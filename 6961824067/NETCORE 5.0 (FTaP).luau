loadstring[[local camera = workspace.CurrentCamera
local plr = game.Players.LocalPlayer
local mouse = plr:GetMouse();
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
if (not UserInputService.KeyboardEnabled) then
    plr:Kick("Unsupported device")
end
if (hookmetamethod == nil or getrawmetatable == nil) then
    plr:Kick(getexecutorname().." isn't supported")
end
local uiLoader = loadstring(game:HttpGet('https://raw.githubusercontent.com/topitbopit/dollarware/main/library.lua'))
local ui = uiLoader({
    rounding = false, -- Whether certain features get rounded 
    theme = 'grape', -- The theme. Available themes are: cherry, orange, lemon, lime, raspberry, blueberry, grape, watermelon
    smoothDragging = false -- Smooth dragging
})
local window = ui.newWindow({
    text = 'NETCORE 5.0 (FTaP)', -- Title of window 
    resize = true, -- Ability to resize
    size = Vector2.new(550, 376), -- Window size, accepts UDim2s and Vector2s
    position = nil -- Custom position, defaults to roughly the bottom right corner
})

local Exploits = window:addMenu({
    text = "Exploits",
})
local Client = window:addMenu({
    text = "Client",
})
local Visuals = window:addMenu({
    text = "Visuals",
})
local Items = window:addMenu({
    text = "Items",
})
local Other = window:addMenu({
    text = "Other",
})

local flingmanips = Exploits:addSection({
    text = 'Fling Manipulations', -- Title of section
    side = 'left', -- Side of the menu that the section is placed on. Defaults to 'auto', but can be 'left' or 'right'
    showMinButton = true, -- Ability to minimize this section. Defaults to true
})
local playerposition = Exploits:addSection({
    text = 'Set Position', -- Title of section
    side = 'left', -- Side of the menu that the section is placed on. Defaults to 'auto', but can be 'left' or 'right'
    showMinButton = true, -- Ability to minimize this section. Defaults to true
})
local players = Exploits:addSection({
    text = 'Players', -- Title of section
    side = 'right', -- Side of the menu that the section is placed on. Defaults to 'auto', but can be 'left' or 'right'
    showMinButton = true, -- Ability to minimize this section. Defaults to true
})
local local_player = Client:addSection({
    text = 'Local Player', -- Title of section
    side = 'left', -- Side of the menu that the section is placed on. Defaults to 'auto', but can be 'left' or 'right'
    showMinButton = true, -- Ability to minimize this section. Defaults to true
})
local local_player_manips = Client:addSection({
    text = 'Local Player Manipulations', -- Title of section
    side = 'right', -- Side of the menu that the section is placed on. Defaults to 'auto', but can be 'left' or 'right'
    showMinButton = true, -- Ability to minimize this section. Defaults to true
})
local vision = Visuals:addSection({
    text = 'Vision', -- Title of section
    side = 'left', -- Side of the menu that the section is placed on. Defaults to 'auto', but can be 'left' or 'right'
    showMinButton = true, -- Ability to minimize this section. Defaults to true
})
local self_vis = Visuals:addSection({
    text = 'Self', -- Title of section
    side = 'left', -- Side of the menu that the section is placed on. Defaults to 'auto', but can be 'left' or 'right'
    showMinButton = true, -- Ability to minimize this section. Defaults to true
})
local modulation = Visuals:addSection({
    text = 'Modulation', -- Title of section
    side = 'right', -- Side of the menu that the section is placed on. Defaults to 'auto', but can be 'left' or 'right'
    showMinButton = true, -- Ability to minimize this section. Defaults to true
})
local itemsmanip = Items:addSection({
    text = 'Thing Manipulations', -- Title of section
    side = 'left', -- Side of the menu that the section is placed on. Defaults to 'auto', but can be 'left' or 'right'
    showMinButton = true, -- Ability to minimize this section. Defaults to true
})
local items_other = Items:addSection({
    text = 'Other', -- Title of section
    side = 'right', -- Side of the menu that the section is placed on. Defaults to 'auto', but can be 'left' or 'right'
    showMinButton = true, -- Ability to minimize this section. Defaults to true
})
local tools_other = Other:addSection({
    text = 'Tools', -- Title of section
    side = 'left', -- Side of the menu that the section is placed on. Defaults to 'auto', but can be 'left' or 'right'
    showMinButton = true, -- Ability to minimize this section. Defaults to true
})

getgenv().whitelist = false;

getgenv().killer = false;
getgenv().superfling = false;
getgenv().flingall = false;
getgenv().walkspeed = false;
getgenv().antifling = false;
getgenv().fly = false;
getgenv().noclip = false;
getgenv().esp = false
getgenv().antitp = false;
getgenv().modulation = false;
getgenv().enable_ambient = false;
getgenv().force_thing_spawn = false;
getgenv().fov = false;
getgenv().pos = false;
getgenv().setposfling = false;
getgenv().thirdperson = false;
getgenv().mouseicon = false;

local super_fling_value = 1000;
local super_fling_multiplier = 1;
local fling_aura_multiplier = 1;
local last_spawned_thing = nil
local thing_checking = false;
local people_checking = false;
local thing_checking_flaura = false;
local people_checking_flaura = false;

local thing_checking_setposar = false;
local people_checking_setposar = false;

local setposition = CFrame.new(0, 0, 0);
local white_anti_tp = false;

local setpos_radius = 20;

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

if (not UserInputService.KeyboardEnabled) then
    plr:Kick("Unsupported device")
end
if (getexecutorname() == "Xeno" or getexecutorname() == "Solara") then
    plr:Kick(getexecutorname().." isn't supported")
end


if (not UserInputService.KeyboardEnabled) then
    game.Players.LocalPlayer:Kick("Unsupported device")
end
local oldNamecalls = {

}
local oldValues_namecall = {

}


local function namecallHookSystem(obj, method, oldValue, state)

    obj = getrawmetatable(obj)

    if (oldNamecalls[obj] == nil) then

        oldNamecalls[obj] = obj.__namecall 

    end

    if (oldValues_namecall[obj] == nil) then

        oldValues_namecall[obj] = {};

    end

    if (oldValues_namecall[obj][method] == nil) then
        oldValues_namecall[obj][method] = oldValue;
    end

    setreadonly(obj, false)

    if (state) then

        obj.__namecall = newcclosure(function(t, ...)

            local namecallMethod = getnamecallmethod();

            local mt = getrawmetatable(t);

            if (getgenv().whitelist == false and oldValues_namecall[mt] ~= nil and oldValues_namecall[mt][namecallMethod] ~= nil) then
                return oldValues_namecall[mt][namecallMethod](t, ...);
            end

            return oldNamecalls[mt](t, ...);
        end)

    end

    if (not state) then

        obj.__namecall = oldNamecalls[obj];

        oldNamecalls[obj] = nil

        oldValues_namecall[obj] = nil;
    end

    setreadonly(obj, true)
end

local oldIndexes = {

}

local oldNewIndexes = {

}

local oldValues = {

}

local function indexHookSystem(obj, key, oldValue, state)
    

    obj = getrawmetatable(obj)

    if (oldIndexes[obj] == nil) then

        oldIndexes[obj] = obj.__index 

    end

    if (oldNewIndexes[obj] == nil) then
        oldNewIndexes[obj] = obj.__newindex 
    end

    if (oldValues[obj] == nil) then

        oldValues[obj] = {};

    end

    if (oldValues[obj][key] == nil) then
        oldValues[obj][key] = oldValue;
    end

    setreadonly(obj, false)

    if (state) then

        obj.__index = newcclosure(function(t, prm)
            local mt = getrawmetatable(t);

            if (getgenv().whitelist == false and oldValues[mt] ~= nil and oldValues[mt][prm] ~= nil) then
                return oldValues[mt][prm];
            end

            return oldIndexes[mt](t, prm);
        end)

        obj.__newindex = newcclosure(function(t, prm, value)
            local mt = getrawmetatable(t)
            if (getgenv().whitelist == false and oldValues[mt] ~= nil and oldValues[mt][prm] ~= nil) then
                oldValues[mt][prm] = value;
                return true;
            end

            return oldNewIndexes[mt](t, prm, value);

        end)
    end

    if (not state) then

        obj.__index = oldIndexes[obj];
        obj.__newindex = oldNewIndexes[obj];

        oldIndexes[obj] = nil
        oldNewIndexes[obj] = nil
        oldValues[obj][key] = nil
    end

    setreadonly(obj, true)

end
local function initializeGlobalEventHook()

    local old;

    old = hookmetamethod(game:GetService("ReplicatedStorage").GrabEvents.SetNetworkOwner, "__namecall", function(self, ...)

        local arg = {...};

        local call = getnamecallmethod()

        if (call == "FireServer" and typeof(arg[1]) ~= "CFrame" and typeof(arg[1]) ~= "Number" and getgenv().killer and not getgenv().whitelist) then
            
            task.spawn(newcclosure(function()
                task.wait()
                if (arg[1] ~= nil and arg[1].Parent and arg[1].Parent:FindFirstChild("Humanoid")) then
                    task.spawn(newcclosure(function()
                        arg[1].Parent.Humanoid.Health = 0;
                        while task.wait() and arg[1].Parent.Humanoid.Health == 0 do
                            arg[1].Parent.Humanoid.Health = 0;
                        end
                    end))
                end
            
            end))
        end

        if (call == "FireServer" and getgenv().superfling and not getgenv().whitelist) then
            task.spawn(newcclosure(function()
                task.wait()
                if (not (arg[1] ~= nil and type(arg[1]) == "userdata" and (typeof(arg[1]) ~= "CFrame" and typeof(arg[1]) ~= "Vector3") and (arg[1]:IsA("BasePart") or arg[1]:IsA("Part")) and arg[1].Parent)) then return  end

                if (people_checking and game.Players:FindFirstChild(arg[1].Parent.Name)) then return; end

                if (thing_checking and not game.Players:FindFirstChild(arg[1].Parent.Name)) then return end;

                if (not arg[1]:IsDescendantOf(workspace.Map) and not arg[1]:IsDescendantOf(workspace.Plots) and not arg[1]:IsDescendantOf(workspace.Slots)) then
                    local connection;
                    connection = UserInputService.InputBegan:Connect(function(key)
                        if (key.UserInputType == Enum.UserInputType.MouseButton2) then
                            arg[1].AssemblyLinearVelocity = camera.CFrame.LookVector * super_fling_value * super_fling_multiplier;
                            connection:Disconnect();
                        end
                    end)

                    task.spawn(newcclosure(function()
                        while task.wait() do
                            
                            if (not workspace:FindFirstChild("GrabParts")) then
                                connection:Disconnect()
                                break;
                            end

                        end
                    end))

                end
            end))
        end
        if (call == "FireServer" and getgenv().setposfling and not getgenv().whitelist) then
            task.spawn(newcclosure(function()
                task.wait()
                if (not (arg[1] ~= nil and type(arg[1]) == "userdata" and (typeof(arg[1]) ~= "CFrame" and typeof(arg[1]) ~= "Vector3") and (arg[1]:IsA("BasePart") or arg[1]:IsA("Part")) and arg[1].Parent)) then return  end

                if (people_checking_setposar and game.Players:FindFirstChild(arg[1].Parent.Name)) then return; end

                if (thing_checking_setposar and not game.Players:FindFirstChild(arg[1].Parent.Name)) then return end;

                if (not arg[1]:IsDescendantOf(workspace.Map) and not arg[1]:IsDescendantOf(workspace.Plots) and not arg[1]:IsDescendantOf(workspace.Slots)) then
                    local connection;
                    connection = UserInputService.InputBegan:Connect(function(key)
                        if (key.UserInputType == Enum.UserInputType.MouseButton2) then
                            arg[1].CFrame = setposition
                            connection:Disconnect();
                        end
                    end)

                    task.spawn(newcclosure(function()
                        while task.wait() do
                            
                            if (not workspace:FindFirstChild("GrabParts")) then
                                connection:Disconnect()
                                break;
                            end

                        end
                    end))
                end
            end))
        end

        return old(self, ...);

    end)

end
local saved_camera_cframe = nil
local saved_rotation_part = nil
local function initializeGlobalItemsHookEvents()

    local old_method;

    old_method = hookmetamethod(game:GetService("ReplicatedStorage"):WaitForChild("MenuToys"):WaitForChild("SpawnToyRemoteFunction"), "__namecall", newcclosure(function(self, ...)
        local args = {...}
        local namecall = getnamecallmethod()

        if (namecall == "InvokeServer" and type(args[1]) == "string") then
            last_spawned_thing = args[1];
        end
        
        if (namecall == "InvokeServer" and saved_camera_cframe ~= nil and saved_rotation_part ~= nil) then
            args[2] = saved_camera_cframe
            args[3] = saved_rotation_part
        end

        return old_method(self, unpack(args));
    
    end))

end

local function onKiller()
    getgenv().killer = not getgenv().killer
end
local function onSuperFling()

    getgenv().superfling = not getgenv().superfling

end

local aura_fling_value = 1;
local skip_iteration = false;
local fling_aura_distance = 21;
local function onFlingAura()
    getgenv().flingall = not getgenv().flingall
    task.spawn(function()
        while getgenv().flingall and task.wait() do
            local event = game:GetService("ReplicatedStorage").GrabEvents.SetNetworkOwner;
            if (plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")) then
                for _, i in pairs(workspace:GetPartBoundsInRadius(plr.Character.HumanoidRootPart.Position, fling_aura_distance, OverlapParams.new())) do
                
                    if (people_checking_flaura and i.Parent ~= nil and game.Players:FindFirstChild(i.Parent.Name)) then skip_iteration = true; end

                    if (thing_checking_flaura and i.Parent ~= nil and not game.Players:FindFirstChild(i.Parent.Name)) then skip_iteration = true end;

                    if (not skip_iteration and i ~= nil and not i:IsDescendantOf(workspace.Plots) and not i:IsDescendantOf(plr.Character) and not i:IsDescendantOf(workspace.Map) and not i:IsDescendantOf(workspace.Slots) and (i:IsA("Part") or i:IsA("BasePart"))) then
                        
                        getgenv().whitelist = true;
                        event:FireServer(i, i.CFrame);

                        i.Velocity = camera.CFrame.LookVector * aura_fling_value * fling_aura_multiplier;

                        getgenv().whitelist = false;

                        task.wait()
                        
                    end

                    skip_iteration = false;
         
                end

            end

        end
    end)
end
local walkspeed_value = 100;
local old_walkspeed_value = plr.Character.Humanoid.WalkSpeed;
local function onWalkspeed()
    getgenv().walkspeed = not getgenv().walkspeed

    task.spawn(function()
        
        while task.wait() and getgenv().walkspeed do
            
            if (plr.Character and plr.Character:FindFirstChild("Humanoid")) then
                getgenv().whitelist = true;
                plr.Character.Humanoid.WalkSpeed = walkspeed_value
                getgenv().whitelist = false;
            end

        end
    
    end)

    indexHookSystem(plr.Character.Humanoid, "WalkSpeed", old_walkspeed_value, getgenv().walkspeed);
end

local function onAntiFling()
    getgenv().antifling = not getgenv().antifling
    local oldpos = CFrame.new(0, 0, 0);
    RunService.RenderStepped:Connect(newcclosure(function()
        if (plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and getgenv().antifling and not plr.Character.Humanoid.Sit) then
            
            oldpos = plr.Character.HumanoidRootPart.CFrame
            plr.Character:FindFirstChild("HumanoidRootPart").Anchored = false;

        end
        if (plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and getgenv().antifling and plr.Character.Humanoid.Sit) then
            game:GetService("ReplicatedStorage"):WaitForChild("CharacterEvents"):WaitForChild("Struggle"):FireServer()

            white_anti_tp = true;
            plr.Character:FindFirstChild("HumanoidRootPart").CFrame = oldpos or CFrame.new(0, 0, 0);
            plr.Character:FindFirstChild("HumanoidRootPart").AssemblyLinearVelocity = Vector3.new(0, 0, 0);
            plr.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(0, 0, 0);
            
            plr.Character:FindFirstChild("HumanoidRootPart").Anchored = true;
            white_anti_tp = false;
        end
        
        if (not getgenv().antifling and plr.Character:FindFirstChild("HumanoidRootPart")) then
            plr.Character:FindFirstChild("HumanoidRootPart").Anchored = false;
        end
    
    end))
end

local function onVelocityJump()
    getgenv().velocityjump = not getgenv().velocityjump
    task.spawn(newcclosure(function()
        while getgenv().velocityjump and task.wait() do
            getgenv().whitelist = true
            local plr = game:GetService("Players").LocalPlayer

            if (plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart") and UserInputService:IsKeyDown(Enum.KeyCode.Space)) then

                local root = plr.Character.HumanoidRootPart

                root.Velocity = Vector3.new(root.Velocity.X, 50, root.Velocity.Z);

            end
            getgenv().whitelist = false
        end
    end))
end

local fly_speed = 100;
local function onFly()
    getgenv().fly = not getgenv().fly

    task.spawn(newcclosure(function()
        while task.wait() and getgenv().fly do
            local plr = game:GetService("Players").LocalPlayer
            local camera = game:GetService("Workspace").CurrentCamera

            local summaryVelocity = Vector3.new(0, 0, 0);

            if (plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart") and camera and UserInputService:IsKeyDown(Enum.KeyCode.W)) then
                
                local lookVector = camera.CFrame.LookVector

                summaryVelocity = summaryVelocity + lookVector * fly_speed;
            end
            if (plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart") and camera and UserInputService:IsKeyDown(Enum.KeyCode.A)) then
                
                local rightVector = camera.CFrame.RightVector

                summaryVelocity = summaryVelocity + -rightVector * fly_speed;
            end
            if (plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart") and camera and UserInputService:IsKeyDown(Enum.KeyCode.D)) then
                
                local rightVector = camera.CFrame.RightVector

                summaryVelocity = summaryVelocity + rightVector * fly_speed;
            end
            if (plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart") and camera and UserInputService:IsKeyDown(Enum.KeyCode.S)) then
                
                local lookVector = camera.CFrame.LookVector;

                summaryVelocity = summaryVelocity + -lookVector * fly_speed;
            elseif (plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart") and camera) then

                plr.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0);
            end
            
            if (plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart")) then
                plr.Character.HumanoidRootPart.Velocity = summaryVelocity + Vector3.new(math.random(-25, 25), math.random(0, 1), math.random(-25, 25));
            end
        end
    end))

end

local function onNoclip()
    getgenv().noclip = not getgenv().noclip

    getgenv().whitelist = true;
    task.spawn(newcclosure(function()

        while task.wait() and getgenv().noclip do
            getgenv().whitelist = true;
            if (plr.Character and plr.Character:FindFirstChild("Humanoid")) then
                
                for _, i in pairs(plr.Character:GetDescendants()) do
                    
                    if (i:IsA("MeshPart") or i:IsA("BasePart") or i:IsA("Part")) then
                        i.CanCollide = false;
                    end

                end

            end
            getgenv().whitelist = false
        end

    end))

    for _, i in pairs(plr.Character:GetChildren()) do
                
        if (i:IsA("MeshPart") or i:IsA("BasePart") or i:IsA("Part")) then
            indexHookSystem(i, "CanCollide", true, getgenv().noclip);
        end

    end

    getgenv().whitelist = false
end
local esp_r = 128; local esp_g = 0; local esp_b = 255;
local function onESP()
    getgenv().esp = not getgenv().esp;
    getgenv().whitelist = true
    task.spawn(newcclosure(function()
        
        while task.wait() and getgenv().esp do
            for _, i in pairs(game.Players:GetPlayers()) do
                getgenv().whitelist = true
                if (i.Character and i.Name ~= plr.Name) then
                    
                    if (not i.Character:FindFirstChildOfClass("Highlight")) then
                        local Highlight = Instance.new("Highlight", i.Character);
                        Highlight.Name = math.random(-12345678, 12345678);

                        Highlight.Enabled = true;
                        Highlight.FillColor = Color3.fromRGB(esp_r, esp_g, esp_b)
                    else
                        i.Character:FindFirstChildOfClass("Highlight").Enabled = true
                        i.Character:FindFirstChildOfClass("Highlight").FillColor = Color3.fromRGB(esp_r, esp_g, esp_b)
                    end
                end
                getgenv().whitelist = false
            end

        end
    
    end))

    for _, i in pairs(game.Players:GetPlayers()) do
        getgenv().whitelist = true
        if (i.Character and i.Name ~= plr.Name) then
            
            namecallHookSystem(i.Character, "FindFirstChildOfClass", function() return nil end, getgenv().esp)
            
        end
        getgenv().whitelist = false
    end

    if (not getgenv().esp) then
        
        for _, i in pairs(game.Players:GetPlayers()) do

            if (i.Character and i.Name ~= plr.Name and i.Character:FindFirstChild("Highlight")) then
                
                i.Character:FindFirstChildOfClass("Highlight").Enabled = false

            end

        end

    end
    getgenv().whitelist = false
end
local previous_player_position;
local write_player_position = true;
local previous_player_velocity;
local function onAntiTp()
    getgenv().antitp = not getgenv().antitp;

    plr.Character.HumanoidRootPart.Changed:Connect(newcclosure(function(key, value)
        getgenv().whitelist = true
        if ((key == "Position" or key == "CFrame") and getgenv().antitp and not white_anti_tp) then
            write_player_position = false;
            plr.Character.HumanoidRootPart.CFrame = previous_player_position
            plr.Character.HumanoidRootPart.Velocity = previous_player_velocity
        elseif (getgenv().antitp) then
            write_player_position = true;
        end
        getgenv().whitelist = false
    end))

    local renderstepped = RunService.RenderStepped:Connect(newcclosure(function()
        getgenv().whitelist = true
        if (plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart") and write_player_position and getgenv().antitp and not white_anti_tp) then
            
            previous_player_position = plr.Character.HumanoidRootPart.CFrame
            previous_player_velocity = plr.Character.HumanoidRootPart.Velocity
        end
        getgenv().whitelist = false
    end))

    if (not getgenv().antitp) then
        renderstepped:Disconnect();
    end

end
local default_brightness = game.Lighting.Brightness;
local default_clocktime = game.Lighting.ClockTime;
local default_moon_sun_size = game.Lighting.Sky.SunAngularSize;

local bright = default_brightness;
local clocktime = default_clocktime
local moon_sun_size = default_moon_sun_size

local amb_r,amb_g,amb_b;

local default_ambient = game.Lighting.OutdoorAmbient;

local function onModulation()
    getgenv().modulation = not getgenv().modulation;
    getgenv().whitelist = true
    task.spawn(newcclosure(function()
        
        while task.wait() and getgenv().modulation do
            getgenv().whitelist = true
            game.Lighting.Brightness = bright;
            game.Lighting.ClockTime = clocktime
            game.Lighting.Sky.SunAngularSize = moon_sun_size
            game.Lighting.Sky.MoonAngularSize = moon_sun_size; 
            getgenv().whitelist = false
        end

        if (not getgenv().modulation) then
            game.Lighting.Brightness = default_brightness;
            game.Lighting.ClockTime = default_clocktime
            game.Lighting.Sky.SunAngularSize = default_moon_sun_size
            game.Lighting.Sky.MoonAngularSize = default_moon_sun_size;
        end
        
    
    end))

    indexHookSystem(game.Lighting, "Brightness", default_brightness, getgenv().modulation);
    indexHookSystem(game.Lighting, "ClockTime", default_clocktime, getgenv().modulation);
    indexHookSystem(game.Lighting.Sky, "SunAngularSize", default_moon_sun_size, getgenv().modulation);
    indexHookSystem(game.Lighting.Sky, "MoonAngularSize", default_moon_sun_size, getgenv().modulation);

    getgenv().whitelist = false

end
local function onAmbient()
    getgenv().enable_ambient = not getgenv().enable_ambient;
    getgenv().whitelist = true
    task.spawn(newcclosure(function()
        while task.wait() and getgenv().enable_ambient do
            getgenv().whitelist = true
            if (getgenv().enable_ambient) then
                game.Lighting.OutdoorAmbient = Color3.fromRGB(amb_r, amb_g, amb_b);
                game.Lighting.Ambient = Color3.fromRGB(amb_r, amb_g, amb_b)
            end
            
            if (not getgenv().enable_ambient) then
                game.Lighting.OutdoorAmbient = default_ambient;
                game.Lighting.Ambient = default_ambient
            end
            getgenv().whitelist = false
        end
    end))

    indexHookSystem(game.Lighting, "OutdoorAmbient", default_ambient, getgenv().enable_ambient)
    indexHookSystem(game.Lighting, "Ambient", Color3.fromRGB(200, 200, 200), getgenv().enable_ambient);

    getgenv().whitelist = false

end

local function onForceSpawn()

    getgenv().force_thing_spawn = not getgenv().force_thing_spawn

    local event = game:GetService("ReplicatedStorage"):WaitForChild("MenuToys"):WaitForChild("SpawnToyRemoteFunction")

    while task.wait(0.01) and getgenv().force_thing_spawn do

        if (last_spawned_thing ~= nil and workspace:FindFirstChild("RotateOrientPart")) then
            task.spawn(function()
                event:InvokeServer(last_spawned_thing, camera.CFrame, workspace:FindFirstChild("RotateOrientPart").Orientation);
            end)
        end
        
    end
    
end
local fov_value = 70
local function onFovChanger()
    getgenv().fov = not getgenv().fov

    while task.wait(0.01) and getgenv().fov do
        
        camera.FieldOfView = fov_value;

    end

end
local function onSetPosAura()
    getgenv().pos = not getgenv().pos
    task.spawn(function()
        while getgenv().pos and task.wait() do
            local event = game:GetService("ReplicatedStorage").GrabEvents.SetNetworkOwner;
            if (plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")) then
                for _, i in pairs(workspace:GetPartBoundsInRadius(plr.Character.HumanoidRootPart.Position, setpos_radius, OverlapParams.new())) do
                
                    if (people_checking_setposar and i.Parent ~= nil and game.Players:FindFirstChild(i.Parent.Name)) then skip_iteration = true; end

                    if (thing_checking_setposar and i.Parent ~= nil and not game.Players:FindFirstChild(i.Parent.Name)) then skip_iteration = true end;

                    if (not skip_iteration and i ~= nil and not i:IsDescendantOf(workspace.Plots) and not i:IsDescendantOf(plr.Character) and not i:IsDescendantOf(workspace.Map) and not i:IsDescendantOf(workspace.Slots) and (i:IsA("Part") or i:IsA("BasePart"))) then
                        
                        getgenv().whitelist = true;
             
                        event:FireServer(i, i.CFrame);

                        i.CFrame = setposition

                        getgenv().whitelist = false;

                        task.wait()
                        
                    end

                    skip_iteration = false;
         
                end

            end

        end
    end)
end
local function onSetPosFling()
    getgenv().setposfling = not getgenv().setposfling;
end
local function onThirdPerson()  
    getgenv().thirdperson = not getgenv().thirdperson

    if (getgenv().thirdperson) then
        plr.CameraMaxZoomDistance = 256;
        plr.CameraMode = "Classic";
    else
        plr.CameraMaxZoomDistance = 256;
        plr.CameraMode = "LockFirstPerson";
    end
end
local function onMouseIcon()
    getgenv().mouseicon = not getgenv().mouseicon
    task.spawn(newcclosure(function()
        
        while task.wait() and getgenv().mouseicon do
            
            UserInputService.MouseIconEnabled = true;

        end
    
    end))

    if (not getgenv().mouseicon) then
        UserInputService.MouseIconEnabled = false;
    end

end

local super_fling = flingmanips:addToggle({
    text = 'Super Fling', 
    state = false -- Starting state of the toggle - doesn't automatically call the callback
})
super_fling:bindToEvent('onToggle', function(newState) -- Call a function when toggled
    onSuperFling();
end)
local thing_check = flingmanips:addToggle({
    text = 'Ignore Things', 
    state = false -- Starting state of the toggle - doesn't automatically call the callback
})
thing_check:bindToEvent('onToggle', function(newState) -- Call a function when toggled
    thing_checking = newState;
end)
local people_check = flingmanips:addToggle({
    text = 'Ignore People', 
    state = false -- Starting state of the toggle - doesn't automatically call the callback
})
people_check:bindToEvent('onToggle', function(newState) -- Call a function when toggled
    people_checking = newState;
end)

flingmanips:addSlider({
    text = 'Fling Strength',
    min = 1,
    max = 10000,
    step = 1,
    val = 1
}, function(newValue) 
    super_fling_value = newValue
end)
flingmanips:addSlider({
    text = 'Strength Multiplier',
    min = 1,
    max = 100,
    step = 1,
    val = 1
}, function(newValue) 
    super_fling_multiplier = newValue
end)

local grab_killer = flingmanips:addToggle({
    text = 'Grab Killer', 
    state = false -- Starting state of the toggle - doesn't automatically call the callback
})
grab_killer:bindToEvent('onToggle', function(newState) -- Call a function when toggled
    onKiller();
end)

local grab_killer = local_player_manips:addToggle({
    text = 'Anti Fling', 
    state = false -- Starting state of the toggle - doesn't automatically call the callback
})
grab_killer:bindToEvent('onToggle', function(newState) -- Call a function when toggled
    onAntiFling();
end)
local walkspeed_changer = local_player:addToggle({
    text = 'Walkspeed Changer', 
    state = false -- Starting state of the toggle - doesn't automatically call the callback
})
walkspeed_changer:bindToEvent('onToggle', function(newState) -- Call a function when toggled
    onWalkspeed();
end)

local_player:addSlider({
    text = 'Speed',
    min = 1,
    max = 1000,
    step = 1,
    val = 1
}, function(newValue) 
    walkspeed_value = newValue
end)

local inf_jump = local_player_manips:addToggle({
    text = 'Infinite Jump', 
    state = false -- Starting state of the toggle - doesn't automatically call the callback
})
inf_jump:bindToEvent('onToggle', function(newState) -- Call a function when toggled
    onVelocityJump();
end)
local fly_enabled = local_player:addToggle({
    text = 'Fly', 
    state = false -- Starting state of the toggle - doesn't automatically call the callback
})
fly_enabled:bindToEvent('onToggle', function(newState) -- Call a function when toggled
    onFly();
end)

local_player:addSlider({
    text = 'Fly Speed',
    min = 1,
    max = 1000,
    step = 1,
    val = 1
}, function(newValue) 
    fly_speed = newValue
end)

local no_clip = local_player_manips:addToggle({
    text = 'Noclip', 
    state = false -- Starting state of the toggle - doesn't automatically call the callback
})
no_clip:bindToEvent('onToggle', function(newState) -- Call a function when toggled
    onNoclip();
end)

local anti_tp = local_player_manips:addToggle({
    text = 'Anti Teleport', 
    state = false -- Starting state of the toggle - doesn't automatically call the callback
})
anti_tp:bindToEvent('onToggle', function(newState) -- Call a function when toggled
    onAntiTp();
end)
local fling_aura = players:addToggle({
    text = 'Fling Aura', 
    state = false -- Starting state of the toggle - doesn't automatically call the callback
})
fling_aura:bindToEvent('onToggle', function(newState) -- Call a function when toggled
    onFlingAura();
end)
fling_aura:bindToEvent('onToggle', function(newState) -- Call a function when toggled
    onFlingAura();
end)
local fling_aura_check_things = players:addToggle({
    text = 'Ignore Things', 
    state = false -- Starting state of the toggle - doesn't automatically call the callback
})
fling_aura_check_things:bindToEvent('onToggle', function(newState) -- Call a function when toggled
    thing_checking_flaura = newState
end)
local fling_aura_check_people = players:addToggle({
    text = 'Ignore People', 
    state = false -- Starting state of the toggle - doesn't automatically call the callback
})
fling_aura_check_people:bindToEvent('onToggle', function(newState) -- Call a function when toggled
    people_checking_flaura = newState
end)
players:addSlider({
    text = 'Fling Strength',
    min = 1,
    max = 10000,
    step = 1,
    val = 1
}, function(newValue) 
    aura_fling_value = newValue
end)
players:addSlider({
    text = 'Strength Multiplier',
    min = 1,
    max = 100,
    step = 1,
    val = 1
}, function(newValue) 
    fling_aura_multiplier = newValue
end)
players:addSlider({
    text = 'Radius',
    min = 1,
    max = 40,
    step = 1,
    val = 21
}, function(newValue) 
    fling_aura_distance = newValue
end)
local player_esp = vision:addToggle({
    text = 'Player ESP', 
    state = false -- Starting state of the toggle - doesn't automatically call the callback
})
player_esp:bindToEvent('onToggle', function(newState) -- Call a function when toggled
    onESP();
end)
vision:addSlider({
    text = 'Red',
    min = 1,
    max = 255,
    step = 1,
    val = 1
}, function(newValue) 
    esp_r = newValue
end)
vision:addSlider({
    text = 'Green',
    min = 1,
    max = 255,
    step = 1,
    val = 1
}, function(newValue) 
    esp_g = newValue
end)
vision:addSlider({
    text = 'Blue',
    min = 1,
    max = 255,
    step = 1,
    val = 1
}, function(newValue) 
    esp_b = newValue
end)
local fov_change = self_vis:addToggle({
    text = 'FOV Changer', 
    state = false -- Starting state of the toggle - doesn't automatically call the callback
})
fov_change:bindToEvent('onToggle', function(newState) -- Call a function when toggled
    onFovChanger();
end)
self_vis:addSlider({
    text = 'FOV',
    min = 1,
    max = 120,
    step = 1,
    val = 1
}, function(newValue) 
    fov_value = newValue
end)
local third_person = self_vis:addToggle({
    text = 'ThirdPerson', 
    state = false -- Starting state of the toggle - doesn't automatically call the callback
})
third_person:bindToEvent('onToggle', function(newState) -- Call a function when toggled
    onThirdPerson();
end)

local modulation_enabled = modulation:addToggle({
    text = 'Modulation', 
    state = false -- Starting state of the toggle - doesn't automatically call the callback
})
modulation_enabled:bindToEvent('onToggle', function(newState) -- Call a function when toggled
    onModulation();
end)

modulation:addSlider({
    text = 'Brightness',
    min = 0,
    max = 255,
    step = 1,
    val = 1
}, function(newValue) 
    bright = newValue
end)
modulation:addSlider({
    text = 'World Time',
    min = 0,
    max = 23,
    step = 1,
    val = 1
}, function(newValue) 
    clocktime = newValue
end)

modulation:addSlider({
    text = 'Sun & Moon Size',
    min = 0,
    max = 30,
    step = 1,
    val = 1
}, function(newValue) 
    moon_sun_size = newValue
end)
local ambient_enabled = modulation:addToggle({
    text = 'Ambient', 
    state = false -- Starting state of the toggle - doesn't automatically call the callback
})
ambient_enabled:bindToEvent('onToggle', function(newState) -- Call a function when toggled
    onAmbient();
end)
modulation:addSlider({
    text = 'Red',
    min = 1,
    max = 255,
    step = 1,
    val = 1
}, function(newValue) 
    amb_r = newValue
end)
modulation:addSlider({
    text = 'Green',
    min = 1,
    max = 255,
    step = 1,
    val = 1
}, function(newValue) 
    amb_g = newValue
end)
modulation:addSlider({
    text = 'Blue',
    min = 1,
    max = 255,
    step = 1,
    val = 1
}, function(newValue) 
    amb_b = newValue
end)
itemsmanip:addButton({
    text = 'Set Spawn Position', 
    style = 'large' -- style of the button, can be 'large' or 'small'
}, newcclosure(function() -- you don't have to always use bindToEvent, just passing a callback normally works fine
    saved_camera_cframe = camera.CFrame;
    saved_rotation_part = workspace.RotateOrientPart.Orientation
end))
itemsmanip:addButton({
    text = 'Reset Spawn Position', 
    style = 'large' -- style of the button, can be 'large' or 'small'
}, newcclosure(function() -- you don't have to always use bindToEvent, just passing a callback normally works fine
    saved_camera_cframe = nil
    saved_rotation_part = nil
end))
local force_thing_spawn = items_other:addToggle({
    text = 'Force Spawn', 
    state = false -- Starting state of the toggle - doesn't automatically call the callback
})
force_thing_spawn:bindToEvent('onToggle', function(newState) -- Call a function when toggled
    onForceSpawn();
end)

local setpos_aura = playerposition:addToggle({
    text = 'SetPos Fling', 
    state = false -- Starting state of the toggle - doesn't automatically call the callback
})
setpos_aura:bindToEvent('onToggle', function(newState) -- Call a function when toggled
    onSetPosFling();
end)

local setpos_aura = playerposition:addToggle({
    text = 'SetPos Aura', 
    state = false -- Starting state of the toggle - doesn't automatically call the callback
})
setpos_aura:bindToEvent('onToggle', function(newState) -- Call a function when toggled
    onSetPosAura();
end)
local setpos_aura_check_things = playerposition:addToggle({
    text = 'Ignore Things', 
    state = false -- Starting state of the toggle - doesn't automatically call the callback
})
setpos_aura_check_things:bindToEvent('onToggle', function(newState) -- Call a function when toggled
    thing_checking_setposar = newState
end)
local setpos_aura_check_people = playerposition:addToggle({
    text = 'Ignore People', 
    state = false -- Starting state of the toggle - doesn't automatically call the callback
})
setpos_aura_check_people:bindToEvent('onToggle', function(newState) -- Call a function when toggled
    people_checking_setposar = newState
end)
playerposition:addSlider({
    text = 'Radius',
    min = 1,
    max = 40,
    step = 1,
    val = 1
}, function(newValue) 
    setpos_radius = newValue
end)
playerposition:addButton({
    text = 'Set Position', 
    style = 'large' -- style of the button, can be 'large' or 'small'
}, newcclosure(function() -- you don't have to always use bindToEvent, just passing a callback normally works fine
    getgenv().whitelist = true
    setposition = plr.Character.HumanoidRootPart.CFrame

    getgenv().whitelist = false
end))
local mouse_icon_enabled = tools_other:addToggle({
    text = 'Mouse Icon Enabled', 
    state = false -- Starting state of the toggle - doesn't automatically call the callback
})
mouse_icon_enabled:bindToEvent('onToggle', function(newState) -- Call a function when toggled
    onMouseIcon();
end)

initializeGlobalEventHook();
initializeGlobalItemsHookEvents();]]();
