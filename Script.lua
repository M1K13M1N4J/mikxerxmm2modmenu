-- Advanced Roblox Mod Menu with ESP, Speed, Jump, Draggable UI

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "ModMenu"
gui.ResetOnSpawn = false
gui.Parent = lp:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 280)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local function createLabel(text, y)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 25)
    label.Position = UDim2.new(0, 10, 0, y)
    label.Text = text
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.SourceSans
    label.TextSize = 18
    label.Parent = frame
end

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

-- God Mode
local godMode = false
createButton("Toggle God Mode", 10, function()
    godMode = not godMode
    local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
    if hum and godMode then
        hum.Health = hum.MaxHealth
        hum:GetPropertyChangedSignal("Health"):Connect(function()
            if godMode then hum.Health = hum.MaxHealth end
        end)
    end
end)

-- Fly
local flying = false
local flyConn
createButton("Toggle Fly", 50, function()
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
end)

-- No Clip
local noclip = false
local noclipConn
createButton("Toggle No Clip", 90, function()
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
end)

-- ESP
local espEnabled = false
local espObjects = {}

createButton("Toggle ESP", 130, function()
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
end)

-- Speed customization
createLabel("WalkSpeed:", 170)
createBox("Speed", 195, 16, function(val)
    local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = val end
end)

-- Jump customization
createLabel("JumpPower:", 225)
createBox("Jump", 250, 50, function(val)
    local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.JumpPower = val end
end)

