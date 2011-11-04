require("defines")

function love.update(dt)
	
end

function love.draw()
	love.graphics.scale(SCALE,SCALE)

	love.graphics.drawq(tiles,quadIsland,40,120)
	love.graphics.drawq(tiles,quadTree[0],119,109)
end

function love.load()
	loadResources()
	love.graphics.setMode(WIDTH*SCALE,HEIGHT*SCALE,false)
	love.graphics.setBackgroundColor(bgcolor)
end

function loadResources()
	bgcolor = {236,243,201}	
	tiles = love.graphics.newImage("res/bg.png")
	tiles:setFilter("nearest","nearest")

	quadIsland = love.graphics.newQuad(0,0,100,89,tiles:getWidth(),tiles:getHeight())

	quadTree = {}
	for	i=0,2 do
		quadTree[i] = love.graphics.newQuad(9*i,80,9,14,tiles:getWidth(),tiles:getHeight())
	end
end
