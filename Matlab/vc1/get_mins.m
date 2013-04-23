function [sig_mins] = get_mins(sig,cutoff,offset)
%GET_MINS Obtains a rough list of minimums in a signal.
%
% GET_MINS(sig,cutoff,offset) Returns a rough list of minimums within a signal portion, sig, with a position
% offset, offset, below a certain cutoff, cutoff.
%
% By: Matthew Hutchinson
% Created: 12/09/04
% Rice University
% Elec 301 Project

if(min(sig)<cutoff)
    if(max(sig)>cutoff)
        [sig1,sig2,new_offset] = split_sig(sig);
        sig_mins = [get_mins(sig1,cutoff,offset);get_mins(sig2,cutoff,offset+new_offset)];
    else
        [x,y] = min(sig);
        sig_mins = y + offset;
    end
else
    sig_mins = 0;
end