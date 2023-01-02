function onStepHit()
    --luaDebugMode = true
    if curBeat < 704 and getProperty('startedCountdown') then
        for i = 0,getProperty('playerStrums.length')-1 do 
            setPropertyFromGroup('playerStrums', i, 'x', _G['defaultPlayerStrumX'..i]+getRandomInt(-2,2))
            setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i]+getRandomInt(-2,2))

            setPropertyFromGroup('opponentStrums', i, 'x', _G['defaultOpponentStrumX'..i]+getRandomInt(-2,2))
            setPropertyFromGroup('opponentStrums', i, 'y', _G['defaultOpponentStrumY'..i]+getRandomInt(-2,2))
        end
    end

    if curStep == 2816 then 
        triggerEvent('Change Character', 'dad', 'badshaggy')
        makeLuaSprite('blackBG', '', 0, 0)
        makeGraphic('blackBG', 2000/getProperty('defaultCamZoom'), 2000/getProperty('defaultCamZoom'), '0xFF000000')
        screenCenter('blackBG', 'xy')
        setObjectCamera('blackBG', 'hud')
        addLuaSprite('blackBG', true)
    end
    if curStep == 2884 then 
        doTweenAlpha('blackBG', 'blackBG', 0, crochet/125, 'quantInOut')
    end
    
end
function onCreatePost()
    addCharacterToList('badshaggy', 'dad')

    setProperty('camFollow.x', getProperty('camFollow.x')+400)
    setProperty('camFollow.y', getProperty('camFollow.y')-270)

    setProperty('camFollowPos.x', getProperty('camFollowPos.x')+400)
    setProperty('camFollowPos.y', getProperty('camFollowPos.y')-270)
end

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

		

