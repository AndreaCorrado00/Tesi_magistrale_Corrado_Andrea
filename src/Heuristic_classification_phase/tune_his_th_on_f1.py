"""
Tunes the His bundle threshold to optimize F1-scores for a heuristic classifier across specified signal intervals.

Parameters:
    signals (DataFrame): Dataset containing cardiac signal recordings as rows.
    y_true (array-like): True labels for the classification, used to compute F1-scores.
    interval (list or array-like): List of percentiles to evaluate for tuning the His bundle threshold.
    t_atr (float): Start time (in seconds) of the His bundle phase relative to the signal.
    t_ven (float): End time (in seconds) of the His bundle phase relative to the signal.
    plot (bool, optional): If True, generates a plot of F1-scores for each class across the evaluated percentiles.
    use_ratio (bool, optional): If True, the classifier uses peak amplitude ratios for classification decisions.

Returns:
    float: The optimal His bundle threshold based on the percentile that maximizes the F1-score for the "Dangerous" class.

Behavior:
    - For each percentile in `interval`, calculates the corresponding His bundle threshold using the `tune_his_th` function.
    - Applies the `heuristic_classifier_C` function to classify signals based on the calculated threshold.
    - Computes F1-scores for each class and identifies the threshold that maximizes the F1-score for the "Dangerous" class.
    - Optionally plots F1-scores for each class as a function of the percentile thresholds.

Notes:
    - The function assumes a fixed sampling rate of 2035 Hz.
    - The "Dangerous" class is prioritized for threshold optimization based on its F1-score.
    - The plot provides visual feedback on the F1-score trends for each class, aiding interpretability.
    - Dependencies include `heuristic_classifier_C` and `tune_his_th` from the specified file path.
"""

def tune_his_th_on_f1(signals, y_true,interval,t_atr, t_ven, plot=False,use_ratio=False):
    import matplotlib.pyplot as plt
    from sklearn.metrics import f1_score
    import numpy as np
    import sys
    
    sys.path.append("D:/Desktop/ANDREA/Universita/Magistrale/Anno Accademico 2023-2024/TESI/Tesi_magistrale/src/Heuristic_classification_phase")
    from heuristic_classifier_C import heuristic_classifier_C
    from tune_his_th import tune_his_th
    
    f1_scores = np.zeros((len(interval), 3))
    max_peaks = np.zeros((len(signals),  1))

    for idx, Q_perc in enumerate(interval):
        dims = signals.shape
        pred_heuristic = np.empty(dims[0], dtype=object)
        
        his_bundle_th=tune_his_th(signals, t_atr, t_ven, Q_perc,False)
        
        for i in range(dims[0]):
            _, _, _, pred = heuristic_classifier_C(signals.iloc[i], 2035, his_bundle_th,use_ratio)
            pred_heuristic[i] = pred
        
        f1_scores[idx, :] = f1_score(y_true, pred_heuristic, average=None)
        
    
    # plot
    if plot:
        plt.figure()
        plt.plot(interval,f1_scores[:,0],label="Indifferent")
        plt.plot(interval,f1_scores[:,1],label="Effective")
        plt.plot(interval,f1_scores[:,2],label="Dangerous")
        plt.xticks(interval)
        plt.xlabel("His Bundle percentile threshold")
        plt.ylabel("F1-score")
        plt.title("F1-score per class")
        plt.legend()
        
    # Finding the threshold which maximise MAP_C f1_score
    max_f1_C_Q_perc=interval[f1_scores[:,2]==np.max(f1_scores[:,2])]
    his_bundle_th=tune_his_th(signals, t_atr, t_ven, max_f1_C_Q_perc[0],False)
    
    return his_bundle_th