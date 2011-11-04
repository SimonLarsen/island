require("defines")
require("player")
require("bullet")

local lg = love.graphics

function love.load()
	loadResources()
	lg.setMode(WIDTH*SCALE,HEIGHT*SCALE,false)
	lg.setBackgroundColor(color[0])

	pl = Player.create(68,111)

	bullets = {}
end

function love.update(dt)
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

	lg.drawq(tiles,quadTrailer[0],84,107)

	-- draw bullets
	for	i,v in ipairs(bullets) do
		v:draw()
	end

	-- Draw player
	pl:draw()

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

function love.mousepressed(x,y,button)
	pl:shoot()		
end
