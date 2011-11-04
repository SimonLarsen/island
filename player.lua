Player = {}
Player.__index = Player

function Player.create(x,y)
	local self = {}
	setmetatable(self,Player)

	self.x = x
	self.y = y
	self.rot = 0
	self.weapon = 0 -- shotgun

	return self
end

function Player:update(dt)
	local mx = love.mouse.getX()/SCALE
	local my = love.mouse.getY()/SCALE

	self.rot = math.atan2(my-self.y-5, mx-self.x+2)
end

function Player:draw()
	love.graphics.drawq(tiles,quadPlayer[0],self.x,self.y)

	love.graphics.drawq(tiles,quadWeapon[self.weapon],self.x+3,self.y+5,self.rot+math.pi,1,1,6,2.5)
end

function Player:shoot()
	table.insert(bullets,Bullet.create(self.x+2,self.y+5,self.rot))
end
