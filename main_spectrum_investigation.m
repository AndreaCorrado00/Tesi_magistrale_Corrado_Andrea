clc
clear
close

%%                                                  PUBLIC DATABESE FOR SPECTRUM EVALUATION
% The aim of this code is investigating if the behavior found into the
% reference trace is acceptable and in case if it's related to some
% patologies. To do it, it's used (part of) the database MIT-BIH arrythmia
% database. 

% dataFolder = "D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Other\mit-bih-arrhythmia-database-1.0.0";
% src_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\src\Spectrum_comparison_phase";
% figure_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Figure\Spectrum_investigation_phase";
% addpath(src_path)


% %% Handling the dataset
% % To make the dataset more handable, it is converted into a struct
% MIT_dataset_builder(dataFolder);
% 
% %% Loading data
% load("D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Other\MIT_dataset.mat")
% %% Example of data
% plot_example(MIT_data,false)
% % there is clear noise into the signals
% 
% 
% %% Cleaning the whole dataset 
% MIT_data_cleaned=filter_signals(MIT_data);
% 
% % Example of data cleaned
% figure
% plot_example(MIT_data,false)
% hold on
% plot_example(MIT_data_cleaned,true)
% title('RAW vs Cleaned example')
% hold off
% 
% %%                                                       DATASET REBUILDING
% % Instead of considering 30 min of acquisition, for each subject are
% % extracted random records with a length of some seconds. In this way I'll
% % reach a good number of examples
% 
% record_duration= 10; %sec
% num_records=100; % for each sub
% min_overlap_ratio=0.1; % 10% of overlap allowed 
% 
% MIT_data_divided = extract_random_segments_struct(MIT_data_cleaned, record_duration, num_records, min_overlap_ratio);
% 
% % Showing the number of records reached
% disp(['There are: ',num2str(length(fieldnames(MIT_data_divided))*num_records), ' records'])
% 
% % Showing an example of record
% plot_record_example(MIT_data_divided,record_duration)
% 
% %% Spectral analysis 
% plotting_signals(MIT_data_divided,figure_path,"freq_mean_sd",true,false) 


%%                                               NEW EVALUATION MADE ON NEW DATA
clc
clear
close
%% Loading data and folders
dataFolder = "D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Other\";
src_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\src\Spectrum_comparison_phase";
figure_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Figure\Spectrum_investigation_phase";
addpath(src_path)
load(dataFolder+'PhysionetData.mat')

fc=300;

%% Building window spectrum analysis
% First, spectrums are evaluated usign the whole signal
windowsize=1000;
spectrum_struct = evaluate_Physionet_spectrums(Signals, fc, windowsize);
% Then, using windows of increasing dimentions
%% 
load(dataFolder+"Spectrums_PhysionetData.mat")
plotting_PhysioNet_signals(spectrum_struct, Labels, figure_path, fc,  'single_signal', true)

