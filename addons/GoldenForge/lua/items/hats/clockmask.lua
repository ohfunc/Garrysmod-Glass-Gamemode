-- Very important, this is used in the player equipped hats networked string. Shouldn't change this once set.
-- And only use strings.
item.unique = "9"

item.price = 600

if (CLIENT) then
	item.name = "Clock Mask"
	item.model = Model("models/props_c17/clock01.mdl")
	
	item.LayoutEntity = function(player, entity)
		local position, angles = vector_zero, angle_zero
		local attachment = player:LookupAttachment("eyes")

		if (attachment != -1) then
			attachment = player:GetAttachment(attachment)
			position, angles = attachment.Pos, attachment.Ang

			angles:RotateAroundAxis(angles:Right(), -90)
		end
		
		return entity, position, angles
	end
end