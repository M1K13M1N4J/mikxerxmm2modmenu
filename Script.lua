-- Simple Roblox Mod Menu by You!

-- Create Screen GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ModMenu"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

-- Create Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Parent = gui

-- Create Toggle Buttons
local function createButton(name, y, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Parent = frame
    btn.MouseButton1Click:Connect(callback)
end

-- God Mode Toggle
local godEnabled = false
createButton("Toggle God Mode", 10, function()
    godEnabled = not godEnabled
    local char = game.Players.LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:GetPropertyChangedSignal("Health"):Connect(function()
                if godEnabled then
                    hum.Health = hum.MaxHealth
                end
            end)
            hum.Health = hum.MaxHealth
        end
    end
end)

-- Fly Toggle
local flying = false
local flyConn
createButton("Toggle Fly", 50, function()
    flying = not flying
    local char = game.Players.LocalPlayer.Character
    if flying and char then
        local root = char:FindFirstChild("HumanoidRootPart")
        local bv = Instance.new("BodyVelocity")
        bv.Velocity = Vector3.new(0, 50, 0)
        bv.MaxForce = Vector3.new(0, math.huge, 0)
        bv.Parent = root
        flyConn = game:GetService("RunService").RenderStepped:Connect(function()
            if root then
                root.Velocity = Vector3.new(0, 50, 0)
            end
        end)
    else
        if flyConn then flyConn:Disconnect() end
        local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            for _, v in pairs(root:GetChildren()) do
                if v:IsA("BodyVelocity") then
                    v:Destroy()
                end
            end
        end
    end
end)

-- No Clip Toggle
local noclip = false
local noclipConn
createButton("Toggle No Clip", 90, function()
    noclip = not noclip
    local player = game.Players.LocalPlayer
    noclipConn = game:GetService("RunService").Stepped:Connect(function()
        if noclip and player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end)
end)
