function trace_align = decide_strategy(traces_origin)
% This function decides which trace alignment strategy to use based on 
% the nature of the reference signal. The input `traces_origin` is a cell 
% array containing information about the origin of the ECG traces. 
% Depending on the reference type, it returns the corresponding trace alignment name.
%
% Parameters:
%   traces_origin (cell array): A 5x2 cell array containing information about 
%                                the origin of the ECG signals. The second column 
%                                contains the origin reference as a string.
%
% Returns:
%   trace_align (string): The name of the trace alignment strategy to be used. 
%                         This can either be "ref_trace" or one of the spare trace names 
%                         like "spare1_trace", "spare2_trace", etc.

% Extract the reference origin from the second column of the second row
ref_origin = strsplit(string(traces_origin{2,2}));
ref_origin = ref_origin(1);

% Check if the reference origin is not "CS"
if upper(ref_origin) ~= "CS"
    % If the reference contains "ECG", align with the "ref_trace"
    trace_align = "ref_trace";
else
    % Otherwise, gather the spare origins from rows 3 to 5
    spares_origins = strings(3, 1);
    for i = 3:5
        spare_name = strsplit(string(traces_origin{i,2}));
        spare_name = spare_name(1);
        spares_origins(i - 2) = spare_name;
    end

    % Find the index of the spare trace that matches "ECG"
    pos = find(spares_origins == "ECG", 1);

    % Return the corresponding spare trace alignment name
    trace_align = "spare" + num2str(pos) + "_trace";
end
