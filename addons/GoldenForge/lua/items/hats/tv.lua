-- Very important, this is used in the player equipped hats networked string. Shouldn't change this once set.
-- And only use strings.
item.unique = "11"

item.price = 900

if (CLIENT) then
	item.name = "TV"
	item.model = Model("models/props_c17/tv_monitor01.mdl")
	
	local scale = Vector(0.8, 0.8, 0.8)
	
	item.LayoutEntity = function(player, entity)
		local position, angles = vector_zero, angle_zero
		local attachment = player:LookupAttachment("eyes")
		
		entity:SetModelScale(scale)
		
		if (attachment != -1) then
			attachment = player:GetAttachment(attachment)
			position, angles = attachment.Pos, attachment.Ang

			position = position -(angles:Right() *2) -(angles:Forward() *3) +(angles:Up() *0.5)
		end
		
		return entity, position, angles
	end
end