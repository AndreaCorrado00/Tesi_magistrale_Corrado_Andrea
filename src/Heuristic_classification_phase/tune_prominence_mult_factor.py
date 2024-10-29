def tune_prominence_mult_factor(signals,y_true,interval,plot=False):
    import matplotlib.pyplot as plt
    from sklearn.metrics import f1_score
    import numpy as np
    import sys
    
    sys.path.append("D:/Desktop/ANDREA/Universita/Magistrale/Anno Accademico 2023-2024/TESI/Tesi_magistrale/src/Heuristic_classification_phase")
    from heuristic_classifier import heuristic_classifier
    
    f1_scores = np.zeros((len(interval), 3))

    for idx, mult_factor in enumerate(interval):
        dims = signals.shape
        pred_heuristic = np.empty(dims[0], dtype=object)
        
        for i in range(dims[0]):
            _, _, _, pred = heuristic_classifier(signals.iloc[i], 2035, mult_factor)
            pred_heuristic[i] = pred
        
        f1_scores[idx, :] = f1_score(y_true, pred_heuristic, average=None)
        
    
    # plot
    if plot:
        plt.figure()
        plt.plot(interval,f1_scores[:,0],label="MAP A")
        plt.plot(interval,f1_scores[:,1],label="MAP B")
        plt.plot(interval,f1_scores[:,2],label="MAP C")
        plt.xticks(interval)
        plt.xlabel("Multiply factor")
        plt.ylabel("F1-score")
        plt.title("F1-score per class")
        plt.legend()
        
    # Finding mult_factor which maximise MAP_C f1_score
    max_f1_C_th=interval[f1_scores[:,2]==np.max(f1_scores[:,2])]
    
    return max_f1_C_th[0]