function p_opt = evaluate_order(signal, min_order, max_order, step, eps)
    % evaluate_order determines the optimal order of an autoregressive (AR) model
    % for a given signal based on the Akaike Information Criterion (AIC).
    % Inputs:
    %   signal: Input signal (as a table) for which the AR model order is evaluated.
    %   min_order: Minimum order to consider for the AR model.
    %   max_order: Maximum order to consider for the AR model.
    %   step: Step size for the range of orders to evaluate.
    %   eps: Convergence threshold for AIC difference.
    % Output:
    %   p_opt: Optimal AR model order.
    
    % Generate a vector of model orders to evaluate
    p = min_order:step:max_order;
    
    % Initialize AIC vector to store AIC values for each order
    AIC_vec = nan(length(p), 1);
    AIC_diff=[];
    % Initialize optimal order position
    p_opt = 0;

    
    % Loop through each order to evaluate the AR model
    for i = 1:length(p)
        % Fit AR model with current order
        th = ar(signal - mean(signal), p(i), 'ls');
        
        % Calculate AIC for the current model
        AIC_vec(i) = aic(th, 'aic');
        if i>1
            AIC_diff(i)=abs(AIC_vec(i - 1) - AIC_vec(i));
        end

        


        % % Check for convergence in AIC values
        % if i ~= 1 && abs(AIC_vec(i - 1) - AIC_vec(i)) < eps
        %     AIC_diff(i)=abs(AIC_vec(i - 1) - AIC_vec(i));
        %     pos_opt = i;
        % end
    end
    pos_opt=find(AIC_diff(2:end)<eps,1);
    
    % If no convergence was found, choose the order with the minimum AIC
    if isempty(pos_opt)
        pos_opt = find(AIC_vec == min(AIC_vec));
    end
    
    % Set the optimal order
    p_opt = p(pos_opt);
end
