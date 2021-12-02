function [sprite1, sprite2] = findSprites(total)
%findSprites Function to return corresponding sprites to display score total
%   Basically it determines which sprites to read from the sprite sheet automatically
%   instead of doing this every time we want to update it we can put it into a function
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

