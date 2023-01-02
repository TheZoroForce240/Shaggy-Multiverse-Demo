local allowCountdown = false
function onStartCountdown()
	-- Block the first countdown and start a timer of 0.8 seconds to play the dialogue
	if not allowCountdown and not seenCutscene and isStoryMode then
        setProperty('inCutscene', true);
        addLuaScript('dialogue')
		allowCountdown = true;
		return Function_Stop;        
	end    
	return Function_Continue;
end