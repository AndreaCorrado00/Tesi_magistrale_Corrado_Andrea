function [map_upper,map_lower]=analise_envelope_slope(example_env,mult_factor,fc)
% derivative operation
    % improving envelope
example_env=movmean(example_env,50);

% derivative computation
d_env=diff(example_env);
d_env=[d_env;nan];
d_env=movmean(d_env,100);

    % removing edges
d_env(1:round(0.17*fc))=nan;
d_env(round(0.6*fc):end)=nan;
    % removing mean
d_env=d_env-mean(d_env,"omitnan");

%% threshold definition

th_upper=abs(max(d_env,[],"omitnan"));
th_upper=th_upper*mult_factor;
th_lower=min(d_env,[],"omitnan");
th_lower=th_lower*mult_factor*50;

%% map creation 
map_upper=d_env>th_upper;
map_lower=d_env<th_lower;

%% map correction
[map_upper,map_lower]=merge_runs(map_upper,map_lower);

end