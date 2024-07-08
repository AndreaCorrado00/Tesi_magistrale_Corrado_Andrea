function ApEn_value = ApEn(u, m, r)
    % ApEn: Approximate Entropy
    % u: time series data
    % m: embedding dimension
    % r: tolerance (typically 0.2 * standard deviation of the data)
    
    N = length(u);
    
    % Function to calculate the C vector
    function C = calculate_C(u, m, r)
        N = length(u);
        C = zeros(1, N - m + 1);
        for i = 1:(N - m + 1)
            for j = 1:(N - m + 1)
                % Distance between vectors
                distance = max(abs(u(i:i+m-1) - u(j:j+m-1)));
                if distance <= r
                    C(i) = C(i) + 1;
                end
            end
            C(i) = C(i) / (N - m + 1);
        end
    end

    % Calculate the phi values
    C_m = calculate_C(u, m, r);
    C_m1 = calculate_C(u, m+1, r);

    % Phi function
    phi_m = sum(log(C_m)) / (N - m + 1);
    phi_m1 = sum(log(C_m1)) / (N - m);

    % Approximate Entropy
    ApEn_value = phi_m - phi_m1;
end
