function x_denoised = handable_denoise_ecg_BP(x, Fc, BP_pass_band, BP_band_stop)
    % This function denoises an ECG signal using a customizable band-stop filter.
    % INPUTS:
    %   x            - The raw ECG signal.
    %   Fc           - The sampling frequency of the ECG signal.
    %   BP_pass_band - The cutoff frequency for the high-pass filter.
    %   BP_band_stop - The cutoff frequency for the low-pass filter.
    % OUTPUT:
    %   x_denoised   - The denoised ECG signal after applying high-pass and low-pass filters.
    
    % High pass filter to remove baseline drift
    [b_hp, a_hp] = butter(6, BP_pass_band / (Fc / 2), 'high');
    x_denoised = filtfilt(b_hp, a_hp, x);

    % Low pass filter with customizable cutoff frequency
    [b_lp, a_lp] = butter(6, BP_band_stop / (Fc / 2), 'low');
    x_denoised = filtfilt(b_lp, a_lp, x_denoised);
    
    % Frequency response analysis
    [H_hp, f_hp] = freqz(b_hp, a_hp, 1024, Fc);
    [H_lp, f_lp] = freqz(b_lp, a_lp, 1024, Fc);
    
    % Compute the cascaded frequency response
    H_bp = H_hp .* H_lp; 
    f_bp = f_hp; 
    
    % % Plot frequency responses
    % figure;
    % subplot(1,3, 1);
    % plot(f_lp, abs(H_lp), 'LineWidth', 1.5);
    % title(['LP filter response (cutoff = ' num2str(BP_band_stop) ' Hz)'],"FontSize",18);
    % xlabel('Frequency (Hz)',"FontSize",14); ylabel('Magnitude',"FontSize",14); grid on;
    % xlim([0,200])
    % ylim([0,1.1])
    % 
    % subplot(1,3, 2);
    % plot(f_hp, abs(H_hp), 'LineWidth', 1.5);
    % title(['HP filter response (cutoff = ' num2str(BP_pass_band) ' Hz)'],"FontSize",18);
    % xlabel('Frequency (Hz)',"FontSize",14); ylabel('Magnitude',"FontSize",14); grid on;
    % xlim([0,200])
    % ylim([0,1.1])
    % subplot(1,3, 3);
    % plot(f_bp, abs(H_bp), 'LineWidth', 1.5);
    % title(['BP filter response (' num2str(BP_pass_band) ' - ' num2str(BP_band_stop) ' Hz)'],"FontSize",18);
    % xlabel('Frequency (Hz)',"FontSize",14); ylabel('Magnitude',"FontSize",14); grid on;
    % xlim([0,200])
    % ylim([0,1.1])
end