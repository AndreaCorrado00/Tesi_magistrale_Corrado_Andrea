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
