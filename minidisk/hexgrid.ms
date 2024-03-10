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
end if