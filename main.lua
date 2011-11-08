require("defines")
require("player")
require("bullet")

local lg = love.graphics

function love.load()
	math.randomseed(os.time())
	loadResources()
	lg.setMode(WIDTH*SCALE,HEIGHT*SCALE,false)
	lg.setBackgroundColor(color[0])

	love.mouse.setVisible(false)
	love.mouse.setGrab(true)

	pl = Player.create(68,90)

	bullets = {}

	platforms = { {x=40,y=123,w=100,h=1} }
				  --{x=87,y=109,w=17,h=1} }
end

function love.update(dt)
	mx = love.mouse.getX()/SCALE
	my = love.mouse.getY()/SCALE

	pl:update(dt)

	for	i,v in ipairs(bullets) do
		v:update(dt)
	end
end

function love.draw()
	lg.scale(SCALE,SCALE)

	lg.setColor(color[1])
	lg.rectangle("fill",0,146,180,54)

	lg.setColor(255,255,255,255)
	lg.drawq(tiles,quadIsland,40,120)
	lg.drawq(tiles,quadTree[0],119,109)
	lg.drawq(tiles,quadTree[0],65,109)

	lg.drawq(tiles,quadTrailer[0],84,106)

	-- draw bullets
	for	i,v in ipairs(bullets) do
		if v.alive then
			v:draw()
		else
			table.remove(bullets,i)
		end
	end

	-- Draw player
	pl:draw()

	lg.drawq(tiles,quadTree[0],53,111)

	-- Draw crosshair
	lg.drawq(tiles,quadCross,mx-3,my-3)
end

function love.keypressed(k,unicode)
	if k == "escape" then
		love.event.push("q")
	elseif k == "g" then
		love.mouse.setGrab(not love.mouse.isGrabbed())
		love.mouse.setVisible(not love.mouse.isVisible())
	end

	pl:keypressed(k)
end

function love.mousepressed(x,y,button)
	pl:shoot()		
end

function loadResources()
	color = {}
	color[0] = {236,243,201}	
	color[1] = {174,196,64}	
	color[2] = {61,100,39}	
	color[3] = {12,26,12}	

	tiles = lg.newImage("res/tiles.png")
	tiles:setFilter("nearest","nearest")

	quadIsland = lg.newQuad(0,0,100,89,tiles:getWidth(),tiles:getHeight())
	quadCross = lg.newQuad(64,105,7,7,tiles:getWidth(),tiles:getHeight())

	quadTree = {}
	for	i=0,2 do
		quadTree[i] = lg.newQuad(9*i,80,9,14,tiles:getWidth(),tiles:getHeight())
	end

	quadTrailer = {}
	for	i = 0,3 do
		quadTrailer[i] = lg.newQuad(32+i*24,80,24,18,tiles:getWidth(),tiles:getHeight())
	end

	quadPlayer = {}
	for	i = 0,6 do
		quadPlayer[i] = lg.newQuad(i*7,99,7,13,tiles:getWidth(),tiles:getHeight())
	end

	quadWeapon = {}
	for	i = 0,1 do
		quadWeapon[i] = lg.newQuad(i*16,112,11,5,tiles:getWidth(),tiles:getHeight())
	end
end
