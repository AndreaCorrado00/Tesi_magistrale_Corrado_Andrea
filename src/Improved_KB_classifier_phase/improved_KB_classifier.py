"""
Classifies a signal into one of three categories ('Dangerous', 'Indifferent', 'Effective') based on the provided features.

Parameters:
-----------
record : pandas.Series
    A record containing feature values of a single observation. Expected keys are:
        - "Minor_peak": The value of the minor peak.
        - "atrial_ventricular_ratio": The ratio between atrial and ventricular peaks (used if `use_ratio=True`).
        - "Dominant_peak_time": The time of the dominant peak (used if `use_ratio=False`).
use_ratio : bool, optional, default=False
    Flag indicating whether to use the atrial-ventricular ratio for classification (`True`) or the dominant peak time (`False`).

Returns:
--------
tuple : (float, float, str)
    A tuple containing:
        - The calculated ratio or dominant peak time (numpy array).
        - The minor peak value (numpy array).
        - The predicted class as a string ("Dangerous", "Indifferent", or "Effective").

Classification Logic:
---------------------
- If `use_ratio=True`:
    - If the `Minor_peak` is greater than 0.020, classify as "Dangerous".
    - Otherwise, if the `atrial_ventricular_ratio` is greater than 0.2, classify as "Indifferent".
    - Otherwise, classify as "Effective".

- If `use_ratio=False`:
    - If the `Minor_peak` is greater than 0.020, classify as "Dangerous".
    - Otherwise, if the `Dominant_peak_time` is less than 0.49, classify as "Indifferent".
    - Otherwise, classify as "Effective".
"""

import numpy as np

def improved_KB_classifier(record,use_ratio=False): 
    # peaks values
    if use_ratio:
        if record["Minor_peak"]>0.020:
            pred_class="Dangerous"
        else:
            # atrial and ventricular thresholds 
            if record["atrial_ventricular_ratio"]>0.2: 
                pred_class="Indifferent"
            else:
                pred_class="Effective"
        return record["atrial_ventricular_ratio"],np.array(record["Minor_peak"]),pred_class
    
    else: 
        if record["Minor_peak"]>0.020:
            pred_class="Dangerous"
        else:
            # atrial and ventricular thresholds 
            if record["Dominant_peak_time"]<0.49: 
                pred_class="Indifferent"
            else:
                pred_class="Effective"
            
        return np.array(record["Dominant_peak_time"]),np.array(record["Minor_peak"]),pred_class

   