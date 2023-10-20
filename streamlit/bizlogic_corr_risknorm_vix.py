import pandas as pd
import numpy as np


def load_df_riskvix(parquetfile: str = "df_all.parquet"):
    """
    Load df_riskvix
    """
    df_riskvix = pd.read_parquet(parquetfile)

    df_riskvix.index.name = "pubdate"

    return df_riskvix


def load_basel_risknorms(csvfile: str = "risk_mean_basel_risk_norms.csv"):
    """
    Load Basel Risk Norms
    """

    df_basel_risk_norms = pd.read_csv(csvfile)
    lst_BRN_lower = [x.strip().lower() for x in df_basel_risk_norms.source]
    df_basel_risk_norms.index = lst_BRN_lower

    return df_basel_risk_norms


def _get_risk_word_score(text, df_basel_risk_norms, riskword_score_threshold):
    """
    Get risk word score
    """
    if isinstance(text, list) or isinstance(text, np.ndarray):
        lst_positive_score = []
        for x in text:
            score = df_basel_risk_norms.loc[x, "rating"]
            if score > riskword_score_threshold:
                lst_positive_score.append(score)
        if len(lst_positive_score) > 0:
            return sum(lst_positive_score)
    return None


def calculate_risk_score(
    df_riskvix: pd.DataFrame,
    df_basel_risk_norms: pd.DataFrame,
    riskword_score_threshold: int,
):
    """
    Calculate risk score
    """

    df_riskvix["risk_score"] = df_riskvix["risk_word"].apply(
        lambda x: _get_risk_word_score(x, df_basel_risk_norms, riskword_score_threshold)
    )

    return df_riskvix


def generate_ui_df(df_riskvix: pd.DataFrame, target_freq: str = "D"):
    """
    Generate UI dataframe
    """
    df_ui = df_riskvix.dropna().sort_index()
    df_ui = df_ui.groupby("pubdate").agg(
        {"num_words": ["sum", "count"], "risk_score": "sum", "VIXCLS": "mean"}
    )
    df_ui.columns = df_ui.columns.to_flat_index()
    df_ui.columns = ["_".join(col).strip() for col in df_ui.columns.values]
    df_ui.columns = ["risk_score_sum", "news_number", "mean_risk_score", "VIXCLS"]

    df_ui = df_ui.resample(target_freq).sum()
    df_ui = df_ui.reset_index()
    _col = df_ui["mean_risk_score"]

    df_ui["risk_score_scaled"] = round(
        (_col - _col.min()) / (_col.max() - _col.min()), 2
    )
    df_ui["pubdate"] = [x.to_timestamp() for x in df_ui["pubdate"]]

    return df_ui


def calculate_corr(df_ui: pd.DataFrame):
    """
    Calculate correlation
    """
    corr_val = df_ui[["mean_risk_score", "VIXCLS"]].dropna().corr().iloc[0, 1]
    corr_val = corr_val.round(3)

    return corr_val


def convert_diplay_df(df_ui: pd.DataFrame):
    """
    Convert display dataframe
    """
    df_display = df_ui.copy()
    df_display["pubdate"] = df_display["pubdate"].dt.strftime("%Y-%m-%d")
    df_display = df_display.reset_index()

    return df_display[["pubdate", "mean_risk_score", "news_number", "VIXCLS"]]
