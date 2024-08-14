function pathology = readAnnotation(atrFilePath)
    % This function reads the annotation from an MIT-BIH .atr file.
    % It extracts the first line of the file, which typically contains
    % the pathological information or description.
    %
    % Inputs:
    %   atrFilePath - The full path to the .atr file containing annotations.
    %
    % Outputs:
    %   pathology   - The extracted annotation, usually describing the pathology.

    % Open the annotation file for reading
    fid = fopen(atrFilePath, 'r');
    
    % Read the first line of the file, which contains the annotation
    annotation = fgetl(fid);
    
    % Close the file
    fclose(fid);
    
    % Assign the read annotation to the output variable
    pathology = annotation;
end
