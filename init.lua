
g_Plugin = nil;





function Initialize(a_Plugin)
	g_Plugin = a_Plugin
	a_Plugin:SetName("FloatingIslands")
	a_Plugin:SetVersion(1)
	
	local Succes, Err = LoadConfig(a_Plugin:GetLocalFolder() .. "/config.cfg")
	if (not Succes) then
		LOGWARNING(Err)
	end
	
	AddHooks()
	return true
end