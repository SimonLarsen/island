require("defines")
require("util.lua")
require("player")
require("bullet")
require("gore")
require("shark")
require("ninja")
require("weather")
require("tree")

local lg = love.graphics

function love.load()
	math.randomseed(os.time())
	loadResources()
	rescale() -- set window mode
	lg.setBackgroundColor(color[0])

	trees = {}
	table.insert(trees,Tree.create(97,109,false))
	table.insert(trees,Tree.create(43,109,false))
	table.insert(trees,Tree.create(31,111,true))

	platforms = { {x=18,y=124,w=147,h=2} }
				 --{x=68,y=109,w=21,h=14} }
				 --
	raining = false
	blood_enabled = true
	rainoffset = 0
	nextthunder = math.random(5,20)
	thundertime = 0.5
	bullet_time = false

	restart()
end

function restart()
	pl = Player.create(54,90)

	bullets = {}
	enemies = {}
	particles = {}
	blood = {}
end

function love.update(dt)
	if bullet_time then dt = dt/8 end

	mx = love.mouse.getX()/SCALE
	my = love.mouse.getY()/SCALE

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
		if v:collidePlayer(pl) then
			-- Kill player or something
			print("Player hit " .. dt)
		end
		v:collideBullets(bullets)
	end
end

function love.draw()
	lg.scale(SCALE,SCALE)

	lg.setColor(color[1])
	lg.rectangle("fill",0,146,180,54)
	lg.setColor(255,255,255,255)

	-- draw island
	lg.drawq(tiles,quadIsland,18,115)
	-- draw trailer
	lg.drawq(tiles,quadTrailer[0],67,106)
	-- draw back trees
	for i,v in ipairs(trees) do
		v:draw(false)
	end
	-- draw bullets
	for	i,v in ipairs(bullets) do
		if v.alive then
			v:draw()
		end
	end
	-- Draw player
	pl:draw()
	-- draw front trees and poles
	for i,v in ipairs(trees) do
		v:draw(true)
	end
	lg.drawq(tiles,quadPoles,119,119)
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
end

function love.keypressed(k,unicode)
	if k == "escape" then
		love.event.push("q")
	elseif k == "g" then
		love.mouse.setGrab(not love.mouse.isGrabbed())
		love.mouse.setVisible(not love.mouse.isVisible())
	elseif k == 'r' then restart()
	elseif k == 'm' then raining = not raining

	elseif k == 'f1' then SCALE = 1 rescale() 
	elseif k == 'f2' then SCALE = 2 rescale() 
	elseif k == 'f3' then SCALE = 3 rescale() 
	elseif k == 'f4' then SCALE = 4 rescale() 
	elseif k == 'f5' then SCALE = 5 rescale() 
	elseif k == 'f6' then SCALE = 6 rescale() 
	
	-- debugging keys
	elseif k == 'h' then
		table.insert(enemies,Shark.create())
	elseif k == 'n' then
		table.insert(enemies,Ninja.create())
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
