function [X_k, P] = EKF(X_k_last, P_last, Z_k, Q, R, k)


%Stage 1: prediction 
X_k_pred = State_updt(X_k_last, k);
F_k_last = State_der(X_k_last, k);
P_pred = F_k_last * P_last * F_k_last' + Q;



%Stage 2: correction
H_k = Output_der(X_k_pred);
Z_k_pred = Output_pred(X_k_pred);
K_k=P_pred * H_k' * inv(H_k * P_pred * H_k' + R);
P = (1 - K_k * H_k) * P_pred * (1 - K_k * H_k)' + K_k * R * K_k';
X_k = X_k_pred + K_k * (Z_k - Z_k_pred);

end
