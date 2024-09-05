function plotting_PhysioNet_signals(data, labels, figure_path, Fc, plot_type, saving)
switch plot_type
    case  'single_signal'
        signals_names=fieldnames(data);

        for i=1:length(signals_names)
            signals_group=data.(signals_names{i});
            windows_names=fieldnames(signals_group);
            for j=1:length(windows_names)
                fig = figure(1);
                fig.WindowState = "maximized";

                % Define the title for the plot
                class=get_class_name(string(labels(i)));
                title_plot = "Spectrum for signal: "+num2str(i)+", class: "+class;

                % Build and display the plot based on the specified type
                build_PhysioNet_plot(data.(signals_names{i}).(windows_names{j}), title_plot, Fc,plot_type,'b')


                % Get the current figure
                fig = gcf;

                % Save the plot if 'saving' is true
                if saving
                    file_name = "Single_spectrum_Sub_" + num2str(i) + "_Physionet_eval_points_"+num2str(length(data.(signals_names{i}).(windows_names{j})));
                    save_plot(file_name, plot_type, fullfile(figure_path, "single_spectrums"), fig, true);

                else
                    % Pause to allow viewing and then close the figure if not saving
                    pause(3);
                    close(fig);
                end

            end

        end
  
        case  'spaghetti_plot'
        signals_names=fieldnames(data);

        for i=1:length(signals_names)
            signals_group=data.(signals_names{i});
            windows_names=fieldnames(signals_group);
            fig = figure(1);
            fig.WindowState = "maximized";
            legend_entries={};
            hold on
            % Generate a custom colormap with unique colors
            num_signals = length(windows_names);
            cmap = distinguishable_colors(num_signals);
            cmap=hsv(num_signals);

            for j = 1:num_signals
                % Define the title for the plot
                class = get_class_name(string(labels(i)));
                title_plot = "Spectrums for signal: " + num2str(i) + ", class: " + class;

                % Build and display the plot with the unique color
                build_PhysioNet_plot(data.(signals_names{i}).(windows_names{j}), title_plot, Fc, plot_type, cmap(j, :))

                legend_entries{j} = "signal length: " + num2str(length(data.(signals_names{i}).(windows_names{j})));
            end
            hold off
            legend(legend_entries);
            % Get the current figure
            fig = gcf;

            % Save the plot if 'saving' is true
            if saving
                file_name = "Spectrum_Sub_" + num2str(i) + "_Physionet_eval_points";
                save_plot(file_name, plot_type, fullfile(figure_path,"Spaghetti_plots"), fig, true);
            else
                % Pause to allow viewing and then close the figure if not saving
                pause(3);
                close(fig);
            end
        end

end