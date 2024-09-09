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

% Loading data
fc=2035;
load(processed_data_path+'\dataset_pop.mat');

% Adding path
src_pop_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\src\Preprocessing_pop_phase";
figure_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Figure\Preprocessing_pop_phase";
addpath(src_pop_path)

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
load(processed_data_path+'\dataset.mat');
fc=2035;

% Adding paths
src_pre_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\src\Preprocessing_phase";
figure_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Figure\Preprocessing_phase";
addpath(src_pre_path)

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





%%                           ---------- SPECTRUM EVALUATION ALGORITHM ----------
clc;clear;close
% This part of preprocessing is used to build a solid framework into which
% evaluate how to extract correct visualizations of spectrums.

% Because are used syntetic data, it's not necessary to load them

% Adding path
src_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\src\Spectrum_comparison_phase";
addpath(src_path)
%% Sintetic data algorithm performances 
close;clc; % cleaning environment
show_spectrum_evaluation_pipeline("Low_frequency_ecg") 

% Other example of situations: 
% "high_frequency_ecg" "Low_frequency_ecg" "PhysioNet_healthy" "PhysioNet_Pathological"
%% Spectrum composition
build_and_show_expected_spectrums()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESULTS, explanation and further comments available into <3. in-depth spectrum analysis.pptx>%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%






