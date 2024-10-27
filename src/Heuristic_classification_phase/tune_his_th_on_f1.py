def tune_his_th_on_f1(signals, y_true,interval,t_atr, t_ven):
    import matplotlib.pyplot as plt
    from sklearn.metrics import f1_score
    import numpy as np
    import sys
    
    sys.path.append("D:/Desktop/ANDREA/Universita/Magistrale/Anno Accademico 2023-2024/TESI/Tesi_magistrale/src/Heuristic_classification_phase")
    from heuristic_classificator_B import heuristic_classificator_B
    from tune_his_th import tune_his_th
    
    f1_scores = np.zeros((len(interval), 3))

    for idx, Q_perc in enumerate(interval):
        dims = signals.shape
        pred_heuristic = np.empty(dims[0], dtype=object)
        
        his_bundle_th=tune_his_th(signals, t_atr, t_ven, Q_perc,False)
        
        for i in range(dims[0]):
            _, _, _, pred = heuristic_classificator_B(signals.iloc[i], 2035, his_bundle_th)
            pred_heuristic[i] = pred
        
        f1_scores[idx, :] = f1_score(y_true, pred_heuristic, average=None)
        
    
    # plot
    plt.figure()
    plt.plot(interval,f1_scores[:,0],label="MAP A")
    plt.plot(interval,f1_scores[:,1],label="MAP B")
    plt.plot(interval,f1_scores[:,2],label="MAP C")
    plt.xticks(interval)
    plt.xlabel("His Bundle threshold")
    plt.ylabel("F1-score")
    plt.title("F1-score per class")
    plt.legend()
    