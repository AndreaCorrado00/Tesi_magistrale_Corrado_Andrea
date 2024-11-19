function [map_upper, map_lower] = clean_false_peaks(map_upper, map_lower, example_env, perc_pos)
    % Calculate the threshold using the percentile value
    percentile_value = prctile(example_env, perc_pos, "all");
    
    % Iterate over the lower runs (descents)
    i = 1;
    while i <= length(map_lower)
        if map_lower(i) == 1  % Start of a descent (run_lower)
            % Find the end of the run (where map_lower turns to 0)
            run_end = i;
            while run_end <= length(map_lower) && map_lower(run_end) == 1
                run_end = run_end + 1;
            end
            
            % Check if this is the last run_lower
            is_last_run = all(map_lower(run_end:end) == 0);
            
            if ~is_last_run
                % Get the minimum value of the envelope in this run
                run_min = min(example_env(i:run_end-1));
                
                % If the run's minimum is greater than the threshold, eliminate the peak
                if run_min > max(example_env) * 0.1
                    % Eliminate the corresponding run_upper (after the descent)
                    j = run_end;  % Start from the first point after the run_lower
                    
                    % Find the first valid '1' in map_upper after run_end
                    while j <= length(map_upper) && map_upper(j) == 0
                        j = j + 1;
                    end
                    
                    % If a valid '1' is found in map_upper, start eliminating it
                    if j <= length(map_upper) && map_upper(j) == 1
                        while j <= length(map_upper) && map_upper(j) == 1
                            map_upper(j) = 0;  % Eliminate the run_upper
                            j = j + 1;
                        end
                    end
                    
                    % Eliminate the current run_lower
                    map_lower(i:run_end-1) = 0;
                end
            end
            % Move to the next run after the current one
            i = run_end;
        else
            i = i + 1;
        end
    end
end
