function X_k_new = State_updt(X_k_last, k)

X_k_new = X_k_last / 2 + (25 * X_k_last) ./ (1+X_k_last .^ 2) + 8 * cos(1.2 * k);

end
