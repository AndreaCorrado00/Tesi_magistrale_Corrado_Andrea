function [n_peaks,peak1_pos,peak2_pos,peak3_pos,peak1_val,peak2_val,peak3_val,...
    duration,silent_phase,silent_rateo,major_peaks_rateo,n_peaks_duration_rateo]=compute_envelope_features_B(example_env,fc)
% original envelope
original_example=example_env;

% cleaning
example_env(round(0.6*fc):end)=nan;
example_env(1:round(0.15*fc))=nan;
% Builting an iterative pipeline to find peaks in order
are_peaks=true;
step=20;

% map of peaks presence
map_peaks=zeros(length(example_env),1);

% features initialization
peaks_pos_val=nan(3,2);
iter=1;

% Absolute minimum
abs_min=abs(min(example_env,[],"omitnan"));

while are_peaks
    [candidate,candidate_pos]=max(example_env,[],"omitnan");
    region=zeros(length(example_env),1);

    % region growing initialization
    is_significant=true;
    grow_steps=0;
    % positions
    sx_lim=candidate_pos;
    dx_lim=candidate_pos;

    sx_pos_candidate=candidate_pos;
    dx_pos_candidate=candidate_pos;
    candidate_sx=candidate;
    candidate_dx=candidate;

    map_peak=zeros(length(example_env),1);

    while is_significant

        % Is the candidate far from the absolute minimum?
        next_candidate_sx=example_env(max([0,sx_pos_candidate-step]));
        next_candidate_dx=example_env(min([length(example_env),dx_pos_candidate+step]));

        candidate_sx_absmin_dist=abs(candidate_sx-abs_min);
        candidate_dx_absmin_dist=abs(candidate_dx-abs_min);

        next_candidate_sx_absmin_dist=abs(next_candidate_sx-abs_min);
        next_candidate_dx_absmin_dist=abs(next_candidate_dx-abs_min);

        more_sx=candidate_sx_absmin_dist>next_candidate_sx_absmin_dist;

        if more_sx
            % region can grow
            sx_lim=max([0,sx_pos_candidate-step]);
            grow_steps=grow_steps+1;

            candidate_sx=next_candidate_sx;
            sx_pos_candidate=sx_lim;
        end

        more_dx=candidate_dx_absmin_dist>next_candidate_dx_absmin_dist;
        if more_dx 
            % region can grow
            dx_lim=min([length(example_env),dx_pos_candidate+step]);
            grow_steps=grow_steps+1;

            candidate_dx=next_candidate_dx;
            dx_pos_candidate=dx_lim;
        end

        % continue growing?
        if more_sx || more_dx
            is_significant=true;
        else
            is_significant=false;
        end

        figure;
        plot(example_env,'k')
        hold on
        plot(sx_pos_candidate,candidate_sx,'bo')
        plot(candidate_pos,candidate,'ro')
        plot(dx_pos_candidate,candidate_dx,'ro')
        pause(1)

        
    end

    region(sx_lim:dx_lim)=example_env(sx_lim:dx_lim);
    example_env=example_env-region;
    % example_env(example_env==0)=nan;

    map_peak(region~=0)=1;
    map_peaks=map_peaks+map_peak;
    
    next_candidate=max(example_env,[],"omitnan");
    disp(["candidate: ",candidate])
    disp(["Next candidate: ", next_candidate])

    if grow_steps==0
        are_peaks=false;
        disp("are peaks = false")
        break
    end


    % saving first three peaks positions and values
    if iter<=3
        peaks_pos_val(iter,1)=candidate_pos;
        peaks_pos_val(iter,2)=candidate;
    end
    
    iter=iter+1;

end
% showing plots
peaks_determined=nan(length(map_peaks),1);
peaks_determined(map_peaks==1)=original_example(map_peaks==1);
figure;
plot(original_example,'k:')
hold on
plot(peaks_determined)

% computing features
n_peaks=sum(~isnan(peaks_pos_val(:,1)));

peak1_pos=peaks_pos_val(1,1)/fc;
peak2_pos=peaks_pos_val(2,1)/fc;
peak3_pos=peaks_pos_val(3,1)/fc;

peak1_val=peaks_pos_val(1,2);
peak2_val=peaks_pos_val(2,2);
peak3_val=peaks_pos_val(3,2);

% computing duration 
idx_active=find(map_peaks==1);
active_phase=map_peaks(idx_active(1):idx_active(end));
duration=length(active_phase)/fc;

% computing silent phase
silent_phase=sum(active_phase==0)/fc;

% derivate features
silent_rateo=silent_phase/duration;

if peak1_pos<peak2_pos
    major_peaks_rateo=peak1_val/peak2_val;
else
    major_peaks_rateo=peak2_val/peak1_val;
end

n_peaks_duration_rateo=n_peaks/duration;






