function [X_seq, W, X_k] = ASIR(X_seq_last, W_last, Z_k, Q, R, k)


for i = 1: length(X_seq_last)
    mu(i)=State_updt(X_seq_last(i), k);
    Z_k_nonoise=Output_pred(mu(i));
    W_k(i) = W_last(i)*normpdf((Z_k_nonoise-Z_k),0,sqrt(R));
end

W_k = W_k./sum(W_k);

%Resampling
%Reference: https://stackoverflow.com/questions/27092478/matlab-weighted-resampling
idx = randsample(1: length(X_seq_last), length(X_seq_last), true, W_k);

for j = 1:length(X_seq_last)
    X_k_pred(j)=State_updt(X_seq_last(idx(j)),k)+sqrt(Q)*randn;
    Z_pred=Output_pred(X_k_pred(j));
    Z_mu = Output_pred(mu(idx(j)));
    W_x = normpdf((Z_k-Z_pred),0,sqrt(R));
    W_mu = normpdf((Z_k-Z_mu),0,sqrt(R));
    W(j) = W_x ./ W_mu;      
end

%normalise
W = W./sum(W);

X_seq=X_k_pred - sqrt(Q)*randn;

%update the state estimate
X_k=mean(X_seq);

end