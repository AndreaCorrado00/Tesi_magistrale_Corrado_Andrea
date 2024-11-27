function rov_trace_plots_by_sub(data,env_data, fc,plot_type,sg_title,figure_path)

    
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
        for h=1:N


            signal=data.(map).(sub).rov_trace{:,h};
            envelope=env_data.(map).(sub).rov_trace{:,h};
         
            x = [0:1/fc:1-1/fc]';

            sub_num=split(sub,'_');
            sub_num=split(sub_num{2},i);
            sub_num=sub_num{end};

            % Create a new figure
            fig = figure(1);
            fig.WindowState = "maximized";

            title_plot = 'MAP:' + i + ' (' + get_name_of_map(i) + '), sub:' + sub_num +' trace, record: '+num2str(h);
            full_title={string(sg_title);string(title_plot)};

            switch plot_type
                case "envelope_or_cross"

                    plot(x,signal,"LineWidth",0.8,"Color","#4DBEEE")
                    hold on
                    plot(x,envelope,"LineWidth",1.5,"Color","#0072BD")

                    xlim([0, x(end)])
                    ylim([min([min(signal,[],"omitnan"),min(envelope,[],"omitnan")]) - 0.2 * abs(min([min(signal,[],"omitnan"),min(envelope,[],"omitnan")])), max([max(signal,[],"omitnan"),max(envelope,[],"omitnan")]) + 0.2 * abs(max([max(signal,[],"omitnan"),max(envelope,[],"omitnan")]))]);

                    xlabel('time [s]')
                    ylabel('Voltage [mV]')

                    title(full_title,"FontSize",14)
                case "STFT"
                    % Spectrogram
                    n = length(signal); % Signal length
                    t_signal = [0:1/fc:(n-1)/fc]'; % signal time

                    % STFT parameters definition
                    win_length = 64; % length of the window (points)
                    hop_size = round(win_length / 3); % 30% superposition
                    window = hamming(win_length, 'periodic'); % Hamming window
                    nfft = 1048; % FFT evaluation points
                    ax1 = subplot(3, 3, 1:6); 

                    [S, F, T, P] = spectrogram(signal, window, hop_size, nfft, fc); 
                    imagesc(T, F, 10*log10(P)); 
                    axis tight;
                    set(gca, 'YDir', 'normal'); 
                    title(full_title,"FontSize",14)

                    xlabel('Time [s]');
                    ylabel('Frequency [Hz]');
                    ylim([0,400])
            
                    hColorbar = colorbar('southoutside'); 
                    ylabel(hColorbar, 'Power/Frequency [dB/Hz]');

                    subplot(3, 3, 7:9);
                    plot(t_signal, signal, 'b');
                    title('Original Signal');
                    xlabel('Time [s]');
                    ylabel('Amplitude [mV]');
                    grid on;

                    linkaxes(findall(gcf, 'Type', 'axes'), 'x');
            end
            % Save the plot
            file_name="MAP_"+i+"_sub_"+sub_num+'_record_'+num2str(h)+'_';
            save_plot(file_name, type_plots(1), figure_path, fig, true);
        end
    end
end
end
