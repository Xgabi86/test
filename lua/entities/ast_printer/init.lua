AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:SpawnFunction(ply, tr)

	if not tr.HitWorld then return end

	local eEnt = ents.Create("ast_printer")
	eEnt:SetPos(tr.HitPos + Vector(0, 0, 20))
	eEnt:Spawn()
	AST_Setup_printer(eEnt)

	return eEnt

end

function ENT:Initialize()

	self:SetModel("models/craphead_scripts/bitminers/rack/rack.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:DropToFloor()

	local ePhys = self:GetPhysicsObject()

	if ePhys:IsValid() then
		ePhys:Wake()
	end

	self:SetBattery(100)
	self:SetHP(100)
	self:SetTemp(0)

	self.iCooldown = 0

	self:StartTimer(AST.Config.TimeBetweenGivePrinter, AST.Config.AmountGivePrinter)
	self:StartBatteryTimer()
	self:StartTempTimer()

end

-- Start a timer for the temperature
function ENT:StartTempTimer()

	local sTimerName = ("AST:Printers:Temp:%s"):format(self:EntIndex())
	if timer.Exists(sTimerName) then timer.Remove(sTimerName) end

	timer.Create(sTimerName, AST.Config.TimeBetweenTempDown, 0, function()
	
		if not IsValid(self) then return end

		if self:GetUpgrade() == 1 then
		
			local iTemp = self:GetTemp()
			local iNewTemp = iTemp - AST.Config.PourcentTempDown
	
			if iTemp <= 0 then iTemp = 0 end
			if iNewTemp <= AST.Config.PourcentTempDefault then iNewTemp = AST.Config.PourcentTempDefault end
	
			self:SetTemp(iNewTemp)

			local getPrintTemp = self:GetNWInt("timeToRemoveVentilo")
			if getPrintTemp > 0 then

				self:SetNWString("timeToRemoveVentilo", getPrintTemp -1 )

			else
				self:SetUpgrade(0)
			end

		else
		
			local iTemp = self:GetTemp()
			local iNewTemp = iTemp + AST.Config.PourcentTempUp

			if iTemp >= 100 then return end
			if iNewTemp >= 100 then iNewTemp = 100 end
	
			if AST.Config.MaxTempExplode == iNewTemp then
				local eExplosion = ents.Create("env_explosion")
				eExplosion:SetPos(self:GetPos())
				eExplosion:Spawn()
				eExplosion:SetKeyValue("iMagnitude", "0")
				eExplosion:Fire("Explode", 0, 0)
				self:Remove()
			end

			self:SetTemp(iNewTemp)

		end

	end)

end

-- Start a timer
function ENT:StartTimer(iTime, iGive)

	local sTimerName = ("AST:Printers:%s"):format(self:EntIndex())
	if timer.Exists(sTimerName) then timer.Remove(sTimerName) end

	timer.Create(sTimerName, iTime, 0, function()

		if not IsValid(self) then return end
		if self:GetBattery() <= 0 then return end

		local iAmountCoin = self:GetPCoinsAmount()
		self:SetPCoinsAmount(iAmountCoin + iGive)

	end)

end

function ENT:Use(_, eCaller)

	if self.iCooldown > CurTime() then return end

	if not IsValid(eCaller) then return end
	if self:GetPCoinsAmount() == 0 then return end

	AST:AddCoinsPlayer(eCaller, self:GetPCoinsAmount(), function(iAllCoins)

        print(("[AST] You just add %i pCoins of the balance of %s | New balance: %i pCoins"):format(self:GetPCoinsAmount(), eCaller:Nick(), iAllCoins))

        if IsValid(eCaller) then
            eCaller:SetLocalNWVar("AST:PCoins", iAllCoins)
			DarkRP.notify(eCaller, 0, 5, ("Vous avez récupéré %i pCoins"):format(self:GetPCoinsAmount()))
        end

		self:SetPCoinsAmount(0)

    end)

	self.iCooldown = CurTime() + 1

end

-- StartTouch with the upgrade
function ENT:StartTouch(eEntity)

	if not IsValid(eEntity) then return end

	if eEntity:GetClass() == "ast_ventiprint" then

		if self:GetUpgrade() == 1 then return end
		self:SetUpgrade(1)
	
		self:StartTimer(AST.Config.TimeBetweenGivePrinterVentilator, AST.Config.AmountGivePrinterVentilator)
		eEntity:Remove()
		self:SetNWInt("timeToRemoveVentilo", AST.Config.TimeToDeleteVentilator)
		

	elseif eEntity:GetClass() == "ast_batteryprint" then

		local iBattery = self:GetBattery()
		local iNewBattery = iBattery + AST.Config.PourcentBatteryUp

		if iBattery >= 100 then return end
		if iNewBattery >= 100 then iNewBattery = 100 end

		self:SetBattery(iNewBattery)
		eEntity:Remove()

	end

end

-- Start a timer for the battery
function ENT:StartBatteryTimer()

	local sTimerName = ("AST:Printers:Battery:%s"):format(self:EntIndex())
	if timer.Exists(sTimerName) then timer.Remove(sTimerName) end

	timer.Create(sTimerName, AST.Config.TimeBetweenBatteryDown, 0, function()

		if not IsValid(self) then return end

		local iBattery = self:GetBattery()
		local iNewBattery = iBattery - AST.Config.PourcentBatteryDown

		if iBattery <= 0 then return end
		if iNewBattery <= 0 then iNewBattery = 0 end

		self:SetBattery(iNewBattery)

	end)

end

function ENT:OnTakeDamage(tInfos)
	
	self:SetHP(self:GetHP() - tInfos:GetDamage())

	if self:GetHP() <= 0 then
		self:Remove()
		local eExplosion = ents.Create("env_explosion")
		eExplosion:SetPos(self:GetPos())
		eExplosion:Spawn()
		eExplosion:SetKeyValue("iMagnitude", "0")
		eExplosion:Fire("Explode", 0, 0)
	end

end

function ENT:OnRemove()
	
	local sTimerName1 = ("AST:Printers:Temp:%s"):format(self:EntIndex())
	if timer.Exists(sTimerName1) then timer.Remove(sTimerName1) end

	local sTimerName2 = ("AST:Printers:%s"):format(self:EntIndex())
	if timer.Exists(sTimerName2) then timer.Remove(sTimerName2) end

	local sTimerName3 = ("AST:Printers:Battery:%s"):format(self:EntIndex())
	if timer.Exists(sTimerName3) then timer.Remove(sTimerName3) end

end