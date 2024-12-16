function plot_feature_boxplots(data, class, feature_name)
    % Extract the feature column from the table and convert it to double
    feature = data{:, feature_name};  % Extract the feature data from the table
    feature = double(feature);        % Convert to double if it's not already numeric

    % Extract class column and convert it to a categorical array
    class_data = class{:, 1};         % Extract the class data from the table
    class_data = categorical(cellstr(class_data)); % Convert to categorical

    % Mapping of original classes to new labels
    class_map = containers.Map({'MAP_A', 'MAP_B', 'MAP_C'}, {'Indifferent', 'Effective', 'Dangerous'});
    
    % Create new class labels by concatenating the original class with the mapped label
    new_class_labels = cellfun(@(x) strcat(x, ' - ', class_map(x)), cellstr(class_data), 'UniformOutput', false);
    class_data = categorical(new_class_labels); % Update class_data with new concatenated labels

    % Create a new figure with the specified feature name as title
    figure;

    [lower_bound, upper_bound] = calculate_y_limits_boxplots(feature, class_data);
    % Format feature_name for the title (replace underscores with spaces)
    formatted_feature_name = strrep(feature_name, '_', ' ');

    % Generate boxplots by class, hiding outliers with 'Symbol' option
    boxplot(feature, class_data, 'Symbol', '');
    ylim([lower_bound, upper_bound]);   % Adjust y-limits to exclude outliers
    % Label the axes
    xlabel('Class');
    ylabel(formatted_feature_name);

    % Set the title
    title("Boxplots for "+ formatted_feature_name + " by Class","FontSize",14);
end
