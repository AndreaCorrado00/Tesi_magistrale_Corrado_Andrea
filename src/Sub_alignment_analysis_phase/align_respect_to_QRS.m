function new_signal=align_respect_to_QRS(signal,QRS_pos,half_width)

%% Finding maximum pipeline
% Defining the neighborhood and a vector of indices to be sure that the maximum is the local one and not repeated into the
% signal (hard but possible). Length of the signal is checked
if QRS_pos+half_width>length(signal)
    neighborhood=signal(QRS_pos-half_width:end);
    neighbor_idx=QRS_pos-half_width:length(signal);

elseif QRS_pos-half_width<0
    neighborhood=signal(1:QRS_pos+half_width);
    neighbor_idx=1:QRS_pos+half_width;

else
    neighborhood=signal(QRS_pos-half_width:QRS_pos+half_width);
    neighbor_idx=QRS_pos-half_width:QRS_pos+half_width;
end



% postion of the maximum value to be aligned with the QRS
max_pos_into_neighbor=find(neighborhood==max(neighborhood));

% checking if the maximum is not repeated
if length(max_pos_into_neighbor)>1
    max_pos_into_neighbor=max_pos_into_neighbor(1); % just taking the first point
end

max_pos_into_signal=neighbor_idx(max_pos_into_neighbor);

% Distance between QRS and max
distance=QRS_pos-max_pos_into_signal;

%% Rebuilding signal
%len_original=length(signal); % probably not useful

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



end
