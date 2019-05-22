
function [X_seq, W, X_k] = SIR(X_seq_last, Z_k, Q, R, k)

%predict
X_pred_noise = State_updt(X_seq_last, k) + sqrt(Q) * randn(size(X_seq_last));

%predict z
Z_pred = Output_pred(X_pred_noise);

%update weight
W_z = normpdf((Z_k - Z_pred), 0, sqrt(R));
W = W_z ./ sum(W_z);

%resample
%Reference: https://stackoverflow.com/questions/27092478/matlab-weighted-resampling
idx = randsample(1:length(X_seq_last), length(X_seq_last), true, W);
X_seq=X_pred_noise(: , idx); 

X_k = mean(X_seq);

end



