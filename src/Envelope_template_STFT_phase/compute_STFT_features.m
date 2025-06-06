function [Dominant_ALFP, Dominant_AMFP, Dominant_AHFP, ...
            Subdominant_ALFP, Subdominant_AMFP, Subdominant_AHFP, ...
            Minor_ALFP, Minor_AMFP, Minor_AHFP,...
            First_ALFP, First_AMFP,First_AHFP, ...
            Second_ALFP, Second_AMFP, Second_AHFP, ...
            Third_ALFP, Third_AMFP, Third_AHFP,...
            max_First_HF,max_First_MF,max_First_LF,...
            max_Second_HF,max_Second_MF,max_Second_LF,...
            max_Third_HF,max_Third_MF,max_Third_LF,...
            min_First_HF,min_First_MF,min_First_LF,...
            min_Second_HF,min_Second_MF,min_Second_LF,...
            min_Third_HF,min_Third_MF,min_Third_LF,...
            std_First_HF,std_First_MF,std_First_LF,...
            std_Second_HF,std_Second_MF,std_Second_LF,...
            std_Third_HF,std_Third_MF,std_Third_LF]=compute_STFT_features(example_rov,example_env,fc)
% This function computes and returns various frequency-domain features 
% derived from the Short-Time Fourier Transform (STFT) of the given input signals.
% The features are categorized into dominant, subdominant, minor, and sequential peaks 
% based on the peak magnitudes and occurrence order of the active regions.

%% Time threshold evaluation
% Evaluate the envelope slope and define time thresholds to segment the signal
[map_upper,map_lower]=analise_envelope_slope(example_env,0.002,fc);
time_th = define_time_th(map_upper, map_lower);
time_th=clean_time_thresholds(example_rov,time_th,fc,2.75);

[N,~]=size(time_th);

% Peaks of active areas evaluation 
original_rov_peaks_val_pos=nan(max([3,N]),4);
for i=1:min([N,3])
    % Find the peak value, peak instant, and active area boundaries: start
    % and stop.
    [max_val,max_pos]=max(abs(example_rov(time_th(i,1):time_th(i,2))),[],"omitnan");
    original_rov_peaks_val_pos(i,:)=[max_val,(max_pos+time_th(i,1))/fc,time_th(i,1)/fc,time_th(i,2)/fc];
end

%% FIRST BLOCK: peak in order of magnitude
% Sorting the peaks in descending order of magnitude 
original_rov_peaks_val_pos=sortrows(original_rov_peaks_val_pos,1,"descend","MissingPlacement","last");

%% STFT computation 
% Compute the STFT using the spectrogram function with defined parameters
win_length = 64; % length of the window (points)
hop_size = round(win_length / 3); % 30% overlap between adjacent windows
window = hamming(win_length, 'periodic'); % Hamming window
nfft = 1048; % Number of FFT points for frequency resolution

[S, F, T, STFT] = spectrogram(example_rov, window, hop_size, nfft, fc);

%% Areas of interest definition: time thresholds on STFT
% Define the time threshold indices in the STFT based on the previously computed time thresholds
original_rov_peaks_val_pos=[original_rov_peaks_val_pos,zeros(size(original_rov_peaks_val_pos,1),1),zeros(size(original_rov_peaks_val_pos,1),1)];
for i = 1:size(time_th, 1)
    [~, idx_start] = min(abs(T - original_rov_peaks_val_pos(i, 3))); % Start index of the active region 
    [~, idx_end] = min(abs(T - original_rov_peaks_val_pos(i, 4)));   % End index of the active region
    original_rov_peaks_val_pos(i, 5:6) = [round(idx_start), round(idx_end)];
end

%% Frequency sub-bands
% Define frequency bands for Low, Medium, and High frequency ranges
Low_band=[0,75]; %Hz
Medium_band=[75,150]; %Hz
High_band=[150,350]; % Hz

% Find the indices corresponding to each frequency band
idx_Low_band = F >= Low_band(1) & F <= Low_band(2);
idx_Medium_band = F > Medium_band(1) & F <= Medium_band(2);
idx_High_band = F > High_band(1) & F <= High_band(2);

%% Average STFT value for each sub-band
% Calculate the average STFT values for each frequency band (Low, Medium, High)
avg_STFT_subbands=zeros(3,3);
for i=1:3
    if ~isnan(original_rov_peaks_val_pos(i,1))
        avg_STFT_subbands(1,i)=mean(STFT(idx_Low_band,original_rov_peaks_val_pos(i,5):original_rov_peaks_val_pos(i,6)),'all');
        avg_STFT_subbands(2,i)=mean(STFT(idx_Medium_band,original_rov_peaks_val_pos(i,5):original_rov_peaks_val_pos(i,6)),'all');
        avg_STFT_subbands(3,i)=mean(STFT(idx_High_band,original_rov_peaks_val_pos(i,5):original_rov_peaks_val_pos(i,6)),'all');
    end
end

% Replace zeros with NaN to handle missing data or uncalculated regions
avg_STFT_subbands(avg_STFT_subbands==0)=nan;

%% Features assignment 
% Assign the average STFT values from each sub-band to corresponding feature variables
Dominant_ALFP=avg_STFT_subbands(1,1);
Dominant_AMFP=avg_STFT_subbands(1,2);
Dominant_AHFP=avg_STFT_subbands(1,3);

Subdominant_ALFP=avg_STFT_subbands(2,1);
Subdominant_AMFP=avg_STFT_subbands(2,2);
Subdominant_AHFP=avg_STFT_subbands(2,3);

Minor_ALFP=avg_STFT_subbands(3,1);
Minor_AMFP=avg_STFT_subbands(3,2);
Minor_AHFP=avg_STFT_subbands(3,3);

%% SECOND BLOCK: peaks in order of occurrence
% Sorting the peaks based on the order of occurrence (time position)
original_rov_peaks_val_pos=sortrows(original_rov_peaks_val_pos,2,"ascend","MissingPlacement","last");

%% Areas of interest definition: time thresholds on STFT
% Redefine the time threshold indices in the STFT based on the occurrence order of peaks
original_rov_peaks_val_pos=[original_rov_peaks_val_pos,zeros(size(original_rov_peaks_val_pos,1),1),zeros(size(original_rov_peaks_val_pos,1),1)];
for i = 1:size(time_th, 1)
    [~, idx_start] = min(abs(T - original_rov_peaks_val_pos(i, 3))); % Start index of the active region 
    [~, idx_end] = min(abs(T - original_rov_peaks_val_pos(i, 4)));   % End index of the active region 
    original_rov_peaks_val_pos(i, 5:6) = [round(idx_start), round(idx_end)];
end

%% Frequency sub-bands
% Same frequency bands (Low, Medium, High) as in the first block
Low_band=[0,75]; %Hz
Medium_band=[75,150]; %Hz
High_band=[150,350]; % Hz

% Recalculate the indices for each frequency band
idx_Low_band = F >= Low_band(1) & F <= Low_band(2);
idx_Medium_band = F > Medium_band(1) & F <= Medium_band(2);
idx_High_band = F > High_band(1) & F <= High_band(2);

%% Average STFT value for each sub-band (second block)
% Calculate the average STFT values for each sub-band again based on the reordered peaks
features_STFT_subbands=zeros(12,3);% 3 peaks, 12 features for each peak
for i=1:3
    if ~isnan(original_rov_peaks_val_pos(i,1))
        features_STFT_subbands(1,i)=mean(STFT(idx_Low_band,original_rov_peaks_val_pos(i,5):original_rov_peaks_val_pos(i,6)),'all');
        features_STFT_subbands(2,i)=mean(STFT(idx_Medium_band,original_rov_peaks_val_pos(i,5):original_rov_peaks_val_pos(i,6)),'all');
        features_STFT_subbands(3,i)=mean(STFT(idx_High_band,original_rov_peaks_val_pos(i,5):original_rov_peaks_val_pos(i,6)),'all');

        features_STFT_subbands(4,i)=max(STFT(idx_Low_band,original_rov_peaks_val_pos(i,5):original_rov_peaks_val_pos(i,6)),[],'all');
        features_STFT_subbands(5,i)=max(STFT(idx_Medium_band,original_rov_peaks_val_pos(i,5):original_rov_peaks_val_pos(i,6)),[],'all');
        features_STFT_subbands(6,i)=max(STFT(idx_High_band,original_rov_peaks_val_pos(i,5):original_rov_peaks_val_pos(i,6)),[],'all');

        features_STFT_subbands(7,i)=min(STFT(idx_Low_band,original_rov_peaks_val_pos(i,5):original_rov_peaks_val_pos(i,6)),[],'all');
        features_STFT_subbands(8,i)=min(STFT(idx_Medium_band,original_rov_peaks_val_pos(i,5):original_rov_peaks_val_pos(i,6)),[],'all');
        features_STFT_subbands(9,i)=min(STFT(idx_High_band,original_rov_peaks_val_pos(i,5):original_rov_peaks_val_pos(i,6)),[],'all');

        features_STFT_subbands(10,i)=std(STFT(idx_Low_band,original_rov_peaks_val_pos(i,5):original_rov_peaks_val_pos(i,6)),0,'all');
        features_STFT_subbands(11,i)=std(STFT(idx_Medium_band,original_rov_peaks_val_pos(i,5):original_rov_peaks_val_pos(i,6)),0,'all');
        features_STFT_subbands(12,i)=std(STFT(idx_High_band,original_rov_peaks_val_pos(i,5):original_rov_peaks_val_pos(i,6)),0,'all');


    end
end

% Replace zeros with NaN for consistency
features_STFT_subbands(features_STFT_subbands==0)=nan;

%% Features assignment (second block)
% Assign the calculated STFT values to new feature variables for the second set of peaks
First_ALFP=features_STFT_subbands(1,1);
First_AMFP=features_STFT_subbands(1,2);
First_AHFP=features_STFT_subbands(1,3);

Second_ALFP=features_STFT_subbands(2,1);
Second_AMFP=features_STFT_subbands(2,2);
Second_AHFP=features_STFT_subbands(2,3);

Third_ALFP=features_STFT_subbands(3,1);
Third_AMFP=features_STFT_subbands(3,2);
Third_AHFP=features_STFT_subbands(3,3);

max_First_HF=features_STFT_subbands(4,1);
max_First_MF=features_STFT_subbands(4,2);
max_First_LF=features_STFT_subbands(4,3);

max_Second_HF=features_STFT_subbands(5,1);
max_Second_MF=features_STFT_subbands(5,2);
max_Second_LF=features_STFT_subbands(5,3);

max_Third_HF=features_STFT_subbands(6,1);
max_Third_MF=features_STFT_subbands(6,2);
max_Third_LF=features_STFT_subbands(6,3);

min_First_HF=features_STFT_subbands(7,1);
min_First_MF=features_STFT_subbands(7,2);
min_First_LF=features_STFT_subbands(7,3);

min_Second_HF=features_STFT_subbands(8,1);
min_Second_MF=features_STFT_subbands(8,2);
min_Second_LF=features_STFT_subbands(8,3);

min_Third_HF=features_STFT_subbands(9,1);
min_Third_MF=features_STFT_subbands(9,2);
min_Third_LF=features_STFT_subbands(9,3);

std_First_HF=features_STFT_subbands(10,1);
std_First_MF=features_STFT_subbands(10,2);
std_First_LF=features_STFT_subbands(10,3);

std_Second_HF=features_STFT_subbands(11,1);
std_Second_MF=features_STFT_subbands(11,2);
std_Second_LF=features_STFT_subbands(11,3);

std_Third_HF=features_STFT_subbands(12,1);
std_Third_MF=features_STFT_subbands(12,2);
std_Third_LF=features_STFT_subbands(12,3);

end
