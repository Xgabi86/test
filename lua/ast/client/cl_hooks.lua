-- Called when the player change the size of the screen
hook.Add("OnScreenSizeChanged", "AST:OnScreenSizeChanged", function()
    AST.Fonts = {}
end)