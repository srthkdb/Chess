function kingInCheck(board, isWhite)
    for i = 1, 8 do
        for j = 1, 8 do
            if board.board[i][j].piece ~= nil and board.board[i][j].piece.isWhite ~= isWhite then
                local moves = board.board[i][j]:showMoves(board)
                for k, move in pairs(moves) do
                    if board.board[move.to.x][move.to.y].piece ~= nil and board.board[move.to.x][move.to.y].piece.pieceName == 'king' and move.canKill then
                        return true
                    end
                end
            end
        end
    end

    return false
end


function isValid(x,y)
    return x >= 1 and x <= 8 and y >= 1 and y <= 8
end

