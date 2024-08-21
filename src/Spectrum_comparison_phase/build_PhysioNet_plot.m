function build_PhysioNet_plot(signals, title_plot, Fc, mean_sd_plot)

signals_table=signals_table';
% Get the size of the signals table
[M, N] = size(signals_table);

 if freq_plot
        % If plotting in frequency domain
        x = [0:Fc/M:Fc-Fc/M]; 
        % Convert signals to power spectrum
        for i = 1:N
            p=evaluate_order(signals_table(:,i),5,50,2,0.05); 
            th=ar(signals_table(:,i)-mean(signals_table(:,i)),p,'ls'); 
            [H,~]=freqz(1,th.a,M,Fc); 
            DSP=(abs(H).^2)*th.NoiseVariance;
            signals_table(:, i) = DSP;
        end
        x_lim = [0, 200]; % Define x-axis limits
        x_label = 'f [Hz]'; % Label for x-axis
        y_label = 'Spectrum'; % Label for y-axis
else
    % If plotting in time domain
    duration=1/Fc*M;
    x= linspace(0,duration,M);
    x_lim = [0, x(end)];
    x_label = 'time [s]';
    y_label = 'Voltage [mV]';
end

% Calculate the mean signal
mean_sig = mean(signals_table, 2);

% Plot the mean signal
plot(x, mean_sig, 'k-', "LineWidth", 3)
hold on

if ~variability_plot && ~sd_plot
    % If not plotting variability bands, plot individual signals
    for i = 1:N
        plot(x, signals_table(:,i), ':', "LineWidth", 0.4)
    end
    hold off
    xlim(x_lim)
    min_y_lim = (min(min(signals_table), [], 2));
    max_y_lim = (max(max(signals_table), [], 2));
    %ylim([min_y_lim - 0.05 * min_y_lim, max_y_lim + 0.05 * max_y_lim])
    title(title_plot)
    xlabel(x_label)
    ylabel(y_label)
elseif variability_plot && ~sd_plot
    % If plotting variability bands (95% confidence intervals)
    up_lim = round(0.95 * length(signals_table(1,:)));
    down_lim = round(0.05 * length(signals_table(1,:)));
    if down_lim == 0
        down_lim = 1;
    end

    VAR_LIMS = [];
    for i = 1:M
        signals_i = sort(signals_table(i,:));
        VAR_LIMS(i, 1) = signals_i(down_lim);
        VAR_LIMS(i, 2) = signals_i(up_lim);
    end
    
    % Plot the confidence intervals
    plot(x, VAR_LIMS(:,1), 'k:', "LineWidth", 0.8)
    plot(x, VAR_LIMS(:,2), 'k:', "LineWidth", 0.8)
    xlim([0, x(end)])
    min_y_lim = min(VAR_LIMS(:,1));
    max_y_lim = max(VAR_LIMS(:,2));
    %ylim([min_y_lim - 0.05 * min_y_lim, max_y_lim + 0.05 * max_y_lim])
    title(title_plot)
    xlabel(x_label)
    ylabel(y_label)
    xlim(x_lim)
    hold off

elseif sd_plot && ~variability_plot
    % Plot mean +/- sd
        % Calculate variability limits (95% intervals)
        sd_vec= [];
        for i = 1:M
            signals_i =signals_table(i, :);
            sd_vec(i)=std(signals_i);
        end

        % Plot the 95% confidence intervals with the same color as the mean
        plot(x, mean_sig+sd_vec', 'k:', "LineWidth", 0.8);
        plot(x, mean_sig-sd_vec', 'k:', "LineWidth", 0.8);
        xlim([0, x(end)]); % Set x-axis limits
        % Calculate y-axis limits based on the variability limits
        min_y_lim = min(mean_sig-sd_vec');
        max_y_lim = max(mean_sig+sd_vec');
        %ylim([min_y_lim - 0.05 * min_y_lim, max_y_lim + 0.05 * max_y_lim]); % Set y-axis limits
        title(title_plot); % Set plot title
        xlabel(x_label); % Set x-axis label
        ylabel(y_label); % Set y-axis label
        xlim(x_lim); % Set x-axis limits
end

end