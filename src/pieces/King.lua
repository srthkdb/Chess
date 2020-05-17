King = Class{__includes = Piece}

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

function King:init(isWhite)
    self.killed = false
    self.isWhite = isWhite
    self.castlingDone = false
    self.canCastle = true
    self.pieceName = "king"
end

function King:castle()
    self.castlingDone = true
    self.canCastle = false
end

function King:move()
    self.canCastle = false
end

function King:showMoves(i, j, board)
    local moves = {}

    for k = 1, 8 do
        local x = i + movesX[k]
        local y = j + movesY[k]

        if isValid(x, y) then
            if board.board[x][y].piece == nil then
                moves[#moves + 1] = Move(board.board[i][j], board.board[x][y], self)
            elseif board.board[x][y].piece.isWhite ~= self.isWhite then
                moves[#moves + 1] = Move(board.board[i][j], board.board[x][y], self)
            end
        end
    end

    if self.canCastle then
        local castleR, castleL = true, true
        local leftR, rightR = nil, nil
        
        if self.isWhite then
            leftR = board.board[1][1]
            rightR = board.board[1][8]
        else
            leftR = board.board[8][1]
            rightR = board.board[8][8]
        end

        if leftR.piece ~= nil and leftR.piece.pieceName == 'rook' and leftR.piece.canCastle == true then
            castleL = true
        else
            castleL = false
        end

        if rightR.piece ~= nil and rightR.piece.pieceName == 'rook' and rightR.piece.canCastle == true then
            castleL = true
        else
            castleL = false
        end

        if castleL then
            for y = 2, j - 1 do
                if board.board[i][y].piece ~= nil then
                    castleL = false
                    break
                end
            end
        end

        if castleR then
            for y = j + 1, 7 do
                if board.board[i][y].piece ~= nil then
                    castleR = false
                    break
                end
            end
        end

        if castleL then
            moves[#moves + 1] = Move(board.board[i][j], board.board[i][j-2], self, 'left', true)
        end

        if castleR then
            moves[#moves + 1] = Move(board.board[i][j], board.board[i][j+2], self, 'right', true)
        end

    end

    return moves
end

function King:render(x, y)
    if not self.killed then
        local texture = nil
        if self.isWhite then
            texture = gTextures['whiteKing']
        else
            texture = gTextures['blackKing']
        end
        love.graphics.draw(texture, x+2, y)
    end
end