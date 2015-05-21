function projectorFigCalibrate(trackableName,host,figPos)
% The "projectorFigCalibrate" function this function calibrates the the
% projector to create figures that have the same coordiates as the
% optitrack data points.
%
% SYNTAX:
%   projectorFigCalibrate(trackableName,host,figPos)
% 
% INPUTS:
%   trackableName - (string) 
%       Name of OptiTrack trackable used for calibration routine. Name must
%       match name assigned in OptiTrack's rigid bodies properties.
%
%   host - (string)
%       IP address or host name of computer running optitrack that is
%       streaming data from the VRPN Streaming Engine.
%
%   figPos - (1 x 4 number)
%       Figure postion values. Recommended procedure to get figure
%       position values is to create a matlab figure, drag it over to the
%       projector screen, maximize it to fit the screen, then get the
%       figure position value with the "get(gcf,'Position')". Use these
%       values for the "figPos" arugment.
%
% EXAMPLES:
%   figure;
%   % Drag figure to projector screen and maximize figure.
%   projectorFigCalibrate('K8','192.168.2.145',get(gcf,'Position'));
%   % Follow instructions on command window.
%
% NOTES:
%
% NECESSARY FILES:
%   +trackable
%
% SEE ALSO:
%    projectorFigCalibrateTest | projectorFigure
%
% AUTHOR:
%    Rowland O'Flaherty (http://rowlandoflaherty.com)
%
% VERSION: 
%   Created 08-APR-2015
%-------------------------------------------------------------------------------

%% Check Inputs

% Check number of inputs
narginchk(3,3)

% Check input arguments for errorss
assert(ischar(trackableName),...
    'projectorFigCalibrate:trackableName',...
    'Input argument "trackableName" must be a string')

assert(ischar(host),...
    'projectorFigCalibrate:host',...
    'Input argument "host" must be a string')

assert(isnumeric(figPos) && isreal(figPos) && isequal(size(figPos),[1 4]),...
    'projectorFigCalibrate:figPos',...
    'Input argument "figPos" must be a 1 x 4 vector of real numbers.')

%% Create trackable
T = trackable.trackable(trackableName,host);
validTrackable = T.init();
assert(validTrackable,...
    'projectorFigCalibrate:trackable',...
    'Trackable data not received for trackable: ''%s'' and host: ''%s''.',trackableName,host)
T.orientationGlobalRotation_ = quaternion([0 0 pi])' * T.orientationGlobalRotation_;
T.update();

%% Create figure
close all
figure(1)
clf(1)
set(1,'MenuBar','none')
set(1,'Position',figPos)
axH = gca;
set(axH,'Position',[0 0 1 1])
set(axH,'XLimMode','manual')
set(axH,'YLimMode','manual')
set(axH,'XLim',[-1 1])
set(axH,'YLim',[-1 1])

%% Splash info
clc
fprintf('+======================================+\n');
fprintf('| Projector Figure Calibration Routine |\n');
fprintf('+======================================+\n');
fprintf('\n');
fprintf('Zoom the projector in until all menus and\n');
fprintf('borders are not visible in the figure,\n');
fprintf('then press ENTER.\n');
pause
fprintf('\n');

%% Get zoom number
zoomNum = nan;
while isnan(zoomNum)
    zoomNumStr = input('How many times did you zoom in? ','s');
    fprintf('\n');
    zoomNum = str2double(zoomNumStr);
    if ~isnumeric(zoomNum) || numel(zoomNum) ~= 1 || mod(zoomNum,1) ~= 0 || zoomNum < 0
        zoomNum = nan;
        fprintf('Invalid entry. Please enter an integer >= 0.\n');
        fprintf('\n');
    end
end

%% Define markers
marker = struct('colorName',{'red','green','blue','yellow'},...
                'color',{'r','g','b','y'},...
                'pos',{[-.5 .5], [.5 .5], [.5 -.5], [-.5 -.5]},...
                'size',43,...
                'coord',nan(2,1));
            
%% Plot markers
nMarkers = numel(marker);
hold(axH,'on')
for i = 1:nMarkers
    mH(i) = hggroup; %#ok<AGROW>
    plot(axH,marker(i).pos(1),marker(i).pos(2),'ok',...
        'MarkerSize',marker(i).size,'MarkerFaceColor',marker(i).color,'Parent',mH(i))
    plot(axH,marker(i).pos(1),marker(i).pos(2),'ok',...
        'MarkerSize',10,'MarkerFaceColor','k','Parent',mH(i))
    set(mH(i),'Visible','off');
end
hold(axH,'off')

%% Get marker coordinates
for i = 1:nMarkers;
    set(mH(i),'Visible','on');
    fprintf('Move trackable to %s marker,             \n',upper(marker(i).colorName));
    fprintf('then press ENTER.\n');
    pause
    T.update
    marker(i).coord = T.position(1:2);
    fprintf('%s marker coordinates: x = %2.3f y = %2.3f\n',...
        upper(marker(i).colorName),marker(i).coord(1), marker(i).coord(2));
    fprintf('\n');
    set(mH(i),'Visible','off');
end

%% Calc axes limits
c = [marker([1 4]).coord];
x(1) = mean(c(1,:));

c = [marker([2 3]).coord];
x(2) = mean(c(1,:));

c = [marker([3 4]).coord];
y(1) = mean(c(2,:));

c = [marker([1 2]).coord];
y(2) = mean(c(2,:));

xLim = [x(1) - (x(2) - x(1))/2, x(1) + 3/2*(x(2) - x(1))];
yLim = [y(1) - (y(2) - y(1))/2, y(1) + 3/2*(y(2) - y(1))];

fprintf('Figure XLim: [%2.4f, %2.4f]\n', xLim(1), xLim(2));
fprintf('Figure YLim: [%2.4f, %2.4f]\n', yLim(1), yLim(2));
fprintf('\n');

%% File struct
projectorFig.xLim = xLim;
projectorFig.yLim = yLim;
projectorFig.marker = marker;
projectorFig.position = figPos;
projectorFig.zoomNum = zoomNum; %#ok<STRNU>

%% Save figure limits
calibrationFileName = 'projectorFigCalData.mat';
save(calibrationFileName,'projectorFig')
fprintf('Calibration file saved to:\n%s\n',fullfile(pwd,calibrationFileName));
fprintf('\n');

%% Set figure limits and replot
cla(axH)
set(axH,'XLim',xLim)
set(axH,'YLim',yLim)

hold(axH,'on')
for i = 1:nMarkers
    plot(axH,marker(i).coord(1),marker(i).coord(2),'ok',...
        'MarkerSize',marker(i).size,'MarkerFaceColor',marker(i).color)
end
hold(axH,'off')

%% Test info
fprintf('Run "projectorFigCalibrateTest(''%s'',''%s'',''%s'');"\n',trackableName,host,calibrationFileName);
fprintf('function to test calibration.\n\n');

end
