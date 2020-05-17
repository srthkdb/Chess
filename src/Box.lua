Box = Class{}

function Box:init(x, y, piece)
    self.x = x
    self.y = y
    self.piece = piece or nil
    self.isHighlighted = false
end

function Box:setHighlight(val)
    self.isHighlighted = val
end

function Box:setPiece(pieceName, isWhite)
    if(pieceName == 'rook') then
        self.piece = Rook(isWhite)
    elseif (pieceName == 'bishop') then
        self.piece = Bishop(isWhite)
    elseif (pieceName == 'knight') then
        self.piece = Knight(isWhite)
    elseif (pieceName == 'queen') then
        self.piece = Queen(isWhite)
    elseif (pieceName == 'king') then
        self.piece = King(isWhite)
    elseif (pieceName == 'pawn') then
        self.piece = Pawn(isWhite)
    else
        self.piece = nil
    end
end

function Box:showMoves(board)
    local moves = {}
    if self.piece ~= nil then
        moves = self.piece:showMoves(self.x, self.y, board)
    end
    return moves
end

function Box:render()
    if self.piece ~= nil then
        self.piece:render(offSetX + (self.y - 1) * BOX_WIDTH, offSetY + (self.x - 1) * BOX_HEIGHT)
    end

    if self.isHighlighted then
        love.graphics.setColor(1,0,0,1)
        love.graphics.rectangle('line',offSetX + (self.y - 1) * BOX_WIDTH, offSetY + (self.x - 1) * BOX_HEIGHT, BOX_WIDTH, BOX_HEIGHT)
        love.graphics.setColor(1,1,1,1)
    end
end
