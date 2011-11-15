Shark = {}
Shark.__index = Shark

local lg = love.graphics

function Shark.create()
	local self = {}
	setmetatable(self,Shark)

	self.y = HEIGHT+78
	self.yspeed = math.random(-370,-350)

	self.x = math.random(-20,20)
	self.xspeed = math.random(20,100)
	if math.random(0,1) == 1 then -- left instead
		self.x = self.x + WIDTH
		self.xspeed = self.xspeed*-1
	end

	self.alive = true
	self.frame = 0

	self.colx = {}
	self.coly = {}
	self.hp = {}

	self.hp = 80

	self:update(0)

	return self
end

function Shark:update(dt)
	self.frame = (self.frame + dt*5) % 2

	self.x = self.x + self.xspeed*dt
	self.y = self.y + self.yspeed*dt

	self.yspeed = self.yspeed + GRAVITY*dt

	self.rot = math.atan2(-self.xspeed,self.yspeed)+math.pi/2

	local cx = math.cos(self.rot)
	local cy = math.sin(self.rot)

	for i=0,5 do
		self.colx[i] = self.x + cx*(i-2)*15
		self.coly[i] = self.y + cy*(i-2)*15 + 4
	end

	if self.y > WIDTH+100 and self.yspeed > 0 then
		self.alive = false
	end
end

function Shark:draw()
	local ysc = 1
	if self.xspeed < 0 then ysc = -1 end

	local fr = 2
	if self.yspeed < 0 and self.y > 170 then fr = math.floor(self.frame)
	elseif self.yspeed >= 0 and self.y > 80 then fr = math.floor(self.frame) end

	lg.drawq(tiles,quadShark[fr],self.x,self.y,self.rot,1,ysc,39,14)
end

function Shark:drawHitCircles()
	lg.setColor(0,255,0,255)
	for i=0,3 do
		lg.circle("fill",self.colx[i],self.coly[i],8,16)
	end
	lg.setColor(255,0,0,255)
	lg.circle("fill",self.colx[4],self.coly[4],8,16)

	lg.setColor(255,255,255,255)
end

function Shark:collideBullets(bullets)
	for i,v in ipairs(bullets) do
		hit, part = self:collideCircleBody(v.x,v.y,v.r)
		if hit then
			if part == 4 then self.hp = self.hp - 2*v.damage -- double damage to head
			else self.hp = self.hp - v.damage end

			if self.hp <= 0 then
				self:explode(part,v.xspeed,v.yspeed)
				self.alive = false
			end

			if blood_enabled then
				for i = 0,3 do
					table.insert(blood,BloodParticle.create(v.x,v.y,math.random()-0.5+math.atan2(v.yspeed,v.xspeed)))
				end
			end
			table.remove(bullets,i)

			return
		end
	end
end

function Shark:collidePlayer(pl)
	return self:collideCirclePart(pl.x+2.5,pl.y+3.5,2,4)
end

function Shark:collideCirclePart(x,y,r,part)
	if math.pow(x-self.colx[part], 2) + math.pow(y-self.coly[4], 2) < math.pow(10+r,2) then
		return true
	end
end

function Shark:collideCircleBody(x,y,r)
	local minr = math.pow(10+r,2)

	for i=0,4 do
		if math.pow(x-self.colx[i],2)+math.pow(y-self.coly[i],2) < minr then
			return true,i
		end
	end
end

function Shark:explode(part,xspeed,yspeed,hitx,hity)
	for i=0,4 do
		local xsp = xspeed
		local ysp = yspeed+math.random(-150,0)
		if i < part then
			xsp = xsp+math.random(-50,0)
		elseif i > part then
			xsp = xsp+math.random(0,50)
		else
			xsp = xsp+math.random(-50,50)
		end

		local rspd = math.random(-15,15)

		table.insert(particles,BodyPart.create(i,self.colx[i],self.coly[i],xsp,ysp,self.rot,rspd))
	end
end
