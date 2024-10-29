def tune_his_th_on_f1(signals, y_true,interval,t_atr, t_ven, plot=False):
    import matplotlib.pyplot as plt
    from sklearn.metrics import f1_score
    import numpy as np
    import sys
    
    sys.path.append("D:/Desktop/ANDREA/Universita/Magistrale/Anno Accademico 2023-2024/TESI/Tesi_magistrale/src/Heuristic_classification_phase")
    from heuristic_classifier_B import heuristic_classifier_B
    from tune_his_th import tune_his_th
    
    f1_scores = np.zeros((len(interval), 3))
    max_peaks = np.zeros((len(signals),  1))

    for idx, Q_perc in enumerate(interval):
        dims = signals.shape
        pred_heuristic = np.empty(dims[0], dtype=object)
        
        his_bundle_th=tune_his_th(signals, t_atr, t_ven, Q_perc,False)
        
        for i in range(dims[0]):
            _, _, _, pred = heuristic_classifier_B(signals.iloc[i], 2035, his_bundle_th)
            pred_heuristic[i] = pred
        
        f1_scores[idx, :] = f1_score(y_true, pred_heuristic, average=None)
        
    
    # plot
    if plot:
        plt.figure()
        plt.plot(interval,f1_scores[:,0],label="MAP A")
        plt.plot(interval,f1_scores[:,1],label="MAP B")
        plt.plot(interval,f1_scores[:,2],label="MAP C")
        plt.xticks(interval)
        plt.xlabel("His Bundle percentile threshold")
        plt.ylabel("F1-score")
        plt.title("F1-score per class")
        plt.legend()
        
    # Finding the threshold which maximise MAP_C f1_score
    max_f1_C_Q_perc=interval[f1_scores[:,2]==np.max(f1_scores[:,2])]
    his_bundle_th=tune_his_th(signals, t_atr, t_ven, max_f1_C_Q_perc[0],False)
    
    return his_bundle_th