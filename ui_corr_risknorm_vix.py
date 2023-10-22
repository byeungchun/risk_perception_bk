import time
import pandas as pd
import streamlit as st
import altair as alt

from bizlogic_corr_risknorm_vix import (
    load_df_riskvix,
    load_basel_risknorms,
    calculate_risk_score,
    generate_ui_df,
    calculate_corr,
    convert_diplay_df,
)

df_riskvix = load_df_riskvix("df_all.parquet")
df_baselrisknorms = load_basel_risknorms(csvfile="risk_mean_basel_risk_norms.csv")

st.set_page_config(page_title="Risk words & VIX index correlation", layout="wide")

st.title("Risk words & VIX index correlation")
st.write(
    f"""
It provides a table combines risk words, their scores, and the VIX index. Risk words are extracted from news articles using the Basel Risk Norms. The risk score for each word is calculated based on the methodology of Hussain et al. (2023).
To calculate the correlation between risk words and VIX index, please enter the parameters in the sidebar. 

- Basel Risk Norms: Hussain, Z., Mata, R., & Wulff, D. U. (2023, July 27). Novel embeddings improve the prediction of risk perception. https://doi.org/10.31234/osf.io/yrjfb
- Financial news: US financial news articles from Kaggle. https://www.kaggle.com/datasets/jeet2016/us-financial-news-articles
  - Time period (6 months): 2018-01-01 to 2018-05-31
  - Number of news articles: {str(df_riskvix.shape[0])}
- VIX: Volatility index of the S&P 500.

"""
)
# chk_predata = st.checkbox("View Processed data")

with st.sidebar:
    st.subheader("Parameters", divider="rainbow")
    riskword_score_threshold = st.text_input(
        "Risk score cutoff:",
        "",
        placeholder="enter a number between -100 and 100",
        help="Risk words with scores, calculated by Hussain et.al.(2023), above the cutoff will be included in the calculation of risk score.",
    )

    rollup_freq = st.selectbox(
        "Aggregation frequency:", ["D (daily)", "W (Weekly)", "M (Monthly)"],
        help="The frequency to aggregate the risk score and VIX index. For example, if you select 'Weekly', the risk score and VIX index will be aggregated by week."
    )


if riskword_score_threshold == "":
    pass

elif not str(riskword_score_threshold).isnumeric():
    st.error(f"riskword_score_threshold ({riskword_score_threshold}) is not numeric.")

else:
    with st.spinner("Calculating risk score..."):
        riskword_score_threshold = int(riskword_score_threshold)

        df_riskvix = calculate_risk_score(
            df_riskvix, df_baselrisknorms, riskword_score_threshold
        )

        target_freq = rollup_freq.split(" ")[0]
        df_ui = generate_ui_df(df_riskvix, target_freq)

    st.success("Risk score calculated.")

    corr_val = calculate_corr(df_ui)
    st.markdown(f"#### Correlation: {str(corr_val)}")

    cht_base = alt.Chart(df_ui).encode(alt.X("pubdate:T", axis=alt.Axis(title="Date")))

    line_vix = cht_base.mark_line(
        stroke="#57A44C", point=alt.OverlayMarkDef(color="#57A44C")
    ).encode(alt.Y("VIXCLS").title("VIX index"))
    line_riskscore = cht_base.mark_line(
        stroke="#5276A7", point=alt.OverlayMarkDef(color="#5276A7")
    ).encode(alt.Y("risk_score_scaled").title("Risk score"))

    st.altair_chart(
        alt.layer(line_vix, line_riskscore)
        .resolve_scale(y="independent")
        .configure_axisLeft(titleColor="#57A44C")
        .configure_axisRight(titleColor="#5276A7"),
        use_container_width=True,
    )

    st.dataframe(convert_diplay_df(df_ui))

    @st.cache_data
    def convert_df_to_csv(df):
        # IMPORTANT: Cache the conversion to prevent computation on every rerun
        return df.to_csv().encode("utf-8")

    st.download_button(
        label="Download data as CSV",
        data=convert_df_to_csv(df_ui),
        file_name="risk_words_VIX_correlation.csv",
        mime="text/csv",
    )
