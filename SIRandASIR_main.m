clear all
clc

%noise variance
Q = 10;
R = 1;

%N particles
N = 100;

%initial state
X_k_initial = randn;
X_k_noise(1) = X_k_initial;

X_seq(1, :) = X_k_initial * ones(1, N) + randn(1, N);
X_seq2(1, :) = X_k_initial * ones(1, N) + randn(1, N);
W2(1, :) = ones(1, N) / N;


%initial measurement
Z_k(1) = randn;


%100 times
k = 101;

%100 simulations in Monte Carlo
for j = 1: 100
    for i = 2: k
        %true state
        X_k_true(i) = State_updt(X_k_noise(i - 1), i);
        %plus noise
        X_k_noise(i) = X_k_true(i) + sqrt(Q) * randn;
        %measurement
        Z_k(i) = Output_pred(X_k_noise(i)) + sqrt(R) * randn;
        %SIRPF
        [X_seq(i, :), W(i, :), X_k(i)] = SIR(X_seq(i - 1, :), Z_k(i), Q, R, i);
        %ASIR PF
        [X_seq2(i, :), W2(i, :), X_k2(i)] = ASIR(X_seq2(i - 1, :), W2(i-1, :), Z_k(i), Q, R, i);

    end
    RMSE_SIR(j) = sqrt(mean((X_k - X_k_true) .^ 2));
    RMSE_ASIR(j) = sqrt(mean((X_k2 - X_k_true) .^ 2));
end

RMSE_SIR_mean = mean(RMSE_SIR);
RMSE_ASIR_mean = mean(RMSE_ASIR);


figure('Name', 'ASIR PF')
plot(X_k_true, 'b', 'linewidth',3)
hold on
plot(X_k, '-.r', 'linewidth',3)
legend('True values', 'Estimated values')
xlabel('Time k')
ylabel('Values of states')
hold off
    
cf = figure('Name', 'ASIR PF')
plot(X_k_true, 'b', 'linewidth',3)
hold on
plot(X_k2, '-.r', 'linewidth',3)
legend('True values', 'Estimated values')
xlabel('Time k')
ylabel('Values of states')
txt1 = ['RMSE: ',num2str(RMSE_ASIR_mean)];
text(80,-18,txt1,'FontSize',18)
hold off


%saveas(cf, 'cf.png')
    
    