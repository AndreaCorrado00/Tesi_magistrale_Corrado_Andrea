def save_plot(fig, figure_path, file_name="plot", dpi=300):
    """
    This function saves a given Matplotlib figure (`fig`) to a specified location on the disk as a PNG image.
    The user can specify the directory path (`figure_path`), file name (`file_name`), and the DPI (dots per inch)
    for the saved image.

    Parameters:
    -----------
    fig : matplotlib.figure.Figure
        The Matplotlib figure object to be saved.

    figure_path : str
        The directory path where the figure will be saved.

    file_name : str, optional (default="plot")
        The name of the file without extension. The extension ".png" will be automatically added.

    dpi : int, optional (default=300)
        The resolution of the saved image in dots per inch (DPI). Higher DPI results in higher image quality.

    Returns:
    --------
    None
        The function saves the figure as a PNG image to the specified location.

    Notes:
    ------
    - If the `figure_path` does not exist, an error will be raised.
    - The saved image is formatted in PNG with the name specified by `file_name`.
    - The `bbox_inches="tight"` option ensures that the bounding box of the saved image is tightly adjusted around the figure content.
    """

    import os
    name_file_complete = f"{file_name}.png"
    full_path = os.path.join(figure_path, name_file_complete)
    
    fig.savefig(full_path,dpi=dpi,bbox_inches="tight")
    