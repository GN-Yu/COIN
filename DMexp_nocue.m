P = 20;
trials = 768;
output_motor_with_noise = true;
pert_seq_codes = zeros(1,20);

for participant = 1:P

    file = dir(sprintf('data/DMdata/sub%02d_*.csv', participant));
    filename = file(1).name;
    data = readtable(filename);
    cues = [data.target_inds].';
    perturbations = [data.perturbation].' / 0.52;
    pert_seq_codes(participant) = unique(data.pert_seq_code);

    % create an object of the COIN class
    obj = COIN;

    obj.perturbations = perturbations;
%     obj.cues = cues;

    obj.runs = 5;
    obj.max_cores = feature('numcores');

%     obj.infer_bias = true;

    OUTPUT = obj.simulate_COIN;
    
    for run = 1:obj.runs
        noiseless_motor_output = OUTPUT.runs{run}.motor_output;
        motor_noise = randn(trials,1)*obj.sigma_motor_noise;
        motor_output(run,:) = noiseless_motor_output + motor_noise;
        state_feedback_output(run,:) = OUTPUT.runs{run}.state_feedback;
    end
    
    error(participant,:) = obj.perturbations - OUTPUT.weights*motor_output;

end

pert_seq_codes = 2 * pert_seq_codes - 1;

error_ave = mean(diag(pert_seq_codes) * error);

% plot motor error figure
% figure
% plot(OUTPUT.weights*motor_output)
% hold on
% plot(OUTPUT.weights*state_feedback_output)
% legend('motor output','state feedback')

figure
plot(error_ave)
grid on;
xlim([0,800]);
ylim([-1.2,1.2]);
title("COIN error average without cues")
legend('off');

% 
% 
% % Save all figures
% for i = 1:10
%     figure(i);
%     % Append the folder 'figures' before the filename
%     print(fullfile('.', 'figureoutput_COIN', ['figure' num2str(i) '.png']), '-dpng');
% end

% Close all figure windows
% close all;