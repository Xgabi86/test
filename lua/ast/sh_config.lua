-- Name of this server
AST.Config.ServerName = "Pandorra"

-- Command to add somes pCoins
AST.Config.CommandAddCoins = "ast_coins_add"

-- Command to remove somes pCoins
AST.Config.CommandRemoveCoins = "ast_coins_remove"

-- Time between all give of x PCoins
AST.Config.TimeBetweenGive = 15 * 60 -- 15 min

-- Amount of the give of PCoins
AST.Config.AmountGive = 3

-------------------Printer--------------------------

-- Interlapse de temps pour la quelle un coin et fabriquer
AST.Config.TimeBetweenGivePrinter = 10 -- min

-- Amount of the give of PCoins from a printer
AST.Config.AmountGivePrinter = 1

------------------Ventilateur----------------------

-- Interlapse de temps pour la quelle un coin et fabriquer
AST.Config.TimeBetweenGivePrinterVentilator = 10 -- min

-- Amount of the give of PCoins from a printer with a ventilator
AST.Config.AmountGivePrinterVentilator = 2

-------------------Baterrie-------------------------

-- Time between x Pourcent of Battery down
AST.Config.TimeBetweenBatteryDown = 3 -- 1 min

-- Pourcent of Battery down
AST.Config.PourcentBatteryDown = 1

-- Pourcent of Battery Up
AST.Config.PourcentBatteryUp = 100

-------------------Temperature-------------------------

-- Pourcent default of temp default
AST.Config.PourcentTempDefault = 0 -- NE PAS TOUCHER (sinon tou casser) [default: 0]

-- Time between x Pourcent of Temp down & up
AST.Config.TimeBetweenTempDown = 3

-- Pourcent of Temp down
AST.Config.PourcentTempDown = 1

-- Pourcent of Temp Up
AST.Config.PourcentTempUp = 1

-- Max temperature of the printer to explode
AST.Config.MaxTempExplode = 100

-- Time to delete a ventilator
AST.Config.TimeToDeleteVentilator = 10 * 60 -- 5 min

--------------------Shop-------------------------

-- Key to open the menu
AST.Config.KeyOpenMenu = KEY_F8

-- Config Items
AST.Config.ItemsConfig = {
    
    [1] = {

        iUniqueId = 123,
        sName = "VIP - 1 mois",
        sIcon = "https://i.imgur.com/wpeXNB7.png",
        iExpireDays = 30, -- 0 = Permanant
        iPriceCoins = 250, -- Price in pCoins
        fcFunction = function(pPlayer)
            pPlayer:SetUserGroup("vip")
        end

    },
    [2] = {

        iUniqueId = 234,
        sName = "Magnum",
        sIcon = "https://i.imgur.com/wpeXNB7.png",
        iExpireDays = 1, -- 0 = Permanant
        iPriceCoins = 250, -- Price in pCoins
        fcFunction = function(pPlayer)
            pPlayer:Give("weapon_357")
        end

    },
    [3] = {

        iUniqueId = 345,
        sName = "Armure 100%",
        sIcon = "https://i.imgur.com/wpeXNB7.png",
        iExpireDays = 2, -- 0 = Permanant
        iPriceCoins = 250, -- Price in pCoins
        fcFunction = function(pPlayer)
            pPlayer:SetArmor(100)
        end

    },
    [4] = {
        
        iUniqueId = 567,
        sName = "Armure 200%",
        sIcon = "https://i.imgur.com/wpeXNB7.png",
        iExpireDays = 0, -- 0 = Permanant
        iPriceCoins = 250, -- Price in pCoins
        fcFunction = function(pPlayer)
            pPlayer:SetArmor(200)
        end

    },
    [5] = {
        
        iUniqueId = 568,
        sName = "Munition illimité",
        sIcon = "https://i.imgur.com/wpeXNB7.png",
        iExpireDays = 0, -- 0 = Permanant
        iPriceCoins = 250, -- Price in pCoins
        fcFunction = function(pPlayer)
            for _, eWep in ipairs(pPlayer:GetWeapons()) do
                if eWep:GetPrimaryAmmoType() ~= -1 then
                    pPlayer:GiveAmmo(9999, eWep:GetPrimaryAmmoType(), true)
                end
        
                if eWep:GetSecondaryAmmoType() ~= -1 then
                    pPlayer:GiveAmmo(9999, eWep:GetSecondaryAmmoType(), true)
                end
            end
        end

    },
    
}

-- Pack Armes
--: pPlayer:Give("class de l'arme")

-- Pack d'amures
--: pPlayer:SetArmor(100)

-- VIP
--: pPlayer:SetUserGroup("vip")

-- -- Munitions
-- --[[
--     for _, eWep in ipairs(pPlayer:GetWeapons()) do
--         if eWep:GetPrimaryAmmoType() ~= -1 then
--             pPlayer:GiveAmmo(nombremuniotion, eWep:GetPrimaryAmmoType(), true)
--         end

--         if eWep:GetSecondaryAmmoType() ~= -1 then
--             pPlayer:GiveAmmo(nombremuniotion, eWep:GetSecondaryAmmoType(), true)
--         end
--     end
-- --]