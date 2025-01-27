function [start_end_areas] = find_atrial_ventricular_areas(signal, example_env, fc)
    % FIND_ATRIAL_VENTRICULAR_AREAS Identifies the start and end times of the atrial and 
    % ventricular phases in a physiological signal based on envelope analysis.
    %
    % This function utilizes envelope analysis to segment the input signal into 
    % atrial and ventricular phases. The function identifies the time intervals where 
    % the highest peaks occur for the atrial phase (before 0.4s) and the ventricular 
    % phase (after 0.4s), and returns these intervals in the output matrix.
    %
    % INPUTS:
    %   signal       - A vector representing the physiological signal (e.g., electrogram).
    %   example_env  - A structure or dataset representing the envelope of the signal.
    %   fc           - The sampling frequency of the signal.
    %
    % OUTPUT:
    %   start_end_areas - A 2x2 matrix where:
    %       - The first row contains the start and end times of the atrial phase.
    %       - The second row contains the start and end times of the ventricular phase.
    %
    % EXAMPLE:
    %   start_end_areas = find_atrial_ventricular_areas(signal, example_env, fc);
    %   % start_end_areas will contain the start and end times for atrial and ventricular phases.
    
    %% Envelope active areas
    [map_upper, map_lower] = analise_envelope_slope(example_env, 0.002, fc); 
    time_th = define_time_th(map_upper, map_lower);
    
    %% Atrial phase: highest peak before 0.4 s
    t_i = round(0.17 * fc);
    t_vent = round(0.45 * fc);
    i = 1;
    atr_peak = 0;
    t_atr_start = nan;
    t_atr_end = nan;

    while t_i < t_vent && time_th(i, 2) < t_vent && i < size(time_th, 1)
        t_s = time_th(i, 1);
        t_e = time_th(i, 2);
        [candidate_atr_peak, candidate_atr_peak_pos] = max(signal(t_s:t_e));

        if candidate_atr_peak > atr_peak
            atr_peak = candidate_atr_peak;
            t_atr_start = t_s;
            t_atr_end = t_e;
        end
        i = i + 1;
        t_i = candidate_atr_peak_pos / fc;
    end

    %% Ventricular phase: highest peak after 0.4 s
    t_vent_start = nan;
    t_vent_end = nan;
    vent_peak = 0;

    while i <= size(time_th, 1)
        t_s = time_th(i, 1);
        t_e = time_th(i, 2);
        candidate_vent_peak = max(signal(t_s:t_e));

        if candidate_vent_peak > vent_peak
            vent_peak = candidate_vent_peak;
            t_vent_start = t_s;
            t_vent_end = t_e;
        end
        i = i + 1;
    end

    start_end_areas = [t_atr_start, t_atr_end;
                       t_vent_start, t_vent_end];
end
