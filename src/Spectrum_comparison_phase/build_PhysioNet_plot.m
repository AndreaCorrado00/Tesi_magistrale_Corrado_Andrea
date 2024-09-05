function build_PhysioNet_plot(signals, title_plot, Fc, plot_type,color)

% signals is the field of the struct with all the psd traces for a certain subect
switch plot_type
    case 'mean_and_sd'
        % signals_table=[]; % to be completed
        % for i=2:length(fieldnames(signals))
        % 
        % end
        % 
        % x = [0:Fc/M:Fc-Fc/M];
        % x_lim = [0, 200]; % Define x-axis limits
        % x_label = 'f [Hz]'; % Label for x-axis
        % y_label = 'Spectrum'; % Label for y-axis
        % 
        % 
        % % Calculate the mean signal
        % mean_sig = mean(signals_table, 2);
        % 
        % % Plot the mean signal
        % plot(x, mean_sig, 'k-', "LineWidth", 3)
        % hold on
        % 
        % 
        % 
        % 
        % % Plot mean +/- sd
        % sd_vec= [];
        % for i = 1:M
        %     signals_i =signals_table(i, :);
        %     sd_vec(i)=std(signals_i);
        % end
        % 
        % % Plot the 95% confidence intervals with the same color as the mean
        % plot(x, mean_sig+sd_vec', 'k:', "LineWidth", 0.8);
        % plot(x, mean_sig-sd_vec', 'k:', "LineWidth", 0.8);
        % xlim([0, x(end)]); % Set x-axis limits
        % % Calculate y-axis limits based on the variability limits
        % min_y_lim = min(mean_sig-sd_vec');
        % max_y_lim = max(mean_sig+sd_vec');
        % %ylim([min_y_lim - 0.05 * min_y_lim, max_y_lim + 0.05 * max_y_lim]); % Set y-axis limits
        % title(title_plot); % Set plot title
        % xlabel(x_label); % Set x-axis label
        % ylabel(y_label); % Set y-axis label
        % xlim(x_lim); % Set x-axis limits

        

    case 'single_signal'
        % here a single signal is expected
        M=length(signals(:,1));
        x = [0:Fc/M:Fc-Fc/M];
        x=signals(:,2);
        plot(x, signals(:,1), 'b-', "LineWidth", 2, "Color",color)
        xlabel('f [Hz]'); % Label for x-axis
        ylabel('Spectrum'); % Label for y-axis
        title_plot=title_plot+', n° points: '+num2str(M);
        title(title_plot)
    case 'spaghetti_plot'
        % here a single signal is expected but the color changes
        M=length(signals);
        x = [0:Fc/M:Fc-Fc/M];
      
        plot(x, signals, "LineWidth", 2, "Color",color)
        xlabel('f [Hz]'); % Label for x-axis
        ylabel('Spectrum'); % Label for y-axis
        title(title_plot)
end