-- Very important, this is used in the player equipped hats networked string. Shouldn't change this once set.
-- And only use strings.
item.unique = "5"

item.price = 250

if (CLIENT) then
	item.name = "No Entry Mask"
	item.model = Model("models/props_c17/streetsign004f.mdl")
	
	local scale = Vector(0.7, 0.7, 0.7)
	
	item.LayoutEntity = function(player, entity)
		local position, angles = vector_zero, angle_zero
		local attachment = player:LookupAttachment("eyes")
		
		entity:SetModelScale(scale)
		
		if (attachment != -1) then
			attachment = player:GetAttachment(attachment)
			position, angles = attachment.Pos, attachment.Ang
			
			position = position +(angles:Forward() *3)
			
			angles:RotateAroundAxis(angles:Up(), -90)
		end
		
		return entity, position, angles
	end
end