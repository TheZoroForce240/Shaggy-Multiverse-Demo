function onCreate()
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Bad Note' then
			local path = 'badnotes/BAD'
			if getPropertyFromClass('PlayState', 'mania') == 5 then --6k
				path = 'badnotes/BAD-6k'
			end
			setPropertyFromGroup('unspawnNotes', i, 'texture', path); --Change texture
			
		end
	end
end