Player = {}
Player.__index = Player

local lg = love.graphics

function Player.create(x,y)
	local self = {}
	setmetatable(self,Player)

	self.x = x
	self.y = y
	self.rot = 0
	self.dir = 1 -- -1 = left, 1 = right
	self.walking = false
	self.jumping = 0
	self.yspeed = 0
	self.frame = 0
	self.weapon = 2 -- gun
	self.lastdmg = 0.05 -- saber damage spawn timer
	self.cooldown = 3

	return self
end

function Player:update(dt)
	self.rot = math.atan2(my-self.y-5.5, mx-self.x+0.5)

	local oldx,oldy
	oldx, oldy = self.x, self.y

	self.walking = false
	if love.keyboard.isDown("a") then
		self.x = self.x - PLAYER_SPEED*dt
		self.walking = true
		self.dir = -1
	end
	if love.keyboard.isDown("d") then
		self.x = self.x + PLAYER_SPEED*dt
		self.walking = true
		self.dir = 1
	end

	-- weapons logic
	self.cooldown = self.cooldown + dt
	if love.mouse.isDown("l") or self.weapon == 0 then
		self:shoot()
	end

	if self.walking == true then
		self.frame = (self.frame+dt*12)%6
	else
		self.frame = 5
	end

	if self:collidePlatforms() then
		self.x = oldx
	end

	self.y = self.y+self.yspeed*dt
	if self:collidePlatforms() then
		self.y = oldy
		if self.yspeed > 0 then self.jumping = 0 end
		self.yspeed = self.yspeed/2
	end

	self.yspeed = self.yspeed + GRAVITY*dt
end

function Player:shoot()
	-- lightsaber
	if self.weapon == 0 and self.cooldown > weapon_cooldown[0] then
		self.cooldown = 0
		table.insert(bullets,Damage.create(self.x+math.cos(self.rot)*11,self.y+5.5+math.sin(self.rot)*11,weapon_cooldown[0],1,1000))
		table.insert(bullets,Damage.create(self.x+math.cos(self.rot)*3,self.y+5.5+math.sin(self.rot)*3,weapon_cooldown[0],1,1000))
	-- gun
	elseif self.weapon == 1 and self.cooldown > weapon_cooldown[1] then
		self.cooldown = 0
		table.insert(bullets,Bullet.create(self.x,self.y+5.5,self.rot))
	-- shotgun
	elseif self.weapon == 2 and self.cooldown > weapon_cooldown[2] then
		self.cooldown = 0
		for i=0,4 do
			table.insert(bullets,Bullet.create(self.x,self.y+5.5,self.rot+(math.random()-0.5)/2))
		end
	-- uzi
	elseif self.weapon == 3 and self.cooldown > weapon_cooldown[3] then
		self.cooldown = 0
		table.insert(bullets,Bullet.create(self.x,self.y+5.5,self.rot+math.random()/2-0.25))
	-- bazooka
	elseif self.weapon == 4 and self.cooldown > weapon_cooldown[4] then
		self.cooldown = 0
		table.insert(bullets,Rocket.create(self.x,self.y+5.5,self.rot))
	-- grenade
	elseif self.weapon == 5 and self.cooldown > weapon_cooldown[5] then
		self.cooldown = 0
		table.insert(bullets,Grenade.create(self.x,self.y+5.5,self.rot))
	end
end

function Player:collidePlatforms()
	for i,v in ipairs(platforms) do
		if self:collidePlatform(v) then
			return true
		end
	end
	return false
end

function Player:collidePlatform(p)
	if self.x-2 > p.x+p.w
	or self.x+2 < p.x
	or self.y > p.y+p.h
	or self.y+13 < p.y then
		return false
	end
	return true
end

function Player:draw()
	local xsc = 1
	if self.dir == 1 then xsc = -1 end
	local fr = 0
	if self.walking then fr = math.floor(self.frame)+1 end

	lg.drawq(tiles,quadPlayer[fr],self.x,self.y,0,xsc,1,4,0)
	if self.weapon ~= 0 then -- gun
		lg.drawq(tiles,quadWeapon[self.weapon],self.x,self.y+6,self.rot,-1,-xsc,8,2.5)
	else -- lightsaber
		lg.drawq(tiles,quadWeapon[self.weapon],self.x,self.y+6,self.rot,-1,1,16,2.5)
	end
end

function Player:keypressed(k,unicode)
	if (k == "w" or k == ' ') and self.jumping < 2 then
		self.yspeed = -JUMP_POWER
		self.jumping = self.jumping + 1
	elseif unicode >= 48 and unicode <= 57 then
		if unicode-48 < NUM_WEAPONS then
			self.weapon = unicode-48
		end
	end
end

function Player:mousepressed(button)
	if button == 'wu' then
		self.weapon = (self.weapon+1)%NUM_WEAPONS
	elseif button == 'wd' then
		self.weapon = (self.weapon-1)%NUM_WEAPONS
	end
end
