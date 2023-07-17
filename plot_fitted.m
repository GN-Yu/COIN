% % Write the fitted motor output to a .csv file
% writematrix(fit, 'fitted_motoroutput.csv');
% 
% avg_col = mean(fit, 1); % compute the average of each column
% 
% % Create a vector for the x-axis values (indices of the columns)
% x_values = 1:1:size(fit, 2); 
% 
% % Plot the average of each column vs. the column index
% figure;
% plot(x_values, avg_col);
% xlabel('Column Index');
% ylabel('Average Value');
% title('Average of Each Column vs. Column Index');
% grid on;

participant = 2;

% % Select a row, e.g., the 5th row
% row_to_plot = fit(participant, :);
% 
% % Create a vector for the x-axis values (indices of the columns)
% x_values = 1:size(fit, 2);
% 
% % Plot the selected row
% figure;
% plot(x_values, row_to_plot);
% xlabel('Column Index');
% ylabel('Value');
% title(['Value of Row ', num2str(participant), ' vs. Column Index']);
% grid on;
% 
figure;
plot(perturbations(participant,:) - fit(participant,:))
grid on;
xlim([0,800]);
ylim([-1.5,1.5]);
legend("perturbations - motor output")