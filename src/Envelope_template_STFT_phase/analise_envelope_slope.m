function [map_upper,map_lower]=analise_envelope_slope(example_env,mult_factor,fc)
% derivative operation
    % improving envelope
example_env=movmean(example_env,100);

% derivative computation
d_env=diff(example_env);
d_env=[d_env;nan];
d_env=movmean(d_env,50);

    % removing edges
d_env(1:round(0.15*fc))=nan;
d_env(round(0.6*fc):end)=nan;
    % removing mean
d_env=d_env-mean(d_env,"omitnan");

%% threshold definition

th_upper=abs(max(abs(d_env),[],"omitnan"));
th_upper=th_upper*mult_factor;
th_lower=-abs(max(abs(d_env),[],"omitnan"));
th_lower=th_lower*mult_factor;

%% map creation 
map_upper=d_env>th_upper;
map_lower=d_env<th_lower;

%% map correction
[map_upper,map_lower]=merge_runs(map_upper,map_lower);

% % % map cleaning to find true peaks starts and ends
% perc_pos=60;
% percentile_value = prctile(example_env, perc_pos, "all");
% [map_upper, map_lower] = clean_false_peaks(map_upper, map_lower, example_env, perc_pos);


end