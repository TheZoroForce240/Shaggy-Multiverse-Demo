local stageData = {
	--name, x, y, scale, scroll factor
	{'bg2', -1300, -300, 1.5, 0.05},
	{'bg3', -650, 150, 1, 0.5},
	{'bg4', -650, 400, 1, 1},
	{'bgforeground', -1500, 300, 1.6, 1.7}
}

local bgFolder = 'mutated/'

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
	runHaxeCode("game.dad.shader = game.variables['bfColorSwap'].shader;")
	runHaxeCode("game.variables['bfColorSwap'].brightness = -0.25;")
end