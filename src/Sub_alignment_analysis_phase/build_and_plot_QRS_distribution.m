function QRS_vec = build_and_plot_QRS_distribution(data)
    % Function to build and plot the distribution of QRS positions across all subjects and maps.
    %
    % INPUTS:
    %   data - Structured data containing QRS position information
    %
    % OUTPUT:
    %   QRS_vec - Vector of QRS positions for plotting

    maps = ["MAP_A", "MAP_B", "MAP_C"];
    n_sub = 12;
    QRS_vec = [];
    
    for i = 1:3
        for j = 1:n_sub
            sub = maps(i) + num2str(j);
            QRS_vec = [QRS_vec; cell2mat(data.(maps(i)).(sub).QRS_position_ref_trace)'];
        end
    end

    % Plot the QRS position distribution
    figure(1)
    boxplot(QRS_vec)
    title('QRS location distribution')
    xlabel('QRS positions')
end
