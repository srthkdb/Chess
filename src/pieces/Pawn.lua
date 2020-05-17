Pawn = Class{__includes = Piece}

function Pawn:init(isWhite)
    self.killed = false
    self.isWhite = isWhite
    self.firstMove = true
    self.pieceName = "pawn"
end

function Pawn:move()
    self.firstMove = false
end

function Pawn:showMoves(x, y, boar)
    local board = boar.board
    local moves = {}
    local dir = -1
    
    if self.isWhite then
        dir = 1
    end

    local next = nil
    if self.firstMove then
        next = x + dir
        if isValid(next,y) and board[next][y].piece == nil then
            moves[#moves + 1] = Move(board[x][y],board[next][y], self, false)
            next = next + dir
        end
        if isValid(next,y) and board[next][y].piece == nil then
            moves[#moves + 1] = Move(board[x][y],board[next][y], self, false)
        end
    else
        next = x + dir
        if isValid(next,y) and board[next][y].piece == nil then
            moves[#moves + 1] = Move(board[x][y],board[next][y], self, false)
        end
    end

    if isValid(x + dir, y + 1) and board[x + dir][y + 1].piece ~= nil and board[x + dir][y + 1].piece.isWhite ~= self.isWhite then
        moves[#moves + 1] = Move(board[x][y], board[x + dir][y + 1], self, true)
    end
    if isValid(x + dir, y - 1) and board[x + dir][y - 1].piece ~= nil and board[x + dir][y - 1].piece.isWhite ~= self.isWhite then
        moves[#moves + 1] = Move(board[x][y], board[x + dir][y - 1], self, true)
    end

    if enpassant ~= nil then
        if x == enpassant.x and y - 1 == enpassant.y then
            moves[#moves + 1] = Move(board[x][y], board[x + dir][y - 1], self, true)
        elseif x == enpassant.x and y + 1 == enpassant.y then
            moves[#moves + 1] = Move(board[x][y], board[x + dir][y + 1], self, true)
        end
    end

    return moves
end

function Pawn:render(x, y)
    if not self.killed then
        local texture = self.isWhite and gTextures['whitePawn'] or gTextures['blackPawn']
        love.graphics.draw(texture, x, y)
    end
end