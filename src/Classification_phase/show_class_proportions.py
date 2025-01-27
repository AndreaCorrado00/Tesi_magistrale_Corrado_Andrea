def show_class_proportions(labels, labels_unique):
    """
    This function calculates and prints the proportion of signals belonging to each class (label) in the dataset.
    The function expects a list/array of class labels and computes the number of occurrences and the percentage of each unique class.

    Parameters:
    -----------
    labels : numpy.array or pandas.Series
        An array or Series containing the class labels for each signal in the dataset.

    labels_unique : numpy.array or list
        An array or list containing the unique class labels that are to be evaluated for proportions.

    Returns:
    --------
    None
        The function prints out the number of signals for each class and their corresponding percentage of the total signals.

    Notes:
    ------
    - This function prints the result directly to the console.
    - It assumes that `labels` contains the class information for each signal and that `labels_unique` contains the set of unique classes in the dataset.
    - The percentage is calculated with respect to the total number of signals (`N`).
    """

    import numpy as np
    import pandas as pd
    
    N=labels.shape[0]
    print(f"Number of signals for each Map")
    for i in range(0,labels_unique.shape[0]):
        label_subset=np.array(labels==labels_unique[i])
        n=np.sum(label_subset)
        prop=round((n/N)*100,2)
        print(f" - {labels_unique[i]}: {n} signals ({prop} %)")
        
        

