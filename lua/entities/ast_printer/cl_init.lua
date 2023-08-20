include("shared.lua")

local rotationSpeed = -1

function ENT:Draw()

    self:DrawModel()

    local vecPos = self:GetPos()
    local angPos = self:GetAngles()

    angPos:RotateAroundAxis(angPos:Forward(), 90)
    angPos:RotateAroundAxis(angPos:Up(), 20)
     angPos:RotateAroundAxis(angPos:Right(), -90)

    self.iLerp = Lerp(FrameTime() * 2, self.iLerp or 0, self:GetBattery() * 10 or 0)
    self.iHP = Lerp(FrameTime() * 2, self.iHP or 0, self:GetHP() * 10 or 0)
    self.iTemp = Lerp(FrameTime() * 2, self.iTemp or 0, self:GetTemp() * 10 or 0)

    local textureVentilo
    self:SetNWInt("rotation", self:GetNWInt("rotation" or 0))
    if self:GetUpgrade() == 1 then
        textureVentilo = Material("materials/craphead_scripts/bitminers/rgb_on.png")
    else
        textureVentilo = Material("materials/craphead_scripts/bitminers/rgb_off.png")
        self:SetNWInt("rotation", 0)
    end
    
    cam.Start3D2D(vecPos + (angPos:Right() * -51.5) + (angPos:Up() * 21.1) + (angPos:Forward() * 25), angPos, 0.020)

        draw.SimpleText(("pCoins: %i"):format(self:GetPCoinsAmount()), AST:Font(150, "Bold", 700, true), 0, -20, color_white, 1, 1)
        
        draw.SimpleText(("Ventilateur: "), AST:Font(85, "Medium", 700, true), -50, 110, color_white, 1, 1)
        surface.SetMaterial(textureVentilo)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRectRotated(225, 125, 150, 150, self:GetNWInt("rotation" or 0))
        self:SetNWInt("rotation", self:GetNWInt("rotation" or 0) + rotationSpeed)
        if self:GetNWInt("rotation" or 0) >= 360 then
            self:SetNWInt("rotation", 0)
        end

        -- Battery
        draw.RoundedBox(8, -500, 220, 1000, 80, AST:GetColor("red_bg1"))
        draw.RoundedBox(8, -500, 220, math.Round(self.iLerp), 80, AST:GetColor("green_bg1"))

        draw.SimpleText(("%i%% de Batterie"):format(math.Round(self.iLerp) / 10), AST:Font(65, "Medium", 700, true), 0, 258, color_white, 1, 1)

        -- HP
        draw.RoundedBox(8, -500, 320, 1000, 80, AST:GetColor("red_bg1"))
        draw.RoundedBox(8, -500, 320, math.Round(self.iHP), 80, AST:GetColor("green_bg1"))

        draw.SimpleText(("%i%% de vie"):format(math.Round(self.iHP) / 10), AST:Font(65, "Medium", 700, true), 0, 358, color_white, 1, 1)

        draw.RoundedBox(8, -500, 420, 1000, 80, AST:GetColor("red_bg1"))
        draw.RoundedBox(8, -500, 420, math.Round(self.iTemp), 80, AST:GetColor("green_bg1"))

        draw.SimpleText(("%i%% de temperature"):format(math.Round(self.iTemp) / 10), AST:Font(65, "Medium", 700, true), 0, 458, color_white, 1, 1)

        draw.SimpleText(("Par gabi_86"), AST:Font(30, "Medium", 700, true), 450, 515, color_white, 1, 1)

    cam.End3D2D()

end