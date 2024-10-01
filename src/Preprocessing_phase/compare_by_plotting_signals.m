function compare_by_plotting_signals(signals_table, title_plot, Fc, freq_plot, variability_plot,sd_plot)
    % Function to compare signals by plotting them.
    % Inputs:
    % - signals_table: Table containing the signals to be plotted
    % - title_plot: Title of the plot
    % - Fc: Sampling frequency or FFT cutoff frequency
    % - freq_plot: Boolean to determine if the plot should be in frequency domain
    % - variability_plot: Boolean to determine if variability bands (95% intervals) should be plotted
    
    % Get the size of the signals table
    [M, N] = size(signals_table);
    
    if freq_plot
        % If plotting in frequency domain
        x = [0:Fc/M:Fc-Fc/M]; 
        % Convert signals to power spectrum
        for i = 1:N
            p=evaluate_order(signals_table(:,i),20,40,2,6,'ls');
            th=ar(table2array(signals_table(:,i))-table2array(mean(signals_table(:,i))),p,'ls'); 
            [H,~]=freqz(1,th.a,M,Fc); 
            DSP=(abs(H).^2)*th.NoiseVariance;
            signals_table(:, i) = array2table(DSP);
        end
        x_lim = [0, 200]; % Define x-axis limits
        x_label = 'f [Hz]'; % Label for x-axis
        y_label = 'Spectrum'; % Label for y-axis
    else
        % If plotting in time domain
        x = [0:1/Fc:1-1/Fc]';
        x_lim = [0, x(end)]; % Define x-axis limits
        x_label = 'time [s]'; % Label for x-axis
        y_label = 'Voltage [mV]'; % Label for y-axis
    end

    % Calculate the mean of the signals
    mean_sig = table2array(mean(signals_table, 2));

    % Plot the mean signal and save its handle
    h_mean = plot(x, mean_sig, "LineWidth", 1);
    hold on;

    % Get the color of the mean line
    mean_color = get(h_mean, 'Color');
    
    if ~variability_plot && ~sd_plot
        % Plot each individual signal as dotted lines with the same color as the mean
        for i = 1:N
            plot(x, table2array(signals_table(:, i)), ':', "LineWidth", 0.4, 'Color', mean_color);
        end
        xlim(x_lim); % Set x-axis limits
        % Calculate y-axis limits based on the min and max of the signals
        min_y_lim = table2array(min(min(signals_table), [], 2));
        max_y_lim = table2array(max(max(signals_table), [], 2));
        %ylim([min_y_lim - 0.05 * min_y_lim, max_y_lim + 0.05 * max_y_lim]); % Set y-axis limits
        title(['Mean and single records: ', title_plot]); % Set plot title
        xlabel(x_label); % Set x-axis label
        ylabel(y_label); % Set y-axis label

    elseif variability_plot && ~sd_plot
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
        plot(x, VAR_LIMS(:, 1), ':', "LineWidth", 0.8, 'HandleVisibility', 'off', 'Color', mean_color);
        plot(x, VAR_LIMS(:, 2), ':', "LineWidth", 0.8, 'HandleVisibility', 'off', 'Color', mean_color);
        xlim([0, x(end)]); % Set x-axis limits
        % Calculate y-axis limits based on the variability limits
        min_y_lim = min(VAR_LIMS(:, 1));
        max_y_lim = max(VAR_LIMS(:, 2));
        %ylim([min_y_lim - 0.05 * min_y_lim, max_y_lim + 0.05 * max_y_lim]); % Set y-axis limits
        title(['Mean and confidence intervals at 95%: ', title_plot]); % Set plot title
        xlabel(x_label); % Set x-axis label
        ylabel(y_label); % Set y-axis label
        xlim(x_lim); % Set x-axis limits

     elseif sd_plot && ~variability_plot
        % Plot mean +/- sd
        % Calculate variability limits (95% intervals)
        sd_vec= [];
        for i = 1:M
            signals_i =table2array(signals_table(i, :));
            sd_vec(i)=std(signals_i);
        end

        % Plot the 95% confidence intervals with the same color as the mean
        plot(x, mean_sig+sd_vec', ':', "LineWidth", 0.8, 'HandleVisibility', 'off', 'Color', mean_color);
        plot(x, mean_sig-sd_vec', ':', "LineWidth", 0.8, 'HandleVisibility', 'off', 'Color', mean_color);
        xlim([0, x(end)]); % Set x-axis limits
        % Calculate y-axis limits based on the variability limits
        min_y_lim = min(mean_sig-sd_vec');
        max_y_lim = max(mean_sig+sd_vec');
        %ylim([min_y_lim - 0.05 * min_y_lim, max_y_lim + 0.05 * max_y_lim]); % Set y-axis limits
        title(['Mean +/- SD : ', title_plot]); % Set plot title
        xlabel(x_label); % Set x-axis label
        ylabel(y_label); % Set y-axis label
        xlim(x_lim); % Set x-axis limits
    end
end
