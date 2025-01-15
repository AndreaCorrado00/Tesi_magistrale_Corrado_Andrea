function show_features_statistics(features_tab,save,figure_path)
feature_names=features_tab.Properties.VariableNames;

classes=features_tab(:,feature_names(end));
feature_names=feature_names(1:end-1);

for i = 3:length(feature_names)
    % Get the feature name
    feature_name = feature_names{i};
    % Call the plot_feature_boxplots function for each feature
    plot_feature_boxplots(features_tab, classes, feature_name);
    if save
        save_plot(feature_name,"_boxplot",figure_path,gcf,true)
    end

end


% Loop through each class (MAP_A, MAP_B, MAP_C)
unique_classes=unique(classes);
for i = 1:height(unique_classes) % Assuming 'classes' corresponds to the map types
    map_type = unique_classes{i,:}; % Get the map type name (MAP_A, MAP_B, etc.)
    
    % Initialize counters for signals with 1, 2, and 3 peaks
    N1 = 0; N2 = 0; N3 = 0;N_more=0;
    map_class=table2array(classes)==map_type;
    % Get the rows corresponding to the current map type
    class_data = features_tab(map_class,:); 
    
    % Loop through the signals in the class and count the number of peaks
    for j = 1:height(class_data)
        % Get the number of peaks for the current signal (using the 'n_peaks' feature)
        n_peaks = class_data.active_areas_number(j);
        
        % Count how many peaks are there
        if n_peaks == string(1)
            N1 = N1 + 1;
        elseif n_peaks == string(2)
            N2 = N2 + 1;
        elseif n_peaks == string(3)
            N3 = N3 + 1;
        elseif n_peaks > string(3)
            N_more=N_more+1;
        end
    end
    % Print the result for the current map type (e.g., MAP_A, MAP_B, MAP_C)
    fprintf('%s has:\n', map_type);
    fprintf('  - %d signals with one active area\n', N1);
    fprintf('  - %d signals with two active areas\n', N2);
    fprintf('  - %d signals with three active areas\n', N3);
    fprintf('  - %d signals with more than three active areas\n', N_more);
    fprintf('        total : %d \n ',N1+N2+N3+N_more)
    
    
end