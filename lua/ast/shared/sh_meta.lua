local PLAYER = FindMetaTable("Player")

-- Get the pCoins amount
function PLAYER:GetPCoins()
    return self:GetLocalNWVar("AST:PCoins", 0)
end