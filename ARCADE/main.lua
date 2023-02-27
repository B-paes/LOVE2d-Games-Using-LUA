WIDTH = 16 * 32
HEIGHT = 16 * 32

PLAYERSPEED = 50



function love.load()
    love.window.setMode(WIDTH, HEIGHT)

    tileset = {}
    tileset.map = love.graphics.newImage('img/tileset.png')
    tileset_width = tileset.map:getWidth() / 9
    tileset_height = tileset.map:getHeight() / 9

    for l = 0,8 do
        for c = 0,8 do
            sprite = love.graphics.newQuad(c * tileset_width, l * tileset_height,
                                tileset_width,
                                tileset_height,
                                tileset.map:getWidth(),
                                tileset.map:getHeight())
            table.insert(tileset, sprite)
        end
    end

    bigFont = love.graphics.newFont('font.ttf', 70)
    smallFont = love.graphics.newFont('font.ttf', 30)

    character = {}
    sprites = {}
    table.insert(sprites, love.graphics.newImage('img/character.png'))
    
    character.up = {}
    character.down = {}
    character.left = {}
    character.right = {}
    character.lastsprite = {}
    index = 1

    troll = {}
    table.insert(sprites, love.graphics.newImage('img/enemy.png'))
    troll.up = {}
    troll.down = {}
    troll.left = {}
    troll.right = {}

    treesprites = {}
    tree = {}
    table.insert(sprites, love.graphics.newImage('img/tree.png'))
    

    charsprites_width = sprites[1]:getWidth() / 15
    charsprites_height = sprites[1]:getHeight() / 8
    enemysprites_width = sprites[2]:getWidth() / 12
    enemysprites_height = sprites[2]:getHeight() / 8
    

    tilemap = {
        {33,43,42,33,43,42,33,43,42,33,43,42,33,43,42,33,43,42,33,43,42,33,43,42,33,56,42,33,43,42,33,43},
        {43,42,33,43,42,33,43,42,77,43,42,33,43,42,33,43,42,33,43,42,33,43,42,33,43,56,33,43,42,33,43,42},
        {42,33,43,42,33,43,42,33,43,42,33,43,42,33,43,42,33,43,42,68,43,42,33,43,42,56,43,42,33,43,42,33},
        {33,43,42,33,43,42,33,43,42,33,43,78,33,43,42,33,43,42,33,43,42,33,43,42,33,56,42,33,43,42,33,43},
        {43,42,33,43,42,33,43,42,33,43,42,33,43,42,33,43,42,33,43,42,33,43,42,33,43,56,33,43,42,77,43,42},
        {42,33,43,42,68,43,42,33,43,42,33,43,42,33,43,42,33,43,42,33,43,42,33,43,42,56,43,42,33,43,42,33},
        {33,43,42,33,43,42,33,43,42,33,43,42,33,70,42,33,43,42,33,43,42,33,43,42,33,56,42,33,43,42,33,43},
        {43,42,33,43,42,33,43,42,33,43,42,33,43,42,33,43,42,33,43,42,33,43,42,33,43,56,68,43,42,33,43,42},
        {42,33,43,42,33,43,42,33,43,42,33,43,42,33,43,42,33,43,42,33,43,42,33,43,42,56,43,42,33,43,42,33},
        {33,43,42,33,43,42,33,43,42,33,43,42,33,43,42,33,43,42,33,43,42,33,43, 7, 8,67, 9,33,43,42,33,43},
        {43,42,33,43,42,33,43,42,33,43,42,33,43,42,33,43,42,33,43,42,33, 7, 8,45,17,17,44, 9,42,33,70,42},
        {42,33,43,42,33,43,42,33,43,42,33,43,42,43,42,33,43,42,33, 7, 8,45,17,17,17,17,17,44, 9,43,42,33},
        {33,43,42,33,43,42,33,43,42,33,43, 7, 8, 8, 9,33,43,42, 7,45,17,17,17,17,17,17,17,17,18,42,33,43},
        {43,42,33,43,42,33,43,42,33,43, 7,17,17,17,44, 8, 8, 8,45,17,17,17,17,17,17,17,17,17,18,33,43,42},
        {42,33,43,42,33,43,42,33,43,42,16,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,18,43,42,33},
        {33,43,42,33,43,77,33,43,42,33,16,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,27,42,33,43},
        {43,42,33,43,42,33,43,42,43, 7,45,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,27,42,33,43,42},
        {42,33,43,42,33,43,42, 7, 8,45,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,27,42,33,43,79,33},
        {33,43,42, 7, 8, 8, 8,45,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,27,42,33,43,42,33,43},
        {43,71,55,75,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,35,26,26,26,27,42,33,43,42,33, 4, 5},
        {42,56,43,25,26,36,17,17,17,17,17,17,17,17,17,17,17,17,17,17,27,42,33,43,42,33,43, 4, 5, 5,41,14},
        {33,56,42,33,43,25,26,26,36,17,17,17,17,17,17,17,17,17,17,27,42,33,43,42,33, 4, 5,41,14,14,14,14},
        {43,56,33,43,42,33,43,42,25,26,26,36,17,17,17,17,17,17,27,42,33,43,42, 4, 5,41,14,14,14,14,14,14},
        {42,56,43,42,33,43,42,33,43,42,33,25,26,26,26,26,26,27,42,33,43, 4, 5,41,14,14,14,14,14,14,14,14},
        {33,56,42,33,43,77,33,43,42,33,43,42,33,43,42,33,43,42,33, 4, 5,41,14,14,14,14,14,14,14,14,14,14},
        {43,56,33,43,42,33,43,42,33,43,42,33,43,42,33,43,42, 4, 5,41,14,14,14,14,14,14,14,14,14,14,14,14},
        {42,56,43,42,33,43,42,33,43,42,33,43,42,33,43, 4, 5,41,14,14,14,14,14,14,14,14,14,14,14,14,14,14},
        {33,56,42,33,43,42,33,43,42,33,43,42,33, 4, 5,41,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14},
        {77,56,33,43,42,33,43,68,33,43, 4, 5, 5,41,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14},
        {42,56,43,42,33,43,42,33, 4, 5,41,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14},
        {33,56,42,33,69,69, 4, 5,41,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14},
        {43,56,33,78, 4, 5,41,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14}
    }

    walkable = {7,8,9,16,17,18,25,26,27,35,36,44,45,55,56,57,58,59,60,61,66,67,71,72,75,76,80,81}



    for l = 0,4 do
        for c = 0,3 do
            sprite = love.graphics.newQuad(c * charsprites_width, l * charsprites_height,
                                charsprites_width,
                                charsprites_height,
                                sprites[1]:getWidth(),
                                sprites[1]:getHeight())
            if l==0 then
                table.insert(character.down, sprite)
            elseif l==1 then
                table.insert(character.left, sprite)
            elseif l==2 then
                table.insert(character.right, sprite)
            else
                table.insert(character.up, sprite)
            end
        end
    
        for l = 0,8 do
            for c = 0,12 do
                sprite = love.graphics.newQuad(c * enemysprites_width, l * enemysprites_height,
                                    enemysprites_width,
                                    enemysprites_height,
                                    sprites[2]:getWidth(),
                                    sprites[2]:getHeight())
                
                if c>5 and c<9 then
                    if l==4 then
                            table.insert(troll.down, sprite)
                    elseif l==5 then
                            table.insert(troll.right, sprite)
                    elseif l==6 then
                            table.insert(troll.left, sprite)
                    elseif l==7 then
                            table.insert(troll.up, sprite)
                    end
                end
            end
        end
    end
        for l = 0,3 do
            
            sprite = love.graphics.newQuad(0, l * sprites[3]:getHeight() / 3,
                                sprites[3]:getWidth(),
                                sprites[3]:getHeight() / 3,
                                sprites[3]:getWidth(),
                                sprites[3]:getHeight())
            if l==0 then
                table.insert(treesprites, sprite)
            elseif l==1 then
                table.insert(treesprites, sprite)
            elseif l==2 then
                table.insert(treesprites, sprite)
            end
        end
    
    enemyFrame = 1
    curFrame = 2

    player = {}
    player.speed = 0
    player.dirX = 0
    player.dirY = 0
    player.x = 1 * 16
    player.y = 30 * 16
    player.cord = {0,0}
    character.lastsprite = character.up


    state = "start"



    enemies = {}
    
    table.insert(enemies,createEnemy(8,17,8,22))
    table.insert(enemies,createEnemy(18,12,28,12))
    table.insert(enemies,createEnemy(17,13,17,23))
    
    trees = {}

    table.insert(trees,newTree(2,2,1))
    table.insert(trees,newTree(28,8,3))
    table.insert(trees,newTree(1,15,3))
    table.insert(trees,newTree(17,10,1))
    table.insert(trees,newTree(23,4,1))
    table.insert(trees,newTree(6,6,3))
    table.insert(trees,newTree(8,22,1))
    table.insert(trees,newTree(5,28,1))
    table.insert(trees,newTree(28,17,3))




end

function love.update(dt)

    if state == "play" then 
        player.cord = posicaoVetor(player.x , player.y)

        
        
        if curFrame > 4 then
            curFrame = 1
        end
        
        if enemyFrame > 4 then
            enemyFrame = 1
        end    
        enemyFrame = enemyFrame + 8 * dt


        for i=#enemies,1,-1 do

            e=enemies[i]

            
            e.cord = posicaoVetor(e.x, e.y)
            
            if (e.pontoA[1] > e.pontoB[1])then
                e.direction = troll.right
                e.x = e.x - e.speed * dt
            elseif (e.pontoA[2] > e.pontoB[2])then
                e.direction = troll.up
                e.y = e.y - e.speed * dt
            elseif (e.pontoB[1] > e.pontoA[1])then
                e.direction = troll.left
                e.x = e.x + e.speed * dt
            elseif(e.pontoB[2] > e.pontoA[2]) then
                e.direction = troll.down
                e.y = e.y + e.speed * dt
            end

            
            if e.cord[1] == e.pontoB[1] and e.cord[2] == e.pontoB[2] then
                a = e.pontoA
                b = e.pontoB

                e.pontoA = b
                e.pontoB = a
            end

            if collides(e, player, 8)  then
                state = "dead"
                --musica morte
            end
            if player.cord[1] == 25 and player.cord[2] == 1 then
                state = "win"
            end
        end
    end
end

function love.draw()
    --tilemap
    for i,row in ipairs(tilemap) do
        for j,v in ipairs(row) do
            love.graphics.draw(tileset.map, tileset[v], j*16 - 16, i*16 - 16)         
        end
    end 

    --player sprite
    if math.floor(curFrame) == 4 then
        idx = 2
    else
        idx = math.floor(curFrame)
    end
    love.graphics.draw(sprites[1], character.lastsprite[idx], player.x, player.y)



    eframe = math.floor(enemyFrame)

    for o, e in ipairs(enemies) do
        love.graphics.draw(sprites[2],
                        e.direction[eframe], 
                        e.x, 
                        e.y, 
                        0)    
    end
    
    for o, t in ipairs(trees) do
        love.graphics.draw(sprites[3],
                        treesprites[t.type], 
                        t.x, 
                        t.y, 
                        0)    
    end
    


    if state == "start" then
        love.graphics.setFont(bigFont)
        love.graphics.printf("WELCOME PLAYER!", 0, HEIGHT/5, WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf("PRESS SPACE", 0,HEIGHT - HEIGHT/5 - 20, WIDTH, 'center')
        love.graphics.printf("TO PLAY", 0,HEIGHT - HEIGHT/5 + 20, WIDTH, 'center')
    elseif state == "dead" then
        love.graphics.setFont(bigFont)
        love.graphics.printf("YOU'RE DEAD!", 0, HEIGHT/5, WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf("PRESS R", 0,HEIGHT - HEIGHT/5 - 20, WIDTH, 'center')
        love.graphics.printf("TO TRY AGAIN", 0, HEIGHT - HEIGHT/5 + 20, WIDTH, 'center')
    elseif state == "win" then
        love.graphics.setFont(bigFont)
        love.graphics.printf("YOU WIN!", 0, HEIGHT/8, WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf("PRESS R", 0, HEIGHT - HEIGHT/2, WIDTH, 'center')
        love.graphics.printf("TO PLAY AGAIN", 0, HEIGHT - HEIGHT/2 + 40, WIDTH, 'center')

        love.graphics.printf("ESC FOR CLOSE", 0, HEIGHT - HEIGHT/8, WIDTH, 'center')
    end


    
end

function posicaoVetor(x, y) 
    novoX = (x+8)/16
    novoY = (y+8)/16
    cord = {math.floor(novoX),math.floor(novoY)}
    return cord 
end

function love.keypressed(key)
    local x = player.x
    local y = player.y

    if state == "play" then

        if key == 'up' and has_value(walkable,tilemap[player.cord[2]][player.cord[1]+1]) then
            y = y - 16
            player.dirX = 0
            player.dirY = -1
            character.lastsprite = character.up
            curFrame = curFrame+1
        elseif key == 'down' and has_value(walkable,tilemap[player.cord[2]+2][player.cord[1]+1]) and player.cord[2] ~= 30 then
            y = y + 16
            player.dirX = 0
            player.dirY = 1
            character.lastsprite = character.down
            curFrame = curFrame+1
        elseif key == 'left' and has_value(walkable,tilemap[player.cord[2]+1][player.cord[1]]) then
            x = x - 16
            player.dirX = -1
            player.dirY = 0
            character.lastsprite = character.left
            curFrame = curFrame+1
        elseif key == 'right' and has_value(walkable,tilemap[player.cord[2]+1][player.cord[1]+2]) then
            x = x + 16
            player.dirX = 1
            player.dirY = 0
            character.lastsprite = character.right
            curFrame = curFrame+1
        end


        player.x = x
        player.y = y
        
    end
       
    if state == "dead" or state == "win" then
        if key == 'r' then
            
            
            for e=#enemies, 1, -1 do
                table.remove(enemies, e)    
            end
        
            table.insert(enemies,createEnemy(8,17,8,22))
            table.insert(enemies,createEnemy(18,12,28,12))
            table.insert(enemies,createEnemy(17,13,17,23))
        
            player.x = 1 * 16
            player.y = 30 * 16
            character.lastsprite = character.up

            state = "play"
        end
    end
    if state == "win" then
        if key == 'escape' then
            love.window.close()
        end
    end
    
    if state == "start" then
        if key == 'space'  then
            state = "play"
        end
    end

end

function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

function createEnemy(AX,AY,BX,BY)
    local enemy = {}
    
    enemy.direction = troll.down
    enemy.speed = 80
    enemy.x = AX * 16
    enemy.y = AY * 16
    enemy.pontoA = {AX,AY}
    enemy.pontoB = {BX,BY}
    enemy.cord = {AX,AY}
    
    return enemy
end

function newTree(x,y,type)
    local tree = {}
    tree.x = x * 16
    tree.y = y * 16
    tree.type = type
    return tree
end

function collides(a, b ,c)
    if math.sqrt((a.y - b.y)^2 + (a.x - b.x)^2) <= c then
        return true
    else
        return false
    end
end