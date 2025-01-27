import sys
import matplotlib.pyplot as plt
sys.path.append("D:/Desktop/ANDREA/Universita/Magistrale/Anno Accademico 2023-2024/TESI/Tesi_magistrale/src/Classification_phase")
from save_plot import save_plot
import pandas as pd

def plot_dataframe_as_plain_image(df, figsize=(8, 4), path=None, saving_name=None, scale=(1, 1), use_rowLabels=None, title_plot=None):
    """
    This function generates a visual representation of a Pandas DataFrame as an image. The DataFrame is plotted as a table, and
    the image can be customized with different scaling options, row labels, and titles. The generated plot is then saved as an image.

    Parameters:
    -----------
    df : pd.DataFrame
        The DataFrame to be plotted. The values of the DataFrame will be rendered as a table.

    figsize : tuple, optional (default=(8, 4))
        The size of the figure (width, height) in inches.

    path : str, optional (default=None)
        The directory path where the plot will be saved. If not provided, the plot will not be saved.

    saving_name : str, optional (default=None)
        The name of the saved file. The extension (e.g., .png) will be handled in the `save_plot` function. 
        If not provided, the plot will not be saved.

    scale : tuple, optional (default=(1, 1))
        The scaling factor applied to the table cells. The first value scales the horizontal size, and the second value scales the vertical size.

    use_rowLabels : bool, optional (default=None)
        Whether to include row labels in the table. If set to `True`, the DataFrame's index will be used as row labels; otherwise, no row labels will be shown.

    title_plot : str, optional (default=None)
        The title of the plot, which will be displayed above the table.

    Returns:
    --------
    None
        The function does not return anything. It either displays the plot or saves it to the specified location.

    Notes:
    ------
    - If the `df` contains a row with the label "accuracy", the function adds an empty row to avoid display issues with the "accuracy" row.
    - The `save_plot` function (imported from the `save_plot.py` module) is used to save the image if `path` and `saving_name` are provided.
    - The table cells and headers have black borders, and their background color is set to white.
    """
    
    # Format float values to two decimal places
    df = df.map(lambda x: f"{x:.2f}" if isinstance(x, float) else x)
    
    # Handling possibly strange rows, like accuracy in he_report
    if 'accuracy' in df.index:
        empty_row = pd.DataFrame([[""] * df.shape[1]], columns=df.columns)
        empty_row.index=[""]
        df = pd.concat([df.iloc[:3], empty_row, df.iloc[3:]])  # Add an empty row around 'accuracy'
        df.loc["accuracy",["precision","recall","support"]]=""  # Empty specific values for 'accuracy' row
    
    # Create the figure and axis for plotting
    fig, ax = plt.subplots(figsize=figsize)
    ax.axis('off')  # Hide axis
    
    # Create the table in the plot, with optional row labels
    if use_rowLabels:
        table = ax.table(cellText=df.values, colLabels=df.columns, rowLabels=df.index, cellLoc='center', loc='center')
    else:
        table = ax.table(cellText=df.values, colLabels=df.columns, cellLoc='center', loc='center')
    
    # Customize the font and table size
    table.auto_set_font_size(False)
    table.set_fontsize(10)
    table.scale(scale[0], scale[1])  # Apply the scaling factor
    
    # Set background color to white and add black borders for all table cells
    for i in range(len(df)):
        for j in range(len(df.columns)):
            table[i + 1, j].set_facecolor("white")  # Set cell background to white
            table[i + 1, j].set_edgecolor("black")  # Add black border to cells

    # Set background color to white and add black borders for headers
    for j in range(len(df.columns)):
        table[0, j].set_facecolor("white")
        table[0, j].set_edgecolor("black")
    
    # Add title to the plot
    plt.suptitle(title_plot)
    
    # Save the figure if a path is provided
    if path is not None:
        save_plot(fig, path, saving_name)

        
    