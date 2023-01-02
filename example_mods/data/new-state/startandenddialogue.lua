local allowCountdown = false
function onStartCountdown()
	-- Block the first countdown and start a timer of 0.8 seconds to play the dialogue
	if not allowCountdown and not seenCutscene and isStoryMode then
        setProperty('inCutscene', true);
        addLuaScript('dialogue')
		allowCountdown = true;
		return Function_Stop;        
	end    
	addLuaScript('stopSongEnd')
	return Function_Continue;
end

function onTimerCompleted(tag, a, b)
	if tag == 'farewell' then 
		setProperty('inCutscene', true);
        addLuaScript('dialogue', true)
    end
end