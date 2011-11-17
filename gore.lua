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
	--lg.setColor(color[3])
	lg.setColor(180,0,0,255)
	for i,v in ipairs(blood) do
		lg.circle("fill",v.x,v.y,v.radius,5)
	end
	lg.setColor(255,255,255,255)
end

BodyPart = {}
BodyPart.__index = BodyPart

function BodyPart.create(part,x,y,xspeed,yspeed,rot,rotspeed)
	local self = {}
	setmetatable(self,BodyPart)

	self.part = part
	self.x = x
	self.y = y
	self.xspeed = xspeed
	self.yspeed = yspeed
	self.rot = rot
	self.rotspeed = rotspeed
	self.alive = true
	self.nextblood = 0.05

	return self
end

function BodyPart:update(dt)
	self.x = self.x + self.xspeed*dt
	self.y = self.y + self.yspeed*dt
	self.yspeed = self.yspeed + GRAVITY*dt
	self.rot = self.rot + self.rotspeed*dt

	if blood_enabled then
		self.nextblood = self.nextblood - dt
		if self.nextblood < 0 then
			table.insert(blood,BloodParticle.create(self.x,self.y,self.rot))
			self.nextblood = 0.015
		end
	end

	if self.y > HEIGHT+30 then self.alive = false end
end

function BodyPart:draw()
	local ysc = 1
	if self.xspeed < 0 then ysc = -1 end

	if self.part < 5 then -- shark part
		lg.drawq(tiles,quadBodyPart[self.part],self.x,self.y,self.rot,1,ysc,8,13.5)
	else -- ninja part
		lg.drawq(tiles,quadBodyPart[self.part],self.x,self.y,self.rot,1,ysc,4,3.5)
	end
end
