function convert_voice(source_file,filter_file,numwin)
%CONVERT_VOICE Coverts the voice of the source to that of the filter.
%
% CONVERT_VOICE(source_file,filter_file,numwin) Converts the voice of the source 
% speech segment to that of the filter. It takes two strings: the filename 
% of the source to convert, source_file, and the filename of the filter to 
% convert it to, filter_file. It segments the wavs into numwin parts and then 
% saves the source and filter files as waves in their respective folders.
%
% By: Matthew Hutchinson
% Created: 12/09/04
% Rice University
% Elec 301 Project

% Clear out the directories
[s,m,mid] = mkdir('source');
[s,m,mid] = mkdir('filter');
cd source;
delete *.wav;
cd ../filter;
delete *.wav;
cd ..;

% Load the wavs
[source,fs] = load_wav(source_file);
[filter,fs] = load_wav(filter_file);

% Window the wavs according to the arguments
if(nargin < 3),
    save_words(source,filter,fs);
else
    save_chunks(source,filter,fs,numwin);
end