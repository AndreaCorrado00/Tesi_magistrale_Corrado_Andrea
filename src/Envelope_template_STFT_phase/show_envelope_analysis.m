function show_envelope_analysis(data,env_data,fc,record_id,figure_path)

% extracting signal
map="MAP_"+record_id(1);
sub=map+num2str(record_id(2));
h=double(record_id(3));
signal = data.(map).(sub).rov_trace{:,h};
example_env = env_data.(map).(sub).rov_trace{:,h};

% plot elements
x = [0:1/fc:1-1/fc]';
sub_num = split(sub,'_');
sub_num = split(sub_num{2},record_id(1));
sub_num = sub_num{end};

% Create a new figure
% fig = figure;
% fig.WindowState = "maximized";
screenSize = get(0, 'ScreenSize');
fig = figure('Visible', 'off');   
fig.Position = [0, 0, screenSize(3), screenSize(4)];
sgtitle(["Example of envelope anlysis for: MAP "+record_id(1)+", sub: "+sub_num+", record: "+num2str(h)])

%% computing derivation
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
d_env=d_env*max(signal,[],"omitnan")/max(d_env);

subplot(3,2,1)
plot(x,signal,"LineWidth",0.8,"Color","#4DBEEE")
hold on
plot(x,example_env,"LineWidth",1.5,"Color","#0072BD")
plot(x,d_env,"LineWidth",1.5,"Color","#7E2F8E")
title('Step 1: Envelope derivative')
legend(["Signal","Envelope","d_{env}/dt"])
xlabel('time [s]')
ylabel('Amplitude [mV]')
%% Map definition
% threshold definition
mult_factor=1000;
% th_upper=abs(min(abs(d_env),[],"omitnan"));
% th_upper=th_upper+mult_factor*th_upper;
% th_lower=-abs(min(abs(d_env),[],"omitnan"));
% th_lower=th_lower+mult_factor*th_lower;
th_upper=abs(max(abs(d_env),[],"omitnan"));
th_upper=th_upper*0.05;
th_lower=-abs(max(abs(d_env),[],"omitnan"));
th_lower=th_lower*0.05;

% map creation 
map_upper=d_env>th_upper;
map_lower=d_env<th_lower;

% Plotting
subplot(3,2,2)
plot(x,signal,"LineWidth",0.8,"Color","#4DBEEE")
hold on
plot(x,example_env,"LineWidth",1.5,"Color","#0072BD")
plot(x, map_upper * min([1, 1/max(signal, [], "omitnan"), max(signal, [], "omitnan")]), "LineWidth", 1.2, "Color", "#A2142F")
plot(x, -map_lower * abs(max([-1, 1/min(signal, [], "omitnan"), min(signal, [], "omitnan")])), "LineWidth", 1.2, "Color", "#7E2F8E")
title('Step 2: derivative thresholding')
legend(["Signal","Envelope","d_{env}/dt >0","d_{env}/dt <0"])
xlabel('time [s]')
ylabel('Amplitude [mV]')
%% Map merge
[map_upper,map_lower]=merge_runs(map_upper,map_lower);

% Plotting
subplot(3,2,3)
plot(x,signal,"LineWidth",0.8,"Color","#4DBEEE")
hold on
plot(x,example_env,"LineWidth",1.5,"Color","#0072BD")
plot(x, map_upper * min([1, 1/max(signal, [], "omitnan"), max(signal, [], "omitnan")]), "LineWidth", 1.2, "Color", "#A2142F")
plot(x, -map_lower * abs(max([-1, 1/min(signal, [], "omitnan"), min(signal, [], "omitnan")])), "LineWidth", 1.2, "Color", "#7E2F8E")
title('Step 3: map merge')
legend(["Signal","Envelope","d_{env}/dt >0","d_{env}/dt <0"])
xlabel('time [s]')
ylabel('Amplitude [mV]')

%% Map cleaning
perc_pos=60;
[map_upper, map_lower] = clean_false_peaks(map_upper, map_lower, example_env, perc_pos);


% Plotting
subplot(3,2,4)
plot(x,signal,"LineWidth",0.8,"Color","#4DBEEE")
hold on
plot(x,example_env,"LineWidth",1.5,"Color","#0072BD")
plot(x, map_upper * min([1, 1/max(signal, [], "omitnan"), max(signal, [], "omitnan")]), "LineWidth", 1.2, "Color", "#A2142F")
plot(x, -map_lower * abs(max([-1, 1/min(signal, [], "omitnan"), min(signal, [], "omitnan")])), "LineWidth", 1.2, "Color", "#7E2F8E")
title('Step 4: intermediate peaks removal')
legend(["Signal","Envelope","d_{env}/dt >0","d_{env}/dt <0"])
xlabel('time [s]')
ylabel('Amplitude [mV]')

%% Time thresholds
time_th = define_time_th(map_upper, map_lower);
subplot(3,2,5)
plot(x,signal,"LineWidth",0.8,"Color","#4DBEEE")
hold on
% Plot vertical dashed lines for peaks
for k = 1:size(time_th, 1)
    % Convert index positions to time
    start_time = time_th(k, 1) / fc; % Start index converted to time
    end_time = time_th(k, 2) / fc;   % End index converted to time

    % Plot vertical dashed line for the start of the peak (green)
    plot([start_time, start_time], ylim, '--', 'LineWidth', 0.2, 'Color', [0, 0.5, 0]);
    % Plot vertical dashed line for the end of the peak (red)
    plot([end_time, end_time], ylim, '--', 'LineWidth', 0.2, 'Color', [0.5, 0, 0]);

   
end
title('Step 5: time threshold definition')
% legend(['Signal','Envelope','d_{env}/dt >0','d_{env}/dt <0'])
xlabel('time [s]')
ylabel('Amplitude [mV]')

%% possible saving plot
% % Save the plot
file_name = sub+ '_record_' + num2str(h) + '_';
save_plot(file_name,"example_analysis", figure_path, fig, true);
