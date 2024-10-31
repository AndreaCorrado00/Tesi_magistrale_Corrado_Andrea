def LOPOCV_heuristic_A(df):
    import sys
    import numpy as np
    
    sys.path.append("D:/Desktop/ANDREA/Universita/Magistrale/Anno Accademico 2023-2024/TESI/Tesi_magistrale/src/Heuristic_classification_phase")
    from heuristic_classifier import heuristic_classifier
    from tune_prominence_mult_factor import tune_prominence_mult_factor
    
    all_y_true = []
    all_y_pred = []
    all_signal_peaks_and_class_train = []
    participant_ids = df['id'].unique()
    
    for participant in participant_ids:
        train_data = df[df['id'] != participant]
        test_data = df[df['id'] == participant]
        
        
        x_train, y_train = train_data.drop(['id','class'],axis=1), train_data['class']
        x_test, y_test = test_data.drop(['id','class'],axis=1), test_data['class']
        
        dims=x_test.shape
        
        pred_heuristic=np.empty(dims[0], dtype=object)
        signal_peaks_and_class_train=[];
        
        mult_factor=tune_prominence_mult_factor(x_train,y_train,np.array(np.arange(1,15,1)), False)
        
        for i in range(0,dims[0]):
            atr_peak,his_peak,vent_peak,pred=heuristic_classifier(x_test.iloc[i],2035,mult_factor)
            pred_heuristic[i]=pred
            
            original_index = test_data.index[i] 
            signal_peaks_and_class_train.append([original_index.item(), participant.item(), atr_peak, his_peak, vent_peak, pred])
        
        all_y_true.extend(y_test)
        all_y_pred.extend(pred_heuristic)
        all_signal_peaks_and_class_train.extend(signal_peaks_and_class_train)
        
    return all_y_true,all_y_pred,all_signal_peaks_and_class_train