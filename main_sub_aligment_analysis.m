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
QRS_detected_data=analyzeQRS(data,fc,true,'ref_trace');

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

window=0.01; %time window into whitch finding the maximum in seconds
plot_alignment=true;
Data_sub_aligned=single_sub_alignment(QRS_detected_data,fc,window,'only_ref',[],plot_alignment);
% Note, the function imputes the position of the QRS if necessary

%% Checking the result
traces_subplots_by_sub(Data_sub_aligned, fc, figure_path + "\single_records_v1") 
% Looking at these results looks clear that not all traces are correctly
% aligned respect to the QRS. What happens is that sometimes some traces
% seems to have aligned the atrial response with the QRS of the
% reference,while the spare2 trace (used to plot these data) seems to be
% aligned with th atrail contribution of the rov trace. So what if we
% change the stategy of alignment?

%% Rebuilding the dataset, part 2
% Now the strategy is: 
% step zero: find the QRS into the spare 2 trace
QRS_detected_data=analyzeQRS(QRS_detected_data,fc,true,'spare2_trace');
% For each rov signal
    % check if the QRS_ref is next to QRS_spare2
    % if yes, define the the neighborhood like done so far
    % if no, define the neighborhood around the QRS_spare2
% than proceed as done before

window=0.01; %time window into whitch finding the maximum in seconds
plot_alignment=false;
tollerance=0.05; %tollerance in [sec] of distance between QRS points in ref and spare2 traces
Data_sub_aligned=single_sub_alignment(QRS_detected_data,fc,window,'ref_and_spare2',tollerance,plot_alignment);

%% Checking the result
% Note, the function imputes the position of the QRS if necessary
traces_subplots_by_sub(Data_sub_aligned, fc, figure_path + "\single_records_v2")  

%% Checking the lost in terms of informations
nan_table = computeNaNPercentages(Data_sub_aligned);

%% Remaking analysis
% Whole analysis previously done are made again to check the results of
% alignment (for the moment, only in the time domain)
spaghetti_confidence_signals(Data_sub_aligned,fc,figure_path)
%%
compare_case_signals(Data_sub_aligned,fc,figure_path)   
compare_traces_between_sub(Data_sub_aligned,fc,figure_path) 
compare_maps_between_signals(Data_sub_aligned,fc,figure_path)



%%                                              WHOLE DATASET COMMON POINT ALIGNMENT
% The scope of this part of code is find out if it's possible to define a
% common point to align signals. Such common point will be the same for ALL
% rov signals and for ALL subjects
clear
close all
clc

processed_data_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Processed";
src_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\src\Sub_alignment_analysis_phase";
figure_path="D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Figure\Sub_alignment_analysis";
addpath(src_path)

%% Loading Data
load(processed_data_path+'\dataset_single_aligned.mat')
fc=2035;
%% Inspecting reference QRS distribution
QRS_vec=build_and_plot_QRS_distribution(Data_sub_aligned);
QRS_median=median(QRS_vec);

disp(['Median location of QRS: ',num2str(QRS_median)])
disp(['  in seconds: ',num2str(QRS_median/fc)])

% Good news: QRS are all around 0.5s seconds

%% Alignment respect to the median of QRS
% basically, the whole dataset is subscribed with the medan, then the
% function single_sub_aligned with ref strategy is used on the previusly
% aligned datased, leading to a dataset alignd respect to the same point

Data_aligned=substitute_QRS_pos_with_median(Data_sub_aligned,QRS_median);

% alignment
window=0.01; %time window into whitch finding the maximum in seconds
plot_alignment=false;
Data_aligned=single_sub_alignment(Data_aligned,fc,window,'only_ref',[],plot_alignment);

%% Plotting first results
traces_subplots_by_sub(Data_aligned, fc, figure_path + "\single_records_aligned")

%% Remaking population analysis


