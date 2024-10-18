function show_filter_pipeline_didactical(type)
load("D:\Desktop\ANDREA\Universita\Magistrale\Anno Accademico 2023-2024\TESI\Tesi_magistrale\Data\Other\ecg_spectrum_analysis_pipeline_test.mat")

switch type
    case "high_frequency_ecg"
        name="ECG with high frequency noise";
        ecg = ecg_simulation.high_freq;
        Fs = 1000; % Hz
        step = 1000; % Increment of points from which to evaluate the spectrum
    case "Low_frequency_ecg"
        name="ECG with low frequency noise";
        ecg = ecg_simulation.low_freq;
        Fs = 1000; % Hz
        step = 1000; % Increment of points from which to evaluate the spectrum

    case "PhysioNet_healthy"
        name="Healthy subject Physionet DB";
        ecg = ecg_simulation.healthy;
        Fs = 360; % Hz
        step = 720; % Increment of points from which to evaluate the spectrum
    case "PhysioNet_Pathological"
        name="Pathological subject Physionet DB";
        ecg = ecg_simulation.patological;
        Fs = 360; % Hz
        step = 720; % Increment of points from which to evaluate the spectrum
end
%% Starting of simulation
x_original = ecg - mean(ecg); % Subtract the mean

if type == "PhysioNet_healthy" || type == "PhysioNet_Pathological"
    %% Signal reduction (avoid artifacts)
    x_original = x_original / 1000;

    t_start = 10; % Start time in seconds
    t_end = 20; % End time in seconds

    % Calculate corresponding indices
    start_index = round(t_start * Fs) + 1; % +1 because MATLAB indexes from 1
    end_index = round(t_end * Fs);

    % Extract samples
    x_original = x_original(start_index:end_index);

end

N = length(x_original);
Ts = 1 / Fs;
t = 0:Ts:Ts*N-Ts;


%% Starting of simulation
N_original = length(x_original);

N_points=[step,N_original];

% for each ECG (n° beats) length the proposed pipeline is evaluated
for i = 1: length(N_points)
    lim=N_points(i);

    x = x_original(1:lim)-mean(x_original(1:lim));
   
    % Plots elements
    N = length(x);
    Ts = 1 / Fs;
    t = 0:Ts:Ts*N-Ts;

    x_w=handable_denoise_ecg_wavelet(x,Fs,'sym4',9,false,2,60);
    x_w=x_w-mean(x_w);
    x_bp=handable_denoise_ecg_BP(x,Fs,2,60);
    x_bp=x_bp-mean(x_bp);

    figure(i+2)
    hold on
    sgtitle("Denoising pipeline, N° points: "+num2str(N_points(i)+", "+name))
    plot(t,x,"Color",[.5,.5,.5],"LineStyle",":","LineWidth",0.5)
    %plot(t,ref_win,"Color",[.3,.3,.3],"LineWidth",0.7)
    plot(t,x_bp,"Color",[0.9290 0.6940 0.1250],"LineWidth",0.9)
    plot(t,x_w,"Color",	"#0072BD","LineWidth",0.9)
    xlabel('time [s]')
    ylabel('Amplitude [mV]')
    xlim([0,t(end)])
    
    
    hold off
    legend(["Noisy signal","BP digital","Wavalet th + BP digital"],"Location","bestoutside")
end
