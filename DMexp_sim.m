% Define the length of the vector
vectorLength = 192;  % Modify this value as per your desired length

% Generate random integers of 0, -1, 1
randomIntegers = randi([1, 3], 1, vectorLength);
randomIntegers = randomIntegers - 2;

% Generate random numbers between -1 to 1
randomNumbers = rand(1, vectorLength);
randomNumbers = (randomNumbers * 2) - 1;


obj_DM = COIN;

obj_DM.perturbations = [zeros(1,24) ones(1,60) zeros(1,24) -ones(1,60) zeros(1,24) randomNumbers zeros(1,24) -ones(1,60) zeros(1,24) ones(1,60) zeros(1,24) randomNumbers];

obj_DM.runs = 10;
obj_DM.max_cores = feature('numcores');

obj_DM.infer_bias = true;

obj_DM.plot_state_given_context = true;
obj_DM.plot_predicted_probabilities = true;
obj_DM.plot_state = true;
obj_DM.plot_bias_given_context = true;
obj_DM.plot_bias = true;
obj_DM.plot_state_feedback = true;
obj_DM.plot_explicit_component = true;
obj_DM.plot_implicit_component = true;

OUTPUT = obj_DM.simulate_COIN;

% plot motor error figure
for run = 1:obj_DM.runs
    motor_output(run,:) = OUTPUT.runs{run}.motor_output;
    state_feedback_output(run,:) = OUTPUT.runs{run}.state_feedback;
end
% figure
% plot(OUTPUT.weights*motor_output)
% hold on
% plot(OUTPUT.weights*state_feedback_output)
% legend('motor output','state feedback')

figure
plot(obj_DM.perturbations - OUTPUT.weights*motor_output)
grid on;
xlim([0,800]);
ylim([-1.2,1.2]);
legend("perturbations - motor output")


% Save all figures
for i = 1:10
    figure(i);
    % Append the folder 'figures' before the filename
    print(fullfile('.', 'figureoutput_COIN', ['figure' num2str(i) '.png']), '-dpng');
end

% Close all figure windows
% close all;