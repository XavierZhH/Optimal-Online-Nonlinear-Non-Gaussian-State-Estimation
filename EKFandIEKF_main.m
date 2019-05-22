clear all
clc

%variances of noises
Q = 10;
R = 1;

%initial state
X_k_initial = randn;
X_k_noise(1) = X_k_initial;
X_k(1) = X_k_noise(1);
X_k2(1) = X_k_noise(1);
X_k_true(1) = X_k_noise(1);

%initial estimates error covariance.
P_initial = randn;
P(1) = P_initial;
P2(1) = P_initial;



%100 times
k = 101;

%500 simulations in Monte Carlo
for j = 1: 500
    for i = 2: k
        %true state
        X_k_true(i) = State_updt(X_k_noise(i - 1), i);
        %plus noise
        X_k_noise(i) = X_k_true(i) + sqrt(Q) * randn;
        %measurements
        Z_k(i) = Output_pred(X_k_noise(i)) + sqrt(R) * randn;
        %EKF
        [X_k(i), P(i)] = EKF(X_k(i - 1), P(i - 1), Z_k(i), Q, R, i);
        %IEKF
        [X_k2(i), P2(i)] = IEKF(X_k2(i - 1), P2(i - 1), Z_k(i), Q, R, i);
    end
    RMSE_EKF(j) = sqrt(mean((X_k - X_k_true) .^ 2));
    RMSE_IEKF(j) = sqrt(mean((X_k2 - X_k_true) .^ 2));
end

MSE_EKF_mean = mean(RMSE_EKF);
MSE2_IEKF_mean = mean(RMSE_IEKF);


b1 = figure('Name', 'Extended Kalman filter')
plot(X_k_true, 'b', 'linewidth',3)
hold on
plot(X_k, '-.r', 'linewidth',3)
legend('True values', 'Estimated values')
xlabel('Time k')
ylabel('Values of states')
hold off
    

c1 = figure('Name', 'IEKF')
plot(X_k_true, 'b', 'linewidth',3)
hold on
plot(X_k2, '-.r', 'linewidth',3)
legend('True values', 'Estimated values')
txt1 = ['RMSE: ',num2str(MSE2_IEKF_mean)];
text(80,-18,txt1,'FontSize',18)
xlabel('Time k')
ylabel('Values of states')
hold off
    
%saveas(c1, 'c1.png')  

