function show_alignment_results(data,fc)

% Show the fist record for each subject into each map
for i = ["A", "B", "C"]
    fig=figure;
    fig.WindowState = "maximized";
    sgtitle("Rov trace (record 1), MAP: "+i+" ("+get_name_of_map(i)+")")
    map = 'MAP_' + i;
    subjects = fieldnames(data.(map));

    % Loop through each subject
    for j = 1:length(subjects)
        sub = map + num2str(j);

        rov=data.(map).(sub).rov_trace{:,1};
        t = [0:1/fc:1-1/fc]';

        subplot(6,2,j)
        plot(t,rov,"LineWidth", 1)
        title("Subject: ",num2str(j))
        xlabel('Time [s]')
        ylabel('Amplitude [mV]')
        xlim([0,1])
        
    end
end

end
