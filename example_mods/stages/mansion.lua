



function onCreate()

	makeLuaSprite('bg', 'bg_lemon', -400, -160);
	--manual setgraphicsize because psych forces an updatehitbox fuck you
	local width = math.floor(getProperty('bg.width') * 1.5)	
	setProperty('bg.scale.x', width/getProperty('bg.frameWidth'))
	setProperty('bg.scale.y', width/getProperty('bg.frameWidth'))
	
	setScrollFactor('bg', 0.95, 0.95)
	--updateHitbox('bg')
	addLuaSprite('bg', false);

	--close(true) 
end