-- Very important, this is used in the player equipped hats networked string. Shouldn't change this once set.
-- And only use strings.
item.unique = "13"

item.price = 50000

if (CLIENT) then
	item.name = "Snowman Head"
	item.model = Model("models/props/cs_office/snowman_face.mdl")
	
	item.LayoutEntity = function(player, entity)
		local position, angles = vector_zero, angle_zero
		local attachment = player:LookupAttachment("eyes")
		
		if (attachment != -1) then
			attachment = player:GetAttachment(attachment)
			position, angles = attachment.Pos, attachment.Ang

			position = position -(angles:Forward() *2.2)
			
			angles:RotateAroundAxis(angles:Up(), -90)
		end
		
		return entity, position, angles
	end
end