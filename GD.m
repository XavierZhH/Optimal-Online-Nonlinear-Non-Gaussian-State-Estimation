function [X_grid, W_k, X_k]  = GD(X_grid_last, Z_k, Q, R, k)

%prediction
X_pred_noise = State_updt(X_grid_last, k) + sqrt(Q) * randn(size(X_grid_last));
%predict z
Z_pred = Output_pred(X_pred_noise);

X_grid = X_pred_noise;


X_pred_mean = State_updt(X_grid_last, k);
%weight
W_x = normpdf((X_pred_noise - X_pred_mean), 0, sqrt(Q));
%probabilities of each 
P_z = normpdf((Z_k - Z_pred), 0, sqrt(R));

%weights
W_k = W_x .* P_z;
W_k = W_k ./ sum(W_k);

%estimate
X_k = sum(X_pred_noise .* W_k);

end



