local stageData = {
	--name, x, y, scale, scroll factor
	{'1', -1250, -150, 2, 1},
	{'2', -750, 150, 1.4, 1},
	{'3', -1000, -50, 1.6, 1}
}

local bgFolder = 'tiredbg/'

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
	
	addHaxeLibrary('ColorSwap')
	runHaxeCode("game.variables['bfColorSwap'] = new ColorSwap();")
	runHaxeCode("game.boyfriend.shader = game.variables['bfColorSwap'].shader;")
	runHaxeCode("game.variables['bfColorSwap'].brightness = -0.15;")
end