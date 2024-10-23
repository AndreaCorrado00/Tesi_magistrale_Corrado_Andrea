def heuristic_classificator(record,Fs):
    import numpy as np
    from scipy.signal import find_peaks
    
    record=np.array(record)
    
    t_atr=0.35;
    t_ven=0.45;
    
    atr_ind=round(t_atr*Fs)
    ven_ind=round(t_ven*Fs)
    
    atrial_phase=np.abs(record[0:atr_ind]);
    vent_phase=np.abs(record[ven_ind:]);
    his_phase=np.abs(record[atr_ind:ven_ind]);
    
    # finding peaks
    mult_factor=6;
    prominence_value=mult_factor*np.std(atrial_phase)
    atr_peak,_ =find_peaks(atrial_phase,prominence=prominence_value)
    
    prominence_value=mult_factor*np.std(vent_phase)
    vent_peak,_ =find_peaks(vent_phase,prominence=prominence_value)
    
    prominence_value=mult_factor*np.std(his_phase)
    his_peak,_ =find_peaks(his_phase,prominence=prominence_value)
    
    # peaks values
    if atr_peak.size>0:
        atr_peak=np.max(atrial_phase[atr_peak])
    else:
        atr_peak=np.nan
        
    if his_peak.size>0:
        his_peak=np.max(his_phase[his_peak])
    else:
        his_peak=np.nan
        
    if vent_peak.size>0:
        vent_peak=np.max(vent_phase[vent_peak])
    else:
        vent_peak=np.nan
    
    # decision making
    if his_peak>0:
        pred_class="MAP_C"
        
    elif atr_peak>=vent_peak or np.isnan(vent_peak):
        pred_class="MAP_A"
        
    else:
        pred_class="MAP_B"
  
    return atr_peak,his_peak,vent_peak,pred_class