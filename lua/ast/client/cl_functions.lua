-- Automatic responsive functions
function AST:RX(x)
    return x / 1920 * ScrW()
end

function AST:RY(y)
    return y / 1080 * ScrH()
end

-- Create automatic responsive font
function AST:Font(iSize, sFont, iWeight, b3D2D)

    sFont = sFont or "Medium"
    iSize = iSize or 25
    iWeight = iWeight or 500
    b3D2D = b3D2D or false
    
    local sName = ("AST:Font:"..sFont..":"..tostring(iSize)..":"..tostring(b3D2D))
	if not AST:GetFont(sFont) then return end

    if not AST.Fonts[sName] then
        
        surface.CreateFont(sName, {
            font = "Montserrat "..sFont,
            extended = false,
            size = (b3D2D and iSize or AST:RX(iSize)),
            weight = iWeight
        })

        AST.Fonts[sName] = true

    end

    return sName

end

-- Convert an imgur image to a material
function AST:ImgurToMaterial(sImgur, fcCallback)    

    local sImageID = sImgur:gsub("https://i.imgur.com/", ""):gsub(".jpeg", ".jpg")
    local sURL = "https://i.imgur.com/"..sImageID

    -- Fetch the data from the image and save it to a data file
    http.Fetch(sURL, function(sData)

        if not file.IsDir("ast/", "DATA") then
            file.CreateDir("ast/")
        end

        sImageID = sImageID:lower()
        
        if file.Exists("ast/"..sImageID, "DATA") then
            local mMaterial = Material("../data/ast/"..sImageID)
            if isfunction(fcCallback) then fcCallback(mMaterial, "../data/ast/"..sImageID) end
            return
        end

        file.Write("ast/"..sImageID, sData)

        local mMaterial = Material("../data/ast/"..sImageID)
        if isfunction(fcCallback) then fcCallback(mMaterial, "../data/ast/"..sImageID) end

    end)

end