function p_opt = evaluate_order(signal, min_order, max_order, step, eps,type)
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
        th = ar(signal - mean(signal), p(i), type);

        % Calculate AIC for the current model
        AIC_vec(i) = aic(th, 'nAIC');
        if i>1
            AIC_diff(i)=abs(AIC_vec(i - 1) - AIC_vec(i));
            if AIC_diff(i)<eps
                break
            end
        end
    end
    pos_opt=find(AIC_diff(2:end)<eps,1);

    % If no convergence was found, choose the order with the minimum AIC
    if isempty(pos_opt)
        disp('No convergence')
        pos_opt = find(AIC_vec == min(AIC_vec));
    end

    % Set the optimal order
    p_opt = p(pos_opt);

    % %% An other strategy: PSD_ar similar to PSD_welch
    % 
    % % Select the order which ensures the highest correlation with the
    % % welch spectrum. 
    % corr_vec=zeros(length(p)+2,1);
    % 
    % %% Welch spectrum estimation
    % window = hamming(512); % Hamming window
    % noverlap = length(window)/2; % overlapping
    % nfft = 2048; % Points of fft
    % 
    % % Welch periodogram: will act as reference
    % [pxx, ~] = pwelch(signal-mean(signal), window, noverlap, nfft, Fs);
    % 
    % % Loop through each order to evaluate the AR model
    % N=length(signal);
    % for i = 3:length(corr_vec)
    %     % Fit AR model with current order
    %     th = ar(signal - mean(signal), p(i-2), 'yw');
    %     [H,~]=freqz(1,th.a,N,Fs);
    %     DSP=th.NoiseVariance*(abs(H).^2);
    % 
    %     % Down sampling
    %     DSP = resample(DSP, length(pxx), length(DSP));
    % 
    %     % Normalisation
    %     U = sum(window.^2);
    %     pxx=pxx.*U;
    % 
    %     corr_vec(i)=corr(pxx,DSP);
    % 
    % 
    %     if i>3 && i<length(corr_vec) && corr_vec(i-2)<corr_vec(i-1) && corr_vec(i-1)>corr_vec(i)
    %         break
    %     end
    % 
    % end
    % 
    % p_opt=p(find(corr_vec==max(corr_vec))-2);
end
