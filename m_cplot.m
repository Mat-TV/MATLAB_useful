function han = m_cplot(varargin)

% M_CPLOT Plot objects on an M_MAP plot.   All of the normal
% Matlab cplot options are available.  NOTE - this isn't exactly
% like cplot as only the first two arguments are actually converted
% to map coords, i.e.:
%
% USAGE: M_CPLOT(LON,LAT,[OPTIONS]) 
%

% Deirdre Byrne, dbyrne@umeoce.maine.edu 00/07/27 (v1.1)
% Matías Troncoso Villar, matro1432@gmail.com 22/05/05
% This software is provided "as is" without warranty of any kind.

global MAP_PROJECTION MAP_VAR_LIST

if isempty(MAP_PROJECTION)
  disp('No Map Projection initialized - call M_PROJ first!');
  return;
end

if nargin < 2
  help m_cplot
  return
end

[x,y] = m_ll2xy(varargin{1},varargin{2});
varargin = varargin(:);
s = size(varargin,1);
h=cplot(x,y,varargin{3:s});

if nargout == 1
  han = h;
end

return
