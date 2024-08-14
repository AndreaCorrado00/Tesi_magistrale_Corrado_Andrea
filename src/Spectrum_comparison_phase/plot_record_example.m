function plot_record_example(MIT_data_divided, record_duration)
    % This function plots an example record from the MIT_data_divided structure.
    % It visualizes the first record of the subject with ID 'sub_100', 
    % using the specified record duration to set the time axis.
    %
    % Inputs:
    %   MIT_data_divided - The structured dataset containing records for each subject.
    %   record_duration  - Duration of each record in seconds, used to set the time axis.
    %
    % Outputs:
    %   A plot displaying the first record from 'sub_100' with the specified duration.

    % Get the number of data points in the record
    N = length(MIT_data_divided.sub_100.records_table(1, :));
    
    % Create a time vector for plotting, ranging from 0 to the specified record duration
    t = linspace(0, record_duration, N);
    
    % Plot the first record from the records_table of subject 'sub_100'
    plot(t, MIT_data_divided.sub_100.records_table(1, :))
    
    % Limit the x-axis to the record duration
    xlim([0, record_duration])
    
    % Add title and labels to the plot
    title('Example of record from subject 1')
    xlabel('Time [s]')
    ylabel('Amplitude [mV]')
end
