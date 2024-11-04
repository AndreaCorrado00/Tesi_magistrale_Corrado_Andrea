def heuristic_classifier_C_2(record,Fs,his_bundle_th):
    import numpy as np
    
    record=np.array(record)
    amplitude=np.nanmax(record)-np.nanmin(record)
    
    t_atr=0.38
    t_ven=0.42
    
    atr_ind=round(t_atr*Fs)
    ven_ind=round(t_ven*Fs)
    
    atrial_phase=np.abs(record[0:atr_ind])
    vent_phase=np.abs(record[ven_ind:])
    his_phase=np.abs(record[atr_ind:ven_ind])
    
    # finding peaks
    atr_peak= np.nanmax(atrial_phase)
    vent_peak = np.nanmax(vent_phase)
    his_peak = np.nanmax(his_phase)/amplitude
    
    # peaks values
    
    if his_peak>his_bundle_th:
        pred_class="MAP_C"
    else:
        # atrial and ventricular thresholds 
        if atr_peak>0.5: 
            pred_class="MAP_A"
        elif 0.1<atr_peak<0.3: 
            pred_class="MAP_B"
            # if thresholds aren't satisfied, peaks are compared
        elif atr_peak>vent_peak: 
            pred_class="MAP_A"
        else:
            pred_class="MAP_B"

    return atr_peak,his_peak,vent_peak,pred_class


