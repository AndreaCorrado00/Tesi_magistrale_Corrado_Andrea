clc
clear
close 

%%                                   ---------- DATA REFACTORING ----------
% Data are refactored to be easily used into the matlab framework.

%% 1. Data refactoring 
original_data_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Original";
processed_data_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Processed";

refactoring=false;
if refactoring==true
        refactor_and_save_pop_data(original_data_path,processed_data_path);
        refactor_and_save_data(original_data_path,processed_data_path);
end

%%                                ---------- POPULATION ANALYSIS ----------
clc;clear;close;
% First, population analysis is done on data as they are, so without
% preprocessing, filtering and so on.

% Adding path
src_pop_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\src\Preprocessing_pop_phase";
figure_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Figure\Preprocessing_pop_phase";
addpath(src_pop_path)

% Loading data
fc=2035;
load(processed_data_path+'\dataset_pop.mat');

%% 2.0 Data visualization as they are 
spaghetti_confidence_signals(data,fc,figure_path)

%% 2.1 Signals direct comparisons 
% Comparison between different signals mean/periodogram traces for the same case
compare_case_signals(data,fc,figure_path)   
% Comparison within traces between subjects 
compare_traces_between_sub(data,fc,figure_path) 
% comparison between maps within subjects and traces
compare_maps_between_signals(data,fc,figure_path)


  

%%                           ---------- SINGLE SUBJECTS ANALYSIS ----------
clc;clear;close;
% Now the same analysis/visualizations made for population dataset are made
% subject by subject, to check possible inter subjects differences

% Adding paths
src_pre_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\src\Preprocessing_phase";
figure_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Figure\Preprocessing_phase";
addpath(src_pre_path)

% Loading data 
load(processed_data_path+'\dataset.mat');
fc=2035;

%% 3.0 Data visualization as they are 
spaghetti_confidence_signals(data,fc,figure_path)

%% 3.1 Signals direct comparisons 
% Comparison between different signals mean/periodogram traces for the same case
compare_case_signals(data,fc,figure_path)   
% Comparison within traces between subjects 
compare_traces_between_sub(data,fc,figure_path) 
% comparison between maps within subjects and traces
compare_maps_between_signals(data,fc,figure_path)

%% Subject specific investigations
% 3D plots of the signals, sub by sub
compare_traces_between_sub_3D_figure(data, fc,figure_path) 
% subplots of single records sub by sub
traces_subplots_by_sub(data, fc, figure_path) 
% Checking if and where reference trace is the same as spare 1 trace
display_ref_equal_spare1(data)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESULTS of these first steps are available into <1. risultati data analysis.pptx>%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%%                      ---------- SPECTRUM EVALUATION ALGORITHM ----------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESULTS, explanation and further comments available into <3. in-depth spectrum analysis.pptx>%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;clear;close
% This part of preprocessing is used to build a solid framework into which
% evaluate how to extract correct visualizations of spectrums.

% Because are used syntetic data, it's not necessary to load them

% Adding path
src_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\src\Spectrum_comparison_phase";
addpath(src_path)
%% 4.0 Sintetic data algorithm performances 
close;clc; % cleaning environment
show_spectrum_evaluation_pipeline("Low_frequency_ecg") 

% Other example of situations: 
% "high_frequency_ecg" "Low_frequency_ecg" "PhysioNet_healthy" "PhysioNet_Pathological"
%% 4.1 Spectrum composition
build_and_show_expected_spectrums()





%%                         ---------- TRACES ALIGMENT STRATEGIES ----------

% First, a solid way to align traces should be found record by record and
% subject by subject. 
clc;clear;close;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESULTS, explanation and further comments available into <3. Record alignment by subjects.pptx>%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Adding paths
processed_data_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Processed";
src_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\src\Sub_alignment_analysis_phase";
figure_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Figure\Sub_alignment_analysis";
addpath(src_path)

% Loading previusly made data
load(processed_data_path+'\dataset.mat');
fc=2035;

%% 5.0 Finding QRS into different traces
show_qrs_pos_example=false;
QRS_detected_data=analyzeQRS(data,fc,show_qrs_pos_example,'ref_trace');
QRS_detected_data=analyzeQRS(QRS_detected_data,fc,show_qrs_pos_example,'spare1_trace');
QRS_detected_data=analyzeQRS(QRS_detected_data,fc,show_qrs_pos_example,'spare2_trace');

%% 5.1 Position of QRS analysis
show_QRS_positions(QRS_detected_data,fc)
%% 5.2 Implementing aligment strategies
    % 5.1.1 Strategy 1
    % QRS is sorely into the ref trace
    window=0.01; %time window into which finding the maximum in seconds
    plot_alignment=false;
    Data_sub_aligned_1=single_sub_alignment(QRS_detected_data,fc,window,'only_ref',[],plot_alignment);

    % 5.1.2 Strategy 2
    % QRS is in both ref and spare2 trces but possibly shifted
    window=0.01; %time window into which finding the maximum in seconds
    plot_alignment=false;
    tollerance=0.05; %tollerance in [sec] of distance between QRS points in ref and spare2 traces
    Data_sub_aligned_2=single_sub_alignment(QRS_detected_data,fc,window,'ref_and_spare2',tollerance,plot_alignment);
%%
    % 5.1.3 Strategy 3
    % a real QRS is only into the spare1 trace
    window=0.01; %time window into whitch finding the maximum in seconds
    plot_alignment=false;
    tollerance=0.05; %tollerance in [sec] of distance between QRS points in ref and spare2 traces
    Data_sub_aligned_3=single_sub_alignment(QRS_detected_data,fc,window,'only_spare1',tollerance,plot_alignment);

%% 5.3 Checking and saving results from strategies
    % Strategy 1
traces_subplots_by_sub(Data_sub_aligned_1, fc, figure_path + "\single_records_v1") 
    % Strategy 2
traces_subplots_by_sub(Data_sub_aligned_2, fc, figure_path + "\single_records_v2") 
    % Strategy 3
traces_subplots_by_sub(Data_sub_aligned_3, fc, figure_path + "\single_records_v3")  





%%                     ---------- SCALOGRAM EVALUATION ALGORITHM ----------
clc;clear;close;
% This part of the code is used to build a robust pipeline to evaluate
% scalograms of signals. Before applying it to the AVNRT data, the producer
% will be tested on didactical signals.
src_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\src\Scalogram_analysis_pipeline_phase";
figure_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Figure\Scalogram_analysis_pipeline_phase";
addpath(src_path)

%% 
show_scalogram_evaluation_pipeline("high_frequency_ecg")

% Other example of situations: 
% "high_frequency_ecg" "Low_frequency_ecg" "PhysioNet_healthy" "PhysioNet_Pathological"



