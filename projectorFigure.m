function varargout = projectorFigure(calibrationFile,projectorFlag,figNum)
% The "projectorFigure" function this function creates a new figure for use
% with the projector.
%
% SYNTAX: TODO: Add syntax
%   figH = projectorFigure(calibrationFile)
%   figH = projectorFigure(calibrationFile,projectorFlag)
%   figH = projectorFigure(calibrationFile,projectorFlag,figNum)
% 
% INPUTS:
%   calibrationFile - (string)
%       Path to projector calibration file.
%
%   projectorFlag - (1x1 logical) [true]
%       If true the figure is created on the projector, if false Matlab's
%       default figure is used and created on the local computer screen.
%
%   figNum - (1x1 positive integer or empty) [next figure number] 
%       Figure number to assign to figure. If empty the next figure number
%       is used.
% 
% OUTPUTS:
%   figH - (1x1 figure handle) 
%       Figure handle to newly created figure
%
% EXAMPLES:
%   projectorFigure('projectorCalData.mat');
%
% NOTES:
%
% NECESSARY FILES:
%
% SEE ALSO:
%    projectorFigCalibrate | figure
%
% AUTHOR:
%    Rowland O'Flaherty (http://rowlandoflaherty.com)
%
% VERSION: 
%   Created 08-APR-2015
%-------------------------------------------------------------------------------

%% Check Inputs

% Check number of inputs
narginchk(1,3)

% Apply default values
if nargin < 2, projectorFlag = true; end
if nargin < 3,
    figNum = numel(get(0,'Children'));
    if figNum == 0
        figNum = 1;
    end
end

% Check input arguments for errors
assert(ischar(calibrationFile) && exist(calibrationFile,'file') == 2,...
    'projectorFigure:calibrationFile',...
    'Input argument "calibrationFile" must be valid path to a calibration file.')

assert(islogical(projectorFlag) && numel(projectorFlag) == 1,...
    'projectorFigure:projectorFlag',...
    'Input argument "projectorFlag" must be a 1x1 logical.')

assert(isnumeric(figNum) && isreal(figNum) && numel(figNum) == 1 && mod(figNum,1) == 0 && figNum > 0,...
    'projectorFigure:figNum',...
    'Input argument "figNum" must be a 1x1 positive integer or [].')

%% Load calibration data
load(calibrationFile)

%% Initialize figure
figH = figure(figNum);
clf(figH)
if projectorFlag
    set(figH,'MenuBar','none')
    set(figH,'Position',projectorFig.position);
end

%% Initialize axis
cla(gca)
set(gca,'NextPlot','add')
axis(gca,'equal')
set(gca,'XLimMode','manual')
set(gca,'YLimMode','manual')
xlim(gca,projectorFig.xLim)
ylim(gca,projectorFig.yLim)

if projectorFlag
    set(gca,'Color','k')
    set(gca,'Position',[0 0 1 1])
    grid(gca,'off')
else
    grid(gca,'on')
    xlabel('x [m]')
    ylabel('y [m]')
end

%% Output
if nargout > 1
    varargout{1} = figH;
end

end
