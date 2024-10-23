def handle_filtered_data(are_filt):
    import pandas as pd
    import numpy as np
    Fs=2035; #  Hz
    
    if are_filt:
        plot_filt="_filtered"
        fig_path_filt="/Filtered"
        data=pd.read_csv("D:/Desktop/ANDREA/Universita/Magistrale/Anno Accademico 2023-2024/TESI/Tesi_magistrale/Data/Processed/AVNRT_DB_FILT.csv")
        addition_title_plots="Data: filtered"
    else:
        plot_filt=""
        fig_path_filt="/No_filtered"
        data=pd.read_csv("D:/Desktop/ANDREA/Universita/Magistrale/Anno Accademico 2023-2024/TESI/Tesi_magistrale/Data/Processed/AVNRT_DB.csv")
        addition_title_plots="Data: not filtered"

    # extraction of labels and signals
    y_true=np.array(data['class'])
    labels_unique=np.unique(y_true)
    data=data.drop('class',axis=1)
        
    return data,y_true,labels_unique,Fs,plot_filt,fig_path_filt,addition_title_plots