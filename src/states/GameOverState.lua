GameOverState = Class{__includes = BaseState}

function GameOverState:enter(params)
    self.state = params.state
    self.whiteWins = params.winner
end

function GameOverState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') or love.mouse.wasPressed(1) then
        gStateMachine:change('play')
    end
end

function GameOverState:render()
    love.graphics.setColor(0.8, 0.2, 0.2, 1)
    if self.state == "checkmate" then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("Checkmate", 0, 100, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(gFonts['medium'])
        if self.whiteWins then
            love.graphics.printf("White won the game!", 0, 180, VIRTUAL_WIDTH, 'center')
        else
            love.graphics.printf("Black won the game!", 0, 180, VIRTUAL_WIDTH, 'center')
        end
    else
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("Stalemate", 0, 100, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(gFonts['medium'])
        love.graphics.printf("Draw!", 0, 180, VIRTUAL_WIDTH, 'center')
    end
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf("Press enter or left-click mouse to play again!", 0, 300, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Press escape to exit", 0, 350, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(1,1,1,1)
end