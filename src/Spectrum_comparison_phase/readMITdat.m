function signals = readMITdat(datFilePath, gain, baseline, numLeads)
    % Funzione per leggere e convertire i dati dal file .dat nel formato 212 in millivolt
    fid = fopen(datFilePath, 'r');
    rawData = fread(fid, [numLeads, inf], 'uint16')'; % Legge tutti i leads
    fclose(fid);
    
    % Converti i dati grezzi in millivolt
    signals = ((rawData - baseline)/gain)*0.1; % Conversione in mV (gain è in uV per digit)
end
