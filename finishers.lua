




function cFinisherTrees(a_Seed)
	local m_Seed = a_Seed
	
	local m_TreeImage = cBlockArea()
	m_TreeImage:LoadFromSchematicFile(cPluginManager:GetCurrentPlugin():GetLocalFolder() .. "/treeimage.schematic")
	
	local SizeX = m_TreeImage:GetSizeX()
	local SizeZ = m_TreeImage:GetSizeZ()
	
	local HalfSizeX = math.floor(SizeX / 2)
	local HalfSizeZ = math.floor(SizeZ / 2)
	
	local MinX = 0  + HalfSizeX
	local MaxX = 15 - HalfSizeX
	
	local MinZ = 0  + HalfSizeZ
	local MaxZ = 15 - HalfSizeZ
	
	local self = {}
	
	-- Points the finisher will check so the trees won't generate directly next to each other.
	local m_PointsToCheck = {
		-- {-2, -2}, {-1, -2}, {0, -2}, {1, -2}, {2, -2},
		--[[{-2, -1}, ]]{-1, -1}, {0, -1}, {1, -1},-- {2, -1},
		--[[{-2,  0}, ]]{-1,  0},          {1,  0},-- {2,  0},
		--[[{-2,  1}, ]]{-1,  1}, {0,  1}, {1,  1},-- {2,  1},
		-- {-2,  2}, {-1,  2}, {0,  2}, {1,  2}, {2,  2},
	}
	function self:DoGenerate(a_World, a_ChunkX, a_ChunkZ, a_ChunkDesc)
		local FullX = a_ChunkX * 16
		local FullZ = a_ChunkZ * 16
		
		local CanSpawnCache = {}
		for x = MinX, MaxX, 1 do
			local xx = FullX + x
			for z = MinZ, MaxZ, 1 do
				local zz = FullZ + z
				
				local n = CanSpawnCache[x + 16 * z] or ((xx * xx) * (zz * zz) / 57 / 57) % 50
				CanSpawnCache[x + 16 * z] = n
				local N = 50
				
				-- Check if there could be trees
				for Idx, CoordInf in ipairs(m_PointsToCheck) do
					local X = xx - CoordInf[1]
					local Z = zz - CoordInf[2]
					
					local RelX = X - FullX
					local RelZ = Z - FullZ
					
					if (a_ChunkDesc:GetHeight(RelX, RelZ) ~= 0) then
						local tempN = CanSpawnCache[RelX + 16 * RelZ] or ((X * X) * (Z * Z) / 57 / 57) % 50
						if (N > tempN) then
							N = tempN
						end
						CanSpawnCache[RelX + 16 * RelZ] = tempN
					end
				end
				
				if ((n < N) and (n == 0)) then
					local Height = a_ChunkDesc:GetHeight(x, z)
					if (Height ~= 0) then
						local BlockArea = cBlockArea()
						a_ChunkDesc:ReadBlockArea(
							BlockArea,
							x - HalfSizeX, x + HalfSizeX,
							Height + 1, Height + m_TreeImage:GetSizeY() + 1,
							z - HalfSizeZ, z + HalfSizeZ
						)
						
						BlockArea:Merge(m_TreeImage, 0, 0, 0, cBlockArea.msSpongePrint)
						a_ChunkDesc:WriteBlockArea(BlockArea, x - HalfSizeZ, Height + 1, z - HalfSizeZ)
					end
				end
			end
		end
		
		a_ChunkDesc:UpdateHeightmap()
	end
	
	return self
end