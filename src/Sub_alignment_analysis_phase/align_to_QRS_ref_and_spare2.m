function new_signal=align_to_QRS_ref_and_spare2(signal,QRS_ref,QRS_spare2,half_width,reference,tollerance,plot_flag)

%% Finding maximum pipeline
% Defining the neighborhood and a vector of indices to be sure that the maximum is the local one and not repeated into the
% signal (hard but possible). Length of the signal is checked
[neighborhood,neighbor_idx]=evaluate_neighbors_from_Ref_spare2(signal,QRS_ref,QRS_spare2,half_width,tollerance);

% postion of the maximum value to be aligned with the QRS
max_pos_into_neighbor=find(neighborhood==max(neighborhood));

% checking if the maximum is not repeated
if length(max_pos_into_neighbor)>1
    max_pos_into_neighbor=max_pos_into_neighbor(1); % just taking the first point
end

max_pos_into_signal=neighbor_idx(max_pos_into_neighbor);

% Distance between QRS and max
distance=QRS_ref-max_pos_into_signal;

%% Rebuilding signal
%len_original=length(signal); % probably not useful
if plot_flag
    figure(1)
    subplot(211)
    x = [0:1/2035:1-1/2035]';
    plot(x,signal,'b-')
    hold on
    plot(max_pos_into_signal/2035,max(neighborhood),'ro')
    plot(neighbor_idx/2035,neighborhood,'k--')
    hold off
    title('before align')
    subplot(212)
    plot(x,reference,'b-')
    hold on
    plot(QRS_ref/2035,reference(QRS_ref),'ro')
    hold off
    pause(0.2)

end

if distance>0
    % maximum is before the QRS --> NaN padding on top, removing signal
    % points from bottom
    new_signal=[nan(distance,1);signal(1:end-distance)];

elseif distance <0
    % maximum is after the QRS --> NaN padding on bottom, removing signal
    % points from top
    new_signal=[signal(abs(distance)+1:end);nan(abs(distance),1)];
else
    new_signal=signal;
end

if plot_flag
    figure(1)
    subplot(211)
    x = [0:1/2035:1-1/2035]';
    plot(x,new_signal,'b-')
    hold on
    plot(max_pos_into_signal/2035,max(neighborhood),'ro')

    hold off
    title('after align')
    subplot(212)
    plot(x,reference,'b-')
    hold on
    plot(QRS_ref/2035,reference(QRS_ref),'ro')
    hold off
    pause(0.2)
end

end