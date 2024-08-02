% Funzione per leggere il file di intestazione
function [recordName, fs, duration, lead_1_data] = readHeader(heaFilePath, dataFolder)
    fid = fopen(heaFilePath, 'r');
    firstLine = fgetl(fid);
    fclose(fid);
    
    % Estrai informazioni dalla prima riga
    info = strsplit(firstLine);
    recordName = info{1};
    nChannels = str2double(info{2});
    fs = str2double(info{3});
    totalSamples = str2double(info{4});
    duration = totalSamples / fs;
    
    % Leggi i dati del segnale
    datFilePath = fullfile(dataFolder, [recordName, '.dat']);
    fid = fopen(datFilePath, 'r');
    rawData = fread(fid, [nChannels, totalSamples], 'int16');
    fclose(fid);
    
    % Estrai i dati del lead 1
    lead_1_data = rawData(1, :);
end