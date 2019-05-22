clc
clear all

%Monte Carlo, 500 experiments
N = 500;
x0 = randn(1, N);

%variances of noise
Q = 10;

%iter times
k = 100;

%estimate x_k
x_state = MTCL(x0, Q, k, N);


%plot the pdfs of p(x1)
a1 = figure()
[a,b]=hist(x_state(2, :), 30);
bar(b, a/sum(a))
xlabel('State values')
ylabel('pdf of x1')

%plot the pdfs of p(x50)
a2 = figure()
[a,b]=hist(x_state(51, :), 30);
bar(b, a/sum(a))
xlabel('State values')
ylabel('pdf of x50')

%plot the pdfs of p(x100)
a3 = figure()
[a,b]=hist(x_state(101, :), 30);
bar(b, a/sum(a))
xlabel('State values')
ylabel('pdf of x100')

% saveas(a1, 'a1.png')
% saveas(a2, 'a2.png')
% saveas(a3, 'a3.png')