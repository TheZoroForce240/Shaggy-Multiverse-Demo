local allowCountdown = false
function onStartCountdown()
	-- Block the first countdown and start a timer of 0.8 seconds to play the dialogue
	if not allowCountdown and not seenCutscene and isStoryMode then
        setProperty('inCutscene', true);
        addLuaScript('dialogue')
		allowCountdown = true;
		return Function_Stop;        
	end    
	addLuaScript('tbc')
	return Function_Continue;
end
function onCreatePost()
    setProperty('camFollow.y', getProperty('camFollow.y')+400)
    setProperty('camFollowPos.y', getProperty('camFollowPos.y')+400)
end