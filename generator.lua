



g_Patterns = 
{
	patGrass = {E_BLOCK_GRASS, E_BLOCK_DIRT, E_BLOCK_DIRT, E_BLOCK_DIRT}
}




function cGeneratorFloatingIsland(a_Seed)
	assert(type(a_Seed) == 'number')
	
	local m_Seed = a_Seed
	local self = {}
	
	function self:DoGenerate(a_World, a_ChunkX, a_ChunkZ, a_ChunkDesc)
		a_ChunkDesc:SetUseDefaultComposition(false)
		a_ChunkDesc:SetUseDefaultBiomes(false)
		a_ChunkDesc:SetUseDefaultHeight(false)
		
		local FullX = a_ChunkX * 16
		local FullZ = a_ChunkZ * 16
		
		for x = 0, 15, 1 do
			local xx = FullX + x
			for z = 0, 15, 1 do
				local zz = FullZ + z
				
				a_ChunkDesc:SetBiome(x, z, biPlains)
				
				local Noise1 = perlin_2d(xx / 20, zz / 20, m_Seed)
				
				if (Noise1 > 0) then
					local Noise2 = perlin_2d(zz / 10, xx / 10, m_Seed) * 25
					
					local MaxHeight = math.ceil(64 + Noise1 * (10 * (Noise1 + 1) ^ 1.5))
					local MinHeight = math.floor(55 - Noise2 + (((0.5 - Noise1) * 10) ^ 2))
					
					if (MaxHeight >= MinHeight) then
						a_ChunkDesc:SetHeight(x, z, MaxHeight)
					end
					
					MaxHeight = Clamp(MaxHeight, 0, 255)
					MinHeight = Clamp(MinHeight, 0, 255)
					
					local Pattern = g_Patterns.patGrass
					for I = MaxHeight, MinHeight, -1 do
						local Block = Pattern[MaxHeight - I + 1] or E_BLOCK_STONE
						a_ChunkDesc:SetBlockType(x, I, z, Block)
					end
				end
			end
		end
				
	end
	
	return self
end