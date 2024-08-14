function plot_example(MIT_data, bigger)
    % This function plots an example of the lead 1 signal from the MIT_data 
    % structure for the subject with ID 'sub_100'. The plot can be made with 
    % a thicker line width if the 'bigger' parameter is set to true.
    %
    % Inputs:
    %   MIT_data - The structured dataset containing the lead 1 signal data.
    %   bigger   - Boolean flag to determine whether to plot with a thicker line width.
    %
    % Outputs:
    %   A plot displaying the signal from 'sub_100' with a time range of 0 to 2 seconds.

    % Get the length of the lead 1 data
    N = length(MIT_data.sub_100.lead_1_data);
    
    % Calculate the duration of the signal in seconds
    duration = N / MIT_data.sub_100.fc;
    
    % Create a time vector for plotting
    t = linspace(0, duration, N);

    % Plot the lead 1 data, adjusting for the mean to remove the DC component
    if bigger
        plot(t, MIT_data.sub_100.lead_1_data - mean(MIT_data.sub_100.lead_1_data), "LineWidth", 1)
    else
        plot(t, MIT_data.sub_100.lead_1_data - mean(MIT_data.sub_100.lead_1_data))
    end

    % Limit the x-axis to the first 2 seconds
    xlim([0, 2])
    
    % Add title and labels to the plot
    title('Example of signal')
    xlabel('Time [s]')
    ylabel('Amplitude [mV]')
end
