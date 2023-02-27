WIDTH = 1024
HEIGHT = 576

BULLET_SPEED = 700
ROBOT_SPEED = 120

SPECIALTIMER = 5

math.randomseed(os.time())

function love.load()
    love.window.setMode(WIDTH, HEIGHT)
    sprite = {}
    sprite.shooter = love.graphics.newImage('images/soldier1_gun.png')
    sprite.enemy =  love.graphics.newImage('images/robot1_hold.png')
    sprite.bullet =  love.graphics.newImage('images/tile_187.png')
    sprite.hole = love.graphics.newImage('images/tile_483.png')

    shooter = {}
    shooter.x = WIDTH/2
    shooter.y = HEIGHT/2
    shooter.speed = 160
    shooter.rotation = 0
    shooter.state = "idle"

    shoot =  0

    enemies = {}
    bullets = {}
    holes = createHoles()

    spawnTime = 2 --segundos
    spawn = spawnTime

    specialCD = 0
    specialTime = 2
    special = specialTime

    state = "menu"

    score = 0

    bigFont = love.graphics.newFont('font.ttf', 70)
    smallFont = love.graphics.newFont('font.ttf', 30)
end

function love.update(dt)

    if state == "play" then
        
        spawn = spawn - dt
        if spawn <=0 then
            table.insert(enemies, createEnemy())
            if spawnTime > 0.3 then
                spawnTime = spawnTime * 0.93
            end
            spawn = spawnTime
        end

        if love.keyboard.isDown('w') and shooter.y > 25 then
            shooter.y = shooter.y - shooter.speed * dt 
        end
        if love.keyboard.isDown('s') and shooter.y < HEIGHT - 25 then
            shooter.y = shooter.y + shooter.speed * dt 
        end
        if love.keyboard.isDown('a') and shooter.x > 25 then
            shooter.x = shooter.x - shooter.speed * dt 
        end
        if love.keyboard.isDown('d') and shooter.x < WIDTH - 25 then
            shooter.x = shooter.x + shooter.speed * dt 
        end
        
    
    
        for p=#bullets, 1, -1 do
            b = bullets[p]
            b.x = b.x + BULLET_SPEED * math.cos(b.direction) * dt
            b.y = b.y + BULLET_SPEED * math.sin(b.direction) * dt

            if b.x < 0 or b.x > WIDTH or
                b.y < 0 or b.y > HEIGHT then
                    table.remove(bullets,p)    
            else
                for i,e in ipairs(enemies) do
                    if collides(b, e, 25) then
                        e.hit = true
                        table.remove(bullets, p)
                    end
                end
            end
        end
        for i=#enemies,1,-1 do
            e = enemies[i]
            e.direction = enemyShooterAngle(e)
            e.x = e.x + ROBOT_SPEED * math.cos(e.direction) * dt
            e.y = e.y + ROBOT_SPEED * math.sin(e.direction) * dt
        
            if collides(shooter,e,25) then
                state = "menu"
            end
            

            if e.hit then
                table.remove(enemies, i)
                score = score+1
            end
        end
        
        if shooter.state == "idle" then
            shooter.rotation = mouseShooterAngle()
        end
        if shooter.state == "special" and specialCD < 0 then
            special =  special - dt
            if special <=0 then
                shooter.state = "idle"
                special = specialTime
                specialCD = SPECIALTIMER

            else --combo
                
                shooter.rotation = shooter.rotation + ( dt * 19 )
                
                
            end
        else 
            shooter.state = "idle"
        end
        specialCD = specialCD - dt
    end
end

function love.draw()
    love.graphics.setFont(smallFont)
    love.graphics.printf("SCORE: ".. score, 0,  20, WIDTH, 'center')

    

    love.graphics.draw(sprite.shooter, 
                        shooter.x, 
                        shooter.y, 
                        shooter.rotation,
                        nil, --escala x
                        nil, --escala y
                        sprite.shooter:getWidth()/2,  --origem x
                        sprite.shooter:getHeight()/2) --origem y
    
    for i, h in ipairs(holes) do
        love.graphics.draw(sprite.hole, h.x, h.y)
    end
    
    if state == "play" then

        for i, b in ipairs(bullets) do
            love.graphics.draw(sprite.bullet, b.x, b.y, 0, nil, nil,
                            sprite.bullet:getWidth()/2,
                            sprite.bullet:getHeight()/2)
        end

        

        for i, e in ipairs(enemies) do
            love.graphics.draw(sprite.enemy, 
                                e.x, 
                                e.y, 
                                e.direction,
                                nil,
                                nil,
                                sprite.enemy:getWidth()/2,
                                sprite.enemy:getHeight()/2)
        end

    end

    if state == "menu" then
        love.graphics.setFont(bigFont)
        love.graphics.printf("PRESS ENTER", 0, 160, WIDTH, 'center')
        love.graphics.printf("TO PLAY", 0, 360, WIDTH, 'center')

        shooter.x = WIDTH/2
        shooter.y = HEIGHT/2
        shooter.speed = 160
        shooter.rotation = 0

        spawnTime = 2

        for i=#enemies,1,-1 do
            table.remove(enemies)
        end
        for i=#bullets,1,-1 do
            table.remove(bullets)
        end
        
    end
end

function love.keypressed(key)
    if state == "play" then
        if shooter.state == "idle" then
            if key == 'space'  then
                
                local bullet = {}
                bullet.x = shooter.x
                bullet.y = shooter.y
                bullet.direction = mouseShooterAngle()

                table.insert(bullets, bullet) 
            end
            if key == 'q' then
                shooter.state = "special"
            end
        elseif shooter.state == "special" then
            
            
        
            local bullet = {}

            bullet.x = shooter.x
            bullet.y = shooter.y
            bullet.direction = shooter.rotation
            table.insert(bullets, bullet)
            
           
            
            

        end
    end

    if state == "menu" then
        if key == 'return' then
           state = "play" 
           score = 0
        end
    end
end

function mouseShooterAngle()
    return math.atan2(love.mouse.getY() - shooter.y,
            love.mouse.getX() - shooter.x)
end

function enemyShooterAngle(e)
    return math.atan2(shooter.y - e.y, shooter.x - e.x)
end

function createEnemy()
    local enemy = {}
    --enemy.x = math.random(0, WIDTH)
    --enemy.y = math.random(0, HEIGHT)

    i = math.random(1,4)
    enemy.x = holes[i].x + sprite.hole:getWidth()/2
    enemy.y = holes[i].y + sprite.hole:getHeight()/2

    enemy.direction = enemyShooterAngle(enemy)
    enemy.hit = false
    enemy.bullet = nil
    return enemy
end

function collides(a, b ,c)
    if math.sqrt((a.y - b.y)^2 + (a.x - b.x)^2) <= c then
        return true
    else
        return false
    end
end
    
function createHoles()
    local holes = {}

    table.insert(holes, {x=10, y=10})
    table.insert(holes, {x=WIDTH - sprite.hole:getWidth() - 10, y=10})
    table.insert(holes, {x=WIDTH - sprite.hole:getWidth() - 10, 
                        y=HEIGHT - sprite.hole:getHeight()-10})
    table.insert(holes, {x=10, y=HEIGHT - sprite.hole:getHeight()-10})
    return holes
end
