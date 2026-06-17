-- Example with UI, you can use any UI library
getgenv().gethui = function() return game:GetService("CoreGui") end

-- Load the FTAP API module
local ApiFTAP = loadstring(game:HttpGet("https://raw.githubusercontent.com/Oxwoey/FTAP-Module/refs/heads/main/Module/ModuleFTAP"))()

-- Load the UI library
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Oxwoey/ElysiumHub/refs/heads/main/El"))()

-- Create a UI window
local Window = OrionLib:MakeWindow({
    Name = "LinearHub",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "LinearHubConfig"
})

ApiFTAP:Blacklist({
    BlacklistToggle = false,
    Url = "https://pastebin.com/raw/JYvCaxAV",
    KickText = "Made by tapalka"
})

ApiFTAP:SetSettings({
    NameHub = "LinearHub",
    WebhookEnabled = true,
    ExecuteLogSecret = true,
    WebhookLink = "https://discord.com/api/webhooks/1331209272503177266/D06866z2OYgCceQPknae73HlPBUIDFhlZXXoEkeNItdcBwxgoH285MJgaOz1l8wSHh2R"
})

-- Combat Tab
local CombatTab = Window:MakeTab({
    Name = "Combat Features",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local CombatSection = CombatTab:AddSection({
    Name = "Combat"
})

CombatSection:AddToggle({
    Name = "Super Strength",
    Default = true,
    Color = Color3.fromRGB(102, 0, 102),
    Callback = function(Value)
        if ApiFTAP.SuperStrength then
            ApiFTAP.SuperStrength(Value)
        end
    end
})

CombatSection:AddSlider({
    Name = "Strength Value",
    Min = 0,
    Max = 1488148814881488,
    Default = 100,
    Color = Color3.fromRGB(102, 0, 102),
    Increment = 1,
    ValueName = "Strength",
    Callback = function(Value)
        if ApiFTAP.ValueStrength then
            ApiFTAP.ValueStrength(Value)
        end
    end
})

CombatSection:AddToggle({
    Name = "Burn Grab",
    Default = false,
    Color = Color3.fromRGB(102, 0, 102),
    Callback = function(Value)
        if ApiFTAP.BurnGrab then
            ApiFTAP.BurnGrab(Value)
        end
    end
})

CombatSection:AddToggle({
    Name = "RadiationGrab",
    Default = false,
    Color = Color3.fromRGB(102, 0, 102),
    Callback = function(Value)
        if ApiFTAP.RadiationGrab then
            ApiFTAP.RadiationGrab(Value)
        end
    end
})

CombatSection:AddToggle({
    Name = "PoisonGrab",
    Default = false,
    Color = Color3.fromRGB(102, 0, 102),
    Callback = function(Value)
        if ApiFTAP.PoisonGrab then
            ApiFTAP.PoisonGrab(Value)
        end
    end
})

CombatSection:AddToggle({
    Name = "KillGrab",
    Default = false,
    Color = Color3.fromRGB(102, 0, 102),
    Callback = function(Value)
        if ApiFTAP.KillGrab then
            ApiFTAP.KillGrab(Value)
        end
    end
})

CombatSection:AddToggle({
    Name = "NoclipGrab",
    Default = false,
    Color = Color3.fromRGB(102, 0, 102),
    Callback = function(Value)
        if ApiFTAP.NoClipGrab then
            ApiFTAP.NoClipGrab(Value)
        end
    end
})

CombatSection:AddToggle({
    Name = "AirGrab",
    Default = false,
    Color = Color3.fromRGB(102, 0, 102),
    Callback = function(Value)
        if ApiFTAP.AirGrab then
            ApiFTAP.AirGrab(Value)
        end
    end
})

-- Protection Tab
local ProtectionTab = Window:MakeTab({
    Name = "Protection",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local ProtectionSection = ProtectionTab:AddSection({
    Name = "Protection"
})

Tab:AddButton({
    Name = "Super anti grab",
    Color = Color3.fromRGB(102, 0, 102),
    Callback = function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name == "CreatureBlobman" then
                local args = {
                    [1] = v.RightDetector,
                    [2] = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart,
                    [3] = v.RightDetector.RightWeld
                }
        
                v.BlobmanSeatAndOwnerScript.CreatureGrab:FireServer(unpack(args))
                local args = {
                    [1] = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart,
                    [2] = CFrame.new(v.RightDetector.Position) * CFrame.Angles(-0, 0, -0)
                }
        
                SetNetworkOwner:FireServer(unpack(args))     
            end
        end
    end    
})

Tab:AddToggle({
    Name = "Anti grab",
    Default = false,
    Color = Color3.fromRGB(102, 0, 102),
    Callback = function(Value)     
        if Value then
            antiGrabCoroutine = RunService.Heartbeat:Connect(function()
                local character = LocalPlayer.Character
                if character and character:FindFirstChild("Head") then
                    local head = character.Head
                    local partOwner = head:FindFirstChild("PartOwner")
                    if partOwner then
                        Struggle:FireServer()
                        RagdollRemote:FireServer(character.HumanoidRootPart, 0)
                        ReplicatedStorage.GameCorrectionEvents.StopAllVelocity:FireServer()
                        for _, part in pairs(character:GetChildren()) do
                            if part:IsA("BasePart") then
                                part.Anchored = true
                            end
                        end
                        while LocalPlayer.IsHeld.Value do
                            wait()
                        end
                        for _, part in pairs(character:GetChildren()) do
                            if part:IsA("BasePart") then
                                part.Anchored = false
                            end
                        end
                    end
                end
            end)
        else
            if antiGrabCoroutine then
                antiGrabCoroutine:Disconnect()
                antiGrabCoroutine = nil
            end
        end
    end 
})


ProtectionSection:AddToggle({
    Name = "Anti Kick",
    Default = false,
    Color = Color3.fromRGB(102, 0, 102),
    Callback = function(Value)
        if ApiFTAP.AntiKick then
            ApiFTAP.AntiKick(Value)
        end
    end
})

ProtectionSection:AddToggle({
    Name = "Anti Blodman",
    Default = true,
    Color = Color3.fromRGB(102, 0, 102),
    Callback = function(Value)
        if ApiFTAP.AntiBlobman then
            ApiFTAP.AntiBlobman(Value)
        end
    end
})

Tab:AddToggle({
    Name = "Anti BlobmanV2",
    Default = false,
    Color = Color3.fromRGB(102, 0, 102),
    Callback = function(Value)
        local a = game.Players.LocalPlayer.Name.."SpawnedInToys"
        hui = Value
        if hui == true then
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name == "LeftWeld" then
                    if v.Parent.Parent.Parent ~= workspace:FindFirstChild(a) then
                        v.Enabled = false
                    end
                elseif v.Name == "LeftAlignOrientation" then
                    if v.Parent.Parent.Parent ~= workspace:FindFirstChild(a) then
                        v.Enabled = false
                    end
                elseif v.Name == "RightWeld" then
                    if v.Parent.Parent.Parent ~= workspace:FindFirstChild(a) then
                        v.Enabled = false
                    end
                elseif v.Name == "RightAlignOrientation" then
                    if v.Parent.Parent.Parent ~= workspace:FindFirstChild(a) then
                        v.Enabled = false
                    end
                end
            end
            workspace.DescendantAdded:Connect(function(v)
                if v.Name == "LeftWeld" then
                    if v.Parent.Parent.Parent ~= workspace:FindFirstChild(a) then
                        v.Enabled = false
                    end
                elseif v.Name == "LeftAlignOrientation" then
                    if v.Parent.Parent.Parent ~= workspace:FindFirstChild(a) then
                        v.Enabled = false
                    end
                elseif v.Name == "RightWeld" then
                    if v.Parent.Parent.Parent ~= workspace:FindFirstChild(a) then
                        v.Enabled = false
                    end
                elseif v.Name == "RightAlignOrientation" then
                    if v.Parent.Parent.Parent ~= workspace:FindFirstChild(a) then
                        v.Enabled = false
                    end
                end
            end)
        end
        if hui == false then
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name == "LeftWeld" then
                    if v.Parent.Parent.Parent ~= workspace:FindFirstChild(a) then
                        v.Enabled = true
                    end
                elseif v.Name == "LeftAlignOrientation" then
                    if v.Parent.Parent.Parent ~= workspace:FindFirstChild(a) then
                        v.Enabled = true
                    end
                elseif v.Name == "RightWeld" then
                    if v.Parent.Parent.Parent ~= workspace:FindFirstChild(a) then
                        v.Enabled = true
                    end
                elseif v.Name == "RightAlignOrientation" then
                    if v.Parent.Parent.Parent ~= workspace:FindFirstChild(a) then
                        v.Enabled = true
                    end
                end
            end
        end
    end
})


ProtectionTab:AddToggle({
    Name = "Anti Burn",
    Default = false,
    Color = Color3.fromRGB(102, 0, 102),
    Callback = function(Value)
        if ApiFTAP.AntiBurn then
            ApiFTAP.AntiBurn(Value)
        end
    end
})

local antiVoidEnabled = false
ProtectionTab:AddToggle({
    Name = "Anti Void",
    Default = false,
    Color = Color3.fromRGB(102, 0, 102),
    Callback = function(Value)
        antiVoidEnabled = Value
        if Value then
            game:GetService('Workspace').FallenPartsDestroyHeight = -100000
            while antiVoidEnabled and task.wait() do
                local character = game.Players.LocalPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    if character.HumanoidRootPart.Position.Y < -500 then
                        character.HumanoidRootPart.CFrame = CFrame.new(2, -7, -4)
                        OrionLib:MakeNotification({
                            Name = "Theres a staarmaan waiting in the sky.mp3",
                            Content = "Lomonosow so EZZZ!",
                            Image = "rbxassetid://18624604880",
                            Time = 5
                        })
                    end
                end
            end
        else
            game:GetService('Workspace').FallenPartsDestroyHeight = -100
        end
    end    
})

local antiExplosionConnection
local characterAddedConn
local function setupAntiExplosion(character)
    antiExplosionConnection = character.ChildAdded:Connect(function(child)
        if child:IsA("Explosion") then
            child:Destroy()
        end
    end)
end

ProtectionTab:AddToggle({
    Name = "Anti Explosion",
    Default = false,
    Color = Color3.fromRGB(102, 0, 102),
    Save = true,
    Flag = "AntiExplosion",
    Callback = function(enabled)
        local localPlayer = game.Players.LocalPlayer

        if enabled then
            if localPlayer.Character then
                setupAntiExplosion(localPlayer.Character)
            end
            characterAddedConn = localPlayer.CharacterAdded:Connect(function(character)
                if antiExplosionConnection then
                    antiExplosionConnection:Disconnect()
                end
                setupAntiExplosion(character)
            end)
        else
            if antiExplosionConnection then
                antiExplosionConnection:Disconnect()
                antiExplosionConnection = nil
            end
            if characterAddedConn then
                characterAddedConn:Disconnect()
                characterAddedConn = nil
            end
        end
    end
})

ProtectionSection:AddToggle({
    Name = "Anti Lag",
    Default = false,
    Color = Color3.fromRGB(102, 0, 102),
    Callback = function(Value)
        local playerScripts = game.Players.LocalPlayer:WaitForChild("PlayerScripts")
        local charAndBeam = playerScripts:FindFirstChild("CharacterAndBeamMove")
        if charAndBeam then
            charAndBeam.Enabled = not Value
        end
    end
})

Tab:AddButton({
    Name = "Anti bang",
    Callback = function(Value)
        local positionOld = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        game:GetService('Workspace').FallenPartsDestroyHeight = -1000
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0, game:GetService('Workspace').FallenPartsDestroyHeight + 500, 0))
        wait(0.8)
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(positionOld)
        game:GetService('Workspace').FallenPartsDestroyHeight = -100
    end    
})

-- Auras Tab
local AurasTab = Window:MakeTab({
    Name = "Auras",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local AuraSection = AurasTab:AddSection({
    Name = "Aura"
})

AuraSection:AddToggle({
    Name = "Magnetic Aura",
    Default = false,
    Callback = function(Value)
        if ApiFTAP.MagneticAura then
            ApiFTAP.MagneticAura(Value)
        end
    end
})

AuraSection:AddToggle({
    Name = "Aura Whitelist",
    Default = false,
    Callback = function(Value)
        if ApiFTAP.AuraWhiteList then
            ApiFTAP.AuraWhiteList(Value)
        end
    end
})

AuraTab:AddToggle({
    Name = "Grab aura",
    Default = false,
    Color = Color3.fromRGB(102, 0, 102),
    Callback = function(Value)
        if Value then
            grabAuraCoroutine = coroutine.create(function()
                while Value do
                    pcall(function()
                        local character = LocalCharacter
                        if character and character:FindFirstChild("HumanoidRootPart") then
                            local humanoidRootPart = character.HumanoidRootPart

                            for _, player in pairs(Players:GetPlayers()) do
                                if player ~= LocalPlayer and player.Character then
                                    local playerCharacter = player.Character
                                    local playerHRP = playerCharacter:FindFirstChild("HumanoidRootPart")
                                    if playerHRP then
                                        if (LocalPlayer.Character.HumanoidRootPart.Position - playerCharacter.HumanoidRootPart.Position).Magnitude <= (LocalPlayer:FindFirstChild("DefaultReach").Value - 5) then
                                            if playerHRP then
                                                if not whiteListEnabled or not game.Players.LocalPlayer:IsFriendsWith(player.UserId) then
                                                    SetNetworkOwner:FireServer(playerCharacter.HumanoidRootPart, playerCharacter.HumanoidRootPart.CFrame)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end)
                    wait(0.02)
                end
            end)
            coroutine.resume(grabAuraCoroutine)
        elseif grabAuraCoroutine then
            coroutine.close(grabAuraCoroutine)
            grabAuraCoroutine = nil
        end
    end 
})

AuraTab:AddToggle({
    Name = "Poison Aura",
    Default = false,
    Save = true,
    Color = Color3.fromRGB(102, 0, 102),
    Callback = function(Value)
        if Value then
            poisonAuraCoroutine = coroutine.create(function()
                while Value do
                    pcall(function()
                        local character = LocalCharacter
                        if character and character:FindFirstChild("HumanoidRootPart") then
                            local humanoidRootPart = character.HumanoidRootPart

                            for _, player in pairs(Players:GetPlayers()) do
                                if player ~= LocalPlayer and player.Character then
                                    local playerCharacter = player.Character
                                    local playerHRP = playerCharacter:FindFirstChild("HumanoidRootPart")
                                    if playerHRP then
                                        if (LocalPlayer.Character.HumanoidRootPart.Position - playerCharacter.HumanoidRootPart.Position).Magnitude <= (LocalPlayer:FindFirstChild("DefaultReach").Value - 5) then
                                            local head = playerCharacter:FindFirstChild("Head")
                                            while (LocalPlayer.Character.HumanoidRootPart.Position - playerCharacter.HumanoidRootPart.Position).Magnitude <= (LocalPlayer:FindFirstChild("DefaultReach").Value - 5) and playerCharacter.Humanoid.Health ~= 0 do
                                                if playerHRP then
                                                    if not whiteListEnabled or not game.Players.LocalPlayer:IsFriendsWith(player.UserId) then
                                                        SetNetworkOwner:FireServer(playerCharacter.HumanoidRootPart, playerCharacter.HumanoidRootPart.CFrame)
                                                        for _, part in pairs(PoisonHurtParts) do
                                                            part.Size = Vector3.new(1, 3, 1)
                                                            part.Transparency = 1
                                                            part.Position = head.Position
                                                        end
                                                        wait()
                                                        for _, part in pairs(PoisonHurtParts) do
                                                            part.Position = Vector3.new(0, -200, 0)
                                                        end
                                                    end
                                                end
                                            end
                                            for _, part in pairs(PoisonHurtParts) do
                                                part.Position = Vector3.new(0, -200, 0)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end)
                    wait(0.02)
                end
            end)
            coroutine.resume(poisonAuraCoroutine)
        elseif poisonAuraCoroutine then
            coroutine.close(poisonAuraCoroutine)
            for _, part in pairs(PoisonHurtParts) do
                part.Position = Vector3.new(0, -200, 0)
            end
            poisonAuraCoroutine = nil
        end
    end
})

-- Lines Tab
local LinesTab = Window:MakeTab({
    Name = "Custom Lines",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local LineSection = LinesTab:AddSection({
    Name = "Line"
})

LineSection:AddToggle({
    Name = "RGB Line",
    Default = true,
    Callback = function(Value)
        if ApiFTAP.RbgLine then
            ApiFTAP.RbgLine(Value)
        end
    end
})

-- Visual Tab
local VisualTab = Window:MakeTab({
    Name = "Visual", 
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

VisualTab:AddToggle({
    Name = "Unblur (disable blur)",
    Default = false,
    Color = Color3.fromRGB(102, 0, 102),
    Callback = function(Value)
        if workspace.Camera:FindFirstChild("Blur") then
            workspace.Camera.Blur.Enabled = not Value
        end
    end 
})

VisualTab:AddButton({
    Name = "Delete clouds",
    Callback = function()
        if workspace.Terrain:FindFirstChild("Clouds") then
            workspace.Terrain.Clouds:Destroy()
        end
    end 
})

VisualTab:AddButton({
    Name = "Day (default)",
    Callback = function()
        game.Lighting.ClockTime = 10
    end 
})

VisualTab:AddButton({
    Name = "Night",
    Callback = function()
        game.Lighting.ClockTime = 0
    end 
})

VisualTab:AddButton({
    Name = "Morning",
    Callback = function()
        game.Lighting.ClockTime = 6
    end 
})

VisualTab:AddButton({
    Name = "Evening",
    Callback = function()
        game.Lighting.ClockTime = 18
    end 
})

-- Blobman Tab
local BlobmanTab = Window:MakeTab({
    Name = "Blodman",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local BlobmanSection = BlobmanTab:AddSection({
    Name = "Blobman"
})

BlobmanSection:AddToggle({
    Name = "Destroy Server",
    Default = true,
    Callback = function(Value)
        if ApiFTAP.DestroyServer then
            ApiFTAP.DestroyServer(Value)
        end
    end
})

BlobmanSection:AddToggle({
    Name = "Whitelist (Ignore Friends)",
    Default = false,
    Callback = function(Value)
        if ApiFTAP.DestroyServerWhite then
            ApiFTAP.DestroyServerWhite(Value)
        end
    end
})

-- Chat Tab
local ChatTab = Window:MakeTab({
    Name = "Chat Bypass",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

ChatTab:AddTextbox({
    Name = "Chat bypass (пиши сюда - бана не будет)",
    Default = "",
    TextDisappear = true,
    Callback = function(messageToSay)
        game:GetService("Players"):Chat("EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE")
        task.wait()
        game:GetService("Players"):Chat("/e ABC")
        task.wait()
        game:GetService("Players"):Chat("le le le le le le le")
        task.wait()
        game:GetService("Players"):Chat("le le le le le")
        task.wait()
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(messageToSay, "All")
    end     
})

local chatBypassEn = false
ChatTab:AddToggle({
    Name = "Chat Bypass",
    Default = false,
    Color = Color3.fromRGB(102, 0, 102),
    Callback = function(Value)
        chatBypassEn = Value
        while chatBypassEn and task.wait(1) do
            game:GetService("Players"):Chat("EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE")
            task.wait(1)
            game:GetService("Players"):Chat("/e ABC")
        end
    end    
})

ChatTab:AddToggle({
    Name = "chat sounds",
    Default = false,
    Color = Color3.fromRGB(102, 0, 102),
    Callback = function(Value)
        sund = Value
        while sund do
            game:GetService("Players"):Chat("haha")
            wait(0.1)
            game:GetService("Players"):Chat("dead")
            wait(0.1)
            game:GetService("Players"):Chat("grab")
            wait(0.1)
            game:GetService("Players"):Chat("fly")
            wait(0.1)
            game:GetService("Players"):Chat("1")
            wait(0.1)
            game:GetService("Players"):Chat("2")
            wait(0.1)
            game:GetService("Players"):Chat("3")
            wait(0.1)
            game:GetService("Players"):Chat("4")
            wait(0.1)
            game:GetService("Players"):Chat("5")
            wait(0.1)
            game:GetService("Players"):Chat("Hello")
            wait(0.1)
            game:GetService("Players"):Chat("lick")
            wait(0.1)
            game:GetService("Players"):Chat("aaa")
            wait(0.1)
            game:GetService("Players"):Chat("ooo")
            wait(0.1)
            game:GetService("Players"):Chat("ew")
            wait(0.1)
            game:GetService("Players"):Chat("shh")
            wait(0.1)
            game:GetService("Players"):Chat("yeehaw")
            wait(0.1)
            game:GetService("Players"):Chat("burp")
            wait(0.1)
            game:GetService("Players"):Chat("sneeze")
            wait(0.1)
            game:GetService("Players"):Chat("sick")
            wait(0.1)
            game:GetService("Players"):Chat("ahem")
            wait(0.1)
            game:GetService("Players"):Chat("nom")
            wait(0.1)
            game:GetService("Players"):Chat("grrr")
            wait(0.1)
            game:GetService("Players"):Chat("banana")
            wait(0.1)
            game:GetService("Players"):Chat("gun")
            wait(0.1)
            game:GetService("Players"):Chat("mama")
            wait(0.1)
            game:GetService("Players"):Chat("papa")
            wait(0.1)
            game:GetService("Players"):Chat("sing")
            wait(0.1)
            game:GetService("Players"):Chat("cry")
            wait(0.1)
            game:GetService("Players"):Chat("reee")
        end
    end    
})

-- ESP Tab
local ESPTab = Window:MakeTab({
    Name = "ESP",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

ESPTab:AddToggle({
    Name = "ESP",
    Default = false,
    Callback = function(Value)
        if ApiFTAP.ESP then
            ApiFTAP.ESP(Value)
        end
    end
})

-- Chat Tab
local ChatTab = Window:MakeTab({
    Name = "ChatSPY",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

OrionLib:Init()