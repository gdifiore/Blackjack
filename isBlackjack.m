function [blackjackBool] = isBlackjack(hand, debug)
%isBlackjack function that checks if a player/dealer's hand is blackjack
%   Checks if either the card conbination is 10/Ace or Ace/10

    % set variables to hold the first and second cards of input hand
    first_card = hand(1);
    second_card = hand(2);

    % vector to hold card values based on their number
    % e.g. 1 is ace which is worth 11
    DeckValues = [11 2:10 10 10 10 11 2:10 10 10 10 11 2:10 10 10 10 11 2:10 10 10 10];

    % check if the first card is 11 and second card is 10, or first is 10 and second is 11
    if (((DeckValues(first_card) == 11) && (DeckValues(second_card) == 10)) || ((DeckValues(first_card) == 10) && (DeckValues(second_card) == 11)))
        % return true if it is
        blackjackBool = true;
        % if debug is set to true, print out to the terminal
        if debug
            fprintf('[DEBUG] blackjack\n')
        end
    else
        %return false if it isnt
        blackjackBool = false;
        if debug
            fprintf("[DEBUG] not blackjack\n")
        end
    end
end


