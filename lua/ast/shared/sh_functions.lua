-- Get a const from the table AST.Constants
function AST:GetConst(sCategoryName, sValueName)

    if not isstring(sCategoryName) then
        return false, error("sCategoryName is not valid string")
    end

    if not isstring(sValueName) then
        return false, error("sValueName is not valid string")
    end

    if not AST.Constants[sCategoryName] then
        return false, error("AST.Constants[sCategory] is not a valid category")
    end

    return AST.Constants[sCategoryName][sValueName]

end

-- Get a color from the table AST.Constants
function AST:GetColor(sColorName)

    if not isstring(sColorName) then
        return false, error("sColorName is not valid string")
    end

    return AST.Constants["cColors"][sColorName]

end

-- Get a font from the table AST.Constants
function AST:GetFont(sFontName)

    if not isstring(sFontName) then
        return false, error("sFontName is not valid string")
    end

    return AST.Constants["sFonts"][sFontName]

end

-- Find a item by his iUniqueId
function AST:FindItemByUniqueId(iUniqueId)

    if not isnumber(iUniqueId) then
        return false, error("iUniqueId is not valid number")
    end

    for i, t in ipairs(AST.Config.ItemsConfig) do
        if t.iUniqueId == iUniqueId then
            return t
        end
    end

    return false

end

-- Check if the player already own a item by his unique id
function AST:CheckItemPlayer(pPlayer, iUniqueId, tInv)

    if not IsValid(pPlayer) then return end
    if not isnumber(iUniqueId) or not istable(tInv) then return end
    
    if #tInv == 0 then return false end
    for i, t in ipairs(tInv) do
        
        if t.iUniqueId == iUniqueId and t.iExpireDays == 0 then
            return true
        end

    end

    return false

end