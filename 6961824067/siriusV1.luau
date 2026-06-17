print([[

░██████╗██╗██████╗░██╗██╗░░░██╗░██████╗
██╔════╝██║██╔══██╗██║██║░░░██║██╔════╝
╚█████╗░██║██████╔╝██║██║░░░██║╚█████╗░
░╚═══██╗██║██╔══██╗██║██║░░░██║░╚═══██╗
██████╔╝██║██║░░██║██║╚██████╔╝██████╔╝
╚═════╝░╚═╝╚═╝░░╚═╝╚═╝░╚═════╝░╚═════╝░

]])

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local plr = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")

local Window = Rayfield:CreateWindow({
    Name = "S I R I U S",
    LoadingTitle = "Loading menu...",
    LoadingSubtitle = "by gpthub",
    ConfigurationSaving = {
        Enabled = true,
        FileName = "gptconfig"
    }
})

local plr = Players.LocalPlayer
local cam = workspace.CurrentCamera
local mouse = plr:GetMouse()

local GrabRemote = ReplicatedStorage:WaitForChild("GrabEvents"):WaitForChild("SetNetworkOwner")
local activeTargets = {}
local usedBananas = {}
local hitboxes = {}

local strengthV = 1000
local flingEnabled = false
local antiGrab1T = false
local antiGrab1AnchorT = false
local antiBananaLegsT = false
local hipHeightLoop = nil
local slideTPT = false
local slideTPD = false
local antiExplodeT = false
local antiLagT = false
local autoAntiLagT = false
local lagDetectionThreshold = 5
local lagEvents = {}
local lagCheckInterval = 1
local walkSpeedT = false
local walkSpeedV = 16
local inspectT = false
local currentInspectS = 0
local currentInspectedAdorneeS = nil
local returnPosS = nil
local mouseTargetS = nil
local antiBlob1T = false
local antiKickCoroutine = nil
local playerLeaveNotifierEnabled = false
local selectedTarget = ""
local espEnabled = false
local antiBlob1T = false
local antiKickCoroutine = nil
local weldsConnection = nil
local blobsConnection = nil
local espColor = Color3.fromRGB(0, 255, 0)
local espTransparency = 0.70

-- Auto Ragdoll Grab Variables
local ragdollGrabEnabled = false
local ragdollGrabConnection = nil
local ragdollGrabSpin = nil
local ragdollGrabPosition = nil

local farCFrame = CFrame.new(10000, -10000, 10000)
local dropVector = Vector3.new(0, -20.34, 0)
local fixedSize = Vector3.new(2, 6, 1.5)
local verticalOffset = -3.2

local scanLoop = nil
local childAddedConnection = nil

local function generateUniqueId()
    return tostring(math.random(100000, 999999))
end

local function getTarget()
    local target = mouse.Target
    if not target then return nil end
    local model = target:FindFirstAncestorOfClass("Model")
    if not model then return nil end
    local player = Players:GetPlayerFromCharacter(model)
    if not player or player == plr then return nil end
    return player
end

local function startSpam(player)
    local running = true
    local thread = task.spawn(function()
        while running do
            pcall(function()
                local char = player.Character
                local head = char and char:FindFirstChild("Head")
                local myHead = plr.Character and plr.Character:FindFirstChild("Head")
                if head and myHead then
                    if (head.Position - myHead.Position).Magnitude <= 50 then
                        GrabRemote:FireServer(head, char:GetPrimaryPartCFrame())
                    end
                end
            end)
            task.wait()
        end
    end)
    activeTargets[player] = function()
        running = false
        task.cancel(thread)
    end
end

local function stopSpam(player)
    if activeTargets[player] then
        activeTargets[player]()
        activeTargets[player] = nil
    end
end

local function antiGrab1F()
    local char = plr.Character
    if not char then return end
    local hrp = char:WaitForChild("HumanoidRootPart")
    
    while antiGrab1T and task.wait() do
        if plr.IsHeld.Value == true and antiGrab1T then
            if hrp then
                if antiGrab1AnchorT then
                    hrp.Anchored = true
                    while plr.IsHeld.Value == true do 
                        ReplicatedStorage.CharacterEvents.Struggle:FireServer(plr)
                        task.wait(0.001) 
                    end
                    hrp.Anchored = false
                else
                    while plr.IsHeld.Value == true do 
                        ReplicatedStorage.CharacterEvents.Struggle:FireServer(plr)
                        task.wait(0.001) 
                    end
                end
            end
        end
    end
end

local function antiExplodeF()
    local char = plr.Character
    if not char then return end
    local hrp = char:WaitForChild("HumanoidRootPart")
    
    workspace.ChildAdded:Connect(function(model)
        if model.Name == "Part" and char and antiExplodeT then
            local mag = (model.Position - hrp.Position).Magnitude
            if mag <= 20 then
                hrp.Anchored = true
                task.wait(0.01)
                while char:FindFirstChild("Right Arm") and char["Right Arm"]:FindFirstChild("RagdollLimbPart") and char["Right Arm"].RagdollLimbPart.CanCollide == true do 
                    task.wait(0.001) 
                end
                hrp.Anchored = false
            end
        end
    end)
end

local function antiLagF()
    local script = plr.PlayerScripts:FindFirstChild("CharacterAndBeamMove")
    if script then
        script.Disabled = antiLagT
    end
end

local function removeAttachDetectors(blob)
    if blob and blob.Name == "CreatureBlobman" then
        local leftDetector = blob:FindFirstChild("LeftDetector")
        local rightDetector = blob:FindFirstChild("RightDetector")
        if leftDetector then leftDetector:Destroy() end
        if rightDetector then rightDetector:Destroy() end
    end
end

local function antiBlob1F()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "CreatureBlobman" then
            removeAttachDetectors(obj)
        end
    end

    if blobsConnection then blobsConnection:Disconnect() end
    blobsConnection = workspace.DescendantAdded:Connect(function(toy)
        if antiBlob1T and toy.Name == "CreatureBlobman" then
            task.wait()
            removeAttachDetectors(toy)
        end
    end)
end

local weldNames = {
    LeftWeld = true,
    LeftAlignOrientation = true,
    RightWeld = true,
    RightAlignOrientation = true,
}

local function disableWelds(playerName)
    for _, v in pairs(workspace:GetDescendants()) do
        if weldNames[v.Name] then
            local ancestor = v.Parent and v.Parent.Parent and v.Parent.Parent.Parent
            if ancestor ~= workspace:FindFirstChild(playerName) then
                if v.Enabled ~= false then
                    v.Enabled = false
                end
            end
        end
    end

    if weldsConnection then weldsConnection:Disconnect() end
    weldsConnection = workspace.DescendantAdded:Connect(function(v)
        if weldNames[v.Name] then
            local ancestor = v.Parent and v.Parent.Parent and v.Parent.Parent.Parent
            if ancestor ~= workspace:FindFirstChild(playerName) then
                if v.Enabled ~= false then
                    v.Enabled = false
                end
            end
        end
    end)
end

local function enableWelds(playerName)
    if weldsConnection then
        weldsConnection:Disconnect()
        weldsConnection = nil
    end
    for _, v in pairs(workspace:GetDescendants()) do
        if weldNames[v.Name] then
            local ancestor = v.Parent and v.Parent.Parent and v.Parent.Parent.Parent
            if ancestor ~= workspace:FindFirstChild(playerName) then
                if v.Enabled ~= true then
                    v.Enabled = true
                end
            end
        end
    end
end

local function startAntiKick()
    if antiKickCoroutine then antiKickCoroutine:Disconnect() end
    antiKickCoroutine = RunService.Heartbeat:Connect(function()
        local character = plr.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local firePart = character.HumanoidRootPart:FindFirstChild("FirePlayerPart")
            if firePart then
                local partOwner = firePart:FindFirstChild("PartOwner")
                if partOwner and partOwner.Value ~= plr.Name then
                    local args = {character.HumanoidRootPart, 0}
                    rs.CharacterEvents.RagdollRemote:FireServer(unpack(args))
                    task.wait(0.05)
                    rs.CharacterEvents.Struggle:FireServer()
                end
            end
        end
    end)
end

local function autoAntiLag()
    while autoAntiLagT and task.wait(lagCheckInterval) do
        local currentTime = os.time()
        
        for i = #lagEvents, 1, -1 do
            if currentTime - lagEvents[i] > 5 then
                table.remove(lagEvents, i)
            end
        end
        
        if #lagEvents >= lagDetectionThreshold then
            if not antiLagT then
                antiLagT = true
                antiLagF()
                Rayfield:Notify({Title = "Auto Anti-Lag", Content = "Автоматически включен", Duration = 3})
            end
        elseif antiLagT then
            antiLagT = false
            antiLagF()
        end
    end
end

local function setupLagDetector()
    workspace.ChildAdded:Connect(function(child)
        if autoAntiLagT and child.Name == "Part" then
            table.insert(lagEvents, os.time())
        end
    end)
end

local function tpF()
    local char = plr.Character
    if not char then return end
    local hrp = char:WaitForChild("HumanoidRootPart")
    
    if not slideTPT then
        if hrp and mouse.Target then 
            hrp.CFrame = CFrame.new(mouse.Hit.x, mouse.Hit.y + 5, mouse.Hit.z) 
        end
    elseif slideTPT then
        if not slideTPD and mouse.Target then
            slideTPD = true
            local info = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In, 0, false, 0)
            local info2 = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In, 0, true, 0)
            local e = {CFrame = CFrame.new(mouse.Hit.x, mouse.Hit.y + 3, mouse.Hit.z)}
            local e2 = {FieldOfView = 100}
            
            if char:FindFirstChild("Head") then char.Head.CanCollide = false end
            if char:FindFirstChild("Torso") then char.Torso.CanCollide = false end
            
            TweenService:Create(hrp, info, e):Play()
            TweenService:Create(cam, info2, e2):Play()
            task.wait(0.55)
            
            if char:FindFirstChild("Head") then char.Head.CanCollide = true end
            if char:FindFirstChild("Torso") then char.Torso.CanCollide = true end
            cam.FieldOfView = 70
            slideTPD = false
        end
    end
end

local function updateWalkSpeedF()
    local char = plr.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    
    if walkSpeedT then
        hum.WalkSpeed = walkSpeedV
    else
        hum.WalkSpeed = 16
    end
    
    hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if walkSpeedT then
            hum.WalkSpeed = walkSpeedV
        else
            hum.WalkSpeed = 16
        end
    end)
end

local function BringPlayerF()
    local char = plr.Character
    if not char then return end
    local hrp = char:WaitForChild("HumanoidRootPart")
    
    if inspectT and currentInspectS ~= 2 and currentInspectS ~= 4 then
        returnPosS = hrp.CFrame
        hrp.CFrame = currentInspectedAdorneeS.PrimaryPart.CFrame + Vector3.new(7, 3, 0)
        task.wait(0.15)
        if currentInspectS == 1 then
            ReplicatedStorage.GrabEvents.SetNetworkOwner:FireServer(currentInspectedAdorneeS:WaitForChild("HumanoidRootPart"), currentInspectedAdorneeS:WaitForChild("HumanoidRootPart").CFrame)
            task.wait(0.1)
            currentInspectedAdorneeS:WaitForChild("HumanoidRootPart").CFrame = returnPosS
        else
            ReplicatedStorage.GrabEvents.SetNetworkOwner:FireServer(currentInspectedAdorneeS.PrimaryPart, currentInspectedAdorneeS.PrimaryPart.CFrame)
            task.wait(0.1)
            currentInspectedAdorneeS.PrimaryPart.CFrame = returnPosS
        end
        hrp.CFrame = returnPosS
    elseif not inspectT then
        if mouse.Target and mouse.Target.Parent and (mouse.Target.Parent:IsDescendantOf(workspace.PlotItems) or string.match(mouse.Target.Parent.Parent.Name, "SpawnedInToys") or (mouse.Target.Parent.Parent and mouse.Target.Parent.Parent:FindFirstChild("SpawningPlatform")) or mouse.Target.Parent:FindFirstChildOfClass("Humanoid")) then
            returnPosS = hrp.CFrame
            mouseTargetS = mouse.Target
            hrp.CFrame = mouseTargetS.Parent.PrimaryPart.CFrame + Vector3.new(10, 3, 0)
            task.wait(0.15)
            if mouseTargetS.Parent:FindFirstChildOfClass("Humanoid") then
                ReplicatedStorage.GrabEvents.SetNetworkOwner:FireServer(mouseTargetS.Parent:WaitForChild("HumanoidRootPart"), mouseTargetS.Parent:WaitForChild("HumanoidRootPart").CFrame)
                task.wait(0.1)
                mouseTargetS.Parent:WaitForChild("HumanoidRootPart").CFrame = returnPosS
            else
                ReplicatedStorage.GrabEvents.SetNetworkOwner:FireServer(mouseTargetS.Parent.PrimaryPart, mouseTargetS.Parent.PrimaryPart.CFrame)
                task.wait(0.1)
                mouseTargetS.Parent.PrimaryPart.CFrame = returnPosS
            end
            hrp.CFrame = returnPosS
            mouseTargetS = nil
        end
    end
end

local function setupPlayerLeaveNotifier()
    if playerLeaveNotifierEnabled then return end
    playerLeaveNotifierEnabled = true
    
    Players.PlayerRemoving:Connect(function(player)
        local message = string.format("[LEFT] %s (@%s)", player.DisplayName, player.Name)
        Rayfield:Notify({Title = "Player Left", Content = message, Duration = 6.5, Image = 4483362458})
    end)
end

local function isTargetInDetector(detector, targetHRP)
    if not detector or not targetHRP then return false end
    
    for _, part in ipairs(detector:GetTouchingParts()) do
        if part:IsDescendantOf(targetHRP.Parent) then
            return true
        end
    end
    return false
end

local function instantGrab()
    if selectedTarget == "" then
        return
    end

    local char = plr.Character
    if not char then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local seat = humanoid.SeatPart
    if not seat or not seat.Parent or not seat.Parent:FindFirstChild("BlobmanSeatAndOwnerScript") then
        return
    end

    local target = Players:FindFirstChild(selectedTarget)
    if not target then
        return
    end

    if target == plr then
        return
    end

    local targetChar = target.Character
    if not targetChar then
        return
    end

    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return end

    local seatParent = seat.Parent
    local det = seatParent:FindFirstChild("LeftDetector")
    if not det then return end

    local weld = det:FindFirstChild("LeftWeld")
    if not weld then return end

    local grab = seatParent.BlobmanSeatAndOwnerScript:FindFirstChild("CreatureGrab")
    if not grab then return end

    local originalCFrame = hrp.CFrame
    local attempts = 0
    local maxAttempts = 3 
    local success = false

    local function performGrab()
        hrp.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 2.5)
        task.wait(0.2)

        grab:FireServer(det, targetHRP, weld)
        task.wait(0.1)
        grab:FireServer(det, targetHRP, weld)
        task.wait(0.5) 

        if isTargetInDetector(det, targetHRP) then
            success = true
        else
            attempts = attempts + 1
            if attempts < maxAttempts then
                performGrab() 
            end
        end
    end

    performGrab()

    if hrp and hrp.Parent then
        hrp.CFrame = originalCFrame
    end

    if success then
        task.wait(0.5)
        if targetHRP and targetHRP.Parent then
            targetHRP.CFrame = originalCFrame * CFrame.new(0, 0, -5)
        end
    end
end

local function startRagdollGrab()
    if ragdollGrabConnection then
        ragdollGrabConnection:Disconnect()
        ragdollGrabConnection = nil
    end
    
    ragdollGrabConnection = RunService.Heartbeat:Connect(function()
        if not ragdollGrabEnabled then return end
        
        local MyToys = workspace:FindFirstChild(plr.Name.."SpawnedInToys")
        if not MyToys then return end
        
        local MyCharacter = plr.Character
        local MyRoot = MyCharacter and MyCharacter:FindFirstChild("HumanoidRootPart")
        if not MyRoot then return end
        
        local MyPallet = MyToys:FindFirstChild("PalletLightBrown")
        if not MyPallet then
            -- Spawn pallet if not exists
            while not plr.CanSpawnToy.Value do task.wait() end
            ReplicatedStorage.MenuToys.SpawnToyRemoteFunction:InvokeServer("PalletLightBrown", MyRoot.CFrame, Vector3.new(0, -90, 0))
            return
        end
        
        local MyPalletPart = MyPallet:WaitForChild("SoundPart")
        local MyPalletMain = MyPallet:WaitForChild("Main")
        local GrabParts = workspace:FindFirstChild("GrabParts")
        
        if MyRoot and MyPalletPart then
            if MyPalletPart:FindFirstChild("PartOwner") == nil then
                ReplicatedStorage.GrabEvents.SetNetworkOwner:FireServer(MyPalletPart, MyPalletPart.CFrame)
                
                if MyPalletPart:FindFirstChild("RagdollGrabSpin") == nil then
                    ragdollGrabSpin = Instance.new("AngularVelocity", MyPalletPart)
                    ragdollGrabSpin.Name = "RagdollGrabSpin"
                    ragdollGrabSpin.MaxTorque = math.huge
                    ragdollGrabSpin.AngularVelocity = Vector3.new(100000, 0, 100000)
                    ragdollGrabSpin.RelativeTo = Enum.ActuatorRelativeTo.World
                    ragdollGrabSpin.Attachment0 = MyPallet:FindFirstChild("Attachment") or Instance.new("Attachment", MyPalletPart)
                    
                    ragdollGrabPosition = Instance.new("BodyPosition", MyPalletMain)
                    ragdollGrabPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    ragdollGrabPosition.D = 100
                    ragdollGrabPosition.Name = "RagdollGrabPosition"
                    ragdollGrabPosition.Position = Vector3.new(0, 10000, 0)
                end
            end
            
            if GrabParts then
                local GrabPart = GrabParts:FindFirstChild("GrabPart")
                local Part = GrabPart and GrabPart:FindFirstChild("WeldConstraint") and GrabPart.WeldConstraint.Part1
                
                if Part and Part.Parent and Part.Parent:FindFirstChild("Humanoid") then
                    if MyPalletPart.CanCollide then
                        for _, part in pairs(MyPallet:GetChildren()) do
                            if part:IsA("Part") then
                                part.CanCollide = false
                                part.CanQuery = false
                            end
                        end
                    end
                    
                    MyPalletPart.Position = Part.Position
                end
            end
        end
    end)
end

local function stopRagdollGrab()
    if ragdollGrabConnection then
        ragdollGrabConnection:Disconnect()
        ragdollGrabConnection = nil
    end
    
    if ragdollGrabSpin then
        ragdollGrabSpin:Destroy()
        ragdollGrabSpin = nil
    end
    
    if ragdollGrabPosition then
        ragdollGrabPosition:Destroy()
        ragdollGrabPosition = nil
    end
end

local DefenseTab = Window:CreateTab("Defense", 4483362458)
local BlobmanTab = Window:CreateTab("Blobman", 4483362458)
local PlayerTab = Window:CreateTab("Player", 4483362458)
local VisualTab = Window:CreateTab("Visual", 4483362458)
local LoggerTab = Window:CreateTab("Logger", 4483362458)
local OthersTab = Window:CreateTab("Others", 4483362458)

local MovementSection = PlayerTab:CreateSection("Movement")

PlayerTab:CreateKeybind({
    Name = "Click TP",
    CurrentKeybind = "Z",
    HoldToInteract = false,
    Flag = "tpKeybindFlag",
    Callback = function(Keybind)
        tpF()
    end
})

PlayerTab:CreateToggle({
    Name = "WalkSpeed",
    CurrentValue = false,
    Flag = "walkSpeedToggleFlag",
    Callback = function(Value)
        walkSpeedT = Value 
        updateWalkSpeedF()
    end
})

PlayerTab:CreateSlider({
    Name = "Speed Count",
    Range = {16, 100},
    Increment = 16,
    Suffix = "Speed",
    CurrentValue = 10,
    Flag = "Speed", 
    Callback = function(Value)
        walkSpeedV = Value
        updateWalkSpeedF()
    end,
})

local MovementSection2 = OthersTab:CreateSection("Player Teleport")

OthersTab:CreateKeybind({
    Name = "Bring Player",
    CurrentKeybind = "B",
    HoldToInteract = false,
    Flag = "tpKeybindFlag",
    Callback = function(Keybind)
        BringPlayerF()
    end
})

OthersTab:CreateKeybind({
    Name = "Spam player ",
    CurrentKeybind = "Y",
    HoldToInteract = false,
    Callback = function()
        local targetPlayer = getTarget()
        if targetPlayer then
            if activeTargets[targetPlayer] then
                stopSpam(targetPlayer)
            else
                startSpam(targetPlayer)
            end
        end
    end,
})

OthersTab:CreateToggle({
    Name = "Auto Ragdoll Grab",
    CurrentValue = false,
    Callback = function(Value)
        ragdollGrabEnabled = Value
        if Value then
            startRagdollGrab()
            stopRagdollGrab()
        end
    end
})

local BlobmanSection = BlobmanTab:CreateSection("Blobman")

BlobmanTab:CreateInput({
    Name = "Target Player",
    PlaceholderText = "Enter player name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        selectedTarget = Text
        Rayfield:Notify({Title = "Target Set", Content = "Target set to: "..Text, Duration = 3})
    end,
})

BlobmanTab:CreateToggle({
    Name = "Bring Selected",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            task.spawn(instantGrab)
        end
    end
})

local DefenceSection = DefenseTab:CreateSection("Defense")

DefenseTab:CreateToggle({
    Name = "Anti Grab [Anch]",
    CurrentValue = false,
    Callback = function(Value)
        antiGrab1T = Value
        antiGrab1AnchorT = Value
        if Value then task.spawn(antiGrab1F) end
    end
})

DefenseTab:CreateToggle({
    Name = "Anti Banana [LEGS]",
    CurrentValue = false,
    Callback = function(Value)
        antiBananaLegsT = Value
        if Value then
            local char = plr.Character or plr.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")
            local Humanoid = char:WaitForChild("Humanoid")
            
            hipHeightLoop = task.spawn(function()
                while antiBananaLegsT do
                    if Humanoid.HipHeight ~= 2 then Humanoid.HipHeight = 2 end
                    task.wait(0.2)
                end
            end)
            
            for i = 1, 10 do 
                pcall(function() ReplicatedStorage.CharacterEvents.RagdollRemote:FireServer(hrp, 1) end) 
                task.wait(0.05) 
            end
            
            for _, leg in ipairs({"Left Leg", "Right Leg"}) do
                local part = char:FindFirstChild(leg)
                if part then part.CFrame = CFrame.new(hrp.Position + Vector3.new(5, -59999, 0)) end
            end
            
            for i = 1, 5 do 
                pcall(function() ReplicatedStorage.CharacterEvents.RagdollRemote:FireServer(hrp, 0) end) 
                task.wait(0.05) 
            end
        else
            if hipHeightLoop then task.cancel(hipHeightLoop) end
        end
    end
})

DefenseTab:CreateToggle({
    Name = "Anti Explosion",
    CurrentValue = false,
    Flag = "Anti Explode",
    Callback = function(Value)
        antiExplodeT = Value
        if Value then antiExplodeF() end
    end
})

DefenseTab:CreateToggle({
    Name = "Anti Blobman",
    CurrentValue = false,
    Flag = "Anti Blobman",
    Callback = function(Value)
        antiBlob1T = Value
        local playerName = plr.Name .. "SpawnedInToys"
        
        if Value then
            antiBlob1F()
            disableWelds(playerName)
            startAntiKick()
        else
            enableWelds(playerName)
            if antiKickCoroutine then
                antiKickCoroutine:Disconnect()
                antiKickCoroutine = nil
            end
            if blobsConnection then
                blobsConnection:Disconnect()
                blobsConnection = nil
            end
        end
    end,
})

DefenseTab:CreateToggle({
    Name = "Anti Lag",
    CurrentValue = false,
    Callback = function(Value)
        antiLagT = Value
        antiLagF()
    end
})

DefenseTab:CreateToggle({
    Name = "Auto Anti Lag",
    CurrentValue = false,
    Callback = function(Value)
        autoAntiLagT = Value
        if Value then
            lagEvents = {}
            task.spawn(autoAntiLag)
            setupLagDetector()
        elseif antiLagT then
            antiLagT = false
            antiLagF()
        end
    end
})

DefenseTab:CreateSlider({
    Name = "Lag Sensitivity",
    Range = {1, 20},
    Increment = 1,
    Suffix = "events",
    CurrentValue = lagDetectionThreshold,
    Callback = function(Value) lagDetectionThreshold = Value end
})

local LoggerSection = LoggerTab:CreateSection("Logger")

LoggerTab:CreateToggle({
    Name = "[Chat] Spy",
    CurrentValue = false,
    Callback = function(Value)
        if getgenv().SPY_LOADED then return end
        getgenv().SPY_LOADED = true
     
        repeat task.wait() until game:GetService("ContentProvider").RequestQueueSize == 0
        repeat task.wait() until game:IsLoaded()
        
        local TextChatService = game:GetService("TextChatService")
        getgenv().ChatSpy = {
            Enabled = true,
            EnabledTF = "",
            SpyOnSelf = false,
            Public = false,
            Count = 0,
            OnMsg = false,
            Chat = {
                Color  = Color3.fromRGB(0, 255, 255),
                Font = Enum.Font.SourceSansBold,
                TextSize = 18,
                Text = "",
            },
            IgnoreList = {
                {Message = ":part/1/1/1", ExactMatch = true},
                {Message = ":part/10/10/10", ExactMatch = true},
                {Message = "A?????????", ExactMatch = false},
                {Message = ":colorshifttop 10000 0 0", ExactMatch = true},
                {Message = ":colorshiftbottom 10000 0 0", ExactMatch = true},
                {Message = ":colorshifttop 0 10000 0", ExactMatch = true},
                {Message = ":colorshiftbottom 0 10000 0", ExactMatch = true},
                {Message = ":colorshifttop 0 0 10000", ExactMatch = true},
                {Message = ":colorshiftbottom 0 0 10000", ExactMatch = true},
            },
        }
        
        function ChatSpy.checkIgnored(message)
            for _, v in ipairs(ChatSpy.IgnoreList) do
                if (v.ExactMatch and message == v.Message) or (not v.ExactMatch and string.match(v.Message, message)) then 
                    return true
                end
            end
            return false
        end
        
        function ChatSpy.onChatted(targetPlayer, message)
            if targetPlayer == plr and string.lower(message) == "/spy" then
                ChatSpy.Count = ChatSpy.Count + 1
                if ChatSpy.Count < 2 then
                    ChatSpy.Enabled = not ChatSpy.Enabled
                    ChatSpy.EnabledTF = ChatSpy.Enabled and "Enabled." or "Disabled."
                    ChatSpy.Chat.Text = string.format('<font color="#10e3df">{SPY} - %s</font>', ChatSpy.EnabledTF)
                    task.wait(0.55)
                    TextChatService.TextChannels.RBXGeneral:DisplaySystemMessage(ChatSpy.Chat.Text)
                else
                    ChatSpy.Count = 0
                end
            elseif ChatSpy.Enabled and (ChatSpy.SpyOnSelf or targetPlayer ~= plr) then
                message = message:gsub("[\n\r]",''):gsub("\t",' '):gsub("[ ]+",' ')
        
                local Hidden = true
                local Connect = TextChatService.MessageReceived:Connect(function()
                    Hidden = false
                end)
        
                task.wait(0.75)
                Connect:Disconnect()
                Connect = nil
        
                if Hidden and ChatSpy.Enabled and not ChatSpy.checkIgnored(message) then
                    if #message > 1200 then
                        message = message:sub(1200) .. "..."
                    end
                    
                    if message:sub(1,2) == "/w" then
                        for _, player in pairs(Players:GetPlayers()) do
                            local msg, count = message:gsub(player.Name, player.DisplayName)
                            if count ~= 0 then
                                ChatSpy.Chat.Text = string.format('<font color="#10e3df">{SPY} [%s]: %s</font>', targetPlayer.DisplayName, msg)
                                break
                            end
                        end
                    else
                        ChatSpy.Chat.Text = string.format('<font color="#10e3df">{SPY} [%s]: %s</font>', targetPlayer.DisplayName, message)
                    end
                    TextChatService.TextChannels.RBXGeneral:DisplaySystemMessage(ChatSpy.Chat.Text)
                end
            end
        end
        
        for _, player in pairs(Players:GetPlayers()) do
            player.Chatted:Connect(function(message)
                ChatSpy.onChatted(player, message)
            end)
        end
        
        Players.PlayerAdded:Connect(function(player)
            player.Chatted:Connect(function(message)
                ChatSpy.onChatted(player, message)
            end)
        end)
        
        ChatSpy.EnabledTF = ChatSpy.Enabled and "Enabled." or "Disabled."
        ChatSpy.Chat.Text = string.format('<font color="#10e3df">{SPY} - %s</font>', ChatSpy.EnabledTF)
        TextChatService.TextChannels.RBXGeneral:DisplaySystemMessage(ChatSpy.Chat.Text)
    end
})

LoggerTab:CreateToggle({
    Name = "[Leave] Logger",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            setupPlayerLeaveNotifier()
        else
            playerLeaveNotifierEnabled = false
        end
    end
})

local VisualSection = VisualTab:CreateSection("Visual")

VisualTab:CreateToggle({
    Name = "Unlock Third Person",
    CurrentValue = false,
    Flag = "ThirdPersonToggle",
    Callback = function(enabled)
        if enabled then
            plr.CameraMode = Enum.CameraMode.Classic
            plr.CameraMaxZoomDistance = 1000
            plr.CameraMinZoomDistance = 0.5
        else
            plr.CameraMode = Enum.CameraMode.LockFirstPerson
            plr.CameraMaxZoomDistance = 0.5
            plr.CameraMinZoomDistance = 0.5
        end
    end,
})
