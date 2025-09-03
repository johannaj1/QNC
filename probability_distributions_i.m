% Simulating data from the binomial distribution shown in figure 4D of:
%"Lipidic folding pathway of a-synuclein via a toxic oligomer"
%(Sant et al., 2025) https://doi.org/10.1038/s41467-025-55849-3

%  p = probability of success on each trial (constant across trials)
%  n = number of trials

p = 0.27;
n = 4;       % number of "trials" per "experiment"
NumExperiments = 1000;     % number of "experiments"
outcomes = binornd(n,p,NumExperiments,1)

% Make histogram of all possible outcomes. We want bins centered on whole
% numbers so we offset the edges
edges = -0.5:10.5;
counts = histcounts(outcomes, edges)

% Show a bar plot of the simulated bionimal distribution
clf;
xs = edges(1:end-1)+diff(edges)/2;
bar(xs, counts);
title(sprintf('Histogram of binomial distribution, n=%d, p=%.2f'));
xlabel(sprintf('Number of successes in %d tries', n));
ylabel('Count');
xlim([1 6]);

sum(outcomes>0)
% Normalize it to make it a pdf. Here counts (the x-axis of the histogram)
%  is a DISCRETE variable, so we just have to add up the values
bar(xs, counts./sum(outcomes>0)); % it seems like the authors displayed their probabilities relative to the nonzero values,
% while excluding cases where the (simulated) value would have been zero. I converted
% to a PDF by dividing the total counts for x-values 1-4 by the total
% number of simulated trials where there was a nonzero result

title(sprintf('PDF of binomial distribution, n=%d, p=%.2f', ...
   n,p));
xlabel(sprintf('Number of successes in %d tries', n));
ylabel('Probability');
xlim([1 6]);
