% figure('Position', [50, 50, 900, 400]);
% plot(obj_DM.perturbations - OUTPUT.weights*motor_output)
% grid on;
% xlim([0,800]);
% ylim([-1.49,1.49]);
% xlabel('Trials')
% ylabel('Motor Error')
% 
% print('sim_nocue_rand_ints.png', '-dpng'); % Saves the figure as a PNG file

% % Save all figures
% for i = 1:10
%     figure(i);
%     % Append the folder 'figures' before the filename
%     print(fullfile('.', 'figureoutput_COIN', ['figure' num2str(i) '.png']), '-dpng');
% end
% figure('Position', [10, 10, 400, 250]); % Set the size here

for i = 1:10
    figure(i);
    
    % Set figure size [left, bottom, width, height]
    set(gcf, 'Position', [10, 10, 400, 300]); % Example size: 800x600 pixels

    % Append the folder 'figures' before the filename
    print(fullfile('.', 'figureoutput_COIN', ['figure' num2str(i) '.png']), '-dpng');
end
