function spectrum_struct = evaluate_Physionet_spectrums(signals, Fc, windowsize)
    % Inizializzazione della struttura di output
    num_signals = numel(signals);
    spectrum_struct = struct();

    % Calcolo dello spettro per ogni segnale e finestra specificata
    for i = 1:num_signals
        signal = signals{i};
        signal_length = numel(signal);

        % Calcolo dello spettro per l'intero segnale

        psd_full= calculate_PSD(signal, Fc);

        % Inizializzazione della struttura per il segnale corrente
        signal_name= sprintf('Signal_%d', i);
        spectrum_struct.(signal_name).FullSignalPSD = psd_full;  
        
        % Calcolo dello spettro per segnali finestrati di dimensioni crescenti
        window_count = 1;
        for j = 1:windowsize:signal_length
            % Controllo della lunghezza residua del segnale
            remaining_length = signal_length - j + 1;
            
            % Se la lunghezza residua è inferiore a windowsize, verifica il criterio di interruzione
            if remaining_length < windowsize
                break
            end
            
            % Estrarre il segnale finestrato
            end_idx = min(j + windowsize - 1, signal_length);
            windowed_signal = signal(1:end_idx);
            
            % Calcolo dello spettro per il segnale finestrato
            psd_windowed= calculate_PSD(windowed_signal, Fc);
            
            % Aggiungere lo spettro finestrato alla struttura del segnale corrente
            field_name = sprintf('WindowedSignalPSD_%d', window_count);
            spectrum_struct.(signal_name).(field_name) = psd_windowed; 
            window_count = window_count + 1;
        end
       
    end
end
