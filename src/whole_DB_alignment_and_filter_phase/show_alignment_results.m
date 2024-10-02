function show_alignment_results(data, fc)
% SHOW_ALIGNMENT_RESULTS Visualize the first ROV trace for each subject in each map.
% This function takes the input data structure `data` which contains maps of 
% subjects and their corresponding ROV traces. For each subject in each map
% ('A', 'B', 'C'), the function plots the first ROV trace for that subject.
% The number of subplots is dynamically adjusted to optimize the display 
% based on the number of subjects in each map.
%
% Inputs:
%   - data: A structure containing maps ('MAP_A', 'MAP_B', 'MAP_C') with fields 
%           for each subject, where each field contains the ROV trace.
%   - fc: Sampling frequency of the ROV traces (in Hz).
%
% Outputs:
%   - None (the function generates and displays figures with the subplots).

    % Loop through each map (A, B, C)
    for i = ["A", "B", "C"]
        % Create a new figure and maximize the window for better visualization
        fig = figure;
        fig.WindowState = "maximized";
        
        % Set the figure's title with the map name and description
        sgtitle("Rov trace (record 1), MAP: " + i + " (" + get_name_of_map(i) + ")")
        
        % Construct the map name dynamically (e.g., 'MAP_A', 'MAP_B', 'MAP_C')
        map = 'MAP_' + i;
        
        % Get the list of subjects in the current map
        subjects = fieldnames(data.(map));

        % Determine the number of subjects in the current map
        numSubjects = length(subjects);
        
        % Calculate the optimal number of rows and columns for subplots
        numRows = ceil(sqrt(numSubjects));     % Number of rows (ceil ensures enough rows)
        numCols = ceil(numSubjects / numRows); % Number of columns based on number of rows

        % Loop through each subject in the map
        for j = 1:numSubjects
            % Get the subject's name
            sub = subjects{j};

            % Extract the ROV trace for the current subject
            rov = data.(map).(sub).rov_trace{:,1};
            
            % Create the time vector for the plot (1 second of data)
            t = [0:1/fc:1-1/fc]';

            % Create a subplot in the appropriate grid position (row, col)
            subplot(numRows, numCols, j)
            
            % Plot the ROV trace with a line width of 1
            plot(t, rov, "LineWidth", 1)

            % Extract the numeric part from the subject's name for the title
            num_str = regexp(sub, '\d+', 'match');
            
            % Set the title for the subplot using the subject number
            title("Subject: " + string(num_str))

            % Label the x-axis and y-axis
            xlabel('Time [s]')
            ylabel('Amplitude [mV]')
            
            % Set the x-axis limit to display only the first second
            xlim([0, 1])
        end
    end
end
