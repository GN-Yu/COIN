clear;

trials = 768;

file = dir(sprintf('data/DMdata/sub01_*.csv'));
filename = file(1).name;
data = readtable(filename);
cues = [data.cue_with_perturb].';
perturbations = [data.perturbation].' / 0.52;

% create an object of the COIN class
obj = COIN;

obj.perturbations = perturbations;
obj.cues = cues;
obj.renumber_cues;

obj.runs = 3;
obj.max_cores = feature('numcores');

obj.infer_bias = true;

obj.plot_state_given_context = true;
obj.plot_predicted_probabilities = true;
obj.plot_state = true;
obj.plot_bias_given_context = true;
obj.plot_bias = true;
obj.plot_state_feedback = true;
obj.plot_explicit_component = true;
obj.plot_implicit_component = true;
obj.plot_global_cue_probabilities  = true;
obj.plot_local_cue_probabilities   = true;

OUTPUT = obj.simulate_COIN;

for run = 1:obj.runs
    noiseless_motor_output = OUTPUT.runs{run}.motor_output;
    motor_noise = randn(trials,1)*obj.sigma_motor_noise;
    motor_output(run,:) = noiseless_motor_output + motor_noise;
    state_feedback_output(run,:) = OUTPUT.runs{run}.state_feedback;
end

error = obj.perturbations - OUTPUT.weights*motor_output;


figure
plot(error)
grid on;
xlim([0,800]);
ylim([-1.2,1.2]);
legend("perturbations - motor output")