clear

mapOffsetX = 16
mapOffsetY = 16

hexagonImage = file.loadImage("images/hexagon.png")
tileImage = file.loadImage("images/tile.png")

tileSize = 32
tileWidth = 2 * tileSize
tileHeight = sqrt(3) * tileSize

drawGrid = function()
    for col in range(0,18)
        numRows = 10 - (col % 2)
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

pointToHex = function(pos)
    q = (2/3 * pos.x) / tileWidth
    r = (-1/3 * pos.x + sqrt(3)/3 * pos.y)
    
end function

drawGrid

tileSprite = new Sprite
tileSprite.image = tileImage
tileSprite.tint = color.green
setSpriteToHexPos(tileSprite, 9, 4)

display(4).sprites = [tileSprite] + display(4).sprites