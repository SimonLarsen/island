local lg = love.graphics

function updateWeather(dt)
	weathertime = weathertime + dt
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
end

function drawWeather()
	if raining then
		if nextthunder < 0 then
			lg.setColor(255,255,255,math.random(0,128))
		else
			lg.setColor(255,255,255,128)
		end
		lg.drawq(rain,quadRain,0,rainoffset-HEIGHT)
		lg.drawq(rain,quadRain,0,rainoffset)
		lg.setColor(255,255,255,255)
	end
end
