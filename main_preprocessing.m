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
processed_data_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Processed";
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
comparclcclce_traces_between_sub(data,fc,figure_path) 
% comparison between maps within subjects and traces
compare_maps_between_signals(data,fc,figure_path)


  

%%                           ---------- SINGLE SUBJECTS ANALYSIS ----------
clc;clear;close;
% Now the same analysis/visualizations made for population dataset are made
% subject by subject, to check possible inter subjects differences

% Adding paths
src_pre_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\src\Preprocessing_phase";
figure_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Figure\Preprocessing_phase";
processed_data_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Processed";
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





%%    ---------- PREPROCESSING AND SPECTRUM EVALUATION ALGORITHM ----------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESULTS, explanation and further comments available into <3. in-depth spectrum analysis.pptx>%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NB: comments aren't correct due to futher evaluations done. For a more
% complete and clear overview the thesis text will be more solid and clear.

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
show_filter_pipeline("baseline_drift")

% Other example of situations: 
%baseline_drift white_noise_stationary_var_fix

%% 4.1 Sintetic data algorithm performances 
% Preprocessin pipeline is then applied on didactical examples. Then,
% spectrums are evaluated. 
close;clc; % cleaning environment
show_spectrum_evaluation_pipeline("high_frequency_ecg") 

% Other example of situations: 
% "high_frequency_ecg" "Low_frequency_ecg" "PhysioNet_healthy" "PhysioNet_Pathological"
%% 4.2 Spectrum composition
build_and_show_expected_spectrums()

%% 4.3 Spectrum evaluation algorithm on AVNRT data
processed_data_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Processed";
% Loading previusly made data
load(processed_data_path+'\dataset.mat');
fc=2035;

% Building examples
MAP_A1_example=data.MAP_A.MAP_A1;
MAP_B1_example=data.MAP_B.MAP_B1;
MAP_C1_example=data.MAP_C.MAP_C8;

    %% 4.3.1 Evaluatig filtering performance
    show_pipeline_performances(MAP_C1_example)

    %% 4.3.2 Example of complete-optimized pipeline 
    % Example of Filter application and spectrum evaluation
    % filter application
    show_filter_result=true;
    Example_filtered=apply_filter(MAP_C1_example,show_filter_result);

    % Example of spectrums
    show_spectrum_AVNRT_example(Example_filtered)



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
    window=0.2; %time window into which finding the maximum in seconds
    plot_alignment=false;
    Data_sub_aligned_1=single_sub_alignment(QRS_detected_data,fc,window,'only_ref',[],plot_alignment);

    % 5.1.2 Strategy 2
    % QRS is in both ref and spare2 traces but possibly shifted
    window=0.01; %time window into which finding the maximum in seconds
    plot_alignment=false;
    tollerance=0.05; %tollerance in [sec] of distance between QRS points in ref and spare2 traces
    Data_sub_aligned_2=single_sub_alignment(QRS_detected_data,fc,window,'ref_and_spare2',tollerance,plot_alignment);

    % 5.1.3 Strategy 3
    % a real QRS is only into the spare1 trace
    window=0.2; %time window into whitch finding the maximum in seconds
    plot_alignment=false;
    Data_sub_aligned_3=single_sub_alignment(QRS_detected_data,fc,window,'only_spare1',[],plot_alignment);

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

%% 6.0 Scalogram evaluation on didactical signals
show_scalogram_evaluation_pipeline("high_frequency_ecg")

% Other example of situations: 
% "high_frequency_ecg" "Low_frequency_ecg" "PhysioNet_healthy" "PhysioNet_Pathological"

%% 6.1 Algorthm application on AVNRT data
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

%% 7.1 Whole dataset alignment
Aligned_DB= align_and_filter_dataset(data,Data_sub_aligned_1,false,0.5,fc);

%% 7.2 Showing some examples
show_alignment_results(Aligned_DB,fc)

%% 7.3 Building the new_population dataset
% whole DB even unclear ref traces
POP_DB_aligned=build_pop_dataset_after_alignment(Aligned_DB);

%% 7.4 Plotting single records results
traces_subplots_by_sub(Aligned_DB, fc, figure_path + "\single_records") 





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Intermediate step: pop analysis on subject with ref trace with QRS     %
vec_subs=[1,2,4,6,11];                                                    %
ref_QRS_data=extract_single_subs(Aligned_DB, vec_subs);  
show_alignment_results(ref_QRS_data,fc)
POP_DB_aligned=build_pop_dataset_after_alignment(ref_QRS_data);           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Following section work on data which have the reference trace clearly 
% interpretable. That's because of this "intermediate step. Once clarified
% the nature of reference trace and defined the best way to alig traces,
% it's possible to proceed.





%%                ---------- ALIGNED DATASET POPULATION ANALYSIS ---------- 
clc;clear;close;
% Now, the population dataset is evaluated again using what has been
% studied before. So functions, pretty similar to the ones used before, are
% update with the last methods implemented (spectrum eval).
% N.B. As the only traces aligned are rov traces and all records have been
% filtered, changes will be appreciable on the rov_trace analysis and into
% spectrums analysis

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
% Comparison between different signals mean/periodogram traces for the same case
compare_case_signals(POP_DB_aligned,fc,figure_path)   
% Comparison within traces between subjects 
compare_traces_between_sub(POP_DB_aligned,fc,figure_path) 
% comparison between maps within subjects and traces
compare_maps_between_signals(POP_DB_aligned,fc,figure_path)

%% 8.4 Preparing dataset for feature extraction




