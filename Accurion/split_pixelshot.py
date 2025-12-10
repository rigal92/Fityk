import pandas as pd
import tkinter as tk
import sys 
from tkinter import filedialog

file = sys.argv[1]

df = pd.read_table(file, header=[0,1], encoding="unicode_escape").droplevel(1, axis = 1).rename({"#Lambda":"Lambda", "#AOI":"AOI", "#ROIidx":"ROIidx"}, axis=1)
for l,d in df.groupby("ROIidx"):
    s = d.loc[:,["Lambda", "Delta", "Psi"]]

    # print("---start")
    # for i in s.values:
    print(*d["Lambda"], sep=" ")
    print(*d["Delta"], sep=" ")
    print(*d["Psi"], sep=" ")
    # print("---end")

