Tree = {}
Tree.__index = Tree

function Tree.create(x,y,front)
	local self = {}
	setmetatable(self,Tree)

	self.x = x
	self.y = y
	self.front = front
	self.health = 20
	self.alive = true

	return self
end

function Tree:draw(front)
	if self.front == front then
		love.graphics.drawq(tiles,quadTree[math.floor(self.health/10)],self.x,self.y)
	end
end
