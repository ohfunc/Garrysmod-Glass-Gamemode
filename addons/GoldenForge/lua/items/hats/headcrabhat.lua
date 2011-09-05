-- Very important, this is used in the player equipped hats networked string. Shouldn't change this once set.
-- And only use strings.
item.unique = "14"

item.price = 1000000

if (CLIENT) then
	item.name = "Headcrab Hat"
	item.model = Model("models/headcrabclassic.mdl")
	
	local scale = Vector(0.7, 0.7, 0.7)
	
	item.LayoutEntity = function(player, entity)
		local position, angles = vector_zero, angle_zero
		local attachment = player:LookupAttachment("eyes")
		
		entity:SetModelScale(scale)
		
		if (attachment != -1) then
			attachment = player:GetAttachment(attachment)
			position, angles = attachment.Pos, attachment.Ang

			position = position +(angles:Forward() *2)
			
			angles:RotateAroundAxis(angles:Right(), 20)
		end
		
		return entity, position, angles
	end
end