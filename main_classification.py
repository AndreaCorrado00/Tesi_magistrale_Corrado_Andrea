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
from heuristic_classifier import heuristic_classifier
from heuristic_classifier_B import heuristic_classifier_B
from heuristic_classifier_C import heuristic_classifier_C
from LOPOCV_heuristic_A import LOPOCV_heuristic_A
from LOPOCV_heuristic_B import LOPOCV_heuristic_B
from LOPOCV_heuristic_C import LOPOCV_heuristic_C
from show_examples import show_examples
from show_single_example import show_single_example
from handle_filtered_data import handle_filtered_data
from drop_one_sub import drop_one_sub
from display_data_summary import display_data_summary
from show_class_proportions import show_class_proportions
from tune_prominence_mult_factor import tune_prominence_mult_factor
from tune_his_th import tune_his_th
from tune_his_th_on_f1 import tune_his_th_on_f1
from evaluate_confusion_matrix import evaluate_confusion_matrix
from draw_his_boundaries import draw_his_boundaries
from misclassification_summary import misclassification_summary
# Exporting plt.gcf()ures
figure_path="D:/Desktop/ANDREA/Universita/Magistrale/Anno Accademico 2023-2024/TESI/Tesi_magistrale/Figure"



#%% Loading data
use_filt_data=False;
# Handling two parralel paths: filtered and not filtered dataset
whole_dataset,signals,y_true,labels_unique,Fs,plot_last_name,fig_final_folder,subtitle_plots= handle_filtered_data(use_filt_data)

whole_dataset,y_true,signals,fig_final_folder,subtitle_plots=drop_one_sub(2, whole_dataset,fig_final_folder,subtitle_plots)
#%% Checking data
display_data_summary(signals,labels_unique)

# other types of EDA have been made previously

#%% Shoving an example of data series
show_examples(signals, Fs, 429,800,960)



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
#%% STRATEGY A
# %% Tuning prominence multiply factor 
mult_factor=tune_prominence_mult_factor(x_train,y_train,np.array(np.arange(1,15,1)), True)

save_plot(plt.gcf(),other_fig_path,"mult_factor_tuning")

# %%  Heuristic classifier: train
dims=x_train.shape
pred_heuristic=np.empty(dims[0], dtype=object)

signal_peaks_and_class_train=[];
for i in range(0,dims[0]):
    atr_peak,his_peak,vent_peak,pred=heuristic_classifier(x_train.iloc[i],Fs,mult_factor)
    pred_heuristic[i]=pred
    signal_peaks_and_class_train.append([atr_peak,his_peak,vent_peak,pred])
    
    
# %% Performance of the heuristic classifier: train 
# Fixed saving names
cm_suptitle="Confusion Matrix: Heuristic classifier"
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
    atr_peak,his_peak,vent_peak,pred=heuristic_classifier(x_test.iloc[i],Fs,mult_factor)
    pred_heuristic[i]=pred
    signal_peaks_and_class_test.append([atr_peak,his_peak,vent_peak,pred])
    
    
# %% Performance of the heuristic classifier: train 
cm_saving_name="CM_heuristic_test"+plot_last_name
cm_title=subtitle_plots+" test set" 
#confusion matrix
evaluate_confusion_matrix(pred_heuristic,y_test,labels_unique,cm_suptitle=cm_suptitle,cm_title=cm_title,save=True, path=cm_saving_path,saving_name=cm_saving_name)


# %% Showing correct results
# with sub 2: 6,144,26
# without sub : 0, 188, 116

show_single_example(x_test, Fs,0, 'MAP A correctly classified as MAP A') 
draw_his_boundaries(0.38,0.42,disp_atr_vent_boxes=False) 
save_plot(plt.gcf(),other_fig_path,"ex_correct_class_1")

show_single_example(x_test, Fs,188, 'MAP B correctly classified as MAP B') 
draw_his_boundaries(0.38,0.42,disp_atr_vent_boxes=False) 
save_plot(plt.gcf(),other_fig_path,"ex_correct_class_2")

show_single_example(x_test, Fs, 116, 'MAP C correctly classified as MAP C') 
draw_his_boundaries(0.38,0.42,disp_atr_vent_boxes=False) 
save_plot(plt.gcf(),other_fig_path,"ex_correct_class_3")

# %% Showing some unclear results
# with sub 2: 0,200,94
# without sub 2: 5, 113, 252
show_single_example(x_test, Fs,5, 'MAP A classified as MAP B') 
draw_his_boundaries(0.38,0.42,disp_atr_vent_boxes=False) 

save_plot(plt.gcf(),other_fig_path,"ex_misclass_1")

show_single_example(x_test, Fs,113, 'MAP C classified as MAP B') 
draw_his_boundaries(0.38,0.42,disp_atr_vent_boxes=False) 

save_plot(plt.gcf(),other_fig_path,"ex_misclass_2")

show_single_example(x_test, Fs, 252, 'MAP C classified as MAP A')
draw_his_boundaries(0.38,0.42,disp_atr_vent_boxes=False) 

save_plot(plt.gcf(),other_fig_path,"ex_misclass_3")



###############################################################################
# %% STRATEGY B
# %% Tuning of His Threshold value for strategy B
# F1 score is used to tune the best percentile to be used as threshold
th_his=tune_his_th_on_f1(x_train,y_train,np.arange(0,100,5),t_atr=0.38,t_ven=0.42,plot=True)
save_plot(plt.gcf(),other_fig_path,"his_th_tuning")

tune_his_th(x_train,t_atr=0.38,t_ven=0.42,Q_perc=75,boxplot=True);
save_plot(plt.gcf(),other_fig_path,"his_th_tuning_boxplot")
# %%  Heuristic classifier: train
dims=x_train.shape
pred_heuristic=np.empty(dims[0], dtype=object)

signal_peaks_and_class_train=[];
for i in range(0,dims[0]):
    atr_peak,his_peak,vent_peak,pred=heuristic_classifier_B(x_train.iloc[i],Fs,th_his)
    pred_heuristic[i]=pred
    signal_peaks_and_class_train.append([atr_peak,his_peak,vent_peak,pred])
    
    
# %% Performance of the heuristic classifier: train 
# Fixed saving names
cm_suptitle="Confusion Matrix: Heuristic classifier"
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
    atr_peak,his_peak,vent_peak,pred=heuristic_classifier_B(x_test.iloc[i],Fs,th_his)
    pred_heuristic[i]=pred
    signal_peaks_and_class_test.append([atr_peak,his_peak,vent_peak,pred])
    
    
# %% Performance of the heuristic classifier: train 
cm_saving_name="CM_heuristic_test_B"+plot_last_name
cm_title=subtitle_plots+" test set B" 
#confusion matrix
evaluate_confusion_matrix(pred_heuristic,y_test,labels_unique,cm_suptitle=cm_suptitle,cm_title=cm_title,save=True, path=cm_saving_path,saving_name=cm_saving_name)



#%% Showing correct results
# with sub 2: 2 38 40
# without sub 2: 0, 188,230
show_single_example(x_test, Fs,0, 'MAP A correctly classified as MAP A, strategy B') 
draw_his_boundaries(0.38,0.42,th_his,disp_atr_vent_boxes=False)
save_plot(plt.gcf(),other_fig_path,"ex_correct_class_1_B")

show_single_example(x_test, Fs,188, 'MAP B correctly classified as MAP B, strategy B') 
draw_his_boundaries(0.38,0.42,th_his,disp_atr_vent_boxes=False)
save_plot(plt.gcf(),other_fig_path,"ex_correct_class_2_B")

show_single_example(x_test, Fs, 230, 'MAP C correctly classified as MAP C, strategy B') 
draw_his_boundaries(0.38,0.42,th_his,disp_atr_vent_boxes=False)
save_plot(plt.gcf(),other_fig_path,"ex_correct_class_3_B")

# %% Showing some unclear results
# with sub 2: 1, 117, 290
# without sub 2: 5, 113, 252
show_single_example(x_test, Fs,5, 'MAP A classified as MAP B, strategy B') 
draw_his_boundaries(0.38,0.42,th_his,disp_atr_vent_boxes=False)
save_plot(plt.gcf(),other_fig_path,"ex_misclass_1_B")

show_single_example(x_test, Fs,113, 'MAP C classified as MAP B, strategy B') 
draw_his_boundaries(0.38,0.42,th_his,disp_atr_vent_boxes=False)
save_plot(plt.gcf(),other_fig_path,"ex_misclass_2_B")

show_single_example(x_test, Fs, 252, 'MAP C classified as MAP A, strategy B') 
draw_his_boundaries(0.38,0.42,th_his,disp_atr_vent_boxes=False)
save_plot(plt.gcf(),other_fig_path,"ex_misclass_3_B")



###############################################################################


# %% STRATEGY C
# %% Tuning of His Threshold value is the same as strategy B

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
cm_saving_path=figure_path+"/Heuristic_classification_phase"+fig_final_folder
# Variable saving names
cm_saving_name="CM_heuristic_train_C"+plot_last_name
cm_title=subtitle_plots+" train set C" 
#confusion matrix
evaluate_confusion_matrix(pred_heuristic,y_train,labels_unique,cm_suptitle=cm_suptitle,cm_title=cm_title,save=True, path=cm_saving_path,saving_name=cm_saving_name)


# %% Heuristic classifier: test 
dims=x_test.shape
pred_heuristic=np.empty(dims[0], dtype=object)

signal_peaks_and_class_test=[];
for i in range(0,dims[0]):
    atr_peak,his_peak,vent_peak,pred=heuristic_classifier_C(x_test.iloc[i],Fs,th_his)
    pred_heuristic[i]=pred
    signal_peaks_and_class_test.append([atr_peak,his_peak,vent_peak,pred])
    
    
# %% Performance of the heuristic classifier: train 
cm_saving_name="CM_heuristic_test_C"+plot_last_name
cm_title=subtitle_plots+" test set C" 
#confusion matrix
evaluate_confusion_matrix(pred_heuristic,y_test,labels_unique,cm_suptitle=cm_suptitle,cm_title=cm_title,save=True, path=cm_saving_path,saving_name=cm_saving_name)



#%% Showing correct results
# with sub 2: 19,809,936
# without sub 2: 
show_single_example(x_test, Fs,19, 'MAP A correctly classified as MAP A, strategy C') 
draw_his_boundaries(0.38,0.42,th_his,disp_atr_vent_boxes=True)
save_plot(plt.gcf(),other_fig_path,"ex_correct_class_1_C")

show_single_example(x_test, Fs,188, 'MAP B correctly classified as MAP B, strategy C') 
draw_his_boundaries(0.38,0.42,th_his,disp_atr_vent_boxes=True)
save_plot(plt.gcf(),other_fig_path,"ex_correct_class_2_C")

show_single_example(x_test, Fs, 195, 'MAP C correctly classified as MAP C, strategy C') 
draw_his_boundaries(0.38,0.42,th_his,disp_atr_vent_boxes=True)
save_plot(plt.gcf(),other_fig_path,"ex_correct_class_3_C")

# %% Showing some unclear results
# with sub 2: 107, 937,928
# without sub 2: 5, 113, 252
show_single_example(x_test, Fs,5, 'MAP A classified as MAP B, strategy C') 
draw_his_boundaries(0.38,0.42,th_his,disp_atr_vent_boxes=True)
save_plot(plt.gcf(),other_fig_path,"ex_misclass_1_C")

show_single_example(x_test, Fs,113, 'MAP C classified as MAP B, strategy C') 
draw_his_boundaries(0.38,0.42,th_his,disp_atr_vent_boxes=True)
save_plot(plt.gcf(),other_fig_path,"ex_misclass_2_C")

show_single_example(x_test, Fs, 252, 'MAP C classified as MAP A, strategy C') 
draw_his_boundaries(0.38,0.42,th_his,disp_atr_vent_boxes=True)
save_plot(plt.gcf(),other_fig_path,"ex_misclass_3_C")




#%%############################################################################
######## Heuristic classifier: Leave One Patient Out Cross validation #########
###############################################################################

# STRATEGY A
y_true_LOPOCV,y_pred_LOPOCV,signal_peaks_and_class_train_LOPOCV=LOPOCV_heuristic_A(whole_dataset)


# %% CM 
# Fixed saving names
cm_suptitle="Confusion Matrix: Heuristic classifier"
cm_saving_path=figure_path+"/Heuristic_classification_phase"+fig_final_folder
# Variable saving names
cm_saving_name="CM_heuristic_LOPOCV_A"+plot_last_name
cm_title=subtitle_plots+" LOPOCV, heuristic A" 
evaluate_confusion_matrix(y_pred_LOPOCV,y_true_LOPOCV,labels_unique,cm_suptitle=cm_suptitle,cm_title=cm_title,save=True, path=cm_saving_path,saving_name=cm_saving_name)

miss_class_summary= misclassification_summary(whole_dataset,y_pred_LOPOCV, labels_unique)
#%% Showing correct results
# with sub 2: 169, 130, 229
# without sub 2:  26 860 991 use_iloc=False
show_single_example(signals, Fs,26, 'MAP A correctly classified as MAP A, LOPOCV A',use_iloc=False) 
draw_his_boundaries(0.35,0.45,disp_atr_vent_boxes=True)
save_plot(plt.gcf(),other_fig_path,"ex_LOPOCV_correct_class_1_A")

show_single_example(signals, Fs,860, 'MAP B correctly classified as MAP B, LOPOCV A',use_iloc=False) 
draw_his_boundaries(0.35,0.45,disp_atr_vent_boxes=True)
save_plot(plt.gcf(),other_fig_path,"ex_LOPOCV_correct_class_2_A")

show_single_example(signals, Fs, 991, 'MAP C correctly classified as MAP C, LOPOCV A',use_iloc=False) 
draw_his_boundaries(0.35,0.45,disp_atr_vent_boxes=True)
save_plot(plt.gcf(),other_fig_path,"ex_LOPOCV_correct_class_3_A")

# %% Showing some unclear results
# with sub 2: 1, 937,961
# without sub 2: 1,1008, 704 use_iloc=False
show_single_example(signals, Fs,1, 'MAP A classified as MAP B, LOPOCV A',use_iloc=False) 
draw_his_boundaries(0.35,0.45,disp_atr_vent_boxes=True)
save_plot(plt.gcf(),other_fig_path,"ex_LOPOCV_misclass_1_A")

show_single_example(signals, Fs,1008, 'MAP C classified as MAP B, LOPOCV A',use_iloc=False) 
draw_his_boundaries(0.35,0.45,disp_atr_vent_boxes=True)
save_plot(plt.gcf(),other_fig_path,"ex_LOPOCV_misclass_2_A")

show_single_example(signals, Fs, 704, 'MAP C classified as MAP A, LOPOCV A',use_iloc=False) 
draw_his_boundaries(0.35,0.45,disp_atr_vent_boxes=True)
save_plot(plt.gcf(),other_fig_path,"ex_LOPOCV_misclass_3_A")
###############################################################################


# %% STRATEGY B
y_true_LOPOCV,y_pred_LOPOCV,signal_peaks_and_class_train_LOPOCV=LOPOCV_heuristic_B(whole_dataset)

# %% CM 
# Fixed saving names
cm_suptitle="Confusion Matrix: Heuristic classifier"
cm_saving_path=figure_path+"/Heuristic_classification_phase"+fig_final_folder
# Variable saving names
cm_saving_name="CM_heuristic_LOPOCV_B"+plot_last_name
cm_title=subtitle_plots+" LOPOCV, heuristic B" 
evaluate_confusion_matrix(y_pred_LOPOCV,y_true_LOPOCV,labels_unique,cm_suptitle=cm_suptitle,cm_title=cm_title,save=True, path=cm_saving_path,saving_name=cm_saving_name)

miss_class_summary= misclassification_summary(whole_dataset,y_pred_LOPOCV, labels_unique)
#%% Showing correct results
# with sub 2: 19, 809, 936
# without sub 2: (53,53)(800,101,933,936)()
show_single_example(signals, Fs,53, 'MAP A correctly classified as MAP A, LOPOCV B',use_iloc=False) 
draw_his_boundaries(0.38,0.42,signal_peaks_and_class_train_LOPOCV[53][6],disp_atr_vent_boxes=False)
save_plot(plt.gcf(),other_fig_path,"ex_LOPOCV_correct_class_1_B")

show_single_example(signals, Fs,800, 'MAP B correctly classified as MAP B, LOPOCV B',use_iloc=False) 
draw_his_boundaries(0.38,0.42,signal_peaks_and_class_train_LOPOCV[101][6],disp_atr_vent_boxes=False)
save_plot(plt.gcf(),other_fig_path,"ex_LOPOCV_correct_class_2_B")

show_single_example(signals, Fs, 933, 'MAP C correctly classified as MAP C, LOPOCV B',use_iloc=False) 
draw_his_boundaries(0.38,0.42,signal_peaks_and_class_train_LOPOCV[936][6],disp_atr_vent_boxes=False)
save_plot(plt.gcf(),other_fig_path,"ex_LOPOCV_correct_class_3_B")

# %% Showing some unclear results
# with sub 2: 107, 937, 928
# without sub 2: (0,0) (999,813)(961,461)
show_single_example(signals, Fs,0, 'MAP A classified as MAP B, LOPOCV B',use_iloc=False) 
draw_his_boundaries(0.38,0.42,signal_peaks_and_class_train_LOPOCV[0][6],disp_atr_vent_boxes=False)
save_plot(plt.gcf(),other_fig_path,"ex_LOPOCV_misclass_1_B")

show_single_example(signals, Fs,999, 'MAP C classified as MAP B, LOPOCV C',use_iloc=False) 
draw_his_boundaries(0.38,0.42,signal_peaks_and_class_train_LOPOCV[813][6],disp_atr_vent_boxes=False)
save_plot(plt.gcf(),other_fig_path,"ex_LOPOCV_misclass_2_B")

show_single_example(signals, Fs, 961, 'MAP C classified as MAP A, LOPOCV B',use_iloc=False) 
draw_his_boundaries(0.38,0.42,signal_peaks_and_class_train_LOPOCV[461][6],disp_atr_vent_boxes=False)
save_plot(plt.gcf(),other_fig_path,"ex_LOPOCV_misclass_3_B")
###############################################################################


# %% STRATEGY C


y_true_LOPOCV,y_pred_LOPOCV,signal_peaks_and_class_train_LOPOCV=LOPOCV_heuristic_C(whole_dataset)

# %% CM 
# Fixed saving names
cm_suptitle="Confusion Matrix: Heuristic classifier"
cm_saving_path=figure_path+"/Heuristic_classification_phase"+fig_final_folder
# Variable saving names
cm_saving_name="CM_heuristic_LOPOCV_C"+plot_last_name
cm_title=subtitle_plots+" LOPOCV, heuristic C" 
evaluate_confusion_matrix(y_pred_LOPOCV,y_true_LOPOCV,labels_unique,cm_suptitle=cm_suptitle,cm_title=cm_title,save=True, path=cm_saving_path,saving_name=cm_saving_name)

miss_class_summary= misclassification_summary(whole_dataset,y_pred_LOPOCV, labels_unique)
#%% Showing correct results
# with sub 2: 19, 809, 936
# without sub 2: (19,19) (841,432) (968, 468) 
show_single_example(signals, Fs,19, 'MAP A correctly classified as MAP A, LOPOCV C',use_iloc=False) 
draw_his_boundaries(0.38,0.42,signal_peaks_and_class_train_LOPOCV[19][6],disp_atr_vent_boxes=True)
save_plot(plt.gcf(),other_fig_path,"ex_LOPOCV_correct_class_1_C")

show_single_example(signals, Fs,841, 'MAP B correctly classified as MAP B, LOPOCV C',use_iloc=False) 
draw_his_boundaries(0.38,0.42,signal_peaks_and_class_train_LOPOCV[432][6],disp_atr_vent_boxes=True)
save_plot(plt.gcf(),other_fig_path,"ex_LOPOCV_correct_class_2_C")

show_single_example(signals, Fs, 968, 'MAP C correctly classified as MAP C, LOPOCV C',use_iloc=False) 
draw_his_boundaries(0.38,0.42,signal_peaks_and_class_train_LOPOCV[468][6],disp_atr_vent_boxes=True)
save_plot(plt.gcf(),other_fig_path,"ex_LOPOCV_correct_class_3_C")

# %% Showing some unclear results
# with sub 2: 107, 937, 928
# without sub 2: 
show_single_example(signals, Fs,0, 'MAP A classified as MAP B, LOPOCV C',use_iloc=False) 
draw_his_boundaries(0.38,0.42,signal_peaks_and_class_train_LOPOCV[0][6],disp_atr_vent_boxes=True)
save_plot(plt.gcf(),other_fig_path,"ex_LOPOCV_misclass_1_C")

show_single_example(signals, Fs,833, 'MAP C classified as MAP B, LOPOCV C',use_iloc=False) 
draw_his_boundaries(0.38,0.42,signal_peaks_and_class_train_LOPOCV[214][6],disp_atr_vent_boxes=True)
save_plot(plt.gcf(),other_fig_path,"ex_LOPOCV_misclass_2_C")

show_single_example(signals, Fs, 938, 'MAP C classified as MAP A, LOPOCV C',use_iloc=False) 
draw_his_boundaries(0.38,0.42,signal_peaks_and_class_train_LOPOCV[225][6],disp_atr_vent_boxes=True)
save_plot(plt.gcf(),other_fig_path,"ex_LOPOCV_misclass_3_C")

# SE E' GIUSTO, AGGIORNA LE LOPOCV FUNCTIONS DELLE ALTRE STRATEGIE

# %%
show_single_example(signals, Fs,49, 'MAP A classified as MAP A without using atrial th') 
draw_his_boundaries(0.38,0.42,signal_peaks_and_class_train_LOPOCV[49][6],disp_atr_vent_boxes=True)

save_plot(plt.gcf(),other_fig_path,"ex_no_atr_th_LOPOCV_C")
