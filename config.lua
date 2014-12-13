




g_Worlds = {}





function LoadConfig(a_Path)
	local ConfigContent = cFile:ReadWholeFile(a_Path)
	local CfgLoader, Err = loadstring("return {" .. ConfigContent .. "}")
	if (not CfgLoader) then
		return false, "Error while loading config: " .. Err
	end
	
	local Succes, Result = pcall(CfgLoader)
	if (not Succes) then
		return false, "Error while loading config: " .. Err
	end
	
	local Root = cRoot:Get()
	for WorldName, WorldInfo in pairs(Result) do
		local World = Root:GetWorld(WorldName)
		if (World) then
			local Seed = GetSeedFromWorld(World)
			Seed = tonumber(Seed) or ConvertStringToNumber(Seed)
			if ((WorldInfo.Generator or ""):lower() == "floatingislands") then
				WorldInfo.Generator = cGeneratorFloatingIsland(Seed)
			else
				LOGWARNING("FloatingIslands: Unknown generator: \"" .. WorldInfo.Generator .. "\"")
			end
		else
			LOGWARNING("FloatingIslands: Config configures a non-existing world: \"" .. WorldName .. "\"")
		end
			
	end
	
	g_Worlds = Result
	return true
end