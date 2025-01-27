function plot_traces_active_areas(data,env_data,fc,bound_type,sg_title,figure_path)
% plot_traces_active_areas
% 
% This function generates and saves plots of signal traces and their corresponding envelope 
% data for different subjects and map types, with the option to analyze signal boundaries 
% using various methods. It supports three boundary analysis methods: "ActiveArea", 
% "TimeTh" (Time Thresholds), and "Slope_Analysis".
%
% Parameters:
%   - data (struct): A structure containing the raw signal data. The structure is 
%                    organized by map types ('MAP_A', 'MAP_B', 'MAP_C'), subjects, and 
%                    their respective signal traces (rov_trace).
%   - env_data (struct): A structure containing the envelope data corresponding to the 
%                         signals in 'data', structured similarly.
%   - fc (numeric): The sampling frequency of the signals.
%   - bound_type (string): Specifies the boundary analysis type. Options include:
%                          'ActiveArea', 'TimeTh', and 'Slope_Analysis'.
%   - sg_title (string): A general title for the plot, typically describing the experiment 
%                        or dataset.
%   - figure_path (string): The path where the generated plots will be saved.
%
% The function supports the following types of plots based on the specified boundary type:
%   - "ActiveArea": Plots the signal, its envelope, and boundaries based on calculated 
%     upper and lower envelope slopes.
%   - "TimeTh": Highlights specific time thresholds within the signal and its envelope.
%   - "Slope_Analysis": Displays the results of a slope analysis on the signal envelope.
%
% The generated plots are saved with filenames that include the map type, subject number, 
% and record number, providing a detailed log of each generated figure.
%
% Example:
%   plot_traces_active_areas(data, env_data, 1000, 'ActiveArea', 'Signal Analysis', '/path/to/save')

% Define plot types
type_plots = ["single_record"];

% Loop through each map type: A, B, C
for i = ["A", "B", "C"]
    map = 'MAP_' + i;
    subjects = fieldnames(data.(map));

    % Loop through each subject
    for j = 1:length(subjects)
        sub = subjects{j};

        [~, N] = size(data.(map).(sub).rov_trace);
        for h = 1:N
            signal = data.(map).(sub).rov_trace{:,h};
            envelope = env_data.(map).(sub).rov_trace{:,h};
            x = [0:1/fc:1-1/fc]';
            sub_num = split(sub,'_');
            sub_num = split(sub_num{2},i);
            sub_num = sub_num{end};




            [map_upper,map_lower] = analise_envelope_slope(envelope, 0.002, fc);
            switch bound_type
                case "ActiveArea"
                    % Create a new figure
                    fig = figure;
                    fig.WindowState = "maximized";
                    plot(x,signal,"LineWidth",0.8,"Color","#4DBEEE")
                    hold on
                    plot(x,envelope,"LineWidth",1.5,"Color","#0072BD")
                    plot(x, map_upper * min([1, 1/max(signal, [], "omitnan"), max(signal, [], "omitnan")]), "LineWidth", 1.2, "Color", "#A2142F")
                    plot(x, -map_lower * abs(max([-1, 1/min(signal, [], "omitnan"), min(signal, [], "omitnan")])), "LineWidth", 1.2, "Color", "#7E2F8E")
                    title_plot = 'MAP:' + i + ' (' + get_name_of_map(i) + '), sub:' + sub_num + ' trace, record: ' + num2str(h);
                    full_title = {string(sg_title); string(title_plot)};

                    title(full_title, "FontSize", 14)
                    xlim([0, x(end)])
                    xlabel('time [s]')
                    ylabel('Voltage [mV]')
                    % Save the plot
                    file_name = "MAP_" + i + "_sub_" + sub_num + '_record_' + num2str(h) + '_';
                    save_plot(file_name, type_plots(1), figure_path, fig, true);
                case "TimeTh"
                    % Create a new figure
                    fig = figure;
                    fig.WindowState = "maximized";
                    plot(x,signal,"LineWidth",0.8,"Color","#4DBEEE")
                    hold on
                    plot(x,envelope,"LineWidth",1.5,"Color","#0072BD")
                    time_th = define_time_th(map_upper, map_lower);

                    % Plot vertical dashed lines for peaks
                    for k = 1:size(time_th, 1)
                        % Convert index positions to time
                        start_time = time_th(k, 1) / fc; % Start index converted to time
                        end_time = time_th(k, 2) / fc;   % End index converted to time

                        % Plot vertical dashed line for the start of the peak (green)
                        plot([start_time, start_time], ylim, '--', 'LineWidth', 1, 'Color', [0, 0.5, 0]);
                        % Plot vertical dashed line for the end of the peak (red)
                        plot([end_time, end_time], ylim, '--', 'LineWidth', 1, 'Color', [0.5, 0, 0]);
                    end
                    title_plot = 'MAP:' + i + ' (' + get_name_of_map(i) + '), sub:' + sub_num + ' trace, record: ' + num2str(h);
                    full_title = {string(sg_title); string(title_plot)};

                    title(full_title, "FontSize", 14)
                    xlim([0, x(end)])
                    xlabel('time [s]')
                    ylabel('Voltage [mV]')

                    % Save the plot
                    file_name = "MAP_" + i + "_sub_" + sub_num + '_record_' + num2str(h) + '_';
                    save_plot(file_name, type_plots(1), figure_path, fig, true);

                case "Slope_Analysis"
                    show_envelope_slope_analysis(data,env_data,fc,[i,sub_num,h],true,figure_path)
                   
            end




        end
    end
end
end
