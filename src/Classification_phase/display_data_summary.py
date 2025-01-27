def display_data_summary(data, labels_unique):
    """
    Displays a summary of the data, including its shape, classes, and any presence of missing values (NaNs).

    Parameters:
    -----------
    data : pd.DataFrame
        The DataFrame containing the dataset to be summarized.
        It is assumed that the last column contains the class labels.

    labels_unique : list
        A list of unique class labels that will be printed to show the available classes in the dataset.

    Behavior:
    ---------
    - Prints the first few rows of the data using `.head()`.
    - Prints the number of signals (rows) and the number of points (columns excluding the class column).
    - Prints the unique classes present in the dataset.
    - Checks if there are any missing (NaN) values in the data and prints an appropriate message if NaNs are present.

    Returns:
    --------
    None (This function outputs information about the dataset directly to the console.)
    """

    print(data.head)

    # data dimensionality
    dims=data.shape
    print("Number of signals: "+ str(dims[0]))
    print("Number of points: "+ str(dims[1]-1))

    # classes
        # just to print 
    labels_string = ", ".join(labels_unique)
    print("Classes: " + labels_string)

    # NaN presence is known but:
    has_nan=data.isna().any().any()

    if has_nan :
        print("Data have NaN points")
    
