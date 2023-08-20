util.AddNetworkString("AST:OpenStoreMenu")
util.AddNetworkString("AST:BuyItem")

-- When a player buying a item
net.Receive("AST:BuyItem", function(_, pPlayer)

    if not IsValid(pPlayer) then return end
    local iUniqueId = net.ReadUInt(32)

    if not AST:FindItemByUniqueId(iUniqueId) then 
        return DarkRP.notify(pPlayer, 1, 5, "Cette item n'existe pas !")
    end

    local tItem = AST:FindItemByUniqueId(iUniqueId)
    local bReturn, iErrorCode = AST:BuyItem(pPlayer, iUniqueId)

    if bReturn then
        
        DarkRP.notify(pPlayer, 0, 5, ("Vous avez acheté %s pour %s PC"):format(tItem.sName, tItem.iPriceCoins))

        if isfunction(tItem.fcFunction) then
            tItem.fcFunction(pPlayer)
        end

        net.Start("AST:OpenStoreMenu")
            net.WriteTable(AST:GetInventoryPlayer(pPlayer) or {})
        net.Send(pPlayer)

    else

        if iErrorCode == 0 then
            return DarkRP.notify(pPlayer, 1, 5, "Cette item n'existe pas !")     
        elseif iErrorCode == 1 then
            return DarkRP.notify(pPlayer, 1, 5, "Vous possèdez déjà cette item")
        elseif iErrorCode == 2 then
            return DarkRP.notify(pPlayer, 1, 5, "Vous n'avez pas assez de PC pour acheter cette item !")
        end

    end

end)