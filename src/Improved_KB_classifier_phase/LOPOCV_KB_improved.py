"""
Performs Leave-One-Participant-Out Cross-Validation (LOPOCV) using an improved knowledge-based classifier.

Parameters:
    df (DataFrame): Dataset containing signal data and associated metadata. Must include columns:
        - 'id': Participant identifier.
        - 'class': True class labels for the signals.
    use_ratio (bool, optional): If True, the improved classifier uses feature ratios for decision-making.

Returns:
    tuple: A tuple containing:
        - all_y_true (list): True class labels aggregated across all test sets.
        - all_y_pred (list): Predicted class labels aggregated across all test sets.
        - all_signal_peaks_and_class_KB_improved (list): List of details for each test signal, including:
            - Feature 1 value (e.g., atrial peak, as determined by the improved classifier).
            - Peak 3 value (e.g., His bundle or ventricular peak, depending on the classifier logic).
            - Predicted class label.

Behavior:
    - Splits the dataset into training and testing subsets, leaving out one participant at a time for testing.
    - Applies the `improved_KB_classifier` function to classify test signals based on extracted features.
    - Aggregates true and predicted labels, along with relevant feature values and classifications, for further analysis.

Notes:
    - The `improved_KB_classifier` function is expected to extract signal features and determine the class label for each signal.
    - This implementation assumes no threshold tuning step, focusing solely on direct classification using the improved knowledge-based approach.
    - The function relies on an external module `improved_KB_classifier` from a specific file path.
    - Designed for datasets where classification depends on participant-specific signal characteristics.
"""


import sys
import numpy as np
def LOPOCV_KB_improved(df,use_ratio=False):

    
    sys.path.append("D:/Desktop/ANDREA/Universita/Magistrale/Anno Accademico 2023-2024/TESI/Tesi_magistrale/src/Improved_KB_classifier_phase")
    from improved_KB_classifier import improved_KB_classifier
    
    all_y_true = []
    all_y_pred = []
    all_signal_peaks_and_class_KB_improved = []
    participant_ids = df['id'].unique()
    
    for participant in participant_ids:
        train_data = df[df['id'] != participant]
        test_data = df[df['id'] == participant]
        
        x_train, y_train = train_data.drop(['id', 'class'], axis=1), train_data['class']
        x_test, y_test = test_data.drop(['id', 'class'], axis=1), test_data['class']
        
        dims = x_test.shape
        
        pred_heuristic = np.empty(dims[0], dtype=object)
                
        signal_peaks_and_class_KB_improved=[];
        
        for i in range(0,dims[0]):
            feature_1_val,peak_3_val,pred=improved_KB_classifier(x_test.iloc[i],use_ratio)
            pred_heuristic[i]=pred
            signal_peaks_and_class_KB_improved.append([feature_1_val.item(),peak_3_val.item(),pred])
            
            
        all_y_true.extend(y_test)
        all_y_pred.extend(pred_heuristic)
        all_signal_peaks_and_class_KB_improved.extend(signal_peaks_and_class_KB_improved)
        
    return all_y_true, all_y_pred, all_signal_peaks_and_class_KB_improved
