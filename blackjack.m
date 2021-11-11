%
% Matlab Blackjack - ENGR 1181 SDP
% Gabriel DiFiore - 2021
%

clc
clear
close all

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

%% Initialize scene
my_scene = simpleGameEngine('retro_cards.png',16,16,8,[255,255,255]);

% Set up variables to name the various sprites
empty_sprite = 1;
blank_card_sprite = 2;
card_sprites = 21:72;

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
    for i=1:length(dealer_hand)
        fprintf("Card number is: %i", dealer_hand(i))
        if (dealer_hand(i) >= 1 && dealer_hand(i) <= 13)
            fprintf("heart\n")
        elseif (dealer_hand(i) >= 14 && dealer_hand(i) <= 26)
            fprintf("diamond\n")
        elseif (dealer_hand(i) >= 27 && dealer_hand(i) <= 39)
            fprintf("clubs\n")
        elseif (dealer_hand(i) >= 40 && dealer_hand(i) <= 52)
            fprintf("spades\n")
        else
            fprintf("error\n")
        end
        fprintf("Card value: %i", DeckValues(dealer_hand(i)))
        dealer_total = dealer_total + DeckValues(dealer_hand(i));
    end

    %% Player Hand
    % use first 2 cards in deck
    player_hand = ShuffledDeck(1:2);
    for i=1:length(player_hand)
        fprintf("Card number is: %i", player_hand(i))
        if (player_hand(i) >= 1 && player_hand(i) <= 13)
            fprintf("heart\n")
        elseif (player_hand(i) >= 14 && player_hand(i) <= 26)
            fprintf("diamond\n")
        elseif (player_hand(i) >= 27 && player_hand(i) <= 39)
            fprintf("clubs\n")
        elseif (player_hand(i) >= 40 && player_hand(i) <= 52)
            fprintf("spades\n")
        else
            fprintf("error\n")
        end
        fprintf("Card value: %i", DeckValues(player_hand(i)))
        player_total = player_total + DeckValues(player_hand(i));
    end

    % The second layer includes the faces of the cards
    % dealer hand on top, player hand on bottom
    face_display = [empty_sprite card_sprites(dealer_hand) empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite
                    empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite
                    empty_sprite card_sprites(player_hand) empty_sprite empty_sprite empty_sprite empty_sprite empty_sprite];
    %size(card_display)
    %size(face_display)
    drawScene(my_scene,card_display,face_display)

    stand = false;

    %% Player playing loop
    % while the player still wants to take cards
    while ~stand && ~(player_total > 21)
        key = getKeyboardInput(my_scene);
        while (~isequal(key, "space") && ~isequal(key, "s") &&  ~isequal(key, "l"))
            key = getKeyboardInput(my_scene);
        end
        switch key
        case "space"
            % player wants to hit
            fprintf('hit')
            new_card = ShuffledDeck(card_index)
            face_display(3, player_hit_index) = card_sprites(new_card);
            player_total = player_total + DeckValues(new_card);
            player_hit_index = player_hit_index + 1;
            card_index = card_index + 1;
        case "s"
            % player wants to stand
            stand = true;
            fprintf('stand')
        case "l"
            % player wants to 
            fprintf('split')
        end
        drawScene(my_scene,card_display,face_display)
    end
 
    %% Dealer playing loop
    % while the dealer total is < 17
    while dealer_total < 17
        % dealer has to hit
        fprintf('dealer hits')
        new_card = ShuffledDeck(card_index)
        face_display(1, dealer_take_index) = card_sprites(new_card);
        dealer_total = dealer_total + DeckValues(new_card);
        dealer_take_index = dealer_take_index + 1;
        card_index = card_index + 1;

        drawScene(my_scene,card_display,face_display)
    end

    if player_total == dealer_total
        fprintf("Push")
    elseif (player_total <= 21) && player_total > dealer_total
        fprintf("Player wins")
    else 
        fprintf("Dealer wins")
    end
end