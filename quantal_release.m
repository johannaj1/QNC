% Neuroscience Example: Quantal Release

% Exercise 1

p1 = 0.2; % probability of each release event
n1 = 10; % number of possible quanta

% preallocate an array to store probabilities
probabilities1 = zeros(n1 + 1, 1);

% calculate binomial probabilities using a for loop
for k1 = 0:n1
    probabilities1(k1 + 1) = binopdf(k1, n1, p1);
end

quanta1 = (0:n1)'; % column vector for number of quanta released
T1 = table(quanta1, probabilities1, 'VariableNames', {'Number of quanta', 'Binomial probability'});
disp(T1);


% Exercise 2

n2 = 14; % number of possible quanta
k2 = 8; % number of quanta observed in this experiment

% create a vector with the values of p being tested
deciles = 0.1:0.1:1.0;

% preallocate an array to store probabilities
probabilities2 = zeros(length(deciles), 1);

% calculate binomial probabilities using a for loop
for p2 = deciles
    probabilities2(find(deciles == p2),1) = binopdf(k2, n2, p2);
end

T2 = table(deciles', probabilities2, 'VariableNames', {'Value of p', 'Binomial probability'});
disp(T2);

fprintf('The value of p with the highest binomial probability of releasing exactly 8 quanta (maximum likelihood) is p = 0.6 \n');

% Exercise 3

k3 = 5; % number of quanta observed in this second experimental replicate

% preallocate an array to store probabilities for measurement 
probabilities3 = zeros(length(deciles), 1);

% calculate binomial probabilities using a for loop
for p3 = deciles
    probabilities3(find(deciles == p3),1) = binopdf(k3, n2, p3);
end

% calculate full and log likelihoods
full_likelihood = probabilities2.*probabilities3;
log_likelihood = log(probabilities2)+log(probabilities3);

T3 = table(deciles', full_likelihood,log_likelihood, 'VariableNames', {'Value of p', 'Full likelihood', 'Log likelihood'});
disp(T3);

fprintf('The value of p with the highest full likelihood value / least negative log likelihood value is p = 0.5 \n');
fprintf('The estimate improves as sample size is increased \n')

% Exercise 4

% using a maximum likelihood estimation
counts = [0,0,3,7,10,19,26,16,16,5,5,0,0,0,0];

% suggested by copilot; a function that repeats the elements of the first
% input (the vector 0:14) the number of times in the corresponding position
% in "counts"

data = repelem([0:14],counts);

% suggested by copilot: using a built-in mle function. Takes as input the
% dataset calculated above, the type of distribution you want to assume (in
% this case binomial), and the value of n (necessary if using binomial
% distribution)
p_hat = mle(data,'distribution','binomial','ntrials', n2);

fprintf('The value of p-hat after these 100 experiments is %.4f.\n', p_hat)

% Exercise 5

k5 = 7; % number of quanta observed in this experiment
newtemperature_p_hat = mle (k5, 'distribution','binomial','ntrials', n2);
newtemperature_p_hat

p_true = 0.3; % the actual probability that was determined

% calculate the binomial probabilities
probabilities = binopdf(0:n2, n2, p_true);

% create the bar graph
figure;
bar(0:n2, probabilities);
title('Binomial Distribution (n=14, p=0.3)');
xlabel('Number of quanta released');
ylabel('Probability');
xlim([-0.5 n2 + 0.5]);

probability_of_exactly_7 = probabilities(k5+1); % the position in the probabilities vector containing the probability corresponding to k5
probability_of_7_or_more = sum(probabilities(k5+1:end));

fprintf('The probability of observing exactly 7 quantal releases under the null hypothesis is %.4f.\n', probability_of_exactly_7)
fprintf('The probability of observing 7 or more quantal releases under the null hypothesis is %.4f.\n', probability_of_7_or_more)
fprintf('Both of these values are greater than the alpha level of 0.05, so neither provide sufficient evidence to reject the null hypothesis. \n')
fprintf('You cannot conclude that there is a significant effect of temperature. \n')