AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')
include('tables.lua')

function ENT:Initialize()
	self.DieTime = CurTime() + 5

	local pl = self.Entity:GetOwner()
	local aimvec = pl:GetAimVector()
	self.Entity:SetPos(pl:GetShootPos() + pl:GetAimVector() * 30)
	self.Entity:SetAngles(pl:GetAimVector():Angle()* math.random(1,45))
	self.Entity:SetModel( table.Random( Props ) )
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(200)
	end
	self.Touched = {}
	self.OriginalAngles = self.Entity:GetAngles()
end

function ENT:Think()
	if CurTime() > self.DieTime then
		self.Entity:Remove()
	end
end

function ENT:PhysicsCollide(data, phys)
	local hitEnt = data.HitEntity
	if (self.Entity.Hit) then return end
	self.Entity.Hit = true

	self.HitTime = CurTime()
	
		self.Entity:EmitSound("physics/metal/metal_box_break"..math.random(1,2)..".wav")

		function self:PhysicsCollide() end
end

