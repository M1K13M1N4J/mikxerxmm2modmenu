-- Advanced Roblox Mod Menu with ESP, Speed, Jump, Draggable UI, Kill Aura, Teleport

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "ModMenu"
gui.ResetOnSpawn = false
gui.Parent = lp:WaitForChild("PlayerGui")

-- Create a frame for the menu
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 350)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(0, 0, 255) -- Blue border
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Create a close button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 20
closeButton.Parent = frame
closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Create a button with text
local function createButton(name, y, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 18
    btn.Parent = frame
    btn.MouseButton1Click:Connect(callback)
end

-- Create input box for speed and jump customization
local function createBox(name, y, default, callback)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -20, 0, 30)
    box.Position = UDim2.new(0, 10, 0, y)
    box.Text = tostring(default)
    box.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.ClearTextOnFocus = false
    box.Font = Enum.Font.SourceSans
    box.TextSize = 18
    box.Parent = frame
    box.FocusLost:Connect(function()
        local val = tonumber(box.Text)
        if val then callback(val) end
    end)
end

-- Toggles for various features
local godMode = false
local flying = false
local noclip = false
local espEnabled = false
local infiniteJump = false
local killAuraEnabled = false
local teleportToMouse = false

local function toggleGodMode()
    godMode = not godMode
    local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
    if hum and godMode then
        hum.Health = hum.MaxHealth
        hum:GetPropertyChangedSignal("Health"):Connect(function()
            if godMode then hum.Health = hum.MaxHealth end
        end)
    end
end

local function toggleFly()
    flying = not flying
    local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if flying and root then
        local bv = Instance.new("BodyVelocity")
        bv.Velocity = Vector3.new(0, 50, 0)
        bv.MaxForce = Vector3.new(0, math.huge, 0)
        bv.Name = "FlyForce"
        bv.Parent = root
        flyConn = RunService.RenderStepped:Connect(function()
            if root then root.Velocity = Vector3.new(0, 50, 0) end
        end)
    else
        if flyConn then flyConn:Disconnect() end
        local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local bv = root:FindFirstChild("FlyForce")
            if bv then bv:Destroy() end
        end
    end
end

local function toggleNoClip()
    noclip = not noclip
    if noclipConn then noclipConn:Disconnect() end
    noclipConn = RunService.Stepped:Connect(function()
        if noclip and lp.Character then
            for _, v in pairs(lp.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
    end)
end

local function toggleESP()
    espEnabled = not espEnabled
    -- Cleanup
    for _, v in pairs(espObjects) do if v and v.Adornee then v:Destroy() end end
    espObjects = {}

    if espEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local highlight = Instance.new("Highlight")
                highlight.Adornee = p.Character
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.Parent = p.Character
                table.insert(espObjects, highlight)
            end
        end
    end
end

local function teleportToPlayer()
    teleportToMouse = not teleportToMouse
    if teleportToMouse then
        local mouse = lp:GetMouse()
        local targetPosition = mouse.Hit.p
        lp.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
    end
end

local function killAura()
    killAuraEnabled = not killAuraEnabled
    -- Will kill nearby players/NPCs
    if killAuraEnabled then
        while killAuraEnabled do
            for _, target in pairs(Players:GetPlayers()) do
                if target ~= lp and target.Character and target.Character:FindFirstChild("Humanoid") then
                    local hum = target.Character:FindFirstChild("Humanoid")
                    if hum then
                        hum.Health = 0 -- instantly kills the target
                    end
                end
            end
            wait(1)
        end
    end
end

local function infiniteJumpToggle()
    infiniteJump = not infiniteJump
    local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.JumpPower = infiniteJump and 100 or 50 -- change as needed
    end
end

-- Add buttons to menu
createButton("Created by Mikxerx")
createButton("Toggle God Mode", 10, toggleGodMode)
createButton("Toggle Fly", 50, toggleFly)
createButton("Toggle No Clip", 90, toggleNoClip)
createButton("Toggle ESP", 130, toggleESP)
createButton("Teleport to Mouse", 170, teleportToPlayer)
createButton("Toggle Kill Aura", 210, killAura)
createButton("Toggle Infinite Jump", 250, infiniteJumpToggle)

-- Speed and Jump customization
createLabel("Speed and Jump:", 290)
createBox("Speed", 315, 16, function(val)
    local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = val end
end)

createBox("Jump", 350, 50, function(val)
    local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.JumpPower = val end
end)

-- Keybind to toggle menu (Right Alt)
local userInputService = game:GetService("UserInputService")
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightAlt then
        if gui.Enabled then
            gui.Enabled = false
        else
            gui.Enabled = true
        end
    end
end)

