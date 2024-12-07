function [n_e_peaks,env_peak1_time,env_peak2_time,env_peak3_time,env_peak1_val,env_peak2_val,env_peak3_val,...
    peak1_time,peak2_time,peak3_time,peak1_val,peak2_val,peak3_val,...
    duration,silent_phase,silent_rateo,atrial_ventricular_ratio,atrial_ventricular_time_ratio,third_major_ratio,third_second_ratio,n_peaks_duration_ratio]=compute_envelope_features(example_env,example_rov,fc)

[map_upper,map_lower]=analise_envelope_slope(example_env,0.002,fc);


time_th = define_time_th(map_upper, map_lower);

[N,M]=size(time_th);
env_peaks_val_pos=nan(N,2);
rov_peaks_val_pos=nan(N,2);
for i=1:N
    [max_env,max_pos]=max(example_env(time_th(i,1):time_th(i,2)),[],"omitnan");
    env_peaks_val_pos(i,:)=[max_env,max_pos+time_th(i,1)];

    [max_env,max_pos]=max(abs(example_rov(time_th(i,1):time_th(i,2))),[],"omitnan");
    rov_peaks_val_pos(i,:)=[max_env,max_pos+time_th(i,1)];

end

% three peaks are considered
    % sorting peaks in descending order of magnitude 
env_peaks_val_pos=sortrows(env_peaks_val_pos,"descend");
rov_peaks_val_pos=sortrows(rov_peaks_val_pos,"descend");

    % building a 3x2 matrix 

env_final_peaks_val_pos=nan(3,2);
final_rov_peaks_val_pos=nan(3,2);

for j=1:min([N,3])
    env_final_peaks_val_pos(j,:)=env_peaks_val_pos(j,:);
    final_rov_peaks_val_pos(j,:)=rov_peaks_val_pos(j,:);
end


%% COMPUTING FEATURES
%% envelope features

% envelope peaks
n_e_peaks=sum(~isnan(env_final_peaks_val_pos(:,1)));

env_peak1_time=env_final_peaks_val_pos(1,2)/fc;
env_peak2_time=env_final_peaks_val_pos(2,2)/fc;
env_peak3_time=env_final_peaks_val_pos(3,2)/fc;

env_peak1_val=env_final_peaks_val_pos(1,1);
env_peak2_val=env_final_peaks_val_pos(2,1);
env_peak3_val=env_final_peaks_val_pos(3,1);



% computing silent phase
active_area=map_upper|map_lower;
start_active=min(env_final_peaks_val_pos(:,2),[],"omitnan");
end_active=max(env_final_peaks_val_pos(:,2),[],"omitnan");

silent_phase=sum(active_area(start_active:end_active)==0)/fc;

% computing duration 
duration=length(active_area(start_active:end_active))/fc;

% derivate features
silent_rateo=silent_phase/duration;

% computing number of peaks on duration
n_peaks_duration_ratio=n_e_peaks/duration;

%% roving trace peaks 
% peaks rateo: assumption - atrial peak is the one to the far left, vent
% peak on the right

[start_end_areas]=find_atrial_ventricular_areas(example_rov,example_env,fc);


if sum(sum(isnan(start_end_areas)))==0
    % Find the leftmost and rightmost peaks
    [atr_peak,atr_peak_pos]=max(example_rov(start_end_areas(1,1):start_end_areas(1,2)),[],"omitnan");
    [vent_peak,vent_peak_pos]=max(example_rov(start_end_areas(2,1):start_end_areas(2,2)),[],"omitnan");
    atrial_ventricular_ratio =atr_peak/vent_peak;
    atrial_ventricular_time_ratio=atr_peak_pos/vent_peak_pos;

else
    if max(final_rov_peaks_val_pos(:,2),[],"omitnan")/fc>0.4 %forcing peak evaluation
        % detected peak is into the ventricular phase
        [atrial_peak,atrial_pos]=max(abs(example_rov(round(0.17*fc):round(0.4*fc))));
        vent_peak=max(final_rov_peaks_val_pos(:,1),[],"omitnan");
        atrial_ventricular_ratio=atrial_peak/vent_peak;
        atrial_ventricular_time_ratio=(atrial_pos+round(0.17*fc))/max(final_rov_peaks_val_pos(:,2),[],"omitnan");

    else
        [vent_peak,vent_pos]=max(abs(example_rov(round(0.4*fc):round(0.6*fc))));
        atrial_peak=max(final_rov_peaks_val_pos(:,1),[],"omitnan");
        atrial_ventricular_ratio=atrial_peak/vent_peak;
        atrial_ventricular_time_ratio=max(final_rov_peaks_val_pos(:,2),[],"omitnan")/(vent_pos+round(0.4*fc));
    end
end

if n_e_peaks ==3
    third_major_ratio = final_rov_peaks_val_pos(3,1) / final_rov_peaks_val_pos(1,1);
else
    third_major_ratio = nan; % Not enough peaks to compute the ratio
end

if n_e_peaks ==3
    third_second_ratio = final_rov_peaks_val_pos(3,1) / final_rov_peaks_val_pos(2,1);
else
    third_second_ratio = nan; % Not enough peaks to compute the ratio
end


% envelope peaks

peak1_time=final_rov_peaks_val_pos(1,2)/fc;
peak2_time=final_rov_peaks_val_pos(2,2)/fc;
peak3_time=final_rov_peaks_val_pos(3,2)/fc;

peak1_val=final_rov_peaks_val_pos(1,1);
peak2_val=final_rov_peaks_val_pos(2,1);
peak3_val=final_rov_peaks_val_pos(3,1);
end

