function save_3D_plot(file_name, type_of_plot, figure_path, fig, close_fig)
% save_plot saves the given figure to the specified path with the specified file name and type.
%
% Inputs:
%   - file_name: String specifying the base name of the file.
%   - type_of_plot: String specifying the type of plot (e.g., 'boxplot', 'lineplot').
%   - figure_path: String specifying the directory path to save the figure.
%   - fig: Handle of the figure to be saved.
%   - close_fig: Boolean indicating whether to close the figure after saving.
%

% Append the plot type and file extension to the base file name
file_name = file_name + type_of_plot + '.fig';

% Construct the full file path
full_file_path = fullfile(figure_path, file_name);

% Save the figure to the specified file path
saveas(fig, full_file_path);

% Close the figure if close_fig is true
if close_fig
    close(fig);
end

end
