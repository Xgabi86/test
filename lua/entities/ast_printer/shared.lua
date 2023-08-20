ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "pCoins Printer"
ENT.Category = "AST"
ENT.Author = "JoeyyFrench"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.RenderGroup = RENDERGROUP_BOTH
ENT.AutomaticFrameAdvance = true

function ENT:SetupDataTables()

	self:NetworkVar( "Int", 0, "PCoinsAmount" )
	self:NetworkVar( "Int", 1, "Upgrade" )
	self:NetworkVar( "Int", 2, "Battery" )
	self:NetworkVar( "Int", 3, "HP" )
	self:NetworkVar( "Int", 4, "Temp" )

end