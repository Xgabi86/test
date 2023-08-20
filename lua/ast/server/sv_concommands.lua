-- Add some pCoins to a SteamID64
concommand.Add(AST.Config.CommandAddCoins, function(pPlayer, sCommand, tArgs, sArg)

    local sId = tArgs[1]
    local iAmountCoin = tonumber(tArgs[2])

    AST:AddCoinsID(sId, iAmountCoin, function(iAllCoins)

        if sId:find("STEAM_") then
            sId = util.SteamIDTo64(sId)
        end
		
        print(("[AST] You just add %i pCoins of the balance of %s | New balance: %i pCoins"):format(iAmountCoin, sId, iAllCoins))
                
        if IsValid(player.GetBySteamID64(sId)) then
            player.GetBySteamID64(sId):SetLocalNWVar("AST:PCoins", iAllCoins)
        end

    end)

end)

-- Remove some pCoins to a SteamID64
concommand.Add(AST.Config.CommandRemoveCoins, function(pPlayer, sCommand, tArgs, sArg)

    local sId = tArgs[1]
    local iAmountCoin = tonumber(tArgs[2])

    AST:RemoveCoinsID(sId, iAmountCoin, function(iAllCoins)

        if sId:find("STEAM_") then
            sId = util.SteamIDTo64(sId)
        end
                
        print(("[AST] You just remove %i pCoins of the balance of %s | New balance: %i pCoins"):format(iAmountCoin, sId, iAllCoins))

        if IsValid(player.GetBySteamID64(sId)) then
            player.GetBySteamID64(sId):SetLocalNWVar("AST:PCoins", iAllCoins)
        end

    end)

end)