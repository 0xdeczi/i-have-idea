local targetUsername = "JESSETC92BACKUP23"
local alertSoundId = "rbxassetid://2723907903"

game.Players.PlayerAdded:Connect(function(player)
    checkAndApplyEffects(player)
end)

game.Players.PlayerAdded:Connect(function(player)
    onTargetJoined(player)
end)

for _, player in pairs(game.Players:GetPlayers()) do
    checkAndApplyEffects(player)
end

local function onCharacterAdded(character)
    wait(1)
    applyHeadEffect(character.Parent)
end

local function applyHeadEffect(player)
    wait(0.5)
    local character = player.Character
    if not character then return end
    
    local head = character:FindFirstChild("Head")
    if not head then return end
    
    if head:FindFirstChild("OwnerBanner") then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "OwnerBanner"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 200, 0, 200)
    billboard.StudsOffset = Vector3.new(0, 6, 0)
    billboard.Parent = head
    
    local mainImage = Instance.new("ImageLabel")
    mainImage.Size = UDim2.new(1, 0, 1, 0)
    mainImage.BackgroundTransparency = 1
    mainImage.Image = "rbxassetid://125566303407962"
    mainImage.ImageTransparency = 0.3
    mainImage.Parent = billboard
    
    createHaloImage(billboard, "rbxassetid://18919749220", Vector2.new(0, -100), 0.3, 1)
    createHaloImage(billboard, "rbxassetid://18919749220", Vector2.new(-100, 0), 0.4, 1.5)
    createHaloImage(billboard, "rbxassetid://18919749220", Vector2.new(100, 0), 0.35, 2)
    createHaloImage(billboard, "rbxassetid://18919749220", Vector2.new(0, 100), 0.3, 1.7)
    
    local particles = Instance.new("ParticleEmitter")
    particles.Texture = "rbxassetid://6943750897"
    particles.Lifetime = NumberRange.new(1.5, 2)
    particles.Rate = 15
    particles.Speed = NumberRange.new(0.5, 2)
    particles.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(1, 0)
    })
    particles.Rotation = NumberRange.new(0, 360)
    particles.Parent = head
    
    spawn(function()
        while mainImage and mainImage.Parent do
            for hue = 0, 1, 0.005 do
                if not mainImage or not mainImage.Parent then return end
                mainImage.ImageColor3 = Color3.fromHSV(hue, 1, 1)
                wait(0.01)
            end
        end
    end)
end

local function createHaloImage(parent, imageId, offset, transparency, speed)
    local image = Instance.new("ImageLabel")
    image.Size = UDim2.new(0.5, 0, 0.5, 0)
    image.BackgroundTransparency = 1
    image.Image = imageId
    image.ImageTransparency = transparency
    image.Position = UDim2.new(0.5, offset.X, 0.5, offset.Y)
    image.Parent = parent
    
    local rotation = 0
    local rotationSpeed = speed * 100
    
    game:GetService("RunService").RenderStepped:Connect(function()
        rotation = (rotation + rotationSpeed) % 360
        image.Rotation = rotation
    end)
end

local function checkAndApplyEffects(player)
    if player.Name == targetUsername then
        applyHeadEffect(player)
        showOwnerMessage()
    end
end

local function onTargetJoined(player)
    if player.Name == targetUsername then
        player.CharacterAdded:Connect(function(character)
            wait(1)
            applyHeadEffect(player)
            showOwnerMessage()
        end)
    end
end

local function findTargetAndApply()
    local player = game.Players:FindFirstChild(targetUsername)
    if player then
        applyHeadEffect(player)
        showOwnerMessage()
    end
end

local function showOwnerMessage()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MessageGui"
    screenGui.Parent = game.Players.LocalPlayer.PlayerGui
    
    local label = Instance.new("TextLabel")
    label.Name = "MessageLabel"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Text = "The Owner Of Verbal Hub Is In Your Server. Do Not Attempt To Kick The Owner!"
    label.Font = Enum.Font.Code
    label.BackgroundTransparency = 0.5
    label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    label.TextScaled = true
    label.TextWrapped = true
    label.Parent = screenGui
    
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. alertSoundId
    sound.PlaybackSpeed = 0.6
    sound.Looped = true
    sound.Parent = game.Workspace
    sound:Play()
    
    spawn(function()
        while label and label.Parent do
            for hue = 0, 1, 0.005 do
                if not label or not label.Parent then return end
                label.TextColor3 = Color3.fromHSV(hue, 1, 1)
                wait(0.01)
            end
        end
    end)
    
    spawn(function()
        for transparency = 1, 0, -0.01 do
            if not label or not label.Parent then return end
            label.TextTransparency = transparency
            wait(0.02)
        end
        
        local startTime = tick()
        local rotation = 0
        while tick() - startTime < 10 do
            if not label or not label.Parent then return end
            rotation = (rotation + 2) % 360
            label.Rotation = rotation
            wait(0.01)
        end
        
        for transparency = 0, 1, 0.01 do
            if not label or not label.Parent then return end
            label.TextTransparency = transparency
            wait(0.02)
        end
        
        screenGui:Destroy()
        sound:Stop()
        sound:Destroy()
    end)
end
