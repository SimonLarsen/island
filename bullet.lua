Bullet = {}
Bullet.__index = Bullet

local lg = love.graphics

function Bullet.create(x,y,dir)
	local self = {}
	setmetatable(self,Bullet)

	self.alive = true
	self.x = x
	self.y = y
	self.r = 0.5
	self.damage = 10

	self.xspeed = BULLET_SPEED*math.cos(dir)
	self.yspeed = BULLET_SPEED*math.sin(dir)

	return self
end

function Bullet:update(dt)
	self.x = self.x + self.xspeed*dt
	self.y = self.y + self.yspeed*dt

	if self.x < 0 or self.y < 0 or self.x > WIDTH or self.y > HEIGHT then
		self.alive = false
	end
end

function Bullet:draw()
	lg.setColor(0,0,0,255)
	lg.rectangle("fill",self.x,self.y,1,1)
	lg.setColor(255,255,255,255)
end

Damage = {}
Damage.__index = Damage

function Damage.create(x,y,time,r,dmg)
	local self = {}
	setmetatable(self,Damage)

	self.x = x
	self.y = y
	self.r = r
	self.xspeed, self.yspeed = 0, 0
	self.damage = dmg

	self.time = time
	self.alive = true

	return self
end

function Damage:update(dt)
	self.time = self.time - dt
	if self.time <= 0 then
		self.alive = false
	end
end

function Damage:draw()
end
