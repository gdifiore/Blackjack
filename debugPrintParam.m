function [] = debugPrintParam(message, param, debug)
    %debugPrintParam Print a message if the debug flag is true
%   Some of my debug fprintfs had a parameter, so this deals with that
    if debug == true
        fprintf('[DEBUG] "%s" %i\n', message, param)
    end
end