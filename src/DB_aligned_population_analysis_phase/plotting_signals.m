function plotting_signals(signals_table, title_plot, Fc, freq_plot, variability_plot, sd_plot)
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
table_or=signals_table;
 if freq_plot
        % If plotting in frequency domain
        % x = [0:Fc/M:Fc-Fc/M]; 
        % Convert signals to power spectrum
        % figure(1)
        % hold on
        % i_anomalies=[];
        for i = 1:N
            signal=prepare_signal(signals_table(:,i),'remove');
            p=evaluate_order(signal,8,20,2,6,'ls');
            th=ar(signal,p,'ls'); 
            [H,x]=freqz(1,th.a,M,Fc); 
            DSP=(abs(H).^2)*th.NoiseVariance;
            signals_table(:, i) = array2table(DSP);
            
            % Improves visualization
            if max(DSP)>40
                signals_table(:,i) = array2table(nan(M,1));
            end

        end

        % for i=1:length(i_anomalies)
        %     t = [0:1/Fc:1-1/Fc]';
        %     figure;
        %     plot(t,table2array(table_or(:,i)))
        %     title(num2str(i)+" record")
        % end

        x_lim = [0, 100]; % Define x-axis limits
        x_label = 'f [Hz]'; % Label for x-axis
        y_label = 'Spectrum'; % Label for y-axis
 else
     for i=1:N
         signal=prepare_signal(signals_table(:,i),'restore');
         signals_table(:, i) = array2table(signal);
     end

    % If plotting in time domain
    x = [0:1/Fc:1-1/Fc]';
    x_lim = [0, x(end)];
    x_label = 'time [s]';
    y_label = 'Voltage [mV]';
end

% Calculate the mean signal
mean_sig = table2array(mean(signals_table, 2,"omitnan"));

% Plot the mean signal

hold on

if ~variability_plot && ~sd_plot
    % If not plotting variability bands, plot individual signals
    for i = 1:N
        plot(x, table2array(signals_table(:,i)), ':', "LineWidth", 0.4,'Color',[.5 .5 .5])
    end
   
    xlim(x_lim)
    min_y_lim = table2array(min(min(signals_table), [], 2));
    max_y_lim = table2array(max(max(signals_table), [], 2));
    %ylim([min_y_lim - 0.05 * min_y_lim, max_y_lim + 0.05 * max_y_lim])
    title('Mean and single records: ' + title_plot + ' (n:' + num2str(N) + ')')
    xlabel(x_label)
    ylabel(y_label)
elseif variability_plot && ~sd_plot
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
    %ylim([min_y_lim - 0.05 * min_y_lim, max_y_lim + 0.05 * max_y_lim])
    title('Mean and confidence intervals at 95%: ' + title_plot + ' (n:' + num2str(N) + ')')
    xlabel(x_label)
    ylabel(y_label)
    xlim(x_lim)
   

elseif sd_plot && ~variability_plot
    % Plot mean +/- sd
        % Calculate variability limits (95% intervals)
        sd_vec= [];
        for i = 1:M
            signals_i =table2array(signals_table(i, :));
            sd_vec(i)=std(signals_i, "omitmissing");
        end

        % Plot the 95% confidence intervals with the same color as the mean
        plot(x, mean_sig+sd_vec', 'k:', "LineWidth", 0.8);
        plot(x, mean_sig-sd_vec', 'k:', "LineWidth", 0.8);
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

plot(x, mean_sig, "Color", "#0072BD", "LineWidth", 1.5)
hold off
end