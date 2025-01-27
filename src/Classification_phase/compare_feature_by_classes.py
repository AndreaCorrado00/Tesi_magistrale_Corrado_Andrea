import matplotlib.pyplot as plt

def compare_feature_by_classes(feature_db, feature_name):
    """
    Compares the distribution of a specific feature across different classes by visualizing boxplots.
    The classes are assumed to be 'Indifferent', 'Effective', and 'Dangerous' in the 'class' column of the DataFrame.

    Parameters:
    -----------
    feature_db : pd.DataFrame
        A DataFrame containing the feature values and class labels.
        It is expected that the DataFrame has at least two columns: 
        - One containing the feature values to be compared.
        - One labeled 'class' containing the class labels.

    feature_name : str
        The name of the feature column to be compared across classes.

    Behavior:
    ---------
    - Extracts the values of the specified feature for each class: 'Indifferent', 'Effective', and 'Dangerous'.
    - Generates a boxplot for each class, showing the distribution of feature values.
    - The boxplots are displayed without outliers (fliers).
    
    Returns:
    --------
    None (This function generates and displays a boxplot for visual comparison.)
    """

    # expected a 2 cols dataframe:
        # col 1: feature value 
        # col 2: map of the signals from which the feature is evalated
    map_A_feature=feature_db[feature_name][feature_db["class"]=="Indifferent"]
    map_B_feature=feature_db[feature_name][feature_db["class"]=="Effective"]
    map_C_feature=feature_db[feature_name][feature_db["class"]=="Dangerous"]   
    
    boxplot_data=[map_A_feature,map_B_feature,map_C_feature]
    
    # showing boxplots
    plt.figure()
    plt.boxplot(boxplot_data,showfliers=False)
    plt.xticks([1,2,3],["Indifferent","Effective","Dangerous"])
    plt.title(f"{feature_name}, class distribution")
    