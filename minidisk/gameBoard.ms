import "qa"
import "rivertile"
import "hexgrid"

GameBoard = {}

GameBoard.tiles = []
GameBoard.mapCols = 18
GameBoard.mapRows = 10

GameBoard.init = function()
    self.tiles = []
end function

GameBoard.tileOnBoardAndFree = function(tile)
    for entry in self.tiles
        if entry.position == tile.position then return false
    end for

    oddQPos = hexgrid.cubeToOddq(tile.position.q,tile.position.r)
    if(oddQPos.col >= 0 and oddQPos.col <= self.mapCols and oddQPos.row >= 0 and oddQPos.row <= self.mapRows - oddQPos.col % 2) then return true
    return false
end function

GameBoard.adjacentConnections = function(tile)
    adjConnections = [0,0,0,0,0,0]
    posAround = hexgrid.allCubeCoordNeighbours(tile.position)
    for element in posAround
        adjTile = self.getTile(element)
        if adjTile == null then continue

        dir = {"q" : tile.position.q - element.q,
                "r" : tile.position.r - element.r,
                "s" : tile.position.s - element.s}

        if dir.q == 0 and dir.r == -1 then
            if adjTile.connections[3] then
                adjConnections[0] = 1
            else
                adjConnections[0] = 2
            end if
        else if dir.q == 1 and dir.r == -1 then
            if adjTile.connections[2] then 
                adjConnections[5] = 1
            else
                adjConnections[5] = 2
            end if
        else if dir.q == 1 and dir.r == 0 then
            if adjTile.connections[1] then
                 adjConnections[4] = 1
            else
                adjConnections[4] = 2
            end if
        else if dir.q == 0 and dir.r == 1 then
            if adjTile.connections[0] then
                adjConnections[3] = 1
            else
                adjConnections[3] = 2
            end if
        else if dir.q == -1 and dir.r == 1 then
            if adjTile.connections[5] then
                adjConnections[2] = 1
            else
                adjConnections[2] = 2
            end if
        else if dir.q == -1 and dir.r == 0 then
            if adjTile.connections[4] then 
                adjConnections[1] = 1
            else
                adjConnections[1] = 2
            end if
        end if
    end for
    return adjConnections
end function

GameBoard.canAdd = function(tile)
    if not self.tileOnBoardAndFree(tile) then
        return false
    end if
    if self.tiles.len > 0 then
        adjConnections = self.adjacentConnections(tile)
        numberConnections = 0 
        for value in adjConnections
            numberConnections = numberConnections + value
        end for

        if numberConnections <= 0 then return false

        for i in range(0,5)
            if adjConnections[i] == 1 and not tile.connections[i] then return false
        end for

        for i in range(0,5)
            if tile.connections[i] and adjConnections[i] == 2 then return false
        end for

    end if
    return true
end function

GameBoard.addTile = function(tile)
    self.tiles.push tile
end function

GameBoard.getTile = function(pos)
    val = null
    for tile in self.tiles
        if tile.position == pos then val = tile
    end for
    return val
end function

GameBoard.tilesAdjacentTo = function(tile)
    neighbourPositions = hexgrid.allCubeCoordNeighbours(tile.position)
    adjacentTiles = []
    for neighbour in neighbourPositions
        for entry in self.tiles
            if entry.position == neighbour then adjacentTiles.push entry
        end for
    end for
    return adjacentTiles
end function

if (globals == locals) then
    print "Test create gameboard"
    testboard = new GameBoard
    testboard.init
    qa.assert(testboard isa GameBoard)
    print "Test canAdd a tile on 0,0 is true on an empty grid"
    zeroZeroTile = new rivertile.Rivertile
    zeroZeroTile.init
    zeroZeroTile.connections[0] = true
    qa.assertEqual(testboard.canAdd(zeroZeroTile), true)
    testboard.addTile(zeroZeroTile)
    print "Test canAdd a tile on 0,0 is false after placing a tile there"
    qa.assertEqual(testboard.canAdd(zeroZeroTile),false)
    print "Test tilesAdjacent to tile at 0,0 should be empty list"
    qa.assertEqual(testboard.tilesAdjacentTo(zeroZeroTile), [])
    print "Test tilesAdjacent to tile at 0,1 should be list with tile at 0,0"
    zeroOneTile = new rivertile.Rivertile
    zeroOneTile.init
    zeroOneTile.position = {"q": 0, "r": 1, "s": -1}
    zeroOneTile.connections[3] = true
    zeroOneTile.connections[0] = true
    print zeroZeroTile
    qa.assertEqual(testboard.tilesAdjacentTo(zeroOneTile), [zeroZeroTile])

    zeroTwoTile = new rivertile.Rivertile
    zeroTwoTile.init
    zeroTwoTile.position = {"q": 0, "r": 2, "s": -2}
    zeroTwoTile.connections[3] = true

    zeroTwoTileWithoutCorrectConnection = new rivertile.Rivertile
    zeroTwoTileWithoutCorrectConnection.init
    zeroTwoTileWithoutCorrectConnection.position = {"q": 0, "r": 2, "s": -2}
    zeroTwoTileWithoutCorrectConnection.connections[2] = true


    print "Test tile can not be placed if not adjacent to already placed tile"
    qa.assertEqual(testboard.canAdd(zeroTwoTile),false)
    print "Test tile can be placed if adjacent to already placed tile"
    qa.assertEqual(testboard.canAdd(zeroOneTile), true)
    testboard.addTile zeroOneTile
    print "Test tile can not be placed if connection is not correct"
    qa.assertEqual(testboard.canAdd(zeroTwoTileWithoutCorrectConnection), false)
    print "Test tile can be placed if connection is correct"
    qa.assertEqual(testboard.canAdd(zeroTwoTile), true)

    print "All tests passed"
end if