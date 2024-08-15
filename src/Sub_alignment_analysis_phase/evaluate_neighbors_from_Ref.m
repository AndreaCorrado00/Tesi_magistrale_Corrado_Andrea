function [neighborhood,neighbor_idx]=evaluate_neighbors_from_Ref(signal,QRS_pos,half_width)

if QRS_pos+half_width>length(signal) %[-half_width ... QRS ... end]
    neighborhood=signal(QRS_pos-half_width:end); 
    neighbor_idx=QRS_pos-half_width:length(signal);

elseif QRS_pos-half_width<0 % [1 ... QRS ... +half_width]
    neighborhood=signal(1:QRS_pos+half_width);
    neighbor_idx=1:QRS_pos+half_width;

else
    neighborhood=signal(QRS_pos-half_width:QRS_pos+half_width); %[-half_width ... QRS ... half_width]
    neighbor_idx=QRS_pos-half_width:QRS_pos+half_width;
end
