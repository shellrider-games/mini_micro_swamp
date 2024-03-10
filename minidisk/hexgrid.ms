import "qa"

cubeToOddq = function(q, r)
    offsetCoord = {"col" : q, "row" : r + (q - (q % 2))/2}
    return offsetCoord
end function

oddqToCube = function(col, row)
    cubeCoord = {}
    cubeCoord.q = col
    cubeCoord.r = row - (col - (col % 2))/2
    cubeCoord.s = -cubeCoord.q - cubeCoord.r //{"q" : col, "r" : row - (col - (col % 2))/2, "s" : -col-row}
    return cubeCoord
end function

cubeRound = function(q, r, s)
    roundedQ = round(q)
    roundedR = round(r)
    roundedS = round(s)

    qDiff = abs(roundedQ - q)
    rDiff = abs(roundedR - r)
    sDiff = abs(roundedS - s)

    if qDiff > rDiff and qDiff > sDiff then
        roundedQ = -roundedR-roundedS
    else if rDiff > sDiff then
        roundedR = -roundedQ-roundedS
    else
        roundedS = -roundedQ-roundedR
    end if
    return {"q": roundedQ, "r": roundedR, "s" : roundedS}    
end function

pointToHexOddq = function(position, size)
    q = (2/3 * position.x) / size
    r = (-1/3 * position.x + sqrt(3)/3 * position.y) / size
    s = -q-r
    rounded = cubeRound(q,r,s)
    return cubeToOddq(rounded.q, rounded.r)
end function

if (globals == locals) then
    print "Testing cubeToOddq ..."
    qa.assertEqual(cubeToOddq(0,0), {"col":0, "row": 0})
    qa.assertEqual(cubeToOddq(1,0), {"col":1, "row": 0})
    qa.assertEqual(cubeToOddq(2, -1), {"col": 2, "row": 0})
    print "All tests for cubeToOddq passed!"
    print "Testing oddqToCube ..."
    qa.assertEqual(oddqToCube(0,0), {"q":0,"r":0,"s":0})
    qa.assertEqual(oddqToCube(1,0), {"q":1,"r":0,"s":-1})
    qa.assertEqual(oddqToCube(2,0), {"q":2,"r":-1,"s":-1})
    print "All tests for oddqToCube passed!"
    print "Testing cubeRound"
    qa.assertEqual(cubeRound(1,0,-1), {"q":1,"r":0,"s": -1})
    qa.assertEqual(cubeRound(1.1,0,-1.1), {"q":1,"r":0,"s": -1})
    qa.assertEqual(cubeRound(1.5,0,-1.5), {"q":2,"r":0,"s": -2})
    qa.assertEqual(cubeRound(1.8,0,-1.8), {"q":2,"r":0,"s": -2})
    qa.assertEqual(cubeRound(1.5,0,-1.5), {"q":2,"r":0,"s": -2})
    qa.assertEqual(cubeRound(1.1,1.1,-2.2), {"q":1,"r":1,"s": -2})
    print "All tests for cubeRound passed!"
end if