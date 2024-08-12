clc
clear
close

%%                                                  PUBLIC DATABESE FOR SPECTRUM EVALUATION
% The aim of this code is investigating if the behavior found into the
% reference trace is acceptable and in case if it's related to some
% patologies. To do it, it's used (part of) the database MIT-BIH arrythmia
% database. 

% Specifica la cartella contenente i dati del MIT-BIH Arrhythmia Database
dataFolder = "D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Other\mit-bih-arrhythmia-database-1.0.0";
src_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\src\Spectrum_comparison_phase";
figure_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Figure\Spectrum_investigation_phase";
addpath(src_path)


%% Handling the dataset
% To make the dataset more handable, it is converted into a struct
MIT_dataset_builder(dataFolder);

%% Loading data
load("D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Other\MIT_dataset.mat")
%% Example of data
plot_example(MIT_data)
% there is clear noise into the signals, they must be processed before
% proceeding.
% To do it,a low pass filter between [0-50] Hz is used and the mean is elimaneted 


%% Cleaning the whole dataset 
MIT_data_cleaned=filter_signals(MIT_data);
plot_example(MIT_data_cleaned)

figure(1)
plot_example(MIT_data)
hold on
plot_example(MIT_data_cleaned)
title('RAW vs Cleaned example')
hold off

%%                                                       DATASET REBUILDING
% Instead of considering 30 min of acquisition, for each subject are
% extracted random records with a length of some seconds. In this way I'll
% reach a good number of examples

record_duration= 10; %sec
num_records=100; % for each sub
min_overlap_ratio=0.1; % 10% of overlap allowed 

MIT_data_divided = extract_random_segments_struct(MIT_data_cleaned, record_duration, num_records, min_overlap_ratio);

% Showing the number of records reached
disp(['There are: ',num2str(length(fieldnames(MIT_data_divided))*num_records), ' records'])

% Showing an example of record
plot_record_example(MIT_data_divided,record_duration)

%% Spectral analysis 
plotting_signals(MIT_data_divided,figure_path,"freq_mean_sd",true,false) 









