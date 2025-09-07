% Completed with input from Copilot
% Reference paper: "The effect of cancer and cancer treatment on attention control: evidence
% from anti-saccade performance" (Edelman et al., 2024)
% doi:  https://doi.org/10.1007/s11764-024-01711-2
% Generating a graph of the fixation interval described in the Methods
% section.
lambda = 0.002; % Rate parameter (lambda)

% Define the x values for the PDF
x = linspace(1000, 3500)

% Calculate the PDF of the exponential distribution
pdf = exppdf(x, 1/lambda); % Note: exppdf uses mean (1/lambda)

% Create a figure
figure;

% Plot the PDF
plot(x, pdf, 'r-', 'LineWidth', 2)
xlabel('Time (ms)');
ylabel('Probability Density');
title('Exponential Distribution of Fixation Duration (Lambda = 0.002 ms^{-1})');
grid on;

mean_fixation_period = 1000 + (1/lambda); % The mean fixation period is the starting point
% (1000 ms) plus 1/lambda.
fprintf('Mean fixation period: %.2f ms\n', mean_fixation_period);
