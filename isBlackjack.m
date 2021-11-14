function [blackjackBool] = isBlackjack(hand, debug)
%isBlackjack function that checks if a player/dealer's hand is blackjack
%   Checks if either the card conbination is 10/Ace or Ace/10
    first = hand(1);
    second = hand(2);

    DeckValues = [11 2:10 10 10 10 11 2:10 10 10 10 11 2:10 10 10 10 11 2:10 10 10 10];

    % matlab doesn't let you write multiline if statements so instead there's this 246 column behemoth
    if (((DeckValues(first) == 11) && (DeckValues(second) == 10)) || ((DeckValues(first) == 10) && (DeckValues(second) == 11)))
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

