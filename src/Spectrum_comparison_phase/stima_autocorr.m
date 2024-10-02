function R=stima_autocorr(Y,tau_max)
%Y è la realizzazione della quale vogliamo fare stima dell'autocorrelazione
NC=length(Y);
R=nan(tau_max,1);

for tau=0:tau_max %Non andremo più a stimare Ry per ogni tau, pena il peggioramento della stima
    prod=nan(NC-tau,1);
    for k=1:NC-tau %tau devi interpretarlo come una sorta di passo di campionamento
        yk=Y(k);
        yktau=Y(k+tau);
        prod(k)=yk*yktau;
    end
    R(tau+1)=1/(NC-tau)*sum(prod);
end
end
