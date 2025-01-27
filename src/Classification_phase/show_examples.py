def show_examples(data, Fs, map_A_idx, map_B_idx, map_C_idx):
    """
    Displays three examples of signals (or time-series data) from different classes (Map A, Map B, Map C) 
    for visualization, with each class's signal plotted in a separate subplot. 

    The function expects data in the form of a pandas DataFrame, with each row representing a signal for a given class. 
    The indices corresponding to each map (class A, B, and C) are passed to retrieve the specific rows for plotting.

    Parameters:
    -----------
    data : pandas.DataFrame
        A DataFrame containing the signals (or time-series data) for different classes. Each row represents a signal.

    Fs : float
        The sampling frequency of the data, used to calculate the time axis in seconds.

    map_A_idx : list or array-like
        A list of indices representing the specific examples from class A to be visualized.

    map_B_idx : list or array-like
        A list of indices representing the specific examples from class B to be visualized.

    map_C_idx : list or array-like
        A list of indices representing the specific examples from class C to be visualized.

    Returns:
    --------
    None
        The function generates a plot with three subplots, each showing one example signal for Map A, Map B, and Map C.
        The signals are plotted against the time axis (in seconds), calculated using the given sampling frequency (Fs).
    
    Notes:
    ------
    - The x-axis of each subplot is from 0 to 1 second, and the signals are plotted in the range of 0 to 1 second for visual inspection.
    - The function automatically sets the y-axis label to represent the units in millivolts ([mV]), assuming the data is in this unit.
    - The `tight_layout()` function is used to ensure that the subplots do not overlap and the plot is neatly arranged.
    """

    
    import numpy as np
    import matplotlib.pyplot as plt
    example_class_A=np.array(data.loc[map_A_idx])
    example_class_B=np.array(data.loc[map_B_idx])
    example_class_C=np.array(data.loc[map_C_idx])
    
    t=np.arange(0,len(example_class_A)/Fs,1/Fs)
    
    plt.figure()
    plt.subplot(3,1,1)
    plt.plot(t,example_class_A,label="Example of map A")
    plt.title('Map A example')
    plt.xlabel("Time [s]")
    plt.ylabel("[mV]")
    plt.xlim(0,1)
    
    plt.subplot(3,1,2)
    plt.plot(t,example_class_B,label="Example of map B")
    plt.title('Map B example')
    plt.xlabel("Time [s]")
    plt.ylabel("[mV]")
    plt.xlim(0,1)
    
    plt.subplot(3,1,3)
    plt.plot(t,example_class_C,label="Example of map C")
    plt.title('Map C example')
    plt.xlabel("Time [s]")
    plt.ylabel("[mV]")
    plt.xlim(0,1)
    
    plt.tight_layout()
