def load_feature_dataset(dataset_path, dataset_name):
    """
    Loads a feature dataset from a specified path and returns the dataset and its corresponding feature database.

    Parameters:
    -----------
    dataset_path : str
        The directory path where the dataset file is located.
    dataset_name : str
        The name of the dataset file (without extension).

    Returns:
    --------
    tuple
        A tuple containing:
        - data (pd.DataFrame): The loaded dataset including all columns.
        - features_db (pd.DataFrame): The feature database extracted from the loaded dataset, excluding the first and last columns.
    """
    import pandas as pd
    import os
    
    # Construct the full file path to the dataset
    full_name = os.path.join(dataset_path, dataset_name + ".txt")
    
    # Read the dataset from the specified file
    table = pd.read_csv(full_name, delimiter=',')
    
    # Create the full dataset DataFrame
    data = pd.DataFrame(table)
    
    # Extract the features database (excluding 'id' column and the last column 'class')
    features_db = data.iloc[:, 1:-1]
    
    # Return the full dataset and the features database
    return data, features_db
