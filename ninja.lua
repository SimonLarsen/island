BaseNinja = {}
BaseNinja.__index = BaseNinja

function BaseNinja:collidePlatforms()
	for i,v in ipairs(platforms) do
		if self:collidePlatform(v) then
			return true
		end
	end
	return false
end

function BaseNinja:collidePlatform(p)
	if self.x-2 > p.x+p.w
	or self.x+2 < p.x
	or self.y > p.y+p.h
	or self.y+14 < p.y then
		return false
	end
	return true
end

function BaseNinja:collideBullets(bullets,dt)
	for i,v in ipairs(bullets) do
		if self:collideRect(v.x-v.r,v.y-v.r,2*v.r,2*v.r) and v.alive then
			if blood_enabled then
				for i = 0,3 do
					table.insert(blood,BloodParticle.create(v.x,v.y,v.xspeed/2,v.yspeed/2))
				end
			end

			if v.static then self.hp = self.hp - v.damage*dt
			else self.hp = self.hp - v.damage end

			v:collide()
			if self.hp <= 0 then
				self:spawnParts(v)
				self.alive = false
				pl.money = pl.money + self.reward
				break
			end
		end
	end
end

function BaseNinja:collideRect(x,y,w,h)
	if x+w < self.x-2 or x > self.x+2
	or y+h < self.y or y > self.y+14 then
		return false
	end
	return true
end

Ninja = {reward = 30}
Ninja.__index = Ninja
setmetatable(Ninja,BaseNinja)

local lg = love.graphics

function Ninja.create()
	local self = {}
	setmetatable(self,Ninja)

	if math.random(0,1) == 0 then -- left
		self.x = WIDTH+4
		self.dir = -1
	else
		self. x = -4
		self.dir = 1
	end
	self.y = math.random(20,80)
	
	self.yspeed = 10

	self.state = 0
	self.hp = 50
	self.frame = 0
	self.alive = true
	-- states:
	--	0 = entering
	--	1 = walking
	--	2 = attacking
	self.cooldown = 0.25

	return self
end

function Ninja:update(dt)
	local oldy = self.y
	local oldx = self.x
	self.y = self.y + self.yspeed*dt
	self.yspeed = self.yspeed + GRAVITY*dt
	self.cooldown = self.cooldown - dt

	-- ENTERING STATE
	if self.state == 0 then
		if self:collidePlatforms() then
			self.y = oldy
			self.yspeed = self.yspeed/2
			self.state = 1
			self.cooldown = 0.25
		end

		self.x = self.x + NINJASPEED*dt*self.dir
	-- WALKING STATE
	elseif self.state == 1 then
		if self:collidePlatforms() then
			self.y = oldy
			self.yspeed = self.yspeed/2
		end

		local pldist = self.x-pl.x
		local abspldist = math.abs(pldist)
		local plydist = self.y - pl.y
		if abspldist > 40 then
			self.dir = pldist/-abspldist
		elseif abspldist < 20 and self.cooldown <= 0
		and math.abs(plydist) < 20 then
			self.state = 2
			self.cooldown = 0.25
		end

		if self.x-2 < platforms[1].x then
			self.dir = 1
		elseif self.x+2 > platforms[1].x+platforms[1].w then
			self.dir = -1
		end

		self.x = self.x + NINJASPEED*dt*self.dir
		self.frame = (self.frame+dt*18)%6
	-- ATTACKING STATE
	elseif self.state == 2 then
		self.y = oldy
		self.x = self.x + 1.5*NINJASPEED*dt*self.dir
		if self.cooldown <= 0 then
			self.state = 1
			self.cooldown = 0.25
		end
	end

	if self:collidePlatforms() then
		self.x = oldx
	end

	if self.y+10 > HEIGHT then
		self.alive = false
	end
end

function Ninja:collidePlayer(pl)
	if self.state == 2 then
		local hitx = self.x+self.dir*8
		local hity = self.y+6.5

		if hitx < pl.x-2 or hitx > pl.x+2
		or hity < pl.y or hity > pl.y+11 then
			return false
		end
		return true
	else
		return false
	end
end

function Ninja:spawnParts(v)
	table.insert(particles,BodyPart.create(5,self.x,self.y+2,v.xspeed*0.9,v.yspeed+math.random(-50,50),math.pi/2,math.random(-10,10)))
	table.insert(particles,BodyPart.create(7,self.x,self.y+2,v.xspeed*0.9,v.yspeed+math.random(-50,50),math.pi/2,math.random(-10,10)))
	table.insert(particles,BodyPart.create(6,self.x,self.y+9,v.xspeed*0.9,v.yspeed+math.random(-50,50),-math.pi/2,math.random(-10,10)))
end

function Ninja:draw()
	local xsc = 1
	if self.dir == 1 then xsc = -1 end

	if self.state == 0 then
		lg.drawq(tiles,quadNinja[6],self.x,self.y,0,xsc,1,4,0)
	elseif self.state == 1 then
		local fr = math.floor(self.frame)
		lg.drawq(tiles,quadNinja[fr],self.x,self.y,0,xsc,1,4,0)
	elseif self.state == 2 then
		lg.drawq(tiles,quadNinja[7],self.x,self.y,0,xsc,1,10,0)
	end
end

StarNinja = {reward = 50}
StarNinja.__index = StarNinja
setmetatable(StarNinja,BaseNinja)

function StarNinja.create()
	local self = {}
	setmetatable(self,StarNinja)

	if math.random(0,1) == 0 then -- left
		self.x = WIDTH+4
		self.dir = -1
	else
		self. x = -4
		self.dir = 1
	end
	self.y = math.random(20,80)
	
	self.yspeed = 10

	self.state = 0
	self.hp = 50
	self.frame = 0
	self.alive = true
	-- states:
	--	0 = entering
	--	1 = walking
	self.star = {x=-10,y=-10,xspeed=0,yspeed=0}
	self.cooldown = 2

	return self
end

function StarNinja:update(dt)
	local oldy = self.y
	local oldx = self.x
	self.y = self.y + self.yspeed*dt
	self.yspeed = self.yspeed + GRAVITY*dt
	self.cooldown = self.cooldown - dt

	-- ENTERING STATE
	if self.state == 0 then
		if self:collidePlatforms() then
			self.y = oldy
			self.yspeed = self.yspeed/2
			self.state = 1
		end
	-- WALKING STATE
	elseif self.state == 1 then
		if self:collidePlatforms() then
			self.y = oldy
			self.yspeed = self.yspeed/2
		end

		if self.x-2 < platforms[1].x then
			self.dir = 1
		elseif self.x+2 > platforms[1].x+platforms[1].w then
			self.dir = -1
		end

		self.frame = (self.frame+dt*18)%6
	--]]
	end

	self.x = self.x + NINJASPEED*dt*self.dir
	if self:collidePlatforms() then
		self.x = oldx
	end

	if self.y+10 > HEIGHT then
		self.alive = false
	end
	
	-- ninja star logic
	if self.cooldown <= 0 then
		self.star.x = self.x
		self.star.y = self.y+6
		self.cooldown = 2
		local pldist = math.sqrt(math.pow(pl.x-self.x,2)+math.pow(pl.y-self.y,2))
		self.star.xspeed = ((pl.x-self.x)/pldist)*150
		self.star.yspeed = ((pl.y-self.y)/pldist)*150
	end
	-- update star
	self.star.x = self.star.x + self.star.xspeed*dt
	self.star.y = self.star.y + self.star.yspeed*dt
end

function StarNinja:collidePlayer(pl)
	return pl:collideRect(self.star.x-1.5,self.star.y-1.5,3,3)
end

function StarNinja:spawnParts(v)
	table.insert(particles,BodyPart.create(5,self.x,self.y+2,v.xspeed*0.9,v.yspeed+math.random(-50,50),math.pi/2,math.random(-10,10)))
	table.insert(particles,BodyPart.create(6,self.x,self.y+9,v.xspeed*0.9,v.yspeed+math.random(-50,50),-math.pi/2,math.random(-10,10)))
end

function StarNinja:draw()
	local xsc = 1
	if self.dir == 1 then xsc = -1 end

	if self.state == 0 then
		lg.drawq(tiles,quadStarNinja[6],self.x,self.y,0,xsc,1,4,0)
	elseif self.state == 1 then
		local fr = math.floor(self.frame)
		lg.drawq(tiles,quadStarNinja[fr],self.x,self.y,0,xsc,1,4,0)
	end

	if self.star.x > -10 and self.star.y > -10 then
		lg.drawq(tiles,starQuad,self.star.x,self.star.y,0,1,1,1.5,1.5)
	end
end
