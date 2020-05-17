Piece = Class{}

function Piece:init()end

function Piece:kill()
    self.killed = true
    --play sound
end

function Piece:move() end

function Piece:render() end