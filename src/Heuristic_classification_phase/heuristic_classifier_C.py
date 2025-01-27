"""
Classifies a cardiac signal based on heuristic thresholds and peak analysis of atrial, His bundle, and ventricular phases.

Parameters:
    record (list or ndarray): The signal data to be classified.
    Fs (float): Sampling frequency of the signal in Hz.
    his_bundle_th (float): Threshold for the His bundle peak to determine "Dangerous" classification.
    use_ratio (bool, optional): 
        - If True, compares the ratio of atrial to ventricular peak amplitudes to a threshold (0.5).
        - If False, compares the atrial peak amplitude directly to the threshold (0.5).

Returns:
    atr_peak (float): Maximum absolute amplitude in the atrial phase.
    his_peak (float): Maximum absolute amplitude in the His bundle phase.
    vent_peak (float): Maximum absolute amplitude in the ventricular phase.
    pred_class (str): Predicted classification:
        - "Dangerous": If the His bundle peak exceeds `his_bundle_th`.
        - "Indifferent": If the atrial peak exceeds the threshold (0.5 or ratio-based).
        - "Effective": If neither the His bundle nor atrial peaks exceed their respective thresholds.

Phases:
    - Atrial phase: Signal segment from 0 to `t_atr`.
    - His bundle phase: Signal segment between `t_atr` and `t_ven`.
    - Ventricular phase: Signal segment between `t_ven` and `t_end`.

Notes:
    - Time intervals (`t_atr`, `t_ven`, `t_end`) are predefined in seconds and converted to indices using the sampling frequency.
    - The function is designed for heuristic classification and assumes specific domain knowledge of the signal structure.
"""

def heuristic_classifier_C(record,Fs,his_bundle_th, use_ratio=False):
    import numpy as np
    
    record=np.array(record)
    
    t_atr=0.38
    t_ven=0.42
    t_end=0.6
    
    atr_ind=round(t_atr*Fs)
    ven_ind=round(t_ven*Fs)
    end_ind=round(t_end*Fs)
    
    atrial_phase=np.abs(record[0:atr_ind])
    vent_phase=np.abs(record[ven_ind:end_ind])
    his_phase=np.abs(record[atr_ind:ven_ind])
    
    # finding peaks
    atr_peak= np.nanmax(atrial_phase)
    vent_peak = np.nanmax(vent_phase)
    his_peak = np.nanmax(his_phase)
    
    # peaks values
    if use_ratio:
        if his_peak>his_bundle_th:
            pred_class="Dangerous"
        else:
            # atrial and ventricular thresholds 
            if atr_peak/vent_peak>0.5: 
                pred_class="Indifferent"
            else:
                pred_class="Effective"
    else: 
        if his_peak>his_bundle_th:
            pred_class="Dangerous"
        else:
            # atrial and ventricular thresholds 
            if atr_peak>0.5: 
                pred_class="Indifferent"
            else:
                pred_class="Effective"
            
            
    return np.array(atr_peak),np.array(his_peak),np.array(vent_peak),pred_class


