clc
clear all

rng(1)
% choose the environment:
env = Discrete3DEnvClass;
% env = Discrete3DEnvClass_randomtarget;
% env = Discrete3DEnvClass_randomin;

obsInfo = getObservationInfo(env);
actInfo = getActionInfo(env);
agent = rlDQNAgent(obsInfo,actInfo);

agent.AgentOptions.EpsilonGreedyExploration.EpsilonDecay = 1e-5;
agent.AgentOptions.EpsilonGreedyExploration.Epsilon = 0.2;
agent.AgentOptions.MiniBatchSize = 128; %64
agent.AgentOptions.CriticOptimizerOptions.LearnRate = 5e-4;
agent.AgentOptions.CriticOptimizerOptions.GradientThreshold = 1;

HRM = true;
if HRM    
    rewardFcn = @myNavigationGoalRewardFcn;
    isDoneFcn = @myNavigationGoalIsDoneFcn;
    % observation: [robot_x, robot_y, robot_z, goal_x, goal_y, goal_z]'
    % goal measurement: channel --- 1, indices --- 1,2,3
    % goal: channel --- 1, indices --- 4,5,6 
    goalConditionInfo = {{1,[1,2,3], 1, [4,5,6]}};
    bufferLength = 1e5;
    agent.ExperienceBuffer = rlHindsightReplayMemory(obsInfo,actInfo,...
        rewardFcn,isDoneFcn,goalConditionInfo,bufferLength);
else    
    agent.AgentOptions.ExperienceBufferLength = 1e5;
end

maxEpisodes = 15000;
maxStepsPerEpisode = 120; %120;% 240; % 240; % 120;
trainOpts = rlTrainingOptions(...
    MaxEpisodes=maxEpisodes, ...
    MaxStepsPerEpisode=maxStepsPerEpisode, ...
    Verbose=false, ...
    ScoreAveragingWindowLength=100,...
    Plots="training-progress",...
    StopTrainingCriteria="EpisodeCount",...
    StopTrainingValue=maxEpisodes);

%% done
% rng(2)
load('RLDesignerSessRtargetnew.mat') %150000 max episodes
plot(env)
simOptions = rlSimulationOptions(...
    NumSimulations=100,...
    MaxSteps=maxStepsPerEpisode);
simResults = sim(env,RLDesignerSession.Data.Agents(2).Data,simOptions);
save('100simulations_targetnew.mat')

%% done
% rng(2)
load('RLDesignerSessRstartnew.mat')
plot(env)
simOptions = rlSimulationOptions(...
    NumSimulations=100,...
    MaxSteps=maxStepsPerEpisode);
simResults = sim(env,RLDesignerSession.Data.Agents(2).Data,simOptions);
%save('100simulations_startnew.mat')

%% done
rng(2)
load('RLDesignerSessReference.mat')
plot(env)
simOptions = rlSimulationOptions(...
    NumSimulations=100,...
    MaxSteps=maxStepsPerEpisode);
simResults = sim(env,RLDesignerSession.Data.Agents(2).Data,simOptions);
save('100simulations_complex.mat')

%%
% rng(2)
load('RLDesignerSessRR500RM(+4).mat')
plot(env)
simOptions = rlSimulationOptions(...
    NumSimulations=1,...
    MaxSteps=maxStepsPerEpisode);
simResults = sim(env,RLDesignerSession.Data.Agents(4).Data,simOptions);

save('100simulations_complex.mat')
%%
% rng(2)
load('RLDesignerSessRR500_04.mat') 
plot(env)
simOptions = rlSimulationOptions(...
    NumSimulations=100,...
    MaxSteps=maxStepsPerEpisode);
simResults = sim(env,RLDesignerSession.Data.Agents(2).Data,simOptions);

save('100simulations_500_0.4.mat')
%%
% rng(2)
load('RLDesignerSessRR500e-5.mat') %150000 max episodes
plot(env)
simOptions = rlSimulationOptions(...
    NumSimulations=10,...
    MaxSteps=maxStepsPerEpisode);
simResults = sim(env,RLDesignerSession.Data.Agents(2).Data,simOptions);

save('100simulations_500e-5.mat')
%%
% rng(2)
load('RLDesignerSessRR500e-3.mat') %150000 max episodes
plot(env)
simOptions = rlSimulationOptions(...
    NumSimulations=1,...
    MaxSteps=maxStepsPerEpisode);
simResults = sim(env,RLDesignerSession.Data.Agents(2).Data,simOptions);

save('100simulations_500e-3.mat')

%%
% rng(2)
load('RLDesignerSessR8000.mat') 
plot(env)
simOptions = rlSimulationOptions(...
    NumSimulations=100,...
    MaxSteps=maxStepsPerEpisode);
simResults = sim(env,RLDesignerSession.Data.Agents(2).Data,simOptions);

save('100simulationsR8000.mat')

%%
% rng(2)
load('RLDesignerSessReference.mat') 
plot(env)
simOptions = rlSimulationOptions(...
    NumSimulations=1,...
    MaxSteps=maxStepsPerEpisode);
simResults = sim(env,RLDesignerSession.Data.Agents(2).Data,simOptions);

save('RnewMap1.mat')
