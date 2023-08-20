-- Add somes pCoins to a player
function AST:AddCoinsPlayer(pPlayer, iAddCoins, fcCallback)

    if not IsValid(pPlayer) then return end
    if not isnumber(iAddCoins) or not isfunction(fcCallback) then return end

    AST:GetCoinsByPlayer(pPlayer, function(iCoins)

        hook.Run("AST:AddCoins", pPlayer:SteamID64(), iAddCoins)

        AST:SetCoinsPlayer(pPlayer, iCoins + iAddCoins, function(iAllCoins)        
            fcCallback(iAllCoins)
            pPlayer:SetLocalNWVar("AST:PCoins", iAllCoins)
        end, false)

    end)
    
end

-- Add somes pCoins to a steamid64
function AST:AddCoinsID(sId, iAddCoins, fcCallback)

    if not isstring(sId) then return end
    if not isnumber(iAddCoins) or not isfunction(fcCallback) then return end

    if sId:find("STEAM_") then sId = util.SteamIDTo64(sId) end

    -- Check if the id64 is already register
    AST:CheckIDRegister(sId, function(bReturn)
    
        if not bReturn then
            AST.SQL:Query("INSERT INTO ast_players(id64, coins, inventory) VALUES(?, ?, ?)", sId, 0, util.TableToJSON({}))
        end

        timer.Simple(0.2, function()
    
            AST:GetCoinsById(sId, function(iCoins)
    
                hook.Run("AST:AddCoins", sId, iAddCoins)
    
                AST.SQL:Query("UPDATE ast_players SET coins = ? WHERE id64 = ?", iCoins + iAddCoins, sId)
                fcCallback(iCoins + iAddCoins)
    
            end)
    
        end)

    end)
    
end

-- Set the amount of pCoins to a player
function AST:SetCoinsPlayer(pPlayer, iSetCoins, fcCallback, bShowLog)

    if not IsValid(pPlayer) then return end
    if not isnumber(iSetCoins) or not isfunction(fcCallback) then return end

    if 0 > iSetCoins then iSetCoins = 0 end

    if bShowLog then
        hook.Run("AST:SetCoins", pPlayer:SteamID64(), iSetCoins)
    end

    AST.SQL:Query("UPDATE ast_players SET coins = ? WHERE id64 = ?", iSetCoins, pPlayer:SteamID64())
    fcCallback(iSetCoins)
    
    pPlayer:SetLocalNWVar("AST:PCoins", iSetCoins)
    
end

-- Set the amount of pCoins to a steamid64
function AST:SetCoinsID(sId, iSetCoins, fcCallback, bShowLog)

    if not isstring(sId) then return end
    if not isnumber(iSetCoins) or not isfunction(fcCallback) then return end

    if sId:find("STEAM_") then sId = util.SteamIDTo64(sId) end
    if 0 > iSetCoins then iSetCoins = 0 end

    -- Check if the id64 is already register
    AST:CheckIDRegister(sId, function(bReturn)
    
        if not bReturn then
            AST.SQL:Query("INSERT INTO ast_players(id64, coins) VALUES(?, ?, ?)", sId, 0, util.TableToJSON({}))
        end
    
        timer.Simple(0.2, function()
        
            if bShowLog then
                hook.Run("AST:SetCoins", sId, iSetCoins)
            end
        
            AST.SQL:Query("UPDATE ast_players SET coins = ? WHERE id64 = ?", iSetCoins, sId)
            fcCallback(iSetCoins)

        end)

    end)
    
end

-- Remove somes pCoins to a player
function AST:RemoveCoinsPlayer(pPlayer, iRemoveCoins, fcCallback)

    if not IsValid(pPlayer) then return end
    if not isnumber(iRemoveCoins) or not isfunction(fcCallback) then return end

    AST:GetCoinsByPlayer(pPlayer, function(iCoins)

        local iFinal = iCoins - iRemoveCoins
        if 0 > iFinal then return end

        hook.Run("AST:RemoveCoins", pPlayer:SteamID64(), iRemoveCoins)

        AST:SetCoinsPlayer(pPlayer, iFinal, function(iCoins)
            fcCallback(iCoins)
        end, false)

    end)

end

-- Remove somes pCoins to a steamid64
function AST:RemoveCoinsID(sId, iRemoveCoins, fcCallback)

    if not isstring(sId) then return end
    if not isnumber(iRemoveCoins) or not isfunction(fcCallback) then return end

    if sId:find("STEAM_") then sId = util.SteamIDTo64(sId) end

    -- Check if the id64 is already register
    AST:CheckIDRegister(sId, function(bReturn)
    
        if not bReturn then
            AST.SQL:Query("INSERT INTO ast_players(id64, coins) VALUES(?, ?, ?)", sId, 0, util.TableToJSON({}))
        end

        timer.Simple(0.2, function()
            
            AST:GetCoinsById(sId, function(iCoins)

                local iFinal = iCoins - iRemoveCoins
                if 0 > iFinal then return end
        
                hook.Run("AST:RemoveCoins", sId, iRemoveCoins)
        
                AST.SQL:Query("UPDATE ast_players SET coins = ? WHERE id64 = ?", iFinal, sId)
                fcCallback(iFinal)
        
            end)

        end)
    
    end)

end

-- Get the pCoins of a SteamID64
function AST:GetCoinsById(sId, fcCallback)

    if not isstring(sId) then return end
    if not isfunction(fcCallback) then return end

    if sId:find("STEAM_") then sId = util.SteamIDTo64(sId) end

    AST:CheckRegisterById(sId, function(bResult)

        if not bResult then
            AST.SQL:Query("INSERT INTO ast_players(id64, coins, inventory) VALUES(?, ?, ?)", sId, 0, util.TableToJSON({}))
        end

        local tData = AST.SQL:Query("SELECT * FROM ast_players WHERE id64 = ?", sId)
        fcCallback((tData[1] and tData[1].coins or 0))

    end)

end

-- Get the pCoins of a player
function AST:GetCoinsByPlayer(pPlayer, fcCallback)

    if not IsValid(pPlayer) then return end
    if not isfunction(fcCallback) then return end

    AST:CheckPlayerRegister(pPlayer, function(bResult)
    
        if not bResult then
            AST.SQL:Query("INSERT INTO ast_players(id64, coins, inventory) VALUES(?, ?, ?)", pPlayer:SteamID64(), 0, util.TableToJSON({}))
        end

        local tData = AST.SQL:Query("SELECT * FROM ast_players WHERE id64 = ?", pPlayer:SteamID64())
        fcCallback((tData[1] and tData[1].coins or 0))

    end)

end

-- Check if the steamid64 is register in the ast_players table
function AST:CheckRegisterById(sId, fcFunction)

    if not isstring(sId) then return end
    if not isfunction(fcFunction) then return end

    if sId:find("STEAM_") then sId = util.SteamIDTo64(sId) end
    local tData = AST.SQL:Query("SELECT * FROM ast_players WHERE id64 = ?", sId)

    if not istable(tData) then
        fcFunction(false)
    end

    fcFunction((istable(tData[1]) and true or false))

end

-- Check if the player is register in the ast_players table
function AST:CheckPlayerRegister(pPlayer, fcFunction)

    if not IsValid(pPlayer) then return end
    if not isfunction(fcFunction) then return end

    local tData = AST.SQL:Query("SELECT * FROM ast_players WHERE id64 = ?", pPlayer:SteamID64())

    if not istable(tData) then
        fcFunction(false)
        return
    end

    fcFunction((tData[1] and true or false))

end

-- Check if the id is register in the ast_players table
function AST:CheckIDRegister(sId, fcFunction)

    if not isstring(sId) then return end
    if not isfunction(fcFunction) then return end

    if sId:find("STEAM_") then
        sId = util.SteamIDTo64(sId)
    end

    local tData = AST.SQL:Query("SELECT * FROM ast_players WHERE id64 = ?", sId)

    if not istable(tData) then
        fcFunction(false)
        return
    end

    fcFunction((tData[1] and true or false))

end

-- Buy a item for a player
function AST:BuyItem(pPlayer, iUniqueId)

    if not IsValid(pPlayer) then return end
    if not isnumber(iUniqueId) then return end

    if not AST:FindItemByUniqueId(iUniqueId) then
        return false, 0
    end

    local tItem = AST:FindItemByUniqueId(iUniqueId)
    
    if AST:CheckItemPlayer(pPlayer, iUniqueId) then
        return false, 1
    end

    local tInfos = AST.SQL:Query("SELECT * FROM ast_players WHERE id64 = ?", pPlayer:SteamID64())[1]

    if tonumber(tInfos.coins) < tItem.iPriceCoins then
        return false, 2
    end

    local iFinal = tInfos.coins - tItem.iPriceCoins
    if 0 > iFinal then return end

    local tInv = AST:GetInventoryPlayer(pPlayer)
    local bExpireExtented = false

    for i, t in ipairs(tInv) do
        
        if t.iUniqueId == iUniqueId and t.iExpireDays >= 1 then
            t.iExpireDays = (tItem.iExpireDays == 0 and 0 or t.iExpireDays + (tItem.iExpireDays * 86400))
            bExpireExtented = true
        end

    end

    if not bExpireExtented then
        table.insert(tInv, {
            iUniqueId = iUniqueId,
            iExpireDays = (tItem.iExpireDays == 0 and 0 or os.time() + tItem.iExpireDays * 86400)
        })
    end

    AST.SQL:Query("UPDATE ast_players SET inventory = ?, coins = ? WHERE id64 = ?", util.TableToJSON(tInv), iFinal, pPlayer:SteamID64())
    pPlayer:SetLocalNWVar("AST:PCoins", iFinal)

    return true

end

-- Get Player Inventory
function AST:GetInventoryPlayer(pPlayer)

    if not IsValid(pPlayer) then return end

    local tSQLQuery = AST.SQL:Query("SELECT * FROM ast_players WHERE id64 = ?", pPlayer:SteamID64())
    local tInventory = util.JSONToTable(tSQLQuery[1].inventory)

    return tInventory

end

-- Check if the player already own a item by his unique id
function AST:CheckItemPlayer(pPlayer, iUniqueId)

    if not IsValid(pPlayer) then return end
    if not isnumber(iUniqueId) then return end

    local tInv = AST:GetInventoryPlayer(pPlayer)
    if #tInv == 0 then return false end

    for i, t in ipairs(tInv) do
        
        if t.iUniqueId == iUniqueId and t.iExpireDays == 0 then
            return true
        end

    end

    return false

end

-- Check the expiration of a item
function AST:CheckItemExpiration(pPlayer)

    if not IsValid(pPlayer) then return end

    local tInv = AST:GetInventoryPlayer(pPlayer)
    if #tInv == 0 then return false end

    for i, t in ipairs(tInv) do
        
        if t.iExpireDays >= 1 and os.time() > t.iExpireDays then
            table.remove(tInv, i)
        end

    end

    AST.SQL:Query("UPDATE ast_players SET inventory = ? WHERE id64 = ?", util.TableToJSON(tInv), pPlayer:SteamID64())

end

-- Give the item when his spawning
function AST:GiveItem(pPlayer)

    if not IsValid(pPlayer) then return end

    local tInv = AST:GetInventoryPlayer(pPlayer)
    if #tInv == 0 then return false end

    for i, t in ipairs(tInv) do

        timer.Simple(i, function()
        
            local tItem = AST:FindItemByUniqueId(t.iUniqueId)

            if isfunction(tItem.fcFunction) then
                tItem.fcFunction(pPlayer)
            end

        end)

    end

end

function AST_Setup_printer(entity)

    entity.ent1 = ents.Create('prop_dynamic');
	entity.ent1:SetModel('models/props/cs_office/computer_caseb_p7a.mdl');
	entity.ent1:SetPos(entity:GetPos()+(entity:GetUp()*20.5)+(entity:GetForward()*2)+(entity:GetRight()*-35));
	entity.ent1:SetAngles(entity:GetAngles() + Angle(0, 10, 90));
	entity.ent1:SetParent(entity);
	entity.ent1:Spawn();
	entity.ent1:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE);

    entity.ent2 = ents.Create('prop_dynamic');
	entity.ent2:SetModel('models/props/cs_office/computer_caseb_p2a.mdl');
	entity.ent2:SetPos(entity:GetPos()+(entity:GetUp()*-1)+(entity:GetForward()*2)+(entity:GetRight()*-25));
	entity.ent2:SetAngles(entity:GetAngles() + Angle(0, 0, 0));
	entity.ent2:SetParent(entity);
	entity.ent2:Spawn();
	entity.ent2:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE);

    entity.ent3 = ents.Create('prop_dynamic');
	entity.ent3:SetModel('models/props/cs_office/computer_caseb_p3a.mdl');
	entity.ent3:SetPos(entity:GetPos()+(entity:GetUp()*1)+(entity:GetForward()*10)+(entity:GetRight()*-25));
	entity.ent3:SetAngles(entity:GetAngles() + Angle(0, 45, 0));
	entity.ent3:SetParent(entity);
	entity.ent3:Spawn();
	entity.ent3:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE);

    entity.ent4 = ents.Create('prop_dynamic');
	entity.ent4:SetModel('models/props/cs_office/computer_caseb_p6b.mdl');
	entity.ent4:SetPos(entity:GetPos()+(entity:GetUp()*-10)+(entity:GetForward()*0)+(entity:GetRight()*-29));
	entity.ent4:SetAngles(entity:GetAngles() + Angle(0, 10, 0));
	entity.ent4:SetParent(entity);
	entity.ent4:Spawn();
	entity.ent4:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE);

    entity.ent5 = ents.Create('prop_dynamic');
	entity.ent5:SetModel('models/props/cs_office/computer_caseb_p1.mdl');
	entity.ent5:SetPos(entity:GetPos()+(entity:GetUp()*50)+(entity:GetForward()*0)+(entity:GetRight()*18));
	entity.ent5:SetAngles(entity:GetAngles() + Angle(0, 0, -90));
	entity.ent5:SetParent(entity);
	entity.ent5:Spawn();
	entity.ent5:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE);

    entity.ent6 = ents.Create('prop_dynamic');
	entity.ent6:SetModel('models/xqm/hydcontrolbox.mdl');
	entity.ent6:SetPos(entity:GetPos()+(entity:GetUp()*63.5)+(entity:GetForward()*0)+(entity:GetRight()*20));
	entity.ent6:SetAngles(entity:GetAngles() + Angle(0, 160, 0));
	entity.ent6:SetParent(entity);
	entity.ent6:Spawn();
	entity.ent6:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE);

    entity.ent7 = ents.Create('prop_dynamic');
	entity.ent7:SetModel('models/props_lab/harddrive01.mdl');
	entity.ent7:SetPos(entity:GetPos()+(entity:GetUp()*73.5)+(entity:GetForward()*0)+(entity:GetRight()*0));
	entity.ent7:SetAngles(entity:GetAngles() + Angle(0, 0, 0));
	entity.ent7:SetParent(entity);
	entity.ent7:Spawn();
	entity.ent7:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE);

    entity.ent8 = ents.Create('prop_dynamic');
	entity.ent8:SetModel('models/props_lab/reciever01c.mdl');
	entity.ent8:SetPos(entity:GetPos()+(entity:GetUp()*48)+(entity:GetForward()*0)+(entity:GetRight()*28));
	entity.ent8:SetAngles(entity:GetAngles() + Angle(0, 32, 0));
	entity.ent8:SetParent(entity);
	entity.ent8:Spawn();
	entity.ent8:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE);

    entity.ent9 = ents.Create('prop_dynamic');
	entity.ent9:SetModel('models/props_lab/plotter.mdl');
	entity.ent9:SetPos(entity:GetPos()+(entity:GetUp()*2)+(entity:GetForward()*0)+(entity:GetRight()*25));
	entity.ent9:SetAngles(entity:GetAngles() + Angle(0, 90, 0));
	entity.ent9:SetParent(entity);
	entity.ent9:Spawn();
	entity.ent9:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE);

    entity.ent10 = ents.Create('prop_dynamic');
	entity.ent10:SetModel('models/props_c17/consolebox03a.mdl');
	entity.ent10:SetPos(entity:GetPos()+(entity:GetUp()*25)+(entity:GetForward()*-1)+(entity:GetRight()*20));
	entity.ent10:SetAngles(entity:GetAngles() + Angle(0, 0, 0));
	entity.ent10:SetParent(entity);
	entity.ent10:Spawn();
	entity.ent10:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE);

    entity.ent11 = ents.Create('prop_dynamic');
	entity.ent11:SetModel('models/props_c17/computer01_keyboard.mdl');
	entity.ent11:SetPos(entity:GetPos()+(entity:GetUp()*28)+(entity:GetForward()*-1)+(entity:GetRight()*-0));
	entity.ent11:SetAngles(entity:GetAngles() + Angle(0, -80, 0));
	entity.ent11:SetParent(entity);
	entity.ent11:Spawn();
	entity.ent11:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE);

    entity.ent11 = ents.Create('prop_dynamic');
	entity.ent11:SetModel('models/props_c17/consolebox01a.mdl');
	entity.ent11:SetPos(entity:GetPos()+(entity:GetUp()*9.5)+(entity:GetForward()*-1)+(entity:GetRight()*10));
	entity.ent11:SetAngles(entity:GetAngles() + Angle(0, 0, 0));
	entity.ent11:SetParent(entity);
	entity.ent11:Spawn();
	entity.ent11:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE);

    entity.ent12 = ents.Create('prop_dynamic');
	entity.ent12:SetModel('models/props_lab/reciever01a.mdl');
	entity.ent12:SetPos(entity:GetPos()+(entity:GetUp()*22.5)+(entity:GetForward()*-1)+(entity:GetRight()*10));
	entity.ent12:SetAngles(entity:GetAngles() + Angle(0, 28, 0));
	entity.ent12:SetParent(entity);
	entity.ent12:Spawn();
	entity.ent12:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE);

    entity.ent13 = ents.Create('prop_dynamic');
	entity.ent13:SetModel('models/props_lab/reciever01b.mdl');
	entity.ent13:SetPos(entity:GetPos()+(entity:GetUp()*17)+(entity:GetForward()*3)+(entity:GetRight()*31));
	entity.ent13:SetAngles(entity:GetAngles() + Angle(0, 0, 90));
	entity.ent13:SetParent(entity);
	entity.ent13:Spawn();
	entity.ent13:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE);

end

function AST:GiveAmmosItem()

    for i, pPlayer in pairs(player.GetAll()) do

        if not IsValid(pPlayer) then return end

        local tInv = AST:GetInventoryPlayer(pPlayer)
        if #tInv == 0 then return false end

        for i, t in ipairs(tInv) do

            timer.Simple(i, function()
            
                local tItem = AST:FindItemByUniqueId(t.iUniqueId)
                if tItem == 568 then
                    if isfunction(tItem.fcFunction) then
                        tItem.fcFunction(pPlayer)
                    end
                end

            end)

        end

    end

end

timer.Create("giveAmmosItem", 10, 0, function()
    AST:GiveAmmosItem()
end)
