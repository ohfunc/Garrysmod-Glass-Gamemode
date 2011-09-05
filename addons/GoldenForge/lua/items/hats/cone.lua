-- Very important, this is used in the player equipped hats networked string. Shouldn't change this once set.
-- And only use strings.
item.unique = "2"

item.price = 2000

if (CLIENT) then
	item.name = "Cone Hat"
	item.model = Model("models/props_junk/TrafficCone001a.mdl")
	
	local scale = Vector(0.8, 0.8, 0.8)
	
	item.LayoutEntity = function(player, entity)
		local position, angles = vector_zero, angle_zero
		local attachment = player:LookupAttachment("eyes")
		
		entity:SetModelScale(scale)
		
		if (attachment != -1) then
			attachment = player:GetAttachment(attachment)
			position, angles = attachment.Pos, attachment.Ang
			
			position = position -(angles:Forward() *7) +(angles:Up() *12)
			
			angles:RotateAroundAxis(angles:Right(), 20)
		end
		
		return entity, position, angles
	end
end