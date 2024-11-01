import sys
import matplotlib.pyplot as plt
sys.path.append("D:/Desktop/ANDREA/Universita/Magistrale/Anno Accademico 2023-2024/TESI/Tesi_magistrale/src/Classification_phase")
from save_plot import save_plot
import pandas as pd

def plot_dataframe_as_plain_image(df, figsize=(8, 4), path=None, saving_name=None, scale=(1,1),use_rowLabels=None,title_plot=None):
    
    # Format float values to two decimal places
    df = df.map(lambda x: f"{x:.2f}" if isinstance(x, float) else x)
    
    # Handling possibly strange rows, like accuracy in he_report
    if 'accuracy' in df.index:
        empty_row = pd.DataFrame([[""] * df.shape[1]], columns=df.columns)
        empty_row.index=[""]
        df = pd.concat([df.iloc[:3], empty_row, df.iloc[3:]])
        df.loc["accuracy",["precision","recall","support"]]=""
    
    fig, ax = plt.subplots(figsize=figsize)
    ax.axis('off')  # Hides the axis
    
    # Create the table with customizable scaling parameters
    if use_rowLabels:
        table = ax.table(cellText=df.values, colLabels=df.columns,rowLabels=df.index, cellLoc='center', loc='center')
    else:
        table = ax.table(cellText=df.values, colLabels=df.columns, cellLoc='center', loc='center')
    
    # Configure font and table size
    table.auto_set_font_size(False)
    table.set_fontsize(10)
    table.scale(scale[0], scale[1])  # Uses specified scaling parameters

     # Removes background colors and sets borders for all cells
    for i in range(len(df)):
        for j in range(len(df.columns)):
            table[i + 1, j].set_facecolor("white")  # Rows (i + 1) leave space for the header
            table[i + 1, j].set_edgecolor("black")  # Thin black border

    # Removes background colors and sets borders for headers
    for j in range(len(df.columns)):
        table[0, j].set_facecolor("white")
        table[0, j].set_edgecolor("black")
        
    plt.suptitle(title_plot)
    # Save the image with the specified path and name
    if path is not(None):
        save_plot(fig, path, saving_name)
        
    