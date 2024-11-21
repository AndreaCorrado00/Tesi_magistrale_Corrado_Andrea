import os
import numpy as np
import pandas as pd

def load_signal_dataset(dataset_path, dataset_name):
    
    Fs = 2035
    
    if dataset_name == "dataset_1":
        plot_last_name = '_whole'
        fig_final_folder = "No_filtered"
        subtitle_plots = "processed data"
    elif dataset_name == "dataset_2":
        plot_last_name = "_no_sub2"
        fig_final_folder = "No_filtered_no_2"
        subtitle_plots = "processed data, no sub 2"
    elif dataset_name == "dataset_3":
        plot_last_name = "_2mapC"
        fig_final_folder = "No_filtered_2mapC"
        subtitle_plots = "MAP C of subject 2 maintained"
    else: 
        print("No dataset found")
        return []
    
    full_name=os.path.join(dataset_path, dataset_name+".txt")
    table= pd.read_csv(full_name, delimiter=',')

    y_true_no_duplicates = table["class"]  


    # Return the cleaned dataset, signals without duplicates, y_true without duplicates
    return table, table.iloc[:, 1:-1], y_true_no_duplicates, np.unique(y_true_no_duplicates), Fs, plot_last_name, fig_final_folder, subtitle_plots  # signals extracted as a DataFrame slice
