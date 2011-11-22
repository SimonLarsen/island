local lg = love.graphics

function loadResources()
	tileset = {}
	tilesetdata = {}
	colorset = {}

	tilesdata = love.image.newImageData("res/tiles.png")
	tiles = lg.newImage(tilesdata)
	tiles:setFilter("nearest","nearest")
	createColors()

	current_theme = DEFAULT_TILESET
	lg.setBackgroundColor(color[0])

	rain = lg.newImage("res/rain.png")
	rain:setFilter("nearest","nearest")

	createQuads()

	platformset = {}
	platformset[1] = { {x=18,y=124,w=147,h=2} }
	platformset[2] = { {x=39,y=140,w=100,h=11},
					   {x=39,y=132,w=1, h=15 },
					   {x=138,y=127,w=2, h=17 } }
	rainingset = {false,true}
end

function createColors()
	color = {}
	for j = 0,3 do
		local r,g,b,a = tilesdata:getPixel(tilesdata:getWidth()-4+j,tilesdata:getHeight()-1)
		color[j] = {r,g,b}
	end
end

function createQuads()
	quadCross = lg.newQuad(208,119,7,7,tiles:getWidth(),tiles:getHeight())
	quadRain = lg.newQuad(0,0,WIDTH,HEIGHT,rain:getWidth(),rain:getHeight())

	-- Island level 
	quadIsland = lg.newQuad(0,96,148,85,tiles:getWidth(),tiles:getHeight())
	quadPoles = lg.newQuad(160,100,37,81,tiles:getWidth(),tiles:getHeight())
	quadTree = lg.newQuad(208,96,8,14,tiles:getWidth(),tiles:getHeight())
	quadTrailer = lg.newQuad(224,96,23,18,tiles:getWidth(),tiles:getHeight())
	-- Boat level
	quadBoatFront = lg.newQuad(96,64,102,26,tiles:getWidth(),tiles:getHeight())
	quadBoatBack = lg.newQuad(208,128,93,60,tiles:getWidth(),tiles:getHeight())

	quadPlayer = {}
	for	i = 0,6 do
		quadPlayer[i] = lg.newQuad(i*8,3,8,13,tiles:getWidth(),tiles:getHeight())
	end

	quadWeapon = {}
	quadWeapon[0] = lg.newQuad(0,27,16,5,tiles:getWidth(),tiles:getHeight())
	for	i = 1,NUM_WEAPONS-1 do
		quadWeapon[i] = lg.newQuad(i*16,16,16,6,tiles:getWidth(),tiles:getHeight())
	end
	quadRocket = lg.newQuad(64,27,5,5,tiles:getWidth(),tiles:getHeight())

	quadShark = {}
	for i=0,2 do
		quadShark[i] = lg.newQuad(i*80,32,78,28,tiles:getWidth(),tiles:getHeight())
	end

	quadBodyPart = {}
	-- shark parts
	for i=0,4 do
		quadBodyPart[i] = lg.newQuad(i*16,64,16,27,tiles:getWidth(),tiles:getHeight())
	end
	-- ninja parts
	quadBodyPart[5] = lg.newQuad(144,0,8,7,tiles:getWidth(),tiles:getHeight())
	quadBodyPart[6] = lg.newQuad(152,0,8,7,tiles:getWidth(),tiles:getHeight())

	quadNinja = {}
	for i=0,6 do
		quadNinja[i] = lg.newQuad(64+i*9,2,8,14,tiles:getWidth(),tiles:getHeight())
	end
	quadNinja[7] = lg.newQuad(128,3,14,14,tiles:getWidth(),tiles:getHeight())
end

function rescale()
	lg.setMode(WIDTH*SCALE,HEIGHT*SCALE)
	love.mouse.setVisible(false)
	love.mouse.setGrab(true)
end

function getOptimalScale()
	modes = lg.getModes()	
	max = 1
	for i,v in ipairs(modes) do
		max = math.max(max, math.floor(math.min(v.width/WIDTH, v.height/HEIGHT)))
	end
	return max
end
