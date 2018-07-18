function jsonTrial = trialToJson(trial, delay, filter, image, mouseX, mouseY, fixX, fixY)
% Structure of json
% [{
% 	'subjectNo' : '',
% 	'trials'	:	
% 	{
% 	'run' : 	'',
% 	'delay'		: '',
% 	'filter'	: '',
% 	'mouse_x' : [],
% 	'mouse_y' : [],
% 	'fix_x'	  : [],
% 	'fix_y'	  : []
% 	},
% 	{
% 	'run' : 	'',
% 	'delay'		: '',
% 	'filter'	: '',
% 	'mouse_x' : [],
% 	'mouse_y' : [],
% 	'fix_x'	  : [],
% 	'fix_y'	  : []
% 	}, ...
% }]
tr = sprintf('{ "run" : "%d",', trial);
del = sprintf('"delay" : "%f",', delay);
fil = sprintf('"filter" : "%d",', filter);
im = sprintf('"image" : "%d",', image);
m_x = ['"mouse_x" : ' '"' mat2str(mouseX) '"'];
m_y = [',"mouse_y" : ' '"' mat2str(mouseY) '"'];
fixX = [',"fix_x" : ' '"' mat2str(fixX) '"'];
fixY = [',"fix_y" : ' '"' mat2str(fixY) '"'];
jsonTrial = [tr del fil im m_x m_y fixX fixY '}'];
end
