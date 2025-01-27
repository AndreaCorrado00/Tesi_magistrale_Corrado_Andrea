"""
Tunes the threshold for His bundle signal classification by analyzing the distribution of maximum peak values within a specified phase.

Parameters:
    x_train (DataFrame): Training dataset containing cardiac signal recordings as rows.
    t_atr (float): Start time (in seconds) of the His bundle phase relative to the signal.
    t_ven (float): End time (in seconds) of the His bundle phase relative to the signal.
    Q_perc (float): Percentile value (0-100) used to determine the threshold for peak amplitudes.
    boxplot (bool): If True, generates a boxplot of the maximum peak values within the His bundle phase.

Returns:
    float: The value of the specified percentile (Q_perc) of the maximum peak amplitudes in the His bundle phase.

Behavior:
    - The function calculates the absolute maximum peak values of the signal within the His bundle phase for each recording in `x_train`.
    - Converts time bounds (`t_atr`, `t_ven`) into signal indices using a fixed sampling rate (2035 Hz).
    - Optionally visualizes the distribution of maximum peaks using a boxplot, with the percentile threshold highlighted.

Notes:
    - Assumes that `x_train` is a Pandas DataFrame where each row corresponds to a single signal.
    - The percentile value is a robust way to estimate a threshold, accounting for variability in the data.
    - The `boxplot` provides insights into the distribution of peak values and helps validate the chosen threshold.
"""


def tune_his_th(x_train, t_atr, t_ven, Q_perc, boxplot):
    import matplotlib.pyplot as plt
    import numpy as np
    
    
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
        plt.ylim([0.0, 0.2])
    

    return np.percentile(max_peaks, Q_perc)

