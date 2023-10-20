import altair as alt
import pandas as pd
import streamlit as st
from vega_datasets import data

source = data.seattle_weather()

base = alt.Chart(source).encode(alt.X("month(date):T").axis(title=None))

area = base.mark_area(opacity=0.3, color="#57A44C").encode(
    alt.Y("average(temp_max)").title("Avg. Temperature (°C)", titleColor="#57A44C"),
    alt.Y2("average(temp_min)"),
)

line = base.mark_point(stroke="#5276A7", interpolate="monotone").encode(
    alt.Y("average(precipitation)").title(
        "Precipitation (inches)", titleColor="#5276A7"
    )
)

line2 = base.mark_point(stroke="#57A44C", interpolate="monotone").encode(
    alt.Y("average(temp_max)", scale=alt.Scale(domain=[0, 100])).title(
        "Precipitation (inches)", titleColor="#57A44C"
    )
)


st.altair_chart(alt.layer(line, line2).resolve_scale(y="independent"))

# temps = data.seattle_temps()
# temps = temps[temps.date.dt.hour == 10]

# startDate = pd.to_datetime("2010-06-01")
# endDate = pd.to_datetime("2010-06-30")
# myScale = alt.Scale(domain=[startDate, endDate])

# c = (
#     alt.Chart(temps)
#     .mark_line(clip=True)
#     .encode(x=alt.X("temp:T", scale=myScale), y="temp:Q")
# )
# st.altair_chart(c)
