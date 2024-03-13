import "hexgrid"
import "mathUtil"
import "easings"
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

createNewTile = function()
    tileSprite = new Sprite
    imageIdx = ceil(rnd * (tileImages.len)) - 1
    tileSprite.image = tileImages[imageIdx]
    display(4).sprites.push tileSprite
    return tileSprite
end function

couldPlaceTile = function(cubePos)
    if tiles.indexOf(cubePos) != null then return false
    oddQPos = hexgrid.cubeToOddq(cubePos.q,cubePos.r)
    if(oddQPos.col >= 0 and oddQPos.col <= mapCols and oddQPos.row >= 0 and oddQPos.row <= mapRows - oddQPos.col % 2) then return true
    return false
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

//drawGrid
tileSprite = createNewTile

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
        continue
    end if

    mouseDown = mouse.button
    gridPos = {"x": mouse.x-mapOffsetX-tileSize, "y": mouse.y-mapOffsetY-tileSize}
    tilePos = hexgrid.pointToHexOddq(gridPos, tileSize)
    setSpriteToHexPos(tileSprite, tilePos.col, tilePos.row)
    cubePos = hexgrid.oddqToCube(tilePos.col, tilePos.row)
    if couldPlaceTile(cubePos) then
        tileSprite.tint = color.white
    else
        tileSprite.tint = color.red
    end if

    if mouseDown and not wasDown and couldPlaceTile(cubePos) then
        tiles.push cubePos
        tileSprite = createNewTile
        setSpriteToHexPos(tileSprite, tilePos.col, tilePos.row)
    end if
    wasDown = mouseDown
end while
clear