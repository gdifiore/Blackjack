%
% Matlab Blackjack - ENGR 1181 SDP
% Gabriel DiFiore - 2021
%

clc
clear
close all

% create a debug flag to print out extra information if I'm trying to debug something
debug = true;

%% Define game variables

money = 1000;
is_playing = true;
% we have used cards 1-4 at the star, so when we want a new one grab the card at this index 
% (and update as you take a card)
% don't declare this in the loop, otherwise it'll be continually reset
card_index = 5;
% first player either the player/dealer takes will go into index 4
player_hit_index = 4;
player_total = 0;
dealer_take_index = 4;
dealer_total = 0;

% player/dealer_blackjack booleans NOT the same as if they win
player_blackjack = false;
dealer_blackjack = false;

% player/dealer_won booleans
player_won = false;
dealer_won = false;

%% Initialize scene and font sprites
my_scene = simpleGameEngine('retro_cards.png',16,16,8,[255,255,255]);

% Set up variables to name the various sprites
empty_sprite = 1;
blank_card_sprite = 2;
card_back = 3;
card_sprites = 21:72;

number_sprites = 75:84;

% initialize card display vector
card_display = blank_card_sprite * ones(3,8);

% set card values
DeckValues = [11 2:10 10 10 10 11 2:10 10 10 10 11 2:10 10 10 10 11 2:10 10 10 10];

%% Prompt user for information

player_name = input('What is your name? ', 's');

fprintf('Hello, %s welcome to blackjack.\n\n', player_name)
fprintf('Controls:\n')
fprintf('Press space to hit\n')
fprintf('Press s to stand\n')
fprintf('Press l to split your hand\n\n')

while is_playing
    % reset these variables for players who play again
    player_won = false;
    dealer_won = false;

    fprintf('You have $%i dollars\n', money)
    bet_amount = input('How much do you want to bet? ');
    while bet_amount > money
        fprintf('You only have $%f\n', money)
        bet_amount = input('How much do you want to bet? ');
    end

    %% Shuffle cards
    
    ShuffledDeck = randperm(52); % Random permutation of numbers 1 to 52

    %% Dealer Hand
    % use first second 2 cards in deck
    dealer_hand = ShuffledDeck(3:4);
    dealer_blackjack = isBlackjack(dealer_hand, debug);
    for i=1:length(dealer_hand)
        debugPrintParam('Card number is: ', dealer_hand(i), debug)
        if (dealer_hand(i) <= 13)
            debugPrint('heart', debug)
        elseif (dealer_hand(i) <= 26)
            debugPrint('diamond', debug)
        elseif (dealer_hand(i) <= 39)
            debugPrint('clubs', debug)
        elseif (dealer_hand(i) <= 52)
            debugPrint('spades', debug)
        else
            debugPrint('error recognizing card', debug)
        end
        debugPrintParam('Card value: ', DeckValues(dealer_hand(i)), debug)
        if dealer_blackjack
            dealer_score_sprites = findSprites(dealer_total);
            dealer_total = dealer_total + DeckValues(dealer_hand(i));
        else   
            if (((dealer_total + DeckValues(dealer_hand(i))) > 21) && DeckValues(dealer_hand(i)) == 11)
                dealer_total = dealer_total + DeckValues(dealer_hand(i)) - 10;
            else
                dealer_total = dealer_total + DeckValues(dealer_hand(i));
            end 
        end

    end

    %% Player Hand
    % use first 2 cards in deck
    player_hand = ShuffledDeck(1:2);
    player_blackjack = isBlackjack(player_hand, debug);
    for i=1:length(player_hand)
        debugPrintParam('Card number is: ', player_hand(i), debug)
        if (player_hand(i) <= 13)
            debugPrint('heart', debug)
        elseif (player_hand(i) <= 26)
            debugPrint('diamond', debug)
        elseif (player_hand(i) <= 39)
            debugPrint('clubs', debug)
        elseif (player_hand(i) <= 52)
            debugPrint('spades', debug)
        else
            debugPrint('error', debug)
        end
        debugPrintParam('Card value: ', DeckValues(player_hand(i)), debug)

        if player_blackjack
            player_score_sprites = findSprites(player_total);
            player_total = player_total + DeckValues(player_hand(i));
        else   
            if (((player_total + DeckValues(player_hand(i))) > 21) && DeckValues(player_hand(i)) == 11)
                player_total = player_total + DeckValues(player_hand(i)) - 10;
            else
                player_total = player_total + DeckValues(player_hand(i));
            end 
        end
    end

    [score_sprite1, score_sprite2] = findSprites(player_total);
    % The second layer includes the faces of the cards
    % dealer hand on top, player hand on bottom
    face_display = [empty_sprite card_back    card_sprites(dealer_hand(2)) empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite
                    empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite
                    empty_sprite card_sprites(player_hand) empty_sprite empty_sprite empty_sprite number_sprites(score_sprite1) number_sprites(score_sprite2)];
    %size(card_display)
    %size(face_display)
    drawScene(my_scene,card_display,face_display)

    %% Player playing loop
    % while the player still wants to take cards

    % automatically skip player turn if he has blackjack, no point in letting them mis-press a key
    % also, you can only get blackjack when your cards are dealt, so only need to check it once
    stand = player_blackjack;

    while (~stand && ~(player_total > 21))
        key = getKeyboardInput(my_scene);
        while (~isequal(key, 'space') && ~isequal(key, 's') &&  ~isequal(key, 'l'))
            key = getKeyboardInput(my_scene);
        end
        switch key
        case 'space'
            % player wants to hit
            debugPrint('hit', debug)
            new_card = ShuffledDeck(card_index);
            face_display(3, player_hit_index) = card_sprites(new_card);
            if (((player_total + DeckValues(new_card)) > 21) && DeckValues(new_card) == 11)
                player_total = player_total + DeckValues(new_card) - 10;
            else
                player_total = player_total + DeckValues(new_card);
            end
            player_hit_index = player_hit_index + 1;
            card_index = card_index + 1;

            [sprite1, sprite2] = findSprites(player_total);
            face_display(3,7) = number_sprites(sprite1);
            face_display(3,8) = number_sprites(sprite2);

        case 's'
            % player wants to stand
            stand = true;
            debugPrint('stand', debug)
        case 'l'
            % player wants to 
            debugPrint('split', debug)
        end
        drawScene(my_scene,card_display,face_display)
    end
 
    %% Dealer playing loop
    % while the dealer total is < 17 and dealer doesn't have blackjack

    while (dealer_total < 17 && ~dealer_blackjack) && player_total <= 21
        % dealer has to hit
        debugPrint('dealer hits', debug)
        new_card = ShuffledDeck(card_index);
        face_display(1, dealer_take_index) = card_sprites(new_card);
        if (((dealer_total + DeckValues(new_card)) > 21) && DeckValues(new_card) == 11)
            dealer_total = dealer_total + DeckValues(new_card) - 10;
        else
            dealer_total = dealer_total + DeckValues(new_card);
        end
        dealer_take_index = dealer_take_index + 1;
        card_index = card_index + 1;

        drawScene(my_scene,card_display,face_display)
    end

    face_display(1, 2) = card_sprites(dealer_hand(1));

    [sprite1, sprite2] = findSprites(dealer_total);
    face_display(1,7) = number_sprites(sprite1);
    face_display(1,8) = number_sprites(sprite2);

    if (player_total == dealer_total)
        debugPrint('Push', debug)
    elseif (((player_total <= 21) && (player_total > dealer_total)) || (player_blackjack && ~dealer_blackjack))
        debugPrint('Player wins', debug)
        player_won = true;
    elseif (((dealer_total <= 21) && (dealer_total > player_total)) || (dealer_blackjack && ~player_blackjack))
        debugPrint('Dealer wins', debug)
        dealer_won = true;
    elseif ((player_total > 21))
        debugPrint('Dealer wins', debug)
        dealer_won = true;
    elseif (dealer_total > 21 && player_total <= 21)
        debugPrint('Player wins', debug)
        player_won = true;
    else
        debugPrint('wtf', debug)
    end

    drawScene(my_scene,card_display,face_display)

    if player_won
        money = money + bet_amount;
    elseif dealer_won
        money = money - bet_amount;
    end

    fprintf('Do you want to play again? [y]es or [n]o\n')
    key = getKeyboardInput(my_scene);
    while (~isequal(key, 'y') && ~isequal(key, 'n'))
        key = getKeyboardInput(my_scene);
    end

    if isequal(key, 'n')
       is_playing = false; 
       fprintf('Thank you for playing, your ending balance is $%i', money)
    elseif isequal(key, 'y')
        % if play again, reset all variables
        player_won = false;
        dealer_won = false;

        card_index = 5;
    
        player_hit_index = 4;
        player_total = 0;
        dealer_take_index = 4;
        dealer_total = 0;

        player_blackjack = false;
        dealer_blackjack = false;
    end
    
end