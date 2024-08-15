function [neighborhood,neighbor_idx]=evaluate_neighbors_from_Ref_spare2(signal,QRS_ref,QRS_spare2,half_width,tollerance)

% the value of 400 correspond to 0.2s of acquisition
if abs(QRS_ref-QRS_spare2)<tollerance % defining the neighborhood arounde the QRS of the references trace
    if QRS_ref+half_width>length(signal) %[-half_width ... QRS ... end]
        neighborhood=signal(QRS_ref-half_width:end);
        neighbor_idx=QRS_ref-half_width:length(signal);

    elseif QRS_ref-half_width<0 % [1 ... QRS ... +half_width]
        neighborhood=signal(1:QRS_ref+half_width);
        neighbor_idx=1:QRS_ref+half_width;

    else
        neighborhood=signal(QRS_ref-half_width:QRS_ref+half_width); %[-half_width ... QRS ... half_width]
        neighbor_idx=QRS_ref-half_width:QRS_ref+half_width;
    end
else % defining the neighborhood arounde the QRS of the spare 2 trace
    if QRS_spare2+half_width>length(signal) %[-half_width ... QRS ... end]
        neighborhood=signal(QRS_spare2-half_width:end);
        neighbor_idx=QRS_spare2-half_width:length(signal);

    elseif QRS_spare2-half_width<0 % [1 ... QRS ... +half_width]
        neighborhood=signal(1:QRS_spare2+half_width);
        neighbor_idx=1:QRS_spare2+half_width;

    else
        neighborhood=signal(QRS_spare2-half_width:QRS_spare2+half_width); %[-half_width ... QRS ... half_width]
        neighbor_idx=QRS_spare2-half_width:QRS_spare2+half_width;
    end
end

end
