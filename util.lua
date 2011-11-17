local lg = love.graphics

function loadResources()
	colorset = {}
	colorset[0] = {}
	colorset[0][0] = {238,238,238}	
	colorset[0][1] = {182,182,182}	
	colorset[0][2] = {87,87,87}	
	colorset[0][3] = {22,22,22}	

	colorset[1] = {}
	colorset[1][0] = {236,243,201}	
	colorset[1][1] = {174,196,64}	
	colorset[1][2] = {61,100,39}	
	colorset[1][3] = {12,26,12}	

	tileset = {}
	tileset[0] = lg.newImage("res/tiles_bw.png")
	tileset[1] = lg.newImage("res/tiles_gb.png")
	tileset[0]:setFilter("nearest","nearest")
	tileset[1]:setFilter("nearest","nearest")

	current_theme = DEFAULT_TILESET
	tiles = tileset[current_theme]
	color = colorset[current_theme]
	lg.setBackgroundColor(color[0])

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

	quadBodyPart = {}
	-- shark parts
	for i=0,4 do
		quadBodyPart[i] = lg.newQuad(i*16,176,16,27,tiles:getWidth(),tiles:getHeight())
	end
	-- ninja parts
	quadBodyPart[5] = lg.newQuad(96,176,8,7,tiles:getWidth(),tiles:getHeight())
	quadBodyPart[6] = lg.newQuad(104,176,8,7,tiles:getWidth(),tiles:getHeight())

	quadNinja = {}
	for i=0,6 do
		quadNinja[i] = lg.newQuad(144+i*9,96,8,14,tiles:getWidth(),tiles:getHeight())
	end
	quadNinja[7] = lg.newQuad(208,96,14,14,tiles:getWidth(),tiles:getHeight())
end

function rescale()
	lg.setMode(WIDTH*SCALE,HEIGHT*SCALE)
	love.mouse.setVisible(false)
	love.mouse.setGrab(true)
end

function switchTheme()
	current_theme = (current_theme+1)%2
	tiles = tileset[current_theme]
	color = colorset[current_theme]
	lg.setBackgroundColor(color[0])
end
