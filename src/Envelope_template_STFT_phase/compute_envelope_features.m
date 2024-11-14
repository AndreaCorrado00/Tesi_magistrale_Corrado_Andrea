function [n_peaks,peak1_pos,peak2_pos,peak3_pos,peak1_val,peak2_val,peak3_val,...
    duration,silent_phase,silent_rateo,major_peaks_rateo,n_peaks_duration_rateo]=compute_envelope_features(example_env,fc)

example_env(round(0.6*fc):end)=nan;
example_env(1:round(0.15*fc))=nan;
% Builting an iterative pipeline to find peaks in order
are_peaks=true;
significance_th=0.001;
step=20;

% map of peaks presence
map_peaks=zeros(length(example_env),1);

% features initialization
peaks_pos_val=nan(3,2);
iter=1;
while are_peaks
    [candidate,candidate_pos]=max(example_env,[],"omitnan");
    region=zeros(length(example_env),1);
    region(candidate_pos)=candidate; % region starts with a single point

    % saving first three peaks positions and values
    if iter<=3
        peaks_pos_val(iter,1)=candidate_pos;
        peaks_pos_val(iter,2)=candidate;
    end

    % region growing initialization
    is_significant=true;
    % positions
    sx_lim=candidate_pos;
    dx_lim=candidate_pos;
    % start
    sx_lim_value=candidate;
    dx_lim_value=candidate;

    map_peak=zeros(length(example_env),1);

    while is_significant

        % new point on the left
        if sx_lim> step
            sx_pos_candidate=sx_lim-step;
            candidate_sx=example_env(sx_pos_candidate);
        else
            sx_pos_candidate=step;
            candidate_sx=example_env(sx_pos_candidate);
        end

        % new point on the right
        if dx_lim<length(example_env)-step
            dx_pos_candidate=dx_lim+step;
            candidate_dx=example_env(dx_pos_candidate);
        else
            dx_pos_candidate=length(example_env);
            candidate_dx=example_env(dx_pos_candidate);
        end

        % computing distances
        distance_sx=sx_lim_value-candidate_sx;
        distance_dx=dx_lim_value-candidate_dx;

        more_sx=distance_sx>significance_th;
        if more_sx
            % region can grow
            sx_lim=sx_pos_candidate;
            region(sx_lim)=candidate_sx;
            sx_lim_value=candidate_sx;
        end

        more_dx=distance_dx>significance_th ;
        if more_dx
            % region can grow
            dx_lim=dx_pos_candidate;
            region(dx_lim)=candidate_dx;
            dx_lim_value=candidate_dx;
        end

        % continue growing?
        if more_sx || more_dx
            is_significant=true;
        else
            is_significant=false;
        end

        % pause(2)
        % figure;
        % plot(example_env,'k')
        % hold on
        % plot(sx_pos_candidate,candidate_sx,'bo')
        % plot(dx_pos_candidate,candidate_dx,'ro')
    end

    region(sx_lim:dx_lim)=example_env(sx_lim:dx_lim);
    example_env=example_env-region;

    map_peak(region~=0)=1;
    map_peaks=map_peaks+map_peak;

    next_candidate=max(example_env,[],"omitnan");

    if abs(candidate-next_candidate)<significance_th*0.2
        are_peaks=false;
        % disp("are peaks = false")
        break
    end
    
    iter=iter+1;

end

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






