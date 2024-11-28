function [start_end_areas]=find_atrial_ventricular_areas(signal,example_env,fc)
%% Envelope active areas
[map_upper,map_lower]=analise_envelope_slope(example_env,0.002,fc);
time_th = define_time_th(map_upper, map_lower);

%% Atrial phase: highest peak before 0.4 s
t_i=round(0.17*fc);
t_vent=round(0.45*fc);
i=1;
atr_peak=0;
t_atr_start=nan;
t_atr_end=nan;

while t_i<t_vent && time_th(i,2)<t_vent && i<size(time_th,1)
    t_s=time_th(i,1);
    t_e=time_th(i,2);
    [candidate_atr_peak,candidate_atr_peak_pos]=max(signal(t_s:t_e));

    if candidate_atr_peak>atr_peak
        atr_peak=candidate_atr_peak;
        t_atr_start=t_s;
        t_atr_end=t_e;
    end
    i=i+1;
    t_i=candidate_atr_peak_pos/fc;

end

%% ventricular phase: highest peak after 0.4 s
t_vent_start=nan;
t_vent_end=nan;
vent_peak=0;

while i<=size(time_th,1) 
    t_s=time_th(i,1);
    t_e=time_th(i,2);
    candidate_vent_peak=max(signal(t_s:t_e));

    if candidate_vent_peak>vent_peak
        vent_peak=candidate_vent_peak;
        t_vent_start=t_s;
        t_vent_end=t_e;
    end
    i=i+1;
end

start_end_areas=[t_atr_start,t_atr_end;
                 t_vent_start,t_vent_end];
