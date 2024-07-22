function plotting_signals(signals_table, title_plot, Fc, freq_plot, variability_plot)
% plotting_signals plots the signals in either time or frequency domain with options for variability bands.
%
% Inputs:
%   - signals_table: Table containing the signal data.
%   - title_plot: String specifying the title of the plot.
%   - Fc: Sampling frequency.
%   - freq_plot: Boolean indicating whether to plot in frequency domain.
%   - variability_plot: Boolean indicating whether to plot variability bands.
%

% Get the size of the signals table
[M, N] = size(signals_table);

 if freq_plot
        % If plotting in frequency domain
        x = [0:Fc/M:Fc-Fc/M]; 
        % Convert signals to power spectrum
        for i = 1:N
            th=ar(table2array(signals_table(:,i))-table2array(mean(signals_table(:,i))),20,'yw'); 
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
    x_lim = [0, x(end)];
    x_label = 'time [s]';
    y_label = 'Voltage [mV]';
end

% Calculate the mean signal
mean_sig = table2array(mean(signals_table, 2));

% Plot the mean signal
plot(x, mean_sig, 'k-', "LineWidth", 3)
hold on

if ~variability_plot
    % If not plotting variability bands, plot individual signals
    for i = 1:N
        plot(x, table2array(signals_table(:,i)), ':', "LineWidth", 0.4)
    end
    hold off
    xlim(x_lim)
    min_y_lim = table2array(min(min(signals_table), [], 2));
    max_y_lim = table2array(max(max(signals_table), [], 2));
    ylim([min_y_lim - 0.05 * min_y_lim, max_y_lim + 0.05 * max_y_lim])
    title('Mean and single records: ' + title_plot + ' (n:' + num2str(N) + ')')
    xlabel(x_label)
    ylabel(y_label)
else
    % If plotting variability bands (95% confidence intervals)
    up_lim = round(0.95 * length(table2array(signals_table(1,:))));
    down_lim = round(0.05 * length(table2array(signals_table(1,:))));
    if down_lim == 0
        down_lim = 1;
    end

    VAR_LIMS = [];
    for i = 1:M
        signals_i = sort(table2array(signals_table(i,:)));
        VAR_LIMS(i, 1) = signals_i(down_lim);
        VAR_LIMS(i, 2) = signals_i(up_lim);
    end
    
    % Plot the confidence intervals
    plot(x, VAR_LIMS(:,1), 'k:', "LineWidth", 0.8)
    plot(x, VAR_LIMS(:,2), 'k:', "LineWidth", 0.8)
    xlim([0, x(end)])
    min_y_lim = min(VAR_LIMS(:,1));
    max_y_lim = max(VAR_LIMS(:,2));
    ylim([min_y_lim - 0.05 * min_y_lim, max_y_lim + 0.05 * max_y_lim])
    title('Mean and confidence intervals at 95%: ' + title_plot + ' (n:' + num2str(N) + ')')
    xlabel(x_label)
    ylabel(y_label)
    xlim(x_lim)
    hold off
end

end
