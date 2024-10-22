def save_plot(fig, figure_path, file_name="plot"):
    import matplotlib.pyplot as plt
    import os
    name_file_complete = f"{file_name}.png"
    full_path = os.path.join(figure_path, name_file_complete)
    
    fig.savefig(full_path)
    