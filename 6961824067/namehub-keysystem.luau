loadstring[[-- Key System GUI Script for Delta X Injector
-- Updated version with improved GUI, debug prints, and ensured key loading
-- New: Load botLink from keys.lua for Get Key button
-- New: Default language is Russian, flag starts as British (🇬🇧), toggles to Russian (🇷🇺) and back

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Scaling factor for GUI (reduced by 1.25 times: original 2/3 ≈0.666, new ≈0.533)
local scale = 2/3.75  -- 2/3 / 1.25 = 2/3.75 ≈0.533

-- Language toggle: false for Russian (default), true for English
local isEnglish = false

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KeySystemGUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Main Frame with improved styling (darker theme, borders)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 450 * scale, 0, 400 * scale)  -- Increased height for new button
mainFrame.Position = UDim2.new(0.5, -225 * scale, 0.5, -200 * scale)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)  -- Darker background
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12 * scale)  -- Softer corners
corner.Parent = mainFrame

-- Add a subtle stroke for border effect
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(50, 50, 50)
stroke.Thickness = 1
stroke.Transparency = 0.5
stroke.Parent = mainFrame

-- Title Label with gradient
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 0, 60 * scale)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Key System"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBlack  -- Bolder font
titleLabel.Parent = mainFrame

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 150, 255))
}
gradient.Parent = titleLabel

-- Language Toggle Button (top-left, starts as British flag)
local flagButton = Instance.new("TextButton")
flagButton.Name = "FlagButton"
flagButton.Size = UDim2.new(0, 40 * scale, 0, 40 * scale)
flagButton.Position = UDim2.new(0, 10 * scale, 0, 10 * scale)
flagButton.BackgroundTransparency = 1
flagButton.Text = "🇬🇧"  -- Start with British flag
flagButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flagButton.TextScaled = true
flagButton.Font = Enum.Font.GothamBold
flagButton.Parent = mainFrame

-- Key Input with placeholder and border
local keyInput = Instance.new("TextBox")
keyInput.Name = "KeyInput"
keyInput.Size = UDim2.new(0.85, 0, 0, 50 * scale)
keyInput.Position = UDim2.new(0.075, 0, 0, 80 * scale)
keyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
keyInput.BorderSizePixel = 0
keyInput.Text = ""
keyInput.PlaceholderText = "Введите ключ здесь..."  -- Default to Russian
keyInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
keyInput.TextScaled = true
keyInput.Font = Enum.Font.GothamSemibold
keyInput.Parent = mainFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 8 * scale)
inputCorner.Parent = keyInput

local inputStroke = Instance.new("UIStroke")
inputStroke.Color = Color3.fromRGB(60, 60, 60)
inputStroke.Thickness = 1
inputStroke.Parent = keyInput

-- Verify Button (left side)
local verifyButton = Instance.new("TextButton")
verifyButton.Name = "VerifyButton"
verifyButton.Size = UDim2.new(0.4, 0, 0, 50 * scale)
verifyButton.Position = UDim2.new(0.075, 0, 0, 150 * scale)
verifyButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)  -- Brighter green
verifyButton.BorderSizePixel = 0
verifyButton.Text = "Проверить Ключ"  -- Default to Russian
verifyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
verifyButton.TextScaled = true
verifyButton.Font = Enum.Font.GothamBold
verifyButton.Parent = mainFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8 * scale)
buttonCorner.Parent = verifyButton

-- New Get Key Button (right side, different color: blue)
local getKeyButton = Instance.new("TextButton")
getKeyButton.Name = "GetKeyButton"
getKeyButton.Size = UDim2.new(0.4, 0, 0, 50 * scale)
getKeyButton.Position = UDim2.new(0.525, 0, 0, 150 * scale)
getKeyButton.BackgroundColor3 = Color3.fromRGB(0, 100, 255)  -- Blue color
getKeyButton.BorderSizePixel = 0
getKeyButton.Text = "Получить ключ"  -- Default to Russian
getKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
getKeyButton.TextScaled = true
getKeyButton.Font = Enum.Font.GothamBold
getKeyButton.Parent = mainFrame

local getKeyCorner = Instance.new("UICorner")
getKeyCorner.CornerRadius = UDim.new(0, 8 * scale)
getKeyCorner.Parent = getKeyButton

-- Status Label (moved lower)
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(0.85, 0, 0, 120 * scale)  -- Increased for multi-line
statusLabel.Position = UDim2.new(0.075, 0, 0, 210 * scale)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Введите ключ и нажмите кнопку."  -- Default to Russian
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextScaled = true
statusLabel.TextWrapped = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

-- Close Button (improved: larger, circular)
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 40 * scale, 0, 40 * scale)
closeButton.Position = UDim2.new(1, -45 * scale, 0, 10 * scale)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)  -- Brighter red
closeButton.BorderSizePixel = 0
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)  -- Fully circular
closeCorner.Parent = closeButton

-- Load keys.lua immediately after script load
local KEYS_URL = "https://raw.githubusercontent.com/scriptografKeys/keuse/main/kys"
print("Attempting to load keys.lua from: " .. KEYS_URL)
local successKeys, result = pcall(function()
    return loadstring(game:HttpGet(KEYS_URL))()
end)
if not successKeys then
    warn("Failed to load keys.lua: " .. tostring(result))
    _G.CurrentKey = nil
    _G.BotLink = nil
    statusLabel.Text = isEnglish and "Error loading key. Try again later." or "Ошибка загрузки ключа. Попробуйте позже."
    statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
else
    if type(result) == "table" and result.key and result.botLink then
        print("Keys.lua loaded successfully. Current key: " .. tostring(result.key) .. ", Bot link: " .. tostring(result.botLink))
        _G.CurrentKey = result.key  -- Store key
        _G.BotLink = result.botLink  -- Store bot link
    else
        print("Keys.lua fallback: treating result as key only")
        _G.CurrentKey = result  -- Fallback for old format
        _G.BotLink = nil
    end
end

-- Function to toggle language
local function toggleLanguage()
    isEnglish = not isEnglish
    if isEnglish then
        titleLabel.Text = "Key System"
        keyInput.PlaceholderText = "Enter key here..."
        verifyButton.Text = "Verify Key"
        getKeyButton.Text = "Get Key"
        statusLabel.Text = "Enter key and verify."
        flagButton.Text = "🇷🇺"  -- Show Russian flag when English
    else
        titleLabel.Text = "Key System"  -- Keep title same or translate if needed
        keyInput.PlaceholderText = "Введите ключ здесь..."
        verifyButton.Text = "Проверить Ключ"
        getKeyButton.Text = "Получить ключ"
        statusLabel.Text = "Введите ключ и нажмите кнопку."
        flagButton.Text = "🇬🇧"  -- Show British flag when Russian
    end
end

-- Flag button logic: Toggle language
flagButton.MouseButton1Click:Connect(toggleLanguage)

-- Verify logic with debug prints
verifyButton.MouseButton1Click:Connect(function()
    local inputKey = string.gsub(keyInput.Text, "%s+", "")  -- Trim whitespace
    print("Verify clicked! Input key: '" .. inputKey .. "' | Current key: '" .. tostring(_G.CurrentKey) .. "'")
    
    if inputKey == "" then
        statusLabel.Text = isEnglish and "Enter a key!" or "Введите ключ!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        print("Empty key input")
        return
    end
    
    if _G.CurrentKey and inputKey == _G.CurrentKey then
        print("Key is valid!")
        statusLabel.Text = isEnglish and "Your script is activated!" or "Ваш скрипт активирован!"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        -- Load the main script after verification
                -- Main script injected by Keybot
        loadstring(game:HttpGet("https://raw.githubusercontent.com/NameHubScript/_/refs/heads/main/f"))()
        wait(2)
        screenGui:Destroy()
    else
        print("Key is invalid or CurrentKey is nil")
        statusLabel.Text = isEnglish and "Invalid key!" or "Неверный ключ!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        keyInput.Text = ""
    end
end)

-- Get Key button logic: Copy bot link to clipboard
getKeyButton.MouseButton1Click:Connect(function()
    local botLink = _G.BotLink or "https://t.me/keysrol_bot"  -- Fallback to default if not loaded
    if setclipboard then
        setclipboard(botLink)
        statusLabel.Text = isEnglish and "Link copied to clipboard: " .. botLink or "Ссылка скопирована в буфер обмена: " .. botLink
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        print("Copied to clipboard: " .. botLink)
    else
        statusLabel.Text = isEnglish and "setclipboard unavailable. Link: " .. botLink or "setclipboard недоступен. Ссылка: " .. botLink
        statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        print("setclipboard not available")
    end
end)

-- Close button logic
closeButton.MouseButton1Click:Connect(function()
    print("Close button clicked")
    screenGui:Destroy()
end)

-- Enter key press to verify
keyInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        verifyButton.MouseButton1Click:Fire()
    end
end)

-- Add hover effect to verify button
verifyButton.MouseEnter:Connect(function()
    TweenService:Create(verifyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 255, 0)}):Play()
end)
verifyButton.MouseLeave:Connect(function()
    TweenService:Create(verifyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 200, 0)}):Play()
end)

-- Add hover effect to get key button
getKeyButton.MouseEnter:Connect(function()
    TweenService:Create(getKeyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 150, 255)}):Play()
end)
getKeyButton.MouseLeave:Connect(function()
    TweenService:Create(getKeyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 100, 255)}):Play()
end)

-- Fade-in animation for all elements
local function fadeIn(element, props)
    TweenService:Create(element, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

mainFrame.BackgroundTransparency = 1
fadeIn(mainFrame, {BackgroundTransparency = 0})

titleLabel.TextTransparency = 1
fadeIn(titleLabel, {TextTransparency = 0})

keyInput.BackgroundTransparency = 1
keyInput.TextTransparency = 1
fadeIn(keyInput, {BackgroundTransparency = 0, TextTransparency = 0})

verifyButton.BackgroundTransparency = 1
verifyButton.TextTransparency = 1
fadeIn(verifyButton, {BackgroundTransparency = 0, TextTransparency = 0})

getKeyButton.BackgroundTransparency = 1
getKeyButton.TextTransparency = 1
fadeIn(getKeyButton, {BackgroundTransparency = 0, TextTransparency = 0})

statusLabel.TextTransparency = 1
fadeIn(statusLabel, {TextTransparency = 0})

closeButton.BackgroundTransparency = 1
closeButton.TextTransparency = 1
fadeIn(closeButton, {BackgroundTransparency = 0, TextTransparency = 0})

flagButton.TextTransparency = 1
fadeIn(flagButton, {TextTransparency = 0})
]]();
