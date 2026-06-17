local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "SKIDS killer | FTAP",
    LoadingTitle = "Loading menu...",
    LoadingSubtitle = "by gpthub",
    ConfigurationSaving = {
        Enabled = true,
        FileName = "gptconfig"
    }
})

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local plr = Players.LocalPlayer
local cam = workspace.CurrentCamera
local rs = game:GetService("ReplicatedStorage")
local mouse = plr:GetMouse()

local OthersTab = Window:CreateTab("Others", 4483362458)
local DefenseTab = Window:CreateTab("Defense", 4483362458)
local LoggerTab = Window:CreateTab("Logger", 4483362458)

local strengthV = 1000
local flingEnabled = false
local activeConnections = {}
local isSitLock = false
local wasSprinting = false
local sitLockConnection = nil
local antiGrab1T = false
local antiGrab1AnchorT = false
local antiBananaSitT = false
local antiBananaLegsT = false
local hipHeightLoop = nil
local masslessT = false
local slideTPT = false
local slideTPD = false
local antiExplodeT = false
local antiLagT = false
local autoAntiLagT = false
local lagDetectionThreshold = 5
local lagEvents = {}
local lagCheckInterval = 1

local CombatSection = OthersTab:CreateSection("Combat")


local function InitializeFling()
    for _, conn in pairs(activeConnections) do conn:Disconnect() end
    activeConnections = {}

    local char = plr.Character
    if not char then return end
    
    table.insert(activeConnections, workspace.ChildAdded:Connect(function(model)
        if model.Name == "GrabParts" then
            local grabPart = model:FindFirstChild("GrabPart")
            if grabPart then
                local weld = grabPart:FindFirstChildOfClass("WeldConstraint") or grabPart:FindFirstChild("Weld")
                if weld then
                    local part_to_impulse = weld.Part1 or weld.Part0
                    if part_to_impulse then
                        local conn = model:GetPropertyChangedSignal("Parent"):Connect(function()
                            if not model.Parent and flingEnabled then
                                local inputConn = UIS.InputBegan:Connect(function(input)
                                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                        local velocityObj = Instance.new("BodyVelocity")
                                        velocityObj.Velocity = cam.CFrame.LookVector * strengthV
                                        velocityObj.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                        velocityObj.Parent = part_to_impulse
                                        Debris:AddItem(velocityObj, 0.1)
                                    end
                                end)
                                table.insert(activeConnections, inputConn)
                            end
                        end)
                        table.insert(activeConnections, conn)
                    end
                end
            end
        end
    end))
end

function masslessF()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    for i, e in pairs(char:GetChildren()) do
        if e:IsA("BasePart") then
            e.Massless = masslessT
        end
    end
end

function antiGrab1F()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    while antiGrab1T and task.wait() do
        if plr.IsHeld.Value == true and antiGrab1T == true then
            if hrp ~= nil then
                if antiGrab1AnchorT then
                    hrp.Anchored = true
                    while plr.IsHeld.Value == true do rs.CharacterEvents.Struggle:FireServer(plr);wait(0.001) end
                    hrp.Anchored = false
                elseif not antiGrab1AnchorT then
                    while plr.IsHeld.Value == true do rs.CharacterEvents.Struggle:FireServer(plr);wait(0.001) end
                end
            end
        end
    end
end

function antiExplodeF()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    workspace.ChildAdded:Connect(function(model)
        if model.Name == "Part" and char ~= nil and antiExplodeT then
            local mag = (model.Position - hrp.Position).Magnitude
            if mag <= 20 then
                hrp.Anchored = true
                wait(0.01)
                while char["Right Arm"].RagdollLimbPart.CanCollide == true do wait(0.001) end
                hrp.Anchored = false
            end
        end
    end)
end

function antiLagF()
    local char = plr.Character
    if not char then return end
    
    local script = plr.PlayerScripts:FindFirstChild("CharacterAndBeamMove")
    if script then
        script.Disabled = antiLagT
    end
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
                Rayfield:Notify({
                    Title = "Auto Anti-Lag",
                    Content = "Автоматически включен",
                    Duration = 3
                })
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


OthersTab:CreateToggle({
    Name = "MassLess Grab",
    CurrentValue = false,
    Callback = function(Value)
        masslessT = Value
        masslessF()
    end
})

OthersTab:CreateToggle({
    Name = "Super Strength [LMB]",
    CurrentValue = false,
    Callback = function(Value)
        flingEnabled = Value
        if Value then
            InitializeFling()
            Rayfield:Notify({Title = "Super Strength", Content = "Enabled", Duration = 3})
        else
            for _, conn in pairs(activeConnections) do conn:Disconnect() end
            activeConnections = {}
        end
    end
})

OthersTab:CreateSlider({
    Name = "Strength Power",
    Range = {100, 5000},
    Increment = 100,
    Suffix = "units",
    CurrentValue = strengthV,
    Callback = function(Value) strengthV = Value end
})

OthersTab:CreateSlider({
    Name = "Strength Mass Check",
    Range = {1, 5},
    Increment = 1,
    Suffix = "units",
    CurrentValue = 1,
    Callback = function(Value) end
})

OthersTab:CreateDropdown({
    Name = "Sterngth Type",
    Options = {"All","Server"},
    CurrentOption = "All",
    MultipleOptions = false,
    Flag = "Dropdown1", 
    Callback = function(Option) end
})

local MovementSection = OthersTab:CreateSection("Movement")

function tpF()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    if not slideTPT then
        if char and hrp and mouse.Target and not slideTPT then hrp.CFrame = CFrame.new(mouse.Hit.x, mouse.Hit.y + 5, mouse.Hit.z) end
    elseif slideTPT then
        if not slideTPD and slideTPT and mouse.Target then
            slideTPD = true
            local info = TweenInfo.new(
                0.5, 
                Enum.EasingStyle.Sine, 
                Enum.EasingDirection.In,
                0,
                false,
                0
            )
            local info2 = TweenInfo.new(
                0.5, 
                Enum.EasingStyle.Sine, 
                Enum.EasingDirection.In,
                0,
                true,
                0
            )
            local e = {["CFrame"] = CFrame.new(mouse.Hit.x, mouse.Hit.y + 3, mouse.Hit.z)}
            local e2 = {FieldOfView = 100}
            char.Head.CanCollide = false
            char.Torso.CanCollide = false
            game:GetService("TweenService"):Create(hrp, info, e):Play()
            game:GetService("TweenService"):Create(cam, info2, e2):Play()
            wait(0.55)
            char.Head.CanCollide = true
            char.Torso.CanCollide = true
            cam.FieldOfView = 70
            slideTPD = false
        end
    end
end

OthersTab:CreateKeybind({
    Name = "Click TP",
    CurrentKeybind = "Z",
    HoldToInteract = false,
    Flag = "tpKeybindFlag",
    Callback = function(Keybind)
        tpF()
    end
})

function updateWalkSpeedF()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    if walkSpeedT then
        hum.WalkSpeed = walkSpeedV
    elseif not walkSpeedT then
        hum.WalkSpeed = 16
    end
    hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if walkSpeedT then
            hum.WalkSpeed = walkSpeedV
        elseif not walkSpeedT then
            hum.WalkSpeed = 16
        end
    end)
end

OthersTab:CreateToggle({
    Name = "WalkSpeed",
    CurrentValue = false,
    Flag = "walkSpeedToggleFlag",
    Callback = function(Value)
        walkSpeedT = Value 
        updateWalkSpeedF()
    end
})

local Slider = OthersTab:CreateSlider({
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

 local MovementSection = OthersTab:CreateSection("Player Teleport")

 function BringPlayerF()
    local char = plr.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    if inspectT and currentInspectS ~= 2 and currentInspectS ~= 4 then
        returnPosS = hrp.CFrame
        hrp.CFrame = currentInspectedAdorneeS.PrimaryPart.CFrame + Vector3.new(7, 3, 0)
        wait(0.15)
        if currentInspectS == 1 then
            rs.GrabEvents.SetNetworkOwner:FireServer(currentInspectedAdorneeS:WaitForChild("HumanoidRootPart"), currentInspectedAdorneeS:WaitForChild("HumanoidRootPart").CFrame)
            wait(0.1)
            currentInspectedAdorneeS:WaitForChild("HumanoidRootPart").CFrame = returnPosS
        else
            rs.GrabEvents.SetNetworkOwner:FireServer(currentInspectedAdorneeS.PrimaryPart, currentInspectedAdorneeS.PrimaryPart.CFrame)
            wait(0.1)
            currentInspectedAdorneeS.PrimaryPart.CFrame = returnPosS
        end
        hrp.CFrame = returnPosS
    elseif not inspectT then
        if mouse.Target.Parent:IsDescendantOf(workspace.PlotItems) or string.match(mouse.Target.Parent.Parent.Name, "SpawnedInToys") or mouse.Target.Parent.Parent:FindFirstChild("SpawningPlatform") or mouse.Target.Parent:FindFirstChildOfClass("Humanoid") then
            returnPosS = hrp.CFrame
            mouseTargetS = mouse.Target
            hrp.CFrame = mouseTargetS.Parent.PrimaryPart.CFrame + Vector3.new(10, 3, 0)
            wait(0.15)
            if mouseTargetS.Parent:FindFirstChildOfClass("Humanoid") then
                rs.GrabEvents.SetNetworkOwner:FireServer(mouseTargetS.Parent:WaitForChild("HumanoidRootPart"), mouseTargetS.Parent:WaitForChild("HumanoidRootPart").CFrame)
                wait(0.1)
                mouseTargetS.Parent:WaitForChild("HumanoidRootPart").CFrame = returnPosS
            else
                rs.GrabEvents.SetNetworkOwner:FireServer(mouseTargetS.Parent.PrimaryPart, mouseTargetS.Parent.PrimaryPart.CFrame)
                wait(0.1)
                mouseTargetS.Parent.PrimaryPart.CFrame = returnPosS
            end
            hrp.CFrame = returnPosS
            mouseTargetS = nil
        end
    end
end



 OthersTab:CreateKeybind({
    Name = "Bring Player",
    CurrentKeybind = "B",
    HoldToInteract = false,
    Flag = "tpKeybindFlag",
    Callback = function(Keybind)
        BringPlayerF()
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

local function UpdateSitLock()
    if sitLockConnection then sitLockConnection:Disconnect() end
    
    if not isSitLock then return end
    
    local char = plr.Character
    if not char then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    humanoid.Sit = true
    sitLockConnection = RunService.Heartbeat:Connect(function()
        if not isSitLock or not char:IsDescendantOf(workspace) then
            if sitLockConnection then sitLockConnection:Disconnect() end
            return
        end
        if not humanoid.Sit then humanoid.Sit = true end
    end)
end

local usedBananas = {}
local farCFrame = CFrame.new(10000, -10000, 10000)
local dropVector = Vector3.new(0, -20.34, 0)

local function generateUniqueId()
    return tostring(math.random(100000, 999999))
end

local function handleBanana(item)
    if not _G.EAT_BANANAS then return end

    local bananaId = item:FindFirstChild("BananaId")
    if not bananaId then
        bananaId = Instance.new("StringValue")
        bananaId.Name = "BananaId"
        bananaId.Value = generateUniqueId()
        bananaId.Parent = item
    end

    if not usedBananas[bananaId.Value] then
        usedBananas[bananaId.Value] = true
        local holdPart = item:FindFirstChild("HoldPart")
        
        if holdPart then
            local args1 = {item, plr.Character}
            pcall(function()
                holdPart:WaitForChild("HoldItemRemoteFunction"):InvokeServer(unpack(args1))
            end)
            
            local args2 = {item, farCFrame, dropVector}
            pcall(function()
                holdPart:WaitForChild("DropItemRemoteFunction"):InvokeServer(unpack(args2))
            end)
        end
    end
end

local function handleBananaFolder(folder)
    if not folder or not folder:IsA("Folder") then return end
    for _, item in pairs(folder:GetChildren()) do
        if item.Name == "FoodBanana" then
            handleBanana(item)
        end
    end
end

local function scanWorkspace()
    for _, folder in pairs(workspace:GetChildren()) do
        if folder and string.find(folder.Name, "SpawnedInToys") then
            handleBananaFolder(folder)
        end
    end
end

local scanLoop = nil
local childAddedConnection = nil

local function startScanning()
    if scanLoop then scanLoop:Disconnect() end
    scanLoop = RunService.Heartbeat:Connect(scanWorkspace)
end

local function stopScanning()
    if scanLoop then scanLoop:Disconnect() end
end

local function startChildTracking()
    if childAddedConnection then childAddedConnection:Disconnect() end
    childAddedConnection = workspace.ChildAdded:Connect(function(child)
        if child and string.find(child.Name, "SpawnedInToys") then
            wait(0.1)
            handleBananaFolder(child)
        end
    end)
end

local function stopChildTracking()
    if childAddedConnection then childAddedConnection:Disconnect() end
end

DefenseTab:CreateToggle({
    Name = "Anti Banana [SIT]",
    CurrentValue = false,
    Callback = function(Value)
        antiBananaSitT = Value
        isSitLock = Value
        UpdateSitLock()
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
            
            for i = 1, 10 do pcall(function() rs.CharacterEvents.RagdollRemote:FireServer(hrp, 1) end) task.wait(0.05) end
            for _, leg in ipairs({"Left Leg", "Right Leg"}) do
                local part = char:FindFirstChild(leg)
                if part then part.CFrame = CFrame.new(hrp.Position + Vector3.new(5, -59999, 0)) end
            end
            for i = 1, 5 do pcall(function() rs.CharacterEvents.RagdollRemote:FireServer(hrp, 0) end) task.wait(0.05) end
        else
            if hipHeightLoop then task.cancel(hipHeightLoop) end
        end
    end
})

DefenseTab:CreateToggle({
    Name = "Anti Banana [EAT]",
    CurrentValue = false,
    Flag = "Anti Banana",
    Callback = function(Value)
        if Value then
            _G.EAT_BANANAS = true
            startScanning()
            startChildTracking()
        else
            _G.EAT_BANANAS = false
            stopScanning()
            stopChildTracking()
        end
    end
})

DefenseTab:CreateToggle({
    Name = "Anti Explode",
    CurrentValue = false,
    Flag = "Anti Explode",
    Callback = function(Value)
        if Value then
            antiExplodeT = Value
            antiExplodeF()
        end
    end
})

DefenseTab:CreateToggle({
    Name = "Anti SnowBall [Trip]",
    CurrentValue = false,
    Flag = "AntiSnowballToggle",
    Callback = function(Value)
        if Value then
            local char = plr.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    pcall(function()
                        local humanoid = char:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                            task.delay(0.5, function()
                                if humanoid and humanoid.Parent then
                                    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                                end
                            end)
                        end
                    end)
                end
            end
        end
    end
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
        if SPY_LOADED == true then return end
        pcall(function() getgenv().SPY_LOADED = true end)
     
        repeat wait() until game:GetService("ContentProvider").RequestQueueSize == 0
        repeat wait() until game:IsLoaded()
        
        -- // Vars
        local Players = game:GetService("Players")
        local StarterGui = game:GetService("StarterGui")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local LocalPlayer = Players.LocalPlayer
        local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
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
        };
        
       
        function ChatSpy.checkIgnored(message)
            for i = 1, #ChatSpy.IgnoreList do
                local v = ChatSpy.IgnoreList[i]
                if (v.ExactMatch and message == v.Message) or (not v.ExactMatch and string.match(v.Message, message)) then 
                    return true
                end
            end
            return false
        end
        
        function ChatSpy.onChatted(targetPlayer, message)
            if (targetPlayer == LocalPlayer and string.lower(message) == "/spy") then
            ChatSpy.Count = ChatSpy.Count + 1
            if ChatSpy.Count < 2 then
                ChatSpy.Enabled = not(ChatSpy.Enabled)
                ChatSpy.EnabledTF = ChatSpy.Enabled and "Enabled." or "Disabled."
                ChatSpy.Chat.Text = `<font color='#10e3df'>{"{SPY} - "..ChatSpy.EnabledTF}</font>`
                task.wait(0.55)
                TextChatService.TextChannels.RBXGeneral:DisplaySystemMessage(ChatSpy.Chat.Text)
            else
                ChatSpy.Count = 0
            end
            elseif (ChatSpy.Enabled and (ChatSpy.SpyOnSelf or targetPlayer ~= LocalPlayer)) then
                local message = message:gsub("[\n\r]",''):gsub("\t",' '):gsub("[ ]+",' ')
        
                local Hidden = true
                local Connect = TextChatService.MessageReceived:Connect(function()
                    Hidden = false
                end)
        
                task.wait(0.75)
                Connect:Disconnect()
                Connect = nil
        
                if (Hidden and ChatSpy.Enabled and not ChatSpy.checkIgnored(message)) then
                    if (#message > 1200) then
                        message = message:sub(1200) .. "..."
                    end
                    if message:sub(1,2) == "/w" then
                        for _,plr in pairs(Players:GetPlayers()) do
                            local msg, count = message:gsub(plr.Name,plr.DisplayName)
                            if count ~= 0 then
                                ChatSpy.Chat.Text = `<font color='#10e3df'>{"{SPY} ["..targetPlayer.DisplayName.."]: "..msg}</font>`
                                break
                            end
                        end
                    else
                        ChatSpy.Chat.Text = `<font color='#10e3df'>{"{SPY} ["..targetPlayer.DisplayName.."]: "..message}</font>`
                    end
                    TextChatService.TextChannels.RBXGeneral:DisplaySystemMessage(ChatSpy.Chat.Text)
                end
            end
        end
        
  
        local AllPlayers = Players:GetPlayers()
        for i = 1, #AllPlayers do
            local player = AllPlayers[i]
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
        ChatSpy.Chat.Text = `<font color='#10e3df'>{"{SPY} - "..ChatSpy.EnabledTF}</font>`
        TextChatService.TextChannels.RBXGeneral:DisplaySystemMessage(ChatSpy.Chat.Text)
    end
})

local playerLeaveNotifierEnabled = false
local function setupPlayerLeaveNotifier()
    if playerLeaveNotifierEnabled then return end
    playerLeaveNotifierEnabled = true
    
    Players.PlayerRemoving:Connect(function(player)
        local username = player.Name
        local displayName = player.DisplayName
        local message = string.format("[LEFT] %s (@%s)", displayName, username)
        
        Rayfield:Notify({
            Title = "Player Left",
            Content = message,
            Duration = 6.5,
            Image = 4483362458
        })
    end)
end

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

Rayfield:Notify({Title = "SKIDS killer", Content = "Successfully loaded!", Duration = 5})