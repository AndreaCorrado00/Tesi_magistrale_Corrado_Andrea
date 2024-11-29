function show_traces_filtering_pipeline(data,fc,plot_type,sg_title,figure_path)

    
% Define plot types
type_plots = ["single_record"];


% Loop through each map type: A, B, C
for i = ["A", "B", "C"]
    map = 'MAP_' + i;
    subjects = fieldnames(data.(map));

    % Loop through each subject
    for j =  1:length(subjects)
        sub = subjects{j};
       


        [~, N] = size(data.(map).(sub).rov_trace);
        % Extraction of signals from the input data structure

        sub_num=split(sub,'_');
        sub_num=split(sub_num{2},i);
        sub_num=sub_num{end};

        Fs = 2035; % Sampling frequency
        traces = ["Rov trace", "Ref trace", "Spare1 trace", "Spare2 trace", "Spare3 trace"];
        for h=1:N
            rov = data.(map).(sub).rov_trace{:,h};
            ref = data.(map).(sub).ref_trace{:,h};
            spare1 = data.(map).(sub).spare1_trace{:,h};
            spare2 = data.(map).(sub).spare2_trace{:,h};
            spare3 = data.(map).(sub).spare3_trace{:,h};

            tab_signals = [rov, ref, spare1, spare2, spare3];
         
            t = [0:1/fc:1-1/fc]';


           
            switch plot_type
                case "rov_trace_filtering"
                    fig = figure(1);
                    title_plot = 'MAP:' + i + ' (' + get_name_of_map(i) + '), sub:' + sub_num +' trace, record: '+num2str(h);
                    full_title={string(sg_title);string(title_plot)};

                    % filtering rov trace
                    x = rov - mean(rov,1,"omitnan"); % Remove DC offset

                    % BP Filtering
                    x_BP = handable_denoise_ecg_BP(x, fc, 2, 60);

                    plot(t,x,"LineWidth",0.8,"Color","#4DBEEE","LineStyle",":")
                    hold on
                    plot(t,x_BP,"LineWidth",1.2,"Color","#0072BD")

                    xlim([0, t(end)])
                    ylim([min([min(x,[],"omitnan"),min(x_BP,[],"omitnan")]) - 0.2 * abs(min([min(x,[],"omitnan"),min(x_BP,[],"omitnan")])), max([max(x,[],"omitnan"),max(x_BP,[],"omitnan")]) + 0.2 * abs(max([max(x,[],"omitnan"),max(x_BP,[],"omitnan")]))]);

                    xlabel('time [s]')
                    ylabel('Voltage [mV]')
                    legend('Original', 'BP Filter', "Location", "bestoutside")

                    title(full_title,"FontSize",14)

                case "whole_signal_set"
                    % Create a new figure
                    fig = figure(1);
                    fig.WindowState = "maximized";
                    title_plot = 'MAP:' + i + ' (' + get_name_of_map(i) + '), sub:' + sub_num +' trace, record: '+num2str(h);
                    full_title={string(sg_title),string(title_plot)};

                  
                    traces = ["Rov trace", "Ref trace", "Spare1 trace", "Spare2 trace", "Spare3 trace"];
                    for l = 1:5

                        x = tab_signals(:,l) - mean(tab_signals(:,l)); % Remove DC offset

                        % BP Filtering
                        x_BP = handable_denoise_ecg_BP(x, Fs, 2, 60);

                        % Plotting results
                        subplot(3,2,l)
                        % plot(t, x, 'k:', t, x_w, 'b-', t, x_BP, 'r-')
                        plot(t,x,"LineWidth",0.8,"Color","#4DBEEE","LineStyle",":")
                        hold on
                        plot(t,x_BP,"LineWidth",1.2,"Color","#0072BD")
                        ylim([min([min(x,[],"omitnan"),min(x_BP,[],"omitnan")]) - 0.2 * abs(min([min(x,[],"omitnan"),min(x_BP,[],"omitnan")])), max([max(x,[],"omitnan"),max(x_BP,[],"omitnan")]) + 0.2 * abs(max([max(x,[],"omitnan"),max(x_BP,[],"omitnan")]))]);
                        xlabel('Time [s]')
                        ylabel('Amplitude [mV]')
                        title(traces(l))
                    end
                    legend('Original', 'BP Filter', "Location", "bestoutside")

                    sgtitle(full_title)
            end
            % Save the plot
            file_name="MAP_"+i+"_sub_"+sub_num+'_record_'+num2str(h)+'_';
            save_plot(file_name, type_plots(1), figure_path, fig, true);
        end
    end
end
end
