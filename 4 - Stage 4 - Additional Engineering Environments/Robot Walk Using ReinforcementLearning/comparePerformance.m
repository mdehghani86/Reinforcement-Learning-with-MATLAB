function comparePerformance(varargin)
% This function takes in string as argument {'DDPGAgent','TD3Agent','SACAgent'}
% and plots the performance comparisons between those respective agents.
%
% Note:
% 1) Make sure that different agents that need to be compared have their
% respective folders with files from different runs.
% 2) Names of the folder need to be passed in as arguments to
% 'comparePerformance' function.
%
% Walking Robot -- Comparison Script
% Copyright 2019 The MathWorks, Inc.

%% Process data for each agent
for i = 1:nargin
    agent(i) = processData(varargin{i});
end

%% Plot mean and standard deviation of average reward values and mean of Episode Q0
figureH = figure('Name','Learning Curve');
axH = axes(figureH);
figureH1 = figure('Name','Episode Q0');
axH1 = axes(figureH1);

for i = 1:length(agent)
    episodeIndex = agent(i).EpisodeIndex;
    meanAverageReward = agent(i).meanAverageReward;
    stdAverageReward = 0.5*agent(i).stdAverageReward;
    meanEpisodeQ0 = agent(i).meanEpisodeQ0;
    stdEpisodeQ0 = 0.5*agent(i).stdEpisodeQ0;
    AvgQ0H = plot(axH1, episodeIndex, meanEpisodeQ0,'DisplayName',varargin{i},'LineWidth',2); % plot mean of Episode Q0
    AvgQ0Color = get(AvgQ0H, 'Color');
    hold(axH1,'on');
    AvgRwdH = plot(axH,episodeIndex, meanAverageReward,'DisplayName',varargin{i},'LineWidth',2); % plot mean of average reward
    AvgRwdColor = get(AvgRwdH, 'Color');
    hold(axH,'on');
    % Arrange data for shading standard deviation
    x = [episodeIndex; flipud(episodeIndex)]; % flipud flips the data from down to up
    y = [meanAverageReward + stdAverageReward; flipud(meanAverageReward - stdAverageReward)];
    fill(axH,x, y ,0.99*AvgRwdColor, 'EdgeAlpha', 0, 'FaceAlpha', 0.4, 'HandleVisibility','off'); % plot standard deviation
    
    y1 = [meanEpisodeQ0 + stdEpisodeQ0; flipud(meanEpisodeQ0 - stdEpisodeQ0)];
    fill(axH1,x, y1 ,0.99*AvgQ0Color, 'EdgeAlpha', 0, 'FaceAlpha', 0.4, 'HandleVisibility','off'); % plot standard deviation
end

title(axH,'Learning curve comparison','FontSize',12)
title(axH1,'Episode Q0 comparison','FontSize',12)

numAxes = [axH,axH1];
for i= 1:length(numAxes)
    grid(numAxes(i),'on');
    xlabel(numAxes(i),'Episode Number')
    ylabel(numAxes(i),'Episode Reward')
    
    lgd = legend(numAxes(i),'Location','southeast','FontSize',10);
    title(lgd,'AGENTS');
    legend(numAxes(i),'boxoff');
end
end

function agent = processData(folderName)
% Extract and process data from the saved agent files within specific agent
% folder.
% This function extracts and calculates mean of average reward 
% from all the runs and saves it within agent structure.
% 
% Walking Robot -- Process data helper Script
% Copyright 2019 The MathWorks, Inc.

% Extract information about all files within the folder 'folderName'
files = dir(folderName);
addpath(folderName); % Add folder to path
files(1:2) = []; % Remove . and .., that automatically gets listed along with filenames

% Consolidate average reward values and Episode Index from different runs
for i = 1:size(files,1)
    S = load(files(i).name,'savedAgentResultStruct');
        agent.averageReward(:,i) = S.savedAgentResultStruct.TrainingStats.AverageReward;
        agent.EpisodeQ0(:,i) = S.savedAgentResultStruct.TrainingStats.EpisodeQ0;
        agent.EpisodeIndex = S.savedAgentResultStruct.TrainingStats.EpisodeIndex;
        agent.ElapsedTime = S.savedAgentResultStruct.Information.ElapsedTime;
end

% Calculate mean and std of average reward
agent.meanAverageReward = mean(agent.averageReward,2);
agent.stdAverageReward = std(agent.averageReward,0,2);
agent.meanEpisodeQ0 = mean(agent.EpisodeQ0,2);
agent.stdEpisodeQ0 = std(agent.EpisodeQ0,0,2);
% Remove folder from path
rmpath(folderName);
end