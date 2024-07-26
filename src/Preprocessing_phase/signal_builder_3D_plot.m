function [y, z_data] = signal_builder_3D_plot(signals_table, Fc, freq_plot)
    % signal_builder_3D_plot builds a 3D plot-ready signal representation.
    % Inputs:
    %   signals_table: 2D table of signals where each column represents a signal.
    %   Fc: Cutoff frequency for frequency domain analysis.
    %   freq_plot: Flag (boolean) indicating whether to plot in frequency domain (true) or time domain (false).
    % Outputs:
    %   y: Vector representing the x-axis values (time or frequency).
    %   z_data: Vector representing the z-axis values (signal power spectrum or mean signal).

    % Get the size of the signals table
    [M, N] = size(signals_table);
    
    if freq_plot
        % If plotting in frequency domain
        y = linspace(0, Fc, M); % Generate frequency axis from 0 to Fc
        % Convert signals to power spectrum
        for i = 1:N
            % Estimate model order for autoregressive (AR) model
            p = evaluate_order(signals_table(:,i), 5, 50, 2, 0.05);
            % Fit AR model coefficients
            th = ar(table2array(signals_table(:,i)) - table2array(mean(signals_table(:,i))), p, 'ls'); 
            % Compute frequency response of AR model
            [H, ~] = freqz(1, th.a, M, Fc); 
            % Compute power spectral density (DSP)
            DSP = (abs(H) .^ 2) * th.NoiseVariance;
            % Update signals_table with power spectrum
            signals_table(:, i) = array2table(DSP);
        end
    else
        % If plotting in time domain
        y = linspace(0, 1, M); % Generate time axis from 0 to 1
    end

    % Calculate the mean of the signals
    mean_sig = table2array(mean(signals_table, 2));

    % Initialize z_data with the mean signal
    z_data = mean_sig;
    
end
