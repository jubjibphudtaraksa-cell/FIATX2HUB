local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🎄 | Street Life Remastered",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Street Life Remastered 🔫🌴",
   LoadingSubtitle = "by Rezux",
   ShowText = "Rezux", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Serenity", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Rezux Studios"
   },

   Discord = {
      Enabled = true, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "YbBH9NdBrv", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Rezux Studios",
      Subtitle = "Key System",
      Note = "Get key access from discord", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = true, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"https://pastebin.com/raw/6vJyqPqZ"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

Rayfield:Notify({
   Title = "Executed",
   Content = "Checkout all different features",
   Duration = 4.5,
   Image = nil,
})

local MiscTab = Window:CreateTab("Misc", nil) -- Title, Image
local Section = MiscTab:CreateSection("Main")

local Toggle = MiscTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Flag = "Inf Jump", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        --[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
local InfiniteJumpEnabled = true
game:GetService("UserInputService").JumpRequest:connect(function()
	if InfiniteJumpEnabled then
		game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
	end
end)
   end,
})

local Slider = MiscTab:CreateSlider({
   Name = "Walk Speed",
   Range = {0, 100},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = (Value)
   end,
})

-- Assuming MiscTab already exists

local flying = false
local speed = 60 -- Default speed
local bodyGyro
local bodyVelocity
local keys = {W=false, A=false, S=false, D=false, Space=false, Ctrl=false}

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- Start flying function
local function startFly()
    flying = true
    humanoid.PlatformStand = true

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.P = 9e4
    bodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9)
    bodyGyro.CFrame = humanoidRootPart.CFrame
    bodyGyro.Parent = humanoidRootPart

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.MaxForce = Vector3.new(9e9,9e9,9e9)
    bodyVelocity.Parent = humanoidRootPart
end

-- Stop flying function
local function stopFly()
    flying = false
    humanoid.PlatformStand = false
    if bodyGyro then bodyGyro:Destroy() end
    if bodyVelocity then bodyVelocity:Destroy() end
end

-- Fly Toggle
local FlyToggle = MiscTab:CreateToggle({
   Name = "Fly",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(Value)
       if Value then
           startFly()
       else
           stopFly()
       end
   end,
})

-- Fly Speed Slider
local FlySpeedSlider = MiscTab:CreateSlider({
    Name = "Fly Speed",
    Range = {10, 500},
    Increment = 5,
    Suffix = "Speed",
    CurrentValue = speed,
    Flag = "FlySpeed",
    Callback = function(Value)
        speed = Value -- Update speed dynamically
    end,
})

-- Input handling for movement
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if keys[input.KeyCode.Name] ~= nil then
        keys[input.KeyCode.Name] = true
    end
    if input.KeyCode == Enum.KeyCode.LeftControl then keys.Ctrl = true end
end)

UserInputService.InputEnded:Connect(function(input)
    if keys[input.KeyCode.Name] ~= nil then
        keys[input.KeyCode.Name] = false
    end
    if input.KeyCode == Enum.KeyCode.LeftControl then keys.Ctrl = false end
end)

-- Fly movement loop
RunService.RenderStepped:Connect(function()
    if not flying then return end
    local cam = workspace.CurrentCamera
    local direction = Vector3.zero

    if keys.W then direction += cam.CFrame.LookVector end
    if keys.S then direction -= cam.CFrame.LookVector end
    if keys.A then direction -= cam.CFrame.RightVector end
    if keys.D then direction += cam.CFrame.RightVector end
    if keys.Space then direction += Vector3.new(0,1,0) end
    if keys.Ctrl then direction -= Vector3.new(0,1,0) end

    if direction.Magnitude > 0 then
        direction = direction.Unit * speed
    end

    if bodyVelocity and bodyGyro then
        bodyVelocity.Velocity = direction
        bodyGyro.CFrame = cam.CFrame
    end
end)

-- Assuming MiscTab already exists
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local RunService = game:GetService("RunService")

local noclipEnabled = false

local function enableNoclip()
    noclipEnabled = true
end

local function disableNoclip()
    noclipEnabled = false
    -- Ensure collisions are restored
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- Rayfield toggle
local NoclipToggle = MiscTab:CreateToggle({
    Name = "NoClip",
    CurrentValue = false,
    Flag = "NoClipToggle",
    Callback = function(Value)
        if Value then
            enableNoclip()
        else
            disableNoclip()
        end
    end,
})

-- Reliable NoClip loop
RunService.Stepped:Connect(function()
    if noclipEnabled and character and humanoid and humanoid.Health > 0 then
        humanoid:ChangeState(Enum.HumanoidStateType.Physics) -- Or PlatformStand = true
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Assuming you already have Rayfield loaded and a Window created
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Create ESP Tab
local ESPTab = Window:CreateTab("ESP", nil) -- Optional icon

-- ESP settings
local ESPEnabled = false
local boxesEnabled = false
local tracersEnabled = false
local charmsEnabled = false
local ESPObjects = {}

-- Colors
local BoxColor = Color3.fromRGB(0, 255, 0)
local TracerColor = Color3.fromRGB(255, 0, 0)

-- Create ESP for a player
local function createESP(player)
    if player == LocalPlayer then return end
    if ESPObjects[player] then return end

    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    -- Box
    local box
    if boxesEnabled then
        box = Instance.new("BoxHandleAdornment")
        box.Adornee = character.HumanoidRootPart
        box.AlwaysOnTop = true
        box.ZIndex = 10
        box.Size = Vector3.new(2, 5, 1)
        box.Color3 = BoxColor
        box.Transparency = 0.5
        box.Parent = workspace
    end

    -- Tracer
    local line
    if tracersEnabled and ESPEnabled then
        line = Drawing.new("Line")
        line.Color = TracerColor
        line.Thickness = 1.5
        line.Visible = true
    end

    -- Charms (thin black outline only)
    local charmsParts = {}
    if charmsEnabled then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                local highlight = Instance.new("Highlight")
                highlight.Adornee = part
                highlight.FillTransparency = 1               -- No fill
                highlight.OutlineColor = Color3.new(0,0,0)  -- Black outline
                highlight.OutlineTransparency = 0           -- Fully visible
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.Parent = part
                table.insert(charmsParts, highlight)
            end
        end
    end

    ESPObjects[player] = {Box = box, Tracer = line, Charms = charmsParts}
end

-- Remove ESP
local function removeESP(player)
    if ESPObjects[player] then
        if ESPObjects[player].Box then ESPObjects[player].Box:Destroy() end
        if ESPObjects[player].Tracer then ESPObjects[player].Tracer:Remove() end
        if ESPObjects[player].Charms then
            for _, highlight in pairs(ESPObjects[player].Charms) do
                if highlight then highlight:Destroy() end
            end
        end
        ESPObjects[player] = nil
    end
end

-- Enable ESP toggle
ESPTab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = false,
    Flag = "ESPEnabled",
    Callback = function(Value)
        ESPEnabled = Value
        if not Value then
            for _, data in pairs(ESPObjects) do
                if data.Box then data.Box:Destroy() end
                if data.Tracer then data.Tracer:Remove() end
                if data.Charms then
                    for _, highlight in pairs(data.Charms) do
                        if highlight then highlight:Destroy() end
                    end
                end
            end
            ESPObjects = {}
        end
    end,
})

-- Boxes toggle
ESPTab:CreateToggle({
    Name = "Boxes",
    CurrentValue = false,
    Flag = "BoxesToggle",
    Callback = function(Value)
        boxesEnabled = Value
        for player, data in pairs(ESPObjects) do
            if Value and not data.Box and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local box = Instance.new("BoxHandleAdornment")
                box.Adornee = player.Character.HumanoidRootPart
                box.AlwaysOnTop = true
                box.ZIndex = 10
                box.Size = Vector3.new(2, 5, 1)
                box.Color3 = BoxColor
                box.Transparency = 0.5
                box.Parent = workspace
                data.Box = box
            elseif not Value and data.Box then
                data.Box:Destroy()
                data.Box = nil
            end
        end
    end,
})

-- Tracers toggle
ESPTab:CreateToggle({
    Name = "Tracers",
    CurrentValue = false,
    Flag = "TracersToggle",
    Callback = function(Value)
        tracersEnabled = Value
        for player, data in pairs(ESPObjects) do
            if Value and ESPEnabled and not data.Tracer then
                local line = Drawing.new("Line")
                line.Color = TracerColor
                line.Thickness = 1.5
                line.Visible = true
                data.Tracer = line
            elseif not Value and data.Tracer then
                data.Tracer:Remove()
                data.Tracer = nil
            end
        end
    end,
})

-- Charms toggle
ESPTab:CreateToggle({
    Name = "Charms",
    CurrentValue = false,
    Flag = "CharmsToggle",
    Callback = function(Value)
        charmsEnabled = Value
        for player, data in pairs(ESPObjects) do
            -- Remove existing charms
            if data.Charms then
                for _, highlight in pairs(data.Charms) do
                    if highlight then highlight:Destroy() end
                end
                data.Charms = {}
            end
            -- Add charms if enabled
            if Value and player.Character then
                local charmsParts = {}
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        local highlight = Instance.new("Highlight")
                        highlight.Adornee = part
                        highlight.FillTransparency = 1               -- No fill
                        highlight.OutlineColor = Color3.new(0,0,0)  -- Black outline
                        highlight.OutlineTransparency = 0           -- Fully visible
                        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        highlight.Parent = part
                        table.insert(charmsParts, highlight)
                    end
                end
                data.Charms = charmsParts
            end
        end
    end,
})

-- Update ESP each frame
RunService.RenderStepped:Connect(function()
    if ESPEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                if not ESPObjects[player] then
                    createESP(player)
                else
                    local hrp = player.Character.HumanoidRootPart
                    if ESPObjects[player].Box then
                        ESPObjects[player].Box.Adornee = hrp
                    end
                    if ESPObjects[player].Tracer then
                        local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                        if onScreen then
                            ESPObjects[player].Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                            ESPObjects[player].Tracer.To = Vector2.new(vector.X, vector.Y)
                            ESPObjects[player].Tracer.Visible = true
                        else
                            ESPObjects[player].Tracer.Visible = false
                        end
                    end
                end
            else
                removeESP(player)
            end
        end
    else
        for player, data in pairs(ESPObjects) do
            removeESP(player)
        end
    end
end)

-- Remove ESP when players leave
Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- AIMBOT TAB
local AimbotTab = Window:CreateTab("Aimbot", nil)

-- SETTINGS
local AimbotEnabled = false
local FOVRadius = 150
local AimSmoothness = 0.15
local MaxDistance = 1000 -- studs

-- FOV CIRCLE
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.NumSides = 100
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Filled = false
FOVCircle.Visible = false

-- GET CLOSEST TARGET (LOCK-ON DISTANCE FIXED)
local function getClosestTarget()
    local closestPlayer = nil
    local shortestScreenDistance = math.huge
    local mousePos = UserInputService:GetMouseLocation()

    local character = LocalPlayer.Character
    if not character then return end

    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local head = char:FindFirstChild("Head")
            local humanoid = char:FindFirstChild("Humanoid")

            if head and humanoid and humanoid.Health > 0 then
                -- WORLD DISTANCE CHECK (THIS IS WHAT YOUR SLIDER CONTROLS)
                local worldDistance = (head.Position - hrp.Position).Magnitude
                if worldDistance <= MaxDistance then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local screenDistance =
                            (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude

                        if screenDistance <= FOVRadius and screenDistance < shortestScreenDistance then
                            shortestScreenDistance = screenDistance
                            closestPlayer = player
                        end
                    end
                end
            end
        end
    end

    return closestPlayer
end

-- AIMBOT LOOP (SINGLE LOOP ONLY)
RunService.RenderStepped:Connect(function()
    FOVCircle.Visible = AimbotEnabled
    if not AimbotEnabled then return end

    local mousePos = UserInputService:GetMouseLocation()
    FOVCircle.Position = mousePos
    FOVCircle.Radius = FOVRadius

    if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = getClosestTarget()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local head = target.Character.Head
            local camPos = Camera.CFrame.Position
            local aimPos = head.Position + Vector3.new(0, 0.5, 0)

            local targetCFrame = CFrame.new(camPos, aimPos)
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, AimSmoothness)
        end
    end
end)

-- UI CONTROLS
AimbotTab:CreateToggle({
    Name = "Enable Aimbot",
    CurrentValue = false,
    Flag = "AimbotToggle",
    Callback = function(Value)
        AimbotEnabled = Value
        FOVCircle.Visible = Value
    end,
})

AimbotTab:CreateSlider({
    Name = "FOV Size",
    Range = {50, 500},
    Increment = 10,
    Suffix = "px",
    CurrentValue = FOVRadius,
    Flag = "AimbotFOV",
    Callback = function(Value)
        FOVRadius = Value
    end,
})

AimbotTab:CreateSlider({
    Name = "Smoothness",
    Range = {0.01, 1},
    Increment = 0.01,
    CurrentValue = AimSmoothness,
    Flag = "AimbotSmoothness",
    Callback = function(Value)
        AimSmoothness = Value
    end,
})

AimbotTab:CreateSlider({
    Name = "Lock-on Distance",
    Range = {50, 2000},
    Increment = 10,
    Suffix = "studs",
    CurrentValue = MaxDistance,
    Flag = "AimbotMaxDistance",
    Callback = function(Value)
        MaxDistance = Value
    end,
})


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local NORMAL_JUMP_POWER = 50
local SUPER_JUMP_POWER = 120 -- fixed jump power
local SuperJumpEnabled = false

-- Apply jump to character
local function ApplyJump(character)
    local humanoid = character:WaitForChild("Humanoid", 5)
    if humanoid then
        humanoid.UseJumpPower = true
        humanoid.JumpPower = SuperJumpEnabled and SUPER_JUMP_POWER or NORMAL_JUMP_POWER
    end
end

-- Apply on respawn
LocalPlayer.CharacterAdded:Connect(ApplyJump)
if LocalPlayer.Character then
    ApplyJump(LocalPlayer.Character)
end

-- Toggle in Misc tab
local Toggle = MiscTab:CreateToggle({
    Name = "Super Jump",
    CurrentValue = false,
    Flag = "SuperJumpToggle",
    Callback = function(Value)
        SuperJumpEnabled = Value
        if LocalPlayer.Character then
            ApplyJump(LocalPlayer.Character)
        end
    end,
})

-- SERVICES (only add if not already defined)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- PLAYER TAG SETTINGS
local PlayerTagsEnabled = false
local PlayerTags = {}

-- CREATE TAG
local function createPlayerTag(player)
    if player == LocalPlayer then return end
    if PlayerTags[player] then return end
    if not player.Character or not player.Character:FindFirstChild("Head") then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "PlayerTag"
    billboard.Adornee = player.Character.Head
    billboard.Size = UDim2.new(0, 50, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = player.Name
    label.TextScaled = true
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard

    billboard.Parent = player.Character.Head
    PlayerTags[player] = billboard
end

-- REMOVE TAG
local function removePlayerTag(player)
    if PlayerTags[player] then
        PlayerTags[player]:Destroy()
        PlayerTags[player] = nil
    end
end

-- UPDATE LOOP
RunService.RenderStepped:Connect(function()
    if not PlayerTagsEnabled then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            if not PlayerTags[player] then
                createPlayerTag(player)
            end
        else
            removePlayerTag(player)
        end
    end
end)

Players.PlayerRemoving:Connect(removePlayerTag)

-- TOGGLE (USES YOUR EXISTING AIMBOT TAB)
ESPTab:CreateToggle({
    Name = "Player Tags",
    CurrentValue = false,
    Flag = "PlayerTags",
    Callback = function(Value)
        PlayerTagsEnabled = Value

        if not Value then
            for player in pairs(PlayerTags) do
                removePlayerTag(player)
            end
        end
    end,
})

-- PLAYER HEALTH BARS UNDER ESP TAB
local HealthBarsEnabled = false
local PlayerHealthBars = {}

local function createHealthBar(player)
    if player == LocalPlayer then return end
    if PlayerHealthBars[player] then return end
    if not player.Character or not player.Character:FindFirstChild("Humanoid") then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "HealthBar"
    billboard.Adornee = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Head")
    billboard.Size = UDim2.new(0, 50, 0, 6)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, 0, 1, 0)
    bar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    bar.BorderSizePixel = 0
    bar.Parent = billboard

    billboard.Parent = player.Character

    PlayerHealthBars[player] = {Billboard = billboard, Bar = bar}

    local humanoid = player.Character:FindFirstChild("Humanoid")
    if humanoid then
        RunService.RenderStepped:Connect(function()
            if HealthBarsEnabled and PlayerHealthBars[player] and humanoid.Health > 0 then
                local healthPercent = humanoid.Health / humanoid.MaxHealth
                PlayerHealthBars[player].Bar.Size = UDim2.new(healthPercent, 0, 1, 0)

                if healthPercent > 0.6 then
                    PlayerHealthBars[player].Bar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                elseif healthPercent > 0.3 then
                    PlayerHealthBars[player].Bar.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
                else
                    PlayerHealthBars[player].Bar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                end
            end
        end)
    end
end

local function removeHealthBar(player)
    if PlayerHealthBars[player] then
        PlayerHealthBars[player].Billboard:Destroy()
        PlayerHealthBars[player] = nil
    end
end

-- Toggle in ESP tab
ESPTab:CreateToggle({
    Name = "Player Health Bars",
    CurrentValue = false,
    Flag = "HealthBarsToggle",
    Callback = function(Value)
        HealthBarsEnabled = Value
        if not Value then
            for player, _ in pairs(PlayerHealthBars) do
                removeHealthBar(player)
            end
        else
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    createHealthBar(player)
                end
            end
        end
    end
})

-- Update health bars on player added/respawn
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if HealthBarsEnabled then
            createHealthBar(player)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    removeHealthBar(player)
end)
