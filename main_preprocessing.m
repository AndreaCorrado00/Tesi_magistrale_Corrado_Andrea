clc
clear
close 
%% Data and functions paths
original_data_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Original";
processed_data_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Processed";
src_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\src";
addpath(original_data_path)
addpath(src_path)
addpath(processed_data_path)

%% LOADING DATA
%% Subject 1
MAP_A1=readtable("Data\MAP_A\MAP_A1.csv",'ReadVariableNames', true); % indifferent
MAP_B1=readtable("Data\MAP_B\MAP_B1.csv"); % effective
MAP_C1=readtable("Data\MAP_C\MAP_C1.csv"); % dangerous

%% 
MAP_A1=maps_refactoring(MAP_A1);
MAP_B1new=maps_refactoring(MAP_B1);
MAP_C1new=maps_refactoring(MAP_C1);

