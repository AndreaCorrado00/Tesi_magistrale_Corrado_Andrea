import numpy as np

def improved_KB_classifier(record,use_ratio=False): 
    # peaks values
    if use_ratio:
        if record["Minor_peak"]>0.020:
            pred_class="MAP_C"
        else:
            # atrial and ventricular thresholds 
            if record["atrial_ventricular_ratio"]>0.2: 
                pred_class="MAP_A"
            else:
                pred_class="MAP_B"
        return record["atrial_ventricular_ratio"],np.array(record["Minor_peak"]),pred_class
    
    else: 
        if record["Minor_peak"]>0.021:
            pred_class="MAP_C"
        else:
            # atrial and ventricular thresholds 
            if record["Dominant_peak_time"]<0.49: 
                pred_class="MAP_A"
            else:
                pred_class="MAP_B"
            
        return np.array(record["Dominant_peak_time"]),np.array(record["Minor_peak"]),pred_class

   