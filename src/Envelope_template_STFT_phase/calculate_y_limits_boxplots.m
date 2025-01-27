function [lower_bound, upper_bound] = calculate_y_limits_boxplots(feature, class_data)
    % CALCULATE_Y_LIMITS_BOXPLOTS Calculates the y-axis limits for boxplots
    % based on the whisker values (using IQR) for each class in the feature.
    %
    % This function calculates the lower and upper whisker limits for three 
    % classes in the data, based on the interquartile range (IQR) and the 
    % defined whisker length. It returns the minimum and maximum whisker 
    % values to be used as the y-axis limits for a boxplot.
    %
    % Parameters:
    %   feature (array)       - The data array containing the values to be 
    %                            used for the boxplots.
    %   class_data (array)    - The class labels corresponding to each data 
    %                            point in `feature`.
    %
    % Outputs:
    %   lower_bound (double)  - The lower limit of the y-axis for the boxplot.
    %   upper_bound (double)  - The upper limit of the y-axis for the boxplot.

    % Preallocate arrays for lower and upper whiskers for the three groups
    lower_whiskers = zeros(1, 3);
    upper_whiskers = zeros(1, 3);

    % Get the unique class labels (assuming three unique classes)
    maps = unique(class_data, "stable");

    % Loop through each class to calculate the whiskers
    for i = 1:3
        % Extract data for the current class
        class_feature = feature(class_data == maps(i));

        % Calculate the quartiles and the interquartile range (IQR)
        q1 = prctile(class_feature, 25);
        q3 = prctile(class_feature, 75);
        iqr_val = q3 - q1;

        % Calculate the whisker limits for the current class
        lower_whiskers(i) = max(min(class_feature), q1 - 1.5 * iqr_val);
        upper_whiskers(i) = min(max(class_feature), q3 + 1.5 * iqr_val);
    end

    % Determine the y-axis bounds by finding the min and max whiskers
    % Adjust the bounds to ensure the boxplot is not too tight
    lower_bound = min(lower_whiskers) - 0.5 * abs(min(lower_whiskers));
    upper_bound = max(upper_whiskers) + 0.05 * max(upper_whiskers);
end
