Board = Class{}

function Board:init()
    self:resetBoard()
    self.highlighted = {
        x = 1,
        y = 1
    }
end 

function Board:resetBoard()
    self.board = {}
    for i = 1, 8 do
        local row = {}
        for j = 1, 8 do
            row[j] = Box(i, j)
        end
        self.board[i] = row
    end
    --white pieces
    self.board[1][1]:setPiece('rook', true)
    self.board[1][2]:setPiece('knight', true)
    self.board[1][3]:setPiece('bishop', true)
    self.board[1][5]:setPiece('queen', true)
    self.board[1][4]:setPiece('king', true)
    self.board[1][6]:setPiece('bishop', true)
    self.board[1][7]:setPiece('knight', true)
    self.board[1][8]:setPiece('rook', true)

    self.board[2][1]:setPiece('pawn', true)
    self.board[2][2]:setPiece('pawn', true)
    self.board[2][3]:setPiece('pawn', true)
    self.board[2][4]:setPiece('pawn', true)
    self.board[2][5]:setPiece('pawn', true)
    self.board[2][6]:setPiece('pawn', true)
    self.board[2][7]:setPiece('pawn', true)
    self.board[2][8]:setPiece('pawn', true)
    --black pieces
    self.board[8][1]:setPiece('rook', false)
    self.board[8][2]:setPiece('knight', false)
    self.board[8][3]:setPiece('bishop', false)
    self.board[8][5]:setPiece('queen', false)
    self.board[8][4]:setPiece('king', false)
    self.board[8][6]:setPiece('bishop', false)
    self.board[8][7]:setPiece('knight', false)
    self.board[8][8]:setPiece('rook', false)

    self.board[7][1]:setPiece('pawn', false)
    self.board[7][2]:setPiece('pawn', false)
    self.board[7][3]:setPiece('pawn', false)
    self.board[7][4]:setPiece('pawn', false)
    self.board[7][5]:setPiece('pawn', false)
    self.board[7][6]:setPiece('pawn', false)
    self.board[7][7]:setPiece('pawn', false)
    self.board[7][8]:setPiece('pawn', false)
end

function Board:highlight(highlighted)
    self.board[self.highlighted.x][self.highlighted.y]:setHighlight(false)
    self.highlighted.x = highlighted.x
    self.highlighted.y = highlighted.y
    self.board[self.highlighted.x][self.highlighted.y]:setHighlight(true)
end

function Board:move(move)
    self.board[move.from.x][move.from.y] = Box(move.from.x, move.from.y)
    self.board[move.to.x][move.to.y].piece = move.from.piece

    

    if move.from.piece.pieceName == 'pawn' then
        if enpassant ~= nil and enpassant.y == move.to.y then
            if move.from.piece.isWhite then
                if enpassant.x +1 == move.to.x then
                    self.board[enpassant.x][enpassant.y] = Box(enpassant.x, enpassant.y)
                end
            else
                if enpassant.x - 1 == move.to.x then
                    self.board[enpassant.x][enpassant.y] = Box(enpassant.x, enpassant.y)
                end
            end
        end
    end

    if move.from.piece.pieceName == 'king' then
        if move.from.piece.isWhite then
            WHITE_KING = { x = move.to.x, y = move.to.y}
        else
            BLACK_KING = { x = move.to.x, y = move.to.y}
        end

        if math.abs(move.to.y - move.from.y) > 1 then
            print("castling")
            local mv = nil 
            if move.to.y < move.from.y then
                print("castling left")
                mv = Move(self.board[move.to.x][1], self.board[move.to.x][3],true,true,true)
                self:move(mv)
            else
                print("castling right")
                mv = Move(self.board[move.to.x][8], self.board[move.to.x][5],true,true,true)
                self:move(mv)
            end
        end
    end
end

function Board:reverseMove(move)
    self.board[move.from.x][move.from.y] = move.from
    self.board[move.to.x][move.to.y] = move.to

    if move.from.piece.pieceName == 'king' then
        if move.from.piece.isWhite then
            WHITE_KING = { x = move.from.x, y = move.from.y}
        else
            BLACK_KING = { x = move.from.x, y = move.from.y}
        end
    end
end

function Board:render()
    for i = 1, 8 do
        for j =1, 8 do
            self.board[i][j]:render()
        end
    end

end