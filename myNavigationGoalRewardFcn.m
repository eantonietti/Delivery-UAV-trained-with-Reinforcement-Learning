function reward = myNavigationGoalRewardFcn(State, Action, NextState)

    isdone = myNavigationGoalIsDoneFcn(State, Action, NextState);
    if isdone
        reward = 4;
    else
        reward = -0.01;
        if State{1}(1) == NextState{1}(1) && State{1}(2) == NextState{1}(2) && State{1}(3) == NextState{1}(3)
           reward = reward - 0.001;
        end
    end
end