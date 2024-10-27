def tune_his_th(x_train, t_atr, t_ven, Q_perc, boxplot):
    import matplotlib.pyplot as plt
    import numpy as np
    
    t_atr = 0.35
    t_ven = 0.45
    
    atr_ind = round(t_atr * 2035)
    ven_ind = round(t_ven * 2035)
    
    max_peaks = np.empty(x_train.shape[0], dtype=float)
    

    for i in range(x_train.shape[0]):
        signal = x_train.iloc[i]
        his_abs_signal = np.abs(signal[atr_ind:ven_ind])
        
        max_peaks[i] = np.nanmax(his_abs_signal)
    percentile_value=np.percentile(max_peaks, Q_perc)
    if boxplot:
        plt.figure()
        plt.boxplot(max_peaks)
        plt.axhline(y=percentile_value, color='black', linestyle=':', label=f'{Q_perc}th Percentile: {percentile_value:.2f}')
        plt.title("His Bundle maxima values")
        plt.ylim([0.0, 0.5])
    

    return np.percentile(max_peaks, Q_perc)

