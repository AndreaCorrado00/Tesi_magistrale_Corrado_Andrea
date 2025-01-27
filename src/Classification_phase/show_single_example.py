def show_single_example(data, Fs, idx, title_plot, use_iloc=True):
    """
    Visualizes a single example from a dataset in the form of a time series plot.

    This function plots a specific example (signal) from a dataset, displaying its 
    amplitude over time. The time series is represented with respect to the sampling 
    frequency (`Fs`) provided. The plot shows the signal for 1 second, with an 
    optional option to retrieve data using `.iloc` or `.loc` for index access.

    Parameters:
    -----------
    data : pandas.DataFrame or pandas.Series
        The dataset containing the signal data. It is assumed that each row represents
        the signal for a single time point. If the dataset is a DataFrame, each column 
        should represent a different signal/channel.

    Fs : float
        The sampling frequency (Hz). It indicates how often the signal is sampled per second
        and is used to convert the index of the signal to time in seconds.

    idx : int
        The index of the signal (or row) to be plotted. This corresponds to a specific signal 
        from the dataset.

    title_plot : str
        The title of the plot to be displayed. This should provide context for the signal 
        being visualized (e.g., signal name or experiment).

    use_iloc : bool, optional, default=True
        A flag to specify how to access the signal data. If `True`, the signal is retrieved
        using `.iloc` (integer-location based indexing). If `False`, the signal is retrieved
        using `.loc` (label-based indexing). This gives flexibility for using either index or label-based access.

    Returns:
    --------
    None
        The function produces a plot and does not return any values.
    
    Notes:
    ------
    - The plot is always limited to the first 1 second of the signal data, and the time axis 
      is divided in increments of 0.1 seconds for clear visualization.
    - The signal's amplitude is expected to be in millivolts (mV), but this can be adjusted if needed.
    - The x-axis range is fixed between 0 and 1 second to zoom into the signal for better visibility.
    - `tight_layout()` ensures the plot elements do not overlap, especially when displaying labels and ticks.
    """

    
    import numpy as np
    import matplotlib.pyplot as plt
    if use_iloc:
        example=np.array(data.iloc[idx])
    else:
        example=np.array(data.loc[idx])
    
    t=np.arange(0,len(example)/Fs,1/Fs)
    
    plt.figure()
    plt.plot(t,example)
    plt.title(title_plot)
    plt.xlabel("Time [s]")
    plt.ylabel("[mV]")
    plt.xlim(0,1)
    plt.xticks(np.arange(0,1,0.1))
    plt.tight_layout()
