local lg = love.graphics

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

	createQuads()
end

function createQuads()
	quadIsland = lg.newQuad(0,0,148,85,tiles:getWidth(),tiles:getHeight())
	quadPoles = lg.newQuad(160,4,37,81,tiles:getWidth(),tiles:getHeight())
	quadCross = lg.newQuad(64,121,7,7,tiles:getWidth(),tiles:getHeight())

	quadRain = lg.newQuad(0,0,WIDTH,HEIGHT,rain:getWidth(),rain:getHeight())

	quadTree = {}
	for	i=0,2 do
		quadTree[i] = lg.newQuad(8*i,96,8,14,tiles:getWidth(),tiles:getHeight())
	end

	quadTrailer = {}
	for	i = 0,3 do
		quadTrailer[i] = lg.newQuad(32+i*24,96,23,18,tiles:getWidth(),tiles:getHeight())
	end

	quadPlayer = {}
	for	i = 0,6 do
		quadPlayer[i] = lg.newQuad(i*8,115,8,13,tiles:getWidth(),tiles:getHeight())
	end

	quadWeapon = {}
	quadWeapon[0] = lg.newQuad(0,139,16,5,tiles:getWidth(),tiles:getHeight())
	for	i = 1,3 do
		quadWeapon[i] = lg.newQuad(i*16,128,16,5,tiles:getWidth(),tiles:getHeight())
	end

	quadShark = {}
	for i=0,2 do
		quadShark[i] = lg.newQuad(i*80,144,78,28,tiles:getWidth(),tiles:getHeight())
	end

	quadSharkPart = {}
	for i=0,4 do
		quadSharkPart[i] = lg.newQuad(i*16,176,16,27,tiles:getWidth(),tiles:getHeight())
	end
end

function rescale()
	lg.setMode(WIDTH*SCALE,HEIGHT*SCALE)
	love.mouse.setVisible(false)
	love.mouse.setGrab(true)
end
