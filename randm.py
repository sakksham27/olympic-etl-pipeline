import pandas as pd
import os 
from pathlib import Path 

base_dir = Path(os.getcwd()) / "Data" / "staged" / "Olympic_Athlete_Event_Details_Files"
#print(os.listdir(base_dir))
if('.DS_Store' in os.listdir(base_dir)):
    print("yes")
    os.remove(base_dir/'.DS_Store')
if('.DS_Store' not in os.listdir(base_dir)):
    print("yes it is not in")
