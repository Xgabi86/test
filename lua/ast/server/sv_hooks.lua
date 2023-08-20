-- Initialize the SQLTables
hook.Add("Initialize", "AST:Initialize", function()

    AST.SQL:CreateTable("ast_players", {
		["id64"] = "VARCHAR(30) NOT NULL",
		["coins"] = "INTEGER NOT NULL",
        ["inventory"] = "JSON"
	})

end)

-- Initialize the player data coins
hook.Add("PlayerSpawn", "AST:PlayerSpawn", function(pPlayer)

    if not IsValid(pPlayer) then return end

    timer.Simple(3, function()
        AST:CheckPlayerRegister(pPlayer, function(bResult)
            if bResult then return end
            AST.SQL:Query("INSERT INTO ast_players(id64, coins, inventory) VALUES(?, ?, ?)", pPlayer:SteamID64(), 0, util.TableToJSON({}))
        end)
    end)

    local sTimerName = ("AST:PlayerSpawn:%s"):format(pPlayer:SteamID64())
    if timer.Exists(sTimerName) then
        timer.Remove(sTimerName)
    end

    timer.Create(sTimerName, AST.Config.TimeBetweenGive, 0, function()

        if not IsValid(pPlayer) then
            return timer.Remove(sTimerName)
        end

        AST:AddCoinsPlayer(pPlayer, AST.Config.AmountGive, function(iAllCoins)

            if IsValid(pPlayer) then
                pPlayer:SetLocalNWVar("AST:PCoins", iAllCoins)
                DarkRP.notify(pPlayer, 0, 5, ("Vous avez reçu %s pCoins !"):format(AST.Config.AmountGive))
            end
    
        end)

    end)

    AST:CheckItemExpiration(pPlayer)
    AST:GiveItem(pPlayer)

end)

-- When the player disconnect
hook.Add("PlayerDisconnected", "AST:PlayerDisconnected", function(pPlayer)

    if not IsValid(pPlayer) then return end

    local sTimerName = ("AST:PlayerSpawn:%s"):format(pPlayer:SteamID64())
    if timer.Exists(sTimerName) then
        timer.Remove(sTimerName)
    end

end)

-- When the player is loadout
hook.Add("PlayerLoadout", "AST:PlayerLoadout", function(pPlayer)

    if not IsValid(pPlayer) then return end

    AST:GetCoinsByPlayer(pPlayer, function(iCoins)
        pPlayer:SetLocalNWVar("AST:PCoins", iCoins)
    end)

end)

-- When the player press the key config, we open the menu
hook.Add("PlayerButtonDown", "AST:PlayerButtonDown", function(pPlayer, iKey)

    if not IsValid(pPlayer) then return end

    if iKey == AST.Config.KeyOpenMenu then
        
        net.Start("AST:OpenStoreMenu")
            net.WriteTable(AST:GetInventoryPlayer(pPlayer) or {})
        net.Send(pPlayer)

    end

end)

hook.Add("playerBoughtCustomEntity", "AST:BoughtPrinter", function(player, entityTable, entity, price)
	if (entity:GetClass() == "ast_printer") then
    	AST_Setup_printer(entity)
	end;
end);