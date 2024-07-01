function MAP_out=maps_refactoring(MAP)
% Finding signals into maps
signals=MAP{:,1};
rov_idx = find(strcmp(signals, 'rov trace:'));
if length(rov_idx)>1
    rov_idx=rov_idx(end,end);
end

ref_idx = find(strcmp(signals, 'ref trace:'));
if length(ref_idx)>1
    ref_idx=ref_idx(end,end);
end

spare1_idx = find(strcmp(signals, 'spare1 trace:'));
if length(spare1_idx)>1
    spare1_idx=spare_idx(end,end);
end

spare2_idx = find(strcmp(signals, 'spare2 trace:'));
if length(spare2_idx)>1
    spare2_idx=spare2_idx(end,end);
end

spare3_idx = find(strcmp(signals, 'spare3 trace:'));
if length(spare3_idx)>1
    spare3_idx=spare3_idx(end,end);
end

end_idx=find(strcmp(signals, 'FFT spectrum is available for FFT maps only'));

% Extraction of data tables
MAP_out.rov_trace=MAP(rov_idx+1:ref_idx-1,2:end);
MAP_out.ref_trace=MAP(ref_idx+1:spare1_idx-1,2:end);
MAP_out.spare1_trace=MAP(spare1_idx+1:spare2_idx-1,2:end);
MAP_out.spare2_trace=MAP(spare2_idx+1:spare3_idx-1,2:end);
MAP_out.spare3_trace=MAP(spare3_idx+1:end_idx-1,2:end);

end
