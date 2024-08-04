function modified_dataset = extract_random_segments_struct(dataset, record_duration, num_records, min_overlap_ratio)
    % Function to extract random segments from ECG data with overlap control
    % dataset: structure containing the dataset data
    % record_duration: duration of each record in seconds (e.g., 20)
    % num_records: number of records to extract for each subject (e.g., 10)
    % min_overlap_ratio: minimum overlap percentage allowed (e.g., 0.1 for 10%)
    
    % Copy the dataset for modification
    modified_dataset = dataset;
    
    % Get the subject names
    subjects = fieldnames(dataset);

    % Iterate over each subject in the dataset
    for i = 1:numel(subjects)
        subject_data = dataset.(subjects{i});
        
        % Access lead_1_data and fc
        if isfield(subject_data, 'lead_1_data') && isfield(subject_data, 'fc')
            lead_1_data = subject_data.lead_1_data;
            fc = subject_data.fc;
            
            % Calculate the number of samples per record (in seconds)
            num_samples_per_record = record_duration * fc;
            total_samples = length(lead_1_data);
            
            % Initialize cell to store records
            records = cell(num_records, 1);
            
            % Overlap control
            min_overlap = min_overlap_ratio * num_samples_per_record;
            
            % Seed random number generator for reproducibility
            rng('shuffle');
            for j = 1:num_records
                valid_segment = false;
                while ~valid_segment
                    start_idx = randi([1, total_samples - num_samples_per_record + 1]);
                    end_idx = start_idx + num_samples_per_record - 1;
                    
                    % Check overlap with previously selected segments
                    overlap = false;
                    for k = 1:j-1
                        if ~isempty(records{k})
                            previous_start_idx = records{k}(1);
                            previous_end_idx = records{k}(end);
                            if max(start_idx, previous_start_idx) <= min(end_idx, previous_end_idx) - min_overlap
                                overlap = true;
                                break;
                            end
                        end
                    end
                    
                    if ~overlap
                        valid_segment = true;
                        record_data = lead_1_data(start_idx:end_idx);
                        records{j} = start_idx:end_idx;  % Store indices for overlap check
                        % Convert record data to table row
                        records_table(j, :) = record_data;
                    end
                end
            end
            
            % Add records table to the subject in the modified structure
            modified_dataset.(subjects{i}).records_table = records_table;
        end
    end
end
