clc
clear
close 
%% Data and functions paths
original_data_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Original";
processed_data_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Processed";

pop=false;
if pop
    src_pop_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\src\Preprocessing_pop_phase";
    figure_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Figure\Preprocessing_pop_phase";
    addpath(src_pop_path)
else
    src_pre_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\src\Preprocessing_phase";
    figure_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Figure\Preprocessing_phase";
    addpath(src_pre_path)
end



%%                                                       DATA PREPROCESSING
%% 1. Data refactoring 
refactoring=false;
if refactoring==true
    if pop==true
        refactor_and_save_pop_data(original_data_path,processed_data_path);
    else
        refactor_and_save_data(original_data_path,processed_data_path);
    end

elseif refactoring==false
    if pop
        load(processed_data_path+'\dataset_pop.mat');
    else
        load(processed_data_path+'\dataset.mat');
    end
end

%%                                                               DATA EDA
fc=2035;

%% 2. Data proprieties
spaghetti_confidence_signals(data,fc,figure_path)

%% 2.1 First observations
% Not all maps have the same numerousness
% there are some signals not in the correct map

% it could be interesting to check the inter-subject mean of signals and
% psd to see if there are some similarities. Just plotting means on means
% and, why not, building the same plots for the maps within subjects.   

%% 2.2 Signals direct comparisons (both for population and subject analysis)
% Comparison between different signals mean/periodogram traces for the same case
compare_case_signals(data,fc,figure_path)   

% Comparison within traces between subjects 
compare_traces_between_sub(data,fc,figure_path) 

% comparison between maps within subjects and traces
compare_maps_between_signals(data,fc,figure_path)

  

%%                                                   SUBJECT SPECIFIC INVESTIGATIONS
%% 3.1 3D plot of signals between subjects 
compare_traces_between_sub_3D_figure(data, fc,figure_path) 

%% 3.2 Subplots of traces record comprison for each subject 
traces_subplots_by_sub(data, fc, figure_path) 

%% 3.3 Subjects with Ref trace equal to spare 1 trace
display_ref_equal_spare1(data)



