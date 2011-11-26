local lg = love.graphics

-- Level definitions
platformset = {}
platformset[1] = { {x=18,y=124,w=147,h=2} }
platformset[2] = { {x=39,y=140,w=100,h=11},
				   {x=39,y=132,w=1, h=15 },
				   {x=138,y=127,w=2, h=17 } }

rainingset = {false,true}
wavingset = {false,true}
startpoint = {{x=90,y=100},{x=90,y=100}}

function loadLevel(level)
	platforms = platformset[level]	
	raining = rainingset[level]
	waving = wavingset[level]
end

function drawLevel(level,front)
	if level == 1 then
		drawLevelIsland(front)
	elseif level == 2 then
		drawLevelBoat(front)
	end
end

function drawLevelIsland(front)
	if not front then
		-- Draw water
		lg.setColor(color[1])
		lg.rectangle("fill",0,146,180,54)

		lg.setColor(255,255,255,255)
		-- draw island
		lg.drawq(tiles,quadIsland,18,115)
		-- draw trailer
		lg.drawq(tiles,quadTrailer,67,106)
		-- draw back trees
		lg.drawq(tiles,quadTree,97,109)
		lg.drawq(tiles,quadTree,43,109)
	else
		-- draw front trees and poles
		lg.drawq(tiles,quadTree,31,111)
		lg.drawq(tiles,quadPoles,119,119)
	end
end

function drawLevelBoat(front)
	if not front then
		lg.translate(0,1+math.sin(2*weathertime))
		-- Draw water
		lg.setColor(color[1])
		lg.rectangle("fill",0,146,180,54)

		lg.setColor(255,255,255,255)
		lg.drawq(tiles,quadBoatBack,45,78)
	else
		lg.drawq(tiles,quadBoatFront,39,126)
	end
end
