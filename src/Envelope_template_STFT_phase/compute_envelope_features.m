function [n_e_peaks,peak1_pos,peak2_pos,peak3_pos,peak1_val,peak2_val,peak3_val,...
    duration,silent_phase,silent_rateo,atrial_ventricular_ratio,n_peaks_duration_rateo]=compute_envelope_features(example_env,example_rov,fc)

[map_upper,map_lower]=analise_envelope_slope(example_rov,example_env,0.05,fc);

active_phase=map_upper+map_lower;

time_th = define_time_th(map_upper, map_lower);

[N,M]=size(time_th);
peaks_val_pos=nan(N,2);
for i=1:N
    [max_env,max_pos]=max(example_env(time_th(i,1):time_th(i,2)),[],"omitnan");
    peaks_val_pos(i,:)=[max_env,max_pos];
end

% three peaks are considered
    % sorting peaks in descending order of magnitude 
peaks_val_pos=sortrows(peaks_val_pos,"descend");
    % building a 3x2 matrix 

final_peaks_val_pos=nan(3,2);
for j=1:min([N,3])
    final_peaks_val_pos(j,:)=peaks_val_pos(j,:);
end


%% computing features
n_e_peaks=sum(~isnan(final_peaks_val_pos(:,1)));

peak1_pos=final_peaks_val_pos(1,2)/fc;
peak2_pos=final_peaks_val_pos(2,2)/fc;
peak3_pos=final_peaks_val_pos(3,2)/fc;

peak1_val=final_peaks_val_pos(1,1);
peak2_val=final_peaks_val_pos(2,1);
peak3_val=final_peaks_val_pos(3,1);

% computing duration 
duration=(time_th(N,M)-time_th(1,1))/fc;

% computing silent phase
silent_phase=sum(active_phase(time_th(1,1):time_th(N,M))==0)/fc;

% derivate features
silent_rateo=silent_phase/duration;

% computing number of peaks on duration
n_peaks_duration_rateo=n_e_peaks/duration;

% peaks rateo: assumption - atrial peak is the one to the far left, vent
% peak on the right
if n_e_peaks >= 2
    % Find the leftmost and rightmost peaks
    [~, leftmost_idx] = min(final_peaks_val_pos(:,2));
    [~, rightmost_idx] = max(final_peaks_val_pos(:,2));
    atrial_ventricular_ratio = final_peaks_val_pos(leftmost_idx,1) / final_peaks_val_pos(rightmost_idx,1);
else
    atrial_ventricular_ratio = nan; % Not enough peaks to compute the ratio
end
end

