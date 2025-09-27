%% 1. Plot the relationship between Age and Wing Length.
age = [3,4,5,6,7,8,9,11,12,14,15,16,17]';
wing_length = [1.4,1.5,2.2,2.4,3.1,3.2,3.2,3.9,4.1,4.7,4.5,5.2,5.0]';

scatter(age, wing_length, 'filled');
xlim([0 18]);
xlabel('Age');
ylabel('Wing Length');
title('Scatter Plot of Age vs Wing Length');

grid on;
hold on;

%% 2. Calculate and plot the regression line.

linear_model = fitlm(age,wing_length);
disp(linear_model);
fprintf('Linear model: y = %.2fx + %.2f \n',linear_model.Coefficients.Estimate(2),linear_model.Coefficients.Estimate(1))

x_fit = linspace(0, 18, 100); % Generate x values for the line
y_fit = predict(linear_model, x_fit'); % Predict y values using the model

reg_line = line(x_fit, y_fit, 'LineWidth', 2);
reg_line.Color = 'black';

grid on;
hold on;

%% 3. Can you reject H0: b = 0?

if linear_model.Coefficients.pValue(2) < 0.05
    fprintf('Reject H0: b = 0, p-value = %e\n', linear_model.Coefficients.pValue(2));
else
    fprintf('Fail to reject H0: b = 0, p-value = %.4f\n', linear_model.Coefficients.pValue(2));
end

%% 4. Calculate and plot the confidence intervals on the slope of the regression.

confidence_intervals = coefCI(linear_model);
fprintf('95%% confidence interval for slope: %.2f to %.2f\n',confidence_intervals(2,1),confidence_intervals(2,2))

ci_lower = refline(confidence_intervals(2,1),linear_model.Coefficients.Estimate(1));
ci_upper = refline(confidence_intervals(2,2),linear_model.Coefficients.Estimate(1));

ci_lower.LineStyle = '--';
ci_upper.LineStyle = '--';
ci_lower.Color = 'r';
ci_upper.Color = 'r';

%% 5. Calculate r^2 (the coefficient of determination)

fprintf('R-squared value: %.4f\n', linear_model.Rsquared.Ordinary)

%% 6. Calculate Pearson's r.

r = corrcoef(age,wing_length);

fprintf('Pearson''s r = %.2f\n', r(1,2));

%% 7. Add some noise to the data and see how the regression changes.

noise = randn(size(wing_length));

min_noise = min(noise);
if min_noise < 0
    noise = noise - min_noise + 0.1; % Shift noise to be positive (age cannot be negative)
end

wing_length_noisy = wing_length + noise;

hold off;

scatter(age, wing_length_noisy, 'filled');
xlim([0 18]);
xlabel('Age');
ylabel('Wing Length (with noise)');
title('Scatter Plot of Age vs Wing Length');

grid on;
hold on;

linear_model_noisy = fitlm(age,wing_length_noisy);
disp(linear_model_noisy);
fprintf('Linear model with noise: y = %.2fx + %.2f \n',linear_model_noisy.Coefficients.Estimate(2),linear_model_noisy.Coefficients.Estimate(1))

x_fit_noisy = linspace(0, 18, 100); % Generate x values for the line
y_fit_noisy = predict(linear_model_noisy, x_fit_noisy'); % Predict y values using the model

reg_line = line(x_fit_noisy, y_fit_noisy, 'LineWidth', 2);
reg_line.Color = 'black';

grid on;
hold on;

confidence_intervals_noisy = coefCI(linear_model_noisy);
fprintf('95%% confidence interval for slope: %.2f to %.2f\n',confidence_intervals_noisy(2,1),confidence_intervals_noisy(2,2))

ci_lower_noisy = refline(confidence_intervals_noisy(2,1),linear_model_noisy.Coefficients.Estimate(1));
ci_upper_noisy = refline(confidence_intervals_noisy(2,2),linear_model_noisy.Coefficients.Estimate(1));

ci_lower_noisy.LineStyle = '--';
ci_upper_noisy.LineStyle = '--';
ci_lower_noisy.Color = 'r';
ci_upper_noisy.Color = 'r';

%The R-squared value (coefficient of determination) is much smaller when the data are noisy,
% and the confidence intervals are much wider.