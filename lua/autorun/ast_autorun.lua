AST = AST or {}
AST.Constants = AST.Constants or {}
AST.SQL = AST.SQL or {}

AST.Config = AST.Config or {}
AST.Fonts = AST.Fonts or {}

-- Make loading functions
local function Inclu(f) return include("ast/"..f) end
local function AddCS(f) return AddCSLuaFile("ast/"..f) end
local function IncAdd(f) return Inclu(f), AddCS(f) end

local function AddMat(f) return resource.AddSingleFile("materials/ast/"..f) end
local function AddRes(f) return resource.AddSingleFile("resource/fonts/"..f) end

-- Load shared files
IncAdd("sh_constants.lua")
IncAdd("shared/sh_functions.lua")
IncAdd("shared/sh_meta.lua")

-- Load libraries shared files
IncAdd("libraries/localnwvars.lua")

-- Load addon files
IncAdd("sh_config.lua")

if SERVER then

	-- Load server content
	Inclu("server/sv_sql.lua")
	Inclu("server/sv_functions.lua")
	Inclu("server/sv_hooks.lua")
	Inclu("server/sv_concommands.lua")
	Inclu("server/sv_network.lua")

    -- Load client content
	AddCS("client/cl_functions.lua")
    AddCS("client/cl_interfaces.lua")
	AddCS("client/cl_network.lua")
	AddCS("client/cl_hooks.lua")

	-- Load fonts --
	AddRes("Montserrat-Bold.ttf")
	AddRes("Montserrat-Light.ttf")
	AddRes("Montserrat-Medium.ttf")

else

	-- Load client content
	Inclu("client/cl_functions.lua")
    Inclu("client/cl_interfaces.lua")
	Inclu("client/cl_network.lua")
	Inclu("client/cl_hooks.lua")

end