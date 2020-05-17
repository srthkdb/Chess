PlayState = Class{__includes = BaseState}

WHITE_KING = { x = 1, y = 4}
BLACK_KING = { x = 8, y = 4}

function PlayState:init()
    self.board = Board()
    self.highlighted = {
        x = 1, 
        y = 1
    }
    self.moves = {}
    self.moveTurn = false
    self.selectedPiece = nil
    self.whitePlayer = Player(true, true)
    self.blackPlayer = Player(true, false)
    self.whiteTurn = true
    self.state = 'play'
end

function PlayState:update(dt)
    local mouseX, mouseY = love.mouse.getPosition()

    mouseX, mouseY = math.min(8, math.max(math.ceil((mouseX - 115) / 135), 1)), math.min(8, math.max(math.ceil((mouseY - 115) / 135), 1))
    if mouseX > 0 and mouseY > 0 then
        self.highlighted = {
            x = mouseY,
            y = mouseX
        }
        self.board:highlight(self.highlighted)
    end
    -- print(self.state)

    if love.mouse.wasPressed(1) then
        if self.moveTurn then
            local validMove = false

            for k, move in pairs(self.moves) do
                if move.to.x == self.highlighted.x and move.to.y == self.highlighted.y then
                    validMove = true
                    break
                end
            end
        
            if validMove then
                local mo = Move(self.board.board[self.selectedPiece.x][self.selectedPiece.y],  self.board.board[self.highlighted.x][self.highlighted.y], nil)
                self.board:move(mo)
                local attackers = self:inCheck(self.whiteTurn, true, 0, 0)
                if #attackers > 0 then
                    self.board:reverseMove(mo)
                else
                    enpassant = nil
                    if mo.from.piece.pieceName == 'pawn' then
                        if math.abs(mo.to.x - mo.from.x) > 1 then
                            enpassant = {x = mo.to.x, y = mo.to.y}
                            print("enpassant")
                        end
                    end
                    self.board.board[mo.to.x][mo.to.y].piece:move()
                    self.whiteTurn = not self.whiteTurn
                    attackers = self:inCheck(self.whiteTurn, true, 0, 0)
                    if #attackers > 0 then
                        if self:checkMate(attackers) then
                            gStateMachine:change('game-over', {state = 'checkmate', winner = not self.whiteTurn})
                        else
                            self.state = 'check'
                        end
                    else
                        if self:staleMate() then
                            gStateMachine:change('game-over', {state = 'stalemate', winner = nil})
                        else
                            self.state = 'play'
                        end
                    end
                    if self.whiteTurn then
                        self.blackPlayer.moves[#self.blackPlayer.moves + 1] = mo
                    else
                        self.whitePlayer.moves[#self.whitePlayer.moves + 1] = mo
                    end
                    if mo.from.piece.pieceName == 'pawn' then
                        if mo.from.piece.isWhite then
                            if mo.to.x == 8 then
                                self.state = 'spawn'
                                self.selectedPiece.x = mo.to.x
                                self.selectedPiece.y = mo.to.y
                            end
                        else
                            if mo.to.x == 1 then
                                self.state = 'spawn'
                                self.selectedPiece.x = mo.to.x
                                self.selectedPiece.y = mo.to.y
                            end
                        end
                    end

                end
            end

            self.moveTurn = false
            self.moves = {}
        else
            if self.board.board[self.highlighted.x][self.highlighted.y].piece ~= nil and self.board.board[self.highlighted.x][self.highlighted.y].piece.isWhite == self.whiteTurn then
                self.moves = self.board.board[self.highlighted.x][self.highlighted.y]:showMoves(self.board)

                if self.moves == nil then
                    self.moves = {}
                end
                if #self.moves > 0 then
                    self.moveTurn = true
                    self.selectedPiece = {x = self.highlighted.x, y = self.highlighted.y}
                else
                    self.moveTurn = false
                end

            else
                self.moves = {}
            end
        end
    end

    self.board:highlight(self.highlighted)

    --undo code
    -- if love.keyboard.wasPressed('u') then
    --     local lastMove = nil
    --     if self.whiteTurn then
    --         lastMove = self.blackPlayer.moves[#self.blackPlayer.moves]
    --         table.remove(self.blackPlayer.moves, #self.blackPlayer.moves)
    --     else
    --         lastMove = self.whitePlayer.moves[#self.whitePlayer.moves]
    --         table.remove(self.whitePlayer.moves, #self.whitePlayer.moves)
    --     end

    --     if lastMove ~= nil then
    --         self.board:reverseMove(lastMove)
    --         self.moveTurn = not self.moveTurn
    --         self.whiteTurn = not self.whiteTurn
    --         if #self:inCheck(true, true, 0, 0) > 0 then
    --             self.state = 'check'
    --         elseif #self:inCheck(false, true, 0, 0) > 0 then
    --             self.state = 'check'
    --         else
    --             self.state = 'play'
    --         end
    --     end
    -- end

    if love.keyboard.wasPressed('q') and self.state == 'spawn' then
        print('q')
        self.board.board[self.selectedPiece.x][self.selectedPiece.y]:setPiece('queen', not self.whiteTurn)
        self.state = 'play'
    elseif love.keyboard.wasPressed('r') and self.state == 'spawn' then
        self.board.board[self.selectedPiece.x][self.selectedPiece.y]:setPiece('rook', not self.whiteTurn)
        self.state = 'play'
    elseif love.keyboard.wasPressed('k') and self.state == 'spawn' then
        self.board.board[self.selectedPiece.x][self.selectedPiece.y]:setPiece('knight', not self.whiteTurn)
        self.state = 'play'
    elseif love.keyboard.wasPressed('b') and self.state == 'spawn' then
        self.board.board[self.selectedPiece.x][self.selectedPiece.y]:setPiece('bishop', not self.whiteTurn)
        self.state = 'play'
    end

end

function PlayState:render()
    self.board:render()

    for k, move in pairs(self.moves) do
        love.graphics.setColor(1,0,0,0.5)
        love.graphics.rectangle('fill', offSetX + (move.to.y - 1) * BOX_WIDTH, offSetY + (move.to.x - 1) * BOX_HEIGHT, BOX_WIDTH, BOX_HEIGHT)
        love.graphics.setColor(1,1,1,1)
    end

    if self.state == 'check' then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("Check", 0, 15, VIRTUAL_WIDTH, center)
    end

    if self.state == 'spawn' then
        love.graphics.setFont(gFonts['medium'])
        love.graphics.printf("Press q for queen, r for rook, b for bishop or k for knight", 0, 10, VIRTUAL_WIDTH, center)
    end

    -- love.graphics.setFont(gFonts['small'])
    -- love.graphics.printf("Press escape to exit.", 0, VIRTUAL_HEIGHT - 20, VIRTUAL_WIDTH, center)
end 

function PlayState:getFirstPiece(x, y, delX, delY)
    for k = 1, 8 do
        local i = x + k * delX
        local j = y + k * delY
        if not isValid(i, j) then
            return nil
        end
        if self.board.board[i][j].piece ~= nil then
            return self.board.board[i][j]
        end
    end

    return nil
end

function PlayState:inCheck(white, isKing, x1, y1)
    --add pawn and king
    local attackers = {}

    local i = x1
    local j = y1

    if isKing then 
        if white then
            i = WHITE_KING.x 
            j = WHITE_KING.y 
        else
            i = BLACK_KING.x
            j = BLACK_KING.y 
        end
    end

    -- up
    local nextPiece = self:getFirstPiece(i, j, -1, 0)
    if nextPiece ~= nil and nextPiece.piece ~= nil then
        if nextPiece.piece.pieceName == 'rook' or nextPiece.piece.pieceName == 'queen' and nextPiece.piece.isWhite ~= white then
            attackers[#attackers + 1] = nextPiece
        end
    end

    -- down
    nextPiece = self:getFirstPiece(i, j, 1, 0)
    if nextPiece ~= nil and nextPiece.piece ~= nil and nextPiece.piece.isWhite ~= white then
        if nextPiece.piece.pieceName == 'rook' or nextPiece.piece.pieceName == 'queen' then
            attackers[#attackers + 1] = nextPiece
        end
    end

    -- left
    nextPiece = self:getFirstPiece(i, j, 0, -1)
    if nextPiece ~= nil and nextPiece.piece ~= nil and nextPiece.piece.isWhite ~= white then
        if nextPiece.piece.pieceName == 'rook' or nextPiece.piece.pieceName == 'queen' then
            attackers[#attackers + 1] = nextPiece
        end
    end

    -- right
    nextPiece = self:getFirstPiece(i, j, 0, 1)
    if nextPiece ~= nil and nextPiece.piece ~= nil and nextPiece.piece.isWhite ~= white then
        if nextPiece.piece.pieceName == 'rook' or nextPiece.piece.pieceName == 'queen' then
            attackers[#attackers + 1] = nextPiece
        end
    end

    -- left top diagonal
    nextPiece = self:getFirstPiece(i, j, -1, -1)
    if nextPiece ~= nil and nextPiece.piece ~= nil and nextPiece.piece.isWhite ~= white then
        if nextPiece.piece.pieceName == 'bishop' or nextPiece.piece.pieceName == 'queen' then
            attackers[#attackers + 1] = nextPiece
        end
    end

    -- right top diagonal
    nextPiece = self:getFirstPiece(i, j, -1, 1)
    if nextPiece ~= nil and nextPiece.piece ~= nil and nextPiece.piece.isWhite ~= white then
        if nextPiece.piece.pieceName == 'bishop' or nextPiece.piece.pieceName == 'queen' then
            attackers[#attackers + 1] = nextPiece
        end
    end

    -- right bottom diagonal
    nextPiece = self:getFirstPiece(i, j, 1, 1)
    if nextPiece ~= nil and nextPiece.piece ~= nil and nextPiece.piece.isWhite ~= white then
        if nextPiece.piece.pieceName == 'bishop' or nextPiece.piece.pieceName == 'queen' then
            attackers[#attackers + 1] = nextPiece
        end
    end

    -- left bottom diagonal
    nextPiece = self:getFirstPiece(i, j, 1, -1)
    if nextPiece ~= nil and nextPiece.piece ~= nil and nextPiece.piece.isWhite ~= white then
        if nextPiece.piece.pieceName == 'bishop' or nextPiece.piece.pieceName == 'queen' then
            attackers[#attackers + 1] = nextPiece
        end
    end

    local movesX = {
        [1] = -2,
        [2] = -2,
        [3] = -1,
        [4] = 1,
        [5] = 2,
        [6] = 2,
        [7] = 1,
        [8] = -1,
    }
    
    local movesY = {
        [1] = -1,
        [2] = 1,
        [3] = 2,
        [4] = 2,
        [5] = 1,
        [6] = -1,
        [7] = -2,
        [8] = -2,
    }

    for k = 1, 8 do
        local x = i + movesX[k]
        local y = j + movesY[k]

        if isValid(x, y) then
            if self.board.board[x][y].piece ~= nil  and self.board.board[x][y].piece.pieceName == 'knight' and self.board.board[x][y].piece.isWhite ~= white  then
                attackers[#attackers + 1] = self.board.board[x][y]
            end
        end
    end

    if isKing then
        local movesX = {
            [1] = -1,
            [2] = -1,
            [3] = -1,
            [4] = 0,
            [5] = 0,
            [6] = 1,
            [7] = 1,
            [8] = 1,
        }
        
        local movesY = {
            [1] = -1,
            [2] = 0,
            [3] = 1,
            [4] = -1,
            [5] = 1,
            [6] = -1,
            [7] = 0,
            [8] = 1,
        }

        for k = 1, 8 do
            local x = i + movesX[k]
            local y = j + movesY[k]
    
            if isValid(x, y) then
                if self.board.board[x][y].piece ~= nil and self.board.board[x][y].piece.pieceName == 'king' and self.board.board[x][y].piece.isWhite ~= whitethen then
                    attackers[#attackers + 1] = self.board.board[x][y]
                end
            end
        end
    end

    return attackers
end

function PlayState:staleMate()
    for i = 1, 8 do
        for j = 1, 8 do
            if self.board.board[i][j].piece ~= nil and self.board.board[i][j].piece.isWhite == self.whiteTurn then
                local moves = self.board.board[i][j]:showMoves(self.board)

                for k, move in pairs(moves) do
                    self.board:move(move)
                    local attacker = self:inCheck(self.whiteTurn, true, 0, 0)
                    self.board:reverseMove(move)
                    if #attacker == 0 then
                        return false
                    end
                end
            end
        end
    end

    return true
end

function PlayState:checkMate(attackers)
    local white = self.whiteTurn

    local kMoves = nil

    local king = nil

    if white then
        king = WHITE_KING
        kMoves = self.board.board[WHITE_KING.x][WHITE_KING.y]:showMoves(self.board)
    else
        king = BLACK_KING
        kMoves = self.board.board[BLACK_KING.x][BLACK_KING.y]:showMoves(self.board)
    end

    for k, move in pairs(kMoves) do 
        self.board:move(move)
        local attacker = self:inCheck(self.whiteTurn, true, 0, 0)
        self.board:reverseMove(move)
        if #attacker == 0 then
            print(move.to.x)
            print(move.to.y)
            return false    
        end
    end

    if #attackers > 1 then
        return true
    end

    for i = 1, 8 do
        for j = 1, 8 do
            if self.board.board[i][j].piece ~= nil and self.board.board[i][j].piece.isWhite == white then
                local moves = self.board.board[i][j]:showMoves(self.board)

                for k, move in pairs(moves) do
                    self.board:move(move)
                    local attacker = self:inCheck(self.whiteTurn, true, 0, 0)
                    self.board:reverseMove(move)
                    if #attacker == 0 then
                        print(self.board.board[i][j].piece.pieceName)
                        return false
                    end
                end
            end
        end
    end

    return true
end