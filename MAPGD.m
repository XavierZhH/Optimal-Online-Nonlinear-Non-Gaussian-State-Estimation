function [X_grid, W_k, X_k]  = MAPGD(X_grid_last, Z_k, Q, R, k)

%Stage 1: prediction
X_pred_noise = State_updt(X_grid_last, k) + sqrt(Q) * randn(size(X_grid_last));
%predict z
Z_pred = Output_pred(X_pred_noise);
X_grid = X_pred_noise;


X_pred_mean = State_updt(X_grid_last, k);
%weights
W_x = normpdf((X_pred_noise - X_pred_mean), 0, sqrt(Q));


%probabilities of each z
P_z = normpdf((Z_k - Z_pred), 0, sqrt(R));

%weights
W_k = W_x .* P_z;
W_k = W_k ./ sum(W_k);

%maximum one is estimate
[~, idx] = max(W_k);
X_k = X_pred_noise(idx);

end



