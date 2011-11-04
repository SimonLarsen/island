Player = {}
Player.__index = Player

function Player.create(x,y)
	local self = {}
	setmetatable(self,Player)

	return self
end
