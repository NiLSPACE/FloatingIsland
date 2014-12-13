




function AddHooks()
	cPluginManager:AddHook(cPluginManager.HOOK_CHUNK_GENERATING, OnChunkGenerating)
end




function OnChunkGenerating(a_World, a_ChunkX, a_ChunkZ, a_ChunkDesc)
	local WorldInf = g_Worlds[a_World:GetName()]
	if (not WorldInf or (not type(WorldInf.Generator) == 'function')) then
		return false
	end
	
	WorldInf.Generator:DoGenerate(a_World, a_ChunkX, a_ChunkZ, a_ChunkDesc)
end