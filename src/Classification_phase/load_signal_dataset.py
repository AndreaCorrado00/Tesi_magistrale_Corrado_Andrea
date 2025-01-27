def load_signal_dataset(dataset_path, dataset_name):
    """
    Loads a signal dataset from a specified path, processes it, and returns the dataset along with relevant metadata.

    Parameters:
    -----------
    dataset_path : str
        The directory path where the dataset file is located.
    dataset_name : str
        The name of the dataset file (without extension), which determines the specific dataset to load and process.

    Returns:
    --------
    tuple
        A tuple containing:
        - table (pd.DataFrame): The loaded dataset with processed class labels.
        - features_db (pd.DataFrame): The dataset without 'id' and 'class' columns, containing only the features.
        - y_true (np.array): The array of target class labels corresponding to the dataset.
        - y_true_no_duplicates (np.array): The ordered array of unique class labels.
        - Fs (int): The sampling frequency (default is 2035 Hz).
        - plot_last_name (str): Suffix for plot file names based on the dataset.
        - fig_final_folder (str): Folder name for saving plots specific to the dataset.
        - subtitle_plots (str): The subtitle used in plot titles to describe the dataset.
    """
    import os
    import numpy as np
    import pandas as pd
    
    Fs = 2035  # Sampling frequency (Hz)

    # Define properties for each dataset based on its name
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

    # Construct the full file path to the dataset
    full_name = os.path.join(dataset_path, dataset_name + ".txt")
    
    # Read the dataset from the specified file
    table = pd.read_csv(full_name, delimiter=',')
    
    # Mapping original class labels to standardized ones
    class_mapping = {
        "MAP_A": "Indifferent",
        "MAP_B": "Effective",
        "MAP_C": "Dangerous"
    }
    
    # Apply class mapping
    table["class"] = table["class"].map(class_mapping)

    # Maintain the original order of classes from the dataset
    unique_classes_in_order = table["class"].drop_duplicates().tolist()
    
    # Sort y_true_no_duplicates based on the order found in the dataset
    y_true_no_duplicates = pd.Categorical(
        table["class"],
        categories=unique_classes_in_order,
        ordered=True
    )
    
    # Convert to an ordered array of unique class labels
    y_true_no_duplicates = np.array(["Indifferent", "Effective", "Dangerous"], order="A")

    # Return the processed dataset, features, and relevant metadata
    return table, table.iloc[:, 1:-1], np.array(table["class"], order="A"), y_true_no_duplicates, Fs, plot_last_name, fig_final_folder, subtitle_plots
