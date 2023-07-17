data_path = '/data/DMdata/';

perturbations = readmatrix(fullfile(data_path, 'perturbations.csv'));
adaptation = readmatrix(fullfile(data_path, 'adaptation.csv'));

[P, trials] = size(perturbations);

% number of runs that are used to estimate the negative log-likelihood
runs = 2;
warning('consider increasing the number of runs that are used to estimate the negative log-likelihood')
            
% number of CPUs available (0 performs serial processing)
max_cores = feature('numcores');
warning('consider performing parallel computing on a computer cluster with more CPUs to speed up parameter optimisation')

% create an array of objects of the COIN class (one object in the array per participant)
object_fit = create_object_array(perturbations,adaptation,runs,max_cores);

% define the objective to be optimised (the negative log-likelihood)
objective = @(param) fit_COIN(object_fit,param);

warning('consider changing the parameter bounds used by BADS')
lb  = [1e-3 0.2    1   1   1e-2 1e-6 1e-4   1e-6]; % lower bounds
plb = [1e-2 0.5    10  10  5e-2 1e-2 1e-3   1e-4]; % plausible lower bounds
pub = [2e-1 0.9    1e5 1e7 2e-1 1e5  0.9    1e2 ]; % plausible upper bounds
ub  = [5e-1 1-1e-6 1e7 1e9 3e-1 1e6  1-1e-4 1e4 ]; % upper bounds

% random initial parameters inside plausible region
x0 = plb + (pub-plb).*rand(1,numel(plb));

% BADS options
options = [];
options.UncertaintyHandling = 1; % tell BADS that the objective is noisy
options.NoiseFinalSamples = 1; % # samples to estimate FVAL at the end (default is 10) - considering increasing if obj.runs is small

% fit the COIN model to the average synthetic adaptation data using BADS
tic;
[maximum_likelihood_parameters,fval,exitflag,output] = bads(objective,x0,lb,ub,plb,pub,[],options);
warning('consider repeating parameter optimisation from multiple initial points')
elapsedTime = toc;


% number of runs used to simulate the model with the fitted parameters
% this does not need to be the same as the number of runs used to estimate the negative log-likelihood
runs = 4;
warning('consider increasing the number of runs of the COIN model simulation')

% create an array of objects
object_simulate = create_object_array(perturbations,adaptation,runs,max_cores);

% simulate the model for each participant using the fitted parameters
% data = zeros(P,trials);
fit = zeros(P,trials);
for participant = 1:P
    
    % set the parameters to their fitted (maximum-likelihood) values
    set_parameters(object_simulate(participant),maximum_likelihood_parameters);
    
    if P == 1
        object_simulate(participant).adaptation = adaptation(participant,:);
    elseif P > 1
        object_simulate(participant).adaptation = [];
    end
    
    % plot internal representations
    if P == 1
        object_simulate(participant).plot_predicted_probabilities = true;
        object_simulate(participant).plot_state_given_context = true;
        object_simulate(participant).plot_state = true;
        object_simulate(participant).plot_local_transition_probabilities = true;
        object_simulate(participant).plot_global_transition_probabilities = true;
%         object_simulate(participant).plot_local_cue_probabilities = true;
%         object_simulate(participant).plot_global_cue_probabilities = true;
    end

    % run the COIN model simulation
    OUTPUT = object_simulate(participant).simulate_COIN;
    
    % extract the motor output of each run of the simulation
    motor_output = zeros(trials,runs);
    for run = 1:runs
        motor_output(:,run) = OUTPUT.runs{run}.motor_output;
    end
    
    fit(participant,:) = OUTPUT.weights*motor_output.';
    
end



function obj = create_object_array(perturbations,adaptation,runs,max_cores)

    % number of participants
    P = size(adaptation,1);

    % array of objects (one object per participant)
    obj(1,P) = COIN;
    
    % define object properties for each participant
    for participant = 1:P

        % sequence of perturbations (may be unique to each participant)
        obj(participant).perturbations = perturbations(participant,:);
        
        % sequence of sensory cues (may be unique to each participant)
%         obj(participant).cues = cues(participant,:);

        % adaptation (unique to each participant)
        obj(participant).adaptation = adaptation(participant,:);
            
        % number of runs
        obj(participant).runs = runs;
            
        % number of CPUs available (0 performs serial processing)
        obj(participant).max_cores = max_cores;

    end
    
end

function negative_log_likelihood = fit_COIN(obj,param)

    % number of participants
    P = length(obj);

    % set the parameters for each participant
    for participant = 1:P
        
        set_parameters(obj(participant),param);
        
    end
    
    % compute the objective
    negative_log_likelihood = obj.objective_COIN;
    
end
    
function set_parameters(obj,param)  

    % parameters (shared by all participants)
    obj.sigma_process_noise = param(1);         % standard deviation of process noise
    obj.prior_mean_retention = param(2);        % prior mean of retention
    obj.prior_precision_retention = param(3)^2; % prior precision (inverse variance) of retention
    obj.prior_precision_drift = param(4)^2;     % prior precision (inverse variance) of drift
    obj.sigma_motor_noise = param(5);           % standard deviation of motor noise
    obj.alpha_context = param(6);               % alpha hyperparameter of the Chinese restaurant franchise for the context transitions
    obj.rho_context = param(7);                 % rho (self-transition) hyperparameter of the Chinese restaurant franchise for the context transitions
%     obj.alpha_cue = param(8);                   % alpha hyperparameter of the Chinese restaurant franchise for the cue emissions
    
end