clear all
clc

%variances of noises
Q = 10;
R = 1;
state_num = 200;

%initial
X_k_initial = randn;
X_k_noise(1) = X_k_initial;

%grid
X_grid(1, :) = linspace(-10, 10, state_num);
X_grid2(1, :) = linspace(-10, 10, state_num);
X_grid3(1, :) = linspace(-10, 10, state_num);
%initial weights
W_k(1, :) = normpdf(X_grid(1, :), X_k_initial, sqrt(Q));
W_k(1, :) = W_k(1, :) ./ sum(W_k(1, :));
W_k2(1, :) = normpdf(X_grid2(1, :), X_k_initial, sqrt(Q));
W_k2(1, :) = W_k2(1, :) ./ sum(W_k2(1, :));
W_k3(1, :) = normpdf(X_grid2(1, :), X_k_initial, sqrt(Q));
W_k3(1, :) = W_k3(1, :) ./ sum(W_k3(1, :));

%initial estimate error variance
P_initial = 1;
P(1) = P_initial;

%initial ,measurement
Z_initial = 0;
Z_k(1) = Z_initial;


%X_100
k = 101;

%500 simulations in Monte Carlo
for j = 1: 500
    for i = 2: k
        %true state
        X_k_true(i) = State_updt(X_k_noise(i - 1), i);
        %plus noise
        X_k_noise(i) = X_k_true(i) + sqrt(Q) * randn;
        %measurement
        Z_k(i) = Output_pred(X_k_noise(i)) + sqrt(R) * randn;
        %maximum grid
        [X_grid(i, :), W_k(i, :), X_k(i)]  = MAPGD(X_grid(i - 1, :), Z_k(i), Q, R, i);
        %weight average
        [X_grid2(i, :), W_k2(i, :), X_k2(i)]  = GD(X_grid2(i - 1, :), Z_k(i), Q, R, i);
         %weight average plus resample
        [X_grid3(i, :), W_k3(i, :), X_k3(i)]  = GDRP(X_grid3(i - 1, :), Z_k(i), Q, R, i);
    end
    RMSE_MAPGD(j) = sqrt(mean((X_k - X_k_true) .^ 2));
    RMSE_GD(j) = sqrt(mean((X_k3 - X_k_true) .^ 2));
    RMSE_GDRP(j) = sqrt(mean((X_k2 - X_k_true) .^ 2));
end

RMSE_GD_mean = mean(RMSE_GD);
RMSE_GDRP_mean = mean(RMSE_GDRP);
RMSE_MAPGD_mean = mean(RMSE_MAPGD);


bf = figure('Name', 'MAPGD')
plot(X_k_true, 'b', 'linewidth',3)
hold on
plot(X_k, '-.r', 'linewidth',3)
legend('True values', 'Estimated values')
hold off
    
    
b2 = figure('Name', 'GD')
plot(X_k_true, 'b', 'linewidth',3)
hold on
plot(X_k3, '-.r', 'linewidth',3)
legend('True values', 'Estimated values')
xlabel('Time k')
ylabel('Values of states')
hold off


    
c2 = figure('Name', 'GDRP')
plot(X_k_true, 'b', 'linewidth',3)
hold on
plot(X_k2, '-.r', 'linewidth',3)
legend('True values', 'Estimated values')
xlabel('Time k')
ylabel('Values of states')
txt1 = ['RMSE: ',num2str(RMSE_GD_mean)];
text(80,-18,txt1,'FontSize',18)
hold off



%saveas(c2, 'c2.png')