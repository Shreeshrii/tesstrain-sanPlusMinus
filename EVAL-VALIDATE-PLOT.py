#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import pandas as pd
import matplotlib.pyplot as plt
import matplotlib
import numpy as np
import argparse

arg_parser = argparse.ArgumentParser(
    '''Creates plot from Training and Evaluation Character Error Rates''')

arg_parser.add_argument('-m', '--model', nargs='?',
                        metavar='MODEL_NAME', help='Model Name', required=True)

arg_parser.add_argument('-v', '--validatelist', nargs='?', metavar='VALIDATIONLIST',
                        help='Validation List', required=True)

args = arg_parser.parse_args()

csvfile = "plot/" + args.model + "-" + args.validatelist + "-plot_cer.csv"
plotfile = "plot/" + args.model + "-" + args.validatelist + "-plot_cer.png"

dataframe = pd.read_csv(csvfile,sep='\t', encoding='utf-8')
dataframe['TrainingIteration'] = dataframe['TrainingIteration'].fillna(-2)
dataframe['TrainingIteration'] = dataframe['TrainingIteration'].astype(int)
dataframe['TrainingIteration'] = dataframe['TrainingIteration'].astype(str)
dataframe['TrainingIteration'] = dataframe['TrainingIteration'].replace('-2', np.nan)

t = dataframe['TrainingIteration']
x = dataframe['LearningIteration']
y = dataframe.IterationCER
c = dataframe.CheckpointCER
e = dataframe.EvalCER
v = dataframe.ValidationCER

maxxlimit=500000 # Use fixed value not auto, so that plots made anytime during training have same scale
minxlimit=None
maxticks=10
ymax = y[np.argmax(y)] # Use to limit y axis to Max IterationCER
cmax = c[np.argmax(c)] # Use to limit y axis to Max CheckpointCER
maxCERtoDisplay=18.5 # Use ymax/cmax, for more detail use 20 or lower
minCERtoDisplay=-1 # Use -5 with ymax/cmax, -1 with 20 or lower

def annot_min(boxcolor, xpos, ypos, x,y):
    xmin = x[np.argmin(y)]
    ymin = y.min()
    boxtext= "{:.3f}% at {:.0f}" .format(ymin,xmin)
    ax1.annotate(boxtext, xy=(xmin, ymin), xytext=(xpos,ypos), textcoords='offset points',
            arrowprops=dict(shrinkA=1, shrinkB=1, fc='black', ec='white', connectionstyle="arc3"),
            bbox=dict(boxstyle='round,pad=0.2', fc=boxcolor, alpha=0.3))

PlotTitle="Tesseract LSTM Training - Model Name = " + args.model + ", Validation List = list." + args.validatelist
fig = plt.figure(figsize=(11,8.5)) #size is in inches
ax1 = fig.add_subplot()

ax1.set_ylim([minCERtoDisplay,maxCERtoDisplay])
ax1.yaxis.set_major_formatter(matplotlib.ticker.ScalarFormatter())
ax1.yaxis.set_major_formatter(matplotlib.ticker.FormatStrFormatter("%.1f"))
ax1.set_ylabel('Character Error Rate %')

ax1.set_xlim([minxlimit,maxxlimit])
ax1.set_xlabel('Learning Iterations')
ax1.set_xticks(x)
ax1.tick_params(axis='x', rotation=45, labelsize='small')
ax1.locator_params(axis='x', nbins=maxticks)  # limit ticks on x-axis
ax1.grid(True)

if not e.dropna().empty: # not NaN or empty
	ax1.plot(x, e, 'magenta')
	ax1.scatter(x, e, c='magenta', s=10, label='Evaluation CER from lstmtraining')
	annot_min('magenta',-0,30,x,e)

ax1.scatter(x, y, s=0.1, c='teal', label='CER every 100 Training Iterations')
ax1.plot(x, y, 'teal', linewidth=0.7)

if not c.dropna().empty: # not NaN or empty
	ax1.scatter(x, c, c='gold', s=10, label='Best Model Checkpoints CER')
	ax1.plot(x, c, 'gold')
	annot_min('gold',-0,-30,x,c)

if not v.dropna().empty: # not NaN or empty
	ax1.plot(x, v, 'maroon')
	ax1.scatter(x, v, c='maroon', s=10, label='Validation CER from lstmeval')
	annot_min('maroon',-0,60,x,v)

plt.title(label=PlotTitle)
plt.legend(loc='upper right')

# Secondary x axis on top to display Training Iterations
ax2 = ax1.twiny() # ax1 and ax2 share y-axis
ax2.set_xlabel("Training Iterations")
ax2.set_xlim(ax1.get_xlim()) # ensure the independant x-axes now span the same range
ax2.set_xticks(x) # copy over the locations of the x-ticks from Learning Iterations
ax2.tick_params(axis='x', rotation=45, labelsize='small')
ax2.set_xticklabels(t) # But give value of Training Iterations
ax2.locator_params(axis='x', nbins=maxticks)  # limit ticks to same as x-axis

plt.savefig(plotfile)