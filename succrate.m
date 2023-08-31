%% succrate
% In this script, we calculate:
% - success rate of each testing session
% - final cumulative reward function for each training session 
% They are plotted in a bar graph to compare
%%
%%
clear all
clc
load('100simulations_complex.mat')
reachtarget = [];
for i = 1:100
    endreward(i) = simResults(i).Reward.Data(end);
    act(i) = length(simResults(i).Reward.Data);
    if endreward(i) == 4
        reachtarget=[reachtarget, i];
    end
end
successrate3 = length(reachtarget);

load('RLDesignerSessReference.mat')
endaverageR3 = RLDesignerSession.Data.TrainResults.Data.AverageReward(end);

%%
load('100simulations_startnew.mat')
reachtarget = [];
for i = 1:100
    endreward(i) = simResults(i).Reward.Data(end);
    act(i) = length(simResults(i).Reward.Data);
    if endreward(i) == 4
        reachtarget=[reachtarget, i];
    end
end
successrate1 = length(reachtarget);

load('RLDesignerSessRstartnew.mat')
endaverageR1 = RLDesignerSession.Data.TrainResults.Data.AverageReward(end);

%%
load('100simulations_targetnew.mat')
reachtarget = [];
for i = 1:100
    endreward(i) = simResults(i).Reward.Data(end);
    act(i) = length(simResults(i).Reward.Data);
    if endreward(i) == 4
        reachtarget=[reachtarget, i];
    end
end
successrate2 = length(reachtarget);

load('RLDesignerSessRstartnew.mat')
endaverageR2 = RLDesignerSession.Data.TrainResults.Data.AverageReward(end);

%%
% clear all
% clc
% load('100simulationsR8000.mat')
% reachtarget = [];
% for i = 1:100
%     endreward(i) = simResults(i).Reward.Data(end);
%     act(i) = length(simResults(i).Reward.Data);
%     if endreward(i) == 4
%         reachtarget=[reachtarget, i];
%     end
% end
% 
% successrate2 = length(reachtarget);
% 
% load('RLDesignerSessReference.mat')
% endaverageR2 = RLDesignerSession.Data.TrainResults.Data.AverageReward;

%% Plot a bar graph showing the success rate and final cumulative reward of the training sessions
figure()
y = [successrate1,successrate2, successrate3];
bar(y)
% legend('Successa rate % (testing)', 'final reward (training)')
figure()
y = [endaverageR1,endaverageR2,endaverageR3];
bar(y)