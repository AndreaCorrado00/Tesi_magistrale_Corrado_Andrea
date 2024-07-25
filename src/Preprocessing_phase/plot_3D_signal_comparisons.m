function [y, z_data, y_label] = plot_3D_signal_comparisons(signals_table, title_plot, Fc, freq_plot, variability_plot)
    % Function to compare signals by plotting them.
    % Inputs:
    % - signals_table: Table containing the signals to be plotted
    % - title_plot: Title of the plot
    % - Fc: Sampling frequency or FFT cutoff frequency
    % - freq_plot: Boolean to determine if the plot should be in frequency domain
    % - variability_plot: Boolean to determine if variability bands (95% intervals) should be plotted
    % Outputs:
    % - y: Array containing the time or frequency values
    % - z_data: Array containing the signal data to be used for 3D plotting
    % - y_label: Label for the y-axis (time or frequency)

    % Get the size of the signals table
    [M, N] = size(signals_table);
    
    if freq_plot
        % If plotting in frequency domain
        y = linspace(0, Fc, M);
        y_label = 'Frequency [Hz]';
        % Convert signals to power spectrum
        for i = 1:N
            p = evaluate_order(signals_table(:,i), 5, 50, 2, 0.05);
            th = ar(table2array(signals_table(:,i)) - table2array(mean(signals_table(:,i))), p, 'ls'); 
            [H, ~] = freqz(1, th.a, M, Fc); 
            DSP = (abs(H) .^ 2) * th.NoiseVariance;
            signals_table(:, i) = array2table(DSP);
        end
    else
        % If plotting in time domain
        y = linspace(0, 1, M);
        y_label = 'Time [s]';
    end

    % Calculate the mean of the signals
    mean_sig = table2array(mean(signals_table, 2));

    % Initialize z_data with the mean signal
    z_data = mean_sig;

    % Plot the mean signal and save its handle
    h_mean = plot(y, mean_sig, "LineWidth", 1);

    % Get the color of the mean line
    mean_color = get(h_mean, 'Color');
    
    if ~variability_plot
        % Plot each individual signal as dotted lines with the same color as the mean
        for i = 1:N
            plot(y, table2array(signals_table(:, i)), ':', "LineWidth", 0.4, 'Color', mean_color);
            z_data = [z_data, table2array(signals_table(:, i))];
        end
        title(['Mean and single records: ', title_plot]); % Set plot title
        xlabel(y_label); % Set x-axis label
        ylabel('Signal Amplitude'); % Set y-axis label
    elseif variability_plot
        % Plot mean and 95% confidence intervals
        up_lim = round(0.95 * length(table2array(signals_table(1, :))));
        down_lim = round(0.05 * length(table2array(signals_table(1, :))));
        if down_lim == 0
            down_lim = 1;
        end

        % Calculate variability limits (95% intervals)
        VAR_LIMS = [];
        for i = 1:M
            signals_i = sort(table2array(signals_table(i, :)));
            VAR_LIMS(i, 1) = signals_i(down_lim);
            VAR_LIMS(i, 2) = signals_i(up_lim);
        end

        % Plot the 95% confidence intervals with the same color as the mean
        plot(y, VAR_LIMS(:, 1), ':', "LineWidth", 0.8, 'HandleVisibility', 'off', 'Color', mean_color);
        plot(y, VAR_LIMS(:, 2), ':', "LineWidth", 0.8, 'HandleVisibility', 'off', 'Color', mean_color);
        title(['Mean and confidence intervals at 95%: ', title_plot]); % Set plot title
        xlabel(y_label); % Set x-axis label
        ylabel('Signal Amplitude'); % Set y-axis label
    end
    
end
