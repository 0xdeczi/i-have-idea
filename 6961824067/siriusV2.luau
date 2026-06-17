local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true

_G.LoopFling = _G.LoopFling or {
    targetNames = {},
    loopActive = false,
    lastPosition = nil,
    stayDuration = 1,
    returnDuration = 0.4,
    magnetRange = 1,
    teleportSpeed = 0.8,
    playerIsInVoid = false
}

local _SpectateGlobals = {
    players = game:GetService("Players"),
    camera = workspace.CurrentCamera,
    localPlayer = game:GetService("Players").LocalPlayer,
    targetPlayer = nil,
    spectating = false,
    playerList = {}
}

local playerLeaveNotifierEnabled = false
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local function updatePlayerList(dropdown)
    local currentPlayers = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(currentPlayers, player.Name)
        end
    end
    if dropdown then
        dropdown:SetValues(currentPlayers)
    end
    return currentPlayers
end

local function spectatePlayer(targetName)
    _SpectateGlobals.targetPlayer = _SpectateGlobals.players:FindFirstChild(targetName)
    if _SpectateGlobals.targetPlayer and _SpectateGlobals.targetPlayer.Character 
       and _SpectateGlobals.targetPlayer.Character:FindFirstChild("Humanoid") then
        _SpectateGlobals.camera.CameraSubject = _SpectateGlobals.targetPlayer.Character.Humanoid
        _SpectateGlobals.spectating = true
    else
        _SpectateGlobals.spectating = false
    end
end

local paintPartsBackup = {}
local connections = {}

local function deleteAllPaintParts()
	for _, obj in ipairs(Workspace:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Name == "PaintPlayerPart" then
			local clone = obj:Clone()
			clone.Archivable = true
			paintPartsBackup[obj:GetDebugId()] = { clone = clone, parent = obj.Parent }
			obj:Destroy()
		end
	end
end

local function restorePaintParts()
	for _, data in pairs(paintPartsBackup) do
		if data.clone and data.parent then
			data.clone.Parent = data.parent
		end
	end
	paintPartsBackup = {}
end

local function watchNewPaintParts()
	table.insert(connections, Workspace.DescendantAdded:Connect(function(obj)
		if obj:IsA("BasePart") and obj.Name == "PaintPlayerPart" then
			task.defer(function()
				if obj and obj.Parent then
					local clone = obj:Clone()
					clone.Archivable = true
					paintPartsBackup[obj:GetDebugId()] = { clone = clone, parent = obj.Parent }
					obj:Destroy()
				end
			end)
		end
	end))
end

local function disconnectWatchers()
	for _, conn in ipairs(connections) do
		if conn.Connected then conn:Disconnect() end
	end
	connections = {}
end

local function setTouchQuery(state)
	local char = Workspace:FindFirstChild(LocalPlayer.Name)
	if not char then return end
	for _, v in ipairs(char:GetChildren()) do
		if v:IsA("Part") or v:IsA("BasePart") then
			v.CanTouch = state
			v.CanQuery = state
		end
	end
end

local function setupPlayerTracking()  
    _SpectateGlobals.players.PlayerAdded:Connect(function(player)  
        updatePlayerList()  
        if playerDropdown then  
            playerDropdown:SetValues(updatePlayerList())  
        end  
    end)   
    _SpectateGlobals.players.PlayerRemoving:Connect(function(player)  
        updatePlayerList()  
        if playerDropdown then  
            playerDropdown:SetValues(updatePlayerList())  
        end   
        if _SpectateGlobals.spectating and player.Name == (_SpectateGlobals.targetPlayer and _SpectateGlobals.targetPlayer.Name) then  
            _SpectateGlobals.camera.CameraSubject = _SpectateGlobals.localPlayer.Character and _SpectateGlobals.localPlayer.Character:FindFirstChild("Humanoid")  
            _SpectateGlobals.spectating = false  
        end  
    end)  
end

local antiGrab1T = false
local antiGrab1AnchorT = false

local function antiGrab1F()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp or not hum then return end
    
    while antiGrab1T and task.wait() do
        if LocalPlayer.IsHeld.Value == true and antiGrab1T == true then
            if hrp ~= nil then
                if antiGrab1AnchorT then
                    hrp.Anchored = true
                    while LocalPlayer.IsHeld.Value == true do 
                        ReplicatedStorage.CharacterEvents.Struggle:FireServer(LocalPlayer)
                        task.wait(0.001) 
                    end
                    hrp.Anchored = false
                elseif not antiGrab1AnchorT then
                    while LocalPlayer.IsHeld.Value == true do 
                        ReplicatedStorage.CharacterEvents.Struggle:FireServer(LocalPlayer)
                        task.wait(0.001) 
                    end
                end
            end
        end
    end
end

local function Bring(targetPlayerName)
    local NetworkRemote = ReplicatedStorage:WaitForChild("GrabEvents"):WaitForChild("SetNetworkOwner")
    local TargetPlayer = Players:FindFirstChild(targetPlayerName)

    if not TargetPlayer then
        Library:Notify("Player not found: " .. targetPlayerName, 3)
        return
    end

    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local Humanoid = Character:WaitForChild("Humanoid")
    local RootPart = Character:WaitForChild("HumanoidRootPart")
    local Seat = Humanoid.SeatPart

    if not Seat or not TargetPlayer or TargetPlayer == LocalPlayer then return end

    local SeatObject = Seat.Parent
    local TargetCharacter = TargetPlayer.Character or TargetPlayer.CharacterAdded:Wait()
    local TargetRoot = TargetCharacter:WaitForChild("HumanoidRootPart")
    local Detector = SeatObject:WaitForChild("LeftDetector")
    local Weld = Detector:WaitForChild("LeftWeld")
    local GrabRemote = SeatObject.BlobmanSeatAndOwnerScript:WaitForChild("CreatureGrab")

    local OriginalPosition = RootPart.CFrame
    
    local OriginalTransparency = {}
    for _, part in ipairs(Character:GetDescendants()) do
        if part:IsA("BasePart") then
            OriginalTransparency[part] = part.Transparency
            part.Transparency = 1
        end
    end
    
    local Camera = workspace.CurrentCamera
    local OriginalCameraCFrame = Camera.CFrame
    Camera.CameraType = Enum.CameraType.Scriptable
    Camera.CFrame = OriginalCameraCFrame

    RootPart.CFrame = TargetRoot.CFrame * CFrame.new(0, 0, 2.5)
    task.wait()

    GrabRemote:FireServer(Detector, TargetRoot, Weld)
    task.delay(0.1, function()
        GrabRemote:FireServer(Detector, TargetRoot, Weld)
    end)

    task.delay(0.2, function()
        RootPart.CFrame = OriginalPosition
        
        for part, transparency in pairs(OriginalTransparency) do
            if part and part.Parent then
                part.Transparency = transparency
            end
        end
        
        Camera.CameraType = Enum.CameraType.Custom
        Camera.CameraSubject = Humanoid
    end)
end

local function setupPlayerLeaveNotifier()
    if playerLeaveNotifierEnabled then return end
    playerLeaveNotifierEnabled = true
    
    Players.PlayerRemoving:Connect(function(player)
        local message = string.format("[LEFT] %s (@%s)", player.DisplayName, player.Name)
        Library:Notify({Title = "Player Left", Content = message, Duration = 6.5, Image = 4483362458})
    end)
end

local function Kick(targetPlayerName)
    local target = Players:FindFirstChild(targetPlayerName)

    if not target then
        Library:Notify("Player not found: " .. targetPlayerName, 3)
        return
    end

    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")
    local hrp = char:WaitForChild("HumanoidRootPart")
    local seat = humanoid.SeatPart

    if seat and target and target ~= LocalPlayer then
        local seatParent, targetChar = seat.Parent, target.Character or target.CharacterAdded:Wait()
        local targetHRP = targetChar:WaitForChild("HumanoidRootPart")
        local det = seatParent:WaitForChild("LeftDetector")
        local weld = det:WaitForChild("LeftWeld")
        local grab = seatParent.BlobmanSeatAndOwnerScript:WaitForChild("CreatureGrab")
        local drop = seatParent.BlobmanSeatAndOwnerScript:WaitForChild("CreatureDrop")

        local originalCFrame = hrp.CFrame

        hrp.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 3)
        task.wait(0.5)

        grab:FireServer(det, targetHRP, weld)
        task.wait(0.7)

        drop:FireServer(weld, targetHRP)
        task.wait(0.3)

        grab:FireServer(det, targetHRP, weld)

        local bp = Instance.new("BodyPosition")
        bp.Position = Vector3.new(0, 999e5000, 0)
        bp.MaxForce = Vector3.new(0, 99999e990, 0)
        bp.Parent = targetHRP

        task.wait(0.6)

        grab:FireServer(det, targetHRP, weld)
        bp:Destroy()

        hrp.CFrame = originalCFrame
    end
end

local playerName = LocalPlayer.Name

local humanoid, rootPart, seat
local antiGucciConnection
local safePosition
local restoreFrames = 0

local function spawnBlobman()
    local args = {
        [1] = "CreatureBlobman",
        [2] = CFrame.new(0, 5000000, 0),
        [3] = Vector3.new(0, 60, 0)
    }
    ReplicatedStorage.MenuToys.SpawnToyRemoteFunction:InvokeServer(unpack(args))

    local folder = Workspace:WaitForChild(playerName.."SpawnedInToys", 5)
    if folder and folder:FindFirstChild("CreatureBlobman") then
        local blob = folder.CreatureBlobman
        if blob:FindFirstChild("Head") then
            blob.Head.CFrame = CFrame.new(0, 50000, 0)
            blob.Head.Anchored = true
        end
    end
end

local function startAntiGucci()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    safePosition = rootPart.Position

    local folder = Workspace:FindFirstChild(playerName.."SpawnedInToys")
    local blob = folder and folder:FindFirstChild("CreatureBlobman")
    seat = blob and blob:FindFirstChild("VehicleSeat")

    if seat and seat:IsA("VehicleSeat") then
        rootPart.CFrame = seat.CFrame + Vector3.new(0, 2, 0)
        seat:Sit(humanoid)
    end

    humanoid:GetPropertyChangedSignal("Jump"):Connect(function()
        if humanoid.Jump and humanoid.Sit then
            restoreFrames = 15
            safePosition = rootPart.Position
        end
    end)

    if antiGucciConnection then antiGucciConnection:Disconnect() end
    antiGucciConnection = RunService.Heartbeat:Connect(function()
        if not rootPart or not humanoid then return end
        ReplicatedStorage.CharacterEvents.RagdollRemote:FireServer(rootPart, 0)
        if restoreFrames > 0 then
            rootPart.CFrame = CFrame.new(safePosition)
            restoreFrames -= 1
        end
    end)

    task.spawn(function()
        while humanoid.Sit do
            task.wait(1)
        end
        task.wait(0.5)
        rootPart.CFrame = CFrame.new(safePosition)
    end)
end

local function stopAntiGucci()
    if antiGucciConnection then
        antiGucciConnection:Disconnect()
        antiGucciConnection = nil
    end
    local blobFolder = Workspace:FindFirstChild(playerName.."SpawnedInToys")
    if blobFolder and blobFolder:FindFirstChild("CreatureBlobman") then
        blobFolder.CreatureBlobman:Destroy()
    end
end

local function LoopKick(targetPlayerName)
    local target = Players:FindFirstChild(targetPlayerName)

    if not target then
        Library:Notify("Player not found: " .. targetPlayerName, 3)
        return
    end

    if target == LocalPlayer then return end

    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")
    local hrp = char:WaitForChild("HumanoidRootPart")
    local seat = humanoid.SeatPart
    if not seat then return end

    local seatParent = seat.Parent
    local targetChar = target.Character or target.CharacterAdded:Wait()
    local targetHumanoid = targetChar:WaitForChild("Humanoid")
    local targetHRP = targetChar:WaitForChild("HumanoidRootPart")

    local leftDet = seatParent:WaitForChild("LeftDetector")
    local leftWeld = leftDet:WaitForChild("LeftWeld")
    local rightDet = seatParent:WaitForChild("RightDetector")
    local rightWeld = rightDet:WaitForChild("RightWeld")

    local grab = seatParent.BlobmanSeatAndOwnerScript:WaitForChild("CreatureGrab")
    local drop = seatParent.BlobmanSeatAndOwnerScript:WaitForChild("CreatureDrop")

    local function grabWithHand(det, weld, targetPart)
        grab:FireServer(det, targetPart, weld)
    end

    local function dropWithHand(weld, targetPart)
        drop:FireServer(weld, targetPart)
    end

    local originalCFrame = hrp.CFrame
    hrp.CFrame = targetHRP.CFrame * CFrame.new(0, -5, 0)
    task.wait(0.1)

    grabWithHand(leftDet, leftWeld, targetHRP)
    task.wait(0.5)
    dropWithHand(leftWeld, targetHRP)
    task.wait(0.2)

    local bp = Instance.new("BodyPosition")
    bp.Position = Vector3.new(0, 999e6, 0)
    bp.MaxForce = Vector3.new(999e6, 999e6, 999e6)
    bp.Parent = targetHRP

    grabWithHand(leftDet, leftWeld, targetHRP)
    task.wait(0.5)
    dropWithHand(leftWeld, targetHRP)
    task.wait(0.5)

    while target and target.Parent and target ~= LocalPlayer do
        if targetHumanoid.Health > 0 then
            grabWithHand(leftDet, leftWeld, targetHRP)
            task.wait()
            dropWithHand(leftWeld, targetHRP)
            task.wait()

            grabWithHand(rightDet, rightWeld, targetHRP)
            task.wait()
            dropWithHand(rightWeld, targetHRP)
            task.wait()

            grabWithHand(leftDet, leftWeld, targetHRP)
            grabWithHand(rightDet, rightWeld, targetHRP)
            task.wait()

            dropWithHand(leftWeld, targetHRP)
            dropWithHand(rightWeld, targetHRP)
            task.wait()
        else
            break
        end
    end

    if bp then bp:Destroy() end
    hrp.CFrame = originalCFrame
end

local function Bypass(targetPlayerName)
    local target = Players:FindFirstChild(targetPlayerName)

    if not target or target == LocalPlayer then 
        Library:Notify("Invalid target player", 3)
        return 
    end

    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")
    local hrp = char:WaitForChild("HumanoidRootPart")
    local seat = humanoid.SeatPart
    if not seat then 
        Library:Notify("You need to be on a blobman seat", 3)
        return 
    end

    local seatParent = seat.Parent
    local targetChar = target.Character or target.CharacterAdded:Wait()
    local targetHumanoid = targetChar:WaitForChild("Humanoid")
    local targetHRP = targetChar:WaitForChild("HumanoidRootPart")

    local leftDet = seatParent:WaitForChild("LeftDetector")
    local leftWeld = leftDet:WaitForChild("LeftWeld")
    local rightDet = seatParent:WaitForChild("RightDetector")
    local rightWeld = rightDet:WaitForChild("RightWeld")

    local grab = seatParent.BlobmanSeatAndOwnerScript:WaitForChild("CreatureGrab")
    local drop = seatParent.BlobmanSeatAndOwnerScript:WaitForChild("CreatureDrop")

    local function grabWithHand(det, weld, targetPart)
        grab:FireServer(det, targetPart, weld)
    end

    local function dropWithHand(weld, targetPart)
        drop:FireServer(weld, targetPart)
    end

    task.wait(0.05)

    while target and target.Parent and targetHumanoid.Health > 0 and Toggles.LoopAppleMethod.Value do
        grabWithHand(leftDet, leftWeld, targetHRP)
        
        grabWithHand(leftDet, leftWeld, targetHRP)
        grabWithHand(leftDet, leftWeld, targetHRP)
        grabWithHand(leftDet, leftWeld, targetHRP)

       grabWithHand(leftDet, leftWeld, targetHRP)
        grabWithHand(leftdet, lefttWeld, targetHRP)
        grabWithHand(leftDet, leftWeld, targetHRP)
        grabWithHand(leftDet, leftWeld, targetHRP)
        grabWithHand(leftdet, leftweld, targetHRP)
        grabWithHand(leftDet, leftWeld, targetHRP)
        grabWithHand(leftDet, leftWeld, targetHRP)
        grabWithHand(leftDet, leftWeld, targetHRP)
        grabWithHand(leftDet, leftWeld, targetHRP)
        grabWithHand(leftDet, leftWeld, targetHRP)

                grabWithHand(leftDet, leftWeld, targetHRP)
        grabWithHand(leftDet, leftWeld, targetHRP)
            

        dropWithHand(leftWeld, targetHRP)
        dropWithHand(leftWeld, targetHRP)

                grabWithHand(leftDet, leftWeld, targetHRP)
        grabWithHand(leftDet, leftWeld, targetHRP)
                grabWithHand(leftDet, leftWeld, targetHRP)
        grabWithHand(leftDet, leftWeld, targetHRP)
                grabWithHand(leftDet, leftWeld, targetHRP)
        grabWithHand(leftDet, leftWeld, targetHRP)
                grabWithHand(leftDet, leftWeld, targetHRP)
        grabWithHand(leftDet, leftWeld, targetHRP)
        
        task.wait(0.01)
        
        if not Toggles.LoopAppleMethod.Value then
            break
        end
    end

    if bp then bp:Destroy() end
end

local function ExecuteFling(targetCharacter)
    local humanoid = targetCharacter:FindFirstChildOfClass("Humanoid")
    local rootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
    if humanoid and rootPart then
        local GrabEvents = ReplicatedStorage:WaitForChild("GrabEvents")
        local SetNetworkOwner = GrabEvents:WaitForChild("SetNetworkOwner")
        
        SetNetworkOwner:FireServer(rootPart, rootPart.CFrame)
        
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
        bodyVelocity.Velocity = Vector3.new(0, 1000, 0)
        bodyVelocity.Parent = rootPart

        local isGoingUp = true
        while _G.LoopFling.loopActive do
            if isGoingUp then
                bodyVelocity.Velocity = Vector3.new(0, 1000, 0)
            else
                bodyVelocity.Velocity = Vector3.new(0, -1000, 0)
            end

            isGoingUp = not isGoingUp
            task.wait(0.5)
        end
        
        bodyVelocity:Destroy()
    end
end

local function teleportTo(position)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local root = LocalPlayer.Character.HumanoidRootPart
        for _ = 1, 5 do
            root.CFrame = root.CFrame:Lerp(position, _G.LoopFling.teleportSpeed)
            task.wait(0.02)
        end
    end
end

local function stickToTarget(targetRoot)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local root = LocalPlayer.Character.HumanoidRootPart
        local distance = (root.Position - targetRoot.Position).Magnitude

        if distance < _G.LoopFling.magnetRange then
            root.CFrame = targetRoot.CFrame + Vector3.new(0, 0, -1)
            root.Velocity = Vector3.new(0, 0, 0)
        end
    end
end

local function startLoopFling(targetPlayer)
    if not targetPlayer then return end

    if not _G.LoopFling.lastPosition and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        _G.LoopFling.lastPosition = LocalPlayer.Character.HumanoidRootPart.CFrame
    end

    while _G.LoopFling.loopActive do
        local targetCharacter = targetPlayer.Character
        if targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart") then
            local targetRoot = targetCharacter.HumanoidRootPart

            teleportTo(targetRoot.CFrame + Vector3.new(0, 0, -2))
            task.wait(0.1)
            stickToTarget(targetRoot)

            ExecuteFling(targetCharacter)
            task.wait(_G.LoopFling.stayDuration)
        end

        if _G.LoopFling.lastPosition then
            teleportTo(_G.LoopFling.lastPosition)
            task.wait(_G.LoopFling.returnDuration)
        end
        
        task.wait()
    end
end

local function autoAdjustLoop()
    while _G.LoopFling.loopActive do
        for _, targetName in ipairs(_G.LoopFling.targetNames) do
            local targetPlayer = Players:FindFirstChild(targetName)
            if targetPlayer and targetPlayer.Character then
                task.spawn(function() startLoopFling(targetPlayer) end)
            end
        end
        task.wait(0.1)
    end
end

local Window = Library:CreateWindow({
    Title = "Sirius Rewrite",
    Footer = "version: 2.0",
    NotifySide = "Right",
    ShowCustomCursor = true,
})

local Tabs = {
    LocalPlayer = Window:AddTab("LocalPlayer", "user"),
    Target = Window:AddTab("Target", "user"),
    Visuals = Window:AddTab("Visuals", "user"),
    Keybinds = Window:AddTab("Keybinds", "user"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

local LeftGroupBox = Tabs.Target:AddLeftGroupbox("Blobman Features", "boxes")

LeftGroupBox:AddInput("TargetPlayerName", {
    Default = "",
    Numeric = false,
    Finished = false,
    ClearTextOnFocus = true,
    Text = "Target Player Name",
    Placeholder = "Player name",
    Callback = function(Value)
    end,
})

LeftGroupBox:AddDropdown("MethodSelect", {
    Values = {"Bring", "Loop Kick", "Bypass", "Kick"},
    Default = 1,
    Multi = false,
    Text = "Selected Method",
    Callback = function(Value)
    end,
})

LeftGroupBox:AddToggle("LoopAppleMethod", {
    Text = "Loop Apple Method",
    Default = false,
    Callback = function(Value)
    end,
})

LeftGroupBox:AddButton({
    Text = "Apply Method Once",
    Func = function()
        local targetName = Options.TargetPlayerName.Value
        local method = Options.MethodSelect.Value
        
        if targetName ~= "" then
            if method == "Bring" then
                Bring(targetName)
                Library:Notify("Bring method applied to: " .. targetName, 3)
            elseif method == "Kick" then
                Kick(targetName)
                Library:Notify("Kick method applied to: " .. targetName, 3)
            elseif method == "Loop Kick" then
                LoopKick(targetName)
                Library:Notify("Loop Kick method applied to: " .. targetName, 3)
            elseif method == "Bypass" then
                Bypass(targetName)
                Library:Notify("Bypass method applied to: " .. targetName, 3)
            end
        else
            Library:Notify("Please enter a target player name", 3)
        end
    end,
    DoubleClick = false,
})

local loopAppleMethodActive = false

Toggles.LoopAppleMethod:OnChanged(function()
    if Toggles.LoopAppleMethod.Value then
        local targetName = Options.TargetPlayerName.Value
        local method = Options.MethodSelect.Value
        
        if targetName ~= "" and not loopAppleMethodActive then
            loopAppleMethodActive = true
            spawn(function()
                while Toggles.LoopAppleMethod.Value and not Library.Unloaded do
                    if method == "Bring" then
                        Bring(targetName)
                    elseif method == "Kick" then
                        Kick(targetName)
                    elseif method == "Loop Kick" then
                        LoopKick(targetName)
                    elseif method == "Bypass" then
                        Bypass(targetName)
                    end
                    task.wait(1)
                end
                loopAppleMethodActive = false
            end)
        else
            Library:Notify("Please enter a target player name", 3)
            Toggles.LoopAppleMethod:SetValue(false)
        end
    end
end)

local DefenseGroupBox = Tabs.LocalPlayer:AddLeftGroupbox("Anti Functions", "boxes")

DefenseGroupBox:AddToggle("AntiGrabToggle", {
    Text = "Anti Grab",
    Default = false,
    Callback = function(Value)
        antiGrab1T = Value
        if Value then
            spawn(antiGrab1F)
        end
    end
})

DefenseGroupBox:AddToggle("AutoGucciToggle", {
    Text = "Auto Gucci",
    Default = false,
    Callback = function()
        spawnBlobman()
        startAntiGucci()
    end,
})

DefenseGroupBox:AddToggle("PlotBarriersToggle", {
    Text = "Anti Barrier",
    Default = false,
    Callback = function(Value)
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return end
        
        for _, plot in ipairs(plots:GetChildren()) do
            local barrierModel = plot:FindFirstChild("Barrier")
            if barrierModel then
                for _, part in ipairs(barrierModel:GetChildren()) do
                    if part:IsA("BasePart") and part.Name == "PlotBarrier" then
                        part.CanCollide = not Value
                    end
                end
            end
        end
    end
})

DefenseGroupBox:AddToggle("PaintDeleteToggle", {
    Text = "Anti Paint",
    Default = false,
    Callback = function(state)
        if state then
            deleteAllPaintParts()
            watchNewPaintParts()
            setTouchQuery(false)
        else
            restorePaintParts()
            disconnectWatchers()
            setTouchQuery(true)
        end
    end
})

local PlayerFunctionsGroupBox = Tabs.LocalPlayer:AddRightGroupbox("Local Player Functions", "boxes")

local walkSpeedT = false
local walkSpeedV = 16

local function updateWalkSpeedF()
    local char = LocalPlayer.Character
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

PlayerFunctionsGroupBox:AddToggle("WalkSpeedToggle", {
    Text = "WalkSpeed",
    Default = false,
    Callback = function(Value)
        walkSpeedT = Value 
        updateWalkSpeedF()
    end
})

PlayerFunctionsGroupBox:AddSlider("SpeedCountSlider", {
    Text = "Speed Count",
    Range = {16, 100},
    Increment = 16,
    Suffix = "",
    Default = 16,
    Callback = function(Value)
        walkSpeedV = Value
        updateWalkSpeedF()
    end,
})

local TargetGroupBox = Tabs.Target:AddRightGroupbox("Targets", "boxes")

local playerDropdown = TargetGroupBox:AddDropdown("ListPlayersDropdown", {
    Values = {},
    Default = 1,
    Multi = false,
    Text = "Select Player",
    Callback = function(Value)
        Options.TargetPlayerName:SetValue(Value)
    end,
})

TargetGroupBox:AddToggle("LoopBounceToggle", {
    Text = "Loop bounce",
    Default = false,
    Callback = function(Value)
        _G.LoopFling.loopActive = Value
        
        if Value then
            local targetName = Options.TargetPlayerName.Value
            if targetName == "" then
                Library:Notify("Please select a target player first", 3)
                Toggles.LoopBounceToggle:SetValue(false)
                return
            end
            
            _G.LoopFling.targetNames = {targetName}
            spawn(autoAdjustLoop)
        end
        
        Library:Notify("Loop bounce " .. (Value and "enabled" or "disabled"), 3)
    end,
})

local LeftGroupBox = Tabs.Visuals:AddLeftGroupbox("Visuals", "boxes")

local plr = game.Players.LocalPlayer

LeftGroupBox:AddToggle("Thirdperson", {
    Text = "Unlock Third Person",
    Default = false,
    Callback = function(Value)
        if Value then
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


local Players = game:GetService("Players")
local plr = Players.LocalPlayer

LeftGroupBox:AddToggle("ChatSPY", {
    Text = "Chat [SPY]",
    Default = false,
    Callback = function(Value)
        if getgenv().SPY_LOADED then return end
        getgenv().SPY_LOADED = true

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
                if (v.ExactMatch and message == v.Message) or (not v.ExactMatch and string.match(message, v.Message)) then 
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

                if ChatSpy.Enabled and not ChatSpy.checkIgnored(message) then
                    if #message > 1200 then
                        message = message:sub(1,1200) .. "..."
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
    end,
})


local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu", "wrench")

MenuGroup:AddToggle("KeybindMenuOpen", {
    Default = Library.KeybindFrame.Visible,
    Text = "Open Keybind Menu",
    Callback = function(value)
        Library.KeybindFrame.Visible = value
    end,
})

MenuGroup:AddToggle("ShowCustomCursor", {
    Text = "Custom Cursor",
    Default = true,
    Callback = function(Value)
        Library.ShowCustomCursor = Value
    end,
})

MenuGroup:AddDropdown("NotificationSide", {
    Values = { "Left", "Right" },
    Default = "Right",
    Text = "Notification Side",
    Callback = function(Value)
        Library:SetNotifySide(Value)
    end,
})

MenuGroup:AddDropdown("DPIDropdown", {
    Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
    Default = "100%",
    Text = "DPI Scale",
    Callback = function(Value)
        Value = Value:gsub("%%", "")
        local DPI = tonumber(Value) / 100
        Library:SetDPIScale(DPI)
    end,
})

MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind")
    :AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })

MenuGroup:AddButton("Unload", function()
    Library:Unload()
end)

updatePlayerList(playerDropdown)

Players.PlayerAdded:Connect(function()
    updatePlayerList(playerDropdown)
end)

Players.PlayerRemoving:Connect(function()
    updatePlayerList(playerDropdown)
end)

RunService.Heartbeat:Connect(function()
    if not _G.LoopFling.loopActive then return end

    for _, targetName in ipairs(_G.LoopFling.targetNames) do
        local targetPlayer = Players:FindFirstChild(targetName)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if not _G.LoopFling.lastPosition and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                _G.LoopFling.lastPosition = LocalPlayer.Character.HumanoidRootPart.CFrame
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = LocalPlayer.Character.HumanoidRootPart
        if rootPart.Position.Y < -100 then
            _G.LoopFling.playerIsInVoid = true
            if _G.LoopFling.lastPosition then
                teleportTo(_G.LoopFling.lastPosition)
            end
        else
            _G.LoopFling.playerIsInVoid = false
        end
    end
end)

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("MyScriptHub")
SaveManager:SetFolder("MyScriptHub/specific-game")
SaveManager:SetSubFolder("specific-place")
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()

Library:OnUnload(function()
    _G.LoopFling.loopActive = false
    print("Unloaded!")
end)