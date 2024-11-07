#%% Loading  libraries
import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import sys
from sklearn.model_selection import train_test_split

#%% Adding paths, functions and exporting paths

# Path src
sys.path.append("D:/Desktop/ANDREA/Universita/Magistrale/Anno Accademico 2023-2024/TESI/Tesi_magistrale/src/Heuristic_classification_phase")
sys.path.append("D:/Desktop/ANDREA/Universita/Magistrale/Anno Accademico 2023-2024/TESI/Tesi_magistrale/src/Classification_phase")

# Functions
from load_dataset import load_dataset
from save_plot import save_plot
from heuristic_classifier_C import heuristic_classifier_C
from LOPOCV_heuristic_C import LOPOCV_heuristic_C
from show_examples import show_examples
from show_single_example import show_single_example
from display_data_summary import display_data_summary
from show_class_proportions import show_class_proportions
from tune_his_th import tune_his_th
from tune_his_th_on_f1 import tune_his_th_on_f1
from evaluate_confusion_matrix import evaluate_confusion_matrix
from draw_his_boundaries import draw_his_boundaries
from misclassification_summary import misclassification_summary
from plot_dataframe_as_plain_image import plot_dataframe_as_plain_image
# Exporting figures
figure_path="D:/Desktop/ANDREA/Universita/Magistrale/Anno Accademico 2023-2024/TESI/Tesi_magistrale/Figure"



#%% Loading data
dataset_path = "D:/Desktop/ANDREA/Universita/Magistrale/Anno Accademico 2023-2024/TESI/Tesi_magistrale/Data/Processed/data_aligned" 
db_number=3
dataset_name = "dataset_"+str(db_number)  # E.g., dataset_1, 2, 3
whole_dataset,signals,y_true,labels_unique,Fs,plot_last_name,fig_final_folder,subtitle_plots = load_dataset(dataset_path, dataset_name)

#%% Checking data
display_data_summary(whole_dataset,labels_unique)

# other types of EDA have been made previously

#%% Shoving an example of data series
#show_examples(signals, Fs, 429,800,960)

# %% Stratified train/test split
# Maps proportions 
show_class_proportions(y_true,labels_unique)
# array index
indices = np.arange(signals.shape[0])

# Split on index
x_train, x_test, y_train, y_test = train_test_split(signals,y_true, test_size=0.3, stratify=y_true, random_state=42)

# check if the train/test split is correctly stratified
print("\n---- After stratified train/test split----")
print("Training set")
show_class_proportions(y_train,labels_unique)
print("Test set")
show_class_proportions(y_test,labels_unique)


#%%###########################################################################
################# BUILDING AN HEURISTIC CLASSIFIER PHASE #####################
##############################################################################
other_fig_path=figure_path+"/Heuristic_classification_phase/"+fig_final_folder+"/other_figs"

# %% Example signals positions
train_test_examples= pd.DataFrame({
    "db 1 c" : [96,106,164],
    "db 1 m": [0,13, 198],
    "db 2 c" : [3,40,13],
    "db 2 m": [1,130, 42],
    "db 3 c" : [0,53,169],
    "db 3 m": [1, 56, 145]
    })

LOPOCV_examples=pd.DataFrame({
        "db 1 c" : [56,227,293,0,0],
        "db 1 m": [2,296,297,890,872],
        "db 2 c" : [56,193,228,0,0],
        "db 2 m": [2,881,444,817,801]
        })

# %% Tuning of His Threshold value for strategy B
# F1 score is used to tune the best percentile to be used as threshold
th_his=tune_his_th_on_f1(x_train,y_train,np.arange(0,100,5),t_atr=0.38,t_ven=0.42,plot=True)
save_plot(plt.gcf(),other_fig_path,"his_th_tuning")

tune_his_th(x_train,t_atr=0.38,t_ven=0.42,Q_perc=75,boxplot=True);
save_plot(plt.gcf(),other_fig_path,"his_th_tuning_boxplot")

# %% STRATEGY C
# %%  Heuristic classifier: train
dims=x_train.shape
pred_heuristic=np.empty(dims[0], dtype=object)

signal_peaks_and_class_train=[];
for i in range(0,dims[0]):
    atr_peak,his_peak,vent_peak,pred=heuristic_classifier_C(x_train.iloc[i],Fs,th_his)
    pred_heuristic[i]=pred
    signal_peaks_and_class_train.append([atr_peak,his_peak,vent_peak,pred])
    
    
# %% Performance of the heuristic classifier: train 
# Fixed saving names
cm_suptitle="Confusion Matrix: Heuristic classifier"
cm_saving_path=os.path.join(figure_path+"/Heuristic_classification_phase",fig_final_folder)
# Variable saving names
cm_saving_name="CM_heuristic_train"+plot_last_name
cm_title=subtitle_plots+" train set" 
#confusion matrix
he_report=evaluate_confusion_matrix(pred_heuristic,y_train,labels_unique,cm_suptitle=cm_suptitle,cm_title=cm_title,save=True, path=cm_saving_path,saving_name=cm_saving_name)
plot_dataframe_as_plain_image(he_report, figsize=(4, 4), scale=(1,1.3),title_plot=cm_title, use_rowLabels=True,path=cm_saving_path,saving_name="report_train_C")

# %% Heuristic classifier: test 
dims=x_test.shape
pred_heuristic=np.empty(dims[0], dtype=object)

signal_peaks_and_class_test=[];
for i in range(0,dims[0]):
    atr_peak,his_peak,vent_peak,pred=heuristic_classifier_C(x_test.iloc[i],Fs,th_his)
    pred_heuristic[i]=pred
    signal_peaks_and_class_test.append([atr_peak,his_peak,vent_peak,pred])
    
    
# %% Performance of the heuristic classifier: train 
cm_saving_name="CM_heuristic_test"+plot_last_name
cm_title=subtitle_plots+" test set" 
#confusion matrix
he_report=evaluate_confusion_matrix(pred_heuristic,y_test,labels_unique,cm_suptitle=cm_suptitle,cm_title=cm_title,save=True, path=cm_saving_path,saving_name=cm_saving_name)

plot_dataframe_as_plain_image(he_report, figsize=(4, 4), scale=(1,1.3),title_plot=cm_title, use_rowLabels=True,path=cm_saving_path,saving_name="report_test_C")

#%% Showing correct results
col=f"db {db_number} c"
show_single_example(x_test, Fs,train_test_examples[col][0], 'MAP A correctly classified as MAP A, strategy C') 
draw_his_boundaries(0.38,0.42,th_his,disp_atr_vent_boxes=True)
save_plot(plt.gcf(),other_fig_path,"ex_correct_class_1_C")

show_single_example(x_test, Fs,train_test_examples[col][1], 'MAP B correctly classified as MAP B, strategy C') 
draw_his_boundaries(0.38,0.42,th_his,disp_atr_vent_boxes=True)
save_plot(plt.gcf(),other_fig_path,"ex_correct_class_2_C")

show_single_example(x_test, Fs, train_test_examples[col][2], 'MAP C correctly classified as MAP C, strategy C') 
draw_his_boundaries(0.38,0.42,th_his,disp_atr_vent_boxes=True)
save_plot(plt.gcf(),other_fig_path,"ex_correct_class_3_C")

# %% Showing some unclear results
col=f"db {db_number} m"
show_single_example(x_test, Fs, train_test_examples[col][0], 'MAP A classified as MAP B, strategy C') 
draw_his_boundaries(0.38,0.42,th_his,disp_atr_vent_boxes=True)
save_plot(plt.gcf(),other_fig_path,"ex_misclass_1_C")

show_single_example(x_test, Fs,train_test_examples[col][1], 'MAP C classified as MAP B, strategy C') 
draw_his_boundaries(0.38,0.42,th_his,disp_atr_vent_boxes=True)
save_plot(plt.gcf(),other_fig_path,"ex_misclass_2_C")

show_single_example(x_test, Fs,train_test_examples[col][2], 'MAP C classified as MAP A, strategy C') 
draw_his_boundaries(0.38,0.42,th_his,disp_atr_vent_boxes=True)
save_plot(plt.gcf(),other_fig_path,"ex_misclass_3_C")



#%%############################################################################
######## Heuristic classifier: Leave One Patient Out Cross validation #########
###############################################################################

# %% STRATEGY C
if dataset_name!="dataset_3":
    y_true_LOPOCV,y_pred_LOPOCV,signal_peaks_and_class_train_LOPOCV=LOPOCV_heuristic_C(whole_dataset)
    
    # %% CM 
    # Fixed saving names
    cm_suptitle="Confusion Matrix: Heuristic classifier"
    cm_saving_path=os.path.join(figure_path+"/Heuristic_classification_phase",fig_final_folder)
    # Variable saving names
    cm_saving_name="CM_heuristic_LOPOCV"+plot_last_name
    cm_title=subtitle_plots+" LOPOCV, heuristic" 
    he_report=evaluate_confusion_matrix(y_pred_LOPOCV,y_true_LOPOCV,labels_unique,cm_suptitle=cm_suptitle,cm_title=cm_title,save=True, path=cm_saving_path,saving_name=cm_saving_name)
    plot_dataframe_as_plain_image(he_report, figsize=(4, 4), scale=(1,1.3),title_plot=cm_title, use_rowLabels=True,path=cm_saving_path,saving_name="report_LOPOCV_C")
    
    # misclassified per class
    miss_class_summary= misclassification_summary(whole_dataset,y_pred_LOPOCV, labels_unique)
    plot_dataframe_as_plain_image(miss_class_summary, figsize=(8,5),scale=(1.7,1.7),title_plot=cm_title,path=other_fig_path,saving_name="Misclass_LOPOCV_C")

    #%% Showing correct results
    col=f"db {db_number} c"
    show_single_example(signals, Fs,LOPOCV_examples[col][0], 'MAP A correctly classified as MAP A, LOPOCV C',use_iloc=False) 
    draw_his_boundaries(0.38,0.42,signal_peaks_and_class_train_LOPOCV[LOPOCV_examples[col][0]][6],disp_atr_vent_boxes=True)
    save_plot(plt.gcf(),other_fig_path,"ex_LOPOCV_correct_class_1_C")
    
    show_single_example(signals, Fs,LOPOCV_examples[col][1], 'MAP B correctly classified as MAP B, LOPOCV C',use_iloc=False) 
    draw_his_boundaries(0.38,0.42,signal_peaks_and_class_train_LOPOCV[LOPOCV_examples[col][1]][6],disp_atr_vent_boxes=True)
    save_plot(plt.gcf(),other_fig_path,"ex_LOPOCV_correct_class_2_C")
    
    show_single_example(signals, Fs, LOPOCV_examples[col][2], 'MAP C correctly classified as MAP C, LOPOCV C',use_iloc=False) 
    draw_his_boundaries(0.38,0.42,signal_peaks_and_class_train_LOPOCV[LOPOCV_examples[col][2]][6],disp_atr_vent_boxes=True)
    save_plot(plt.gcf(),other_fig_path,"ex_LOPOCV_correct_class_3_C")
    
    # %% Showing some unclear results
    col=f"db {db_number} m"
    show_single_example(signals, Fs,LOPOCV_examples[col][0], 'MAP A classified as MAP B, LOPOCV C',use_iloc=False) 
    draw_his_boundaries(0.38,0.42,signal_peaks_and_class_train_LOPOCV[LOPOCV_examples[col][0]][6],disp_atr_vent_boxes=True)
    save_plot(plt.gcf(),other_fig_path,"ex_LOPOCV_misclass_1_C")
    
    show_single_example(signals, Fs,LOPOCV_examples[col][1], 'MAP C classified as MAP B, LOPOCV C',use_iloc=False) 
    draw_his_boundaries(0.38,0.42,signal_peaks_and_class_train_LOPOCV[LOPOCV_examples[col][1]][6],disp_atr_vent_boxes=True)
    save_plot(plt.gcf(),other_fig_path,"ex_LOPOCV_misclass_2_C")
    
    show_single_example(signals, Fs, LOPOCV_examples[col][2], 'MAP C classified as MAP A, LOPOCV C',use_iloc=False) 
    draw_his_boundaries(0.38,0.42,signal_peaks_and_class_train_LOPOCV[LOPOCV_examples[col][2]][6],disp_atr_vent_boxes=True)
    save_plot(plt.gcf(),other_fig_path,"ex_LOPOCV_misclass_3_C")
    
    show_single_example(signals, Fs, LOPOCV_examples[col][3], 'MAP B classified as MAP C, LOPOCV C',use_iloc=False) 
    draw_his_boundaries(0.38,0.42,signal_peaks_and_class_train_LOPOCV[LOPOCV_examples[col][3]][6],disp_atr_vent_boxes=True)
    save_plot(plt.gcf(),other_fig_path,"ex_LOPOCV_misclass_4_C")
    
    show_single_example(signals, Fs, LOPOCV_examples[col][4], 'MAP A classified as MAP C, LOPOCV C',use_iloc=False) 
    draw_his_boundaries(0.38,0.42,signal_peaks_and_class_train_LOPOCV[LOPOCV_examples[col][4]][4],disp_atr_vent_boxes=True)
    save_plot(plt.gcf(),other_fig_path,"ex_LOPOCV_misclass_5_C")
    
    
    #%%
else:print("Unable to perform LOPOCV")

#%% Peaks distribution: are they discriminative?
# NB:
atrial_peaks=[]
his_peaks=[]
vent_peaks=[]

# combining train and test set
for i in range(0,len(signal_peaks_and_class_train)):
    atrial_peaks.append(signal_peaks_and_class_train[i][0])
    his_peaks.append(signal_peaks_and_class_train[i][1])
    vent_peaks.append(signal_peaks_and_class_train[i][2])
    
for i in range(0,len(signal_peaks_and_class_test)):
    atrial_peaks.append(signal_peaks_and_class_test[i][0])
    his_peaks.append(signal_peaks_and_class_test[i][1])
    vent_peaks.append(signal_peaks_and_class_test[i][2])

atr_vent_ratio=np.array(atrial_peaks)/np.array(vent_peaks)
    
signals_peaks=pd.DataFrame({
    "atrial_peaks": atrial_peaks,
    "his_peaks": his_peaks,
    "vent_peaks": vent_peaks,
    "atr_vent_ratio":atr_vent_ratio,
    "class": np.concatenate((y_train,y_test), axis=0)
    })

from compare_feature_by_classes import compare_feature_by_classes
# %%
compare_feature_by_classes(signals_peaks,"atrial_peaks")
save_plot(plt.gcf(),other_fig_path,"atrial_peaks_boxplots")

compare_feature_by_classes(signals_peaks,"his_peaks")
save_plot(plt.gcf(),other_fig_path,"his_peaks_boxplots")

compare_feature_by_classes(signals_peaks,"vent_peaks")
save_plot(plt.gcf(),other_fig_path,"vent_peaks_boxplots")

#%% 
compare_feature_by_classes(signals_peaks,"atr_vent_ratio")
save_plot(plt.gcf(),other_fig_path,"atr_vent_ratio_boxplots")