-- Very important, this is used in the player equipped hats networked string. Shouldn't change this once set.
-- And only use strings.
item.unique = "8"

item.price = 500

if (CLIENT) then
	item.name = "Lampshade Hat"
	item.model = Model("models/props_c17/lampShade001a.mdl")
	
	local scale = Vector(0.6, 0.6, 0.6)
	
	item.LayoutEntity = function(player, entity)
		local position, angles = vector_zero, angle_zero
		local attachment = player:LookupAttachment("eyes")
		
		entity:SetModelScale(scale)
		
		if (attachment != -1) then
			attachment = player:GetAttachment(attachment)
			position, angles = attachment.Pos, attachment.Ang
			
			position = position -(angles:Forward() *4.5) +(angles:Up() *4)
			
			angles:RotateAroundAxis(angles:Right(), 10)
		end
		
		return entity, position, angles
	end
end