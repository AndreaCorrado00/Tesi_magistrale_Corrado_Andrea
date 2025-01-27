function plotting_signals(signals_table, title_plot, Fc, freq_plot, variability_plot, sd_plot, what_is_plotted)
    % PLOTTING_SIGNALS Plots signals in either time or frequency domain with options for variability bands.
    %
    % This function visualizes a set of signals either in the time domain or frequency domain. 
    % The user can specify whether to display variability bands (e.g., 95% confidence intervals) 
    % or standard deviation (SD) intervals around the mean signal. The plot also includes options 
    % for signal processing in the frequency domain, such as power spectrum calculation.
    %
    % INPUTS:
    %   signals_table   - A table containing the signal data to be plotted.
    %   title_plot      - A string specifying the title of the plot.
    %   Fc              - Sampling frequency of the signals (Hz).
    %   freq_plot       - Boolean (true/false) to specify whether to plot in the frequency domain.
    %   variability_plot- Boolean (true/false) to specify whether to plot variability bands.
    %   sd_plot         - Boolean (true/false) to specify whether to plot standard deviation intervals.
    %   what_is_plotted - A string specifying what is being plotted (e.g., "ECG", "EEG", etc.) for the title.
    %
    % OUTPUT:
    %   The function generates a plot displaying the signal(s) and, optionally, variability bands or SD intervals.
    %
    % EXAMPLE:
    %   plotting_signals(signals_table, 'Signal Plot', 1000, false, true, false, 'ECG');
    %   % This will plot the signals in time domain with 95% confidence intervals.

    % Get the size of the signals table
    [M, N] = size(signals_table);  % M: number of samples, N: number of signals
    
    if freq_plot
        % If plotting in frequency domain
        x = [0:Fc/M:Fc-Fc/M];  % Frequency vector
        for i = 1:N
            p = evaluate_order(signals_table(:,i), 20, 40, 2, 6, 'ls');
            th = ar(table2array(signals_table(:,i)) - table2array(mean(signals_table(:,i))), p, 'ls');
            [H, ~] = freqz(1, th.a, M, Fc); 
            DSP = (abs(H).^2) * th.NoiseVariance;
            signals_table(:, i) = array2table(DSP);  % Update signal data with power spectrum
        end
        x_lim = [0, 200];  % Define x-axis limits for frequency domain
        x_label = 'f [Hz]';  % Frequency label
        y_label = 'Spectrum';  % Spectrum label
    else
        % If plotting in time domain
        x = [0:1/Fc:1-1/Fc]';  % Time vector
        x_lim = [0, x(end)];
        x_label = 'time [s]';
        y_label = 'Voltage [mV]';
    end

    % Calculate the mean signal
    mean_sig = table2array(mean(signals_table, 2));

    hold on
    if ~variability_plot && ~sd_plot
        % If not plotting variability bands or SD intervals, plot individual signals
        for i = 1:N
            plot(x, table2array(signals_table(:,i)), ':', 'LineWidth', 0.4, 'Color', [0.5, 0.5, 0.5]);
        end
        xlim(x_lim)
        min_y_lim = table2array(min(min(signals_table), [], 2));
        max_y_lim = table2array(max(max(signals_table), [], 2));
        title("Mean and single " + what_is_plotted + ": " + title_plot + " (n:" + num2str(N) + ")");
        xlabel(x_label)
        ylabel(y_label)
    elseif variability_plot && ~sd_plot
        % If plotting variability bands (95% confidence intervals)
        up_lim = round(0.95 * length(table2array(signals_table(1, :))));
        down_lim = round(0.05 * length(table2array(signals_table(1, :))));
        if down_lim == 0
            down_lim = 1;
        end

        VAR_LIMS = [];
        for i = 1:M
            signals_i = sort(table2array(signals_table(i, :)));
            VAR_LIMS(i, 1) = signals_i(down_lim);
            VAR_LIMS(i, 2) = signals_i(up_lim);
        end
        
        % Plot the confidence intervals
        plot(x, VAR_LIMS(:,1), 'k:', 'LineWidth', 0.8)
        plot(x, VAR_LIMS(:,2), 'k:', 'LineWidth', 0.8)
        xlim([0, x(end)])
        min_y_lim = min(VAR_LIMS(:,1));
        max_y_lim = max(VAR_LIMS(:,2));
        title('Mean and confidence intervals at 95%: ' + title_plot + ' (n:' + num2str(N) + ')');
        xlabel(x_label)
        ylabel(y_label)
        xlim(x_lim)

    elseif sd_plot && ~variability_plot
        % If plotting SD bands (Mean +/- SD)
        sd_vec = [];
        for i = 1:M
            signals_i = table2array(signals_table(i, :));
            sd_vec(i) = std(signals_i);  % Compute standard deviation
        end

        % Plot the SD intervals
        plot(x, mean_sig + sd_vec', 'k:', 'LineWidth', 0.8);
        plot(x, mean_sig - sd_vec', 'k:', 'LineWidth', 0.8);
        xlim([0, x(end)]);
        min_y_lim = min(mean_sig - sd_vec');
        max_y_lim = max(mean_sig + sd_vec');
        title(['Mean +/- SD : ', title_plot]);
        xlabel(x_label);
        ylabel(y_label);
        xlim(x_lim);
    end
    % Plot the mean signal
    plot(x, mean_sig, 'Color', '#0072BD', 'LineWidth', 1.5);
    hold off
end
