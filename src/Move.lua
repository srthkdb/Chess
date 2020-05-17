Move = Class{}

function Move:init(from, to, piece, castleSide, castle)
    self.from = Box(from.x, from.y, from.piece)
    self.to = Box(to.x, to.y, to.piece)
    self.castle = castle or false
    self.castleSide = castleSide or 'none'
end