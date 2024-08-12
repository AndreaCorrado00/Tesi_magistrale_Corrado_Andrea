function [recordName, fs, duration, gain, baseline, numLeads] = readHeader(heaFilePath)
    % Funzione per leggere il file .hea e ottenere i parametri necessari
    fid = fopen(heaFilePath, 'r');
    headerInfo = textscan(fid, '%s', 'Delimiter', '\n');
    fclose(fid);
    
    % Estrai informazioni importanti dalla prima riga
    firstLine = strsplit(headerInfo{1}{1});
    recordName = firstLine{1};
    fs = str2double(firstLine{3}); % Frequenza di campionamento
    duration = str2double(firstLine{4}); % Durata del segnale
    
    % Estrai il numero di derivazioni (leads)
    numLeads = str2double(firstLine{2});
    
    % Estrai il gain e il baseline dalla seconda riga (esempio per la derivazione 1)
    secondLine = strsplit(headerInfo{1}{2});
    gain = str2double(secondLine{3}); % Gain del segnale (uV per digit)
    baseline = str2double(secondLine{5}); % Baseline del segnale
end
