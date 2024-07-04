function save_plot(i,j,k,type_of_plot,figure_path,fig)
file_name='MAP_'+i+'_sub_'+num2str(j)+'_trace_'+k+'_'+type_of_plot+'.png';
full_file_path = fullfile(figure_path, file_name);
saveas(fig, full_file_path);
close(fig);

end
