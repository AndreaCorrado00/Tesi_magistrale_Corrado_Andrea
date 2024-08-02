% Funzione per leggere le annotazioni
function pathology = readAnnotation(atrFilePath)
    % Nota: Qui si potrebbe implementare una logica per determinare la
    % patologia dalle annotazioni, ma per semplicità supponiamo che sia
    % annotata come un semplice stringa nel file
    fid = fopen(atrFilePath, 'r');
    annotation = fgetl(fid);
    fclose(fid);
    
    % Qui andrebbe aggiunta logica per estrarre la patologia
    pathology = annotation;
end

% function pathology = readAnnotation(recordName, dataFolder)
%     % Utilizza WFDB Toolbox per leggere le annotazioni
%     ann = rdann(fullfile(dataFolder, recordName), 'atr');
% 
%     % Estrarre la patologia dalle annotazioni
%     % Nota: la logica per determinare la patologia dipende dalle annotazioni disponibili
%     % Qui si presuppone che la patologia possa essere dedotta dal tipo di battito
%     uniqueTypes = unique(ann.anntyp);
% 
%     % Mappatura semplificata dei tipi di battito a patologie
%     % Questa mappa va adattata secondo le specifiche del dataset
%     typeToPathology = containers.Map({'N', 'L', 'R', 'A', 'V', 'F'}, ...
%                                      {'Normal', 'Left bundle branch block', 'Right bundle branch block', ...
%                                       'Atrial premature', 'Premature ventricular contraction', 'Fusion'});
% 
%     pathology = [];
%     for i = 1:length(uniqueTypes)
%         if isKey(typeToPathology, uniqueTypes(i))
%             pathology = [pathology, {typeToPathology(uniqueTypes(i))}];
%         end
%     end
%     pathology = unique(pathology);
% end