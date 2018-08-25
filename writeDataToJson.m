function jsonTrial = trialToJson(runNo, fix_durations, mouse_x, mouse_y, fix_x, fix_y)
% Creates the json file given the data provided as arguments. The json file
% is of the following structure

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
% 	}
% }]

%jsonStart = sprintf('[{''subjectNo'' : ''%d'',', subjectNo);
run = sprintf('{ ''run : ''%d''', runNo);
del = sprintf('''delay : ''%f''', delay);
fil = sprintf('''filter: ''%d''', filter);
m_x = strcat('''mouse_x'' : ', mat2str(mouse_x));
m_y = strcat('''mouse_y'' : ', mat2str(mouse_y));
fix_x = strcat('''fix_x'' : ', mat2str(fix_x));
fix_y = strcat('''fix_y'' : ', mat2str(fix_y));
fix_dur = strcat('''fix_durations'' : ', mat2str(fix_durations));
strings = [run del fil m_x m_y fix_x fix_y fix_dur];
jsonTrial = join(strings, ',');
    
    


end



