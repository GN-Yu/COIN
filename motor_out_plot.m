figure
plot(obj_DM.perturbations - OUTPUT.weights*motor_output)
grid on;
xlim([0,800]);
ylim([-1.2,1.2]);
legend("perturbations - motor output")


% % Save all figures
% for i = 1:10
%     figure(i);
%     % Append the folder 'figures' before the filename
%     print(fullfile('.', 'figureoutput_COIN', ['figure' num2str(i) '.png']), '-dpng');
% end