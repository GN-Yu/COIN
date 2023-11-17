P = 1;
trials = 768;
output_motor_with_noise = true;
pert_seq_codes = zeros(1,P);
error = zeros(P,trials);

plot_and_save_all = true;

if ~(P==1)
    plot_and_save_all = false;
end


for participant = 1:P

    file = dir(sprintf('data/DMdata/sub%02d_*.csv', participant));
    filename = file(1).name;
    data = readtable(filename);
%     cues = [data.target_inds].';
    perturbations = [data.perturbation].' / 0.52;
    pert_seq_codes(participant) = unique(data.pert_seq_code);

    % create an object of the COIN class
    obj = COIN;

    obj.perturbations = perturbations;
%     obj.cues = cues;

    obj.runs = 5;
    obj.max_cores = feature('numcores');

    if plot_and_save_all
        obj.infer_bias = true;

        obj.plot_state_given_context = true;
        obj.plot_predicted_probabilities = true;
        obj.plot_state = true;
        obj.plot_bias_given_context = true;
        obj.plot_bias = true;
        obj.plot_state_feedback = true;
        obj.plot_explicit_component = true;
        obj.plot_implicit_component = true;
    end

    OUTPUT = obj.simulate_COIN;
    
    for run = 1:obj.runs
        noiseless_motor_output = OUTPUT.runs{run}.motor_output;
        motor_noise = randn(trials,1)*obj.sigma_motor_noise;
        motor_output(run,:) = noiseless_motor_output + motor_noise;
        state_feedback_output(run,:) = OUTPUT.runs{run}.state_feedback;
    end
    
    error(participant,:) = obj.perturbations - OUTPUT.weights*motor_output;

end

pert_seq_codes = 1 - 2 * pert_seq_codes;
error_matrix = diag(pert_seq_codes) * error;

% In trial 72 of subject 14, the perturbation is wrong
% ignore 14th element when taking average
% Remove the 14th row
if P == 20
    error_matrix(14, :) = [];
end

% Compute the mean
error_ave = mean(error_matrix);

% figure('Position', [50, 50, 900, 400]);
% plot(error_ave)
% grid on;
% xlim([0,800]);
% ylim([-1.2,1.2]);
% xlabel('Trials')
% ylabel('Motor Error')
% % title("COIN error average without cues")
% legend('off');
% print('sim_nocue_real_pert.png', '-dpng'); % Saves the figure as a PNG file

% Save all figures for a single simulation
if plot_and_save_all
    figure
    plot(error)
    grid on;
    xlim([0,800]);
    ylim([-1.2,1.2]);
    xlabel('Trials')
    ylabel('Motor Error')
    % title("COIN error average without cues")
    legend('off');

    for i = 1:10
        figure(i);

        % Set figure size [left, bottom, width, height]
        set(gcf, 'Position', [10, 10, 400, 300]);

        % Append the folder 'figures' before the filename
        print(fullfile('.', 'figureoutput_COIN', ['figure' num2str(i) '.png']), '-dpng');
    end

    % Close all figure windows
    % close all;
end