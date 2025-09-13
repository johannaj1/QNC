% simulating Poisson data for LC spiking
lambda = 2; % looks on graph like mean spike rate is 2 per second? I'm not sure how else I would know this value...?
N = 1000;   % Number of random samples to generate



%%
% simulating Gaussian data for pupil diameter z-score
mu = 0;      % Mean of the Gaussian distribution
sigma = 1;   % Standard deviation of the Gaussian distribution

correlation = zeros(1000,1); % preallocate vector to store simulated correlation coefficients

for trials = [1:1000]
    randomData_p = poissrnd(lambda, N, 1); % Generate new set of random samples from a Poisson distribution
    randomData_g = normrnd(mu, sigma, N, 1); % Generate new set of random samples from a Gaussian distribution
    correlation(trials) = corr(randomData_p, randomData_g); % Calculate correlation coefficient
end

mean(correlation) % verify that the mean simulated correlation coefficient should be around zero
%%

% Parameters
mu_null = mean(correlation); % Null hypothesis mean
sigma = std(correlation); % NOTE: I am extremely confused about what to set this value to. How would we know the true standard deviation of the population? Wouldn't we need to be given this value?
power_target = 0.80; % Desired power
effectsizes = 0.1:0.1:1.0 % Range of effect sizes to test

n_required = zeros(10,1)

for x = 1:10
    mu_alternative = effectsizes(1,x)
n_required(x,1) = sampsizepwr('t', [mu_null sigma], mu_alternative, power_target)
end

% Create a table
T = table(effectsizes', n_required, 'VariableNames', {'Effect Size', 'Required Number of Data Samples'});

% Display the table
disp(T);