function MIT_dataset_builder(dataFolder)
    % Elenca tutti i file .hea nella cartella
    heaFiles = dir(fullfile(dataFolder, '*.hea'));

    % Crea la struct per i dati
    MIT_data = struct();
    
    % Loop attraverso tutti i file .hea
    for k = 1:length(heaFiles)
        % Ottieni il nome del file senza estensione
        [~, fileName, ~] = fileparts(heaFiles(k).name);

        % Leggi il file di intestazione
        heaFilePath = fullfile(dataFolder, [fileName, '.hea']);
        [recordName, fs, duration, gain, baseline, numLeads] = readHeader(heaFilePath);

        % Leggi i dati dal file .dat (nel formato 212) e convertili in millivolt
        datFilePath = fullfile(dataFolder, [fileName, '.dat']);
        signals = readMITdat(datFilePath, gain, baseline, numLeads);  % Funzione aggiornata
        
        % Leggi le annotazioni per ottenere la patologia
        atrFilePath = fullfile(dataFolder, [fileName, '.atr']);
        pathology = readAnnotation(atrFilePath);

        % Aggiungi i dati alla struct
        subFieldName = ['sub_', fileName];
        MIT_data.(subFieldName).lead_1_data = signals(:,1); % Salva la derivazione 1 (lead 1)
        MIT_data.(subFieldName).signals = signals; % Salva tutti i segnali
        MIT_data.(subFieldName).fc = fs; % Frequenza di campionamento
        MIT_data.(subFieldName).duration = duration;
        MIT_data.(subFieldName).pathology = pathology;
    end
    
    % Salva la struct in un file .mat
    save("D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Other\MIT_dataset.mat", 'MIT_data');
end






