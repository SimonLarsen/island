BloodParticle = {}
BloodParticle.__index = BloodParticle

local lg = love.graphics

function BloodParticle.create(x,y,rot)
	local self = {}
	setmetatable(self,BloodParticle)

	self.x = x
	self.y = y
	self.xspeed = math.cos(rot)*150+math.random(-20,20)
	self.yspeed = math.sin(rot)*150+math.random(-20,20)
	self.radius = math.random()

	self.alive = true
	self.time = 0

	return self
end

function BloodParticle:update(dt)
	self.time = self.time + dt

	self.x = self.x + self.xspeed*dt
	self.y = self.y + self.yspeed*dt

	self.xspeed = self.xspeed
	self.yspeed = self.yspeed + GRAVITY*dt

	if self.x < -1 or self.x > WIDTH+1
	or self.y < -1 or self.y > HEIGHT+1 or self.time > 5 then
		self.alive = false
	end
end

function drawBlood()
	lg.setColor(color[3])
	for i,v in ipairs(blood) do
		lg.circle("fill",v.x,v.y,v.radius,5)
	end
	lg.setColor(255,255,255,255)
end
