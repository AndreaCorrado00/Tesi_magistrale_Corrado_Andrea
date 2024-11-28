function [N_positive_corr_peaks,signal_corr_active_area]=analyse_TM_into_active_areas(record_id,data,env_dataset,T,fc,area)

%% 0. data informations and envelope active areas
map="MAP_"+record_id(1);
sub=map+num2str(record_id(2));
h=double(record_id(3));
signal = data.(map).(sub).rov_trace{:,h};
example_env = env_dataset.(map).(sub).rov_trace{:,h};

% finding areas of interest
[start_end_areas]=find_atrial_ventricular_areas(signal,example_env,fc);

if area=="atrial"
    idx_r=1;
else
    idx_r=2;
end

t_start=start_end_areas(idx_r,1);
t_end=start_end_areas(idx_r,2);

% if the area of interest is present, analysis are made
phase_presence=true;
if isnan(t_start) || isnan(t_end)
    phase_presence=false;
    disp("No "+area+" phase detected for "+sub+"-"+num2str(h))
else
    example_corr=nan(length(signal),1);
    %% Define the template (biphasic)

    N = round(T * fc);  % Number of samples in the template

    t_template = linspace(0, T, N);

    signal_example=signal(t_start:t_end);
    norm_signal = sqrt(sum(signal_example.^2));
    signal_example=signal_example/norm_signal;

    signal_example=movmean(signal_example,50);

    template =  sin(2 * pi * 1/T *t_template); % Biphasic siusoid template
    norm_template = sqrt(sum(template.^2));
    template=template/norm_template;
    corr = conv(signal_example, flip(template), 'same');  % Convolution (cross-correlation)

    example_corr(t_start:t_end)=movmean(corr,50);


    %% 1. computing derivation
    example_corr=movmean(example_corr,70);

    d_corr=diff(example_corr);
    d_corr=[d_corr;nan];
    d_corr=movmean(d_corr,100);

    % removing edges
    % d_corr(1:t_start)=nan;
    % d_corr(t_end:end)=nan;

    d_corr=d_corr-mean(d_corr,"omitnan");

    %% Map thresholding 
    mult_factor=0.1;
    th_upper=abs(max(d_corr,[],"omitnan"));
    th_upper=th_upper*mult_factor;
    th_lower=min(d_corr,[],"omitnan");
    th_lower=th_lower*mult_factor;

    map_upper=d_corr>th_upper;
    map_lower=d_corr<th_lower;

    %% 3. Map cleaning 
    % Find runs in map_upper and map_lower
    runs_upper = find(diff([0; map_upper]) == 1);  % Indices of the start of runs in map_upper
    runs_lower = find(diff([0; map_lower]) == 1);  % Indices of the start of runs in map_lower
    % Remove runs in map_upper not followed by a run in map_lower
    if length(runs_lower)<length(runs_upper)
        for i = 1:length(runs_upper)
            % End of the current run in map_upper
            end_upper = find(map_upper(runs_upper(i):end) == 0, 1) + runs_upper(i) - 1;

            % Check if there is a run in map_lower after the current run in map_upper
            following_lower = runs_lower(min([i, length(runs_lower)])); % Find the next run start in map_lower after end_upper
            next_upper = runs_upper(min([i+1, length(runs_upper)]));

            % If no run in map_lower follows this run in map_upper, remove the run
            if next_upper < following_lower
                map_upper(runs_upper(i):end_upper) = 0;  % Remove the run in map_upper
            end
        end
    end
    % Remove runs in map_lower not preceded by a run in map_upper
    if length(runs_lower)>length(runs_upper)
        for i = 1:length(runs_lower)
            % Start of the current run in map_lower
            start_lower = runs_lower(i);

            % Find the end of the current run in map_lower
            end_lower = find(map_lower(start_lower:end) == 0, 1) + start_lower - 1;

            % Check if there is a run in map_lower after the current run in map_upper
            next_lower = runs_lower(min([i+1, length(runs_lower)]));
            next_upper = runs_upper(min([i+1, length(runs_upper)]));

            % If no run in map_lower follows this run in map_upper, remove the run
            if next_upper > next_lower
                map_lower(runs_lower(i):end_lower) = 0;  % Remove the run in map_lower
            end
        end
    end
    % Ensure the combined map starts with a run in map_upper
    first_upper = find(map_upper, 1, 'first');
    first_lower = find(map_lower, 1, 'first');

    if isempty(first_upper) || (~isempty(first_lower) && first_lower < first_upper)
        % If map_lower starts before map_upper, set map_lower to 0 before the first map_upper
        map_lower(1:first_upper-1) = 0;
    end

    % Ensure the combined map ends with a run in map_lower
    last_lower = find(map_lower, 1, 'last');
    last_upper = find(map_upper, 1, 'last');

    if isempty(last_lower) || (~isempty(last_upper) && last_upper > last_lower)
        % If map_upper ends after map_lower, set map_upper to 0 after the last map_lower
        map_upper(last_lower+1:end) = 0;
    end

end
%% 4. Number of (positive) peaks into active phase
if phase_presence
    N_positive_corr_peaks=numel(regionprops(map_upper, 'PixelIdxList'));
    signal_corr_active_area=example_corr;
else
    N_positive_corr_peaks=nan;
    signal_corr_active_area=nan;

end



