function MI = mutual_information(X, Y)
    % Compute the Mutual Information between two signals X and Y
    % X, Y: input signals (1D arrays)
    
    % Normalize the signals
    X = (X - mean(X)) / std(X);
    Y = (Y - mean(Y)) / std(Y);
    
    % Compute the joint histogram
    joint_hist = hist3([X, Y], 'Nbins', [20, 20]);
    
    % Normalize the histogram to get the joint probability distribution
    joint_prob = joint_hist / sum(joint_hist(:));
    
    % Marginal probability distributions
    prob_X = sum(joint_prob, 2);
    prob_Y = sum(joint_prob, 1);
    
    % Calculate MI using the formula
    MI = sum(joint_prob(:) .* log(joint_prob(:) ./ (prob_X .* prob_Y')));
end