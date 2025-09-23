wing_length = [10.4;10.8;11.1;10.2;10.3;10.2;10.7;10.5;10.8;11.2;10.6;11.4];
tail_length = [7.4;7.6;7.9;7.2;7.4;7.1;7.4;7.2;7.8;7.7;;7.8;8.3];
n = length(wing_length)

%% 1. Plot X vs Y. Do they look related?
scatter(wing_length, tail_length, 'filled');
xlabel('Wing Length');
ylabel('Tail Length');
title('Wing Length vs Tail Length');
grid on;
% The variables appear positively correlated.

%% 2. Calculate r(X,Y) and r(Y,X) first using the equations above and then
% using either the Python numpy funciton corrcoef or Matlab's built-in corrcoef.
% Did you get the same answers?

% manually calculating:
for i = 1:n
    xi_minus_mean(i) = wing_length(i)-mean(wing_length);
    yi_minus_mean(i) = tail_length(i)-mean(tail_length);

    xi_minus_mean_squared(i) = xi_minus_mean(i)^2;
    yi_minus_mean_squared(i) = yi_minus_mean(i)^2;

end

r_xy_manual = (sum(xi_minus_mean.*yi_minus_mean)) / (sqrt(sum(xi_minus_mean_squared))*sqrt(sum(yi_minus_mean_squared)));
r_yx_manual = (sum(yi_minus_mean.*xi_minus_mean)) / (sqrt(sum(yi_minus_mean_squared))*sqrt(sum(xi_minus_mean_squared)));

% using corrcoef function:
r_xy = corrcoef(wing_length, tail_length);
r_yx = corrcoef(tail_length, wing_length);

fprintf('The manually calculated values are r(X,Y) = %.2f and r(Y,X) = %.2f. \n', r_xy_manual,r_yx_manual)
fprintf('The values using the corrcoef function are r(X,Y) = %.2f and r(Y,X) = %.2f.\n', r_xy(1,2), r_yx(1,2));

%% 3. What is the standard error of r(X,Y)? The 95% confidence intervals computed from the standard error?
std_error_r_xy = sqrt((1 - r_xy(1,2)^2)/(n - 2));

% 95% confidence intervals
z = 0.5 * log((1+r_xy(1,2))/(1-r_xy(1,2)));
sd = sqrt(1/(n-3));
z_crit = norminv([0.025,0.975]);
z_confidence_intervals_lower = z + z_crit(1)*sd;
z_confidence_intervals_upper = z + z_crit(2)*sd;
r_xy_confidence_intervals_lower = (exp(2*z_confidence_intervals_lower)-1)/(exp(2*z_confidence_intervals_lower)+1);
r_xy_confidence_intervals_upper = (exp(2*z_confidence_intervals_upper)-1)/(exp(2*z_confidence_intervals_upper)+1);

fprintf('Standard error of r(X,Y): %.4f\n', std_error_r_xy);
fprintf('95%% confidence interval: [%.4f, %.4f]\n', r_xy_confidence_intervals_lower, r_xy_confidence_intervals_upper);

%% 4. Should the value of r(X,Y) be considered significant at the p<0.05 level, given a two-tailed test (i.e., we reject if the test statistic is too large on either tail of the null distribution) for H0: r(X,Y)=0?

t_stat = r_xy(1,2)*sqrt((n-2)/(1-r_xy(1,2)^2));
p_value = 2*(1-tcdf(abs(t_stat),n-2));

fprintf('t-statistic: %.4f\n', t_stat);
fprintf('p-value: %.4f\n', p_value);

% Since p < 0.05, the value of r(X,Y) is significant and the null
% hypothesis r(X,Y)=0 can be rejected.

%% 5. Yale does the exact same study and finds that his correlation value is 0.75. Is this the same as yours? That is, evaluate H0: r=0.75.

r0 = 0.75
t_stat_new = (r_xy(1,2)-r0)*sqrt((n-2)/(1-r_xy(1,2)^2));
p_value_new = 2*(1-tcdf(abs(t_stat_new),n-2));

fprintf('t-statistic: %.4f\n', t_stat_new);
fprintf('p-value: %.4f\n', p_value_new);

% Since p > 0.05, there is not sufficient evidence to reject the null
% hypothesis that the correlation value is 0.75.

%% 6. Finally, calculate the statistical power and sample size needed to reject H0: r=0 when r>=0.5.

power_values = 0.1:0.1:0.9;
n_required = zeros(length(power_values),1);

for i = 1:length(power_values)
    n_required(i) = sampsizepwr('t', [0 sd], 0.5, power_values(i));
end

table(power_values',n_required,'VariableNames', {'Power', 'Required Sample Size'})