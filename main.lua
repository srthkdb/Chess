require 'src/dependencies'

function love.load()
    
    love.window.setTitle('Chess')
    math.randomseed(os.time())
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    gFonts = {
        ['small'] = love.graphics.newFont('fonts/font.ttf', 12),
        ['medium'] = love.graphics.newFont('fonts/font.ttf', 18),
        ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
    }
    love.graphics.setFont(gFonts['large'])

    gSounds = {
    	['move'] = love.audio.newSource('sounds/move.wav', 'static'),
    	['game-over'] = love.audio.newSource('sounds/game_over.wav', 'static'),
    }

    gTextures = {
        ['board'] = love.graphics.newImage('graphics/board.jpg'),
        ['blackBishop'] = love.graphics.newImage('graphics/blackBishop.png'),
        ['blackKing'] = love.graphics.newImage('graphics/blackKing.png'),
        ['blackKnight'] = love.graphics.newImage('graphics/blackKnight.png'),
        ['blackPawn'] = love.graphics.newImage('graphics/blackPawn.png'),
        ['blackQueen'] = love.graphics.newImage('graphics/blackQueen.png'),
        ['blackRook'] = love.graphics.newImage('graphics/blackRook.png'),
        ['whiteBishop'] = love.graphics.newImage('graphics/whiteBishop.png'),
        ['whiteKing'] = love.graphics.newImage('graphics/whiteKing.png'),
        ['whiteKnight'] = love.graphics.newImage('graphics/whiteKnight.png'),
        ['whitePawn'] = love.graphics.newImage('graphics/whitePawn.png'),
        ['whiteQueen'] = love.graphics.newImage('graphics/whiteQueen.png'),
        ['whiteRook'] = love.graphics.newImage('graphics/whiteRook.png'),
    }

    gStateMachine = StateMachine({
        ['play'] = function() return PlayState() end,
        ['game-over'] = function() return GameOverState() end,
    })

    gStateMachine:change('play')

    love.keyboard.keysPressed = {}
    love.mouse.keysPressed = {}
end

function love.mouse.wasPressed(key)
    if love.mouse.keysPressed[key] then
        return true
    end
    return false
end


function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    end
    return false
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.mousepressed(x, y, button)
    love.mouse.keysPressed[button] = true
 end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)
    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
    love.mouse.keysPressed = {}
end

function love.draw()
    push:start()

    local backgroundWidth = gTextures['board']:getWidth()
    local backgroundHeight = gTextures['board']:getHeight()

    love.graphics.draw(gTextures['board'], 0, 0,
        0,
        VIRTUAL_WIDTH / (backgroundWidth - 1), VIRTUAL_HEIGHT / (backgroundHeight - 1))

    
    gStateMachine:render()
    push:finish()
end
