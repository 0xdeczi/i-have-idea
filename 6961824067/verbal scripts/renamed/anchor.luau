--rename by ai ((( 
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local grabbedPartsList = {}
local ownedToys = {}
local activeGrabs = {}
local grabGroups = {}
local highlightCache = {}
local overlayCache = {}
local anchorGrabThread = nil
local isAnchorGrabEnabled = false
local onPlayerAdded
local onPlayerRemoving

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local MenuGui = PlayerGui:WaitForChild("MenuGui")
local Menu = MenuGui:WaitForChild("Menu")
local TabContents = Menu:WaitForChild("TabContents")
local Toys = TabContents:WaitForChild("Toys")
local Contents = Toys:WaitForChild("Contents")

for _, child in pairs(Contents:GetChildren()) do
    if child:IsA("Model") then
        for _, subChild in pairs(child:GetChildren()) do
            if subChild.Name == "UIGridLayout" then
                ownedToys[child.Name] = nil
                print("Owned toy:", child.Name)
            end
        end
    end
end

local function findGrabbedPartByName(partName)
    for i, name in ipairs(grabbedPartsList) do
        if name == partName then
            return grabbedPartsList[i]
        end
    end
    return nil
end

local function clearGrabbedPartsList()
    for i = #grabbedPartsList, 1, -1 do
        table.remove(grabbedPartsList, i)
    end
end

local function safeConnectHeartbeat(callback)
    pcall(function()
        RunService.Heartbeat:Connect(callback)
    end)
end

local function findCurrentGrabbedPart()
    local grabPartsFolder = workspace:FindFirstChild("GrabParts")
    if not grabPartsFolder then return nil end
    
    local grabPart = grabPartsFolder:FindFirstChild("GrabPart")
    if not grabPart then return nil end
    
    local weldConstraint = grabPart:FindFirstChild("WeldConstraint")
    if not weldConstraint then return nil end
    
    local connectedPart = weldConstraint.Part1
    if not connectedPart then return nil end
    
    return connectedPart
end

local function updateHighlightOwnership(part)
    for _, child in ipairs(part:GetChildren()) do
        if child.Name == "PartOwner" then
            local ownerName = child.Value
            if ownerName == LocalPlayer.Name then
                local model = part:FindFirstChild("Model")
                local highlight = model and model:FindFirstChild("Highlight")
                if highlight then
                    if ownerName == LocalPlayer.Name then
                        highlight.OutlineColor = Color3.new(1, 0, 0)
                    end
                    highlight.OutlineColor = Color3.fromRGB(0, 255, 255)
                    print("Updated highlight color for", part.Name, "to", highlight.OutlineColor)
                end
            end
        end
    end
end

local function searchInList(list)
    for _ in ipairs(list) do
        return
    end
end

local anchorGrabButton = nil
local tooltipLabel = nil

local function createAnchorGrabUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AnchorGrabButtonGui"
    screenGui.IgnoreGuiInset = false
    screenGui.ResetOnSpawn = false
    screenGui.Parent = PlayerGui
    
    local button = Instance.new("TextButton")
    button.Name = "AnchorGrabButton"
    button.Size = UDim2.new(0, 75, 0, 75)
    button.Position = UDim2.new(0, -130, 0, -130)
    button.AnchorPoint = Vector2.new(1, 1)
    button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    button.BorderSizePixel = 0
    button.Text = "Anchor Grab"
    button.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = button
    
    local tooltip = Instance.new("TextLabel")
    tooltip.Name = "Tooltip"
    tooltip.Size = UDim2.new(0, 100, 0, 30)
    tooltip.Position = UDim2.new(1, -80, 1, -150)
    tooltip.AnchorPoint = Vector2.new(0.5, 1)
    tooltip.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    tooltip.BackgroundTransparency = 0.5
    tooltip.TextColor3 = Color3.fromRGB(255, 255, 255)
    tooltip.Text = "Anchor Grab: Off"
    tooltip.Font = Enum.Font.SourceSans
    tooltip.TextSize = 13
    tooltip.Visible = false
    tooltip.Parent = button
    
    anchorGrabButton = button
    tooltipLabel = tooltip
    isAnchorGrabEnabled = false
    
    button.MouseButton1Click:Connect(function()
        toggleAnchorGrab()
    end)
    
    button.MouseEnter:Connect(function()
        showTooltip()
    end)
    
    button.MouseLeave:Connect(function()
        hideTooltip()
    end)
end

local function toggleAnchorGrab()
    isAnchorGrabEnabled = not isAnchorGrabEnabled
    
    if isAnchorGrabEnabled then
        anchorGrabButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        
        if anchorGrabThread then
            local status = coroutine.status(anchorGrabThread)
            if status == "dead" then
                anchorGrabThread = nil
            end
        end
        
        anchorGrabThread = coroutine.create(function()
            anchorGrabLoop()
        end)
        coroutine.resume(anchorGrabThread)
        
        print("Anchor Grab Enabled")
        tooltipLabel.Text = "Anchor Grab: On"
    else
        anchorGrabButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        
        if anchorGrabThread then
            local status = coroutine.status(anchorGrabThread)
            if status == "dead" then
                coroutine.close(anchorGrabThread)
                anchorGrabThread = nil
                print("Anchor Grab Disabled")
            end
        end
        
        hideTooltip()
        tooltipLabel.Text = "Anchor Grab: Off"
    end
end

local function showTooltip()
    tooltipLabel.Visible = true
end

local function hideTooltip()
    tooltipLabel.Visible = false
end

local function removeFromList(list, targetPart)
    for i, part in ipairs(list) do
        if part.Name == targetPart.Name then
            table.remove(list, i)
            print("Removed", part.Name)
        end
    end
end

local function cleanupPart(part)
    if part then
        local bodyPos = part:FindFirstChild("BodyPosition")
        if bodyPos then
            bodyPos:Destroy()
            print("Destroyed BodyPosition for", part.Name)
        end
        
        local bodyGyro = part:FindFirstChild("BodyGyro")
        if bodyGyro then
            bodyGyro:Destroy()
            print("Destroyed BodyGyro for", part.Name)
        end
        
        local model = part:FindFirstChild("Model")
        if model then
            local highlight = model:FindFirstChild("Highlight")
            if highlight then
                highlight:Destroy()
                print("Destroyed Highlight for", part.Name)
            end
            
            local imageOverlay = model:FindFirstChild("ImageOverlay")
            if imageOverlay then
                imageOverlay:Destroy()
                print("Destroyed Image Overlay for", part.Name)
            end
        end
    end
end

local function validateGrab(grabData)
    if grabData then
        local result = isDescendantOf(grabData.part, workspace)
        if result then
            return grabData
        end
    end
    return nil
end

local function cleanupGroup(grabData)
    if grabData.group then
        for _, groupPart in ipairs(grabData.group) do
            if groupPart.part then
                local bodyPos = groupPart.part:FindFirstChild("BodyPosition")
                if bodyPos then
                    bodyPos:Destroy()
                    print("Destroyed BodyPosition for", groupPart.part.Name)
                end
                
                local bodyGyro = groupPart.part:FindFirstChild("BodyGyro")
                if bodyGyro then
                    bodyGyro:Destroy()
                    print("Destroyed BodyGyro for", groupPart.part.Name)
                end
            end
        end
    end
    
    if grabData.primaryPart then
        local parent = grabData.primaryPart.Parent
        if parent then
            local highlight = parent:FindFirstChild("Highlight")
            if highlight then
                highlight:Destroy()
                print("Destroyed Highlight for", grabData.primaryPart.Name)
            end
            
            local imageOverlay = parent:FindFirstChild("ImageOverlay")
            if imageOverlay then
                imageOverlay:Destroy()
                print("Destroyed Image Overlay for", grabData.primaryPart.Name)
            end
        end
    end
    
    activeGrabs = {}
    print("Cleaned up grab group")
end

local function isDescendantOf(target, ancestor)
    local current = target.Parent
    while current do
        if current == ancestor then
            return true
        end
        current = current.Parent
    end
    return false
end

local function createGrabVisuals(model)
    local highlight = Instance.new("Highlight")
    highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    highlight.FillTransparency = 1
    highlight.Name = "Highlight"
    highlight.OutlineColor = Color3.fromRGB(0, 255, 255)
    highlight.OutlineTransparency = 0.5
    highlight.Parent = model
    print("Created highlight and set on " .. model.Name)
    
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "ImageOverlay"
    billboardGui.Size = UDim2.new(0, 80, 0, 80)
    billboardGui.StudsOffset = Vector3.new(0, 3, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Adornee = model
    billboardGui.Parent = model
    
    local imageLabel = Instance.new("ImageLabel")
    imageLabel.Size = UDim2.new(1, 0, 1, 0)
    imageLabel.Position = UDim2.new(0, 0, 0, 0)
    imageLabel.BackgroundTransparency = 1
    imageLabel.Image = "rbxassetid://122000268316876"
    imageLabel.Parent = billboardGui
    print("Added image overlay to " .. model.Name)
    
    return {
        Highlight = highlight,
        BillboardGui = billboardGui
    }
end

local function createBodyMovers(part, position, cframe)
    local bodyPosition = Instance.new("BodyPosition")
    local bodyGyro = Instance.new("BodyGyro")
    
    bodyPosition.P = 15000
    bodyPosition.D = 200
    bodyPosition.MaxForce = Vector3.new(5000000, 5000000, 5000000)
    bodyPosition.Position = position
    bodyPosition.Parent = part
    
    bodyGyro.P = 15000
    bodyGyro.D = 200
    bodyGyro.MaxTorque = Vector3.new(5000000, 5000000, 5000000)
    bodyGyro.CFrame = cframe
    bodyGyro.Parent = part
    
    print("Created BodyMovers for", part.Name)
end

local function addToGrabbedList(part, list)
    table.insert(list, part.Name)
    print("Added", part.Name, "to grabbed list")
end

local function anchorGrabLoop()
    while isAnchorGrabEnabled do
        local grabbedPart = findCurrentGrabbedPart()
        if grabbedPart then
            local partName = grabbedPart.Name
            if not findGrabbedPartByName(partName) then
                local model = grabbedPart:FindFirstChild("Model") or grabbedPart
                createGrabVisuals(model)
                createBodyMovers(grabbedPart, grabbedPart.Position, grabbedPart.CFrame)
                addToGrabbedList(grabbedPart, grabbedPartsList)
            end
        end
        task.wait()
    end
end

createAnchorGrabUI()
