local stopEnd = true
function onEndSong()
	-- Block the first countdown and start a timer of 0.8 seconds to play the dialogue
	if stopEnd and isStoryMode then
        --setProperty('inCutscene', true);
        --addLuaScript('dialogue')
		runTimer('to be continued', 1)
		stopEnd = false;
		return Function_Stop;        
	end    
	return Function_Continue;
end
function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'to be continued' then 
		makeLuaSprite('tbc', 'introcards/tbc', 0, 0)
        setGraphicSize('tbc', 1280, 720)
        screenCenter('tbc')
        setObjectCamera('tbc', 'other')
        addLuaSprite('tbc', true)
		setProperty('tbc.alpha', 0)
		doTweenAlpha('tbc', 'tbc', 1, 1.5, 'expoOut')
		addLuaScript('endSongFFS')
        runTimer('endShit', 2.3)
	end
end