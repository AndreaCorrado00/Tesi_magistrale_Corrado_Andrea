function signals = readMITdat(datFilePath, gain, baseline, numLeads)
    % This function reads and converts data from a MIT-BIH .dat file in format 212 to millivolts.
    % The data is read as 16-bit unsigned integers and then converted using the provided gain and baseline.
    %
    % Inputs:
    %   datFilePath - The full path to the .dat file containing the ECG signals in format 212.
    %   gain        - The gain of the signal in microvolts per digit (used for conversion).
    %   baseline    - The baseline of the signal (used for conversion).
    %   numLeads    - The number of leads present in the .dat file.
    %
    % Outputs:
    %   signals     - The converted signal data in millivolts, with each row representing a lead.

    % Open the .dat file for reading
    fid = fopen(datFilePath, 'r');
    
    % Read the entire file into a matrix, with numLeads rows and as many columns as needed
    rawData = fread(fid, [numLeads, inf], 'uint16')';
    
    % Close the file
    fclose(fid);
    
    % Convert the raw data to millivolts
    % The raw data is in units of microvolts per digit; conversion requires adjusting for baseline and gain
    signals = ((rawData - baseline) / gain) * 0.1; % Conversion to millivolts (gain is in microvolts per digit)
end
