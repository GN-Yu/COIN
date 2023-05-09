% Define the length of the vector
vectorLength = 192;  % Modify this value as per your desired length

% Generate random integers between 1 and 3
randomIntegers = rand([1, 3], 1, vectorLength);

% Convert the random integers to the corresponding values: 0, -1, 1
vector = randomIntegers - 2;

% Display the generated vector
% disp(vector);


obj_DM = COIN;

obj_DM.perturbations = [zeros(1,24) ones(1,60) zeros(1,24) -ones(1,60) zeros(1,24) vector zeros(1,24) -ones(1,60) zeros(1,24) ones(1,60) zeros(1,24) vector];

obj_DM.runs = 2;
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