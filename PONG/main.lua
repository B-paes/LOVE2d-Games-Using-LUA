WIDTH = 960
HEIGHT = 540
SPEED = 300
BALLSPEED = 700

function love.load() --VARIAVEIS DE INICIALIZAÇÃO
    math.randomseed(os.time())
    love.window.setMode(960, 540)
    love.window.setTitle("Ping-Pong")
    
    score1 = 0
    score2 = 0

    racket1 = {}
    racket1.speed = 0
    racket1.w = 20
    racket1.h = 80
    racket1.x = WIDTH - 10 - racket1.w
    racket1.y = HEIGHT/2 - 40


    racket2 = {}
    racket2.w = 20
    racket2.h = 80
    racket2.x = 10
    racket2.y = HEIGHT/2 - 40
    racket2.speed = 0

    ball = {}
    ball.h = 20
    ball.w = 20
    ball.x = WIDTH/2
    ball.y = HEIGHT/2 - ball.h/2
    ball.dx = 0 --velocidade da bola no eixo x
    ball.dy = 0
    ball.speed = -BALLSPEED

    bigFont = love.graphics.newFont('font.ttf', 70)
    smallFont = love.graphics.newFont('font.ttf', 30)
    state = 'start'
end

function love.update(dt)
    if colides(ball, racket2) then --COLISAO BOLA E RAQUETE
        ball.speed = -ball.speed
        if ball.speed < 2000 then
            ball.speed = ball.speed * 1.05
        end

        ball.x = racket2.x + racket2.w
        ball.dy = math.random(-280, 280)
        
    end
    if colides(ball, racket1) then
        ball.speed = -ball.speed

        if ball.speed < -2000 then
            ball.speed = ball.speed * 1.05
        end

        ball.x = racket1.x - racket1.w
        ball.dy = math.random(-280, 280)
    end

    if ball.y < 0 then --COLISAO COM BORDAS
        ball.y = 0
        ball.dy = -ball.dy
    end
    if ball.y > HEIGHT - ball.h then
        ball.y = HEIGHT - ball.h
        ball.dy = -ball.dy
    end

    if ball.x <= 0 then  --SCORE BOT
        score2 = score2 + 1
        ball.x = WIDTH/2
        ball.y = HEIGHT/2 - ball.h/2
        ball.speed = -BALLSPEED
        ball.dx = 0
        ball.dy = 0
        racket1.y = HEIGHT/2 - 40
        racket2.y = HEIGHT/2 - 40
    end
    if ball.x >= WIDTH then --SCORE PLAYER
        score1 = score1 + 1
        ball.x = WIDTH/2
        ball.y = HEIGHT/2 - ball.h/2
        ball.speed = BALLSPEED
        ball.dy = 0
        racket1.y = HEIGHT/2 - 40
        racket2.y = HEIGHT/2 - 40
    end
    
    if state == 'play' then --PLAYER MOVE
        if love.keyboard.isDown('up') and racket1.y > 0 then
            racket1.speed = -SPEED   
        elseif love.keyboard.isDown('down') and racket1.y < HEIGHT - racket1.h then
            racket1.speed = SPEED
        else 
            racket1.speed = 0
        end
    
    
        if ball.dx < 0 then
            racketIa(racket2, ball) --Movimento da raquete (IA) apenas se estiver recebendo a bola
        else
            racket2.speed = 0
        end
            

        ball.dx = ball.speed -- movimento bola
        ball.x = ball.x + ball.dx * dt
        ball.y = ball.y + ball.dy * dt

        racket1.y = racket1.y + racket1.speed * dt --movimento raquetes
        racket2.y = racket2.y + racket2.speed * dt
    end
end

function love.draw()
    if state == 'start' then --START INICIAL
        love.graphics.setFont(bigFont)
        love.graphics.printf('PRESSIONE ENTER PARA JOGAR', 0,  HEIGHT/3, WIDTH, 'center' )
    end

    if state == 'play' then --PLAY MODE
        love.graphics.printf(score1, 200,  HEIGHT/2-35, WIDTH, 'left' )
        love.graphics.printf(score2, 0,  HEIGHT/2-35, WIDTH-200, 'right' )
        love.graphics.rectangle('line', racket2.x, racket2.y, racket2.w, racket2.h)
        love.graphics.rectangle('line', racket1.x, racket1.y, racket1.w, racket1.h)
        love.graphics.rectangle('fill', ball.x, ball.y, ball.w, ball.h)
    end
end

function colides(ball, racket1) --CALCULO COLISAO
    --bola acima ou abaixo da raquete
    if ball.y > racket1.y + racket1.h or ball.y + ball.h < racket1.y then
        return false
    end
    --bola do lado direito ou esquerdo da raquete
    if ball.x > racket1.x + racket1.w or ball.x + ball.w < racket1.x then
        return false
    end
    return true
end

function racketIa(racket2, ball) --CALCULO MOVIMENTO DA IA
    if racket2.y + racket2.h < ball.y + ball.h/2 then
        racket2.speed = SPEED
    elseif racket2.y > ball.y + ball.h/2 then
        racket2.speed = -SPEED
    else
        racket2.speed = 0
    end
end

--callback
function love.keypressed(key)
    if state == 'start' and key == 'return' then
        ball.speed = -BALLSPEED
        ball.dy = 0
        state = 'play'
    end
end