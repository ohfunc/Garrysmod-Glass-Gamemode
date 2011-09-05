-- Very important, this is used in the player equipped hats networked string. Shouldn't change this once set.
-- And only use strings.
item.unique = "3"

item.price = 200000

if (CLIENT) then
	item.name = "Skull Head"
	item.model = Model("models/gibs/hgibs.mdl")
	
	local scale = Vector(1.6, 1.6, 1.6)
	
	item.LayoutEntity = function(player, entity)
		local position, angles = vector_zero, angle_zero
		local attachment = player:LookupAttachment("eyes")
		
		entity:SetModelScale(scale)
		
		if (attachment != -1) then
			attachment = player:GetAttachment(attachment)
			position, angles = attachment.Pos, attachment.Ang
			
			position = position -(angles:Forward() *2.5)
			
			angles:RotateAroundAxis(angles:Right(), -15)
		end
		
		return entity, position, angles
	end
end