




function cFinisherTrees(a_Seed)
	local m_Seed = a_Seed
	
	local m_TreeImage = cBlockArea()
	m_TreeImage:LoadFromSchematicFile(cPluginManager:GetCurrentPlugin():GetLocalFolder() .. "/treeimage.schematic")
	
	local SizeX = m_TreeImage:GetSizeX()
	local SizeZ = m_TreeImage:GetSizeZ()
	
	local MinX = 0  + math.floor(SizeX / 2)
	local MaxX = 15 - math.floor(SizeX / 2)
	
	local MinZ = 0  + math.floor(SizeZ / 2)
	local MaxZ = 15 - math.floor(SizeZ / 2)
	
	local self = {}
	
	function self:DoGenerate(a_World, a_ChunkX, a_ChunkZ, a_ChunkDesc)
		local FullX = a_ChunkX * 16
		local FullZ = a_ChunkZ * 16
		
		for x = MinX, MaxX, 1 do
			local xx = FullX + x
			for z = MinZ, MaxZ, 1 do
				local zz = FullZ + z
				
				local n = (xx * xx) * (zz * zz) / 57 / 57
				if (n % 50 == 0) then
					local Height = a_ChunkDesc:GetHeight(x, z)
					if (Height ~= 0) then
						local BlockArea = cBlockArea()
						a_ChunkDesc:ReadBlockArea(
							BlockArea,
							x - SizeX / 2, x + SizeX / 2,
							Height + 1, Height + m_TreeImage:GetSizeY() + 1,
							z - SizeZ / 2, z + SizeZ / 2
						)
						
						BlockArea:Merge(m_TreeImage, 0, 0, 0, cBlockArea.msSpongePrint)
						a_ChunkDesc:WriteBlockArea(BlockArea, x - SizeX / 2, Height + 1, z - SizeX / 2)
					end
				end
			end
		end
	end
	
	return self
end