function trace_align=decide_strategy(traces_origin)

% Looking at the nature of reference
ref_origin=strsplit(string(traces_origin{2,2}));
ref_origin=ref_origin(1);

if upper(ref_origin) ~= "CS"
% In this case, reference has inside ECG
    trace_align="ref_trace";
else
    spares_origins=strings(3,1);
    for i=3:5
        spare_name=strsplit(string(traces_origin{i,2}));
        spare_name=spare_name(1);
        spares_origins(i-2)=spare_name;
    end

    pos=find(spares_origins=="ECG",1);
    trace_align="spare"+num2str(pos)+"_trace";

end
