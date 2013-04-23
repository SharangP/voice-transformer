function [word_breaks] = get_word_breaks(sig,fs,threshold)
%GET_WORD_BREAKS Gets the position of the spaces in the speech signal.
%
% GET_WORD_BREAKS(sig,fs,threshold) Finds word breaks in the signal sig.
% It takes the sampling frequency of the signal and a threshold by which 
% to determine breaks in the signal. It returns a list of possible
% word breaks.
%
% By: Matthew Hutchinson
% Created: 12/09/04
% Rice University
% Elec 301 Project

sig_contour = smooth(abs(sig),2000); % Smoothed signal
cutoff = threshold * max(sig_contour); % Cutoff region for minimums
possible_mins = get_mins(sig_contour,cutoff,0); % Rough list of possible minimums

% Remove zero-chains and find minimums of non-zero chains
mins = 0;
i = 1;
while (i < length(possible_mins)),
    if(possible_mins(i) > 0),
        temp_min_pos = possible_mins(i);
        temp_min_val = sig_contour(possible_mins(i));
        for j = i:length(possible_mins),
            if(possible_mins(j) == 0),
                [min_val, min_index] = min(temp_min_val);
                mins = [mins, temp_min_pos(min_index)];
                i = j;
                break;
            else
                temp_min_pos = [temp_min_pos, possible_mins(j)];
                temp_min_val = [temp_min_val, sig_contour(possible_mins(j))];
            end
        end
    end
    i = i + 1;
end

% Refine minimums using a minimum word length of 5ms
word_length = 0.05*fs;
word_breaks = [];
temp_break_pos = 0;
temp_break_val = Inf;
for i = 2:length(mins),
    if((mins(i) - mins(i-1)) < word_length),
        temp_break_pos = [temp_break_pos, mins(i)];
        temp_break_val = [temp_break_val, sig_contour(mins(i))];
    else
        if(min(temp_break_val) < Inf),
            [break_val, break_index] = min(temp_break_val);
            word_breaks = [word_breaks, temp_break_pos(break_index)];
        end
        temp_break_pos = mins(i);
        temp_break_val = sig_contour(mins(i));
    end
end

% Append the end of the signal
word_breaks = [word_breaks, length(sig)];