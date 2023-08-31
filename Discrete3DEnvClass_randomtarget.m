classdef Discrete3DEnvClass_randomtarget < rl.env.MATLABEnvironment
   % NavigationDiscreteEnv random target and random initial position
    %% Properties
    properties
        Map = zeros([20,20,20]);
        Robot
        Goal
        State = zeros(6,1)
        Obstacles
    end

    properties(Access = protected)
        % Initialize internal flag to indicate episode termination
        IsDone = false
    end

    properties (Transient,Access = private)
        Visualizer = []
    end

    %% Methods
    methods
        function this = Discrete3DEnvClass_randomtarget()
            % Initialize Observation settings
            observationInfo = rlNumericSpec([6 1]);
            observationInfo.Name = 'Observation';
            observationInfo.Description = 'Robot x, Robot y, Robot z, Goal x, Goal y, Goal z';

            % Initialize Action settings
            % 1 = move N
            % 2 = move S
            % 3 = move W
            % 4 = move E
            % 5 = move UP
            % 6 = move DOWN
             
            actionInfo = rlFiniteSetSpec([1, 2, 3, 4, 5, 6]);
            actionInfo.Name = 'Action';

            % The following line implements built-in functions of RL env
            this = this@rl.env.MATLABEnvironment(observationInfo, actionInfo);

            createMap(this);
            reset(this);
        end

        function state = reset(this)
            
            this.Robot.x  = 2;
            this.Robot.y  = 3;
            this.Robot.z  = 11;

          % Reset target position and goal position
            posFoundt = false;
            while(~posFoundt)
                pos = [randi(19); ...
                    randi(19); ...
                    randi(19)];
                if pos(3) ~= 1
                    pos_check = pos;
                    pos_check(3) = pos(3)-1;
                    c = this.Map(pos_check(1),pos_check(2),pos_check(3)) == 1 && this.Map(pos(1),pos(2),pos(3)) == 0;
                    if c
                        posFoundt = true;
                        this.Goal.x  = pos(1);
                        this.Goal.y  = pos(2);
                        this.Goal.z  = pos(3);
                    end
                else
                    c = this.Map(pos(1),pos(2),pos(3)) == 0;
                    if c
                        posFoundt = true;
                        this.Goal.x  = pos(1);
                        this.Goal.y  = pos(2);
                        this.Goal.z  = pos(3);
                    end
                end
           end

            state = [this.Robot.x, this.Robot.y, this.Robot.z, this.Goal.x, this.Goal.y, this.Goal.z]';
            this.State = state;
        end

        function createMap(this)
            % Create an empty map
            zLength = 20;
            yLength = 20;
            xLength = 20;
            this.Map = zeros([zLength,yLength,xLength]);

            % Create obstacles
            this.Obstacles = []; % zeros(186,3); % 186,3 (34,2)
            for i = 1:zLength
                for j = 1:zLength
                    for k = 1:zLength
                        if (i==2 & j==3 & k<=10) | (i==10 & j==10 & k<=7) | ...
                                (i==15 & j==16 & k<=3) | (i==2 & j==16 & k<=5) | ...
                                (i==17 & j==6 & k<=8) | (i==16 & j==14 & k<=9) | ...
                                (i==17 & j==19 & k<=3) | (i==2 & j==8 & k<=11) | ...
                                (i==14 & j==7 & k<=12) | (i==1 & j==12 & k<=10) | ...
                                (i==15 & j==1 & k<=8) | (i==8 & j==19 & k<=6)  | ...
                                (i==16 & j==1 & k<=12) | (i==9 & j==19 & k<=4)  | ...
                                (i==3 & j==3 & k<=15) | (i==9 & j==9 & k<=6)  | ...
                                (i==3 & j==20 & k<=20) | (i==20 & j==4 & k<=10) | ...
                                (i==1 & j==1 & k<=2) | (i==8 & j==8 & k<=6) | ...
                                (i==6 & j==14 & k<=3) | (i==6 & j==15 & k<=11)
                            % (i==2 & j==3 & k<=10) | (i==10 & j==10 & k<=7) | ...
                            %     (i==15 & j==16 & k<=5) | (i==2 & j==16 & k<=5) | ...
                            %     (i==17 & j==6 & k<=8) | (i==16 & j==14 & k<=9) | ...
                            %     (i==17 & j==20 & k<=8) | (i==2 & j==8 & k<=11) | ...
                            %     (i==14 & j==7 & k<=12) | (i==1 & j==12 & k<=10) | ...
                            %     (i==15 & j==1 & k<=8) | (i==8 & j==19 & k<=6)
                            this.Obstacles= [this.Obstacles; [i,j,k]];
                            this.Map(i,j,k) = 1;
                        else
                            this.Map(i,j,k) = 0;
                        end
                    end
                end
            end
            % for i = 1:size(this.Obstacles,1)
            %     this.Map(this.Obstacles(i,3)+1, this.Obstacles(i,2)+1, this.Obstacles(i,1)+1) = 1;
            % end
        end

        function [nextobs,reward,isdone,loggedSignals] = step(this,action)
            arguments
                this
                action {mustBeMember(action,[1,2,3,4,5,6])}
            end
            % Step the environment to the next state, given the action
            x = this.Robot.x;
            y = this.Robot.y;
            z = this.Robot.z;

            switch action
                case 1
                    xnew = x+1;
                    ynew = y;
                    znew = z;
                case 2
                    xnew = x-1;
                    ynew = y;
                    znew = z;
                case 3
                    xnew = x;
                    ynew = y+1;
                    znew = z;
                case 4
                    xnew = x;
                    ynew = y-1;
                    znew = z;
                case 5
                    xnew = x;
                    ynew = y;
                    znew = z+1;
                case 6
                    xnew = x;
                    ynew = y;
                    znew = z-1;                    
            end

            % The robot doesn't move if the robot is outside of the map's boundary.
            if znew <= 0 || znew > 19
                znew = z;
            end

            if ynew <= 0 || ynew > 19
                ynew = y;
            end

            if xnew <= 0 || xnew > 19
                xnew = x;
            end

            % The robot doesn't move if new position is occupied by obstacles.
            if this.Map(xnew,ynew,znew) == 1
                znew = z;
                ynew = y;
                xnew = x;
            end

            % Assign new position
            this.Robot.z = znew;
            this.Robot.y = ynew;
            this.Robot.x = xnew;

            nextobs = [this.Robot.x, this.Robot.y, this.Robot.z, this.Goal.x, this.Goal.y, this.Goal.z]';
            reward = myNavigationGoalRewardFcn({this.State}, {action}, {nextobs});
            isdone = myNavigationGoalIsDoneFcn({this.State}, {action}, {nextobs});
            this.State = nextobs;
            this.IsDone = isdone;
            loggedSignals = [];
        end

        function varargout = plot(this)
            % Visualizes the environment
            if isempty(this.Visualizer) || ~isvalid(this.Visualizer)
                this.Visualizer = NavigationDiscreteEnvVisualizer(this);
            else
                bringToFront(this.Visualizer);
            end
            if nargout
                varargout{1} = this.Visualizer;
            end
        end

        function set.State(this,state)
            this.State = state;
            notifyEnvUpdated(this);
        end
    end
end
