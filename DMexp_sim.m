obj_DM = COIN;

obj_DM.perturbations = [zeros(1,24) ones(1,60) zeros(1,24) -ones(1,60) zeros(1,24) NaN(1,192) zeros(1,24) -ones(1,60) zeros(1,24) ones(1,60) zeros(1,24) NaN(1,192)];

obj_DM.runs = 15;
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