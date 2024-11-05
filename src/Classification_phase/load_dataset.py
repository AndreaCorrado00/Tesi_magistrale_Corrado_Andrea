import os
import numpy as np
import pandas as pd

def load_dataset(dataset_path, dataset_name):
    # initialization
    subject_ids = []
    signal_data = []
    y_true = []
    
    Fs=2035
    
    if dataset_name=="dataset_1":
        plot_last_name='_whole'
        fig_final_folder="No_filtered"
        subtitle_plots="processed data"
    elif dataset_name=="dataset_2":
        plot_last_name="_no_sub2"
        fig_final_folder="No_filtered_no_2"
        subtitle_plots="processed data, no sub 2"
    elif dataset_name=="dataset_3":
        plot_last_name="_2mapC"
        fig_final_folder="No_filtered_2mapC"
        subtitle_plots= "MAP C of subject 2 maintained" 
    else: 
        print("No dataset found")
        return []
    
    # Directory of the dataset requested
    dataset_dir = os.path.join(dataset_path, dataset_name)
    for subj_folder in sorted(os.listdir(dataset_dir)):
        if subj_folder.startswith("pat"):
            subject_id = int(subj_folder[3:])
            subject_dir = os.path.join(dataset_dir, subj_folder)
            
            # looking for rov_MAPY.txt
            for map_type in ["A", "B", "C"]:
                file_name = f"rov_MAP{map_type}.txt"
                file_path = os.path.join(subject_dir, file_name)
                print(file_path)
                
                # Does the table exist?
                if os.path.exists(file_path):
                    # table loading
                    table = pd.read_csv(file_path, header=None)
                    print(table.shape)
                    # Iterate through columns as separate signals
                    for col in table.columns:
                        signal_data.append(table[col].values)  # Each column (signal) is appended as a row
                        subject_ids.append(subject_id)
                        y_true.append(f"MAP_{map_type}")

    # Final dataset
    data = pd.DataFrame(signal_data)
    data.insert(0, 'id', subject_ids)  # First column: subject ID
    data['class'] = y_true  # Last column: class (MAP_Y)
    
    return data, data.iloc[:, 1:-1], np.array(y_true),np.unique(np.array(y_true)),Fs,plot_last_name,fig_final_folder,subtitle_plots  # signals extracted as a DataFrame slice

