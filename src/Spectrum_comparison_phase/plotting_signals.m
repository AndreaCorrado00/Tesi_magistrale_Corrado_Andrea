function plotting_signals(data,figure_path,plot_type,saving,check_noise)

% plot type handling
plot_types=["time_mean_spaghetti","time_mean_conf","time_mean_sd","freq_mean_spaghetti","freq_mean_conf","freq_mean_sd"];
titles=["Spaghetti plot ","Mean and confidence intervals 95% ","Mean and +/- sd ",
        "Spectrum spaghetti plot ","Spectrum mean and confidence intervals 95% ","Spectrum mean and +/- sd "];
ind_plot=find(plot_type==plot_types);

table_pox = [false, false,false;
                 false, true,false;
                 false, false, true;
                 true, false, false;
                 true, true, false;
                 true, false, true];

%% Building the plot, sub by sub
subjects=fieldnames(data);
for i=1:length(subjects)
    % to build the plot
    records=data.(subjects{i}).records_table;
    fc=data.(subjects{i}).fc;
    
    % Create a new figure
    fig = figure(1);
    fig.WindowState = "maximized";

    title_plot=titles(ind_plot)+"for Sub: "+num2str(i);
    % Plot the signals
    build_plot(records, title_plot, fc, table_pox(ind_plot, 1), table_pox(ind_plot, 2), table_pox(ind_plot,3));
    if check_noise
        xlim([40,fc/2])
        title(title_plot+",noise check")
        plot_type=plot_types(ind_plot)+"_noise_check";
    end


    % Get the current figure
    fig = gcf;

    % Save the plot
    if saving
        file_name=plot_types(ind_plot)+"Sub_"+num2str(i)+"MIT_dataset_eval";
        save_plot(file_name, plot_type, figure_path + "\data_visual", fig, true);
    end

end


end
