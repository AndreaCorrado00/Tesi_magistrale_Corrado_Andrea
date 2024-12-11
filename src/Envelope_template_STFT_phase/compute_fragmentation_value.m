function Fragmentation=compute_fragmentation_value(example_rov,th,fc)
% Fragmentation is defined as the number of peaks above a certain threshold
% applyed on the rectified signal

rectfied_rov=abs(example_rov);
rectfied_rov=rectfied_rov(round(fc*0.15):round(0.65*fc));
T=th*mad(rectfied_rov);

Fragmentation=length(findpeaks(rectified_rov,"Threshold",T));


