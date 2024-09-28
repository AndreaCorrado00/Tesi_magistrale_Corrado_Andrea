function new_signal = prepare_signal(signal, nan_option)
    % Prepares the signal for analysis by handling NaN values, filtering, scaling, and mean subtraction.
    % Depending on the 'nan_option', either restores NaNs in the signal or returns the signal with NaNs removed.
    %
    % INPUTS:
    %   signal - Input signal, which may be in table format and may contain NaN values.
    %   nan_option - Specifies how to handle NaNs in the signal:
    %                'restore' - Restore NaNs in their original positions after processing.
    %                'remove'  - Remove NaNs from the signal.
    %
    % OUTPUT:
    %   new_signal - Processed signal with NaNs handled according to 'nan_option'.

    % Convert table to array, if necessary
    signal = table2array(signal);

    % Check if there are NaNs and save their positions
    nan_indices = isnan(signal);

    % Remove NaNs from the signal for filtering operations
    signal_without_nans = signal(~nan_indices);

    % Perform wavelet denoising on the signal without NaNs
    new_signal = denoise_ecg_wavelet(signal_without_nans, 2035, 'sym4', 9);

    % % Scale the signal to the range [0, 1]
    % new_signal = (new_signal - max(new_signal)) ./ (max(new_signal) - min(new_signal));

    % Subtract the mean from the scaled signal
    new_signal = new_signal - mean(new_signal);

    % Restore NaNs if the option is 'restore'
    switch nan_option
        case 'restore'
            % Create an array of NaNs with the same size as the original signal
            restored_signal = nan(size(signal));
            % Insert the processed signal into the positions where NaNs were not originally present
            restored_signal(~nan_indices) = new_signal;
            new_signal = restored_signal;
            
        case 'remove'
            % Return the processed signal without NaNs
            % No action needed as NaNs have already been removed
            % and processed signal is returned as is.

        otherwise
            % Handle invalid 'nan_option' input
            error('Invalid option. Use "remove" to return signal without NaNs or "restore" to restore NaNs.');
    end
end
