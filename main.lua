require("defines")
require("player")
require("bullet")
require("shark")
require("tree")

local lg = love.graphics

function love.load()
	math.randomseed(os.time())
	loadResources()
	rescale() -- set window mode
	lg.setBackgroundColor(color[0])

	pl = Player.create(68,90)

	bullets = {}
	sharks = {}

	trees = {}
	table.insert(trees,Tree.create(119,109,false))
	table.insert(trees,Tree.create(65,109,false))
	table.insert(trees,Tree.create(53,111,true))

	platforms = { {x=40,y=123,w=100,h=1} }
				  --{x=87,y=109,w=17,h=1} }
	rainoffset = 0
	raining = false

	nextthunder = math.random(5,20)
	thundertime = 0.5
end

function love.update(dt)
	mx = love.mouse.getX()/SCALE
	my = love.mouse.getY()/SCALE

	pl:update(dt)

	if raining then
		rainoffset = (rainoffset + dt*RAINSPEED)%HEIGHT

		nextthunder = nextthunder - dt
		if nextthunder < 0 then
			thundertime = thundertime - dt	
			if thundertime < 0 then
				nextthunder = math.random(5,10)
				thundertime = 0.5
			end
		end
	end

	for	i,v in ipairs(bullets) do
		if v.alive then
			v:update(dt)
		else
			table.remove(bullets,i)
		end
	end

	for i,v in ipairs(sharks) do
		if v.alive then
			v:update(dt)
		else
			table.remove(sharks,i)
		end
	end

	-- Collision detection
	for i,v in ipairs(sharks) do
		if v:collidePlayer(pl) then
			-- Kill player or something
			print(dt)
		end
	end
end

function love.draw()
	lg.scale(SCALE,SCALE)

	lg.setColor(color[1])
	lg.rectangle("fill",0,146,180,54)

	lg.setColor(255,255,255,255)
	lg.drawq(tiles,quadIsland,40,120)
	-- draw trailer
	lg.drawq(tiles,quadTrailer[0],84,105)
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

	-- draw front trees
	for i,v in ipairs(trees) do
		v:draw(true)
	end

	-- draw enemies
	for i,v in ipairs(sharks) do
		v:draw()
	end

	-- Draw crosshair
	lg.drawq(tiles,quadCross,mx-3,my-3)

	-- draw rain
	if raining then
		if nextthunder < 0 then
			lg.setColor(255,255,255,math.random(0,128))
		else
			lg.setColor(255,255,255,128)
		end
		lg.drawq(rain,quadRain,0,rainoffset-HEIGHT)
		lg.drawq(rain,quadRain,0,rainoffset)
	end
end

function love.keypressed(k,unicode)
	if k == "escape" then
		love.event.push("q")
	elseif k == "g" then
		love.mouse.setGrab(not love.mouse.isGrabbed())
		love.mouse.setVisible(not love.mouse.isVisible())
	elseif k == 'r' then raining = not raining

	elseif k == 'f1' then SCALE = 1 rescale() 
	elseif k == 'f2' then SCALE = 2 rescale() 
	elseif k == 'f3' then SCALE = 3 rescale() 
	elseif k == 'f4' then SCALE = 4 rescale() 
	elseif k == 'f5' then SCALE = 5 rescale() 
	elseif k == 'f6' then SCALE = 6 rescale() 
	end

	pl:keypressed(k,unicode)

	if k == 'h' then
		table.insert(sharks,Shark.create(-1))
	end
end

function love.mousepressed(x,y,button)
	pl:mousepressed(button)
end

function loadResources()
	color = {}
	color[0] = {236,243,201}	
	color[1] = {174,196,64}	
	color[2] = {61,100,39}	
	color[3] = {12,26,12}	

	tiles = lg.newImage("res/tiles.png")
	tiles:setFilter("nearest","nearest")

	rain = lg.newImage("res/rain.png")
	rain:setFilter("nearest","nearest")

	quadIsland = lg.newQuad(0,0,100,89,tiles:getWidth(),tiles:getHeight())
	quadCross = lg.newQuad(64,105,7,7,tiles:getWidth(),tiles:getHeight())

	quadRain = lg.newQuad(0,0,WIDTH,HEIGHT,rain:getWidth(),rain:getHeight())

	quadTree = {}
	for	i=0,2 do
		quadTree[i] = lg.newQuad(8*i,80,8,14,tiles:getWidth(),tiles:getHeight())
	end

	quadTrailer = {}
	for	i = 0,3 do
		quadTrailer[i] = lg.newQuad(32+i*24,79,24,19,tiles:getWidth(),tiles:getHeight())
	end

	quadPlayer = {}
	for	i = 0,6 do
		quadPlayer[i] = lg.newQuad(i*7,99,7,13,tiles:getWidth(),tiles:getHeight())
	end

	quadWeapon = {}
	for	i = 0,3 do
		quadWeapon[i] = lg.newQuad(i*16,112,12,5,tiles:getWidth(),tiles:getHeight())
	end

	quadShark = {}
	for i=0,2 do
		quadShark[i] = lg.newQuad(i*80,128,78,28,tiles:getWidth(),tiles:getHeight())
	end
end

function rescale()
	lg.setMode(WIDTH*SCALE,HEIGHT*SCALE)
	love.mouse.setVisible(false)
	love.mouse.setGrab(true)
end
