function [map_upper, map_lower] = clean_false_peaks(map_upper, map_lower, example_env, perc_pos)
    % Calculate the threshold using the percentile value
    percentile_value = prctile(example_env, perc_pos, "all");
    
    % Iterate over the lower runs (descents)
    i = 1;
    while i <= length(map_lower)
        if map_lower(i) == 1  % Start of a descent (run_lower)
            % Find the run's end (where map_lower turns to 0)
            run_end = i;
            while run_end <= length(map_lower) && map_lower(run_end) == 1
                run_end = run_end + 1;
            end
            
            % Get the minimum value of the envelope in this run
            run_min = min(example_env(i:run_end-1));
            
            % If the run's minimum is greater than the threshold, eliminate the peak
            if run_min > percentile_value
                % Set the following run_upper to 0 (invalid peak, remove)
                j = run_end;  % Start from the first point after the run_lower
                while j <= length(map_upper) && map_upper(j) == 1
                    map_upper(j) = 0;  % Eliminate the run_upper
                    j = j + 1;
                end
                
                % Eliminate the current run_lower
                map_lower(i:run_end-1) = 0;
            end
            % Move to the next run after the current one
            i = run_end;
        else
            i = i + 1;
        end
    end
end
