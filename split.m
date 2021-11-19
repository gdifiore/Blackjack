function [] = split(hand)
    %splits sets up a players split hand both
    %   sets up 2 separate hands to 'hit' cards into
    %   sets up display background to show the separate hands
        if (hand(1) == hand(2) - 39 || hand(1) == hand(2) - 26 || hand(1) == hand(2) - 13 || hand(1) == hand(2) + 13 || hand(1) == hand(2) + 26 || hand(1) == hand(2) + 39)
            canSplit = true
        else
            canSplit = false
        end
    end
    
    