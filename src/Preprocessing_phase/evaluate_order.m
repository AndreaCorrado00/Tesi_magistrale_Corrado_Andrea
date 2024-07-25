function p_opt=evaluate_order(signal,min_order,max_order,step,eps)

p=min_order:step:max_order;
AIC_vec=nan(length(p),1);
p_opt=0;
for i=1:length(p)
    th=ar(table2array(signal)-table2array(mean(signal)),p(i),'ls');
    AIC_vec(i)=aic(th,'aic');
    
    if i ~=1 && abs(AIC_vec(i-1)-AIC_vec(i))<eps
        pos_opt=i;
    end
end
if p_opt==0
    pos_opt=find(AIC_vec==min(AIC_vec));
end
p_opt=p(pos_opt);


end
