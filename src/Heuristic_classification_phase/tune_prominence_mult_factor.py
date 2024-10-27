def tune_prominence_mult_factor(signals,y_true,interval):
    import matplotlib.pyplot as plt
    from sklearn.metrics import f1_score
    import numpy as np
    import sys
    
    sys.path.append("D:/Desktop/ANDREA/Universita/Magistrale/Anno Accademico 2023-2024/TESI/Tesi_magistrale/src/Heuristic_classification_phase")
    from heuristic_classificator import heuristic_classificator
    
    f1_scores = np.zeros((len(interval), 3))

    for idx, mult_factor in enumerate(interval):
        dims = signals.shape
        pred_heuristic = np.empty(dims[0], dtype=object)
        
        for i in range(dims[0]):
            _, _, _, pred = heuristic_classificator(signals.iloc[i], 2035, mult_factor)
            pred_heuristic[i] = pred
        
        f1_scores[idx, :] = f1_score(y_true, pred_heuristic, average=None)
        
    
    # plot
    plt.figure()
    plt.plot(interval,f1_scores[:,0],label="MAP A")
    plt.plot(interval,f1_scores[:,1],label="MAP B")
    plt.plot(interval,f1_scores[:,2],label="MAP C")
    plt.xticks(interval)
    plt.xlabel("Multiply factor")
    plt.ylabel("F1-score")
    plt.title("F1-score per class")
    plt.legend()
    