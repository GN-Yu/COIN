P = 1;
trials = 768;
vectorLength = 192;
error = zeros(P,trials);

plot_and_save_all = true;

if ~(P==1)
    plot_and_save_all = false;
end

for participant = 1:P
    % Generate random integers of 0, -1, 1
    randomIntegers = randi([1, 3], 1, vectorLength);
    randomIntegers = randomIntegers - 2;

    % Generate random numbers between -1 to 1
    randomNumbers = rand(1, vectorLength);
    randomNumbers = (randomNumbers * 2) - 1;

    obj_DM = COIN;

    obj_DM.perturbations = [zeros(1,24) ones(1,60) zeros(1,24) -ones(1,60) zeros(1,24) randomIntegers zeros(1,24) -ones(1,60) zeros(1,24) ones(1,60) zeros(1,24) randomIntegers];
%     obj_DM.perturbations = [zeros(1,24) ones(1,60) zeros(1,24) -ones(1,60) zeros(1,24) randomNumbers zeros(1,24) -ones(1,60) zeros(1,24) ones(1,60) zeros(1,24) randomNumbers];

    obj_DM.runs = 5;
    obj_DM.max_cores = feature('numcores');
    
    if plot_and_save_all
        obj_DM.infer_bias = true;

        obj_DM.plot_state_given_context = true;
        obj_DM.plot_predicted_probabilities = true;
        obj_DM.plot_state = true;
        obj_DM.plot_bias_given_context = true;
        obj_DM.plot_bias = true;
        obj_DM.plot_state_feedback = true;
        obj_DM.plot_explicit_component = true;
        obj_DM.plot_implicit_component = true;
    end
        
    OUTPUT = obj_DM.simulate_COIN;
    % plot motor error figure
    for run = 1:obj_DM.runs
        motor_output(run,:) = OUTPUT.runs{run}.motor_output;
        state_feedback_output(run,:) = OUTPUT.runs{run}.state_feedback;
    end
    
    error(participant,:) = obj_DM.perturbations - OUTPUT.weights*motor_output;
    
end
    
% Compute the mean
error_ave = mean(error);

% figure('Position', [50, 50, 900, 400]);
% plot(error_ave)
% grid on;
% xlim([0,800]);
% ylim([-1.2,1.2]);
% xlabel('Trials')
% ylabel('Motor Error')
% % title("COIN error average without cues")
% legend('off');
% print('sim_nocue_rand.png', '-dpng'); % Saves the figure as a PNG file

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
