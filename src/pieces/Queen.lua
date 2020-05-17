Queen = Class{__includes = Piece}

function Queen:init(isWhite)
    self.killed = false
    self.isWhite = isWhite
    self.pieceName = "queen"
end

function Queen:showMoves(i, j, boar)
    local board = boar.board
    local moves = {}
    local x = i
    local y = j

    for k = 1, 8 do
        x = i + k
        y = j + k
        if isValid(x, y) then
            if board[x][y].piece == nil then
                moves[#moves + 1] = Move(board[i][j],board[x][y], self, true)
            else
                if board[x][y].piece.isWhite ~= self.isWhite then
                    moves[#moves + 1] = Move(board[i][j],board[x][y], self, true)
                end
                break
            end
        else
            break
        end 
    end

    for k = 1, 8 do
        x = i - k
        y = j + k
        if isValid(x, y) then
            if board[x][y].piece == nil then
                moves[#moves + 1] = Move(board[i][j],board[x][y], self, true)
            else
                if board[x][y].piece.isWhite ~= self.isWhite then
                    moves[#moves + 1] = Move(board[i][j],board[x][y], self, true)
                end
                break
            end
        else
            break
        end 
    end

    for k = 1, 8 do
        x = i - k
        y = j - k
        if isValid(x, y) then
            if board[x][y].piece == nil then
                moves[#moves + 1] = Move(board[i][j],board[x][y], self, true)
            else
                if board[x][y].piece.isWhite ~= self.isWhite then
                    moves[#moves + 1] = Move(board[i][j],board[x][y], self, true)
                end
                break
            end
        else
            break
        end 
    end

    for k = 1, 8 do
        x = i + k
        y = j - k
        if isValid(x, y) then
            if board[x][y].piece == nil then
                moves[#moves + 1] = Move(board[i][j],board[x][y], self, true)
            else
                if board[x][y].piece.isWhite ~= self.isWhite then
                    moves[#moves + 1] = Move(board[i][j],board[x][y], self, true)
                end
                break
            end
        else
            break
        end 
    end

    for k = 1, 8 do
        x = i + k
        y = j
        if isValid(x, y) then
            if board[x][y].piece == nil then
                moves[#moves + 1] = Move(board[i][j],board[x][y], self, true)
            else
                if board[x][y].piece.isWhite ~= self.isWhite then
                    moves[#moves + 1] = Move(board[i][j],board[x][y], self, true)
                end
                break
            end
        else
            break
        end 
    end

    for k = 1, 8 do
        x = i - k
        y = j
        if isValid(x, y) then
            if board[x][y].piece == nil then
                moves[#moves + 1] = Move(board[i][j],board[x][y], self, true)
            else
                if board[x][y].piece.isWhite ~= self.isWhite then
                    moves[#moves + 1] = Move(board[i][j],board[x][y], self, true)
                end
                break
            end
        else
            break
        end 
    end

    for k = 1, 8 do
        x = i
        y = j + k
        if isValid(x, y) then
            if board[x][y].piece == nil then
                moves[#moves + 1] = Move(board[i][j],board[x][y], self, true)
            else
                if board[x][y].piece.isWhite ~= self.isWhite then
                    moves[#moves + 1] = Move(board[i][j],board[x][y], self, true)
                end
                break
            end
        else
            break
        end 
    end
    
    for k = 1, 8 do
        x = i
        y = j - k
        if isValid(x, y) then
            if board[x][y].piece == nil then
                moves[#moves + 1] = Move(board[i][j],board[x][y], self, true)
            else
                if board[x][y].piece.isWhite ~= self.isWhite then
                    moves[#moves + 1] = Move(board[i][j],board[x][y], self, true)
                end
                break
            end
        else
            break
        end 
    end
    
    return moves
end

function Queen:render(x, y)
    local texture = self.isWhite and gTextures['whiteQueen'] or gTextures['blackQueen']
    love.graphics.draw(texture, x + 3, y)
end