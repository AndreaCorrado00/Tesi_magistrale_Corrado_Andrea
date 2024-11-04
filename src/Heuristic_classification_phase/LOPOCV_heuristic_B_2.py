def LOPOCV_heuristic_B_2(df):
    import sys
    import numpy as np
    
    sys.path.append("D:/Desktop/ANDREA/Universita/Magistrale/Anno Accademico 2023-2024/TESI/Tesi_magistrale/src/Heuristic_classification_phase")
    from heuristic_classifier_B_2 import heuristic_classifier_B_2
    from tune_relative_his_th_on_f1 import tune_relative_his_th_on_f1
    
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
        
        th_his,Q_perc=tune_relative_his_th_on_f1(x_train,y_train,np.arange(0,100,5),t_atr=0.38,t_ven=0.42,plot=False)
        
        for i in range(0,dims[0]):
            atr_peak,his_peak,vent_peak,pred=heuristic_classifier_B_2(x_test.iloc[i],2035,th_his)
            pred_heuristic[i]=pred
            amplitude=np.nanmax(x_test.iloc[i])-np.nanmin(x_test.iloc[i])
            original_index = test_data.index[i]
            #print(original_index,atr_peak,his_peak,vent_peak,pred,his_peak)
            
            signal_peaks_and_class_train.append([original_index.item(), participant.item(), atr_peak, his_peak, vent_peak, pred, th_his*amplitude.item()])
        
        all_y_true.extend(y_test)
        all_y_pred.extend(pred_heuristic)
        all_signal_peaks_and_class_train.extend(signal_peaks_and_class_train)
        
    return all_y_true,all_y_pred,all_signal_peaks_and_class_train