function [X_k, P] = IEKF(X_k_last, P_last, Z_k, Q, R, k)

%Stage 1: prediction 
X_k_pred = State_updt(X_k_last, k);
F_k_last = State_der(X_k_last, k);
P_pred = F_k_last * P_last * F_k_last' + Q;

X_k_update = X_k_pred;
%make sure the firt time can run 'while'
X_k_update_last = X_k_update + 1000;
P_pred_update = P_pred;


%Stage 2: correction
%change is small
while abs(X_k_update - X_k_update_last) > 8
	X_k_update_last = X_k_update;
    H_k = Output_der(X_k_update);
    Z_k_pred = Output_pred(X_k_update);
    K_k=P_pred * H_k' * inv(H_k * P_pred * H_k' + R);
    P_pred_update = (1 - K_k * H_k) * P_pred * (1 - K_k * H_k)' + K_k * R * K_k';
    X_k_update = X_k_pred + K_k * (Z_k - Z_k_pred - H_k * (X_k_pred - X_k_update));

end


X_k = X_k_update;
P = P_pred_update;

end
