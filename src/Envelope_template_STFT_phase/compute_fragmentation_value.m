function Fragmentation=compute_fragmentation_value(example_rov,th,fc)
% Fragmentation is defined as the number of peaks above a certain threshold
% applyed on the rectified signal

rectified_rov=abs(example_rov);
rectified_rov=rectified_rov(round(fc*0.15):round(0.65*fc));
T=th*mad(rectified_rov);

Fragmentation=length(findpeaks(rectified_rov,"MinPeakHeight",T));


