function new_signal = prepare_signal(signal, nan_option)

% Convert table to array, if necessary
signal = table2array(signal);

% Check if there are NaNs and save their positions
nan_indices = isnan(signal);

% Remove NaNs from the signal for the operations
signal_without_nans = signal(~nan_indices);

% Perform filtering on the signal without NaNs
new_signal = denoise_ecg_wavelet(signal_without_nans, 2035, 'sym4', 9);

% Scale the signal
new_signal = (new_signal - max(new_signal)) ./ (max(new_signal) - min(new_signal));

% Subtract the mean
new_signal = new_signal - mean(new_signal);

% Restore NaNs if the option is 'restore'
switch nan_option
    case 'restore'
        % Create a signal array of NaNs the same size as the original
        restored_signal = nan(size(signal));
        % Insert the processed signal where NaNs were not originally present
        restored_signal(~nan_indices) = new_signal;
        new_signal = restored_signal;
        
    case 'remove'
        % No action needed, return the processed signal without NaNs
        
    otherwise
        error('Invalid option. Use "remove" to return signal without NaNs or "restore" to restore NaNs.');
end

end
