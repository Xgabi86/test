AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:SpawnFunction(ply, tr)

	if not tr.HitWorld then return end

	local eEnt = ents.Create("ast_batteryprint")
	eEnt:SetPos(tr.HitPos + Vector(0, 0, 20))
	eEnt:Spawn()

	return eEnt

end

function ENT:Initialize()

	self:SetModel("models/props_lab/reciever01b.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:DropToFloor()

	local ePhys = self:GetPhysicsObject()

	if ePhys:IsValid() then
		ePhys:Wake()
	end

end

function ENT:OnTakeDamage()
	return false
end