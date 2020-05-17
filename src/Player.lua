Player = Class{}

function Player:init(isHuman, isWhite)
    self.moves = {}
    self.isHuman = true
    self.isWhite = isWhite
end

function Player:addMove(move)
    self.moves[#self.moves + 1] = move
end