#%% Loading  libraries
import numpy as np
import matplotlib.pyplot as plt
import sys
from sklearn.model_selection import train_test_split

#%% Adding paths, functions and exporting paths

# Path src
sys.path.append("D:/Desktop/ANDREA/Universita/Magistrale/Anno Accademico 2023-2024/TESI/Tesi_magistrale/src/Heuristic_classification_phase")
sys.path.append("D:/Desktop/ANDREA/Universita/Magistrale/Anno Accademico 2023-2024/TESI/Tesi_magistrale/src/Classification_phase")

# Functions
from save_plot import save_plot
from heuristic_classificator import heuristic_classificator
from heuristic_classificator_B import heuristic_classificator_B
from show_examples import show_examples
from show_single_example import show_single_example
from handle_filtered_data import handle_filtered_data
from display_data_summary import display_data_summary
from show_class_proportions import show_class_proportions
from tune_prominence_mult_factor import tune_prominence_mult_factor
from tune_his_th import tune_his_th
from tune_his_th_on_f1 import tune_his_th_on_f1
from evaluate_confusion_matrix import evaluate_confusion_matrix
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


#%%###########################################################################
################# BUILDING AN HEURISTIC CLASSIFIER PHASE #####################
##############################################################################
#%% STRATEGY A
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
# Fixed saving names
cm_suptitle="Confusion Matrix: Heuristic classificator"
cm_saving_path=figure_path+"/Heuristic_classification_phase"+fig_final_folder
# Variable saving names
cm_saving_name="CM_heuristic_train"+plot_last_name
cm_title=subtitle_plots+" train set" 
#confusion matrix
evaluate_confusion_matrix(pred_heuristic,y_train,labels_unique,cm_suptitle=cm_suptitle,cm_title=cm_title,save=True, path=cm_saving_path,saving_name=cm_saving_name)


# %% Heuristic classifier: test 
dims=x_test.shape
pred_heuristic=np.empty(dims[0], dtype=object)

signal_peaks_and_class_test=[];
for i in range(0,dims[0]):
    atr_peak,his_peak,vent_peak,pred=heuristic_classificator(x_test.iloc[i],Fs,5)
    pred_heuristic[i]=pred
    signal_peaks_and_class_test.append([atr_peak,his_peak,vent_peak,pred])
    
    
# %% Performance of the heuristic classifier: train 
cm_saving_name="CM_heuristic_test"+plot_last_name
cm_title=subtitle_plots+" test set" 
#confusion matrix
evaluate_confusion_matrix(pred_heuristic,y_test,labels_unique,cm_suptitle=cm_suptitle,cm_title=cm_title,save=True, path=cm_saving_path,saving_name=cm_saving_name)


# %% Showing correct results
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




# %% STRATEGY B
# %% Tuning of His Threshold value for strategy B
# F1 score is used to tune the best percentile to be used as threshold
tune_his_th_on_f1(x_train,y_train,np.arange(0,100,5),t_atr=0.38,t_ven=0.42)

# then the threshold is fixed
th_his=tune_his_th(x_train,t_atr=0.38,t_ven=0.42,Q_perc=55,boxplot=True)
# %%  Heuristic classifier: train
dims=x_train.shape
pred_heuristic=np.empty(dims[0], dtype=object)

signal_peaks_and_class_train=[];
for i in range(0,dims[0]):
    atr_peak,his_peak,vent_peak,pred=heuristic_classificator_B(x_train.iloc[i],Fs,th_his)
    pred_heuristic[i]=pred
    signal_peaks_and_class_train.append([atr_peak,his_peak,vent_peak,pred])
    
    
# %% Performance of the heuristic classifier: train 
# Fixed saving names
cm_suptitle="Confusion Matrix: Heuristic classificator"
cm_saving_path=figure_path+"/Heuristic_classification_phase"+fig_final_folder
# Variable saving names
cm_saving_name="CM_heuristic_train_B"+plot_last_name
cm_title=subtitle_plots+" train set B" 
#confusion matrix
evaluate_confusion_matrix(pred_heuristic,y_train,labels_unique,cm_suptitle=cm_suptitle,cm_title=cm_title,save=True, path=cm_saving_path,saving_name=cm_saving_name)


# %% Heuristic classifier: test 
dims=x_test.shape
pred_heuristic=np.empty(dims[0], dtype=object)

signal_peaks_and_class_test=[];
for i in range(0,dims[0]):
    atr_peak,his_peak,vent_peak,pred=heuristic_classificator_B(x_test.iloc[i],Fs,th_his)
    pred_heuristic[i]=pred
    signal_peaks_and_class_test.append([atr_peak,his_peak,vent_peak,pred])
    
    
# %% Performance of the heuristic classifier: train 
cm_saving_name="CM_heuristic_test_B"+plot_last_name
cm_title=subtitle_plots+" test set B" 
#confusion matrix
evaluate_confusion_matrix(pred_heuristic,y_test,labels_unique,cm_suptitle=cm_suptitle,cm_title=cm_title,save=True, path=cm_saving_path,saving_name=cm_saving_name)



# %% Showing correct results
# show_single_example(x_train, Fs,103, 'MAP A correctly classified as MAP A') 
# fig=plt.gcf()
# save_plot(fig,figure_path+"/Heuristic_classification_phase/other_figs","ex_correct_class_1")

# show_single_example(x_train, Fs,73, 'MAP B correctly classified as MAP B') 
# fig=plt.gcf()
# save_plot(fig,figure_path+"/Heuristic_classification_phase/other_figs","ex_correct_class_2")

# show_single_example(x_train, Fs, 255, 'MAP C correctly classified as MAP C') 
# fig=plt.gcf()
# save_plot(fig,figure_path+"/Heuristic_classification_phase/other_figs","ex_correct_class_3")

# # %% Showing some unclear results
# show_single_example(x_train, Fs,2, 'MAP A classified as MAP B') 
# fig=plt.gcf()
# save_plot(fig,figure_path+"/Heuristic_classification_phase/other_figs","ex_misclass_1")

# show_single_example(x_train, Fs,163, 'MAP C classified as MAP B') 
# fig=plt.gcf()
# save_plot(fig,figure_path+"/Heuristic_classification_phase/other_figs","ex_misclass_2")

# show_single_example(x_train, Fs, 199, 'MAP C classified as MAP A') 
# fig=plt.gcf()
# save_plot(fig,figure_path+"/Heuristic_classification_phase/other_figs","ex_misclass_3")

