local songTable = {
    --song name inside json, text to display
    {'adagio', 'Adagio\n\nSong By: Spurk\nChart by: Armando The Anima'},
    {'ultra instinct', 'Ultra Instinct\n\nSong By: Tomz_\nChart by: Armando The Anima'},
   
    {'new-state', 'New State\n\nSong and Chart By: Armando The Anima'},
    
    {'bad-idea', 'Bad Idea\n\nSong By: Armando The Anima\nChart by: TheZoroForce240'},

    {'resistance', 'Resistance\n\nSong By: Armando The Anima\nChart by: TheZoroForce240'},

    {'fusion reactor', 'Fusion Reactor\n\nSong By: srPerez\nChart by: TheZoroForce240'},
    {'resplandor', 'Resplandor\n\nSong By: Armando The Anima\nChart by: RhysRJJ'},
}

function onSongStart()



    local text = 'no credits set'

    local songLower = string.lower(songName) --song in lowercase
    for i = 0,#songTable-1 do --loop through each song to find a match
        if songTable[i+1][1] == songLower then --if correct song
            text = songTable[i+1][2]
        end
    end

    makeLuaText('popupText', text, 390, 0, 0)
	setTextSize('popupText', 24)

    makeLuaSprite('popupBox', '', 0, 200)
	makeGraphic('popupBox', 400, getProperty('popupText.height')+10, '0xFF000000')
	setProperty('popupBox.y', -getProperty('popupBox.height'))
    screenCenter('popupBox', 'x')
	doTweenY('popup', 'popupBox', 0, 0.5, 'quantInOut')
	
	setObjectCamera('popupBox', 'hud')
	addLuaSprite('popupBox', true)
	setProperty('popupBox.alpha', 0.7)

    setProperty('popupText.x', getProperty('popupBox.x'))
    setProperty('popupText.y', getProperty('popupBox.y')+5)
    setTextAlignment('popupText', 'center')
    doTweenY('popupText', 'popupText', 5, 0.5, 'quantInOut')


	addLuaText('popupText')
	--doTweenX('popupText', 'popupText', 5, 0.5, 'quantInOut')	

    runTimer('popupEnd', 5)
end

function onTimerCompleted(tag, loops, loopsleft)
	if tag == 'popupEnd' then 
		doTweenY('popupEnd', 'popupBox', -getProperty('popupBox.height')-500, 0.5, 'quantInOut')
		doTweenY('popupTextEnd', 'popupText', -getProperty('popupBox.height')-500, 0.5, 'quantInOut')
	end
end