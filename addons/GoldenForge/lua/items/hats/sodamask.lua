item.unique = "16"

item.price = 300

if (CLIENT) then
	item.name = "Soda Mask"
	item.model = Model("models/props_junk/PopCan01a.mdl")
	
	item.LayoutEntity = function(player, entity)
		local position, angles = vector_zero, angle_zero
		local attachment = player:LookupAttachment("eyes")

		if (attachment != -1) then
			attachment = player:GetAttachment(attachment)
			position, angles = attachment.Pos, attachment.Ang

			position = position -(angles:Up() *4)

			angles:RotateAroundAxis(angles:Right(), -90)
		end
		
		return entity, position, angles
	end
end
