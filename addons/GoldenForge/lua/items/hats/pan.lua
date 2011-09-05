-- Very important, this is used in the player equipped hats networked string. Shouldn't change this once set.
-- And only use strings.
item.unique = "10"

item.price = 250

if (CLIENT) then
	item.name = "Pan"
	item.model = Model("models/props_interiors/pot02a.mdl")
	
	item.LayoutEntity = function(player, entity)
		local position, angles = vector_zero, angle_zero
		local attachment = player:LookupAttachment("eyes")

		if (attachment != -1) then
			attachment = player:GetAttachment(attachment)
			position, angles = attachment.Pos, attachment.Ang

			position = position -(angles:Forward() *3) +(angles:Up() *2) +(angles:Right() *5.5)
			
			angles:RotateAroundAxis(angles:Right(), 180)
		end
		
		return entity, position, angles
	end
end