-- Open the menu after a buying
net.Receive("AST:OpenStoreMenu", function()
    AST:OpenMainMenu(net.ReadTable())
end)