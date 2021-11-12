function [total] = aceLogic(cards, total)
%aceLogic function to determine if an ace should be worth 1 or 11 when adding up card total
%   so we're gonna let the other script automatically assume every ace is worth 11, 
%   but we'll call this function after to recalculate the total by changing the value of every ace
    
    card_sprites = 21:72;
    %FOR SOME FUCKIG REASON IT CAN'T DETECT WHICH CARD IS AN ACE
    for i=1:length(cards)
        if (cards(i) == card_sprites(3) || cards(1) == card_sprites(17) || cards(i) == card_sprites(30) || cards(i) == card_sprites(43))
            if total > 21
                fprintf('THERE IS AN ACE')
                % subtract 10 if the total is greater than 21
                % if it's still greater than 21, the main loop will detect that
                total = total - 10;
            end
        end
    end
end

