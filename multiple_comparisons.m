%% Simulating t-tests: comparing 2 samples when means ARE NOT different
p_values = zeros(1000,1); % preallocate vector

for i = 1:1000
    sampleA = randn(10, 1);
    sampleB = randn(10,1); % simulating 2 normal distributions of n = 10 with mean 0 and SD 1
    [h, p] = ttest2(sampleA,sampleB);
    p_values(i, 1) = p;
end

alpha = 0.05;

false_positive_rate = sum(p_values < alpha)/1000;

fprintf('The uncorrected false positive rate is: %.2f\n', false_positive_rate)

% Bonferroni correction
bonferroni_alpha = alpha/1000; % since 1000 tests were performed, divide alpha by 1000

bonferroni_false_positive_rate = sum(p_values < bonferroni_alpha)/1000;

fprintf('The Bonferroni-corrected false positive rate is: %.2f\n', bonferroni_false_positive_rate)

% Benjamini-Hochberg correction
bh_crit_value = zeros (1000,1); % preallocate vector

ascending_p_values = sort(p_values); % sort p-values in increasing order

for i = 1:1000
    bh_crit_value(i) = (i/1000)*alpha; % calculate the BH correction
end
bh_indices = ascending_p_values <= bh_crit_value; % determine rank of p-values where p <= BH critical value

if sum(bh_indices) > 0
    bh_alpha = (ascending_p_values(max(find(bh_indices)))); % finding the maximum p-value for which p <= the corresponding BH critical value
    bh_false_positive_rate = sum(ascending_p_values < bh_alpha)/1000;
else bh_false_positive_rate = 0; % if no p-values are < BH critical value, none will be counted as a false positive
end

fprintf('The Benjamini-Hochberg-corrected false positive rate is: %.2f\n\n', bh_false_positive_rate)

%% Repeating the exercise when sample means ARE different

% Simulating t-tests comparing 2 samples
p_values = zeros(1000,1); % preallocate vector

for i = 1:1000
    sampleA = randn(10, 1)+1;
    sampleB = randn(10,1)+4; % simulating 2 normal distributions, one with mean 1 and one with mean 2
    [h, p] = ttest2(sampleA,sampleB);
    p_values(i, 1) = p;
end

alpha = 0.05;

false_positive_rate = sum(p_values < alpha)/1000;

fprintf('The uncorrected (true) positive rate is: %.2f\n', false_positive_rate)

% Bonferroni correction
bonferroni_alpha = alpha/1000; % since 1000 tests were performed, divide alpha by 1000

bonferroni_false_positive_rate = sum(p_values < bonferroni_alpha)/1000;

fprintf('The Bonferroni-corrected (true) positive rate is: %.2f\n', bonferroni_false_positive_rate)

% Benjamini-Hochberg correction
bh_crit_value = zeros (1000,1); % preallocate vector

ascending_p_values = sort(p_values); % sort p-values in increasing order

for i = 1:1000
    bh_crit_value(i) = (i/1000)*alpha; % calculate the BH correction
end
bh_indices = ascending_p_values <= bh_crit_value; % determine rank of p-values where p <= BH critical value

if sum(bh_indices) > 0
    bh_alpha = (ascending_p_values(max(find(bh_indices)))); % finding the maximum p-value for which p <= the corresponding BH critical value
    bh_false_positive_rate = sum(ascending_p_values < bh_alpha)/1000;
else bh_false_positive_rate = 0; % if no p-values are < BH critical value, none will be counted as a false positive
end

fprintf('The Benjamini-Hochberg-corrected (true) positive rate is: %.2f\n\n', bh_false_positive_rate)

% When there is NO true difference between the means of the two distributions, both the
% Bonferroni and the Benjamini-Hochberg corrections can reduce the false positive rate,
% with the conservative Bonferroni reducing false positives even more. However, if we know
% there IS a true difference between the means of the two distributions (e.g. when one had
% a mean of 1 and the other a mean of 2), the use of either correction reduces the rate at
% which true positives will be detected. This is especially true for the Bonferroni
% correction, which will only detect true positives as efficiently as the noncorrected
% p-values when the difference between the two means is larger (in this case for n = 10,
% even when the difference in the means is increased to 1 and 4,the Bonferroni-correction
% criteria will only reject the null hypothesis about ~85% of the time). This implies that
% while using these corrections can reduce false positives if the null hypothesis is true,
% it can also reduce ability to detect small,true differences in the mean.