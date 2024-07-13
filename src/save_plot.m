function save_plot(file_name,type_of_plot,figure_path,fig,close_fig)
file_name=file_name+type_of_plot+'.png';
full_file_path = fullfile(figure_path, file_name);
saveas(fig, full_file_path);
if close_fig
    close(fig);
end


end
