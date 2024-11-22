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
sys.path.append("D:/Desktop/ANDREA/Universita/Magistrale/Anno Accademico 2023-2024/TESI/Tesi_magistrale/src/Improved_KB_classifier_phase")

# Functions
from load_signal_dataset import load_signal_dataset
from save_plot import save_plot
from show_single_example import show_single_example
from display_data_summary import display_data_summary
from show_class_proportions import show_class_proportions
from evaluate_confusion_matrix import evaluate_confusion_matrix
from draw_his_boundaries import draw_his_boundaries
from misclassification_summary import misclassification_summary
from plot_dataframe_as_plain_image import plot_dataframe_as_plain_image
from load_feature_dataset import load_feature_dataset
from improved_KB_classifier import improved_KB_classifier
from LOPOCV_KB_improved import LOPOCV_KB_improved
# Exporting figures
figure_path="D:/Desktop/ANDREA/Universita/Magistrale/Anno Accademico 2023-2024/TESI/Tesi_magistrale/Figure"



#%% Loading data
dataset_path = "D:/Desktop/ANDREA/Universita/Magistrale/Anno Accademico 2023-2024/TESI/Tesi_magistrale/Data/Processed/data_aligned" 
db_number=2
dataset_name = "dataset_"+str(db_number)  # E.g., dataset_1, 2, 3
whole_dataset,signals,y_true,labels_unique,Fs,plot_last_name,fig_final_folder,subtitle_plots = load_signal_dataset(dataset_path, dataset_name)

#%% Checking data
display_data_summary(whole_dataset,labels_unique)

# other types of EDA have been made previously

# %% Stratified train/test split
# Maps proportions 
show_class_proportions(y_true,labels_unique)
# array index
indices = np.arange(signals.shape[0])

# # Split on index
# x_train, x_test, y_train, y_test = train_test_split(signals,y_true, test_size=0.3, stratify=y_true, random_state=42)

# # check if the train/test split is correctly stratified
# print("\n---- After stratified train/test split----")
# print("Training set")
# show_class_proportions(y_train,labels_unique)
# print("Test set")
# show_class_proportions(y_test,labels_unique)

#%%############################################################################
############## KNOWLEDGE BASED CLASSIFIER: first evaluations ##################
###############################################################################
show_heuristic=False
if show_heuristic:
    from show_knowledgeBased_on_whole_dataset import show_knowledgeBased_on_whole_dataset
    show_knowledgeBased_on_whole_dataset(db_number=2,use_ratio=True)

# this function shows knowledge-based classifier results on dataset with sub 2 
# dropped and using atrial/vventricular ratio

# Results can be seen into Figure\Heuristic_classification_phase\Final He V2(recap)

# From now on, once collected these results, two main paths will be followed:
    # 1. Improving knowledge based classifier
    # 2. Building a ML model from scratch 


#%% IMPROVING KNOWLEDGE BASED CLASSIFIER

    # 1. two main aspects were critic into the first heuristic classifier:
        # a. time threshold definition
        # b. his peak value
    # 2. feature set will have peaks value and positions. Moreover. by looking at
    #    boxplots, a more robust threshold definition could be done. 
    # 3. the problem is that into this dataset atrial and ventricular phases 
    #    are not explicitly present. 
feature_dataset_name="feature_"+dataset_name
whole_feature_db,feature_db=load_feature_dataset(dataset_path,feature_dataset_name)

other_fig_path=figure_path+"/Improved_KB_classifier_phase/"+fig_final_folder+"/other_figs"
#%% KB classifier will still be based on peaks values, ratios and positions
use_ratio=False
# whole dataset
dims=feature_db.shape
pred_KB_improved=np.empty(dims[0], dtype=object)

signal_peaks_and_class_KB_improved=[];
for i in range(0,dims[0]):
    feature_1_val,peak_3_val,pred=improved_KB_classifier(feature_db.iloc[i],use_ratio)
    pred_KB_improved[i]=pred
    signal_peaks_and_class_KB_improved.append([feature_1_val.item(),peak_3_val.item(),pred])
    
# %% Performance of the heuristic classifier: train 
# Fixed saving names
cm_suptitle="Confusion Matrix: improved KB classifier"
cm_saving_path=os.path.join(figure_path+"/Improved_KB_classifier_phase",fig_final_folder)
# Variable saving names
cm_saving_name="CM_KB_whole"+plot_last_name
cm_title=subtitle_plots+" whole dataset" 
#confusion matrix
he_report=evaluate_confusion_matrix(pred_KB_improved,y_true,labels_unique,cm_suptitle=cm_suptitle,cm_title=cm_title,save=True, path=cm_saving_path,saving_name=cm_saving_name)
plot_dataframe_as_plain_image(he_report, figsize=(4, 4), scale=(1,1.3),title_plot=cm_title, use_rowLabels=True,path=cm_saving_path,saving_name="CM_whole_KB_improved")

#%% LOPOCV validation 
y_true_LOPOCV,y_pred_LOPOCV,signal_peaks_and_class_KB_improved_LOPOCV=LOPOCV_KB_improved(whole_feature_db,use_ratio)
# %% CM 
# Variable saving names
cm_saving_name="CM_heuristic_LOPOCV"+plot_last_name
cm_title=subtitle_plots+" LOPOCV KB improved" 
he_report=evaluate_confusion_matrix(y_pred_LOPOCV,y_true_LOPOCV,labels_unique,cm_suptitle=cm_suptitle,cm_title=cm_title,save=True, path=cm_saving_path,saving_name=cm_saving_name)
plot_dataframe_as_plain_image(he_report, figsize=(4, 4), scale=(1,1.3),title_plot=cm_title, use_rowLabels=True,path=cm_saving_path,saving_name="CM_LOPOCV_KB_improved")

# misclassified per class
miss_class_summary= misclassification_summary(whole_feature_db,y_pred_LOPOCV, labels_unique)
plot_dataframe_as_plain_image(miss_class_summary, figsize=(8,5),scale=(1.7,1.7),title_plot=cm_title,path=other_fig_path,saving_name="Misclass_LOPOCV_KB_improved")


