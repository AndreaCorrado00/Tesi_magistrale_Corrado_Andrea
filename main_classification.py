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
from show_single_example import show_single_example
from handle_filtered_data import handle_filtered_data
from display_data_summary import display_data_summary
from show_class_proportions import show_class_proportions
from tune_prominence_mult_factor import tune_prominence_mult_factor
# Exporting figures
figure_path="D:/Desktop/ANDREA/Universita/Magistrale/Anno Accademico 2023-2024/TESI/Tesi_magistrale/Figure"



#%% Loading data
use_filt_data=False;
# Handling two parralel paths: filtered and not filtered dataset
data,y_true,labels_unique,Fs,plot_last_name,fig_final_folder,subtitle_plots= handle_filtered_data(use_filt_data)

#%% Checking data
display_data_summary(data,labels_unique)

# other types of EDA have been made previously

#%% Shoving an example of data series
show_examples(data, Fs, 429,800,960)


# %% Stratified train/test split
# Maps proportions 
show_class_proportions(y_true,labels_unique)
# array index
indices = np.arange(data.shape[0])

# Split on index
x_train, x_test, y_train, y_test = train_test_split(data,y_true, test_size=0.3, stratify=y_true, random_state=42)

# check if the train/test split is correctly stratified
print("\n---- After stratified train/test split----")
print("Training set")
show_class_proportions(y_train,labels_unique)
print("Test set")
show_class_proportions(y_test,labels_unique)
# %% Tuning prominence multiply factor 
tune_prominence_mult_factor(x_train,y_train,np.array(np.arange(1,15,1)))
save_plot(plt.gcf(),figure_path+"/Heuristic_classification_phase/other_figs","mult_factor_tuning")
# %%  Heuristic classifier: train
dims=x_train.shape
pred_heuristic=np.empty(dims[0], dtype=object)

signal_peaks_and_class_train=[];
for i in range(0,dims[0]):
    atr_peak,his_peak,vent_peak,pred=heuristic_classificator(x_train.iloc[i],Fs,5)
    pred_heuristic[i]=pred
    signal_peaks_and_class_train.append([atr_peak,his_peak,vent_peak,pred])
    
    
# %% Performance of the heuristic classifier: train 
cm = confusion_matrix(y_train, pred_heuristic)

cm_fig, ax = plt.subplots()  
disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=["MAP_A", "MAP_B", "MAP_C"])
disp.plot(cmap=plt.cm.Blues, ax=ax)
plt.suptitle('Confusion Matrix: Heuristic classificator')
plt.title(subtitle_plots+" train set",fontsize=10)

# Report of performance: baseline    
he_report = classification_report(y_train, pred_heuristic, target_names=labels_unique)
print(he_report)
# saving confusion matrix
save_plot(cm_fig,figure_path+"/Heuristic_classification_phase"+fig_final_folder,"CM_heuristic_train"+plot_last_name)

# %% Heuristic classificator: test 
dims=x_test.shape
pred_heuristic=np.empty(dims[0], dtype=object)

signal_peaks_and_class_test=[];
for i in range(0,dims[0]):
    atr_peak,his_peak,vent_peak,pred=heuristic_classificator(x_test.iloc[i],Fs,5)
    pred_heuristic[i]=pred
    signal_peaks_and_class_test.append([atr_peak,his_peak,vent_peak,pred])
    
    
# %% Performance of the heuristic classifier: train 
cm = confusion_matrix(y_test, pred_heuristic)

cm_fig, ax = plt.subplots()  
disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=["MAP_A", "MAP_B", "MAP_C"])
disp.plot(cmap=plt.cm.Blues, ax=ax)
plt.suptitle('Confusion Matrix: Heuristic classificator')
plt.title(subtitle_plots+" test set",fontsize=10)

# Report of performance: baseline    
he_report = classification_report(y_test, pred_heuristic, target_names=labels_unique)
print(he_report)
# saving confusion matrix
save_plot(cm_fig,figure_path+"/Heuristic_classification_phase"+fig_final_folder,"CM_heuristic_test"+plot_last_name)

# %% Showing correct results
# %% Showing some unclear results
show_single_example(x_train, Fs,103, 'MAP A correctly classified as MAP A') 
fig=plt.gcf()
save_plot(fig,figure_path+"/Heuristic_classification_phase/other_figs","ex_correct_class_1")

show_single_example(x_train, Fs,73, 'MAP B correctly classified as MAP B') 
fig=plt.gcf()
save_plot(fig,figure_path+"/Heuristic_classification_phase/other_figs","ex_correct_class_2")

show_single_example(x_train, Fs, 255, 'MAP C correctly classified as MAP C') 
fig=plt.gcf()
save_plot(fig,figure_path+"/Heuristic_classification_phase/other_figs","ex_correct_class_3")

# %% Showing some unclear results
show_single_example(x_train, Fs,2, 'MAP A classified as MAP B') 
fig=plt.gcf()
save_plot(fig,figure_path+"/Heuristic_classification_phase/other_figs","ex_misclass_1")

show_single_example(x_train, Fs,163, 'MAP C classified as MAP B') 
fig=plt.gcf()
save_plot(fig,figure_path+"/Heuristic_classification_phase/other_figs","ex_misclass_2")

show_single_example(x_train, Fs, 199, 'MAP C classified as MAP A') 
fig=plt.gcf()
save_plot(fig,figure_path+"/Heuristic_classification_phase/other_figs","ex_misclass_3")


