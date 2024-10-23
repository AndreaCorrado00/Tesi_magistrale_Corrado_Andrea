#%% Loading  libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import sys
from sklearn.metrics import confusion_matrix, ConfusionMatrixDisplay
from sklearn.metrics import classification_report
from sklearn.model_selection import train_test_split

#%% Adding paths, functions and exporting paths

# Path src
sys.path.append("D:/Desktop/ANDREA/Universita/Magistrale/Anno Accademico 2023-2024/TESI/Tesi_magistrale/src/Heuristic_classification_phase")
sys.path.append("D:/Desktop/ANDREA/Universita/Magistrale/Anno Accademico 2023-2024/TESI/Tesi_magistrale/src/Classification_phase")

# Functions
from save_plot import save_plot
from heuristic_classificator import heuristic_classificator
from show_examples import show_examples
from handle_filtered_data import handle_filtered_data
from diplay_data_summary import diplay_data_summary
# Exporting figures
figure_path="D:/Desktop/ANDREA/Universita/Magistrale/Anno Accademico 2023-2024/TESI/Tesi_magistrale/Figure"



#%% Loading data
use_filt_data=False;
# Handling two parralel paths: filtered and not filtered dataset
data,y_true,labels_unique,Fs,plot_last_name,fig_final_folder,subtitle_plots= handle_filtered_data(use_filt_data)

#%% Checking data
diplay_data_summary(data,labels_unique)

# other types of EDA have been made previously

#%% Shoving an example of data series
show_examples(data, Fs, 429,800,960)


# %% Stratified train/test split
# Creiamo un array di indici
indices = np.arange(data.shape[0])

# Split sugli indici con stratify su y
train_idx, test_idx = train_test_split(indices, test_size=0.3, stratify=y_true, random_state=42)

# Test and training 
# X_train, X_test = data[train_idx], data[test_idx]
# y_train, y_test = y_true[train_idx], y_true[test_idx]

# %% Building an heuristic classificator
dims=data.shape
pred_heuristic=np.empty(dims[0], dtype=object)

signal_peaks_and_class=[];
for i in range(0,dims[0]):
    atr_peak,his_peak,vent_peak,pred=heuristic_classificator(data.iloc[i],Fs)
    pred_heuristic[i]=pred
    signal_peaks_and_class.append([atr_peak,his_peak,vent_peak,pred])
    
    
# %% Performance of the heuristic classifier
cm = confusion_matrix(y_true, pred_heuristic)

cm_fig, ax = plt.subplots()  
disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=["MAP_A", "MAP_B", "MAP_C"])
disp.plot(cmap=plt.cm.Blues, ax=ax)
plt.suptitle('Confusion Matrix: Heuristic classificator')
plt.title(subtitle_plots,fontsize=10)

# Report of performance: baseline    
he_report = classification_report(y_true, pred_heuristic, target_names=labels_unique)
print(he_report)
# saving confusion matrix
save_plot(cm_fig,figure_path+"/Heuristic_classification_phase"+fig_final_folder,"CM_heuristic"+plot_last_name)