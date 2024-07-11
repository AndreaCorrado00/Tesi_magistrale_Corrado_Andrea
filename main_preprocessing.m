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

<<<<<<< Updated upstream
% Comparison within traces between subjects
<<<<<<< Updated upstream
compare_traces_between_sub(data,fc,figure_path)
=======
table_pox=[false,true;
            true,true];
=======
%% 2.4 Similarity between signals 
table_corr=correlation_signals_within_maps(data,'rov_trace',true);
% It could be interesting looking at the correlation values within
% subjects. IE a sort of distribution
>>>>>>> Stashed changes

type_plots=["comp_case_by_sign"; "comp_case_spectrum_by_sign"];
for l = 1:2
    for i = ["A","B","C"]
        map = 'MAP_' + i;
        subjects = fieldnames(data.(map));
        for k = ["rov","ref","spare1","spare2","spare3"]
            for j = 1:length(subjects)
                sub = map + num2str(j);
                trace = k + '_trace';
                title_plot = 'MAP:' + i + ' (' + get_name_of_map(i) + '), trace:' + k + ', subjects comparison';
                fig = figure(1);
                fig.WindowState = "maximized";
                hold on
                compare_by_plotting_signals(data.(map).(sub).(trace), title_plot, fc, table_pox(1, l), table_pox(2, l));
                
                legend_entries{j} = ['Subject ' num2str(j)];
            end  
            legend(legend_entries);
            hold off
            save_plot(i, '', k, type_plots(l), figure_path+"\traces_comp", fig, true);
        end
    end
end
>>>>>>> Stashed changes

% comparison between maps within subjects and traces
compare_maps_between_signals(data,fc,figure_path)

%% 2.3  ApEn Evaluation
% Are signals more or less regular?
% TOO MUCH TIME
apen_builder=true;
if apen_builder
    apen_data=apen_dataset_builder(data);
    save("D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Processed\apen_dataset.mat",'apen_data')
else
    load(apen_dataset.mat);
end

%% 


