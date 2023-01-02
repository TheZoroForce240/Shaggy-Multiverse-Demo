local stageData = {
	--name, x, y, scale, scroll factor
	{'1', -2000, -2050, 10, 0.05},
	{'2', -440, -500, 1.1, 0.4},
	{'4', -440, -650, 1.1, 0.55},
	{'3', -440, -650, 1.2, 0.85},
	{'5', -440, -650, 1.2, 1}
}

local bgFolder = 'fusionbg/'

function onCreate() --simple stage template

	for i = 0, #stageData-1 do 
		local name = stageData[i+1][1]
		makeLuaSprite(name, bgFolder..name, stageData[i+1][2], stageData[i+1][3]);
		setScrollFactor(name, stageData[i+1][5], stageData[i+1][5])
		scaleObject(name, stageData[i+1][4], stageData[i+1][4])
		updateHitbox(name)
		addLuaSprite(name, false);
	end



	
end

function onCreatePost()
	--close(true) 
	--luaDebugMode = true
	addHaxeLibrary('ColorSwap')
	--runHaxeCode("game.variables['bfColorSwap'] = new ColorSwap();")
	--runHaxeCode("game.boyfriend.shader = game.variables['bfColorSwap'].shader;")
	--runHaxeCode("game.variables['bfColorSwap'].brightness = -0.5;")
end