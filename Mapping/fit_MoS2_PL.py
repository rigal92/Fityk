from fityk import Fityk
from scipy.stats import linregress
import numpy as np
import os
import matplotlib.pyplot as plt
import re

def define_fitting_functions():
    f.execute("define TrionVoigt(height, center, gwidth=hwhm*0.8, shape=0.1[0:1]) = Voigt(height, center, gwidth, shape)")
    f.execute("define ExcitonVoigt(height, center, gwidth=hwhm*0.8, shape=0.1[0:1]) = Voigt(height, center, gwidth, shape)")

def points_to_arrays(data):
    return np.array([[i.x,i.y] for i in data]).T

# filename = "/home/riccardo/Dev/Fityk/Mapping/temp.fit"
# filename2 = "/home/riccardo/Dev/Fityk/Mapping/temp2.fit"


def get_data(files):
    xs = np.empty((5475,1650))
    ys = np.empty((5475,1650))
    stds = np.empty(5475, dtype = float)
    n = 0

    for file in files:
        print(file)
        f.execute(f"reset; exec '{file}'")
        for i in range(f.get_dataset_count()):
            x, y = points_to_arrays(f.get_data(i))
            xs[i+n]=x
            ys[i+n]=y
            stds[i+n]=y.std()
            # print(y.std())

        n+=f.get_dataset_count()
    return xs, ys, stds

def get_background(xs, ys, out=None):
    """returns the mean value of the parameters of a linear fit on the datasets. If out is 
    given a fityk file can be saved with the name out."""
    def fitAndAdd(i,x,y):
        a,b = np.polyfit(x, y, 1)
        if(out is not None):
            fbg.execute("@+=0")
            fbg.execute(f"use @{i}")
            
            for xi,yi in zip(x, y):
                fbg.add_point(xi, yi, 1.)
            fbg.execute(f"@{i}.F += Linear(slope=~{a}, intercept=~{b})")
        return a,b
    
    fbg=Fityk()
    coeff = np.array([np.array(fitAndAdd(i,x,y)) for i,(x,y) in enumerate(zip(xs,ys))]).T
    if(out is not None):
        fbg.execute(f"info state > '{out}'")
    return c.mean(axis=1), c.std(axis=1)

def fitting(files, linearbg, save=False):
    #center gwidth shape
    initial_Exciton = 596.0457, 115.7862, 1.33781
    initial_Trion = 917.8725, 115.7862, 2.855993

    n = 0
    for file in files:
        f.execute(f"reset; exec '{file}'")
        f.execute(f"set max_wssr_evaluations=100")
        define_fitting_functions()
        for i,in zip(range(f.get_dataset_count())):
            x, y = points_to_arrays(f.get_data(i))
            height_guess = y.max() - 500
            f.execute(f"@{i}.F += Linear({linearbg[0]}, {linearbg[1]})")
            # std <3 is considered background
            if(y.std()>3):
                f.execute(f"@{i}.F += ExcitonVoigt(~{height_guess}, ~{initial_Exciton[0]}, ~{initial_Exciton[1]}, ~{initial_Exciton[2]})")
                gwidth_Exciton = "$" + f.all_functions()[-1].var_name("gwidth")

                if(height_guess>50):
                    f.execute(f"@{i}.F += TrionVoigt(~{871.3157/3}, ~{initial_Trion[0]}, ~{initial_Trion[1]}, ~{initial_Trion[2]})")
                    gwidth_Trion = "$" + f.all_functions()[-1].var_name("gwidth")
                    f.execute(f"{gwidth_Exciton}={gwidth_Trion}")
                print(f"fitting @{i}")
                f.execute(f"@{i}: fit")
        if save:
            fout = file.replace(".fit", "_fitted.fit")
            f.execute(f"info state > '{fout}'")

def hist(y):
    fig, ax = plt.subplots()
    ax.hist(y, bins=200)





if __name__ == '__main__':
    
    f = Fityk()
    files = [i for i in os.listdir() if re.match(r"fit_\d+-\d+.fit",i)]


    # xs, ys, stds = get_data(files)
    # c = get_background(xs[stds<3], ys[stds<3], out=None)

    # hist(ys.max(axis=1))
    # hist(stds)
    # plt.show()
    fitting(["fit_501-1000.fit", "fit_1001-1500.fit", "fit_1501-2000.fit","fit_2501-3000.fit",], (4.95336116e+02, -1.98809807e-03), save=True)
    # fitting(files, (4.95336116e+02, -1.98809807e-03), save=True)


