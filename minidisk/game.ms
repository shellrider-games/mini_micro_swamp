import "hexgrid"
import "mathUtil"
import "easings"
import "gameBoard"
import "rivertile"
clear

mapOffsetX = 16
mapOffsetY = 16
mapCols = 18
mapRows = 10
rotationTime = 0.25

tileImages = []
tileImages.push file.loadImage("images/tile_variations/tile_0_1.png")
tileImages.push file.loadImage("images/tile_variations/tile_0_2.png")
tileImages.push file.loadImage("images/tile_variations/tile_0_3.png")
tileImages.push file.loadImage("images/tile_variations/tile_0_1_3.png")
tileImages.push file.loadImage("images/tile_variations/tile_0_3_5.png")
tileImages.push file.loadImage("images/tile_variations/tile_1_3_5.png")

hexagonImage = file.loadImage("images/hexagon.png")

tileSize = 32
tileWidth = 2 * tileSize
tileHeight = sqrt(3) * tileSize

board = new gameBoard.GameBoard
tiles = []
tileSprites = []

currentTileRotating = false
rotationTimePassed = 0
currentRotation = 0
nextRotation = 0

drawGrid = function()
    for col in range(0,mapCols)
        numRows = mapRows - (col % 2)
        for row in range(0,numRows)
            yOffset = 0
            if col % 2 then yOffset = tileHeight*0.5
            xOffset = -tileWidth * 0.25 * col
            sprite = new Sprite
            sprite.image = hexagonImage
            sprite.x = tileWidth*col + tileWidth * 0.5 + xOffset + mapOffsetX
            sprite.y = tileHeight*row + tileHeight * 0.5 + yOffset + mapOffsetY
            display(4).sprites.push sprite
        end for
    end for
end function

setSpriteToHexPos = function(sprite, x, y)
    yOffset = 0
    if x % 2 then yOffset = tileHeight * 0.5
    sprite.x = tileWidth * x + tileWidth * 0.5 - tileWidth*0.25*x + mapOffsetX
    sprite.y = tileHeight * y + tileHeight * 0.5 + yOffset + mapOffsetY
end function

createRiverTile = function(idx)
    noob = new rivertile.Rivertile
    noob.init
    if idx == 0 then
        noob.connections[0] = true
        noob.connections[1] = true
    else if idx == 1 then
        noob.connections[0] = true
        noob.connections[2] = true
    else if idx == 2 then
        noob.connections[0] = true
        noob.connections[3] = true
    else if idx == 3 then
        noob.connections[0] = true
        noob.connections[1] = true
        noob.connections[3] = true
    else if idx == 4 then
        noob.connections[0] = true
        noob.connections[3] = true
        noob.connections[5] = true
    else if idx == 5 then
        noob.connections[1] = true
        noob.connections[3] = true
        noob.connections[5] = true
    end if
    return noob
end function

createNewTile = function()
    tileSprite = new Sprite
    imageIdx = ceil(rnd * (tileImages.len)) - 1
    tileSprite.image = tileImages[imageIdx]
    display(4).sprites.push tileSprite
    tileModel = createRiverTile(imageIdx)
    return [tileSprite, tileModel]
end function

startRotation = function(direction)
    outer.rotationTimePassed = 0
    if direction > 0 then 
        outer.nextRotation = outer.currentRotation + 60
    else
        outer.nextRotation = outer.currentRotation - 60
    end if
    outer.currentTileRotating = 1
end function

handleRotation = function(delta)
    outer.rotationTimePassed = outer.rotationTimePassed + delta
    t = easings.outQuint(outer.rotationTimePassed / rotationTime)
        tileSprite.rotation = mathUtil.lerp(outer.currentRotation,outer.nextRotation, t)
    if rotationTimePassed >= rotationTime then
        tileSprite.rotation = outer.nextRotation
        outer.currentTileRotating = false
        outer.currentRotation = outer.nextRotation
    end if
end function

tile = createNewTile
tileSprite = tile[0]
tileModel = tile[1]
wasDown = false
lastTimestamp = time

while true
    yield
    currentTimestamp = time
    delta = currentTimestamp - lastTimestamp
    lastTimestamp = currentTimestamp
    
    if key.pressed("q") then break
    
    if currentTileRotating then
        handleRotation delta
        continue
    end if

    if key.axis("Mouse ScrollWheel") != 0 then
        startRotation key.axis("Mouse ScrollWheel")
        tileModel.rotate key.axis("Mouse ScrollWheel")
        continue
    end if

    mouseDown = mouse.button

    gridPos = {"x": mouse.x-mapOffsetX-tileSize, "y": mouse.y-mapOffsetY-tileSize}
    tilePos = hexgrid.pointToHexOddq(gridPos, tileSize)
    setSpriteToHexPos(tileSprite, tilePos.col, tilePos.row)
    cubePos = hexgrid.oddqToCube(tilePos.col, tilePos.row)
    tileModel.position = cubePos

    if board.canAdd(tileModel) then
        tileSprite.tint = color.white
    else
        tileSprite.tint = color.red
    end if

    if mouseDown and not wasDown and board.canAdd(tileModel) then
        board.addTile tileModel
        tile = createNewTile
        tileSprite = tile[0]
        tileModel = tile[1]
        currentRotation = 0
        nextRotation = 0
        tileSprite.rotation = 0
        setSpriteToHexPos(tileSprite, tilePos.col, tilePos.row)
    end if
    wasDown = mouseDown
end while
clear