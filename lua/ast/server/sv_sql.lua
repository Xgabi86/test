-- Check if a AST.SQL Table is valid
function AST.SQL:IsValidTable(sTableName)

	if not isstring(sTableName) then
		return false, error("sTableName is not a valid string")
	end

	local tReturn = AST.SQL:Query("SELECT name FROM sqlite_master WHERE name = ? AND type = ?", sTableName, "table")

	if not istable(tReturn) then 
		return false
	end

	local bReturn = (istable(tReturn[1]) and true or false)
	return bReturn

end

-- Create a AST.SQL Table
function AST.SQL:CreateTable(sTableName, tColumns)

	-- Check if the table if not already valid
	local bValidTable = AST.SQL:IsValidTable(sTableName)

	if bValidTable then
		return false, print(("[AST] Table '%s' is already initialized"):format(sTableName))
	end

	local sQuery = "CREATE TABLE %s (\n%s\n)"
	local sAutoIncrement = "AUTOINCREMENT"
	local sColumn = ("	id INTEGER PRIMARY KEY %s,"):format(sAutoIncrement)

	local i = 1
	for sId, sType in pairs(tColumns) do
		sColumn = ("%s\n	%s %s%s"):format(sColumn, sId, sType, (table.Count(tColumns) == i and "" or ","))
		i = i + 1
	end

	sQuery = sQuery:format(sTableName, sColumn)
	AST.SQL:Query(sQuery)

	print(("[AST] Table '%s' has been initialized"):format(sTableName))

end

-- Send a AST.SQL query
function AST.SQL:Query(sQuery, ...)

	local tArgs = {...}
	local fcCallback

	for iArgId, xValue in ipairs(tArgs) do

		local sType = type(xValue)
		if not AST:GetConst("sQueryTypes", sType) then continue end

		if sType == "string" then
			xValue = sql.SQLStr(xValue)
		elseif sType == "table" then
			xValue = util.TableToJSON(xValue)
			if not isstring(xValue) then continue end
		end

		sQuery = sQuery:gsub("?", tostring(xValue), 1)

	end

    return sql.Query(sQuery)

end