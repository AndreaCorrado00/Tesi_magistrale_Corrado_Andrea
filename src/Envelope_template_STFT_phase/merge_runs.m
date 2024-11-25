function [map_upper, map_lower] = merge_runs(map_upper, map_lower)

signal_start = round(0.17 * 2035); % Signal start point
signal_end = round(0.6 * 2035);    % Signal end point
% Ensure map_upper and map_lower have the same length
if length(map_upper) ~= length(map_lower)
    error('map_upper and map_lower must have the same length.');
end


% Identify runs of 1s in the logical vectors
upper_regions = regionprops(map_upper, 'PixelIdxList');
lower_regions = regionprops(map_lower, 'PixelIdxList');


% Handling possibility of peaks not fully detected
i = 1;
while i < numel(upper_regions)

    % End of the current run and start of the next run in map_upper
    end_current = upper_regions(i).PixelIdxList(end);
    start_next = upper_regions(i+1).PixelIdxList(1);

    % Check if there is no overlap with map_lower
    if all(~map_lower(end_current:start_next)) % no 1s in map_lower
        % assume that there is a descend in the middle between two
        % consecutive run upper (maybe not detected by the threshold)
        half_width=end_current+round((start_next-end_current)/2);

        map_lower(upper_regions(i).PixelIdxList(end)+1:half_width) = 1;
        % Remove the second run from the list
        % upper_regions(i+1) = [];
    else
        i = i + 1;
    end
end

% Merge consecutive runs of map_lower that are not followed by runs in map_upper
i = 2;
while i < numel(lower_regions)
    % End of the current run and start of the next run in map_lower
    end_current = lower_regions(i-1).PixelIdxList(end);
    start_next = lower_regions(i).PixelIdxList(1);
    % Check if there is no overlap with map_upper
    if all(~map_upper(end_current:start_next)) % no 1s in map_upper
        % assume that there is a descend in the middle between two
        % consecutive run upper (maybe not detected by the threshold)
        half_width=end_current+round((start_next-end_current)/2);
        map_upper(half_width:lower_regions(i).PixelIdxList(1)-1) = 1;
        % Remove the second run from the list
        % lower_regions(i+1) = [];
    else
        i = i + 1;
    end
end

% Identify runs of 1s in the logical vectors
upper_regions = regionprops(map_upper, 'PixelIdxList');
lower_regions = regionprops(map_lower, 'PixelIdxList');

% Add a positive run at the start if needed
if numel(lower_regions)>1 && lower_regions(1).PixelIdxList(1) < upper_regions(1).PixelIdxList(end) && lower_regions(1).PixelIdxList(1)>signal_start
    % Add a positive run before the first negative run
    map_upper(signal_start+round((lower_regions(1).PixelIdxList(1)-signal_start)/2):lower_regions(1).PixelIdxList(1) - 1) = 1;
end

% Add a negative run at the end if needed
if numel(upper_regions)>1 && upper_regions(end).PixelIdxList(end) > lower_regions(end).PixelIdxList(end) && upper_regions(end).PixelIdxList(end)<signal_end
    % Add a negative run after the last positive run
    map_lower(upper_regions(end).PixelIdxList(end) + 1:upper_regions(end).PixelIdxList(end)+round((signal_end-upper_regions(end).PixelIdxList(end)+1)/2)) = 1;
end

% Ensure the combined map starts with a run in map_upper
first_upper = find(map_upper, 1, 'first');
first_lower = find(map_lower, 1, 'first');

if isempty(first_upper) || (~isempty(first_lower) && first_lower < first_upper)
    % If map_lower starts before map_upper, set map_lower to 0 before the first map_upper
    map_lower(1:first_upper-1) = 0;
end

% Ensure the combined map ends with a run in map_lower
last_lower = find(map_lower, 1, 'last');
last_upper = find(map_upper, 1, 'last');

if isempty(last_lower) || (~isempty(last_upper) && last_upper > last_lower)
    % If map_upper ends after map_lower, set map_upper to 0 after the last map_lower
    map_upper(last_lower+1:end) = 0;
end
end