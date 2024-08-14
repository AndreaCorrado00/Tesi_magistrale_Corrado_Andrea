function [recordName, fs, duration, gain, baseline, numLeads] = readHeader(heaFilePath)
    % This function reads an MIT-BIH .hea file to extract necessary parameters.
    % The parameters include the record name, sampling frequency, duration,
    % gain, baseline, and the number of leads.
    %
    % Inputs:
    %   heaFilePath - The full path to the .hea file containing header information.
    %
    % Outputs:
    %   recordName  - The name of the record.
    %   fs          - The sampling frequency (Hz).
    %   duration    - The duration of the signal (seconds).
    %   gain        - The gain of the signal (microvolts per digit).
    %   baseline    - The baseline of the signal.
    %   numLeads    - The number of leads in the signal.

    % Open the header file for reading
    fid = fopen(heaFilePath, 'r');
    
    % Read the entire file content into a cell array, one line per cell
    headerInfo = textscan(fid, '%s', 'Delimiter', '\n');
    
    % Close the file
    fclose(fid);
    
    % Extract important information from the first line
    firstLine = strsplit(headerInfo{1}{1});
    recordName = firstLine{1}; % Record name
    fs = str2double(firstLine{3}); % Sampling frequency (Hz)
    duration = str2double(firstLine{4}); % Duration of the signal (seconds)
    
    % Extract the number of leads from the first line
    numLeads = str2double(firstLine{2});
    
    % Extract the gain and baseline from the second line (example for lead 1)
    secondLine = strsplit(headerInfo{1}{2});
    gain = str2double(secondLine{3}); % Gain of the signal (microvolts per digit)
    baseline = str2double(secondLine{5}); % Baseline of the signal
end
