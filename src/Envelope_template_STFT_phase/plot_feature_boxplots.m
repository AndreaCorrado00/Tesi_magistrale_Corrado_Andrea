function plot_feature_boxplots(data, class, feature_name)
% plot_feature_boxplots
%
% This function generates boxplots for a specified feature in a dataset, grouped by a 
% categorical class variable. It also overlays scatter points on the boxplots to provide 
% additional visual representation of individual data points. The plot includes customized 
% colors for each class and formats the figure based on the input feature name.
%
% Parameters:
%   - data (table): A table containing the dataset with features. The feature to be plotted
%                   is identified by its column name.
%   - class (table): A table containing the class labels corresponding to each data point. 
%                    The class variable is categorical and defines the groups for the boxplots.
%   - feature_name (string): The name of the feature (column in the `data` table) to be plotted.
%                             This is used to extract the feature values for plotting and 
%                             to create the plot title.
%
% Functionality:
%   1. The feature data is extracted from the provided `data` table and converted to numeric 
%      format (double) if it's not already.
%   2. The class data is extracted and converted into a categorical array with an explicitly 
%      defined order ('Indifferent', 'Effective', 'Dangerous').
%   3. A new figure is created with the specified feature name used in the plot title.
%   4. The function calculates the y-axis limits based on the feature data, excluding outliers.
%   5. Boxcharts are generated for each class, with specific colors assigned to each class 
%      ('Indifferent' as blue, 'Effective' as green, 'Dangerous' as red).
%   6. Scatter points for each data point are plotted over the boxcharts, with a small amount 
%      of horizontal jitter applied to avoid overlap.
%   7. The axes are adjusted for readability and the title is set based on the feature name.
%
% Example:
%   plot_feature_boxplots(data, class, 'feature_name')
%
% This function is useful for visualizing the distribution of a feature across different classes,
% making it easier to compare the central tendency, spread, and outliers for each group.


    % Extract the feature column from the table and convert it to double
    feature = data{:, feature_name};  % Extract the feature data from the table
    feature = double(feature);        % Convert to double if it's not already numeric

    % Extract class column and convert it to a categorical array
    class_data = class{:, 1};         % Extract the class data from the table
    desired_order = {'Indifferent', 'Effective', 'Dangerous'}; % Specify the desired order
    class_data = categorical(cellstr(class_data), desired_order, 'Ordinal', true); % Convert to categorical with specific order

    % Create a new figure with the specified feature name as title
    figure('Position', [100, 100, 800, 600]);

    % Format feature_name for the title (replace underscores with spaces)
    formatted_feature_name = strrep(feature_name, '_', ' ');

    % Calculate y-limits based on the data, excluding outliers
    [lower_bound, upper_bound] = calculate_y_limits_boxplots(feature, class_data);

    % Generate boxcharts by class with specific colors
    hold on; % Allow multiple boxcharts and scatter points on the same axes
    % categories_list = categories(class_data); % Get unique categories in specified order
    colors = {[0.6, 0.6, 0.8], [0.2, 0.8, 0.2], [0.8, 0.2, 0.2]}; % Blue for Indifferent, Green for Effective, Red for Dangerous
    jitter_amount = 0.4; % Amount of horizontal jitter for scatter points
    for i = 1:length(desired_order)
        % Get the data for the current category
        current_category = desired_order{i};
        idx = class_data == current_category;
        
        % Plot the boxchart
        boxchart(repmat(i, sum(idx), 1), feature(idx), 'BoxWidth', 0.5, ...
                 'MarkerStyle', 'none', ...
                 'BoxFaceColor', colors{i});
        
        % Add scatter points for the data
        jittered_x = i + (rand(sum(idx), 1) - 0.5) * jitter_amount; % Add jitter to x-coordinates
        scatter(jittered_x, feature(idx), 20, 'filled', 'MarkerFaceAlpha', 0.30, 'MarkerFaceColor', colors{i}); % Scatter points with transparency
    end
    hold off;

    % Adjust axes and formatting
    ylim([lower_bound, upper_bound]);   % Adjust y-limits to exclude outliers
    set(gca, 'XTick', 1:length(desired_order), 'XTickLabel', desired_order,"FontSize",14); % Set class labels on x-axis
    xlabel('Class',"FontSize",16);
    ylabel(formatted_feature_name,"FontSize",16);

    % Set the title
    title("Boxplots for " + formatted_feature_name + " by Class", "FontSize", 20);
end
