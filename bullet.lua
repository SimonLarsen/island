Bullet = {}
Bullet.__index = Bullet

function Bullet.create(x,y,dir)
	local self = {}
	setmetatable(self,Bullet)

	self.x = x
	self.y = y

	self.xspeed = BULLET_SPEED*math.cos(dir)
	self.yspeed = BULLET_SPEED*math.sin(dir)

	return self
end

function Bullet:update(dt)
	self.x = self.x + self.xspeed*dt
	self.y = self.y + self.yspeed*dt
end

function Bullet:draw()
	love.graphics.setColor(0,0,0,255)
	love.graphics.rectangle("fill",self.x,self.y,1,1)
	love.graphics.setColor(255,255,255,255)
end
