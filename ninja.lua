Ninja = {}
Ninja.__index = Ninja

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

function Ninja:collidePlatforms()
	for i,v in ipairs(platforms) do
		if self:collidePlatform(v) then
			return true
		end
	end
	return false
end

function Ninja:collidePlatform(p)
	if self.x-2 > p.x+p.w
	or self.x+2 < p.x
	or self.y > p.y+p.h
	or self.y+14 < p.y then
		return false
	end
	return true
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

function Ninja:collidePlayer(pl)
	return false	
end

function Ninja:collideBullets(bullets)
	for i,v in ipairs(bullets) do
		if self:collideRect(v.x-v.r,v.y-v.r,2*v.r,2*v.r) then
			if blood_enabled then
				for i = 0,3 do
					table.insert(blood,BloodParticle.create(v.x,v.y,math.random()-0.5+math.atan2(v.yspeed,v.xspeed)))
				end
			end
			self.hp = self.hp - v.damage
			if self.hp <= 0 then
				self.alive = false
			end
			table.remove(bullets,i)
		end
	end
end

function Ninja:collideRect(x,y,w,h)
	if x+w < self.x-2 or x > self.x+2
	or y+h < self.y or y > self.y+14 then
		return false
	end
	return true
end
