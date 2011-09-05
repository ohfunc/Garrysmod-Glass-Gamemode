-- Very important, this is used in the player equipped hats networked string. Shouldn't change this once set.
-- And only use strings.
item.unique = "4"

item.price = 20

if (CLIENT) then
	item.name = "Bomb Head"
	item.model = Model("models/combine_helicopter/helicopter_bomb01.mdl")
	
	local scale = Vector(0.5, 0.5, 0.5)
	
	item.LayoutEntity = function(player, entity)
		local position, angles = vector_zero, angle_zero
		local attachment = player:LookupAttachment("eyes")
		
		entity:SetModelScale(scale)
		
		if (attachment != -1) then
			attachment = player:GetAttachment(attachment)
			position, angles = attachment.Pos, attachment.Ang
			
			position = position -(angles:Forward() *2)
			
			angles:RotateAroundAxis(angles:Right(), 90)
		end
		
		return entity, position, angles
	end
end