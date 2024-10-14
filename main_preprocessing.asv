clc
clear
close 

%%                                   ---------- DATA REFACTORING ----------
% Data are refactored to be easily used into the matlab framework.

%% 1. Data refactoring 
original_data_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Original";
processed_data_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Processed";
src_pre_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\src\Preprocessing_phase";
addpath(src_pre_path)

refactoring=true;
if refactoring==true
        refactor_and_save_data(original_data_path,processed_data_path);
end


%%                           ---------- SINGLE SUBJECTS ANALYSIS ----------
clc;clear;close;

% Adding paths
src_pre_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\src\Preprocessing_phase";
figure_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Figure\Preprocessing_phase";
processed_data_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Processed";
addpath(src_pre_path)

% Loading data 
load(processed_data_path+'\dataset.mat');
fc=2035;

%% Preliminar observations
% Are NaN present?
computeNaNPercentages(data)
% Are there some subjects repeated?
display_subjects_repeated(data)
% Are spare1==reference?
display_ref_equal_spare1(data)

%% 3.0 Data visualization as they are 
spaghetti_confidence_signals(data,fc,figure_path)

%% 3.1 Signals direct comparisons 
% Comparison between different signals mean/periodogram traces for the same case
compare_case_signals(data,fc,figure_path)   
% Comparison within traces between subjects 
compare_traces_between_sub(data,fc,figure_path) 
% comparison between maps within subjects and traces
compare_maps_between_signals(data,fc,figure_path)

%% Single records for each subject
% subplots of single records sub by sub
traces_subplots_by_sub(data, fc, figure_path) 






%%                            ---------- PREPROCESSING ALGORITHM ----------

clc;clear;close
% This part of preprocessing is used to build a solid framework into which
% evaluate how to extract correct visualizations of spectrums.

% Because are used syntetic data, it's not necessary to load them

% Adding path
src_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\src\Spectrum_comparison_phase";
addpath(src_path)

%% 4.0 Building a strong preprocessing
% Based on literature, proposed methods are digital filter or DWT
% thresholding plus digital filter. These method will be evaluated using
% didactical examples.
close;clc;close all; % cleaning environment
show_filter_pipeline_syntetic("baseline_drift")

% Other example of situations: 
%baseline_drift white_noise_stationary_var_fix

%% 4.1 Didactical data Preprocessing 
% Preprocessin pipeline is then applied on didactical examples. Then,
% spectrums are evaluated. 
close;clc;close all; % cleaning environment
show_filter_pipeline_didactical("high_frequency_ecg") 

% Other example of situations: 
% "high_frequency_ecg" "Low_frequency_ecg" "PhysioNet_healthy" "PhysioNet_Pathological"





%%               ---------- PREPROCESSING ALGORITHM ON AVNRT DATA----------
% Adding path
src_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\src\Spectrum_comparison_phase";
addpath(src_path)
processed_data_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Processed";
% Loading previusly made data
load(processed_data_path+'\dataset.mat');
fc=2035;
%% 5.1 Preprocessing and Spectrum evaluation algorithm on AVNRT data
% Building examples
MAP_A1_example=data.MAP_A.MAP_A1;
MAP_B1_example=data.MAP_B.MAP_B1;
MAP_C1_example=data.MAP_C.MAP_C8;
    
% Evaluating filtering performance
    show_pipeline_performances(MAP_C1_example)





%%                        ---------- SPECTRUM EVALUATION PIPELINE----------
% Adding path
src_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\src\Spectrum_comparison_phase";
addpath(src_path)
%% 6.1 Spectrum composition
% First, let's make some preliminary observations on the expected spectrum
% shape of a single beat ecg.

build_and_show_expected_spectrums()
% Is this evaluation good? Actually not. In fact, as the ECG is a
% quasi-periodical signal, what is expected is a band-made spectrum with
% many peaks, that's not the situation.
% There are some reasons, on of these is that AR spectrum estimation
% require a stationary signal. 

% Such conclusion can be reached even from the results below

%% 6.2 Spectrum evaluation on didactical examples
show_spectrum_evaluation_pipeline("Low_frequency_ecg")

% Other example of situations: 
% "high_frequency_ecg" "Low_frequency_ecg" "PhysioNet_healthy" "PhysioNet_Pathological"






%%                     ---------- SCALOGRAM EVALUATION ALGORITHM ----------
clc;clear;close;
% This part of the code is used to build a robust pipeline to evaluate
% scalograms of signals. Before applying it to the AVNRT data, the producer
% will be tested on didactical signals.
src_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\src\Scalogram_analysis_pipeline_phase";
figure_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Figure\Scalogram_analysis_pipeline_phase";
addpath(src_path)

%% 8.0 Scalogram evaluation on didactical signals
show_scalogram_evaluation_pipeline("high_frequency_ecg")

% Other example of situations: 
% "high_frequency_ecg" "Low_frequency_ecg" "PhysioNet_healthy" "PhysioNet_Pathological"

%% 8.1 Algorthm application on AVNRT data
processed_data_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Processed";
% Loading previusly made data
load(processed_data_path+'\dataset.mat');
fc=2035;

MAP_A1_example=data.MAP_A.MAP_A7;
MAP_B1_example=data.MAP_B.MAP_B7;
MAP_C1_example=data.MAP_C.MAP_C7;

% Options
filtering=true;
log_scale_visualization=true;

% Application
show_scalogram_AVNRT_data(MAP_A1_example,'Example MAP A, sub 7',filtering,log_scale_visualization)
show_scalogram_AVNRT_data(MAP_B1_example,'Example MAP B, sub 7',filtering,log_scale_visualization)
show_scalogram_AVNRT_data(MAP_C1_example,'Example MAP C, sub 7',filtering,log_scale_visualization)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% More correct comments on the previous parts are summarized into <4. Recap filters-spectrum-alignment> %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%                         ---------- TRACES ALIGMENT STRATEGIES ----------

% Alignment is necessary becouse of different nature of reference traces.
% In fact, as we know, we can divide the dataset into two macro areas: Ref
% with CS signals and Ref with QRS. the idea is pretty simple:
%   1. case ref=CS -> find peak into spare traces
%   2. case ref=QRS -> find peak into ref trace 

% In this part of the code the Fiducial Point (i.e., the maximum of the
% ventricular conduction into rov trace) is found

clc;clear;close;

% Adding paths
processed_data_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Processed";
src_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\src\Sub_alignment_analysis_phase";
figure_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Figure\Sub_alignment_analysis";
addpath(src_path)

% Loading previusly made data
load(processed_data_path+'\dataset.mat');
fc=2035;

%%
% Alignment strategy 
Data_sub_aligned_1 = find_fiducial_point(data, fc, 0.2);

save("D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Processed\dataset_aligned_STR_1.mat", 'Data_sub_aligned_1');

%% old strategy

% 
% %% 7.0 Finding QRS into different traces
% show_qrs_pos_example=false;
% QRS_detected_data=analyzeQRS(data,fc,show_qrs_pos_example,'ref_trace');
% QRS_detected_data=analyzeQRS(QRS_detected_data,fc,show_qrs_pos_example,'spare1_trace');
% QRS_detected_data=analyzeQRS(QRS_detected_data,fc,show_qrs_pos_example,'spare2_trace');
% 
% %% 7.1 Position of QRS analysis
% show_QRS_positions(QRS_detected_data,fc)
% 
% %% 7.2 Implementing aligment strategies
%     % 5.1.1 Strategy 1
%     % QRS is sorely into the ref trace
%     window=0.2; %time window into which finding the maximum in seconds
%     plot_alignment=false;
%     Data_sub_aligned_1=single_sub_alignment(QRS_detected_data,fc,window,'only_ref',[],plot_alignment);
% 
%     % 5.1.2 Strategy 2
%     % QRS is in both ref and spare2 traces but possibly shifted
%     window=0.01; %time window into which finding the maximum in seconds
%     plot_alignment=false;
%     tollerance=0.05; %tollerance in [sec] of distance between QRS points in ref and spare2 traces
%     Data_sub_aligned_2=single_sub_alignment(QRS_detected_data,fc,window,'ref_and_spare2',tollerance,plot_alignment);
% 
%     % 5.1.3 Strategy 3
%     % a real QRS is only into the spare1 trace
%     window=0.2; %time window into whitch finding the maximum in seconds
%     plot_alignment=false;
%     Data_sub_aligned_3=single_sub_alignment(QRS_detected_data,fc,window,'only_spare1',[],plot_alignment);
% 
% %% 7.3 Checking and saving results from strategies
%     % Strategy 1
% traces_subplots_by_sub(Data_sub_aligned_1, fc, figure_path + "\single_records_v1") 
%     % Strategy 2
% traces_subplots_by_sub(Data_sub_aligned_2, fc, figure_path + "\single_records_v2") 
%     % Strategy 3
% traces_subplots_by_sub(Data_sub_aligned_3, fc, figure_path + "\single_records_v3")  




%%                            ---------- WHOLE DATASET ALIGNMENT ----------  
clc;clear;close;
% Here, all rov traces are aligned respect to the same point: 0.5. The
% point of alignment is the fiducial point, i.e., the maximum of the
% ventricular contraction evaluated in phase 5. Different strategies,
% different fiducial points, different results.
processed_data_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Processed";
src_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\src\whole_DB_alignment_and_filter_phase";
figure_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Figure\whole_DB_alignment_and_filter_phase";
addpath(src_path)

% Loading previusly made data
load(processed_data_path+'\dataset_aligned_STR_1.mat');
load(processed_data_path+'\dataset.mat');
fc=2035;

%% 9.1 Whole dataset alignment
Aligned_DB= align_and_filter_dataset(data,Data_sub_aligned_1,false,0.5,fc);

%% 9.2 Showing some examples
show_alignment_results(Aligned_DB,fc)

%% 9.3 Plotting single records results
traces_subplots_by_sub(Aligned_DB, fc, figure_path + "\single_records") 

%% 9.4 Dropping repeated subjects
Aligned_DB.MAP_A=rmfield(Aligned_DB.MAP_A, 'MAP_A5');
Aligned_DB.MAP_B=rmfield(Aligned_DB.MAP_B, 'MAP_B5');
Aligned_DB.MAP_C=rmfield(Aligned_DB.MAP_C, 'MAP_C5');

save("D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Processed\aligned_subjects_DB.mat", 'Aligned_DB');
load(processed_data_path+'\aligned_subjects_DB.mat');
%% 9.5 Building the new_population dataset
POP_DB_aligned=build_pop_dataset_after_alignment(Aligned_DB);







%%                ---------- ALIGNED DATASET POPULATION ANALYSIS ---------- 
clc;clear;close;
% Ppopulation plots are done to summarize. They not intend to be a complete
% and deep representation, but just a quick overview on the data we have.

processed_data_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Processed";
src_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\src\DB_aligned_population_analysis_phase";
figure_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Figure\DB_aligned_population_analysis_phase";
addpath(src_path)

% Loading previusly made data
load(processed_data_path+'\dataset_pop_aligned.mat');
fc=2035;

%% Single record visualization after preprocessing
traces_subplots_by_sub(POP_DB_aligned, fc, figure_path + "\single_records")

%% 8.2 Data visualization as they are 
spaghetti_confidence_signals(POP_DB_aligned,fc,figure_path)

%% 8.3 Signals direct comparisons 
% Comparison between different signals mean traces for the same case
% compare_case_signals(POP_DB_aligned,fc,figure_path)   

% comparison between maps within subjects and traces
compare_maps_between_signals(POP_DB_aligned,fc,figure_path)






