function map_name = get_name_of_map(i)
% get_name_of_map returns the name of the map based on the input character.
%
% Input:
%   - i: Character representing the map type ('A', 'B', or any other character).
%
% Output:
%   - map_name: String containing the name of the map ('Indif', 'Eff', 'Danger').
%

% Check if the input character is 'A'
if i == "A"
    % If 'A', set map_name to 'Indif'
    map_name = "Indif";
% Check if the input character is 'B'
elseif i == "B"
    % If 'B', set map_name to 'Eff'
    map_name = "Eff";
% If the input character is neither 'A' nor 'B'
else
    % Set map_name to 'Danger'
    map_name = "Danger";
end
end
