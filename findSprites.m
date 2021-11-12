function [sprite1, sprite2] = findSprites(total)
%findSprites Function to return corresponding sprites to display score total
%   Detailed explanation goes here
    if total >= 30
        sprite1 = 4;
        sprite2 = total - 29;
    elseif total >= 20
        sprite1 = 3;
        sprite2 = total - 19;
    elseif total >= 10
        sprite1 = 2;
        sprite2 = total - 9;
    else
        sprite1 = 1;
        sprite2 = total + 1;
    end
    
end

