-- https://evjkh.com
-- Notes: Fill in your username to the table below.

getgenv().USER = {"fh_helper"}


----------------------------------------------------------------------------


print("Awaiting game load..")
repeat wait() until game:IsLoaded()

-- 

print("Service load..")

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--

print("Player load..")

local Player = Players.LocalPlayer

if not table.find(getgenv().USER, Player.Name) then
    warn("Couldn't find user in list.")
    wait(999)
end

--

local ServersMain = nil
local ServersBase = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=%s&limit=100&excludeFullGames=true", game.PlaceId, "Asc")

if not isfile("HelperSHOP.json") then
    writefile("HelperSHOP.json", HttpService:JSONEncode({ LastUpdated = 0, Servers = {} }))
end

local function RefreshServers()
    print("RECACHING...")
    local ServersResponse = http.request({
        Url = ServersBase,
        Method = "GET"
    })

    if not ServersResponse or ServersResponse.StatusCode ~= 200 then
        print("Failed to fetch server list. Attempt again in 5.")
        task.wait(5)
        return RefreshServers()
    end

    local CachedServers = {}
    local ServersBody = HttpService:JSONDecode(ServersResponse.Body)

    if ServersBody and ServersBody.data then
        for i, v in next, ServersBody.data do
            if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.JobId then
                table.insert(CachedServers, v)
            end
        end
    end

    print("Wrote " .. #CachedServers .. " servers to cache.")
    writefile("HelperSHOP.json", HttpService:JSONEncode({ LastUpdated = tick(), Servers = CachedServers }))
end

local Started = false
local function SwitchServer(same)
    if not Started then
        Started = true
    else
        return
    end

    local Success = false
    Player.OnTeleport:Connect(function(state)
        if state == Enum.TeleportState.Started then
            Success = true
        end
    end)

    local ServersData = HttpService:JSONDecode(readfile("HelperSHOP.json"))
    if ServersData.LastUpdated < tick() - 120 or #ServersData.Servers == 0 then
        RefreshServers()
        ServersData = HttpService:JSONDecode(readfile("HelperSHOP.json"))
    end
    ServersMain = ServersData.Servers

    local Servers = {}
    local Server = nil

    for i, v in pairs(ServersMain) do
        if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.JobId then
            table.insert(Servers, v)
        end
    end

    while not Success do
        warn(pcall(function()
            if #Servers > 0 then
                Server = Servers[math.random(1, #Servers)]
                if Server.id ~= game.JobId then

                    for i = #ServersMain, 1, -1 do
                        if ServersMain[i].id == Server.id then
                            table.remove(ServersData.Servers, i)
                        end
                    end

                    writefile("HelperSHOP.json", HttpService:JSONEncode(ServersData))
                    
                    pcall(function()
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, Server.id, Player)
                        TeleportService.TeleportInitFailed:Wait()
                        task.wait(2)
                    end)
                end
            end

            task.wait(5)
            if Success then
                wait(math.huge)
            else
                TeleportService:Teleport(game.PlaceId, Player)
            end
        end))

        task.wait()
    end
end

delay(15, function() SwitchServer() end)

--

local Mapped = {
    CFrame.new(1495, 85, -1049), CFrame.new(1305, 52, 264), CFrame.new(1150, 62, -742), CFrame.new(1188, 48, 424), CFrame.new(896, 79, -658), CFrame.new(966, 56, 395), CFrame.new(649, 58, -473), CFrame.new(766, 54, 520),
    CFrame.new(-738, 59, -3265), CFrame.new(-358, 97, -3231), CFrame.new(-423, 39, -3723), CFrame.new(241, 42, -3454), CFrame.new(-116, 31, -3972), CFrame.new(304, 41, -3904), CFrame.new(383, 31, -4217),
}
local Camera = Workspace.CurrentCamera
local TweenInfos = TweenInfo.new(0.4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0)
Camera.CameraType = "Scriptable"

for _, pos in pairs(Mapped) do
    local CamTween = TweenService:Create(Camera, TweenInfos, { CFrame = pos })
    CamTween:Play()

    repeat task.wait() until CamTween.PlaybackState == Enum.PlaybackState.Completed or Workspace:FindFirstChild("Drop")
    pcall(function() CamTween:Cancel() end)
    if Workspace:FindFirstChild("Drop") then break end
end

--

local RobberyConsts = require(ReplicatedStorage:WaitForChild("Robbery"):WaitForChild("RobberyConsts"))
local RobberyState = ReplicatedStorage:WaitForChild("RobberyState")

local ToSend = "?id=" .. game.JobId
if RobberyState[RobberyConsts.ENUM_ROBBERY.JEWELRY].Value ~= 3 then
    ToSend = ToSend .. "&jewelry=true"
end
if RobberyState[RobberyConsts.ENUM_ROBBERY.MANSION].Value == 1 then
    ToSend = ToSend .. "&mansion=true"
end
if Workspace:FindFirstChild("Drop") then
    ToSend = ToSend .. "&airdrop=true"
end

if ToSend ~= ("?id=" .. game.JobId) then
    local resp = request({
        -- Url = "https://farm-log.evjkh.com/report" .. ToSend ,
        Url = "http://localhost:1796/report" .. ToSend,
        Method = "GET",  
    })
end

SwitchServer()
