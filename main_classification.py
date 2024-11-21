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
db_number=2
dataset_name = "dataset_"+str(db_number)  # E.g., dataset_1, 2, 3
whole_dataset,signals,y_true,labels_unique,Fs,plot_last_name,fig_final_folder,subtitle_plots = load_dataset(dataset_path, dataset_name)

#%% Checking data
display_data_summary(whole_dataset,labels_unique)

# other types of EDA have been made previously

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

#%%############################################################################
############## KNOWLEDGE BASED CLASSIFIER: first evaluations ##################
###############################################################################
from show_knowledgeBased_on_whole_dataset import show_knowledgeBased_on_whole_dataset
show_knowledgeBased_on_whole_dataset(db_number=2,use_ratio=True)

# this function shows knowledge-based classifier results on dataset with sub 2 
# dropped and using atrial/vventricular ratio

# From now on, once collected these results, two main paths will be followed:
    # 1. Improving knowledge based classifier
    # 2. Building a ML model from scratch 
    

    
