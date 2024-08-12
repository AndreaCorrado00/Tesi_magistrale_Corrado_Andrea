function [signals, Fs] = readMITdat(datFilePath)
    % Funzione per leggere i dati dal file .dat nel formato 212
    fid = fopen(datFilePath, 'r');
    signals = fread(fid, inf, 'uint16');
    fclose(fid);

    Fs = 360; % Frequenza di campionamento per il formato 212 (o 360, a seconda del caso)
end