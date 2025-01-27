def handle_filtered_data(are_filt):
    """
    Loads and processes a dataset based on whether the data is filtered or not. The function reads the appropriate CSV file, 
    extracts relevant data (signals and labels), and returns key variables used for further analysis.

    Parameters:
    -----------
    are_filt : bool
        A flag indicating whether to load filtered data (True) or unfiltered data (False).

    Returns:
    --------
    tuple
        A tuple containing the following elements:
        - data (pd.DataFrame): The loaded dataset.
        - signals (pd.DataFrame): The dataset with 'id' and 'class' columns removed (features).
        - y_true (np.ndarray): The true class labels.
        - labels_unique (np.ndarray): The unique class labels.
        - Fs (int): The sampling frequency (set to 2035 Hz).
        - plot_filt (str): A suffix for plot titles and file paths, depending on whether the data is filtered or not.
        - fig_path_filt (str): The file path for saving figures, depending on the data filtering status.
        - addition_title_plots (str): A string indicating whether the data is filtered or not, used in plot titles.
    """
    import pandas as pd
    import numpy as np
    Fs = 2035  # Hz
    
    if are_filt:
        plot_filt = "_filtered"
        fig_path_filt = "/Filtered"
        data = pd.read_csv("D:/Desktop/ANDREA/Universita/Magistrale/Anno Accademico 2023-2024/TESI/Tesi_magistrale/Data/Processed/AVNRT_DB_filt.csv")
        addition_title_plots = "Data: filtered"
    else:
        plot_filt = ""
        fig_path_filt = "/No_filtered"
        data = pd.read_csv("D:/Desktop/ANDREA/Universita/Magistrale/Anno Accademico 2023-2024/TESI/Tesi_magistrale/Data/Processed/AVNRT_DB_no_filt.csv")
        addition_title_plots = "Data: not filtered"

    # Extraction of labels and signals
    y_true = np.array(data['class'])
    labels_unique = np.unique(y_true)
    signals = data.drop(['id', 'class'], axis=1)
        
    return data, signals, y_true, labels_unique, Fs, plot_filt, fig_path_filt, addition_title_plots
