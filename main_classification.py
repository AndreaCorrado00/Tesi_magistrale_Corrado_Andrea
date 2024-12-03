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
from display_data_summary import display_data_summary
from show_class_proportions import show_class_proportions
from evaluate_confusion_matrix import evaluate_confusion_matrix
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


#%%############################################################################
################## IMPROVING KNOWLEDGE BASED CLASSIFIER #######################
###############################################################################
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
use_ratio=True
# whole dataset
dims=feature_db.shape
pred_KB_improved=np.empty(dims[0], dtype=object)

signal_peaks_and_class_KB_improved=[];
for i in range(0,dims[0]):
    feature_1_val,peak_3_val,pred=improved_KB_classifier(feature_db.iloc[i],use_ratio)
    pred_KB_improved[i]=pred
    signal_peaks_and_class_KB_improved.append([feature_1_val.item(),peak_3_val.item(),pred])
    
# %% Performance of the heuristic classifier on the whole dataset
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





#%%############################################################################
###################     TREE CLASSIFIER WITH LOPOCV     #######################
###############################################################################
other_fig_path=figure_path+"/Classification_phase/"+fig_final_folder+"/other_figs"

from LOPOCV_decision_tree import LOPOCV_decision_tree
from sklearn.metrics import f1_score
from tune_tree_depth_lopocv import tune_tree_depth_lopocv

#%% CORRELATION ANALYSIS on features
df_corr_analysis=whole_feature_db.drop(["id","class"],axis=1)

categorical_features = [col for col in df_corr_analysis.columns if df_corr_analysis[col].nunique() <=3]
print(f"Categorical features names: {categorical_features}")
df_corr_analysis=df_corr_analysis.drop(categorical_features,axis=1)

# Compute the correlation matrix
correlation_matrix = df_corr_analysis.corr()

# # Plot the correlation matrix as a heatmap
# import seaborn as sns
# cross_features, ax = plt.subplots(figsize=(50, 40))
# sns.heatmap(correlation_matrix, annot=True, fmt=".2f", cmap="coolwarm", 
#             xticklabels=df_corr_analysis.columns, 
#             yticklabels=df_corr_analysis.columns,annot_kws={"size": 25})  
# plt.xticks(fontsize=25)
# plt.yticks(fontsize=25)
# plt.title("Feature Cross-Correlation Matrix")
# plt.show()

# save_plot(cross_features, other_fig_path,file_name='features_cross_corretion_matrix',dpi=500)

# correlated features removal
correlated_features=['env_peak1_pos','env_peak2_pos','env_peak3_pos',
                     'env_peak1_val','env_peak2_val','env_peak3_val','silent_rateo',
                     'cross_peak','cross_peak_pos','corr_energy','vent_corr_energy',
                     'energy_cross_atr_vent_ratio','energy_cross_atr_abs_max_ratio'];

final_column_names = [col for col in whole_feature_db.columns.tolist() if col not in correlated_features]
whole_feature_db=whole_feature_db.drop(correlated_features,axis=1)


# %% FIRST CLASSIFIER: whole dataset
selected_features=whole_feature_db.columns.tolist()

max_depth=tune_tree_depth_lopocv(whole_feature_db,selected_features,np.arange(3,15,dtype=int))
print(f"-> Maximum depth for the tree: {max_depth}")
classifier,all_y_pred, all_y_true, all_predictions_by_subs, selected_feature_db,feature_importances=LOPOCV_decision_tree(whole_feature_db, selected_features,max_depth=max_depth)

# PERFORMANCE
cm_suptitle=f"Confusion Matrix: Tree classifier, depth {max_depth}"
cm_saving_path=os.path.join(figure_path+"/Classification_phase",fig_final_folder)
# Variable saving names
cm_saving_name="CM_whole_tree_LOPOCV"+plot_last_name
cm_title=subtitle_plots+", LOPOCV" 

#confusion matrix
he_report=evaluate_confusion_matrix(all_y_pred,all_y_true,labels_unique,cm_suptitle=cm_suptitle,cm_title=cm_title,save=True, path=cm_saving_path,saving_name=cm_saving_name)
plot_dataframe_as_plain_image(he_report, figsize=(4, 4), scale=(1,1.3),title_plot=cm_title, use_rowLabels=True,path=cm_saving_path,saving_name="report_LOPOCV_whole_tree")

# Features importance: best model tuning
feature_names = selected_feature_db.columns.tolist()

importance_fig,ax=plt.subplots(figsize=(30, 20))
plt.barh(feature_names, feature_importances, color="skyblue")
plt.xlabel("Importance")
plt.title("Feature Importance: whole feature set", fontsize=50)
plt.xticks(fontsize=20)
plt.yticks(fontsize=20)
plt.show()
save_plot(importance_fig, other_fig_path,file_name='whole tree features importance')

f1_macro = f1_score(all_y_pred,all_y_true, average="weighted")
print(f"Global F1-Score (Weighted): {f1_macro:.4f}")

# Summary of misclassification errors
miss_class_summary= misclassification_summary(whole_feature_db[selected_features],all_y_pred, labels_unique)
plot_dataframe_as_plain_image(miss_class_summary, figsize=(8,5),scale=(1.7,1.7),title_plot=cm_title,path=other_fig_path,saving_name="Misclass_LOPOCV_whole_tree")



#%% Second classifier: otimal subset of features
selected_features=['id','peak3_val','peak1_pos','peak2_pos','n_peaks_duration_rateo','atrial_ventricular_ratio','vent_cross_peak','class']

max_depth=tune_tree_depth_lopocv(whole_feature_db,selected_features,np.arange(1,15,dtype=int))
print(f"-> Maximum depth for the tree: {max_depth}")
# lopocv training
classifier,all_y_pred, all_y_true, all_predictions_by_subs, selected_feature_db,feature_importances=LOPOCV_decision_tree(whole_feature_db, selected_features,max_depth=max_depth)

# PERFORMANCE
cm_suptitle=f"Confusion Matrix: Tree classifier,depth {max_depth} on feature subset"
cm_saving_path=os.path.join(figure_path+"/Classification_phase",fig_final_folder)
# Variable saving names
cm_saving_name="CM_opt_tree_LOPOCV_feature_subset"+plot_last_name
cm_title=subtitle_plots+", LOPOCV" 

#confusion matrix
he_report=evaluate_confusion_matrix(all_y_pred,all_y_true,labels_unique,cm_suptitle=cm_suptitle,cm_title=cm_title,save=True, path=cm_saving_path,saving_name=cm_saving_name)
plot_dataframe_as_plain_image(he_report, figsize=(4, 4), scale=(1,1.3),title_plot=cm_title, use_rowLabels=True,path=cm_saving_path,saving_name="report_LOPOCV_tree_feature_subset")

# Features importance
feature_names = selected_feature_db.columns.tolist()

importance_fig,ax=plt.subplots()
plt.barh(feature_names, feature_importances, color="skyblue")
plt.xlabel("Importance")
plt.title("Feature Importance: optimal subset of features")
plt.show()
save_plot(importance_fig, other_fig_path,file_name='optimised tree features importance')

f1_macro = f1_score(all_y_pred,all_y_true, average="weighted")
print(f"Global F1-Score (Weighted): {f1_macro:.4f}")

# Summary of misclassification errors
miss_class_summary= misclassification_summary(whole_feature_db[selected_features],all_y_pred, labels_unique)
plot_dataframe_as_plain_image(miss_class_summary, figsize=(8,5),scale=(1.7,1.7),title_plot=cm_title+", optimised model",path=other_fig_path,saving_name="Misclass_LOPOCV_tree_feature_subset")



#%% Proving that subs 1,3,4,6 worsen the anlysis
selected_features=['id','peak3_val','peak1_pos','peak2_pos','n_peaks_duration_rateo','atrial_ventricular_ratio','vent_cross_peak','class']
sub_feature_db=whole_feature_db[whole_feature_db['id'].isin([7,8,9,10,11,12])]

max_depth=tune_tree_depth_lopocv(whole_feature_db,selected_features,np.arange(1,15,dtype=int))
print(f"-> Maximum depth for the tree: {max_depth}")
# lopocv training
classifier,all_y_pred, all_y_true, all_predictions_by_subs, selected_feature_db,feature_importances=LOPOCV_decision_tree(sub_feature_db, selected_features,max_depth=max_depth)

# PERFORMANCE
cm_suptitle=f"Confusion Matrix: Tree classifier,depth {max_depth} on feature subset and DB subset"
cm_saving_path=os.path.join(figure_path+"/Classification_phase",fig_final_folder)
# Variable saving names
cm_saving_name="CM_opt_tree_LOPOCV_feature_and_DB_subset"+plot_last_name
cm_title=subtitle_plots+", LOPOCV, subs 7->12" 

#confusion matrix
he_report=evaluate_confusion_matrix(all_y_pred,all_y_true,labels_unique,cm_suptitle=cm_suptitle,cm_title=cm_title,save=True, path=cm_saving_path,saving_name=cm_saving_name)
plot_dataframe_as_plain_image(he_report, figsize=(4, 4), scale=(1,1.3),title_plot=cm_title, use_rowLabels=True,path=cm_saving_path,saving_name="report_LOPOCV_tree_subset_features_and_DB")

# Features importance
feature_names = selected_feature_db.columns.tolist()

importance_fig,ax=plt.subplots()
plt.barh(feature_names, feature_importances, color="skyblue")
plt.xlabel("Importance")
plt.title("Feature Importance: subset of patients, optimal subset of features")
plt.show()
save_plot(importance_fig, other_fig_path,file_name='optimised tree features importance reduced db')

f1_macro = f1_score(all_y_pred,all_y_true, average="weighted")
print(f"Global F1-Score (Weighted): {f1_macro:.4f}")

# Summary of misclassification errors
miss_class_summary= misclassification_summary(sub_feature_db[selected_features],all_y_pred, labels_unique)
plot_dataframe_as_plain_image(miss_class_summary, figsize=(8,5),scale=(1.7,1.7),title_plot=cm_title+", optimised model",path=other_fig_path,saving_name="Misclass_LOPOCV_tree_feature_and_DB_subset")



#%%############################################################################
################## TRAIN-TEST SPLIT IMPROVES GENERALIZATION? ################## 
###############################################################################
from sklearn.tree import DecisionTreeClassifier

selected_features=['peak3_val','peak1_pos','peak2_pos','n_peaks_duration_rateo','cross_vent_abs_max_ratio','cross_atr_vent_ratio']
sub_feature_db=whole_feature_db[whole_feature_db['id'].isin([1,3,4,6,7,8,9,10,11,12])]

y_true_sub=sub_feature_db["class"]

sub_feature_db=sub_feature_db.drop(["id","class"],axis=1)

# Split 70-30%
x_train, x_test, y_train, y_test = train_test_split(sub_feature_db[selected_features],y_true_sub, test_size=0.3, stratify=y_true_sub, random_state=42)

# check if the train/test split is correctly stratified
print("\n---- After stratified train/test split----")
print("Training set")
show_class_proportions(y_train,labels_unique)
print("Test set")
show_class_proportions(y_test,labels_unique)

# model evaluation
classifier = DecisionTreeClassifier(criterion="entropy", random_state=42,max_depth=3)

# Train the model on the training data
classifier.fit(x_train, y_train)

# Predict on the test data
y_pred = classifier.predict(x_test)

# PERFORMANCE
cm_suptitle="Confusion Matrix: Tree classifier"
cm_saving_path=os.path.join(figure_path+"/Classification_phase",fig_final_folder)
# Variable saving names
cm_saving_name="CM_train_test_split"+plot_last_name
cm_title=subtitle_plots+", train-test split, whole feature set" 

#confusion matrix
he_report=evaluate_confusion_matrix(y_pred,y_test,labels_unique,cm_suptitle=cm_suptitle,cm_title=cm_title,save=False, path=cm_saving_path,saving_name=cm_saving_name)
#plot_dataframe_as_plain_image(he_report, figsize=(4, 4), scale=(1,1.3),title_plot=cm_title, use_rowLabels=True,path=cm_saving_path,saving_name="report_LOPOCV_tree_subset_features_and_DB")

# the problem are the subjects!!

