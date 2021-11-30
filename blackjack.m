%
% Matlab Blackjack - ENGR 1181 SDP
% Gabriel DiFiore - 2021
%

%
% I wish I knew matlab had classes before I made this
%


% add double down
% add insurance if dealer faceup is an ace
% add surrender

clc
clear
close all

% create a debug flag to print out extra information if I'm trying to debug something
debug = false;

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

doubled_down = false;
insured = false;

% player/dealer_blackjack booleans NOT the same as if they win
player_blackjack = false;
dealer_blackjack = false;

% player/dealer_won booleans
player_won = false;
dealer_won = false;

% boolean to determine if an ace was subtracted from the first 2 cards in a hand
% needed for if you hit, need to determine if the aces value was already subtracted
sub_ace_dealer = false;
sub_ace_player = false;

% variables needed for splitting hand
% location to add new card for left/right hand
left_hit_index = 4;
right_hit_index = 8;
left_total = 0;
right_total = 0;
left_stand = false;
right_stand = false;
left_blackjack = false;
right_blackjack = false;

%% Initialize scene and font sprites
my_scene = simpleGameEngine('retro_cards.png',16,16,8,[255,255,255]);

% Set up variables to name the various sprites
empty_sprite = 1;
blank_card_sprite = 2;
card_back = 3;
card_sprites = 21:72;

number_sprites = 75:84;

% initialize card display vector
card_display = blank_card_sprite * ones(5,11);

% set card values
DeckValues = [11 2:10 10 10 10 11 2:10 10 10 10 11 2:10 10 10 10 11 2:10 10 10 10];

%% Prompt user for information

player_name = input('What is your name? ', 's');

fprintf('Hello, %s welcome to blackjack.\n\n', player_name)
fprintf('Controls:\n')
fprintf('Press space to hit\n')
fprintf('Press p to split (if able)\n')
fprintf('Press s to stand\n')
fprintf('Press u to surrender\n')
fprintf('Press i to insure your hand\n')
fprintf('Press d to double down on your bet\n')

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

        debugPrintParam('Card value: ', DeckValues(dealer_hand(i)), debug)

        dealer_total = dealer_total + DeckValues(dealer_hand(i));
    end

    % if dealer total is greater than 21, and one of the cards is an ace, subtract 10 so the ace is technically worth 1
    for i=1:length(dealer_hand)
        if dealer_total > 21 && DeckValues(dealer_hand(i)) == 11
           dealer_total = dealer_total - 10; 
           sub_ace_dealer = true;
        end
    end

    %% Player Hand
    % use first 2 cards in deck
    player_hand = ShuffledDeck(1:2);
    player_blackjack = isBlackjack(player_hand, debug);
    for i=1:length(player_hand)
        debugPrintParam('Card number is: ', player_hand(i), debug)

        debugPrintParam('Card value: ', DeckValues(player_hand(i)), debug)

        player_total = player_total + DeckValues(player_hand(i));
    end

    for i=1:length(player_hand)
        if player_total > 21 && DeckValues(player_hand(i)) == 11
            player_total = player_total - 10; 
            sub_ace_player = true;
        end
    end


    [score_sprite1, score_sprite2] = findSprites(player_total);
    % The second layer includes the faces of the cards
    % dealer hand on top, player hand on bottom
    face_display = [empty_sprite card_back    card_sprites(dealer_hand(2)) empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite
                    empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite
                    empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite
                    empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite number_sprites(score_sprite1) number_sprites(score_sprite2)
                    empty_sprite card_sprites(player_hand(1)) card_sprites(player_hand(2)) empty_sprite empty_sprite empty_sprite  empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite];
    %size(card_display)
    %size(face_display)
    drawScene(my_scene,card_display,face_display)

    %% Player playing loop
    % while the player still wants to take cards

    % automatically skip player turn if he has blackjack, no point in letting them mis-press a key
    % also, you can only get blackjack when your cards are dealt, so only need to check it once
    stand = player_blackjack;

    while ((~stand && ~(player_total > 21)) && ~left_stand && ~right_stand)
        % get player input for if they want to hit or stand
        key = getKeyboardInput(my_scene);
        while (~isequal(key, 'space') && ~isequal(key, 's') && ~isequal(key, 'p') && ~isequal(key, 'i') && ~isequal(key, 'd') && ~isequal(key, 'u'))
            key = getKeyboardInput(my_scene);
        end

        % switch statement based on key input
        switch key
        case 'space'
            % player wants to hit
            debugPrint('hit', debug)
            new_card = ShuffledDeck(card_index);
            debugPrintParam('Card number is: ', new_card, debug)
            debugPrintParam('Card value: ', DeckValues(new_card), debug)
            face_display(5, player_hit_index) = card_sprites(new_card);

            player_hand(end + 1) = new_card;

            player_total = player_total + DeckValues(new_card);

            if player_total > 21
                debugPrint('player_total bigger than 21', debug)
                % only need to check from 3rd card if one of the first 2 aces already had their value changed
                if sub_ace_player
                    for i=(player_hit_index - 1):length(player_hand)
                        if player_total > 21 && DeckValues(player_hand(i)) == 11
                            debugPrint('new ace, subtracting', debug)
                            player_total = player_total - 10; 
                        end
                    end
                else
                    for i=1:length(player_hand)
                        if player_total > 21 && DeckValues(player_hand(i)) == 11
                            debugPrint('starting from beginning, ace found', debug)
                            player_total = player_total - 10;
                            sub_ace_player = true;
                        end
                    end
                end
            end

            player_hit_index = player_hit_index + 1;
            card_index = card_index + 1;

            [sprite1, sprite2] = findSprites(player_total);
            face_display(4,10) = number_sprites(sprite1);
            face_display(4,11) = number_sprites(sprite2);
        case 'i'
            if DeckValues(dealer_hand(2)) == 11 && ~insured
                debugPrint('Insured hand', debug)
                bet_amount = bet_amount / 2;
                insured = true;
            end
        case 'd'
            if ~doubled_down
                debugPrint('Doubled down', debug)
                bet_amount = bet_amount * 2;
                doubled_down = true;
            end
        case 'u'
            % end players turn by setting stand to true
            stand = true;
        case 'p'
            % split logic
            player_total = 0;
            if canSplit(player_hand) && ((money - (bet_amount * 2)) >= 0)
                bet_amount = bet_amount * 2;
                debugPrint('splitting', debug)
                face_display = [empty_sprite card_back    card_sprites(dealer_hand(2)) empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite
                    empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite
                    empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite
                    empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite number_sprites(score_sprite1) number_sprites(score_sprite2)
                    empty_sprite empty_sprite empty_sprite empty_sprite card_sprites(player_hand(1)) empty_sprite card_sprites(player_hand(2)) empty_sprite empty_sprite empty_sprite empty_sprite];
                 drawScene(my_scene,card_display,face_display)

                left_hand = [player_hand(1)];
                right_hand = [player_hand(2)];
                left_total = DeckValues(player_hand(1));
                right_total = DeckValues(player_hand(2));
                
                while (~left_stand)
                    % take cards for left hand
                    key = getKeyboardInput(my_scene);
                    while (~isequal(key, 'space') && ~isequal(key, 's'))
                        key = getKeyboardInput(my_scene);
                    end

                    switch key
                    case 'space'
                        % player wants to hit
                        debugPrint('hit left', debug)
                        new_card = ShuffledDeck(card_index);
                        debugPrintParam('Card number is: ', new_card, debug)
                        debugPrintParam('Card value: ', DeckValues(new_card), debug)
                        face_display(5, left_hit_index) = card_sprites(new_card);

                        left_hand(end + 1) = new_card;

                        left_total = left_total + DeckValues(new_card);

                        if left_total > 21
                            debugPrint('player_total bigger than 21', debug)
                            % only need to check from 3rd card if one of the first 2 aces already had their value changed
                            for i=1:length(left_hand)
                                if left_total > 21 && DeckValues(left_hand(i)) == 11
                                    debugPrint('starting from beginning, ace found', debug)
                                    left_total = left_total - 10;
                                end
                            end
                        end

                        if isBlackjack(left_hand, debug) || left_total > 21
                            left_stand = true;
                        end

                        left_hit_index = left_hit_index - 1;
                        card_index = card_index + 1;

                        [sprite1, sprite2] = findSprites(left_total);
                        face_display(4,1) = number_sprites(sprite1);
                        face_display(4,2) = number_sprites(sprite2);
                        drawScene(my_scene,card_display,face_display)
                    case 's'
                        % player wants to stand on their left hand
                        debugPrint('stand left hand', debug)
                        left_stand = true;
                    end
                end

                while ~right_stand
                    % take cards for right hand
                    key = getKeyboardInput(my_scene);
                    while (~isequal(key, 'space') && ~isequal(key, 's'))
                        key = getKeyboardInput(my_scene);
                    end

                    switch key
                    case 'space'
                        % player wants to hit
                        debugPrint('hit right', debug)
                        new_card = ShuffledDeck(card_index);
                        debugPrintParam('Card number is: ', new_card, debug)
                        debugPrintParam('Card value: ', DeckValues(new_card), debug)
                        face_display(5, right_hit_index) = card_sprites(new_card);

                        right_hand(end + 1) = new_card;

                        right_total = right_total + DeckValues(new_card);

                        if right_total > 21
                            debugPrint('player_total bigger than 21', debug)
                            % only need to check from 3rd card if one of the first 2 aces already had their value changed
                            for i=1:length(right_hand)
                                if right_total > 21 && DeckValues(right_hand(i)) == 11
                                    debugPrint('starting from beginning, ace found', debug)
                                    right_total = right_total - 10;
                                end
                            end
                        end

                        if isBlackjack(right_hand, debug) || right_total > 21
                            right_stand = true;
                        end

                        right_hit_index = right_hit_index + 1;
                        card_index = card_index + 1;

                        [sprite1, sprite2] = findSprites(right_total);
                        face_display(4,10) = number_sprites(sprite1);
                        face_display(4,11) = number_sprites(sprite2);
                        drawScene(my_scene,card_display,face_display)
                        debugPrint('HIT RIGHT FINISHED', debug)
                    case 's'
                        % player wants to stand on their right hand
                        debugPrint('stand right hand', debug)
                        right_stand = true;
                    end
                end
            end
        case 's'
            % player wants to stand
            stand = true;
            debugPrint('stand', debug)
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

        dealer_hand(end + 1) = new_card;

        dealer_total = dealer_total + DeckValues(new_card);

        if dealer_total > 21
            debugPrint('dealer_total bigger than 21', debug)
            % only need to check from 3rd card if one of the first 2 aces already had their value changed
            if sub_ace_dealer
                for i=(dealer_take_index - 1):length(dealer_hand)
                    if dealer_total > 21 && DeckValues(dealer_hand(i)) == 11
                        debugPrint('new ace, subtracting', debug)
                        dealer_total = dealer_total - 10; 
                    end
                end
            else
                for i=1:length(dealer_hand)
                    if dealer_total > 21 && DeckValues(dealer_hand(i)) == 11
                        debugPrint('starting from beginning, ace found', debug)
                        dealer_total = dealer_total - 10;
                        sub_ace_dealer = true;
                    end
                end
            end
        end

        dealer_take_index = dealer_take_index + 1;
        card_index = card_index + 1;

        drawScene(my_scene,card_display,face_display)
    end

    face_display(1, 2) = card_sprites(dealer_hand(1));

    [sprite1, sprite2] = findSprites(dealer_total);
    face_display(2,10) = number_sprites(sprite1);
    face_display(2,11) = number_sprites(sprite2);

    if (left_total > 0) 
        debugPrintParam('Player left total: ', left_total, debug)
        debugPrintParam('Player right total: ', right_total, debug)
        debugPrintParam('Dealer total: ', dealer_total, debug)
    else
        debugPrintParam('Player total: ', player_total, debug)
        debugPrintParam('Dealer total: ', dealer_total, debug)
    end

    if (dealer_blackjack && ~player_blackjack)
        fprintf('Dealer wins\n')
        debugPrint('Dealer wins', debug)
        dealer_won = true;
    elseif (player_blackjack && ~dealer_blackjack)
        fprintf('Player wins!\n')
        debugPrint('Player wins', debug)
        player_won = true;        
    elseif ((player_total == dealer_total) && ~(player_total > 21) && ~(dealer_total > 21) || (dealer_blackjack && player_blackjack))
        fprintf('Push - no winner\n')
        debugPrint('Push', debug)
    elseif (((player_total <= 21) && (player_total > dealer_total)) || (player_blackjack && ~dealer_blackjack) || left_blackjack || right_blackjack)
        fprintf('Player wins!\n')
        debugPrint('Player wins', debug)
        player_won = true;
    elseif (((dealer_total <= 21) && (dealer_total > player_total)) || (dealer_blackjack && ~player_blackjack) || (left_total > 21 && right_total > 21))
        fprintf('Dealer wins\n')
        debugPrint('Dealer wins', debug)
        dealer_won = true;
    elseif ((player_total > 21) || (left_total > 21 && right_total > 21))
        fprintf('Dealer wins\n')
        debugPrint('Dealer wins', debug)
        dealer_won = true;
    elseif ((dealer_total > 21 && player_total <= 21) || (dealer_total > 21 && (left_total < 21 && right_total < 21)))
        fprintf('Player wins!\n')
        debugPrint('Player wins', debug)
        player_won = true;
    else
        debugPrint('wtf', debug)
    end

    drawScene(my_scene,card_display,face_display)

    if player_won
        if player_blackjack
            money = money + bet_amount + (bet_amount * 1.5);
        else
            money = money + (bet_amount * 2);
        end
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
       fprintf('Thank you for playing, your ending balance is $%i\n\n', money)
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

        sub_ace_player = false;
        sub_ace_dealer = false;

        left_hit_index = 4;
        right_hit_index = 8;
        left_total = 0;
        right_total = 0;
        left_stand = false;
        right_stand = false;
        left_blackjack = false;
        right_blackjack = false;
    end
    
end 