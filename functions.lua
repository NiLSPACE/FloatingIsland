




function GetSeedFromWorld(a_World)
	local Path = a_World:GetIniFileName()
	local Ini = cIniFile()
	Ini:ReadFile(Path)
	return Ini:GetValue("Seed", "Seed")
end





function ConvertStringToNumber(a_String)
	assert(type(a_String) == 'string')
	local Num = ""
	for I = 1, a_String:len() do
		Num = Num .. string.byte(a_String:sub(I, I))
	end
	
	Num = tonumber(Num) or 1234567
	return Num
end





