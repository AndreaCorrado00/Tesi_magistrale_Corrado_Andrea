"""
Performs Leave-One-Participant-Out Cross-Validation (LOPOCV) using a heuristic classifier to evaluate signal classification performance.

Parameters:
    df (DataFrame): Dataset containing signal data and associated metadata. Must include columns:
        - 'id': Participant identifier.
        - 'class': True class labels for the signals.
    use_ratio (bool, optional): If True, the heuristic classifier uses peak amplitude ratios for decision-making.

Returns:
    tuple: A tuple containing:
        - all_y_true (list): True class labels aggregated across all test sets.
        - all_y_pred (list): Predicted class labels aggregated across all test sets.
        - all_signal_peaks_and_class_train (list): List of details for each test signal, including:
            - Original index in the dataset.
            - Participant ID.
            - Atrial peak value.
            - His bundle peak value.
            - Ventricular peak value.
            - Predicted class label.
            - His bundle threshold used for classification.

Behavior:
    - Splits the dataset into training and testing subsets, leaving out one participant at a time for testing.
    - Tunes the His bundle threshold on the training data using the `tune_his_th_on_f1` function.
    - Classifies test signals using the `heuristic_classifier_C` function.
    - Aggregates true and predicted labels, along with peak signal values and classification thresholds for further analysis.

Notes:
    - The His bundle threshold is optimized on the training data for each fold using F1-score maximization.
    - Assumes a fixed sampling rate of 2035 Hz and signal bounds for atrial (`t_atr`) and ventricular (`t_ven`) phases.
    - The function relies on external modules `heuristic_classifier_C` and `tune_his_th_on_f1` from a specific file path.
    - Designed for datasets where signal classification depends on participant-specific variability.
"""


def LOPOCV_heuristic_C(df,use_ratio=False):
    import sys
    import numpy as np
    
    sys.path.append("D:/Desktop/ANDREA/Universita/Magistrale/Anno Accademico 2023-2024/TESI/Tesi_magistrale/src/Heuristic_classification_phase")
    from heuristic_classifier_C import heuristic_classifier_C
    from tune_his_th_on_f1 import tune_his_th_on_f1
    
    all_y_true = []
    all_y_pred = []
    all_signal_peaks_and_class_train = []
    participant_ids = df['id'].unique()
    
    for participant in participant_ids:
        train_data = df[df['id'] != participant]
        test_data = df[df['id'] == participant]
        
        x_train, y_train = train_data.drop(['id', 'class'], axis=1), train_data['class']
        x_test, y_test = test_data.drop(['id', 'class'], axis=1), test_data['class']
        
        dims = x_test.shape
        
        pred_heuristic = np.empty(dims[0], dtype=object)
        signal_peaks_and_class_train = []
        
        th_his = tune_his_th_on_f1(x_train, y_train, np.arange(0, 100, 5), t_atr=0.38, t_ven=0.42, plot=False)
        
        for i in range(0, dims[0]):
            atr_peak, his_peak, vent_peak, pred = heuristic_classifier_C(x_test.iloc[i], 2035, th_his,use_ratio)
            pred_heuristic[i] = pred
            
            original_index = test_data.index[i] 
            signal_peaks_and_class_train.append([original_index, participant, atr_peak.item(), his_peak.item(), vent_peak.item(), pred, th_his.item()])
        
        all_y_true.extend(y_test)
        all_y_pred.extend(pred_heuristic)
        all_signal_peaks_and_class_train.extend(signal_peaks_and_class_train)
        
    return all_y_true, all_y_pred, all_signal_peaks_and_class_train
