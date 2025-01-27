function show_features_statistics(features_tab, save, figure_path)
    % SHOW_FEATURES_STATISTICS Analyzes and visualizes statistics of features in a table.
    %
    % This function processes a table of features and performs the following tasks:
    %   1. Generates box plots for each feature.
    %   2. Saves the plots (optional).
    %   3. Calculates and prints the distribution of active areas (peaks) for each map type.
    %
    % INPUT:
    %   features_tab - A table containing feature data. The last column represents the class labels.
    %   save - Boolean indicating whether to save the generated plots.
    %   figure_path - Path to save the plots if 'save' is true.
    %
    % USAGE:
    %   show_features_statistics(features_tab, true, 'path/to/save/plots');
    %
    % REQUIREMENTS:
    %   - The 'features_tab' must have a column named 'active_areas_number' for peak counting.
    %   - Functions 'plot_feature_boxplots' and 'save_plot' must be defined and accessible.

    % Extract feature names and class labels from the input table
    feature_names = features_tab.Properties.VariableNames;
    classes = features_tab(:, feature_names(end)); % Class labels are in the last column
    feature_names = feature_names(1:end-1); % Exclude class labels from feature names

    % Generate box plots for each feature and save if required
    for i = 3:length(feature_names) % Start from the 3rd feature (skip first two if necessary)
        % Get the current feature name
        feature_name = feature_names{i};

        % Call a helper function to plot box plots for the feature
        plot_feature_boxplots(features_tab, classes, feature_name);

        % Save the plot if the 'save' flag is true
        if save
            save_plot(feature_name, "_boxplot", figure_path, gcf, true);
        end
    end

    % Analyze the distribution of active areas (peaks) for each map type
    unique_classes = unique(classes); % Get unique map types (e.g., MAP_A, MAP_B, MAP_C)

    for i = 1:height(unique_classes) % Iterate through each unique map type
        % Extract the current map type name
        map_type = unique_classes{i, :}; 

        % Initialize counters for the number of active areas
        N1 = 0; N2 = 0; N3 = 0; N_more = 0;

        % Get rows corresponding to the current map type
        map_class = table2array(classes) == map_type; 
        class_data = features_tab(map_class, :);

        % Count the number of signals with different active area counts
        for j = 1:height(class_data)
            % Extract the number of peaks (active areas) for the current signal
            n_peaks = class_data.active_areas_number(j);

            % Update counters based on the number of peaks
            if n_peaks == string(1)
                N1 = N1 + 1;
            elseif n_peaks == string(2)
                N2 = N2 + 1;
            elseif n_peaks == string(3)
                N3 = N3 + 1;
            elseif n_peaks > string(3)
                N_more = N_more + 1;
            end
        end

        % Print the statistics for the current map type
        fprintf('%s has:\n', map_type);
        fprintf('  - %d signals with one active area\n', N1);
        fprintf('  - %d signals with two active areas\n', N2);
        fprintf('  - %d signals with three active areas\n', N3);
        fprintf('  - %d signals with more than three active areas\n', N_more);
        fprintf('        total : %d \n ', N1 + N2 + N3 + N_more);
    end
end
