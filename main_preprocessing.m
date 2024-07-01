clc
clear
close 
%% Data and functions paths
original_data_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Original";
processed_data_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Processed";
src_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\src";

addpath(src_path)

%%                                      DATA PREPROCESSING
%% 1. Data refactoring 
%% Loading Subject 1
MAP_A1=readtable(original_data_path+"\MAP_A\MAP_A1.csv"); % indifferent
MAP_B1=readtable(original_data_path+"\MAP_B\MAP_B1.csv"); % effective
MAP_C1=readtable(original_data_path+"\MAP_C\MAP_C1.csv"); % dangerous

%% Refactoring Subject 1
MAP_A1=maps_refactoring(MAP_A1,processed_data_path+'\MAP_A\MAP_A1_refactored.csv');
MAP_B1=maps_refactoring(MAP_B1,processed_data_path+'\MAP_B\MAP_B1_refactored.csv');
MAP_C1=maps_refactoring(MAP_C1,processed_data_path+'\MAP_C\MAP_C1_refactored.csv');

