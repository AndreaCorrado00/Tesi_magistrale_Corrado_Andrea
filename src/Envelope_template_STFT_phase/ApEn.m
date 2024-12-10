function ApEnValue = ApEn(data, m, r)
    % Approximate Entropy calculation (vectorized)
    % data: time series (1D array)
    % m: embedding dimension
    % r: tolerance (scaled by std(data))
    
    N = length(data); % Length of the time series
    r = r * std(data); % Scale tolerance by the standard deviation of the series
    
    % Helper function to calculate phi
    function C = phi(m)
        % Create embedded vectors of length m
        X = zeros(N - m + 1, m);
        for i = 1:(N - m + 1)
            X(i, :) = data(i:i + m - 1);
        end
        
        % Compute maximum absolute distances (Chebyshev distance)
        % Each row of X is compared with all other rows
        distMatrix = abs(pdist2(X, X, 'chebychev')); % 'chebychev' => max(|xi - xj|)
        
        % Count occurrences where distance <= r
        similarityCounts = sum(distMatrix <= r, 2) / (N - m + 1);
        
        % Average logarithm
        C = mean(log(similarityCounts));
    end

    % Compute phi(m) and phi(m+1)
    phi_m = phi(m);
    phi_m1 = phi(m + 1);
    
    % Approximate Entropy
    ApEnValue = phi_m - phi_m1;
end
