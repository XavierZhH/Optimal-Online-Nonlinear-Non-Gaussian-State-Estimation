function x_new = MTCL(x_initial, Q, k, N)
%N is the iterations of Monte Carlo
%k is the time of state
%Q is the noise variance

x_new = zeros(k + 1, N);

%x0
x_new(1, :) = x_initial;

for i = 2: k + 1
    for j = 1: N
        %plus noise
        x_new(i, j) = State_updt(x_new(i - 1, j), i - 1) + sqrt(Q) * randn;
    end
end

end
