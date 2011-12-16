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

	fontImage = lg.newImage("res/font.png")
	fontImage:setFilter("nearest","nearest")
	font = lg.newImageFont(fontImage," 0123456789abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ!-.,$")
	lg.setFont(font)
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
	quadBoatFront = lg.newQuad(96,64,102,28,tiles:getWidth(),tiles:getHeight())
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
	quadGrenade = lg.newQuad(80,27,5,5,tiles:getWidth(),tiles:getHeight())

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
	quadBodyPart[7] = lg.newQuad(144,9,8,7,tiles:getWidth(),tiles:getHeight())

	quadNinja = {}
	for i=0,6 do
		quadNinja[i] = lg.newQuad(64+i*9,2,8,14,tiles:getWidth(),tiles:getHeight())
	end
	quadNinja[7] = lg.newQuad(128,3,14,14,tiles:getWidth(),tiles:getHeight())

	quadStarNinja = {}
	for i=0,6 do
		quadStarNinja[i] = lg.newQuad(176+i*11,2,10,14,tiles:getWidth(),tiles:getHeight())
	end
	starQuad = lg.newQuad(157,13,3,3,tiles:getWidth(),tiles:getHeight())

	quadSmoke = {}
	for i=0,7 do
		quadSmoke[i] = lg.newQuad(128+i*16,16,16,16,tiles:getWidth(),tiles:getHeight())
	end

	quadExplosion = {}
	for i=0,7 do
		quadExplosion[i] = lg.newQuad(256+i*16,16,16,16,tiles:getWidth(),tiles:getHeight())
	end

	-- HUD stuff
	quadHeart = lg.newQuad(208,64,9,8,tiles:getWidth(),tiles:getHeight())
	quadNoHeart = lg.newQuad(224,64,9,8,tiles:getWidth(),tiles:getHeight())
	quadCoin = {}
	for i=0,3 do
		quadCoin[i] = lg.newQuad(240+i*8,64,6,9,tiles:getWidth(),tiles:getHeight())
	end
	quadHUDWeapon = {}
	for i=0,NUM_WEAPONS-1 do
		quadHUDWeapon[i] = lg.newQuad(480,0+i*16,32,16,tiles:getWidth(),tiles:getHeight())
	end
end

function rescale()
	lg.setMode(WIDTH*SCALE,HEIGHT*SCALE,false)
	love.mouse.setVisible(false)
	love.mouse.setGrab(true)
end

-- UNUSED. ONLY WORKS FOR FULLSCREEN MODES
function getOptimalScale()
	modes = lg.getModes()	
	max = 1
	for i,v in ipairs(modes) do
		max = math.max(max, math.floor(math.min(v.width/WIDTH, v.height/HEIGHT)))
	end
	return max
end
