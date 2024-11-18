function time_th = define_time_th(map_upper, map_lower)
    % Initialize output matrix with a reasonable upper bound on the number of peaks
    time_th = [];
    
    % Find the upper and lower runs
    upper_runs = find_runs(map_upper);  % Find runs of 1s in map_upper
    lower_runs = find_runs(map_lower);  % Find runs of 1s in map_lower

    % Iterate through each upper-lower run pair
    for i = 1:length(upper_runs)
        % Check if there is a corresponding lower run after the upper run
        if i <= length(lower_runs)
            % Upper run start and end
            upper_start = upper_runs{i}(1);
            upper_end = upper_runs{i}(end);

            % Lower run start and end (should come after the upper run)
            lower_start = lower_runs{i}(1);
            lower_end = lower_runs{i}(end);

            % Ensure that the lower run starts after the upper run
            if lower_start > upper_end
                % Append the start and end of the peak (active region) to the output matrix
                time_th = [time_th; upper_start, lower_end];
            end
        end
    end
end

% Helper function to find runs of consecutive 1s in a binary vector
function runs = find_runs(binary_map)
    runs = {};  % Initialize cell array to store run indices
    start_idx = NaN;  % Initialize start index for a run

    for i = 1:length(binary_map)
        if binary_map(i) == 1  % If we encounter a 1, check for a run start
            if isnan(start_idx)
                start_idx = i;  % Mark the start of a new run
            end
        elseif binary_map(i) == 0 && ~isnan(start_idx)  % End of a run of 1s
            runs{end + 1} = start_idx:i-1;  % Store the run indices
            start_idx = NaN;  % Reset start index for the next run
        end
    end

    % If the last run ends at the final element in the vector, add it as well
    if ~isnan(start_idx)
        runs{end + 1} = start_idx:length(binary_map);
    end
end
