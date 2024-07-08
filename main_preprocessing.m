clc
clear
close 
%% Data and functions paths
original_data_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Original";
processed_data_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Processed";
src_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\src";
figure_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Figure\Preprocessing_phase";

addpath(src_path)

%%                                                       DATA PREPROCESSING
%% 1. Data refactoring 
refactoring=false;
if refactoring==true
    refactor_and_save_data(original_data_path)
elseif refactoring==false
    load(processed_data_path+'\dataset.mat')
end

%%                                                               DATA EDA

%% 2. Data proprieties
fc=2035;
spaghetti_confidence_signals(data,fc,figure_path)

%% 2.1 First observations
% Not all maps have the same numerosity
% there are some signals not in the correct map

% it could be interesting to check the inter-subject mean of signals and
% psd to see if there are some similarities. Just plotting means on means
% and, why not, building the same plots for the maps within subjects.

%% 2.2 Signals direct comparisons
% Comparison between different signals mean/periodogram traces for the same case
compare_case_signals(data,fc,figure_path)

% Comparison within traces between subjects
compare_traces_between_sub(data,fc,figure_path)

% comparison between maps within subjects and traces
compare_maps_between_signals(data,fc,figure_path)

%% 2.3  ApEn Evaluation
% Are signals more or less regular?
apen_builder=true;
if apen_builder
    apen_data=apen_dataset_builder(data);
    save("D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Processed\apen_dataset.mat",'apen_data')
else
    load(apen_dataset.mat);
end



