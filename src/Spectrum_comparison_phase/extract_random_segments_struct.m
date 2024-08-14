function modified_dataset = extract_random_segments_struct(dataset, record_duration, num_records, min_overlap_ratio)
    % This function extracts random segments of data from each subject's lead_1_data
    % in the input dataset. The function ensures that the extracted segments 
    % have minimal overlap as specified by min_overlap_ratio. The extracted 
    % segments are stored in a new field 'records_table' within the dataset.
    %
    % Inputs:
    %   dataset            - Structure containing data for each subject.
    %   record_duration    - Duration of each record segment in seconds.
    %   num_records        - Number of segments to extract for each subject.
    %   min_overlap_ratio  - Minimum allowable overlap ratio between segments.
    %
    % Output:
    %   modified_dataset   - The modified dataset structure with the extracted
    %                        segments stored in 'records_table' for each subject.

    modified_dataset = dataset;
    
    % Get the subject names from the dataset structure
    subjects = fieldnames(dataset);

    % Iterate over each subject in the dataset
    for i = 1:numel(subjects)
        subject_data = dataset.(subjects{i});
        
        % Access lead_1_data and fc fields for the current subject
        if isfield(subject_data, 'lead_1_data') && isfield(subject_data, 'fc')
            lead_1_data = subject_data.lead_1_data;
            fc = subject_data.fc;
            
            % Calculate the number of samples per record based on the duration and sampling frequency
            num_samples_per_record = record_duration * fc;
            total_samples = length(lead_1_data);
            
            % Initialize a cell array to store the extracted records
            records = cell(num_records, 1);
            
            % Calculate the minimum overlap in terms of samples
            min_overlap = min_overlap_ratio * num_samples_per_record;
            
            % Seed the random number generator for reproducibility
            rng('shuffle');
            for j = 1:num_records
                valid_segment = false;
                while ~valid_segment
                    % Randomly select the start index for the segment
                    start_idx = randi([1, total_samples - num_samples_per_record + 1]);
                    end_idx = start_idx + num_samples_per_record - 1;
                    
                    % Check overlap with previously selected segments
                    overlap = false;
                    for k = 1:j-1
                        if ~isempty(records{k})
                            previous_start_idx = records{k}(1);
                            previous_end_idx = records{k}(end);
                            % Ensure the overlap is less than the minimum allowed
                            if max(start_idx, previous_start_idx) <= min(end_idx, previous_end_idx) - min_overlap
                                overlap = true;
                                break;
                            end
                        end
                    end
                    
                    % If no overlap is found, the segment is valid
                    if ~overlap
                        valid_segment = true;
                        record_data = lead_1_data(start_idx:end_idx);
                        records{j} = start_idx:end_idx;  % Store indices for overlap check
                        % Store the extracted segment in a table row
                        records_table(j, :) = record_data;
                    end
                end
            end
            
            % Add the table of records to the current subject in the modified dataset
            modified_dataset.(subjects{i}).records_table = records_table;
        end
    end
end
