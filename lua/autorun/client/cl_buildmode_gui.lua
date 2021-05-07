-- Creates Console Commands
CreateClientConVar("ulxbuildmode_gui_enable", "1", true, false, "If true then ULX Buildmode GUI will be drawn", 0, 1)
CreateClientConVar("ulxbuildmode_gui_position_x", "50", true, false, "Sets the X Position of GUI", 0, 100)
CreateClientConVar("ulxbuildmode_gui_position_y", "99", true, false, "Sets the Y Position of GUI", 0, 100)
concommand.Add("ulxbuildmode_gui_reset", function()
    GetConVar("ulxbuildmode_gui_position_x"):SetInt(50)
    GetConVar("ulxbuildmode_gui_position_y"):SetInt(99)
end)

-- Awaits for Net Messages
net.Receive("playerBuildmodeStatus", function()
    isPlayerBuild = net.ReadBool()
end)

-- Creates the Buildmode GUI Category in Utilities Tab
hook.Add("AddToolMenuTabs", "myHookClass", function()
    spawnmenu.AddToolCategory("Utilities", "BuildmodeGUI", "#Buildmode GUI")
end)

-- Creates the Settings Option in Buildmode GUI Category
hook.Add("PopulateToolMenu", "ShowOptions", function()
    spawnmenu.AddToolMenuOption( "Utilities", "BuildmodeGUI", "Custom_Menu", "#Settings", "", "", function(gui)
        gui:ClearControls()
        gui:CheckBox("Enable", "ulxbuildmode_gui_enable")
        gui:NumSlider("Position of X", "ulxbuildmode_gui_position_x", 0, 100, 0)
        gui:NumSlider("Position of Y", "ulxbuildmode_gui_position_y", 0, 100, 0)
        gui:Button("Reset to Defaults", "ulxbuildmode_gui_reset")
     end)
end)

-- Updates the Variables on every Frame
hook.Add("Think", "UpdateValues", function()
    realWidth = ((ScrW() - 100) / 100) * GetConVar("ulxbuildmode_gui_position_x"):GetInt()
    realHeight = ((ScrH() - 25) / 100) * GetConVar("ulxbuildmode_gui_position_y"):GetInt()  
end)

-- Draws the GUI
hook.Add("HUDPaint", "drawGUI", function()

    -- If the ConVar is set to true and Player is alive then it will be drawn
    if GetConVar("ulxbuildmode_gui_enable"):GetBool() and LocalPlayer():Alive() and isPlayerBuild != nil then
        draw.RoundedBox(0, realWidth, realHeight, 100, 25, Color(0, 0, 0, 240))

        -- If Client is in Buildmode then the GUI should draw BUILD else PVP will be drawn
        if isPlayerBuild then
            draw.DrawText("BUILD", "Trebuchet24", realWidth + 50, realHeight, Color(0, 200, 0, 255 ), TEXT_ALIGN_CENTER)
        else
            draw.DrawText("PVP", "Trebuchet24", realWidth + 50, realHeight, Color(2000, 0, 0, 255 ), TEXT_ALIGN_CENTER)
        end    
    end    
end)