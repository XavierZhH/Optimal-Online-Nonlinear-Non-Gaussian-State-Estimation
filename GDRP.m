function [X_grid, W_k, X_k]  = GDRP(X_grid_last, Z_k, Q, R, k)

%Stage 1: prediction
X_pred_noise = State_updt(X_grid_last, k) + sqrt(Q) * randn(size(X_grid_last));
X_pred_mean = State_updt(X_grid_last, k);
X_grid = X_pred_noise;


W_x = normpdf((X_pred_noise - X_pred_mean), 0, sqrt(Q));

%resample
%Reference: https://stackoverflow.com/questions/27092478/matlab-weighted-resampling
idx = randsample(1: length(X_grid_last), length(X_grid_last), true, W_x);
X_pred_noise = X_pred_noise(idx);

%predict z
Z_pred = Output_pred(X_pred_noise);

%probabilities of each
W_z = normpdf((Z_k - Z_pred), 0, sqrt(R));

%weights
W_k = W_x .* W_z;
W_k = W_k ./ sum(W_k);

%estimate
X_k = sum(X_pred_noise .* W_k);

end



