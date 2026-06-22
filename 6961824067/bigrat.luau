-- https://youtu.be/dQw4w9WgXcQ?si=AYWHp5vvOV25MflT
-- https://youtu.be/dQw4w9WgXcQ?si=AYWHp5vvOV25MflT

local r = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(r .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(r .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(r .. "addons/SaveManager.lua"))()

    local Window = Library:CreateWindow({
        Title = "Big Rat",
        Footer = "Version: 0.0",
        Icon = 102816031861909,
    })

local Credit = Window:AddTab({
    Name = "Credit",
    Description = "Main",
    Icon = "house"
})

local Defence = Window:AddTab({
    Name = "Defence",
    Description = "Defender",
    Icon = "shield"
})

-- https://youtu.be/dQw4w9WgXcQ?si=AYWHp5vvOV25MflT
-- https://youtu.be/dQw4w9WgXcQ?si=AYWHp5vvOV25MflT

local Credit1 = Credit:AddLeftGroupbox("Credit", "book-search")
Credit1:AddLabel("Made By: wftap")
Credit1:AddLabel("Made By: wftap")
Credit1:AddLabel("Made By: wftap")
Credit1:AddLabel("Made By: wftap")
Credit1:AddLabel("Made By: wftap")
Credit1:AddLabel("Made By: wftap")
Credit1:AddLabel("Made By: wftap")
Credit1:AddLabel("Made By: wftap")
Credit1:AddLabel("Made By: wftap")
Credit1:AddLabel("Made By: wftap")
Credit1:AddLabel("Made By: wftap")
Credit1:AddLabel("Made By: wftap")
Credit1:AddLabel("Made By: wftap")
Credit1:AddLabel("Made By: wftap")
Credit1:AddLabel("Made By: wftap")
Credit1:AddLabel("Made By: wftap")
Credit1:AddLabel("Made By: wftap")
Credit1:AddLabel("Made By: wftap")
Credit1:AddLabel("Made By: wftap")
Credit1:AddLabel("Made By: wftap")
Credit1:AddLabel("Made By: wftap")

local Credit2 = Credit:AddRightGroupbox("Credit", "book-search")
Credit2:AddLabel("Made By: locality")
Credit2:AddLabel("Made By: locality")
Credit2:AddLabel("Made By: locality")
Credit2:AddLabel("Made By: locality")
Credit2:AddLabel("Made By: locality")
Credit2:AddLabel("Made By: locality")
Credit2:AddLabel("Made By: locality")
Credit2:AddLabel("Made By: locality")
Credit2:AddLabel("Made By: locality")
Credit2:AddLabel("Made By: locality")
Credit2:AddLabel("Made By: locality")
Credit2:AddLabel("Made By: locality")
Credit2:AddLabel("Made By: locality")
Credit2:AddLabel("Made By: locality")
Credit2:AddLabel("Made By: locality")
Credit2:AddLabel("Made By: locality")
Credit2:AddLabel("Made By: locality")
Credit2:AddLabel("Made By: locality")
Credit2:AddLabel("Made By: locality")
Credit2:AddLabel("Made By: locality")
Credit2:AddLabel("Made By: locality")
Credit2:AddLabel("Made By: locality")
Credit2:AddLabel("Made By: locality")
Credit2:AddLabel("Made By: locality")

-- https://youtu.be/dQw4w9WgXcQ?si=AYWHp5vvOV25MflT
-- https://youtu.be/dQw4w9WgXcQ?si=AYWHp5vvOV25MflT

local Defender = Defence:AddLeftGroupbox("Defenders", "a-large-small")
Defender:AddButton("Loop Kick", function()

    local Camera = workspace.CurrentCamera
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local HRP = Character:WaitForChild("HumanoidRootPart", 2)
    Character.Archivable = true

    local BV = Instance.new("BodyVelocity")
    BV.Velocity = Vector3.new(0, 15, 0)
    BV.Parent = HRP

    HRP.CFrame = CFrame.new(15, 70, 0)

    local Character2 = Character:Clone()
    local HRP2 = Character2.HumanoidRootPart
    Character2.Parent = Character
    LocalPlayer.Character = Character2
    Camera.CameraSubject = Character2.Humanoid
    Camera.CameraType = Enum.CameraType.Scriptable
    Camera.CFrame = CFrame.lookAt(Vector3.new(15, 50, 25), HRP.Position)

    Character2.Humanoid:Destroy()
    HRP2.Anchored = true
    HRP2.CFrame = Camera.CFrame

    while true do task.wait()
        if HRP.Position.Y < 10 then
            HRP.CFrame = CFrame.new(15, 70, 0)
        end
    end

end)

-- https://youtu.be/dQw4w9WgXcQ?si=AYWHp5vvOV25MflT
-- https://youtu.be/dQw4w9WgXcQ?si=AYWHp5vvOV25MflT

Defender:AddButton("Silent Aim", function()
    game:GetService("Players").LocalPlayer:Kick("head up nigga: menaton☠️")
end)
