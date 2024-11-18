function [map_upper,map_lower]=analise_envelope_slope(example_rov,example_env,mult_factor,fc)
% derivative operation
    % improving envelope
example_env=movmean(example_env,30);
    % removing edges
example_env(1:round(0.15*fc))=nan;
example_env(round(0.6*fc):end)=nan;

d_env=diff(example_env);
d_env=[d_env;nan];
d_env=movmean(d_env,50);

d_env=d_env-mean(d_env,"omitnan");
d_env=d_env*max(example_rov,[],"omitnan")/max(d_env);


% threshold definition
th_upper=abs(min(abs(d_env),[],"omitnan"));
th_upper=th_upper+mult_factor*th_upper;
th_lower=-abs(min(abs(d_env),[],"omitnan"));
th_lower=th_lower+mult_factor*th_lower;


% map creation 
map_upper=d_env>th_upper;
map_lower=d_env<th_lower;

 
% map cleaning to find true peaks starts and ends
perc_pos=50;
percentile_value = prctile(example_env, perc_pos, "all");
[map_upper, map_lower] = clean_false_peaks(map_upper, map_lower, example_env, perc_pos);
% [map_upper,map_lower]=merge_runs(map_upper,map_lower);

% figure;
% histogram(example_env, 50,'NumBins',50); 
% hold on;
% xline(percentile_value, 'r', 'LineWidth', 2, 'Label', ['Percentile (' num2str(percentile_value) ')']);
% 
% % Etichette e titolo
% title('Histogram of Envelope');
% xlabel('Envelope Values');
% ylabel('Number of  points');
% 
% 
% figure;
% % plot(example_rov,'k:')
% hold on 
% plot(example_env,"LineWidth",0.8,"Color","b")
% plot(percentile_value*ones(length(example_env),1),"LineWidth",1.5,"Color","r")

end