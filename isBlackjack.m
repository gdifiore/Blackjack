function [blackjackBool] = isBlackjack(hand, debug)
%isBlackjack function that checks if a player/dealer's hand is blackjack
%   Checks if either the card conbination is 10/Ace or Ace/10
    first = hand(1);
    second = hand(2);

    % matlab doesn't let you write multiline if statements so instead there's this 246 column behemoth
    if (((first == 1 || first == 14 || first == 27 || first == 40) && (second == 10 || second == 23 || second == 36 || second == 49)) || ((second == 1 || second == 14 || second == 27 || second == 40) && (first == 10 || first == 23 || first == 36 || first == 49)))
        blackjackBool = true;
        if debug
            fprintf('[DEBUG] blackjack\n')
        end
    else
        blackjackBool = false;
        if debug
            fprintf("[DEBUG] not blackjack\n")
        end
    end
end

