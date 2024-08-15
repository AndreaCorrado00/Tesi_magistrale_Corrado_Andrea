clc
clear
close
%%                                                SIGNAL ALIGNMENT FOR EACH SUBJECT
processed_data_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Processed";
src_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\src\Sub_alignment_analysis_phase";
figure_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Figure\Sub_alignment_analysis";
addpath(src_path)

% Loading previusly made data
load(processed_data_path+'\dataset.mat');

%%                                         QRS DETECTION AND SINGLE SUBJECT SIGNAL ALIGNMENT
%% QRS detecton
% for each signal
fc=2035;
QRS_detected_data=analyzeQRS(data,fc,true);

%% QRS position analysis
% Now for each single signal there is the position of the QRS, it's
% reasonable to see if, for a single ref trace (thus for a sigle subject)
% the distribution of QRS positions is very close to the mean position. If
% yes, one can proceed by considering the position of the QRS as the mean
% of the QRS position for that reference trace for the specified subject. 

QRSStatsTable = computeQRSStatistics(QRS_detected_data);

% Looking at the table, it's not possible to directly conclude that the QRS
% position can be approximated with the mean, at least not for each
% subject. Further investigations are necessary in this case. So for
% subjects with huge variability, there will visualized QRS position and
% signals. 

%% QRS position:going deeper
subjectIndices=1:12; 
plotQRSForSubjects(QRS_detected_data, subjectIndices,fc,figure_path)

% There are some subjects (i.e., sub 8) for whom the QRS is clearly shifted
% probably due to some realigment issues. It's necessary to check even if
% the corresponding components into the rov trace are shifeted too or at
% least if there's an hint about that

% After a quick evaluation, does not seems to be a problem such situation.
% So now one can proceed by rebuilding the dataset.

%% Rebuilding the dataset, part 1
% Here the dataset is rebuilt by align one by one the signals into the rov
% trace with the QRS position. The strategy is:
    % For each subject
        % For each rov SIGNAL
            % Find the maximum around the posistion of the QRS_ref, then evaluate
                % the distance between such maximum and the QRS point. 
            % Shift the signal by adding NaNs on top or bottom and adjust the
                % length of the signal to be the same as the original one.

% Then the analysis done previously will be made again to see if there are
% changes.

% NB: during the processing, the function substitute possible unavailable
% QRS with the median of the ref trace QRS.

window=0.1; %time window into whitch finding the maximum in seconds
Data_sub_aligned=single_sub_alignment(QRS_detected_data,fc,window);

%% Remaking analysis
% Whole analysis previously done are made again to check the results of
% alignment
spaghetti_confidence_signals(Data_sub_aligned,fc,figure_path)
compare_case_signals(Data_sub_aligned,fc,figure_path)  
compare_traces_between_sub(Data_sub_aligned,fc,figure_path) 
compare_maps_between_signals(Data_sub_aligned,fc,figure_path)
traces_subplots_by_sub(Data_sub_aligned, fc, figure_path) 


%%                                              WHOLE DATASET COMMON POINT ALIGNMENT
% The scope of this part of code is find out if it's possible to define a
% common point to align signals. Such common point will be the same for ALL
% rov signals and for ALL subjects

    



