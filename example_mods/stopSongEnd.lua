local stopEnd = true
function onEndSong()
	-- Block the first countdown and start a timer of 0.8 seconds to play the dialogue
	if stopEnd and isStoryMode then
        --setProperty('inCutscene', true);
        --addLuaScript('dialogue')
		runTimer('farewell', 0.3)
		stopEnd = false;
		return Function_Stop;        
	end    
	return Function_Continue;
end