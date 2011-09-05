GF.categories = {}

local itemFolders = file.FindInLua("../addons/goldenforge/lua/items/*")

if (CLIENT) then
	itemFolders = file.FindInLua("../lua_temp/items/*")
end

for k, v in pairs(itemFolders) do
	if (v != "." and v != ".." and v != ".svn") then
		category = {items = {}}
		
		if (SERVER) then
			AddCSLuaFile("items/" .. v .. "/__setup.lua")
			include("items/" .. v .. "/__setup.lua")

			local itemFiles = file.FindInLua("../addons/goldenforge/lua/items/" .. v .. "/*.lua")
		
			for k2, v2 in pairs(itemFiles) do
				if (v2 != "__setup.lua") then
					item = {}
					
					AddCSLuaFile("items/" .. v .. "/" .. v2)
					include("items/" .. v .. "/" .. v2)
					
					table.insert(category.items, item)
					
					item = nil
				end
			end
			
			GF.categories[category.position] = category
			
			category = nil
		elseif (CLIENT) then
			include("items/" .. v .. "/__setup.lua")
			
			local itemFiles = file.FindInLua("../lua_temp/items/" .. v .. "/*.lua")
		
			for k2, v2 in pairs(itemFiles) do
				if (v2 != "__setup.lua") then
					item = {}
					
					include("items/" .. v .."/" .. v2)
					
					table.insert(category.items, item)
					
					item = nil
				end
			end
			
			GF.categories[category.position] = category
			
			category = nil
		end
	end
end

----------------
--  UTILITIES --
----------------

GF.GetPlayers = player.GetAll

function GF:FindPlayer(name)
	if (!name) then return nil end
	
	name = string.lower(name)
	
	local output = {}

	for k, v in pairs(self.GetPlayers()) do
		if (string.lower(v:Nick()) == name) then
			return v
		end
		
		if (string.find(string.lower(v:Nick()), name)) then
			table.insert(output, v)
		end
	end
	
	if (#output == 1) then
		return output[1]
	elseif (#output > 1) then
		return false
	else
		return nil
	end
end

-------------------
--  PLAYER META	 --
-------------------

local meta = FindMetaTable("Player")

function meta:CanAffordScrapMetal(amount)
	return (CLIENT and self.scrapMetal >= amount) or (SERVER and self:GetScrapMetal() >= amount)
end