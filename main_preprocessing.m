clc
clear
close 
%% Data and functions paths
original_data_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Original";
processed_data_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Processed";
src_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\src";

addpath(src_path)

%%                                                       DATA PREPROCESSING
%% 1. Data refactoring 
refactoring=false;
if refactoring==true
    n_el=numel(dir(original_data_path+"\MAP_A"))-2;
    for i = 1:n_el
        for map_name=["A","B","C"] %indifferent, effective, dangerous
            % Loading Subject
            MAP=readtable(original_data_path+"\MAP_"+map_name+"\MAP_"+map_name+num2str(i)+".csv");

            % Refactoring Subject
            MAP=maps_refactoring(MAP,processed_data_path+'\MAP_'+map_name+'\MAP_'+map_name+'_refactored.csv');

            % Adding data to a struct
            main_field='MAP_'+map_name;
            sub_field='MAP_'+map_name+num2str(i);
            data.(main_field).(sub_field)=MAP;
        end
    end
    save("D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Processed\dataset.mat",'data')

elseif refactoring==false
    load(processed_data_path+'\dataset.mat')
end
%% 2. Data proprieties
plotting_signals(data.MAP_A.MAP_A1.rov_trace,'Mean rov trace')

% mean_rov=mean(data.MAP_A.MAP_A1.rov_trace,2);
% mean_ref=mean(data.MAP_A.MAP_A1.ref_trace,2);
% mean_spare1=mean(data.MAP_A.MAP_A1.spare1_trace,2);
% mean_spare2=mean(data.MAP_A.MAP_A1.spare2_trace,2);
% mean_spare3=mean(data.MAP_A.MAP_A1.spare3_trace,2);



