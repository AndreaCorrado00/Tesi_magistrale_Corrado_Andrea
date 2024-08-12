function plot_record_example(MIT_data_divided,record_duration)
N=length(MIT_data_divided.sub_100.records_table(1,:));
t = linspace(0,record_duration,N);
%figure(1)
plot(t,MIT_data_divided.sub_100.records_table(1,:))
xlim([0,record_duration])
title('Example of record from subject 1')
xlabel('Time [s]')
ylabel('Amplitude [mV]')