function plot_example(MIT_data)
N=length(MIT_data.sub_100.lead_1_data);
t = linspace(0,MIT_data.sub_100.duration,N);

figure(1)
plot(t,MIT_data.sub_100.lead_1_data)
xlim([0,2])
title('Example of signal')
xlabel('Time [s]')
ylabel('Amplitude [mV]')
