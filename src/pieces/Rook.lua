Rook = Class{__includes = Piece}

function Rook:init(isWhite)
    self.killed = false
    self.isWhite = isWhite
    self.pieceName = "rook"
    self.canCastle = true
    self.castlingDone = false
end

function Rook:castle()
    self.castlingDone = true
    self.canCastle = false
end

function Rook:move()
    self.canCastle = false
end

function Rook:showMoves(i, j, boar)
    local board = boar.board
    local moves = {}
    local x = i
    local y = j

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

function Rook:render(x, y)
    local texture = self.isWhite and gTextures['whiteRook'] or gTextures['blackRook']
    love.graphics.draw(texture, x, y)
end