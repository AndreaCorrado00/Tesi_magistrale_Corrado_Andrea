function show_scalogram_AVNRT_data(data, title_plot, filter, log_scale)
    % Function to generate and display scalograms for different ECG traces of a single subject.
    %
    % INPUTS:
    %   data - Struct containing ECG traces for a single subject
    %   title_plot - Title for the plot
    %   filter - Boolean indicating whether to apply denoising
    %   log_scale - Boolean indicating whether to use logarithmic scale for scalogram
    %
    % OUTPUT:
    %   None. The function displays figures showing scalograms for each trace.

    %% Starting of simulation

    % Extract signals
    rov = data.rov_trace{:,1};
    ref = data.ref_trace{:,1};
    spare1 = data.spare1_trace{:,1};
    spare2 = data.spare2_trace{:,1};
    spare3 = data.spare3_trace{:,1};

    tab_signals = [rov, ref, spare1, spare2, spare3];
    Fs = 2035; % Sampling frequency in Hz
    traces = ["Rov trace", "Ref trace", "Spare1 trace", "Spare2 trace", "Spare3 trace"];

    % Create figure for scalograms
    figure;
    sgtitle(title_plot)
    for i = 1:5
        subplot(3, 2, i)
        
        x = tab_signals(:,i) - mean(tab_signals(:,i));
        if filter
            x = denoise_ecg_wavelet(x, Fs, 'sym4', 9);
        end
        N = length(x);
        Ts = 1 / Fs;
        t = 0:Ts:Ts*N-Ts;

        % CWT filterbank decomposition
        fb = cwtfilterbank('SignalLength', N, ...
            'SamplingFrequency', Fs, ...
            'VoicesPerOctave', 12, ...
            'Wavelet', 'morse');

        % Calculate the scalogram
        [coefficients, frequencies] = cwt(x, 'FilterBank', fb);

        if log_scale
            scalogram_values = log10(abs(coefficients).^2 + eps); 
        else
            scalogram_values = abs(coefficients).^2;
        end

        % Plot the scalogram
        contourf(t, frequencies, scalogram_values, 200, 'LineColor', 'none');
        xlabel('Time (s)');
        ylabel('Frequency (Hz)');
        ylim([0, 120])
        title(traces(i));
        colorbar;
    end

    % Plot whole signal and scalogram
    for i = 1:5
        figure;
        sgtitle(title_plot + "," + traces(i))
        x = tab_signals(:,i) - mean(tab_signals(:,i));
        if filter
            x = denoise_ecg_wavelet(x, Fs, 'sym4', 9);
        end
        N = length(x);
        Ts = 1 / Fs;
        t = 0:Ts:Ts*N-Ts;

        % CWT filterbank decomposition
        fb = cwtfilterbank('SignalLength', N, ...
            'SamplingFrequency', Fs, ...
            'VoicesPerOctave', 12, ...
            'Wavelet', 'morse');

        % Calculate the scalogram
        [coefficients, frequencies] = cwt(x, 'FilterBank', fb);

        if log_scale
            scalogram_values = log10(abs(coefficients).^2 + eps); 
        else
            scalogram_values = abs(coefficients).^2;
        end

        % Plot whole signal and scalogram
        subplot(3, 3, 1:3)
        plot(t, x, 'b-')
        ylabel('Amplitude [mV]')
        subplot(3, 3, 4:9)
        contourf(t, frequencies, scalogram_values, 200, 'LineColor', 'none');
        xlabel('Time (s)');
        ylabel('Frequency (Hz)');
        ylim([0, 120])
        colorbar('Location', 'southoutside');
    end
end
