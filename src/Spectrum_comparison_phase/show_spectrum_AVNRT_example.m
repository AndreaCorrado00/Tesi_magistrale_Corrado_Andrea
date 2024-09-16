function show_spectrum_AVNRT_example(data)
% SHOW_SPECTRUM_AVNRT_EXAMPLE Compares and plots the power spectrum of
% signals filtered with both DWT and BP filters.
%
% Inputs:
%   - data: A structure containing signals filtered with both DWT and BP
%           filters. Fields should include 'DWT' and 'BP' with respective
%           traces.
%
% Outputs:
%   - None
%
% Description:
%   This function extracts and processes signals filtered using DWT and BP
%   methods from the provided data structure. It compares their power spectra
%   using AR estimation, Welch periodogram, and FFT.

% Extraction of signals filtered with DWT
rov = data.DWT.rov_trace(:,1);
ref = data.DWT.ref_trace(:,1);
spare1 = data.DWT.spare1_trace(:,1);
spare2 = data.DWT.spare2_trace(:,1);
spare3 = data.DWT.spare3_trace(:,1);

% Extraction of signals filtered with BP
rov_BP = data.BP.rov_trace(:,1);
ref_BP = data.BP.ref_trace(:,1);
spare1_BP = data.BP.spare1_trace(:,1);
spare2_BP = data.BP.spare2_trace(:,1);
spare3_BP = data.BP.spare3_trace(:,1);

% Parameters
Fs = 2035; % Sampling frequency
signals = [rov, ref, spare1, spare2, spare3];
signals_BP = [rov_BP, ref_BP, spare1_BP, spare2_BP, spare3_BP];
traces = ["Rov trace", "Ref trace", "Spare1 trace", "Spare2 trace", "Spare3 trace"];
colors = ["b", "r", "g", "c", "m"];

figure(1)
sgtitle('Comparison of Power Spectra (DWT vs BP)')

for i = 1:5
    x = signals(:,i) - mean(signals(:,i));
    x_BP = signals_BP(:,i) - mean(signals_BP(:,i));
    color = colors(i);

    % Plot for DWT Filter
    subplot(5,2,2*i-1)
    title([traces(i), ' DWT'])
    p = 10;
    th = ar(x, p, 'burg');
    [H, f] = freqz(1, th.a, length(x), Fs);
    f_BU = f;
    DSP_BU = th.NoiseVariance * (abs(H).^2);
    plot(f_BU, DSP_BU, 'Color', color, "LineWidth", 1.5)
    xlabel('f [Hz]')
    ylabel('Amplitude')
    xlim([0, 60])
    ylim([0, 0.2])

    % Plot for BP Filter
    subplot(5,2,2*i)
    title([traces(i), ' BP'])
    p = 10;
    th = ar(x_BP, p, 'burg');
    [H, f] = freqz(1, th.a, length(x_BP), Fs);
    f_BU = f;
    DSP_BU = th.NoiseVariance * (abs(H).^2);
    plot(f_BU, DSP_BU, 'Color', color, "LineWidth", 1.5)
    xlabel('f [Hz]')
    ylabel('Amplitude')
    xlim([0, 60])
    ylim([0, 0.2])
end
end
