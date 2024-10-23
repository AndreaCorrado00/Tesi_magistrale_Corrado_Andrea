#%% Loading  libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import sys
from sklearn.metrics import confusion_matrix, ConfusionMatrixDisplay
from sklearn.metrics import classification_report

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
use_filt_data=True;
# Handling two parralel paths: filtered and not filtered dataset
data,y_true,labels_unique,Fs,plot_last_name,fig_final_folder,subtitle_plots= handle_filtered_data(use_filt_data)

#%% Checking data
diplay_data_summary(data,labels_unique)

# other types of EDA have been made previously

#%% Shoving an example of data series
show_examples(data, Fs, 429,800,960)


# %% Stratified train/test split


# %% Building an heuristic classificator
dims=data.shape
pred_heuristic=np.empty(dims[0], dtype=object)

for i in range(0,dims[0]):
    pred=heuristic_classificator(data.iloc[i],Fs)
    pred_heuristic[i]=pred
    
# %% Performance of the heuristic classifier
cm = confusion_matrix(y_true, pred_heuristic)

cm_fig, ax = plt.subplots()  
disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=["MAP_A", "MAP_B", "MAP_C"])
disp.plot(cmap=plt.cm.Blues, ax=ax)
plt.suptitle('Confusion Matrix: Heuristic classificator')
plt.title(subtitle_plots)

# Report of performance: baseline    
he_report = classification_report(y_true, pred_heuristic, target_names=labels_unique)
print(he_report)
# saving confusion matrix
save_plot(cm_fig,figure_path+"/Heuristic_classification_phase"+fig_final_folder,"CM_heuristic"+plot_last_name)