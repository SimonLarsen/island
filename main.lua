require("defines")
require("levels")
require("util.lua")
require("player")
require("bullet")
require("effects")
require("shark")
require("ninja")
require("weather")

local lg = love.graphics

function love.load()
	math.randomseed(os.time())
	loadResources()
	SCALE = 3
	rescale() -- set window mode

	blood_enabled = true
	rainoffset = 0
	weathertime = 0
	nextthunder = math.random(5,20)
	thundertime = 0.5
	bullet_time = false
	coinframe = 0

	level = 1
	loadLevel(level)

	restart()
end

function respawn()
	pl:respawn()
end

function restart()
	pl = Player.create()
	bullets = {}
	enemies = {}
	particles = {}
	blood = {}
end

function love.update(dt)
	if dt > 0.1 then dt = 0.1 end

	mx = love.mouse.getX()/SCALE
	my = love.mouse.getY()/SCALE

	if coinframe > 0 then coinframe = coinframe - dt end

	if bullet_time then dt = dt/8 end
	-- everything below here will be affected by slow motion
	pl:update(dt)

	updateWeather(dt)

	for	i,v in ipairs(bullets) do
		if v.alive then
			v:update(dt)
		else
			table.remove(bullets,i)
		end
	end

	for i,v in ipairs(enemies) do
		if v.alive then
			v:update(dt)
		else
			table.remove(enemies,i)
		end
	end

	for i,v in ipairs(blood) do
		if v.alive then
			v:update(dt)
		else
			table.remove(blood,i)
		end
	end

	for i,v in ipairs(particles) do
		if v.alive then
			v:update(dt)
		else
			table.remove(particles,i)
		end
	end

	for i,v in ipairs(enemies) do
		if v:collidePlayer(pl) and pl.blinking <= 0 then
			pl:kill()
		end
		if v:collideBullets(bullets,dt) then

		end
	end
end

function love.draw()
	lg.scale(SCALE,SCALE)
	-- Draw level background
	drawLevel(level,false)

	-- draw bullets
	for	i,v in ipairs(bullets) do
		if v.alive then
			v:draw()
		end
	end

	-- Draw player
	pl:draw()

	-- Draw level front
	drawLevel(level,true)

	-- draw blood
	drawBlood()
	-- draw enemies
	for i,v in ipairs(enemies) do
		v:draw()
	end
	-- draw particles
	for i,v in ipairs(particles) do
		v:draw()
	end
	-- draw weather effects
	drawWeather()
	-- Draw crosshair
	lg.drawq(tiles,quadCross,mx-3,my-3)
	-- Draw HUD
	for i=0,2 do
		lg.drawq(tiles,quadNoHeart,10+i*11,10)
		if i < pl.lives then
			lg.drawq(tiles,quadHeart,10+i*11,10)
		end
	end
	if coinframe > 0 then
		lg.drawq(tiles,quadCoin[math.floor(10*coinframe)],69,9)
	else
		lg.drawq(tiles,quadCoin[0],69,9)
	end
	lg.printf(pl.money,77,9,100,"left")
	lg.drawq(tiles,quadHUDWeapon[pl.weapon],143,5)
end

function love.keypressed(k,unicode)
	if k == "escape" then
		love.event.push("q")
	elseif k == "g" then
		love.mouse.setGrab(not love.mouse.isGrabbed())
		love.mouse.setVisible(not love.mouse.isVisible())
	elseif k == 'r' then respawn()
	elseif k == 'return' then restart()
	elseif k == 'm' then raining = not raining
	-- rescaling
	elseif k == 'f1' then SCALE = 1 rescale() 
	elseif k == 'f2' then SCALE = 2 rescale() 
	elseif k == 'f3' then SCALE = 3 rescale() 
	elseif k == 'f4' then SCALE = 4 rescale() 
	elseif k == 'f5' then SCALE = 5 rescale() 
	elseif k == 'f6' then SCALE = 6 rescale() 

	-- selecting level
	elseif k == 'f9' then level = 1 loadLevel(level) respawn()
	elseif k == 'f10' then level = 2 loadLevel(level) respawn()
	
	-- debugging keys
	elseif k == 'h' then
		table.insert(enemies,Shark.create())
	elseif k == 'n' then
		table.insert(enemies,Ninja.create())
	elseif k == 'j' then
		table.insert(enemies,StarNinja.create())
	elseif k == 'b' then
		blood_enabled = not blood_enabled
	elseif k == 'lshift' then
		bullet_time = not bullet_time
	end

	pl:keypressed(k,unicode)
end

function love.mousepressed(x,y,button)
	pl:mousepressed(button)
end
