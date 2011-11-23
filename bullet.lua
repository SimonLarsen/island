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
	self.timed = false

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

function Bullet:collide()
	self.alive = false	
end

function Bullet:draw()
	lg.setColor(0,0,0,255)
	lg.rectangle("fill",self.x,self.y,1,1)
	lg.setColor(255,255,255,255)
end

Rocket = {}
Rocket.__index = Rocket

function Rocket.create(x,y,rot)
	local self = {}
	setmetatable(self,Rocket)

	self.x,self.y = x,y
	self.xspeed = math.cos(rot)*ROCKET_SPEED
	self.yspeed = math.sin(rot)*ROCKET_SPEED
	self.rot = rot
	self.r = 1
	self.nextsmoke = 0.2
	self.damage = 100
	self.timed = false
	self.alive = true

	return self
end

function Rocket:update(dt)
	self.x = self.x + self.xspeed*dt + math.random(-20,20)*dt
	self.y = self.y + self.yspeed*dt + math.random(-20,20)*dt

	self.xspeed = self.xspeed + 5*self.xspeed*dt
	self.yspeed = self.yspeed + 5*self.yspeed*dt

	self.nextsmoke = self.nextsmoke - dt
	if self.nextsmoke <= 0 then
		self.nextsmoke = 0.04
		table.insert(particles,Smoke.create(self.x+math.random(-2,2)/2,self.y+math.random(-2,2)/2,0,0.4))
	end

	for i,v in ipairs(platforms) do
		if self:collidePlatform(v) then
			self:collide()
		end
	end

	if self.x < -5 or self.y < -5 or self.x > WIDTH+5 or self.y > HEIGHT+5 then
		self.alive = false
	end
end

function Rocket:collidePlatform(p)
	if self.x-1 > p.x+p.w
	or self.x+1 < p.x
	or self.y-1 > p.y+p.h
	or self.y+1 < p.y then
		return false
	end
	return true
end

function Rocket:collide()
	table.insert(bullets,Damage.create(self.x,self.y,0.5,14,300))
	for i=0,8 do
		table.insert(particles,Smoke.create(self.x+math.random(-15,15),self.y+math.random(-15,15),math.random(0,1),0.1+math.random()))
	end
	self.alive = false
end

function Rocket:draw()
	lg.drawq(tiles,quadRocket,self.x,self.y,self.rot,1,1,2.5,2.5)	
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
	self.timed = true

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

function Damage:collide()

end

function Damage:draw()
end

Grenade = {}
Grenade.__index = Grenade

function Grenade.create(x,y,dir)
	local self = {}
	setmetatable(self,Grenade)

	self.x = x
	self.y = y
	self.xspeed = math.cos(dir)*GRENADE_SPEED
	self.yspeed = math.sin(dir)*GRENADE_SPEED
	self.rot = dir
	self.alive = true
	self.r = 2
	self.timed = false
	self.damage = 100
	self.time = 2

	return self
end

function Grenade:update(dt)
	local oldx, oldy = self.x, self.y
	self.x = self.x + self.xspeed*dt
	if self:collidePlatforms() then
		self.x = oldx
		self.xspeed = self.xspeed*-0.5
	end

	self.y = self.y + self.yspeed*dt
	if self:collidePlatforms() then
		self.y = oldy
		self.yspeed = self.yspeed*-0.4
		self.xspeed = self.xspeed*0.6
	end

	self.yspeed = self.yspeed + GRAVITY*dt
	self.rot = math.atan2(self.yspeed,self.xspeed)

	self.time = self.time - dt
	if self.time <= 0 then
		self:collide()
	end

	if self.x < -2 or self.x > WIDTH+2 or
	self.y < -2 or self.y > HEIGHT+2 then
		self.alive = false
	end
end

function Grenade:draw()
	lg.drawq(tiles,quadGrenade,self.x,self.y,self.rot,1,1,2.5,2.5)
end

function Grenade:collidePlatforms()
	for i,v in ipairs(platforms) do
		if self:collidePlatform(v) then
			return true
		end
	end
	return false
end

function Grenade:collidePlatform(p)
	if self.x-1 > p.x+p.w
	or self.x+1 < p.x
	or self.y-1 > p.y+p.h
	or self.y+1 < p.y then
		return false
	end
	return true
end

function Grenade:collide()
	table.insert(bullets,Damage.create(self.x,self.y,0.5,14,300))
	for i=0,8 do
		table.insert(particles,Smoke.create(self.x+math.random(-15,15),self.y+math.random(-15,15),math.random(0,1),0.1+math.random()))
	end
	self.alive = false
end
