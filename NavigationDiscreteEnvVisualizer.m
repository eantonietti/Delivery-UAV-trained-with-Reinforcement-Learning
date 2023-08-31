classdef NavigationDiscreteEnvVisualizer < rl.env.viz.AbstractFigureVisualizer
    % NavigationDiscreteEnvVisualizer

    % Copyright 2023 The MathWorks, Inc.

    methods
        function this = NavigationDiscreteEnvVisualizer(env)
            this = this@rl.env.viz.AbstractFigureVisualizer(env);
        end
    end
    methods (Access = protected)
        function f = buildFigure(this)
            f = figure(...
                'Toolbar','none',...
                'Visible','on',...
                'HandleVisibility','off', ...
                'NumberTitle','off',...
                'Name','Navigation 3D',...
                'MenuBar','none',...
                'CloseRequestFcn',@(~,~)delete(this));
            % if ~strcmp(f.WindowStyle,'docked')
            %     f.Position = [200 100 800 500];
            % end
            ha = gca(f);
            ha.Tag = 'ha';
            ha.XLimMode = 'manual';
            ha.YLimMode = 'manual';
            ha.ZLimMode = 'manual';
            ha.DataAspectRatioMode = 'manual';
            ha.PlotBoxAspectRatioMode = 'manual';

            ha.XLim = [0 21];
            ha.YLim = [0 21];
            ha.ZLim = [0 21];
            set(ha, 'DataAspectRatio',[1,1,1])
        end

        function updatePlot(this)
           
            mapWithRobotandGoal = zeros([size(this.Environment.Map),3]);
            f = this.Figure;
            ha = findobj(f,'Tag','ha');
            img  = findobj(f ,'Tag','img' );
            if isempty(img)
                img = plotTransforms([this.Environment.Robot.x,this.Environment.Robot.y,this.Environment.Robot.z], eul2quat([0,0,0]), "MeshFilePath", "cad.stl");
                hold on
                for i = 1:20
                    for j = 1:20
                        for k = 1:20
                            if  (i==2 & j==3 & k<=10) | (i==10 & j==10 & k<=7) | ...
                                    (i==15 & j==16 & k<=5) | (i==2 & j==16 & k<=5) | ...
                                    (i==17 & j==6 & k<=8) | (i==16 & j==14 & k<=9) | ...
                                    (i==17 & j==19 & k<=3) | (i==2 & j==8 & k<=11) | ...
                                    (i==14 & j==7 & k<=12) | (i==1 & j==12 & k<=10) | ...
                                    (i==15 & j==1 & k<=8) | (i==8 & j==19 & k<=6)  | ...
                                    (i==16 & j==1 & k<=12) | (i==9 & j==19 & k<=4)  | ...
                                    (i==3 & j==3 & k<=15) | (i==9 & j==9 & k<=6)  | ...
                                    (i==3 & j==20 & k<=20) | (i==20 & j==4 & k<=10) | ...
                                    (i==1 & j==1 & k<=2) | (i==8 & j==8 & k<=6) | ...
                                    (i==6 & j==14 & k<=3) | (i==6 & j==15 & k<=11)  
                                color = 'b';
                                mapWithRobotandGoal(i,j,k) = 1;
                                drawCube(i-0.5, j-0.5, k-0.5, color);
                            else
                                color = 'none';
                                mapWithRobotandGoal(i,j,k) = 0;
                            end
                        end
                    end
                end
                % hold on
                % plot3(this.Environment.Goal.x, this.Environment.Goal.y, this.Environment.Goal.z,'o','MarkerFaceColor','g')
                
                ha.XLim = [0 10];
                ha.YLim = [0 10];
                ha.ZLim = [0 10];
                xlabel=('x');
                ylabel=('y');
                zlabel=('z');
                % view(3)
                % image(0,0,mapWithRobotandGoal, 'Parent',ha);
                img.Tag = 'img';
                set(ha, 'DataAspectRatio',[1,1,1])
                set(ha, 'ydir', 'normal' )
            else
                hold on, % me
                img.CData = mapWithRobotandGoal;
            end
            drawnow();
        end
    end
end