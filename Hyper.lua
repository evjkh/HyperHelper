
getgenv()._ExecuteOn = {"your farmer username"}
script_key = "your key"

-------------------------------------------------------

repeat task.wait() until game:IsLoaded()
local Player = game:GetService("Players").LocalPlayer
if getgenv()._ExecuteOn then
    if type(getgenv()._ExecuteOn) == "string" then
        getgenv()._ExecuteOn = {getgenv()._ExecuteOn}
    end

    if not table.find(getgenv()._ExecuteOn, Player.Name) then
        return
    end
end
loadstring(game:HttpGet('https://api.luaauth.com/loader/EYxt0vXj3SUnAGxUbbSJQc81w445xsAb'))()
