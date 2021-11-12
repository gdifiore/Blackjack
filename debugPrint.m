function [] = debugPrint(message, debug)
%debugPrint Print a message if the debug flag is true
%   Instead of writing an if/end statement every time I want to check for debug, this makes 
%   what was a 3 line process, much simpler

    if debug == true
        fprintf('[DEBUG] "%s"\n', message)
    end
end