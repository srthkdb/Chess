Knight = Class{__includes = Piece}

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

function Knight:init(isWhite)
    self.killed = false
    self.isWhite = isWhite
    self.pieceName = "knight"
end

function Knight:showMoves(i, j, boar)
    local moves = {}
    local board = boar.board
    for k = 1, 8 do
        local x = i + movesX[k]
        local y = j + movesY[k]

        if isValid(x, y) then
            if board[x][y].piece == nil then
                moves[#moves + 1] = Move(board[i][j], board[x][y], self, true)
            elseif board[x][y].piece.isWhite ~= self.isWhite then
                moves[#moves + 1] = Move(board[i][j], board[x][y], self, true)
            end
        end
    end

    return moves
end

function Knight:render(x, y)
    if not self.killed then
        local texture = self.isWhite and gTextures['whiteKnight'] or gTextures['blackKnight']
        love.graphics.draw(texture, x, y)
    end
end