--[[

 █     █░  █████▒▄▄▄█████▓ ▄▄▄       ██▓███  
▓█░ █ ░█░▓██   ▒ ▓  ██▒ ▓▒▒████▄    ▓██░  ██▒
▒█░ █ ░█ ▒████ ░ ▒ ▓██░ ▒░▒██  ▀█▄  ▓██░ ██▓▒
░█░ █ ░█ ░▓█▒  ░ ░ ▓██▓ ░ ░██▄▄▄▄██ ▒██▄█▓▒ ▒
░░██▒██▓ ░▒█░      ▒██▒ ░  ▓█   ▓██▒▒██▒ ░  ░
░ ▓░▒ ▒   ▒ ░      ▒ ░░    ▒▒   ▓▒█░▒▓▒░ ░  ░
  ▒ ░ ░   ░          ░      ▒   ▒▒ ░░▒ ░     
  ░   ░   ░ ░      ░        ░   ▒   ░░       
    ░                           ░  ░         
--]]

local vu1 = game:GetService("Players").LocalPlayer
local v2 = game:GetService("ReplicatedStorage")
local v3 = game:GetService("Players")
game:GetService("RunService")
v2:FindFirstChild("GrabEvents"):FindFirstChild("SetNetworkOwner")
local v4 = v3.LocalPlayer
workspace:FindFirstChild(v4.Name .. "SpawnedInToys")
local vu5 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Jeffepicy/OrionGod/refs/heads/main/CosmicOrion", true))()
local v6 = vu5
vu5.MakeNotification(v6, {
    Name = "Welcome to Cosmic Hub: Auras!\t",
    Content = "You’re Whitelisted! wink wink",
    Image = "rbxassetid://4483345998",
    Time = 20
})
local vu7 = game:GetService("ReplicatedStorage")
local vu8 = game:GetService("Players")
local vu9 = game:GetService("RunService")
local v10 = vu7
local vu11 = vu7.FindFirstChild(v10, "GrabEvents"):FindFirstChild("SetNetworkOwner")
local vu12 = vu8.LocalPlayer
local vu13 = workspace:FindFirstChild(vu12.Name .. "SpawnedInToys")
local vu14 = false
local vu15 = 10
local vu16 = 2
local vu17 = 3
local vu18 = {}
local vu19 = {}
local vu20 = nil
local vu21 = false
local vu22 = nil
local v23 = vu5
local v24 = vu5.MakeWindow(v23, {
    Name = "Cosmic Hub Auras",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "CosmicHubAuras"
})
local v25 = v24:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://6031075927",
    PremiumOnly = false
})
v25:AddSection({
    Name = "Movement"
})
_G = {}
_G.Walkspeed = false
_G.WalkspeedValue = 5
_G.InfiniteJump = false
_G.InfiniteJumpPower = 100
_G.Noclip = false
_G.Connections = {}
local vu26 = game:GetService("UserInputService")
function _G.WalkspeedFunc()
    if _G.Connections.WS then
        _G.Connections.WS:Disconnect()
    end
    if _G.Walkspeed then
        _G.Connections.WS = vu9.Stepped:Connect(function()
            p = vu8.LocalPlayer
            if p and p.Character and (p.Character:FindFirstChild("HumanoidRootPart") and (p.Character:FindFirstChildOfClass("Humanoid") and typeof(_G.WalkspeedValue) == "number")) then
                h = p.Character.HumanoidRootPart
                u = p.Character:FindFirstChildOfClass("Humanoid")
                h.CFrame = h.CFrame + u.MoveDirection * (16 * _G.WalkspeedValue / 10)
            end
        end)
    end
end
function _G.InfiniteJumpFunc()
    if _G.Connections.JP then
        _G.Connections.JP:Disconnect()
    end
    if _G.InfiniteJump then
        _G.Connections.JP = vu26.JumpRequest:Connect(function()
            local v27 = vu8.LocalPlayer
            if v27 and v27.Character and v27.Character:FindFirstChildOfClass("Humanoid") then
                local v28 = v27.Character:FindFirstChildOfClass("Humanoid")
                v28:ChangeState(Enum.HumanoidStateType.Freefall)
                task.wait()
                v28:ChangeState(Enum.HumanoidStateType.Jumping)
                if v28.UseJumpPower == false then
                    v28.JumpHeight = math.clamp(_G.InfiniteJumpPower / 10, 7.2, 50)
                else
                    v28.JumpPower = _G.InfiniteJumpPower
                end
            end
        end)
    end
end
function _G.NoclipFunc()
    if _G.Connections.NC then
        _G.Connections.NC:Disconnect()
    end
    if _G.Noclip then
        _G.Connections.NC = vu9.Stepped:Connect(function()
            p = vu8.LocalPlayer
            if p and p.Character then
                local v29, v30, v31 = ipairs(p.Character:GetDescendants())
                while true do
                    local v32
                    v31, v32 = v29(v30, v31)
                    if v31 == nil then
                        break
                    end
                    if v32:IsA("BasePart") then
                        v32.CanCollide = false
                    end
                end
            end
        end)
    end
end
v25:AddToggle({
    Name = "Walkspeed",
    Default = false,
    Callback = function(p33)
        _G.Walkspeed = p33
        _G.WalkspeedFunc()
    end
})
v25:AddSlider({
    Name = "Speed Multiplier",
    Min = 1,
    Max = 5,
    Default = 0.1,
    Increment = 0.1,
    Callback = function(p34)
        _G.WalkspeedValue = p34
    end
})
v25:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(p35)
        _G.InfiniteJump = p35
        _G.InfiniteJumpFunc()
    end
})
v25:AddSlider({
    Name = "Jump Power",
    Min = 16,
    Max = 500,
    Default = 16,
    Increment = 1,
    Callback = function(p36)
        _G.InfiniteJumpPower = p36
    end
})
v25:AddToggle({
    Name = "Noclip",
    Default = false,
    Callback = function(p37)
        _G.Noclip = p37
        _G.NoclipFunc()
    end
})
local v38 = v24:MakeTab({
    Name = "Invincibility",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})
v38:AddSection({
    Name = "Anti"
})
local function vu44()
    if RagdollEvent then
        local v39 = vu8
        local v40, v41, v42 = pairs(v39:GetPlayers())
        while true do
            local v43
            v42, v43 = v40(v41, v42)
            if v42 == nil then
                break
            end
            if v43.Character and v43.Character:FindFirstChild("HumanoidRootPart") then
                for _ = 1, 150 do
                    RagdollEvent:FireServer(v43.Character.HumanoidRootPart, 9999999)
                    wait()
                end
            end
        end
    else
        vu5:MakeNotification({
            Name = "Error",
            Content = "error",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
end
v38:AddButton({
    Name = "Anti Ragdoll/Snowball",
    Callback = function()
        vu44()
    end
})
v38:AddButton({
    Name = "Destroy Void",
    Callback = function()
        workspace.FallenPartsDestroyHeight = - 1e95
    end
})
local vu55 = {
    Players = game:GetService("Players"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    RunService = game:GetService("RunService"),
    LP = game.Players.LocalPlayer,
    spawnGucci = function()
        return vu55.ReplicatedStorage.MenuToys.SpawnToyRemoteFunction:InvokeServer("CreatureBlobman", CFrame.new(0, 50000, 0) * CFrame.Angles(- 0.7351, 0.9028, 0.6173), Vector3.new(0, 59.667, 0))
    end,
    setup = function()
        vu55.spawnGucci()
        local vu45 = vu55.LP.Name
        local vu46 = workspace
        local v47 = vu55.LP.Character or vu55.LP.CharacterAdded:Wait()
        local v48 = vu46:FindFirstChild(vu45 .. "SpawnedInToys")
        local v49 = nil
        local v50
        if v48 then
            v50 = v48:FindFirstChild("CreatureBlobman")
        else
            v50 = nil
        end
        if v50 then
            v49 = v50:FindFirstChild("Head")
        end
        if v49 then
            v49.CFrame = CFrame.new(0, 50000, 0)
            v49.Anchored = true
        end
        task.wait(0.1)
        local vu51 = v47:WaitForChild("Humanoid")
        local vu52 = v47:WaitForChild("HumanoidRootPart")
        local vu53 = vu52.Position
        local vu54 = false
        if v50 then
            v50 = v50:FindFirstChild("VehicleSeat")
        end
        if v50 and v50:IsA("VehicleSeat") then
            vu52.CFrame = v50.CFrame + Vector3.new(0, 2, 0)
            v50:Sit(vu51)
            vu54 = true
        end
        vu51:GetPropertyChangedSignal("Jump"):Connect(function()
            if vu54 and vu51.Jump then
                task.wait(0.02)
                vu52.CFrame = CFrame.new(vu53)
                vu54 = false
            end
        end)
        vu55.ragdollConn = vu55.RunService.Heartbeat:Connect(function()
            if vu55.enabled and vu54 then
                pcall(function()
                    vu55.ReplicatedStorage.CharacterEvents.RagdollRemote:FireServer(vu46[vu45].HumanoidRootPart, 0)
                end)
            end
        end)
        vu55.posCheckConn = vu55.RunService.Heartbeat:Connect(function()
            if vu55.enabled and (vu52.Position - vu53).Magnitude < 1 then
                vu54 = false
            end
        end)
    end
}
v38:AddToggle({
    Name = " Gucci Anti",
    Default = false,
    Callback = function(p56)
        vu55.enabled = p56
        if p56 then
            vu55.setup()
        else
            if vu55.ragdollConn then
                vu55.ragdollConn:Disconnect()
                vu55.ragdollConn = nil
            end
            if vu55.posCheckConn then
                vu55.posCheckConn:Disconnect()
                vu55.posCheckConn = nil
            end
        end
    end
})
local vu57 = false
local function vu60()
    while vu57 and task.wait() do
        if plr:FindFirstChild("IsHeld") and plr.IsHeld.Value == true then
            local v58 = plr.Character
            local v59 = v58 and v58:FindFirstChild("HumanoidRootPart")
            if v59 then
                v59.Anchored = true
                while plr.IsHeld.Value == true and vu57 do
                    vu7.CharacterEvents.Struggle:FireServer(plr)
                    task.wait(0.001)
                end
                v59.Anchored = false
            end
        end
    end
end
v38:AddToggle({
    Name = "Anti Grab",
    Default = false,
    Callback = function(p61)
        vu57 = p61
        if vu57 then
            task.spawn(vu60)
        end
    end
})
local vu62 = false
local function vu67()
    workspace.ChildAdded:Connect(function(p63)
        local v64 = p63:IsA("Part") and (p63.Name == "Part" and (vu62 and plr.Character))
        if v64 then
            local v65 = v64:FindFirstChild("HumanoidRootPart")
            local v66 = v64:FindFirstChild("Right Arm")
            if v65 and (v66 and (p63.Position - v65.Position).Magnitude <= 20) then
                v65.Anchored = true
                task.wait(0.01)
                while v66:FindFirstChild("RagdollLimbPart") and v66.RagdollLimbPart.CanCollide == true do
                    task.wait(0.001)
                end
                v65.Anchored = false
            end
        end
    end)
end
v38:AddToggle({
    Name = "Anti Explode",
    Default = false,
    Callback = function(p68)
        vu62 = p68
        if vu62 then
            task.spawn(vu67)
        end
    end
})
v38:AddToggle({
    Name = "Anti Fire",
    Default = false,
    Callback = function(p69)
        local vu70 = {
            p = game:GetService("Players").LocalPlayer,
            rs = game:GetService("RunService"),
            w = game:GetService("Workspace"),
            mon = false,
            con = nil
        }
        vu70.ep = vu70.w.Map.Hole.PoisonBigHole.ExtinguishPart
        vu70.op = vu70.ep.Position
        local function vu74()
            local v71 = (vu70.p.Character or vu70.p.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
            local v72 = v71:FindFirstChild("FireLight")
            local v73 = v71:FindFirstChild("FireParticleEmitter")
            if v72 or v73 then
                vu70.ep.CFrame = CFrame.new(v71.Position)
                while v72 or v73 do
                    task.wait(0.1)
                    v72 = v71:FindFirstChild("FireLight")
                    v73 = v71:FindFirstChild("FireParticleEmitter")
                    vu70.ep.CFrame = CFrame.new(v71.Position)
                end
                vu70.ep.CFrame = CFrame.new(vu70.op)
            end
        end
        vu70.mon = p69
        if p69 then
            if not vu70.con then
                vu70.con = vu70.rs.Heartbeat:Connect(function()
                    if vu70.mon then
                        vu74()
                    end
                end)
            end
        else
            vu70.ep.CFrame = CFrame.new(vu70.op)
            if vu70.con then
                vu70.con:Disconnect()
                vu70.con = nil
            end
        end
    end
})
local vu75 = {
    toggle = false,
    lp = game.Players.LocalPlayer,
    ws = game.Workspace,
    drop = CFrame.new(- 238.98, - 256.01, - 123.97)
}
local function vu97()
    while vu75.toggle do
        local function v87(p76)
            local v77, v78, v79 = pairs(p76:GetDescendants())
            local v80 = {}
            while true do
                local v81
                v79, v81 = v77(v78, v79)
                if v79 == nil then
                    break
                end
                if v81:IsA("Model") and v81:FindFirstChild("HoldPart") and v81:FindFirstChild("HoldPart"):FindFirstChild("HoldItemRemoteFunction") then
                    table.insert(v80, v81)
                end
            end
            for v82 = # v80, 1, - 1 do
                local vu83 = v80[v82]
                local v84 = vu83:FindFirstChild("HoldPart")
                if v84 then
                    local vu85 = v84:FindFirstChild("HoldItemRemoteFunction")
                    if vu85 then
                        pcall(function()
                            vu85:InvokeServer(vu83, vu75.lp.Character)
                        end)
                    end
                    local vu86 = v84:FindFirstChild("DropItemRemoteFunction")
                    if vu86 then
                        pcall(function()
                            vu86:InvokeServer(vu83, vu75.drop, Vector3.new())
                        end)
                    end
                end
                table.remove(v80, v82)
                task.wait(0.2)
            end
        end
        local v88, v89, v90 = pairs(vu75.ws:GetChildren())
        while true do
            local v91
            v90, v91 = v88(v89, v90)
            if v90 == nil then
                break
            end
            if v91:IsA("Folder") and v91.Name:find("SpawnedInToys") then
                v87(v91)
            end
        end
        local v92 = vu75.ws:FindFirstChild("PlotItems")
        if v92 then
            local v93, v94, v95 = pairs(v92:GetChildren())
            while true do
                local v96
                v95, v96 = v93(v94, v95)
                if v95 == nil then
                    break
                end
                if v96:IsA("Folder") then
                    v87(v96)
                end
            end
        end
        task.wait(0.001)
    end
end
v38:AddToggle({
    Name = "Grab All Items",
    Default = false,
    Color = Color3.fromRGB(255, 204, 0),
    Callback = function(p98)
        vu75.toggle = p98
        if p98 then
            task.spawn(vu97)
        end
    end
})
local function vu103()
    local v99 = game.Players.LocalPlayer.Character
    if v99 then
        local v100 = v99:FindFirstChild("HumanoidRootPart")
        local v101 = v99:FindFirstChild("Humanoid")
        local v102 = game.Players.LocalPlayer:FindFirstChild("PlayerScripts")
        if v102 then
            v102 = game.Players.LocalPlayer.PlayerScripts:FindFirstChild("CharacterAndBeamMove")
        end
        if v100 and (v101 and v102) then
            v102.Disabled = antiLagT
        end
    end
end
v38:AddToggle({
    Name = "Anti Lag",
    Default = false,
    Callback = function(p104)
        antiLagT = p104
        vu103()
    end
})
local function vu111()
    local v105 = vu1.Character
    if v105 then
        local v106 = v105:FindFirstChild("HumanoidRootPart")
        if v106 then
            local v107, v108, v109 = pairs(workspace:GetDescendants())
            while true do
                local v110
                v109, v110 = v107(v108, v109)
                if v109 == nil then
                    break
                end
                if v110:IsA("BasePart") and (v110.Name == "LeftDetector" or v110.Name == "RightDetector") and (v106.Position - v110.Position).Magnitude > 10 then
                    v110:Destroy()
                end
            end
        end
    else
        return
    end
end
local function vu116()
    while vu14 do
        if vu1.Character then
            local v112, v113, v114 = ipairs(vu1.Character:GetDescendants())
            while true do
                local v115
                v114, v115 = v112(v113, v114)
                if v114 == nil then
                    break
                end
                if v115:IsA("BasePart") and v115.Massless then
                    v115.Massless = false
                end
            end
        end
        task.wait(1)
    end
end
v38:AddToggle({
    Name = "Anti Blobman",
    Default = false,
    Callback = function(p117)
        vu14 = p117
        if vu14 then
            vu5:MakeNotification({
                Name = "Anti Blobman",
                Content = "Anti Blobman & Anti Massless enabled",
                Time = 2
            })
            task.spawn(function()
                while vu14 do
                    vu111()
                    task.wait(1)
                end
            end)
            task.spawn(vu116)
        else
            vu5:MakeNotification({
                Name = "Anti Blobman",
                Content = "Anti Blobman & Anti Massless disabled",
                Time = 2
            })
        end
    end
})
local v118 = v24:MakeTab({
    Name = "Orbit Aura",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
v38:AddLabel("GET HOUSE FULL OF SPARKLERS")
local vu119 = false
local function vu129(p120)
    local v121, v122, v123 = ipairs(vu18)
    while true do
        local v124
        v123, v124 = v121(v122, v123)
        if v123 == nil then
            break
        end
        if v124:IsA("Model") then
            local v125, v126, v127 = ipairs(v124:GetDescendants())
            while true do
                local v128
                v127, v128 = v125(v126, v127)
                if v127 == nil then
                    break
                end
                if v128:IsA("BasePart") then
                    v128.CanCollide = not p120
                    v128.CanTouch = not p120
                    v128.CanQuery = not p120
                end
            end
        end
    end
end
local function vu130()
    while vu119 do
        vu129(true)
        vu9.Stepped:Wait()
    end
    vu129(false)
end
v118:AddToggle({
    Name = "Enable Sparkler Noclip",
    Default = false,
    Callback = function(p131)
        vu119 = p131
        if vu119 then
            task.spawn(vu130)
        else
            vu129(false)
        end
    end
})
local function vu138()
    local v132 = vu8
    local v133, v134, v135 = pairs(v132:GetPlayers())
    local v136 = {}
    while true do
        local v137
        v135, v137 = v133(v134, v135)
        if v135 == nil then
            break
        end
        if v137 ~= vu12 then
            table.insert(v136, v137.Name)
        end
    end
    return v136
end
local function vu140(p139)
    p139:Refresh(vu138(), true)
end
local vu142 = v118:AddDropdown({
    Name = "Select Player",
    Default = nil,
    Options = vu138(),
    Callback = function(p141)
        vu20 = vu8:FindFirstChild(p141)
    end
})
vu140(vu142)
v118:AddToggle({
    Name = "Follow Player",
    Default = false,
    Callback = function(p143)
        vu21 = p143
    end
})
local function vu145(p144)
    if p144 and (p144:IsA("BasePart") and not vu19[p144]) then
        vu11:FireServer(p144, p144.CFrame)
        vu19[p144] = true
    end
end
local function vu153(p146)
    if vu13 and p146 then
        local v147 = vu13
        local v148, v149, v150 = pairs(v147:GetChildren())
        while true do
            local v151
            v150, v151 = v148(v149, v150)
            if v150 == nil then
                break
            end
            if v151:IsA("Model") and (v151.Name == "FireworkSparkler" and v151:FindFirstChild("SoundPart")) then
                local v152 = v151.SoundPart
                if (v152.Position - p146.Position).Magnitude <= 40 and not vu19[v152] then
                    vu145(v152)
                    table.insert(vu18, v151)
                end
            end
        end
    end
end
local function vu159()
    while vu14 do
        local v154, v155, v156 = ipairs(vu18)
        while true do
            local v157
            v156, v157 = v154(v155, v156)
            if v156 == nil then
                break
            end
            local v158 = v157:FindFirstChild("SoundPart")
            if v158 and v158.Position.Y < - 5000 then
                v158.Position = vu12.Character and (vu12.Character:FindFirstChild("HumanoidRootPart") and vu12.Character.HumanoidRootPart.Position + Vector3.new(0, 10, 0)) or Vector3.new(0, 10, 0)
            end
        end
        task.wait(1)
    end
end
local function vu170()
    local v160 = workspace:FindFirstChild("PlotItems")
    if v160 then
        local v161 = {}
        local v162 = 0
        for v163 = 1, 5 do
            local v164 = v160:FindFirstChild("Plot" .. v163)
            if v164 then
                local v165, v166, v167 = pairs(v164:GetDescendants())
                while true do
                    local v168
                    v167, v168 = v165(v166, v167)
                    if v167 == nil then
                        break
                    end
                    if v168:IsA("Model") and v168.Name == "FireworkSparkler" then
                        local v169 = v168:FindFirstChild("SoundPart")
                        if v169 then
                            if not vu19[v169] then
                                vu11:FireServer(v169, v169.CFrame)
                                vu19[v169] = true
                            end
                            table.insert(v161, v168)
                            v162 = v162 + 1
                        end
                    end
                end
            end
        end
        vu18 = v161
        print("Active FireworkSparklers: " .. v162)
    end
end
task.spawn(function()
    while true do
        vu170()
        task.wait(0.1)
    end
end)
workspace.FallenPartsDestroyHeight = - 9000000000
local function vu183()
    vu170()
    local v171 = vu153
    local v172 = vu12.Character
    if v172 then
        v172 = vu12.Character:FindFirstChild("HumanoidRootPart")
    end
    v171(v172)
    while vu14 do
        local v173 = vu21 and vu20 or vu12
        if v173 then
            v173 = v173.Character
        end
        if v173 then
            v173 = v173:FindFirstChild("HumanoidRootPart")
        end
        if v173 then
            local v174 = 360 / math.max(1, # vu18)
            local v175, v176, v177 = ipairs(vu18)
            while true do
                local v178
                v177, v178 = v175(v176, v177)
                if v177 == nil then
                    break
                end
                local v179 = v178:FindFirstChild("SoundPart")
                if v179 then
                    local v180 = v179:FindFirstChildOfClass("BodyPosition")
                    if not v180 then
                        v180 = Instance.new("BodyPosition")
                        v180.MaxForce = Vector3.new(5e18, 5e18, 5e18)
                        v180.D = 1000
                        v180.P = 50000
                        v180.Parent = v179
                    end
                    local v181 = v179:FindFirstChildOfClass("BodyGyro")
                    if not v181 then
                        v181 = Instance.new("BodyGyro")
                        v181.MaxTorque = Vector3.new(5e18, 5e18, 5e18)
                        v181.D = 1000
                        v181.P = 50000
                        v181.Parent = v179
                    end
                    local v182 = math.rad((tick() * vu16 * 20 + v177 * v174) % 360)
                    v180.Position = v173.Position + Vector3.new(math.cos(v182) * vu15, vu17, math.sin(v182) * vu15)
                    v181.CFrame = CFrame.new(v179.Position, v173.Position)
                end
            end
        end
        task.wait(1e-10)
    end
end
v118:AddToggle({
    Name = "Sparkler Aura",
    Default = false,
    Callback = function(p184)
        vu14 = p184
        if vu14 then
            if vu22 then
                coroutine.yield(vu22)
            end
            vu22 = coroutine.create(vu183)
            coroutine.resume(vu22)
            coroutine.wrap(vu159)()
        else
            vu22 = nil
        end
    end
})
v118:AddSlider({
    Name = "Orbit Radius",
    Min = 11,
    Max = 5000,
    Default = 10,
    Increment = 1,
    Callback = function(p185)
        vu15 = p185
    end
})
v118:AddSlider({
    Name = "Orbit Speed",
    Min = 0.5,
    Max = 1000,
    Default = 2,
    Increment = 0.1,
    Callback = function(p186)
        vu16 = p186
    end
})
v118:AddSlider({
    Name = "Orbit Height",
    Min = 1,
    Max = 1000,
    Default = 3,
    Increment = 1,
    Callback = function(p187)
        vu17 = p187
    end
})
local function v188(_)
    if vu14 then
        if vu22 then
            coroutine.yield(vu22)
        end
        vu22 = coroutine.create(vu183)
        coroutine.resume(vu22)
    end
end
vu12.CharacterAdded:Connect(v188)
vu8.PlayerAdded:Connect(function()
    vu140(vu142)
end)
vu8.PlayerRemoving:Connect(function()
    vu140(vu142)
end)
local vu189 = false
local vu190 = 5
local vu191 = 10
local vu192 = {}
local vu193 = {
    A = {
        Vector3.new(0, 0, 0),
        Vector3.new(0, 0, 5),
        Vector3.new(2, 0, 5),
        Vector3.new(2, 0, 0),
        Vector3.new(0, 0, 2.5),
        Vector3.new(2, 0, 2.5)
    },
    B = {
        Vector3.new(0, 0, 0),
        Vector3.new(0, 0, 5),
        Vector3.new(1.5, 0, 4),
        Vector3.new(0, 0, 2.5),
        Vector3.new(1.5, 0, 1),
        Vector3.new(0, 0, 0)
    },
    C = {
        Vector3.new(2, 0, 5),
        Vector3.new(0, 0, 5),
        Vector3.new(0, 0, 0),
        Vector3.new(2, 0, 0)
    },
    D = {
        Vector3.new(0, 0, 0),
        Vector3.new(0, 0, 5),
        Vector3.new(2, 0, 4),
        Vector3.new(2, 0, 1),
        Vector3.new(0, 0, 0)
    },
    E = {
        Vector3.new(2, 0, 5),
        Vector3.new(0, 0, 5),
        Vector3.new(0, 0, 0),
        Vector3.new(2, 0, 0),
        Vector3.new(0, 0, 2.5),
        Vector3.new(1.5, 0, 2.5)
    },
    F = {
        Vector3.new(0, 0, 5),
        Vector3.new(0, 0, 0),
        Vector3.new(0, 0, 2.5),
        Vector3.new(1.5, 0, 2.5)
    },
    G = {
        Vector3.new(2, 0, 5),
        Vector3.new(0, 0, 5),
        Vector3.new(0, 0, 0),
        Vector3.new(2, 0, 0),
        Vector3.new(2, 0, 2.5),
        Vector3.new(1, 0, 2.5)
    },
    H = {
        Vector3.new(0, 0, 5),
        Vector3.new(0, 0, 0),
        Vector3.new(2, 0, 5),
        Vector3.new(2, 0, 0),
        Vector3.new(0, 0, 2.5),
        Vector3.new(2, 0, 2.5)
    },
    I = {
        Vector3.new(1, 0, 5),
        Vector3.new(1, 0, 0)
    },
    I_dot = {
        Vector3.new(1, 0.5, 5)
    },
    J = {
        Vector3.new(2, 0, 5),
        Vector3.new(2, 0, 0),
        Vector3.new(0, 0, 0),
        Vector3.new(0, 0, 1)
    },
    K = {
        Vector3.new(0, 0, 5),
        Vector3.new(0, 0, 0),
        Vector3.new(2, 0, 5),
        Vector3.new(0, 0, 2.5),
        Vector3.new(2, 0, 0)
    },
    L = {
        Vector3.new(0, 0, 5),
        Vector3.new(0, 0, 0),
        Vector3.new(2, 0, 0)
    },
    M = {
        Vector3.new(0, 0, 0),
        Vector3.new(0, 0, 5),
        Vector3.new(1, 0, 3.5),
        Vector3.new(2, 0, 5),
        Vector3.new(2, 0, 0)
    },
    N = {
        Vector3.new(0, 0, 0),
        Vector3.new(0, 0, 5),
        Vector3.new(2, 0, 0),
        Vector3.new(2, 0, 5)
    },
    O = {
        Vector3.new(1, 0, 5),
        Vector3.new(0, 0, 4),
        Vector3.new(0, 0, 1),
        Vector3.new(1, 0, 0),
        Vector3.new(2, 0, 1),
        Vector3.new(2, 0, 4),
        Vector3.new(1, 0, 5)
    },
    P = {
        Vector3.new(0, 0, 0),
        Vector3.new(0, 0, 5),
        Vector3.new(2, 0, 5),
        Vector3.new(2, 0, 2.5),
        Vector3.new(0, 0, 2.5)
    },
    Q = {
        Vector3.new(1, 0, 5),
        Vector3.new(0, 0, 4),
        Vector3.new(0, 0, 1),
        Vector3.new(1, 0, 0),
        Vector3.new(2, 0, 1),
        Vector3.new(2, 0, 4),
        Vector3.new(1, 0, 5),
        Vector3.new(2, 0, 0)
    },
    R = {
        Vector3.new(0, 0, 0),
        Vector3.new(0, 0, 5),
        Vector3.new(2, 0, 5),
        Vector3.new(2, 0, 2.5),
        Vector3.new(0, 0, 2.5),
        Vector3.new(2, 0, 0)
    },
    S = {
        Vector3.new(2, 0, 5),
        Vector3.new(0, 0, 5),
        Vector3.new(0, 0, 2.5),
        Vector3.new(2, 0, 2.5),
        Vector3.new(2, 0, 0),
        Vector3.new(0, 0, 0)
    },
    T = {
        Vector3.new(0, 0, 5),
        Vector3.new(2, 0, 5),
        Vector3.new(1, 0, 5),
        Vector3.new(1, 0, 0)
    },
    U = {
        Vector3.new(0, 0, 5),
        Vector3.new(0, 0, 0),
        Vector3.new(2, 0, 0),
        Vector3.new(2, 0, 5)
    },
    V = {
        Vector3.new(0, 0, 5),
        Vector3.new(1, 0, 0),
        Vector3.new(2, 0, 5)
    },
    W = {
        Vector3.new(0, 0, 5),
        Vector3.new(0.5, 0, 0),
        Vector3.new(1, 0, 3),
        Vector3.new(1.5, 0, 0),
        Vector3.new(2, 0, 5)
    },
    X = {
        Vector3.new(0, 0, 5),
        Vector3.new(2, 0, 0)
    },
    X2 = {
        Vector3.new(2, 0, 5),
        Vector3.new(0, 0, 0)
    },
    Y = {
        Vector3.new(0, 0, 5),
        Vector3.new(1, 0, 3),
        Vector3.new(2, 0, 5),
        Vector3.new(1, 0, 3),
        Vector3.new(1, 0, 0)
    },
    Z = {
        Vector3.new(0, 0, 5),
        Vector3.new(2, 0, 5),
        Vector3.new(0, 0, 0),
        Vector3.new(2, 0, 0)
    }
}
local function vu195()
    local v194 = vu12.Character
    if v194 then
        v194 = v194:FindFirstChild("HumanoidRootPart")
    end
    return v194 and v194.Position or Vector3.new(0, 10, 0)
end
local function vu201()
    local v196, v197, v198 = ipairs(vu192)
    while true do
        local v199
        v198, v199 = v196(v197, v198)
        if v198 == nil then
            break
        end
        local v200 = (v198 - 1) * (vu190 * 3)
        v199.basePosition = vu195() + Vector3.new(v200, 0, 0) + Vector3.new(0, vu191, 0)
    end
end
local function vu211(p202, p203, p204, p205)
    local v206 = p202:FindFirstChild("SoundPart")
    if v206 and vu193[p203] then
        local v207 = v206:FindFirstChildOfClass("BodyPosition") or Instance.new("BodyPosition", v206)
        local v208 = v206:FindFirstChildOfClass("BodyGyro") or Instance.new("BodyGyro", v206)
        v207.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        v207.D = 1000
        v207.P = 50000
        v208.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        v208.D = 1000
        v208.P = 50000
        v208.CFrame = CFrame.Angles(0, 0, math.rad(90))
        if not (vu192[p204] and vu192[p204].basePosition) then
            vu195()
        end
        local v209 = vu193[p203]
        local v210 = p205 and (# v209 or 1) or 1
        while vu189 and vu192[p204] do
            v207.Position = (vu192[p204] and vu192[p204].basePosition or vu195()) + v209[v210] * vu190
            if p205 then
                v210 = v210 - 1
                if v210 < 1 then
                    v210 = v210 + 1
                    task.wait(5e-6)
                    p205 = false
                end
            else
                v210 = v210 + 1
                if # v209 < v210 then
                    v210 = v210 - 1
                    task.wait(5e-6)
                    p205 = true
                end
            end
            task.wait(0.14)
        end
        if not vu189 then
            v207.Position = vu195()
        end
    end
end
local function vu218(p212)
    if vu189 then
        if # vu18 >= # vu192 + 2 then
            local v213 = vu18[# vu192 * 2 + 1]
            local v214 = vu18[# vu192 * 2 + 2]
            if v213 and v214 then
                local v215 = # vu192 + 1
                local v216 = (v215 - 1) * (vu190 * 3)
                local v217 = {
                    sparkler1 = v213,
                    sparkler2 = v214,
                    letter = p212,
                    index = v215,
                    basePosition = vu195() + Vector3.new(v216, 0, 0) + Vector3.new(0, vu191, 0)
                }
                table.insert(vu192, v217)
                task.spawn(vu211, v213, p212, v215, false)
                task.spawn(vu211, v214, p212, v215, true)
                vu201()
            end
        else
            return
        end
    else
        return
    end
end
local function vu228()
    if # vu192 ~= 0 then
        local v219 = table.remove(vu192)
        local v220 = vu195()
        local v221 = # vu192 * 2
        local v222, v223, v224 = ipairs({
            v219.sparkler1,
            v219.sparkler2
        })
        while true do
            local v225
            v224, v225 = v222(v223, v224)
            if v224 == nil then
                break
            end
            local v226 = v225:FindFirstChild("SoundPart")
            if v226 then
                local v227 = v226:FindFirstChildOfClass("BodyPosition")
                if v227 then
                    v227.Position = v220 + Vector3.new(v221, 0, 1)
                end
            end
        end
        vu201()
    end
end
local function vu241()
    local v229 = vu195()
    local v230, v231, v232 = ipairs(vu192)
    while true do
        local v233
        v232, v233 = v230(v231, v232)
        if v232 == nil then
            break
        end
        local v234 = (v232 - 1) * 2
        local v235, v236, v237 = ipairs({
            v233.sparkler1,
            v233.sparkler2
        })
        while true do
            local v238
            v237, v238 = v235(v236, v237)
            if v237 == nil then
                break
            end
            local v239 = v238:FindFirstChild("SoundPart")
            if v239 then
                local v240 = v239:FindFirstChildOfClass("BodyPosition")
                if v240 then
                    v240.Position = v229 + Vector3.new(v234, 0, 1)
                end
            end
        end
    end
    vu192 = {}
end
v118:AddToggle({
    Name = "Enable Virtual Keyboard",
    Default = false,
    Callback = function(p242)
        vu189 = p242
        if p242 then
            local v243, v244, v245 = ipairs(vu192)
            while true do
                local v246
                v245, v246 = v243(v244, v245)
                if v245 == nil then
                    break
                end
                task.spawn(vu211, v246.sparkler1, v246.letter, v245, false)
                task.spawn(vu211, v246.sparkler2, v246.letter, v245, true)
            end
        else
            vu241()
        end
    end
})
v118:AddDropdown({
    Name = "Select Letter",
    Options = {
        "A",
        "B",
        "C",
        "D",
        "E",
        "F",
        "G",
        "H",
        "I",
        "J",
        "K",
        "L",
        "M",
        "N",
        "O",
        "P",
        "Q",
        "R",
        "S",
        "T",
        "U",
        "V",
        "W",
        "X",
        "Y",
        "Z"
    },
    Default = "A",
    Callback = function(p247)
        selectedLetter = p247
    end
})
v118:AddButton({
    Name = "Add Letter",
    Callback = function()
        vu218(selectedLetter)
    end
})
v118:AddButton({
    Name = "Remove Letter",
    Callback = function()
        vu228()
    end
})
v118:AddSlider({
    Name = "Letter Size",
    Min = 1,
    Max = 100,
    Default = 5,
    Increment = 1,
    Callback = function(p248)
        vu190 = p248
        vu201()
    end
})
v118:AddSlider({
    Name = "Letter Height",
    Min = 5,
    Max = 1000,
    Default = 10,
    Increment = 1,
    Callback = function(p249)
        vu191 = p249
        vu201()
    end
})
local v250 = v24:MakeTab({
    Name = "Christmas Tree",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
local vu251 = false
local vu252 = 50
local vu253 = 2
local vu254 = 3
local vu255 = 30
local function vu267()
    vu170()
    while vu251 do
        local v256 = vu12.Character
        if v256 then
            v256 = v256:FindFirstChild("HumanoidRootPart")
        end
        if v256 then
            local v257 = tick()
            local v258 = math.min(# vu18, vu255)
            for v259 = 1, v258 do
                local v260 = vu18[v259]
                if v260 then
                    v260 = v260:FindFirstChild("SoundPart")
                end
                if v260 then
                    local v261 = v260:FindFirstChildOfClass("BodyPosition") or Instance.new("BodyPosition")
                    v261.MaxForce = Vector3.new(5e18, 5e18, 5e18)
                    v261.D = 1000
                    v261.P = 50000
                    v261.Parent = v260
                    local v262 = v260:FindFirstChildOfClass("BodyGyro") or Instance.new("BodyGyro")
                    v262.MaxTorque = Vector3.new(5e18, 5e18, 5e18)
                    v262.D = 1000
                    v262.P = 50000
                    v262.Parent = v260
                    local v263 = vu252 * ((vu255 - v259) / vu255)
                    local v264 = vu254 * v259
                    local v265 = v259 == v258 and 0 or v263
                    local v266 = math.rad((v257 * vu253 * 20 + v259 * 30) % 360)
                    v261.Position = v256.Position + Vector3.new(math.cos(v266) * v265, v264, math.sin(v266) * v265)
                    v262.CFrame = CFrame.new(v260.Position, v256.Position)
                end
            end
        end
        task.wait(3e-6)
    end
end
v250:AddToggle({
    Name = "Enable Christmas Tree",
    Default = false,
    Callback = function(p268)
        vu251 = p268
        if vu251 then
            task.spawn(vu267)
        end
    end
})
v250:AddSlider({
    Name = "Orbit Radius",
    Min = 10,
    Max = 2000,
    Default = 50,
    Increment = 1,
    Callback = function(p269)
        vu252 = p269
    end
})
v250:AddSlider({
    Name = "Orbit Speed",
    Min = 0.5,
    Max = 500,
    Default = 2,
    Increment = 0.1,
    Callback = function(p270)
        vu253 = p270
    end
})
v250:AddSlider({
    Name = "Height Step",
    Min = 1,
    Max = 50,
    Default = 3,
    Increment = 1,
    Callback = function(p271)
        vu254 = p271
    end
})
local v272 = v24:MakeTab({
    Name = "Wings",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
local vu273 = false
local vu274 = 2
local vu275 = 5
local vu276 = 3
local vu277 = 1
local function vu300()
    vu170()
    while vu273 do
        local vu278 = vu12.Character
        if vu278 then
            vu278 = vu278:FindFirstChild("HumanoidRootPart")
        end
        if vu278 then
            local vu279 = tick()
            local v280 = {}
            local v281 = {}
            if # vu18 >= 30 then
                for v282 = 1, 15 do
                    local v283 = v282
                    table.insert(v280, vu18[v283])
                    table.insert(v281, vu18[v283 + 15])
                end
            end
            local vu284 = vu278.CFrame.LookVector
            local vu285 = vu278.CFrame.RightVector
            local function v299(p286, p287)
                local v288, v289, v290 = ipairs(p286)
                while true do
                    local v291
                    v290, v291 = v288(v289, v290)
                    if v290 == nil then
                        break
                    end
                    if v291 then
                        v291 = v291:FindFirstChild("SoundPart")
                    end
                    if v291 then
                        local v292 = 2.5 - v290 * 0.15
                        local v293 = 1 + v290 * 0.4 * vu277
                        local v294 = - v290 * 0.3
                        local v295 = v290 / 15
                        local v296 = math.sin(vu279 * vu274) * (vu275 * v295)
                        local v297 = v291:FindFirstChildOfClass("BodyPosition") or Instance.new("BodyPosition")
                        v297.MaxForce = Vector3.new(5e18, 5e18, 5e18)
                        v297.D = 1000
                        v297.P = 50000
                        v297.Parent = v291
                        local v298 = v291:FindFirstChildOfClass("BodyGyro") or Instance.new("BodyGyro")
                        v298.MaxTorque = Vector3.new(5e18, 5e18, 5e18)
                        v298.D = 1000
                        v298.P = 50000
                        v298.Parent = v291
                        v297.Position = vu278.Position + vu285 * p287 * vu276 + Vector3.new(0, v292, 0) + (vu285 * p287 * v293 + Vector3.new(0, v296, 0) + - vu284 * v294)
                        v298.CFrame = CFrame.new(v291.Position, vu278.Position)
                    end
                end
            end
            v299(v280, - 1)
            v299(v281, 1)
        end
        task.wait(0.03)
    end
end
v272:AddToggle({
    Name = "Enable Wings",
    Default = false,
    Callback = function(p301)
        vu273 = p301
        if vu273 then
            task.spawn(vu300)
        end
    end
})
v272:AddSlider({
    Name = "Flap Speed",
    Min = 0.5,
    Max = 50,
    Default = 2,
    Increment = 0.1,
    Callback = function(p302)
        vu274 = p302
    end
})
v272:AddSlider({
    Name = "Flap Size",
    Min = 1,
    Max = 50,
    Default = 5,
    Increment = 1,
    Callback = function(p303)
        vu275 = p303
    end
})
v272:AddSlider({
    Name = "Wing Spread",
    Min = 0.5,
    Max = 25,
    Default = 1,
    Increment = 0.1,
    Callback = function(p304)
        vu277 = p304
    end
})
local v305 = v24:MakeTab({
    Name = "Grid Pattern",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
local function vu323()
    vu170()
    while gridEnabled do
        local v306 = vu12.Character
        if v306 then
            v306 = v306:FindFirstChild("HumanoidRootPart")
        end
        if v306 then
            local v307 = tick()
            local v308 = math.ceil(math.sqrt(# vu18))
            local v309 = squareSize + 5
            local v310 = (v308 - 1) * v309 * 0.5
            local v311, v312, v313 = ipairs(vu18)
            while true do
                local v314
                v313, v314 = v311(v312, v313)
                if v313 == nil then
                    break
                end
                local v315 = v314:FindFirstChild("SoundPart")
                if v315 then
                    local v316 = v315:FindFirstChildOfClass("BodyPosition") or Instance.new("BodyPosition")
                    v316.MaxForce = Vector3.new(5e18, 5e18, 5e18)
                    v316.D = 1000
                    v316.P = 50000
                    v316.Parent = v315
                    local v317 = v315:FindFirstChildOfClass("BodyGyro") or Instance.new("BodyGyro")
                    v317.MaxTorque = Vector3.new(5e18, 5e18, 5e18)
                    v317.D = 1000
                    v317.P = 50000
                    v317.Parent = v315
                    local v318 = math.floor((v313 - 1) / v308)
                    local v319 = (v313 - 1) % v308
                    local v320 = v306.Position + Vector3.new(v319 * v309 - v310, 0, v318 * v309 - v310)
                    local v321 = v307 * vu253 * 2 % 4
                    local v322 = Vector3.new(0, gridHeight, 0)
                    if v321 < 1 then
                        v322 = Vector3.new(squareSize, gridHeight, 0)
                    elseif v321 < 2 then
                        v322 = Vector3.new(squareSize, gridHeight, squareSize)
                    elseif v321 < 3 then
                        v322 = Vector3.new(0, gridHeight, squareSize)
                    elseif v321 < 4 then
                        v322 = Vector3.new(0, gridHeight, 0)
                    end
                    v316.Position = v320 + v322
                    v317.CFrame = CFrame.new(v315.Position, v306.Position)
                end
            end
        end
        task.wait(0.03)
    end
end
v305:AddToggle({
    Name = "Enable Grid",
    Default = false,
    Callback = function(p324)
        gridEnabled = p324
        if gridEnabled then
            task.spawn(vu323)
        end
    end
})
v305:AddSlider({
    Name = "Square Size",
    Min = 5,
    Max = 50,
    Default = 20,
    Increment = 1,
    Callback = function(p325)
        squareSize = p325
    end
})
v305:AddSlider({
    Name = "Orbit Speed",
    Min = 0.5,
    Max = 10,
    Default = 2,
    Increment = 0.1,
    Callback = function(p326)
        vu253 = p326
    end
})
v305:AddSlider({
    Name = "Grid Height",
    Min = 1,
    Max = 30,
    Default = 5,
    Increment = 1,
    Callback = function(p327)
        gridHeight = p327
    end
})
local v328 = v24:MakeTab({
    Name = "Extra",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
v328:AddButton({
    Name = "Cosmic Hub Main",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Jeffepicy/CosmicHub/refs/heads/main/CosmicHub", true))()
    end
})
v328:AddButton({
    Name = "Dex",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/m0onyy/Test/refs/heads/main/mobile%20dex.lua", true))()
    end
})
v328:AddButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ttwizz/infiniteyield/master/source.lua", true))()
    end
})
local v329 = vu5
vu5.Init(v329)
