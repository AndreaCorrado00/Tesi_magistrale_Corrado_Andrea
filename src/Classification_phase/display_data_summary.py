def display_data_summary(data,labels_unique):
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
    
