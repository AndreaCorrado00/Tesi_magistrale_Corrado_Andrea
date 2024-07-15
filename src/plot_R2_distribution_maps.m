function plot_R2_distribution_maps(table_corr, trace, figure_path, make_ttest)
% plot_R2_distribution_maps plots the distribution of R^2 values within maps and performs t-tests if required.
%
% Inputs:
%   - table_corr: Structure containing correlation tables.
%   - trace: String specifying the trace type (e.g., 'trace1', 'trace2').
%   - figure_path: String specifying the path to save the figures.
%   - make_ttest: Boolean indicating whether to perform t-tests on the R^2 values.
%

% Initialize an empty array to store R^2 values
R2_vectors = []; % corr(A,B), corr(B,C), corr(A,C)

% Iterate over the number of correlation tables in table_corr
for i = 1:length(fieldnames(table_corr))
    sub = "sub_" + num2str(i);
    tab = table_corr.(sub);
    R2_vectors(i, 1) = table2array(tab(1, 2));
    R2_vectors(i, 2) = table2array(tab(2, 3));
    R2_vectors(i, 3) = table2array(tab(1, 3));
end

% Define map comparisons
maps_vs = ["A-B", "B-C", "A-C"];

% Plot the R^2 distribution for each comparison
for i = 1:3
    % Create a new figure and maximize the window
    fig = figure(1);
    fig.WindowState = "maximized";
    hold on

    subplot(1, 3, i)
    boxplot(R2_vectors(:, i))
    ylim([-1, 1])
    title("R^2 for " + string(trace) + ", maps:" + maps_vs(i))
end

% Get the current figure handle
fig = gcf;
file_name = "R2 distribution for " + string(trace) + " within maps";
% Save the plot
save_plot(file_name, " boxplot", figure_path + "\boxplots", fig, true);

% Perform t-tests if make_ttest is true
if make_ttest
    tab_hp = [];
    tab_p = [];
    for i = 1:3
        for j = 1:3
            [h, p] = ttest(R2_vectors(:, i), R2_vectors(:, j));
            tab_hp(i, j) = h;
            tab_p(i, j) = p;
        end
    end

    % Convert tab_p to table format and set variable and row names
    tab_p = array2table(tab_p);
    tab_p.Properties.VariableNames = {char("A-B"), char("B-C"), char("A-C")};
    tab_p.Properties.RowNames = {char("A-B"), char("B-C"), char("A-C")};

    % Convert tab_hp to table format and set variable and row names
    tab_hp = array2table(tab_hp);
    tab_hp.Properties.VariableNames = {char("A-B"), char("B-C"), char("A-C")};
    tab_hp.Properties.RowNames = {char("A-B"), char("B-C"), char("A-C")};

    % Display t-test results
    disp("Results of T-Test for " + string(trace))
    disp('HP table')
    disp(tab_hp)
    disp('----------------')
    disp('p-values table')
    disp(tab_p)
    disp('----------------')
end
end





