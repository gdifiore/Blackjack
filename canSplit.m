function [canSplit] = canSplit(hand)
%canSplit Determines if you can split a hand
%   returns a boolean
    if ((hand(1) == hand(2) - 39 || hand(1) == hand(2) - 26 || hand(1) == hand(2) - 13 || hand(1) == hand(2) + 13 || hand(1) == hand(2) + 26 || hand(1) == hand(2) + 39)) && (length(hand) == 2)
        canSplit = true;
    else
        canSplit = false;
    end
end

