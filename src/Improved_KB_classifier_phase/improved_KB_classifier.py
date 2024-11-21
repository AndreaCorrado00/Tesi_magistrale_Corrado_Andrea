import numpy as np

def improved_KB_classifier(record,use_ratio=False): 
    # peaks values
    if use_ratio:
        if record["peak3_pos"]>0.28:
            pred_class="MAP_C"
        else:
            # atrial and ventricular thresholds 
            if record["atrial_ventricular_ratio"]>0.2: 
                pred_class="MAP_A"
            else:
                pred_class="MAP_B"
        return record["atrial_ventricular_ratio"],np.array(record["peak3_val"]),pred_class
    
    else: 
        if record["peak3_pos"]>0.28:
            pred_class="MAP_C"
        else:
            # atrial and ventricular thresholds 
            if record["peak1_pos"]<0.48: 
                pred_class="MAP_A"
            else:
                pred_class="MAP_B"
            
        return np.array(record["peak1_pos"]),np.array(record["peak3_pos"]),pred_class


