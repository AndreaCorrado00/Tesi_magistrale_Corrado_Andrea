function [active_areas_number,...
    Major_peak, Major_peak_time, Medium_peak, Medium_peak_time, Lowest_peak, Lowest_peak_time,...
    Major_peak_env, Major_peak_env_time, Medium_peak_env, Medium_peak_env_time, Lowest_peak_env, Lowest_peak_env_time,...
    First_peak, First_peak_time, Second_peak, Second_peak_time, Third_peak, Third_peak_time,...
    First_peak_env, First_peak_env_time, Second_peak_env, Second__peak_env_time, Third_peak_env, Third_peak_env_time,...
    duration,silent_phase,...
    silent_rateo,atrial_ventricular_ratio,atrial_ventricular_time_ratio,third_major_ratio,third_second_ratio,n_active_areas_on_duration_ratio] = compute_envelope_features(example_env,example_rov,fc)

    % COMPUTE_ENVELOPE_FEATURES Extracts various envelope features from the input signal
    %
    % This function computes a set of features related to the envelope and
    % roving signals (example_env and example_rov). These features include peak
    % values, peak timings, temporal activation characteristics, and ratios
    % of interest. The function processes the signal to detect the active areas
    % (regions of interest) and calculates various ratios based on signal 
    % characteristics such as atrial-ventricular phase relationships.
    %
    % Parameters:
    %   example_env (array) - The envelope signal representing the smoothed version
    %                          of the original signal, from which peaks are analyzed.
    %   example_rov (array) - The roving signal representing raw signal values, 
    %                          typically related to some bioelectrical measurement.
    %   fc (double)         - The frequency at which the signals are sampled (sampling rate).
    %
    % Output:
    %   active_areas_number (integer) - The number of active areas detected.
    %   Major_peak (double)           - The value of the largest peak in the roving signal.
    %   Major_peak_time (double)      - The time (in seconds) at which the Major peak occurs.
    %   Medium_peak (double)          - The value of the second largest peak in the roving signal.
    %   Medium_peak_time (double)     - The time (in seconds) at which the Medium peak occurs.
    %   Lowest_peak (double)          - The value of the third largest peak in the roving signal.
    %   Lowest_peak_time (double)     - The time (in seconds) at which the Lowest peak occurs.
    %   Major_peak_env (double)       - The value of the largest peak in the envelope signal.
    %   Major_peak_env_time (double)  - The time (in seconds) at which the Major peak in envelope occurs.
    %   Medium_peak_env (double)      - The value of the second largest peak in the envelope signal.
    %   Medium_peak_env_time (double)- The time (in seconds) at which the Medium peak in envelope occurs.
    %   Lowest_peak_env (double)      - The value of the third largest peak in the envelope signal.
    %   Lowest_peak_env_time (double)- The time (in seconds) at which the Lowest peak in envelope occurs.
    %   First_peak (double)           - The value of the first peak in the roving signal by time order.
    %   First_peak_time (double)      - The time (in seconds) at which the First peak occurs.
    %   Second_peak (double)          - The value of the second peak in the roving signal by time order.
    %   Second_peak_time (double)     - The time (in seconds) at which the Second peak occurs.
    %   Third_peak (double)           - The value of the third peak in the roving signal by time order.
    %   Third_peak_time (double)      - The time (in seconds) at which the Third peak occurs.
    %   First_peak_env (double)       - The value of the first peak in the envelope signal by time order.
    %   First_peak_env_time (double)  - The time (in seconds) at which the First peak in envelope occurs.
    %   Second_peak_env (double)      - The value of the second peak in the envelope signal by time order.
    %   Second__peak_env_time (double)- The time (in seconds) at which the Second peak in envelope occurs.
    %   Third_peak_env (double)       - The value of the third peak in the envelope signal by time order.
    %   Third_peak_env_time (double)  - The time (in seconds) at which the Third peak in envelope occurs.
    %   duration (double)             - The total duration of the signal in seconds.
    %   silent_phase (double)         - The duration of the silent phase (inactive period) in seconds.
    %   silent_rateo (double)         - The ratio of the silent phase to the total duration.
    %   atrial_ventricular_ratio (double) - The ratio of the atrial peak to the ventricular peak.
    %   atrial_ventricular_time_ratio (double) - The time ratio between the atrial peak and ventricular peak.
    %   third_major_ratio (double)    - The ratio of the third peak to the major peak.
    %   third_second_ratio (double)   - The ratio of the third peak to the second peak.
    %   n_active_areas_on_duration_ratio (double) - The ratio of active areas to the total signal duration.
    %
    % Example:
    %   [active_areas_number, Major_peak, Major_peak_time, ...] = compute_envelope_features(example_env, example_rov, fc);
    
    % Analyze the envelope slopes for upper and lower bounds
    [map_upper,map_lower] = analise_envelope_slope(example_env, 0.002, fc);
    
    % Define the time thresholds for active areas
    time_th = define_time_th(map_upper, map_lower);
    N_initial = size(time_th, 1);
    
    % Clean the time thresholds based on the roving signal
    time_th = clean_time_thresholds(example_rov, time_th, fc, 2.75);
    N_cleaned = size(time_th, 1);
    
    % Display a warning if the number of active areas changes
    if N_cleaned > 3
        fprintf("WARNING --> Starting from %.d, ends with %.d active areas \n", N_initial, N_cleaned);
    end
    
    % Number of active areas detected
    active_areas_number = size(time_th, 1);
    [N, ~] = size(time_th);
    
    %% Peaks of active areas evaluation 
    original_env_peaks_val_pos = nan(max([3, N]), 2);
    original_rov_peaks_val_pos = nan(max([3, N]), 2);
    
    for i = 1:min([N, 3])
        [max_val, max_pos] = max(example_env(time_th(i, 1):time_th(i, 2)), [], "omitnan");
        original_env_peaks_val_pos(i, :) = [max_val, (max_pos + time_th(i, 1)) / fc];
        
        [max_val, max_pos] = max(abs(example_rov(time_th(i, 1):time_th(i, 2))), [], "omitnan");
        original_rov_peaks_val_pos(i, :) = [max_val, (max_pos + time_th(i, 1)) / fc];
    end
    
    %% First block of features: Peaks in order of magnitude 
    % Sorting peaks in descending order of magnitude 
    env_peaks_val_pos = sortrows(original_env_peaks_val_pos, 1, "descend","MissingPlacement","last");
    rov_peaks_val_pos = sortrows(original_rov_peaks_val_pos, 1, "descend","MissingPlacement","last");
    
    % Handling zeros in the peaks
    env_peaks_val_pos(env_peaks_val_pos == 0) = nan;
    rov_peaks_val_pos(rov_peaks_val_pos == 0) = nan;

    % Roving signal peak details
    Major_peak = rov_peaks_val_pos(1, 1);
    Major_peak_time = rov_peaks_val_pos(1, 2);

    Medium_peak = rov_peaks_val_pos(2, 1);
    Medium_peak_time = rov_peaks_val_pos(2, 2);

    Lowest_peak = rov_peaks_val_pos(3, 1);
    Lowest_peak_time = rov_peaks_val_pos(3, 2);
    
    % Envelope signal peak details
    Major_peak_env = env_peaks_val_pos(1, 1);
    Major_peak_env_time = env_peaks_val_pos(1, 2);

    Medium_peak_env = env_peaks_val_pos(2, 1);
    Medium_peak_env_time = env_peaks_val_pos(2, 2);

    Lowest_peak_env = env_peaks_val_pos(3, 1);
    Lowest_peak_env_time = env_peaks_val_pos(3, 2);
    
    %% Second block of features: Peaks in order of time occurrence
    % Sorting peaks by time of occurrence 
    env_peaks_val_pos = sortrows(original_env_peaks_val_pos, 2, "ascend","MissingPlacement","last");
    rov_peaks_val_pos = sortrows(original_rov_peaks_val_pos, 2, "ascend","MissingPlacement","last");
    
    % Handling zeros in the peaks
    env_peaks_val_pos(env_peaks_val_pos == 0) = nan;
    rov_peaks_val_pos(rov_peaks_val_pos == 0) = nan;
    
    % Roving signal peaks by time
    First_peak = rov_peaks_val_pos(1, 1);
    First_peak_time = rov_peaks_val_pos(1, 2);

    Second_peak = rov_peaks_val_pos(2, 1);
    Second_peak_time = rov_peaks_val_pos(2, 2);

    Third_peak = rov_peaks_val_pos(3, 1);
    Third_peak_time = rov_peaks_val_pos(3, 2);
    
    % Envelope signal peaks by time
    First_peak_env = env_peaks_val_pos(1, 1);
    First_peak_env_time = env_peaks_val_pos(1, 2);

    Second_peak_env = env_peaks_val_pos(2, 1);
    Second__peak_env_time = env_peaks_val_pos(2, 2);

    Third_peak_env = env_peaks_val_pos(3, 1);
    Third_peak_env_time = env_peaks_val_pos(3, 2);

    %% Third block of features: Temporal activation features
    % Computing the signal duration
    duration = (time_th(end, end) - time_th(1, 1)) / fc;

    % Computing the silent phase (inactive period)
    silent_phase = ((time_th(end, end) - time_th(1, 1)) - sum(diff(time_th, 1, 2))) / fc;

    % Computing the silent phase ratio to the total duration
    silent_rateo = silent_phase / duration;

    % Computing the number of active areas relative to the duration
    n_active_areas_on_duration_ratio = active_areas_number / duration;

    %% Roving trace peaks: Atrial and ventricular phase evaluation
    % Using the start and end areas to detect the atrial and ventricular peaks
    [start_end_areas] = find_atrial_ventricular_areas(example_rov, example_env, fc);

    if sum(sum(isnan(start_end_areas))) == 0
        % Using the defined peaks for atrial and ventricular phases
        [atr_peak, atr_peak_pos] = max(example_rov(start_end_areas(1, 1):start_end_areas(1, 2)), [], "omitnan");
        [vent_peak, vent_peak_pos] = max(example_rov(start_end_areas(2, 1):start_end_areas(2, 2)), [], "omitnan");
        atrial_ventricular_ratio = atr_peak / vent_peak;
        atrial_ventricular_time_ratio = atr_peak_pos / vent_peak_pos;
    else
        atrial_ventricular_ratio = nan;
        atrial_ventricular_time_ratio = nan;
    end

    % Third peak evaluation
    if sum(sum(isnan(start_end_areas))) == 0
        third_major_ratio = atr_peak / Major_peak;
        third_second_ratio = atr_peak / Medium_peak;
    else
        third_major_ratio = nan;
        third_second_ratio = nan;
    end
    
end
