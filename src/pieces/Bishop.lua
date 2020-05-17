Bishop = Class{__includes = Piece}

function Bishop:init(isWhite)
    self.killed = false
    self.isWhite = isWhite
    self.pieceName = "bishop"
end

function Bishop:showMoves(i, j, boar)
    local moves = {}
    local x = i
    local y = j
    local board = boar.board
    for k = 1, 8 do
        x = i + k
        y = j + k
        if isValid(x, y) then
            if board[x][y].piece == nil then
                moves[#moves + 1] = Move(board[i][j], board[x][y], self, true)
            else
                if board[x][y].piece.isWhite ~= self.isWhite then
                    moves[#moves + 1] = Move(board[i][j], board[x][y], self, true)
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
                moves[#moves + 1] = Move(board[i][j], board[x][y], self, true)
            else
                if board[x][y].piece.isWhite ~= self.isWhite then
                    moves[#moves + 1] = Move(board[i][j], board[x][y], self, true)
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
                moves[#moves + 1] = Move(board[i][j], board[x][y], self, true)
            else
                if board[x][y].piece.isWhite ~= self.isWhite then
                    moves[#moves + 1] = Move(board[i][j], board[x][y], self, true)
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
                moves[#moves + 1] = Move(board[i][j], board[x][y], self, true)
            else
                if board[x][y].piece.isWhite ~= self.isWhite then
                    moves[#moves + 1] = Move(board[i][j], board[x][y], self, true)
                end
                break
            end
        else
            break
        end 
    end
    
    return moves
end

function Bishop:render(x, y)
    if not self.killed then
        local texture = nil
        if self.isWhite then
            texture = gTextures['whiteBishop']
        else
            texture = gTextures['blackBishop']
        end
        love.graphics.draw(texture, x, y)
    end
end