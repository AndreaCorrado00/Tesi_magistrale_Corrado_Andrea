#%% Loading  libraries
import os
import numpy as np
import sys

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
from show_SHAP_analysis import show_SHAP_analysis
# Exporting figures
figure_path="D:/Desktop/ANDREA/Universita/Magistrale/Anno Accademico 2023-2024/TESI/Tesi_magistrale/Figure"



#%% Loading data
dataset_path = "D:/Desktop/ANDREA/Universita/Magistrale/Anno Accademico 2023-2024/TESI/Tesi_magistrale/Data/Processed/data_aligned" 
db_number=2
dataset_name = "dataset_"+str(db_number)  # E.g., dataset_1, 2, 3
whole_dataset,signals,y_true,labels_unique,Fs,plot_last_name,fig_final_folder,subtitle_plots = load_signal_dataset(dataset_path, dataset_name)

feature_dataset_name="feature_"+dataset_name
whole_feature_db,feature_db=load_feature_dataset(dataset_path,feature_dataset_name)
#%% Checking data
display_data_summary(whole_feature_db,labels_unique)

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
# Variable saving 
cm_saving_name="CM_heuristic_LOPOCV"+plot_last_name
cm_title=subtitle_plots+" LOPOCV KB improved" 
he_report=evaluate_confusion_matrix(y_pred_LOPOCV,y_true_LOPOCV,labels_unique,cm_suptitle=cm_suptitle,cm_title=cm_title,save=True, path=cm_saving_path,saving_name=cm_saving_name)
plot_dataframe_as_plain_image(he_report, figsize=(4, 4), scale=(1,1.3),title_plot=cm_title, use_rowLabels=True,path=cm_saving_path,saving_name="CM_LOPOCV_KB_improved")

# misclassified per class
miss_class_summary= misclassification_summary(whole_feature_db,y_pred_LOPOCV, labels_unique)
plot_dataframe_as_plain_image(miss_class_summary, figsize=(8,5),scale=(1.7,1.7),title_plot=cm_title,path=other_fig_path,saving_name="Misclass_LOPOCV_KB_improved")




#%%############################################################################
#################     CORRELATION ANALYSIS ON FEATURES     ####################
###############################################################################
other_fig_path=figure_path+"/Classification_phase/"+fig_final_folder+"/other_figs"


#%% Correlation analysis on features
df_corr_analysis=whole_feature_db.drop(["id","class"],axis=1)

categorical_features = [col for col in df_corr_analysis.columns if df_corr_analysis[col].nunique() <=5]
print(f"Categorical features names: {categorical_features}")
df_corr_analysis=df_corr_analysis.drop(categorical_features,axis=1)

# Compute the correlation matrix
correlation_matrix = df_corr_analysis.corr()

# Plot the correlation matrix as a heatmap
# import seaborn as sns
# import matplotlib.pyplot as plt
# cross_features, ax = plt.subplots(figsize=(80, 60))
# sns.heatmap(correlation_matrix, annot=True, fmt=".2f", cmap="coolwarm", 
#             xticklabels=df_corr_analysis.columns, 
#             yticklabels=df_corr_analysis.columns,annot_kws={"size": 25})  
# plt.xticks(fontsize=25)
# plt.yticks(fontsize=25)
# plt.title("Feature Cross-Correlation Matrix")
# plt.show()


# save_plot(cross_features, other_fig_path,file_name='features_cross_corretion_matrix',dpi=500)

#%% correlated features removal
correlated_features=['Dominant_peak_env', 'Dominant_peak_env_time', 'Subdominant_peak_env',
'Subdominant_peak_env_time', 'Minor_peak_env', 'Minor_peak_env_time',
'First_peak_env','First_peak_env_time', 'Second_peak_env', 'Second_peak_env_time',
'Third_peak_env', 'Third_peak_env_time','silent_phase',
'cross_energy_TM1','cross_peak_TM2', 'cross_energy_TM2',
 'Dominant_AvgPowMF',
 'Subdominant_AvgPowLF','Subdominant_AvgPowMF',
 'Minor_AvgPowLF','Minor_AvgPowMF',
 'First_AvgPowMF',
 'Second_AvgPowLF', 'Second_AvgPowMF',
 'Third_AvgPowLF', 'Third_AvgPowMF',
];

 
final_column_names = [col for col in whole_feature_db.columns.tolist() if col not in correlated_features]
whole_feature_db=whole_feature_db.drop(correlated_features,axis=1)





#%%############################################################################
###################     TREE CLASSIFIER WITH LOPOCV     #######################
###############################################################################

from LOPOCV_decision_tree import LOPOCV_decision_tree
from analyse_feature_importance import analyse_feature_importance
# %% FIRST CLASSIFIER: whole dataset
selected_features=whole_feature_db.columns.tolist()

classifier,all_y_pred, all_y_true, all_predictions_by_subs,feature_importance=LOPOCV_decision_tree(whole_feature_db, selected_features)

# PERFORMANCE
cm_suptitle="Confusion Matrix: Tree classifier, whole feature set"
cm_saving_path=os.path.join(figure_path+"/Classification_phase",fig_final_folder)
# Variable saving names
cm_saving_name="CM_whole_tree_LOPOCV"+plot_last_name
cm_title=subtitle_plots+", LOPOCV" 

#confusion matrix
he_report=evaluate_confusion_matrix(all_y_pred,all_y_true,labels_unique,cm_suptitle=cm_suptitle,cm_title=cm_title,save=True, path=cm_saving_path,saving_name=cm_saving_name)
plot_dataframe_as_plain_image(he_report, figsize=(4, 4), scale=(1,1.3),title_plot=cm_title, use_rowLabels=True,path=cm_saving_path,saving_name="report_LOPOCV_whole_tree")

# Summary of misclassification errors
miss_class_summary= misclassification_summary(whole_feature_db[selected_features],all_y_pred, labels_unique)
plot_dataframe_as_plain_image(miss_class_summary, figsize=(8,5),scale=(1.7,1.7),title_plot=cm_title,path=other_fig_path,saving_name="Misclass_LOPOCV_whole_tree")

#%% Features importance: best model tuning

selected_features=analyse_feature_importance(feature_importance,th=0.008,plot_title="Feature Importance: whole set of features",file_name='tree_whole_feature_importance',other_fig_path=other_fig_path,saving_plot=True)

# SHAP analysis
show_SHAP_analysis(whole_feature_db,selected_features,saving_path=other_fig_path,other_comments="whole_feature_set")

#%% SECOND CLASSIFIER: otimal subset of features
# lopocv training
classifier,all_y_pred, all_y_true, all_predictions_by_subs,feature_importance=LOPOCV_decision_tree(whole_feature_db, selected_features)

# PERFORMANCE
cm_suptitle="Confusion Matrix: Tree classifier, optimal feature subset"
cm_saving_path=os.path.join(figure_path+"/Classification_phase",fig_final_folder)
# Variable saving names
cm_saving_name="CM_opt_tree_LOPOCV_feature_subset"+plot_last_name
cm_title=subtitle_plots+", LOPOCV" 

#confusion matrix
he_report=evaluate_confusion_matrix(all_y_pred,all_y_true,labels_unique,cm_suptitle=cm_suptitle,cm_title=cm_title,save=True, path=cm_saving_path,saving_name=cm_saving_name)
plot_dataframe_as_plain_image(he_report, figsize=(4, 4), scale=(1,1.3),title_plot=cm_title, use_rowLabels=True,path=cm_saving_path,saving_name="report_LOPOCV_tree_feature_subset")

# Summary of misclassification errors
miss_class_summary= misclassification_summary(whole_feature_db[selected_features],all_y_pred, labels_unique)
plot_dataframe_as_plain_image(miss_class_summary, figsize=(8,5),scale=(1.7,1.7),title_plot=cm_title+", optimised model",path=other_fig_path,saving_name="Misclass_LOPOCV_tree_feature_subset")


#%% Features importance
analyse_feature_importance(feature_importance,th=0.008,plot_title="Feature Importance: reduced set of features",file_name='tree_optimal_feature_importance',other_fig_path=other_fig_path,saving_plot=True)
# SHAP analysis
show_SHAP_analysis(whole_feature_db,selected_features,saving_path=other_fig_path,other_comments="optimal_feature_set")





#%%############################################################################
###################     SVM CLASSIFIER WITH LOPOCV     ########################
###############################################################################
from impute_scale_dataset import impute_scale_dataset
from LOPOCV_SVM import LOPOCV_SVM
from analyse_feature_importance import analyse_feature_importance 

#%% Data preparation: imputation and Min-Max scaling
whole_feature_db_imp_scal=impute_scale_dataset(whole_feature_db)

#%% SVM LOPOCV training: variable kernel
selected_features=whole_feature_db_imp_scal.columns.tolist()
kernel_types={"Linear":"linear","Polynomial":"poly","Gaussian":"rbf"}
for kernel_full_name,kernel in kernel_types.items():
    classifier, all_y_pred, all_y_true, all_predictions_by_subs,feature_importance=LOPOCV_SVM(whole_feature_db_imp_scal,selected_features,kernel_type=kernel)

    # PERFORMANCE
    cm_suptitle="Confusion Matrix: SVM model, whole feature set"
    cm_saving_path=os.path.join(figure_path+"/Classification_phase",fig_final_folder)
    # Variable saving names
    cm_saving_name="CM_SVM_whole_LOPOCV"+plot_last_name+"_"+kernel_full_name
    cm_title=subtitle_plots+f", LOPOCV, {kernel_full_name} kernel" 

    #confusion matrix
    he_report=evaluate_confusion_matrix(all_y_pred,all_y_true,labels_unique,cm_suptitle=cm_suptitle,cm_title=cm_title,save=True, path=cm_saving_path,saving_name=cm_saving_name)
    plot_dataframe_as_plain_image(he_report, figsize=(4, 4), scale=(1,1.3),title_plot=cm_title, use_rowLabels=True,path=cm_saving_path,saving_name="report_LOPOCV_SVM_whole_"+kernel_full_name)

#%% Feature importance analysis
# The best model in terms of perfomance is used to evaluate feature importance

best_kernel="Gaussian"
classifier, all_y_pred, all_y_true, all_predictions_by_subs,feature_importance=LOPOCV_SVM(whole_feature_db_imp_scal,selected_features,kernel_type=kernel_types[best_kernel])

selected_features=analyse_feature_importance(feature_importance,th=0.008,plot_title="Feature Importance: whole set of features",file_name='SVM_whole_feature_importance',other_fig_path=other_fig_path,saving_plot=True)


#%% final optimised model
classifier, all_y_pred, all_y_true, all_predictions_by_subs,feature_importance=LOPOCV_SVM(whole_feature_db_imp_scal,selected_features,kernel_type=kernel_types[best_kernel])

# PERFORMANCE
cm_suptitle="Confusion Matrix: SVM model, optimal feature subset"
cm_saving_path=os.path.join(figure_path+"/Classification_phase",fig_final_folder)
# Variable saving names
cm_saving_name="CM_SVM_opt_feature_set_LOPOCV"+plot_last_name+"_"+kernel
cm_title=subtitle_plots+f", LOPOCV,  {best_kernel} kernel" 

#confusion matrix
he_report=evaluate_confusion_matrix(all_y_pred,all_y_true,labels_unique,cm_suptitle=cm_suptitle,cm_title=cm_title,save=True, path=cm_saving_path,saving_name=cm_saving_name)
plot_dataframe_as_plain_image(he_report, figsize=(4, 4), scale=(1,1.3),title_plot=cm_title, use_rowLabels=True,path=cm_saving_path,saving_name="report_LOPOCV_SVM_opt_feature_set_"+best_kernel)

#%% Feature importance analysis
analyse_feature_importance(feature_importance,th=0.008,plot_title="Feature Importance: reduced set of features",file_name='SVM_optimal_feature_importance',other_fig_path=other_fig_path,saving_plot=True)



#%%############################################################################
############     MULTINOMIAL LOGISTIC REGRESSION WITH LOPOCV    ###############
###############################################################################

from impute_scale_dataset import impute_scale_dataset
from LOPOCV_LogisticRegression import LOPOCV_LogisticRegression
from analyse_feature_importance import analyse_feature_importance 

#%% Data preparation: imputation and Min-Max scaling
whole_feature_db_imp_scal=impute_scale_dataset(whole_feature_db)

#%% MLR LOPOCV training: whole dataset
selected_features=whole_feature_db_imp_scal.columns.tolist()
# whole dataset analysis
classifier, all_y_pred, all_y_true, all_predictions_by_subs, feature_importance=LOPOCV_LogisticRegression(whole_feature_db_imp_scal,selected_features)

# PERFORMANCE
cm_suptitle="Confusion Matrix: MLR model, whole feature set"
cm_saving_path=os.path.join(figure_path+"/Classification_phase",fig_final_folder)
# Variable saving names
cm_saving_name="CM_GLM_MLR_whole_LOPOCV"+plot_last_name
cm_title=subtitle_plots+", LOPOCV, multinomial logistic model" 

#confusion matrix
he_report=evaluate_confusion_matrix(all_y_pred,all_y_true,labels_unique,cm_suptitle=cm_suptitle,cm_title=cm_title,save=True, path=cm_saving_path,saving_name=cm_saving_name)
plot_dataframe_as_plain_image(he_report, figsize=(4, 4), scale=(1,1.3),title_plot=cm_title, use_rowLabels=True,path=cm_saving_path,saving_name="report_GLM_MLR_whole")

#%% Feature importance
selected_features=analyse_feature_importance(feature_importance,th=0.008,plot_title="Feature Importance: whole set of features",file_name='GLM_whole_feature_importance',other_fig_path=other_fig_path,saving_plot=True)

#%% MLR LOPOCV training: optimal dataset
# whole dataset analysis
classifier, all_y_pred, all_y_true, all_predictions_by_subs, feature_importance=LOPOCV_LogisticRegression(whole_feature_db_imp_scal,selected_features)

# PERFORMANCE
cm_suptitle="Confusion Matrix: MLR model, optimal feature set"
cm_saving_path=os.path.join(figure_path+"/Classification_phase",fig_final_folder)
# Variable saving names
cm_saving_name="CM_GLM_MLR_opt_LOPOCV"+plot_last_name
cm_title=subtitle_plots+", LOPOCV, multinomial logistic model" 

#confusion matrix
he_report=evaluate_confusion_matrix(all_y_pred,all_y_true,labels_unique,cm_suptitle=cm_suptitle,cm_title=cm_title,save=True, path=cm_saving_path,saving_name=cm_saving_name)
plot_dataframe_as_plain_image(he_report, figsize=(4, 4), scale=(1,1.3),title_plot=cm_title, use_rowLabels=True,path=cm_saving_path,saving_name="report_GLM_MLR_opt")

#%% Feature importance
analyse_feature_importance(feature_importance,th=0.008,plot_title="Feature Importance: reduced set of features",file_name='GLM_optimal_feature_importance',other_fig_path=other_fig_path,saving_plot=True)





# #%%############################################################################
# ################     RANDOM FOREST CLASSIFIER WITH LOPOCV    ##################
# ###############################################################################

# from LOPOCV_RandomForest import LOPOCV_RandomForest
# from analyse_feature_importance import analyse_feature_importance 


# #%% MLR LOPOCV training: whole dataset
# selected_features=whole_feature_db.columns.tolist()
# # whole dataset analysis
# classifier, all_y_pred, all_y_true, all_predictions_by_subs, feature_importance=LOPOCV_RandomForest(whole_feature_db,selected_features,forest_size=300,max_depth=6)

# # PERFORMANCE
# cm_suptitle="Confusion Matrix: RF model, whole feature set"
# cm_saving_path=os.path.join(figure_path+"/Classification_phase",fig_final_folder)
# # Variable saving names
# cm_saving_name="CM_RF_whole_LOPOCV"+plot_last_name
# cm_title=subtitle_plots+", LOPOCV, random forest model" 

# #confusion matrix
# he_report=evaluate_confusion_matrix(all_y_pred,all_y_true,labels_unique,cm_suptitle=cm_suptitle,cm_title=cm_title,save=True, path=cm_saving_path,saving_name=cm_saving_name)
# plot_dataframe_as_plain_image(he_report, figsize=(4, 4), scale=(1,1.3),title_plot=cm_title, use_rowLabels=True,path=cm_saving_path,saving_name="report_RF_whole")

# #%% Feature importance
# selected_features=analyse_feature_importance(feature_importance,th=0.008,file_name='RF_whole_feature_importance',other_fig_path=other_fig_path,saving_plot=True)

# #%% MLR LOPOCV training: optimal dataset
# # whole dataset analysis
# classifier, all_y_pred, all_y_true, all_predictions_by_subs, feature_importance=LOPOCV_RandomForest(whole_feature_db,selected_features,forest_size=300,max_depth=6)

# # PERFORMANCE
# cm_suptitle="Confusion Matrix: RF model, optimal feature set"
# cm_saving_path=os.path.join(figure_path+"/Classification_phase",fig_final_folder)
# # Variable saving names
# cm_saving_name="CM_RF_opt_LOPOCV"+plot_last_name
# cm_title=subtitle_plots+", LOPOCV, random forest model" 

# #confusion matrix
# he_report=evaluate_confusion_matrix(all_y_pred,all_y_true,labels_unique,cm_suptitle=cm_suptitle,cm_title=cm_title,save=True, path=cm_saving_path,saving_name=cm_saving_name)
# plot_dataframe_as_plain_image(he_report, figsize=(4, 4), scale=(1,1.3),title_plot=cm_title, use_rowLabels=True,path=cm_saving_path,saving_name="report_RF_opt")

# #%% Feature importance
# analyse_feature_importance(feature_importance,th=0.008,file_name='RF_optimal_feature_importance',other_fig_path=other_fig_path,saving_plot=True)

























