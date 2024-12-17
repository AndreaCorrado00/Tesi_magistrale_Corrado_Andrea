function [Dominant_ALFP, Dominant_AMFP, Dominant_AHFP, ...
            Subdominant_ALFP, Subdominant_AMFP, Subdominant_AHFP, ...
            Minor_ALFP, Minor_AMFP, Minor_AHFP,...
            First_ALFP, First_AMFP,First_AHFP, ...
            Second_ALFP, Second_AMFP, Second_AHFP, ...
            Third_ALFP, Third_AMFP, Third_AHFP]=compute_STFT_features(example_rov,example_env,fc)

%% Time threshold evaluation
% Same as envelope analysis
[map_upper,map_lower]=analise_envelope_slope(example_env,0.002,fc);
time_th = define_time_th(map_upper, map_lower);
time_th=clean_time_thresholds(example_rov,time_th,fc,2.5);

[N,~]=size(time_th);

% Peaks of active areas evaluation 
original_rov_peaks_val_pos=zeros(max([3,N]),4);
for i=1:min([N,3])
    % peak value, peak instant, active area start, active area end
    [max_val,max_pos]=max(abs(example_rov(time_th(i,1):time_th(i,2))),[],"omitnan");
    original_rov_peaks_val_pos(i,:)=[max_val,(max_pos+time_th(i,1))/fc,time_th(i,1)/fc,time_th(i,2)/fc];

end

%% FIRST BLOCK: peak in order of magnitude
    % sorting peaks in descending order of magnitude 
original_rov_peaks_val_pos=sortrows(original_rov_peaks_val_pos,1,"descend");

%% STFT computation 
% STFT parameters definition
win_length = 64; % length of the window (points)
hop_size = round(win_length / 3); % 30% superposition
window = hamming(win_length, 'periodic'); % Hamming window
nfft = 1048; % FFT evaluation points

[S, F, T, STFT] = spectrogram(example_rov, window, hop_size, nfft, fc);

%% Areas of interest definition: time thresholds on STFT
% Adding two columns to original_rov_peaks_val_pos: start and end of STFT
% time threhsolds
original_rov_peaks_val_pos=[original_rov_peaks_val_pos,zeros(size(original_rov_peaks_val_pos,1),1),zeros(size(original_rov_peaks_val_pos,1),1)];
for i = 1:size(time_th, 1)
    [~, idx_start] = min(abs(T - original_rov_peaks_val_pos(i, 3))); % Begin of i-th active area 
    [~, idx_end] = min(abs(T - original_rov_peaks_val_pos(i, 4)));   % End of i-th active area 
    original_rov_peaks_val_pos(i, 5:6) = [idx_start, idx_end];
end

%% Frequency sub-bands
Low_band=[0,75]; %Hz
Medium_band=[75,150]; %Hz
High_band=[150,350]; % Hz

idx_Low_band = find(F >= Low_band(1) & F <= Low_band(2));
idx_Medium_band = find(F > Medium_band(1) & F <= Medium_band(2));
idx_High_band = find(F > High_band(1) & F <= High_band(2));


%% Average STFT value  for each sub band

avg_STFT_subbands=zeros(3,3);

    
for i=1:3
    if original_rov_peaks_val_pos(i,1)~=0
        avg_STFT_subbands(1,i)=mean(STFT(idx_Low_band,original_rov_peaks_val_pos(i,5):original_rov_peaks_val_pos(i,6)),'all');
        avg_STFT_subbands(2,i)=mean(STFT(idx_Medium_band,original_rov_peaks_val_pos(i,5):original_rov_peaks_val_pos(i,6)),'all');
        avg_STFT_subbands(3,i)=mean(STFT(idx_High_band,original_rov_peaks_val_pos(i,5):original_rov_peaks_val_pos(i,6)),'all');
    end
end


% Nan Mapping
avg_STFT_subbands(avg_STFT_subbands==0)=nan;

%% Features names assegnation 
Dominant_ALFP=avg_STFT_subbands(1,1);
Dominant_AMFP=avg_STFT_subbands(1,2);
Dominant_AHFP=avg_STFT_subbands(1,3);

Subdominant_ALFP=avg_STFT_subbands(2,1);
Subdominant_AMFP=avg_STFT_subbands(2,2);
Subdominant_AHFP=avg_STFT_subbands(2,3);

Minor_ALFP=avg_STFT_subbands(3,1);
Minor_AMFP=avg_STFT_subbands(3,2);
Minor_AHFP=avg_STFT_subbands(3,3);

%% SECOND BLOCK: peaks in order of occurence
    % sorting peaks in descending order of occurance 
original_rov_peaks_val_pos=sortrows(original_rov_peaks_val_pos,2,"descend");

%% Areas of interest definition: time thresholds on STFT
% Adding two columns to original_rov_peaks_val_pos: start and end of STFT
% time threhsolds
original_rov_peaks_val_pos=[original_rov_peaks_val_pos,zeros(size(original_rov_peaks_val_pos,1),1),zeros(size(original_rov_peaks_val_pos,1),1)];
for i = 1:size(time_th, 1)
    [~, idx_start] = min(abs(T - original_rov_peaks_val_pos(i, 3))); % Begin of i-th active area 
    [~, idx_end] = min(abs(T - original_rov_peaks_val_pos(i, 4)));   % End of i-th active area 
    original_rov_peaks_val_pos(i, 5:6) = [idx_start, idx_end];
end

%% Frequency sub-bands
Low_band=[0,75]; %Hz
Medium_band=[75,150]; %Hz
High_band=[150,350]; % Hz

idx_Low_band = find(F >= Low_band(1) & F <= Low_band(2));
idx_Medium_band = find(F > Medium_band(1) & F <= Medium_band(2));
idx_High_band = find(F > High_band(1) & F <= High_band(2));


%% Average STFT value  for each sub band

avg_STFT_subbands=zeros(3,3);
  
for i=1:3
    if original_rov_peaks_val_pos(i,1)~=0
        avg_STFT_subbands(1,i)=mean(STFT(idx_Low_band,original_rov_peaks_val_pos(i,5):original_rov_peaks_val_pos(i,6)),'all');
        avg_STFT_subbands(2,i)=mean(STFT(idx_Medium_band,original_rov_peaks_val_pos(i,5):original_rov_peaks_val_pos(i,6)),'all');
        avg_STFT_subbands(3,i)=mean(STFT(idx_High_band,original_rov_peaks_val_pos(i,5):original_rov_peaks_val_pos(i,6)),'all');
    end
end


% Nan Mapping
avg_STFT_subbands(avg_STFT_subbands==0)=nan;

%% Features names assegnation 
First_ALFP=avg_STFT_subbands(1,1);
First_AMFP=avg_STFT_subbands(1,2);
First_AHFP=avg_STFT_subbands(1,3);

Second_ALFP=avg_STFT_subbands(2,1);
Second_AMFP=avg_STFT_subbands(2,2);
Second_AHFP=avg_STFT_subbands(2,3);

Third_ALFP=avg_STFT_subbands(3,1);
Third_AMFP=avg_STFT_subbands(3,2);
Third_AHFP=avg_STFT_subbands(3,3);



end


