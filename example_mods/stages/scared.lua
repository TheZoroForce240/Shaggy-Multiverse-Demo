local stageData = {
	--name, x, y, scale, scroll factor
	{'1', -540, -450, 1, 0.05},
	{'2', -540, -450, 1.1, 0.6},
	{'4', -540, -400, 1.1, 0.85},
	{'3', -540, -650, 1.2, 1}
}

local bgFolder = 'scaredbg/'

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
	runHaxeCode("game.variables['bfColorSwap'] = new ColorSwap();")
	runHaxeCode("game.boyfriend.shader = game.variables['bfColorSwap'].shader;")
	runHaxeCode("game.variables['bfColorSwap'].brightness = -0.5;")
end