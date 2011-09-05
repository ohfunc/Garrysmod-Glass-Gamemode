-- Very important, this is used in the player equipped hats networked string. Shouldn't change this once set.
-- And only use strings.
item.unique = "12"

item.price = 9001

if (CLIENT) then
	item.name = "Turtle"
	item.model = Model("models/props/de_tides/vending_turtle.mdl")
	
	item.LayoutEntity = function(player, entity)
		local position, angles = vector_zero, angle_zero
		local attachment = player:LookupAttachment("eyes")

		if (attachment != -1) then
			attachment = player:GetAttachment(attachment)
			position, angles = attachment.Pos, attachment.Ang

			position = position -(angles:Forward() *3)
			
			angles:RotateAroundAxis(angles:Up(), -90)
		end
		
		return entity, position, angles
	end
end