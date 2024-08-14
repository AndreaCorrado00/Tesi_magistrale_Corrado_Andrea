function data_filtered = filter_signals(data)
    % This function applies an elliptical high-pass filter to the 'lead_1_data' 
    % field of each subject in the input dataset. The filter properties are 
    % defined and adjusted according to the sampling frequency 'fc' for each subject.
    %
    % Inputs:
    %   data           - Structure containing data for each subject. Each subject
    %                    has a 'lead_1_data' field with the signal and a 'fc' field 
    %                    for the sampling frequency.
    %
    % Output:
    %   data_filtered  - The input structure with the filtered 'lead_1_data' for each subject.

    data_filtered = data;
    subjects = fieldnames(data);

    % Iterate over each subject in the dataset
    for i = 1:length(subjects)
        sub = string(subjects(i));
        
        % Retrieve the sampling frequency for the current subject
        Fc = data.(sub).fc; % Hz

        %% Filter properties (Band Pass)
        Rp = 0.90; % Passband ripple in percentage
        Rs = 0.10; % Stopband attenuation in percentage

        %% Convert parameters to decibels and normalized frequency
        Wp = Wp / (Fc / 2);
        Ws = Ws / (Fc / 2);
        Rp = -20 * log10(Rp); % Convert passband ripple to dB
        Rs = -20 * log10(Rs); % Convert stopband attenuation to dB

        %% Determine the filter order and natural frequency
        [n, Wn] = ellipord(Wp, Ws, Rp, Rs); 
        [b, a] = ellip(n, Rp, Rs, Wn, "high");

        %% Frequency response of the filter
        [H, f] = freqz(b, a, 512, Fc);
        
        % Display the magnitude and phase response
        figure(2)
        subplot(211)
        plot(f, abs(H))
        grid on
        title('Elliptical High Pass Filter')
        ylabel('Magnitude')
        
        subplot(212)
        plot(f, angle(H))
        grid on
        ylabel('Phase')
        xlabel('Normalized frequency')

        %% Apply the filter to the lead_1_data
        % Subtract the mean from the signal to remove DC component before filtering
        data_filtered.(sub).lead_1_data = filter(b, a, data.(sub).lead_1_data - mean(data.(sub).lead_1_data));
    end
end

