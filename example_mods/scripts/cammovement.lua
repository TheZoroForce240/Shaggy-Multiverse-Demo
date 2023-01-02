

local curCamX = 0
local curCamY = 0

local camOffsetX = 0
local camOffsetY = 0

function onUpdatePost(elapsed)
    if not getProperty('isDead') then 
        setProperty('camFollow.x', curCamX + camOffsetX) 
        setProperty('camFollow.y', curCamY + camOffsetY) 
    end
end
function onCreatePost()
    curCamX = getProperty('camFollow.x')
    curCamY = getProperty('camFollow.y')
end

local maniaShit = {
    {2},
    {0,3},
    {0,2,3},
    {0,1,2,3},
    {0,1,2,2,3},
    {0,2,3,0,1,3},
    {0,2,3,2,0,1,3},
    {0,1,2,3,0,1,2,3},
    {0,1,2,3,2,0,1,2,3},
    {0,1,2,3,2,2,0,1,2,3},
    {0,1,2,3,2,2,2,0,1,2,3}
}
function goodNoteHit(id, direction, noteType, isSustainNote)
    if not isSustainNote then 
        camOffsetX = 0
        camOffsetY = 0
        local dir = maniaShit[getPropertyFromClass('PlayState', 'mania')+1][direction+1]
        if dir == 0 then 
            camOffsetX = -getProperty('boyfriend.height')/20
        elseif dir == 1 then 
            camOffsetY = getProperty('boyfriend.height')/20
        elseif dir == 2 then 
            camOffsetY = -getProperty('boyfriend.height')/20
        elseif dir == 3 then 
            camOffsetX = getProperty('boyfriend.height')/20
        end
    end
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
    if not isSustainNote then 
        camOffsetX = 0
        camOffsetY = 0
        local dir = maniaShit[getPropertyFromClass('PlayState', 'mania')+1][direction+1]
        if dir == 0 then 
            camOffsetX = -getProperty('dad.height')/20
        elseif dir == 1 then 
            camOffsetY = getProperty('dad.height')/20
        elseif dir == 2 then 
            camOffsetY = -getProperty('dad.height')/20
        elseif dir == 3 then 
            camOffsetX = getProperty('dad.height')/20
        end
    end
end

function onMoveCamera(char)
    curCamX = getProperty('camFollow.x')
    curCamY = getProperty('camFollow.y')
end