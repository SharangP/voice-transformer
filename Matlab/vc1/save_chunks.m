function save_chunks(source,filter,fs,num_chunks)
%SAVE_CHUNKS Saves segments of the source and filter files.
%
% SAVE_CHUNKS(source,filter,fs,num_chunks) Breaks the source and filter
% files into num_chunks parts and saves the segments as wavs with sampling
% frequency fs.
%
% By: Matthew Hutchinson
% Created: 12/09/04
% Rice University
% Elec 301 Project

if(length(filter) > length(source)),
    filter = filter(1:length(source));
else
    source = source(1:length(filter)); 
end
source_chunks = sig_chunks(source,num_chunks);
filter_chunks = sig_chunks(filter,num_chunks);
for i = 1:num_chunks,
    wavwrite(source_chunks(i,:),fs,strcat('source/',num2str(i,'%.4d'),'.wav'));
    wavwrite(filter_chunks(i,:),fs,strcat('filter/',num2str(i,'%.4d'),'.wav'));
end
