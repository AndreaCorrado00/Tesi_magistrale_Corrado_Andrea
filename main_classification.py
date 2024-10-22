#%% Loading  libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import sys
import sklearn
from scipy.signal import find_peaks
#%% Adding paths
sys.path.append("D:/Desktop/ANDREA/Universita/Magistrale/Anno Accademico 2023-2024/TESI/Tesi_magistrale/src")

#%% Loading data
data=pd.read_csv("D:/Desktop/ANDREA/Universita/Magistrale/Anno Accademico 2023-2024/TESI/Tesi_magistrale/Data/Processed/AVNRT_DB.csv")

Fs=2035; # Fixed value of samplig rate, Hz

# extraction of labels and signals
labels=np.unique(np.array(data['class']))
data=data.drop('class',axis=1)
#%% Checking data
print(data.head)

# data dimensionality
dims=data.shape
print("Number of signals: "+ str(dims[0]))
print("Number of points: "+ str(dims[1]-1))

# classes
    # just to print 
labels_string = ", ".join(labels)
print("Classes: " + labels_string)

# NaN presence is known but:
has_nan=data.isna().any().any()

if has_nan :
    print("Data have NaN points")
    
# other types of EDA have been made previously

#%% Shoving an example of data series

example_class_A=np.array(data.iloc[429])
example_class_B=np.array(data.iloc[800])
example_class_C=np.array(data.iloc[960])

t=np.arange(0,len(example_class_A)/Fs,1/Fs)

plt.figure()
plt.subplot(3,1,1)
plt.plot(t,example_class_A,label="Example of map A")
plt.title('Map A example')
plt.xlabel("Time [s]")
plt.ylabel("[mV]")
plt.xlim(0,1)

plt.subplot(3,1,2)
plt.plot(t,example_class_B,label="Example of map B")
plt.title('Map B example')
plt.xlabel("Time [s]")
plt.ylabel("[mV]")
plt.xlim(0,1)

plt.subplot(3,1,3)
plt.plot(t,example_class_C,label="Example of map C")
plt.title('Map C example')
plt.xlabel("Time [s]")
plt.ylabel("[mV]")
plt.xlim(0,1)

plt.tight_layout()

# %% Stratified train/test split

# %% Building an heuristic classificator

t_atr=0.35;
t_ven=0.45;

atr_ind=round(t_atr*Fs)
ven_ind=round(t_ven*Fs)

atrial_phase=np.abs(example_class_C[0:atr_ind]);
vent_phase=np.abs(example_class_C[ven_ind:]);
his_phase=np.abs(example_class_C[atr_ind:ven_ind]);

# finding peaks
mult_factor=6;
prominence_value=mult_factor*np.std(atrial_phase)
atr_peak,_ =find_peaks(atrial_phase,prominence=prominence_value)

prominence_value=mult_factor*np.std(vent_phase)
vent_peak,_ =find_peaks(vent_phase,prominence=prominence_value)

prominence_value=mult_factor*np.std(his_phase)
his_peak,_ =find_peaks(his_phase,prominence=prominence_value)

# peaks values
his_peak=np.max(his_phase[his_peak])
atr_peak=np.max(atrial_phase[atr_peak])
vent_peak=np.max(vent_phase[vent_peak])

if his_peak.size>0:
    pred_class="MAP_C"
elif atr_peak<=vent_peak:
    pred_class="MAP_B"
elif atr_peak>vent_peak:
        pred_class="MAP_A"
        
print(pred_class)
    
