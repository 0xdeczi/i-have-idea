--rename by ai ((( 
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")
local Debris = game:GetService("Debris")

local teleportDistance = 5
local blackHoleSoundId = 17422207457
local orbitRadius = 23
local orbitSpeed = 25
local loopkillDelay = 0.5
local TimeElapsed = 0
local Intensity = 0

local adminList = {
    ["26Angelcookie26"] = true,
    ["hahshsin"] = true,
    ["76rgoyf"] = true,
    ["ggerrtasalt"] = true,
    ["Lokick07"] = true,
    ["Xx_sabrina726"] = true,
    ["lpina25"] = true,
    ["realsticsoccerowner"] = true,
    ["Blizz_T"] = true,
    ["Reset32937132"] = true,
    ["starronyxx"] = true,
    ["UNDEBOLT"] = true,
    ["moonyrblxx"] = true,
    ["M0onR3b0rn"] = true
}

local cameraShakeId = "rbxassetid://89898199435154"
local screenGui = Instance.new("ScreenGui")
screenGui.DisplayOrder = 12
screenGui.Parent = game.CoreGui
screenGui.IgnoreGuiInset = false

local overlayFrame = Instance.new("Frame")
overlayFrame.Size = UDim2.new(1, 0, 1, 0)
overlayFrame.Position = UDim2.new(0, 0, 0, 0)
overlayFrame.BackgroundColor3 = Color3.new(0, 0, 0)
overlayFrame.BackgroundTransparency = 1
overlayFrame.Parent = screenGui

local loopkillTargets = {}
local blackholeTargets = {}
local blackholeParts = {}
local blackholeAngles = {}
local spamConnections = {}
local chatSpamConnections = {}
local crashThread = nil
local colorCycleThread = nil
local colorArray = {}
local colorIndex = 1
local isSpamming = false
local isChatSpamming = false
local spamThread = nil
local blackholeSoundId2 = "rbxassetid://8046889679"
local objectSpamThread = nil
local isObjectSpamming = false
local soundSpamThread = nil
local isSoundSpamming = false
local loopkillThreads = {}
local blackholeThreads = {}

local function checkAdmin(player)
    if adminList[player.Name] then
        return true
    end
    return false
end

local function freezePlayer(player)
    if player.Character then
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Anchored = true
        end
    end
end

local function unfreezePlayer(player)
    if player.Character then
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Anchored = false
        end
    end
end

local function startLoopkill(player)
    if loopkillTargets[player.Name] then
        return
    end
    loopkillTargets[player.Name] = true
    local thread = coroutine.create(function()
        while loopkillTargets[player.Name] do
            if player.Character then
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.Health = 0
                end
            end
            wait(loopkillDelay)
        end
    end)
    loopkillThreads[player.Name] = thread
    coroutine.resume(thread)
end

local function stopLoopkill(player)
    if loopkillTargets[player.Name] then
        loopkillTargets[player.Name] = nil
        if loopkillThreads[player.Name] then
            local status = coroutine.status(loopkillThreads[player.Name])
            if status ~= "dead" then
                coroutine.close(loopkillThreads[player.Name])
            end
            loopkillThreads[player.Name] = nil
        end
    end
end

local function killPlayer(player)
    if player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.Health = 0
        end
    end
end

local function isSelf(player, targetPlayer)
    if player.Name == targetPlayer.Name then
        return true
    end
    return false
end

local function startCrash()
    pcall(function()
        crashThread = coroutine.create(function()
            while true do
            end
        end)
        coroutine.resume(crashThread)
    end)
end

local function stopCrash()
    if crashThread then
        local status = coroutine.status(crashThread)
        if status ~= "dead" then
            coroutine.close(crashThread)
        end
        crashThread = nil
    end
end

local function startSpam()
    if isSpamming then
        return
    end
    isSpamming = true
    spamThread = coroutine.create(function()
        while isSpamming do
            for _, player in pairs(Players:GetPlayers()) do
                if adminList[player.Name] then
                    player:Kick("You have been kicked by Owner/Admin player.")
                end
            end
            wait()
        end
    end)
    coroutine.resume(spamThread)
end

local function stopSpam()
    isSpamming = false
    if spamThread then
        local status = coroutine.status(spamThread)
        if status ~= "dead" then
            coroutine.close(spamThread)
        end
        spamThread = nil
    end
end

local function startObjectSpam()
    if isObjectSpamming then
        return
    end
    isObjectSpamming = true
    objectSpamThread = coroutine.create(function()
        while isObjectSpamming do
            for _, obj in pairs(workspace:GetChildren()) do
                if obj:IsA("BasePart") then
                    local part = Instance.new("Part")
                    part.Size = Vector3.new(2, 2, 2)
                    part.Position = obj.Position + Vector3.new(math.random(-5, 5), math.random(-5, 5), math.random(-5, 5))
                    part.Anchored = true
                    part.BrickColor = BrickColor.random()
                    part.Material = Enum.Material.Neon
                    part.Parent = workspace
                    Debris:AddItem(part, 5)
                end
            end
            wait()
        end
    end)
    coroutine.resume(objectSpamThread)
end

local function stopObjectSpam()
    isObjectSpamming = false
    if objectSpamThread then
        local status = coroutine.status(objectSpamThread)
        if status ~= "dead" then
            coroutine.close(objectSpamThread)
        end
        objectSpamThread = nil
    end
end

local function startChatSpam(message, sender)
    if isChatSpamming then
        return
    end
    isChatSpamming = true
    local thread = coroutine.create(function()
        while isChatSpamming do
            sendMessage(message, sender)
            wait(0.5)
        end
    end)
    table.insert(chatSpamConnections, thread)
    coroutine.resume(thread)
end

local function stopChatSpam()
    isChatSpamming = false
    for i, thread in ipairs(chatSpamConnections) do
        local status = coroutine.status(thread)
        if status ~= "dead" then
            coroutine.close(thread)
        end
    end
    chatSpamConnections = {}
end

local function startSoundSpam()
    if isSoundSpamming then
        return
    end
    isSoundSpamming = true
    soundSpamThread = coroutine.create(function()
        while isSoundSpamming do
            for _, player in ipairs(Players:GetPlayers()) do
                local targetName = player.Name
                if adminList[targetName] then
                    if player.Character then
                        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            for i = 1, 10 do
                                local sound = Instance.new("Sound")
                                sound.SoundId = "rbxassetid://" .. blackHoleSoundId
                                sound.Looped = true
                                sound.Pitch = math.random(200, 200) / 200
                                sound.Volume = 22
                                sound.Parent = hrp
                                sound:Play()
                                table.insert(blackholeParts, sound)
                            end
                        end
                    end
                end
            end
            wait(4)
        end
    end)
    coroutine.resume(soundSpamThread)
end

local function stopSoundSpam()
    isSoundSpamming = false
    for _, sound in ipairs(blackholeParts) do
        if sound and sound.Parent then
            sound:Stop()
            sound:Destroy()
        end
    end
    blackholeParts = {}
    if soundSpamThread then
        local status = coroutine.status(soundSpamThread)
        if status ~= "dead" then
            coroutine.close(soundSpamThread)
        end
        soundSpamThread = nil
    end
end

local function fadeOverlay()
    overlayFrame.BackgroundTransparency = 0
    local tween = TweenService:Create(overlayFrame, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 1
    })
    tween:Play()
    tween.Completed:Connect(function()
        tween:Destroy()
    end)
end

local function createColorArray()
    local colors = {
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(255, 165, 0),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(75, 0, 130),
        Color3.fromRGB(238, 130, 238)
    }
    colorArray = colors
    colorIndex = 1
end

local function cycleColors()
    if #colorArray == 0 then
        return
    end
    local currentColor = colorArray[colorIndex]
    colorIndex = colorIndex % #colorArray
    colorIndex = colorIndex + 1
    local tween = TweenService:Create(Lighting, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {
        Color = currentColor
    })
    tween:Play()
    tween.Completed:Connect(function()
        tween:Destroy()
    end)
end

local function playBlackholeSound()
    local character = Players.LocalPlayer.Character
    if character then
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://" .. blackHoleSoundId
            sound.Parent = hrp
            sound:Play()
            task.spawn(function()
                while sound and sound.Parent do
                    task.wait(0.01)
                    if not sound.IsPlaying then
                        sound.Parent = workspace
                        sound.Pitch = 1
                        sound.TimePosition = 0
                        sound:Play()
                        local timeLeft = sound.TimeLength - 0.01
                        task.wait(timeLeft)
                    end
                end
            end)
        end
    end
end

local function startBlackhole(player)
    if blackholeTargets[player.Name] then
        return
    end
    blackholeTargets[player.Name] = true
    blackholeAngles[player.Name] = 0
    blackholeParts[player.Name] = nil
    
    local thread = coroutine.create(function()
        while blackholeTargets[player.Name] do
            if player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local angle = blackholeAngles[player.Name]
                    angle = angle + orbitSpeed * RunService.Heartbeat:Wait()
                    blackholeAngles[player.Name] = angle
                    
                    local offset = Vector3.new(
                        math.cos(angle) * orbitRadius,
                        0,
                        math.sin(angle) * orbitRadius
                    )
                    hrp.Position = hrp.Position + offset
                    
                    for _, otherPlayer in pairs(Players:GetPlayers()) do
                        if adminList[otherPlayer.Name] then
                            if otherPlayer.Character then
                                local otherHrp = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                                if otherHrp then
                                    local distance = (otherHrp.Position - hrp.Position).Magnitude
                                    if distance < 100 then
                                        local bodyPos = Instance.new("BodyPosition")
                                        bodyPos.MaxForce = Vector3.new(1000000000, 1000000000, 1000000000)
                                        bodyPos.Position = hrp.Position
                                        bodyPos.Parent = otherHrp
                                        task.wait(0.5)
                                        bodyPos:Destroy()
                                    end
                                end
                            end
                        end
                    end
                end
            end
            task.wait()
        end
    end)
    blackholeThreads[player.Name] = thread
    coroutine.resume(thread)
end

local function stopBlackhole(player)
    if blackholeTargets[player.Name] then
        blackholeTargets[player.Name] = nil
        blackholeAngles[player.Name] = nil
        if blackholeThreads[player.Name] then
            local status = coroutine.status(blackholeThreads[player.Name])
            if status ~= "dead" then
                coroutine.close(blackholeThreads[player.Name])
            end
            blackholeThreads[player.Name] = nil
        end
        for _, sound in pairs(SoundService:GetChildren()) do
            if sound:IsA("Sound") then
                if sound.SoundId == "rbxassetid://" .. blackHoleSoundId then
                    sound:Stop()
                    sound:Destroy()
                end
            end
        end
    end
end

local function startVisualCrash()
    local localPlayerName = Players.LocalPlayer.Name
    if adminList[localPlayerName] then
        local msg = Instance.new("Message")
        msg.Parent = workspace
        msg.Text = "START RUNNING"
        task.delay(5, function()
            msg:Destroy()
        end)
        
        local colorCorrection = Instance.new("ColorCorrectionEffect")
        colorCorrection.Parent = Lighting
        colorCorrection.Saturation = -500000000
        colorCorrection.Contrast = 50000
        colorCorrection.Brightness = 25000
        
        Lighting.TimeOfDay = "00:00:00"
        
        local blur = Instance.new("BlurEffect")
        blur.Parent = Lighting
        blur.Size = 1
        
        Intensity = 0.03
        
        createColorArray()
        
        task.spawn(function()
            while true do
                task.wait(0.5)
                if colorArray and #colorArray > 0 then
                    Lighting.Color = colorArray[colorIndex]
                    colorIndex = colorIndex % #colorArray
                    colorIndex = colorIndex + 1
                end
            end
        end)
        
        task.delay(30, function()
            stopVisualCrash()
        end)
        
        task.spawn(function()
            playBlackholeSound()
        end)
    end
end

local function stopVisualCrash()
    Intensity = 0
    if crashThread then
        local status = coroutine.status(crashThread)
        if status ~= "dead" then
            coroutine.close(crashThread)
        end
        crashThread = nil
    end
    if colorCycleThread then
        local status = coroutine.status(colorCycleThread)
        if status ~= "dead" then
            coroutine.close(colorCycleThread)
        end
        colorCycleThread = nil
    end
    Lighting.TimeOfDay = "12:00:00"
    for _, effect in ipairs(Lighting:GetChildren()) do
        if effect:IsA("ColorCorrectionEffect") or effect:IsA("BlurEffect") then
            effect:Destroy()
        end
    end
    for _, sound in ipairs(SoundService:GetChildren()) do
        if sound:IsA("Sound") then
            if sound.SoundId == "rbxassetid://" .. blackHoleSoundId then
                sound:Stop()
                sound:Destroy()
            end
        end
    end
    fadeOverlay()
end

local function sendMessage(message, sender)
    local textMessage = tostring(message)
    if sender then
        if sender.Character then
            local chatVersion = TextChatService.ChatVersion
            if chatVersion == Enum.ChatVersion.LegacyChatService then
                local chatGui = sender.PlayerGui:FindFirstChild("ChatGui")
                if chatGui then
                    for _, channel in ipairs(TextChatService:GetChildren()) do
                        if channel.Name == "RBXSystem" or channel.Name == "RBXGeneral" then
                            TextChatService:DisplaySystemMessage(textMessage)
                        end
                    end
                end
            end
            local sayMessage = ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest
            sayMessage:FireServer(textMessage, "All")
        end
    end
end

local function bringPlayer(targetPlayer, sender)
    if sender.Character and targetPlayer.Character then
        local senderHrp = sender.Character:FindFirstChild("HumanoidRootPart")
        local targetHrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if senderHrp and targetHrp then
            targetHrp.CFrame = senderHrp.CFrame * CFrame.new(0, 0, teleportDistance)
        end
    end
end

local function handleCommand(player, message)
    if not adminList[player.Name] then
        return
    end
    
    local args = string.split(message, " ")
    local command = args[1]
    
    if command == "!crash" then
        print("!crash command executed by: " .. player.Name)
        startVisualCrash()
    elseif command == "!say" then
        local msg = table.concat(args, " ", 2)
        print("!say command executed by: " .. player.Name .. ", Message: " .. msg)
        sendMessage(msg, player)
    elseif command == "!kill" then
        print("!kill command executed by: " .. player.Name)
        killPlayer(player)
    elseif command == "!s" then
        print("!s command executed by: " .. player.Name)
        startCrash()
    elseif command == "!uns" then
        print("!uns command executed by: " .. player.Name)
        stopCrash()
    elseif command == "!objects" then
        print("!objects command executed by: " .. player.Name)
        startObjectSpam()
    elseif command == "!spam all" then
        print("!spam all command executed by: " .. player.Name)
        startSpam()
    elseif command == "!unspam all" then
        print("!unspam all command executed by: " .. player.Name)
        stopSpam()
    elseif command == "!kick all" then
        print("!kick all command executed by: " .. player.Name)
        for _, targetPlayer in ipairs(Players:GetPlayers()) do
            if adminList[targetPlayer.Name] then
                targetPlayer:Kick("You have been kicked by Owner/Admin player.")
            end
        end
    elseif command == "!loopkill all" then
        print("!loopkill all command executed by: " .. player.Name)
        for _, targetPlayer in ipairs(Players:GetPlayers()) do
            if adminList[targetPlayer.Name] then
                startLoopkill(targetPlayer)
            end
        end
    elseif command == "!unloopkill all" then
        print("!unloopkill all command executed by: " .. player.Name)
        for _, targetPlayer in ipairs(Players:GetPlayers()) do
            if adminList[targetPlayer.Name] then
                stopLoopkill(targetPlayer)
            end
        end
    elseif command == "!blackhole all" then
        print("!blackhole all command executed by: " .. player.Name)
        for _, targetPlayer in ipairs(Players:GetPlayers()) do
            if adminList[targetPlayer.Name] then
                startBlackhole(targetPlayer)
            end
        end
    elseif command == "!unblackhole all" then
        print("!unblackhole all command executed by: " .. player.Name)
        for _, targetPlayer in ipairs(Players:GetPlayers()) do
            if adminList[targetPlayer.Name] then
                stopBlackhole(targetPlayer)
            end
        end
    elseif string.match(message, "^!bring all") then
        print("!bring all command executed by: " .. player.Name)
        for _, targetPlayer in pairs(Players:GetPlayers()) do
            if not isSelf(player, targetPlayer) then
                bringPlayer(targetPlayer, player)
            end
        end
    elseif command == "!freeze all" then
        print("!freeze all command executed by: " .. player.Name)
        for _, targetPlayer in pairs(Players:GetPlayers()) do
            if adminList[targetPlayer.Name] then
                freezePlayer(targetPlayer)
            end
        end
    elseif command == "!unfreeze all" then
        print("!unfreeze all command executed by: " .. player.Name)
        for _, targetPlayer in pairs(Players:GetPlayers()) do
            if adminList[targetPlayer.Name] then
                unfreezePlayer(targetPlayer)
            end
        end
    elseif command == "!kill all" then
        print("!kill all command executed by: " .. player.Name)
        for _, targetPlayer in pairs(Players:GetPlayers()) do
            if adminList[targetPlayer.Name] then
                killPlayer(targetPlayer)
            end
        end
    elseif string.sub(message, 1, 9) == "!chat all " then
        local msg = string.sub(message, 10)
        print("!chat all command executed by: " .. player.Name .. ", Message: " .. msg)
        if msg and msg ~= "" then
            startChatSpam(msg, player)
        end
    end
end

local function onPlayerChatted(player, message)
    handleCommand(player, message)
end

local function onPlayerAdded(player)
    player.Chatted:Connect(function(message)
        onPlayerChatted(player, message)
    end)
end

Players.PlayerAdded:Connect(onPlayerAdded)

for _, player in ipairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end
