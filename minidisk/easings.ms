outBack = function(t)
    c1 = 1.70158
    c3 = c1 + 1;
    return 1 + c3 * (t-1)^3 + c1 * (t-1)^2
end function

outQuint = function(t)
    return 1 - (1-t)^5
end function