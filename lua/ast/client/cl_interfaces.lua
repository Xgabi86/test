-- Open the main menu
function AST:OpenMainMenu(tInventory)

    if IsValid(self.vMainMenu) then
        self.vMainMenu:Remove()
    end

    local vFrame = vgui.Create("DFrame")
    vFrame:SetSize(AST:RX(1200), AST:RY(800))
    vFrame:Center()
    vFrame:SetTitle("")
    vFrame:MakePopup()
    vFrame:SetDraggable(false)
    vFrame:ShowCloseButton(false)
    vFrame:SetAlpha(0)
    vFrame.iSelected = 1
    vFrame.tPanels = {}
    function vFrame:Paint(w, h)

        draw.RoundedBox(8, 0, 0, w, h, AST:GetColor("black_bg2"))
        draw.RoundedBoxEx(8, 0, 0, w, AST:RY(60), AST:GetColor("black_bg1"), true, true, false, false)

        draw.SimpleText(("Boutique de %s Coins"):format(AST.Config.ServerName), AST:Font(30, "Medium"), AST:RX(20), AST:RY(30), AST:GetColor("white"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(("PC: %i"):format(LocalPlayer():GetPCoins()), AST:Font(30, "Medium"), w - AST:RX(60), AST:RY(30), AST:GetColor("white"), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    
    end

    vFrame:AlphaTo(255, 0.3, 0, function() end)
    self.vMainMenu = vFrame
    AST:ShowStoreMenu(tInventory)

    local vStore = vgui.Create("DButton", vFrame)
    vStore:SetSize(AST:RX(150), AST:RY(40))
    vStore:SetPos(AST:RX(25), AST:RY(80))
    vStore:SetText("")
    function vStore:Paint(w, h)
        draw.RoundedBox(4, 0, 0, w, h, AST:GetColor((self:IsHovered() and "green_bg1" or (vFrame.iSelected == 1 and "green_bg1" or "green_bg2"))))
        draw.SimpleText("Boutique", AST:Font((self:IsHovered() and 24 or (vFrame.iSelected == 1 and 24 or 22)), (self:IsHovered() and "Bold" or (vFrame.iSelected == 1 and "Bold" or "Medium"))), w / 2, h / 2, AST:GetColor("white"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    function vStore:DoClick()
        vFrame.iSelected = 1
        AST:ShowStoreMenu(tInventory)
    end

    local vInventory = vgui.Create("DButton", vFrame)
    vInventory:SetSize(AST:RX(150), AST:RY(40))
    vInventory:SetPos(AST:RX(185), AST:RY(80))
    vInventory:SetText("")
    function vInventory:Paint(w, h)
        draw.RoundedBox(4, 0, 0, w, h, AST:GetColor((self:IsHovered() and "green_bg1" or (vFrame.iSelected == 2 and "green_bg1" or "green_bg2"))))
        draw.SimpleText("Inventaire", AST:Font((self:IsHovered() and 24 or (vFrame.iSelected == 2 and 24 or 22)), (self:IsHovered() and "Bold" or (vFrame.iSelected == 2 and "Bold" or "Medium"))), w / 2, h / 2, AST:GetColor("white"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    function vInventory:DoClick()
        vFrame.iSelected = 2
        AST:ShowInventoryMenu(tInventory)
    end

    local vClose = vgui.Create("DButton", vFrame)
    vClose:SetSize(AST:RX(40), AST:RY(40))
    vClose:SetPos(AST:RX(1150), AST:RY(10))
    vClose:SetText("")
    function vClose:Paint(w, h)
        draw.SimpleText("✕", AST:Font(30, "Medium"), w / 2, h / 2, AST:GetColor("white"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    function vClose:DoClick()
        vFrame:AlphaTo(0, 0.3, 0, function() vFrame:Remove() end)
    end

end

-- Show the store menu
function AST:ShowStoreMenu(tInventory)

    if not IsValid(self.vMainMenu) then return end
    local vFrame = self.vMainMenu

    for i, v in ipairs(vFrame.tPanels) do
        if IsValid(v) then v:Remove() end
    end

    local vScroll = vgui.Create("DScrollPanel", vFrame)
    vScroll:Dock(FILL)
    vScroll:DockMargin(AST:RX(20), AST:RY(110), AST:RX(20), AST:RY(20))
    vScroll:GetVBar():SetWide(0)
    vFrame.tPanels[#vFrame.tPanels + 1] = vScroll

    local vList = vgui.Create("DIconLayout", vScroll)
    vList:Dock(FILL)
    vList:SetSpaceX(AST:RX(8))
    vList:SetSpaceY(AST:RY(8))

    for i, t in ipairs(AST.Config.ItemsConfig) do

        if AST:CheckItemPlayer(LocalPlayer(), t.iUniqueId, tInventory) then continue end

        if isstring(t.sIcon) then
            AST:ImgurToMaterial(t.sIcon, function(mIcon) end)
        end

        local vPack = vgui.Create("DPanel", vList)
        vPack:SetSize(AST:RX(280), AST:RY((isstring(t.sIcon) and 410 or 185)))
        function vPack:Paint(w, h)
            
            draw.RoundedBox(8, 0, 0, w, h, AST:GetColor("black_bg1"))

            draw.SimpleText(t.sName, AST:Font(26, "Bold"), w / 2, AST:RY((isstring(t.sIcon) and 280 or 48)), AST:GetColor("white"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(("Prix: %i PC"):format(t.iPriceCoins), AST:Font(22, "Medium"), w / 2, AST:RY((isstring(t.sIcon) and 305 or 70)), AST:GetColor("white"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(("Expiration: %s"):format((t.iExpireDays == 0 and "Jamais" or ("%s jour(s)"):format(t.iExpireDays))), AST:Font(22, "Medium"), w / 2, AST:RY((isstring(t.sIcon) and 325 or 90)), AST:GetColor("white"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            if isstring(t.sIcon) then
                surface.SetDrawColor(AST:GetColor("white"))
                surface.SetMaterial(Material(("../data/ast/%s"):format(t.sIcon:gsub("https://i.imgur.com/", ""):gsub(".jpeg", ".jpg"):lower())))
                surface.DrawTexturedRect(w / 2 - AST:RX(100), AST:RY(50), AST:RX(200), AST:RY(200))
            end

        end

        local vBuy = vgui.Create("DButton", vPack)
        vBuy:SetSize(AST:RX(260), AST:RY(40))
        vBuy:SetPos(AST:RX(10), vPack:GetTall() - AST:RY(50))
        vBuy:SetText("")
        function vBuy:Paint(w, h)
            draw.RoundedBox(4, 0, 0, w, h, AST:GetColor((self:IsHovered() and "green_bg1" or "green_bg2")))
            draw.SimpleText("Acheter ce pack", AST:Font((self:IsHovered() and 24 or 22), (self:IsHovered() and "Bold" or "Medium")), w / 2, h / 2, AST:GetColor("white"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        function vBuy:DoClick()

            net.Start("AST:BuyItem")
                net.WriteUInt(t.iUniqueId, 32)
            net.SendToServer()

        end

    end

end

-- Show the inventory menu
function AST:ShowInventoryMenu(tInventory)

    if not IsValid(self.vMainMenu) then return end
    local vFrame = self.vMainMenu

    for i, v in ipairs(vFrame.tPanels) do
        if IsValid(v) then v:Remove() end
    end

    local vScroll = vgui.Create("DScrollPanel", vFrame)
    vScroll:Dock(FILL)
    vScroll:DockMargin(AST:RX(20), AST:RY(110), AST:RX(20), AST:RY(20))
    vScroll:GetVBar():SetWide(0)
    vFrame.tPanels[#vFrame.tPanels + 1] = vScroll

    local vList = vgui.Create("DIconLayout", vScroll)
    vList:Dock(FILL)
    vList:SetSpaceX(AST:RX(8))
    vList:SetSpaceY(AST:RY(8))

    for i, t in ipairs(tInventory) do

        if not AST:FindItemByUniqueId(t.iUniqueId) then continue end
        local tItem = AST:FindItemByUniqueId(t.iUniqueId)

        if isstring(tItem.sIcon) then
            AST:ImgurToMaterial(tItem.sIcon, function(mIcon) end)
        end

        local vPack = vgui.Create("DPanel", vList)
        vPack:SetSize(AST:RX(280), AST:RY((isstring(tItem.sIcon) and 380 or 145)))
        function vPack:Paint(w, h)
            
            draw.RoundedBox(8, 0, 0, w, h, AST:GetColor("black_bg1"))

            draw.SimpleText(tItem.sName, AST:Font(26, "Bold"), w / 2, AST:RY((isstring(tItem.sIcon) and 280 or 48)), AST:GetColor("white"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(("Prix: %i PC"):format(tItem.iPriceCoins), AST:Font(22, "Medium"), w / 2, AST:RY((isstring(tItem.sIcon) and 305 or 70)), AST:GetColor("white"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(("Expire %s"):format((t.iExpireDays == 0 and "Jamais" or ("le %s"):format(os.date("%d/%m/%Y - %H:%M", t.iExpireDays)))), AST:Font(22, "Medium"), w / 2, AST:RY((isstring(tItem.sIcon) and 325 or 90)), AST:GetColor("white"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            if isstring(tItem.sIcon) then
                surface.SetDrawColor(AST:GetColor("white"))
                surface.SetMaterial(Material(("../data/ast/%s"):format(tItem.sIcon:gsub("https://i.imgur.com/", ""):gsub(".jpeg", ".jpg"):lower())))
                surface.DrawTexturedRect(w / 2 - AST:RX(100), AST:RY(50), AST:RX(200), AST:RY(200))
            end

        end

    end

end