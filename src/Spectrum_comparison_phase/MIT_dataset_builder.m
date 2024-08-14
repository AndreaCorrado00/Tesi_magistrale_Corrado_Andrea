function MIT_dataset_builder(dataFolder)
    % This function builds a dataset from MIT-BIH formatted data files. 
    % It reads .hea, .dat, and .atr files from the specified folder, extracts 
    % relevant information and signals, and stores them in a structured format. 
    % The dataset is then saved as a .mat file.
    %
    % Inputs:
    %   dataFolder - The folder containing the MIT-BIH .hea, .dat, and .atr files.
    %
    % Output:
    %   A .mat file containing the structured dataset, saved to the specified path.

    % List all .hea files in the folder
    heaFiles = dir(fullfile(dataFolder, '*.hea'));

    % Create the struct to hold the data
    MIT_data = struct();
    
    % Loop through all .hea files
    for k = 1:length(heaFiles)
        % Get the file name without the extension
        [~, fileName, ~] = fileparts(heaFiles(k).name);

        % Read the header file (.hea)
        heaFilePath = fullfile(dataFolder, [fileName, '.hea']);
        [recordName, fs, duration, gain, baseline, numLeads] = readHeader(heaFilePath);

        % Read the data from the .dat file (in 212 format) and convert to millivolts
        datFilePath = fullfile(dataFolder, [fileName, '.dat']);
        signals = readMITdat(datFilePath, gain, baseline, numLeads);  % Updated function to handle .dat format
        
        % Read the annotations to obtain the pathology
        atrFilePath = fullfile(dataFolder, [fileName, '.atr']);
        pathology = readAnnotation(atrFilePath);

        % Add the data to the struct
        subFieldName = ['sub_', fileName];
        MIT_data.(subFieldName).lead_1_data = signals(:,1); % Store lead 1 data
        MIT_data.(subFieldName).signals = signals; % Store all signals
        MIT_data.(subFieldName).fc = fs; % Sampling frequency
        MIT_data.(subFieldName).duration = duration;
        MIT_data.(subFieldName).pathology = pathology;
    end
    
    % Save the struct to a .mat file
    save("D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Other\MIT_dataset.mat", 'MIT_data');
end






