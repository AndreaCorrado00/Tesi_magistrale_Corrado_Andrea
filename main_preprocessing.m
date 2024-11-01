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
show_filter_pipeline_syntetic("white_noise_stationary_var_fix")

% Other example of situations: 
%baseline_drift white_noise_stationary_var_fix

%% 4.1 Didactical data examples
% Preprocessing pipeline is applied on didactical examples
close;clc;close all; % cleaning environment
show_filter_pipeline_didactical("Low_frequency_ecg") 

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
MAP_A7_example=data.MAP_A.MAP_A7;
MAP_B7_example=data.MAP_B.MAP_B7;
MAP_C7_example=data.MAP_C.MAP_C7;
    
% Evaluating filtering performance
close all;
    show_pipeline_performances(MAP_A7_example)
    show_pipeline_performances(MAP_B7_example)
    show_pipeline_performances(MAP_C7_example)



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

%% 7.0 Scalogram evaluation on didactical signals
show_scalogram_evaluation_pipeline("high_frequency_ecg")

% Other example of situations: 
% "high_frequency_ecg" "Low_frequency_ecg" "PhysioNet_healthy" "PhysioNet_Pathological"

%% 7.1 Algorthm application on AVNRT data
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

%% 8.1 Demonstrating that reference traces have the main oeaks aligned
show_ref_maximum_positions(data, fc)

%% 8.2 Does have sense align traces?
% Considering only traces with reference as ECG, whihc is the size of the
% database?

show_DB_reduction(data)

% Map B and C, yet less represented in the original DB, are reduced by the
% 50%. The class less reduced is MAP A. 

% Building an alignment could "save" these signals from being discarded.

%% 8.3  Data alignment 
% For each set of signals the R-peak is found
filter_flag=true;
data = find_guide_trace_and_filter(data, fc,filter_flag);
% Then R peak is used to align each set os singals to have ventricular
% conduction around 0.5 seconds
Aligned_DB= align_dataset(data,0.5,fc);


%% 8.4  Showing results examples
show_alignment_results(Aligned_DB,fc)


%% 8.5 Plotting single records results
traces_subplots_by_sub(Aligned_DB, fc, figure_path + "\single_records") 


%% 8.6 Dropping repeated subjects
Aligned_DB.MAP_A=rmfield(Aligned_DB.MAP_A, 'MAP_A5');
Aligned_DB.MAP_B=rmfield(Aligned_DB.MAP_B, 'MAP_B5');
Aligned_DB.MAP_C=rmfield(Aligned_DB.MAP_C, 'MAP_C5');


%% 8.7 Building the new dataset
POP_DB_aligned=build_pop_dataset_after_alignment(Aligned_DB);


%%                           ---------- ALIGNED DATASET ANALYSIS ---------- 
clc;clear;close;
% Ppopulation plots are done to summarize. They not intend to be a complete
% and deep representation, but just a quick overview on the data we have.

processed_data_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Processed";
src_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\src\DB_aligned_population_analysis_phase";
figure_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Figure\DB_aligned_population_analysis_phase";
addpath(src_path)

% Loading previusly made data
load(processed_data_path+'\dataset_pop_aligned_filt.mat');
load(processed_data_path+'\aligned_subjects_DB_filt.mat');
fc=2035;

%% 9.1 Single record visualization 
traces_subplots_by_sub(POP_DB_aligned, fc, figure_path + "\single_records")
    
%% 9.2 Data visualization as they are 
spaghetti_confidence_signals(POP_DB_aligned,fc,figure_path)

%% 9.3 Signals direct comparisons 

% comparison between maps within subjects and traces
compare_maps_between_signals(POP_DB_aligned,fc,figure_path)


%% 9.4 Saving the dataset as single table of signals
% db_table = build_table_dataset(POP_DB_aligned);
% writetable(db_table,processed_data_path+"\AVNRT_DB.csv")

db_table = build_table_dataset_with_subs(Aligned_DB);
writetable(db_table,processed_data_path+"\AVNRT_DB_filt.csv")
