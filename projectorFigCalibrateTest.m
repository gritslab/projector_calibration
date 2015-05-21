function projectorFigCalibrateTest(trackableName,host,calibrationFile)
% The "projectorFigCalibrateTest" function test the projector figure
% calibration. Move the trackable object around and the circle on the
% ground should project right on top of it. If it does not, run the
% projector figure calibration function again.
%
% SYNTAX: TODO: Add syntax
%   output = projectorFigCalibrateTest(trackableName,host,calibrationFile)
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
%   calibrationFile - (string)
%       Path to projector calibration file.
%
% EXAMPLES:
%   projectorFigCalibrateTest('K8','192.168.2.145','projectorCalData.mat');
%
% NOTES:
%
% NECESSARY FILES:
%   +trackable, projectorFigure.m
%
% SEE ALSO:
%    projectorFigCalibrate | projectorFigure
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
    'projectorFigCalibrateTest:trackableName',...
    'Input argument "trackableName" must be a string')

assert(ischar(host),...
    'projectorFigCalibrateTest:host',...
    'Input argument "host" must be a string')

assert(ischar(calibrationFile) && exist(calibrationFile,'file') == 2,...
    'projectorFigCalibrateTest:calibrationFile',...
    'Input argument "calibrationFile" must be valid path to a calibration file.')

%% Splash info
clc
fprintf('+===========================================+\n');
fprintf('| Projector Figure Calibration Test Routine |\n');
fprintf('+===========================================+\n');
fprintf('\n');
fprintf('Testing calibration file:\n%s\n',calibrationFile);
fprintf('\n');
fprintf('Move trackable object around.\n');
fprintf('The circle on floor should follow it.\n');
fprintf('If it does not follow it,\n');
fprintf('re-run the "projectorFigCalibrate" function.\n');
fprintf('\n');
fprintf('Press ctrl-c to stop test program.');

%% Create figure
close all
projectorFigure(calibrationFile);

%% Create trackable
T = trackable.trackable(trackableName,host);
T.init();
T.orientationGlobalRotation_ = quaternion([0 0 pi])' * T.orientationGlobalRotation_;
T.update();

%% Initialize circle
lineH = plot(T.position(1),T.position(2),'o','MarkerSize',85,'MarkerFaceColor','w');
drawnow;

%% Follow
while 1
    T.update();
    lineH.XData = T.position(1);
    lineH.YData = T.position(2);
   	pause(.001);
end

end
