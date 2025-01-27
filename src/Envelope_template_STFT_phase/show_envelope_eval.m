function show_envelope_eval(final_data_by_sub,fc,N_points)
% SHOW_ENVELOPE_EVAL - Compare signal envelope estimation methods
%
% This function visualizes and compares the performance of two envelope 
% estimation techniques: the moving average method and the root mean square (RMS) method. 
% The analysis is performed on a selected signal from the provided dataset.
%
% INPUTS:
%   final_data_by_sub - Struct containing the signal data organized by maps and subjects.
%   fc                - Sampling frequency in Hz.
%   N_points          - Window size for the moving average and RMS envelope calculations.
%
% FUNCTIONALITY:
%   - Plots the original signal, its rectified version, the RMS envelope, and the moving 
%     average envelope to highlight the differences between the two methods.
%   - Generates a second plot illustrating how the RMS envelope changes for varying 
%     window sizes (N).
%
% OUTPUTS:
%   No explicit outputs; generates and displays comparison plots.
%
% EXAMPLES:
%   show_envelope_eval(final_data_by_sub, 1000, 30);
%
% NOTE:
%   Ensure the input dataset contains valid signal data for the specified map and subject.

% Signal example
x = final_data_by_sub.MAP_C.MAP_C7.rov_trace{:,1};
t=0:1/fc:1-1/fc;

% Moving average filter
x_rectified=abs(x);
b = ones(1, N_points) / N_points;

env_mov_avg = filter(b, 1,x_rectified);

[yupper, ~] = envelope(x, N_points, "rms");

figure;
plot(t,x,"k:")
hold on
plot(t,x_rectified,"b:")
plot(t,yupper,LineWidth=1.2)
plot(t,env_mov_avg,LineWidth=1.2)
legend('original signal','rectified signal','envelope rms','moving average')

title('Moving average VS rms method (N=30)')



figure;
plot(t, x, 'k:') 
hold on
N_values = [10, 30, 50, 100, 200];
legend_item={};
legend_item{1}="Original signal";

for i = 1:length(N_values)
    N = N_values(i);
   
    [yupper, ~] = envelope(x,N, "rms");
    plot(t,yupper, 'LineWidth', 1.5) 
    
    % Impostazioni del grafico
    legend_item{i+1}="N = "+num2str(N);
    ylabel('Amplitude [mV]')
    xlabel('time [s]')
    title("RMS envelope varying N")
end
legend(legend_item)

hold off