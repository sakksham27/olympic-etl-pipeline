import pandas as pd
import math
from pathlib import Path
import os
import psycopg2


# --- CONFIG ---
csv_path = Path(os.getcwd()) / "Data" / "raw" / "Olympic_Athlete_Event_Details.csv"
expected_columns = 11


conn = psycopg2.connect(
    host = 'localhost',
    user ='postgres',
    password = 'postgres',
    port = '5432',
    database = 'Olympic_Data_Warehouse'
)
curr = conn.cursor()

df = pd.read_csv(Path(os.getcwd())/"Data"/"raw"/"olympic_athlete_event_details.csv")
row = df.values.tolist()
import math

row = [None if (isinstance(x, float) and math.isnan(x)) else x for x in row]
insert_query = """
INSERT INTO bronze.Olympic_Athlete_Event_Details (
    edition, edition_id, country_noc, sport, event,
    result_id, athlete, athlete_id, pos, medal, isTeamSport
) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);
"""

curr.executemany(insert_query, row)
conn.commit()
