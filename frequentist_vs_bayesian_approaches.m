%Exercise 1
pvalue = 0.05
 if pvalue < 0.05
     fprintf('The p-value is significant \n \n')
else
     fprintf('The p-value is not significant \n \n')

fprintf('The p-value reflects the probability that a positive result would be observed if the null hypothesis (the patient does NOT have HIV) \n')
fprintf('is true. Since the false positive rate of 0.05 is not less than the alpha level 0.05 (it is exactly equal), the p-value is not significant.\n\n')
 end

%Exercise 2
% Given values (with input from Copilot)
P_positive_given_infected = 1; % Probability of a person testing positive given infected
P_positive_given_not_infected = 0.05; % Probability of a person testing positive given not infected

% Initialize prior infection rates
prior_infection_rates = 0:0.1:1;
bayesian_result = zeros(size(prior_infection_rates));

% Calculate results for each prior
for i = 1:length(prior_infection_rates)
    P_infected = prior_infection_rates(i); % Prior probability of infection
    P_not_infected = 1 - P_infected; % Probability of not being infected

    % Calculate P(positive)
    P_positive = P_positive_given_infected * P_infected + P_positive_given_not_infected * P_not_infected;

    % Apply Bayes' theorem
    P_infected_given_positive = (P_positive_given_infected * P_infected) / P_positive;

    % Store the result
    bayesian_result(i) = P_infected_given_positive;
end

% Display results
disp(table(prior_infection_rates', bayesian_result', ...
    'VariableNames', {'Infection Rate', 'Probability Infected Given Positive'}));