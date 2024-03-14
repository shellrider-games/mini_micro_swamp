import "qa"

Rivertile = {}

Rivertile.position = {"q" : 0,"r" : 0,"s" : 0}

Rivertile.rotation = 0

Rivertile.connections = [
    false,
    false,
    false,
    false,
    false,
    false]

Rivertile.rotate = function(direction)
    if direction > 0 then
        self.rotation = (self.rotation + 1) % 6
        self.connections = [
            self.connections[1],
            self.connections[2],
            self.connections[3],
            self.connections[4],
            self.connections[5],
            self.connections[0]]
    else
        self.rotation = (self.rotation + 5) % 6
        self.connections = [
            self.connections[5],
            self.connections[0],
            self.connections[1],
            self.connections[2],
            self.connections[3],
            self.connections[4]]
    end if
end function

Rivertile.init = function()
    self.position = {"q" : 0,"r" : 0,"s" : 0}
    self.rotation = 0
    self.connections = [
        false,
        false,
        false,
        false,
        false,
        false]
end function

//Tests

if (globals == locals) then
    print "Testing tile creation"
    testTile = new Rivertile
    testTile.init
    qa.assert(testTile isa Rivertile)
    print "Test passed"
    print "Test rotate(-1)"
    testTile.connections[0] = true
    qa.assertEqual(testTile.connections,[
        true,
        false,
        false,
        false,
        false,
        false])
    testTile.rotate(-1)
    qa.assertEqual(testTile.connections,[
        false,
        false,
        false,
        false,
        false,
        true])
    qa.assertEqual(testTile.rotation, 5)
    print "Test rotate(-1) passed"
    print "Test rotate(1)"
    testTile = new Rivertile
    testTile.init
    testTile.connections[2] = true
    qa.assertEqual(testTile.connections,[
        false,
        false,
        true,
        false,
        false,
        false])
    testTile.rotate(1)
    qa.assertEqual(testTile.connections,[
        false,
        false,
        false,
        true,
        false,
        false])
    qa.assertEqual(testTile.rotation,1)
    print "Test rotate(1) passed"
    print "All tests passed!"
end if