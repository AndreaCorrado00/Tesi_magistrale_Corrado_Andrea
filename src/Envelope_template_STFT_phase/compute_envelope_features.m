function [active_areas_number,...
    Major_peak, Major_peak_time, Medium_peak, Medium_peak_time, Lowest_peak, Lowest_peak_time,...
    Major_peak_env, Major_peak_env_time, Medium_peak_env, Medium_peak_env_time, Lowest_peak_env, Lowest_peak_env_time,...
    First_peak, First_peak_time, Second_peak, Second_peak_time, Third_peak, Third_peak_time,...
    First_peak_env, First_peak_env_time, Second_peak_env, Second__peak_env_time, Third_peak_env, Third_peak_env_time,...
    duration,silent_phase,...
    silent_rateo,atrial_ventricular_ratio,atrial_ventricular_time_ratio,third_major_ratio,third_second_ratio,n_active_areas_on_duration_ratio]=compute_envelope_features(example_env,example_rov,fc)

[map_upper,map_lower]=analise_envelope_slope(example_env,0.002,fc);


time_th = define_time_th(map_upper, map_lower);
N_initial=size(time_th,1);
time_th=clean_time_thresholds(example_rov,time_th,fc,2.75);
N_cleaned=size(time_th,1);

if N_cleaned>3
    fprintf("WARNING --> Starting from %.d, ends with %.d active areas \n",N_initial,N_cleaned)
end

active_areas_number=size(time_th,1);

[N,~]=size(time_th);

%% Peaks of active areas evaluation 
original_env_peaks_val_pos=zeros(max([3,N]),2);
original_rov_peaks_val_pos=zeros(max([3,N]),2);
for i=1:min([N,3])
    [max_val,max_pos]=max(example_env(time_th(i,1):time_th(i,2)),[],"omitnan");
    original_env_peaks_val_pos(i,:)=[max_val,(max_pos+time_th(i,1))/fc];

    [max_val,max_pos]=max(abs(example_rov(time_th(i,1):time_th(i,2))),[],"omitnan");
    original_rov_peaks_val_pos(i,:)=[max_val,(max_pos+time_th(i,1))/fc];

end

%% First block of features: Peaks in order of magnitude 
    % sorting peaks in descending order of magnitude 
env_peaks_val_pos=sortrows(original_env_peaks_val_pos,1,"descend");
rov_peaks_val_pos=sortrows(original_rov_peaks_val_pos,1,"descend");
    % zeros handling
env_peaks_val_pos(env_peaks_val_pos==0)=nan;
rov_peaks_val_pos(rov_peaks_val_pos==0)=nan;

    % Roving signal
Major_peak=rov_peaks_val_pos(1,1);
Major_peak_time=rov_peaks_val_pos(1,2);

Medium_peak=rov_peaks_val_pos(2,1);
Medium_peak_time=rov_peaks_val_pos(2,2);

Lowest_peak=rov_peaks_val_pos(3,1);
Lowest_peak_time=rov_peaks_val_pos(3,2);
    
    % Envelope signal
Major_peak_env=env_peaks_val_pos(1,1);
Major_peak_env_time=env_peaks_val_pos(1,2);

Medium_peak_env=env_peaks_val_pos(2,1);
Medium_peak_env_time=env_peaks_val_pos(2,2);

Lowest_peak_env=env_peaks_val_pos(3,1);
Lowest_peak_env_time=env_peaks_val_pos(3,2);
    
%% Second block of features: Peaks in order of time occurence 
    % sorting peaks in descending order of time occurence 
env_peaks_val_pos=sortrows(original_env_peaks_val_pos,2,"ascend");
rov_peaks_val_pos=sortrows(original_rov_peaks_val_pos,2,"ascend");
    % zeros handling
env_peaks_val_pos(env_peaks_val_pos==0)=nan;
rov_peaks_val_pos(rov_peaks_val_pos==0)=nan;

    % Roving signal
First_peak=rov_peaks_val_pos(1,1);
First_peak_time=rov_peaks_val_pos(1,2);

Second_peak=rov_peaks_val_pos(2,1);
Second_peak_time=rov_peaks_val_pos(2,2);

Third_peak=rov_peaks_val_pos(3,1);
Third_peak_time=rov_peaks_val_pos(3,2);
    
    % Envelope signal
First_peak_env=env_peaks_val_pos(1,1);
First_peak_env_time=env_peaks_val_pos(1,2);

Second_peak_env=env_peaks_val_pos(2,1);
Second__peak_env_time=env_peaks_val_pos(2,2);

Third_peak_env=env_peaks_val_pos(3,1);
Third_peak_env_time=env_peaks_val_pos(3,2);

%% Third block of features: temporal activation features 

% computing duration 
duration=(time_th(end,end)-time_th(1,1))./fc;

% computing silent phase
silent_phase=((time_th(end,end)-time_th(1,1))-sum(diff(time_th,1,2)))./fc; 

% derivate features
silent_rateo=silent_phase/duration;

% computing number of peaks on duration
n_active_areas_on_duration_ratio=active_areas_number/duration;

%% roving trace peaks 
% peaks rateo: assumption - atrial peak is the one to the far left, vent
% peak on the right

[start_end_areas]=find_atrial_ventricular_areas(example_rov,example_env,fc);


if sum(sum(isnan(start_end_areas)))==0
    % Using the defintion and peaks as they are
    [atr_peak,atr_peak_pos]=max(example_rov(start_end_areas(1,1):start_end_areas(1,2)),[],"omitnan");
    [vent_peak,vent_peak_pos]=max(example_rov(start_end_areas(2,1):start_end_areas(2,2)),[],"omitnan");
    atrial_ventricular_ratio =atr_peak/vent_peak;
    atrial_ventricular_time_ratio=atr_peak_pos/vent_peak_pos;

else
    if max(original_rov_peaks_val_pos(:,2),[],"omitnan")/fc>0.4 %forcing peak evaluation
        % detected peak is into the ventricular phase, thus must be found
        % the atrial one
        [atrial_peak,atrial_pos]=max(abs(example_rov(round(0.17*fc):round(0.4*fc))));
        vent_peak=max(original_rov_peaks_val_pos(:,1),[],"omitnan");
        atrial_ventricular_ratio=atrial_peak/vent_peak;
        atrial_ventricular_time_ratio=(atrial_pos+round(0.17*fc))/max(original_rov_peaks_val_pos(:,2),[],"omitnan");

    else
        % viceversa
        [vent_peak,vent_pos]=max(abs(example_rov(round(0.4*fc):round(0.6*fc))));
        atrial_peak=max(original_rov_peaks_val_pos(:,1),[],"omitnan");
        atrial_ventricular_ratio=atrial_peak/vent_peak;
        atrial_ventricular_time_ratio=max(original_rov_peaks_val_pos(:,2),[],"omitnan")/(vent_pos+round(0.4*fc));
    end
end

third_major_ratio=Third_peak/Major_peak;
third_second_ratio=Third_peak/Second_peak;


end

