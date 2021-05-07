util.AddNetworkString("playerBuildmodeStatus")

-- Checks all Players Buildmode and send it to the Client
hook.Add("Think", "SendPlayerBuildmode", function()
    for k,v in pairs(player.GetAll()) do
        state = v.buildmode
        net.Start("playerBuildmodeStatus")
        net.WriteBool(state)
        net.Send(v)
    end
end)   