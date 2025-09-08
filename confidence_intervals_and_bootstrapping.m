% Confidence intervals and bootstrapping
% (with input from Copilot)


n = [5, 10, 20, 40, 80, 160, 1000];
mean_value = 10;
std_dev = 2;
num_observations = length(n);

% Calculate SEM
sem = std_dev / sqrt(num_observations);

% Method 1: determine confidence interval using 95% confidence interval z-score
z_score = 1.96; % Z-score for 95% confidence interval

% Calculate confidence interval
lower_bound_1 = mean_value - z_score * sem;
upper_bound_1 = mean_value + z_score * sem;

% Display the results
disp('Confidence interval from z-score method:');
disp(['Lower Bound: ', num2str(lower_bound_1)]);
disp(['Upper Bound: ', num2str(upper_bound_1)]);
fprintf('\n');

% Method 2: use a student's t-distribution
degrees_of_freedom = num_observations - 1;

alpha = 0.05; % significance level for 95% confidence interval
t_score = tinv(1 - alpha/2, degrees_of_freedom);

% Calculate confidence interval
lower_bound_2 = mean_value - t_score * sem;
upper_bound_2 = mean_value + t_score * sem;

disp('Confidence interval from t-distribution method:');
disp(['Lower Bound: ', num2str(lower_bound_2)]);
disp(['Upper Bound: ', num2str(upper_bound_2)]);
fprintf('\n');

% Method 3: determine confidence interval using bootstrapping
num_bootstrap_samples = 1000; %using 1000 bootstrap samples

% Initialize array to hold bootstrap means
bootstrap_means = zeros(num_bootstrap_samples, 1);

% Bootstrapping process
for i = 1:num_bootstrap_samples
    % Resample with replacement
    sample = datasample(n, length(n));
    % Calculate the mean of the bootstrap sample
    bootstrap_means(i) = mean(sample);
end

% Calculate the confidence interval (95%)
alpha = 0.05; % significance level
lower_bound_3 = prctile(bootstrap_means, 100 * (alpha / 2));
upper_bound_3 = prctile(bootstrap_means, 100 * (1 - alpha / 2));

% Display the results
disp('Confidence interval using bootstrapping:');
disp(['Lower Bound: ', num2str(lower_bound_3)]);
disp(['Upper Bound: ', num2str(upper_bound_3)]);
fprintf('\n');

% Method 4: determine confidence interval using Bayesian credible intervals
% Prior parameters (assuming a normal prior)
prior_mean = 0; % Prior mean
prior_variance = 10; % Prior variance

% Posterior parameters
posterior_mean = (prior_variance * mean_value + std_dev^2 * prior_mean) / ...
                 (prior_variance + std_dev^2);
posterior_variance = 1 / (1/prior_variance + num_observations/std_dev^2);

% Calculate the credible interval (95%)
alpha = 0.05; % significance level
lower_bound_4 = posterior_mean - norminv(1 - alpha/2) * sqrt(posterior_variance);
upper_bound_4 = posterior_mean + norminv(1 - alpha/2) * sqrt(posterior_variance);

% Display the results
disp('Confidence interval using Bayesian credible intervals:');
disp(['Lower Bound: ', num2str(lower_bound_4)]);
disp(['Upper Bound: ', num2str(upper_bound_4)]);
fprintf('\n');