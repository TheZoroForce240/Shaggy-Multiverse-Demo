function onCreatePost()
	luaDebugMode = true
	runHaxeCode("game.variables['trail'] = new FlxTrail(game.dad, null, 4, 6, 0.3, 0.002);")

	--runHaxeCode("game.insert(game.members.indexOf(game.dadGroup), game.variables['trail']);") --layer below
	runHaxeCode("game.insert(game.members.indexOf(game.dadGroup)+1, game.variables['trail']);") --layer on top

	runHaxeCode("game.variables['trail'].visible = false;")
end
local trailActive = false
function onEvent(tag, val1, val2)

	if tag == 'Toggle Trail' then 
		trailActive = not trailActive
		runHaxeCode("game.variables['trail'].visible = "..tostring(trailActive)..";")
	elseif tag == 'Change Trail Length' then 
		runHaxeCode("game.variables['trail']._trailLength = 0;")
		runHaxeCode("game.variables['trail'].increaseLength("..tostring(val1)..");")
	elseif tag == 'Change Trail Delay' then 
		runHaxeCode("game.variables['trail'].delay = "..tostring(val1)..";")
	elseif tag == 'Change Trail Alpha' then 
		runHaxeCode("game.variables['trail']._transp = "..tostring(val1)..";")
		runHaxeCode("game.variables['trail'].increaseLength(0);") --refresh
	elseif tag == 'Change Trail Alpha Diff' then 
		runHaxeCode("game.variables['trail']._difference = "..tostring(val1)..";")
		runHaxeCode("game.variables['trail'].increaseLength(0);")
	end
end