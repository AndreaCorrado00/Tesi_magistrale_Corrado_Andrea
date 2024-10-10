function spaghetti_confidence_signals(data, fc, figure_path)
% SPAGHETTI_CONFIDENCE_SIGNALS Generate and save plots for multiple signal types.
%
%   SPAGHETTI_CONFIDENCE_SIGNALS(DATA, FC, FIGURE_PATH) creates spaghetti and confidence
%   plots for both time and frequency domains for each signal in the provided dataset.
%   The plots are saved to the specified path.
%
%   Inputs:
%       DATA - Struct, containing the processed map data organized by map type and index.
%       FC - Numeric, the cutoff frequency for filtering signals.
%       FIGURE_PATH - String, the directory path where the plots will be saved.

% Define combinations of plot types
table_pox = [false, false,false;
    false, true,false;
    false, false, true;
    true, false, false;
    true, true, false;
    true, false, true];

% Define plot types
type_plots = ["spaghetti"; "confidence";"mean_sd"; "spaghetti_freq"; "confidence_freq";"mean_sd_freq"];

% Loop through each plot type combination
for l = 1:3
    % Loop through each map type: A, B, C
    for i = ["A", "B", "C"]
        map = 'MAP_' + i;
        % Loop through each trace type
        for k = "rov" %["rov", "ref", "spare1", "spare2", "spare3"]
            trace = k + '_trace';
            title_plot = 'MAP:' + i + ' (' + get_name_of_map(i) + '), population' + ', trace: ' + k;

            % Create a new figure
            fig = figure(1);
            fig.WindowState = "maximized";

            % Plot the signals
            plotting_signals(data.(map).(trace), title_plot, fc, table_pox(l, 1), table_pox(l, 2), table_pox(l,3));

            % Get the current figure
            fig = gcf;

            % Save the plot            
            file_name="MAP_"+i+"_trace_"+k+"_";
            save_plot(file_name, type_plots(l), figure_path + "\data_visual", fig, true);
        end
    end
end
end


