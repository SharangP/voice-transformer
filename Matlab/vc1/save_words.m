function save_words(source,filter,fs)
%SAVE_WORDS Saves the words of the source and filter files.
%
% SAVE_WORDS(source,filter,fs,num_chunks) Breaks the source and filter
% files into words and saves the segments as wavs with sampling
% frequency fs.
%
% By: Matthew Hutchinson
% Created: 12/09/04
% Rice University
% Elec 301 Project

source_breaks = get_word_breaks(source,fs,0.3);
filter_breaks = get_word_breaks(filter,fs,0.3);
if(length(filter_breaks) > length(source_breaks)),
    filter_breaks = [filter_breaks(1:length(source_breaks)-1),filter_breaks(length(filter_breaks))];
else
    source_breaks = [source_breaks(1:length(filter_breaks)-1),source_breaks(length(source_breaks))];
end

for i = 1:length(filter_breaks)-1,
    filter_word = filter(filter_breaks(i):filter_breaks(i+1));
    source_word = source(source_breaks(i):source_breaks(i+1));
    if(length(filter_word) > length(source_word)),
        filter_word = filter_word(1:length(source_word));
    else
        source_word = source_word(1:length(filter_word)); 
    end
    wavwrite(filter_word,fs,strcat('source/',num2str(i,'%.4d'),'.wav'));
    wavwrite(source_word,fs,strcat('filter/',num2str(i,'%.4d'),'.wav'));
end