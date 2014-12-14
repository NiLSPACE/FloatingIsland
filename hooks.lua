




function AddHooks()
	cPluginManager:AddHook(cPluginManager.HOOK_CHUNK_GENERATING, OnChunkGenerating)
end




function OnChunkGenerating(a_World, a_ChunkX, a_ChunkZ, a_ChunkDesc)
	local WorldInf = g_Worlds[a_World:GetName()]
	if (not WorldInf) then
		return false
	end
	
	if (WorldInf.Generator and (type(WorldInf.Generator) == 'table')) then
		WorldInf.Generator:DoGenerate(a_World, a_ChunkX, a_ChunkZ, a_ChunkDesc)
	end
	
	if (WorldInf.AdditionalFinishers and (type(WorldInf.AdditionalFinishers) == 'table')) then
		for Idx, Finisher in ipairs(WorldInf.AdditionalFinishers) do
			Finisher:DoGenerate(a_World, a_ChunkX, a_ChunkZ, a_ChunkDesc)
		end
	end
end