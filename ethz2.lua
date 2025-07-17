-- ethz Steal Script - Final Enhanced Version (Arbix Style GUI)
-- by _ethz

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local random = Random.new()

local tpAmt = 150
local MAX_DISTANCE_OK = 60
local TELEPORT_ITERATIONS = 110

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ethzStealGUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 230, 0, 210)
frame.Position = UDim2.new(0.5, -115, 0.45, 0) -- ortalanmış
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Parent = gui

local dragging, dragInput, dragStart, startPos = false, nil, nil, nil

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 10)

-- Title Bar
local titleBar = Instance.new("Frame", frame)
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
titleBar.BorderSizePixel = 0
titleBar.Active = true
titleBar.Draggable = true
titleBar.Parent = frame
local titleCorner = Instance.new("UICorner", titleBar)
titleCorner.CornerRadius = UDim.new(0, 10)

-- Title
local title = Instance.new("TextLabel", titleBar)
title.Text = "ethz Script"
title.Font = Enum.Font.FredokaOne
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 18
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left

-- Buttons
local buttonFrame = Instance.new("Frame", titleBar)
buttonFrame.Size = UDim2.new(0, 60, 1, 0)
buttonFrame.Position = UDim2.new(1, -60, 0, 0)
buttonFrame.BackgroundTransparency = 1

local minimizeButton = Instance.new("TextButton", buttonFrame)
minimizeButton.Text = "-"
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 18
minimizeButton.TextColor3 = Color3.new(1, 1, 0)
minimizeButton.Size = UDim2.new(0.5, 0, 1, 0)
minimizeButton.BackgroundTransparency = 1

local closeButton = Instance.new("TextButton", buttonFrame)
closeButton.Text = "X"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 18
closeButton.TextColor3 = Color3.new(1, 0.2, 0.2)
closeButton.Size = UDim2.new(0.5, 0, 1, 0)
closeButton.Position = UDim2.new(0.5, 0, 0, 0)
closeButton.BackgroundTransparency = 1

-- Content
local content = Instance.new("Frame", frame)
content.Size = UDim2.new(1, 0, 1, -35)
content.Position = UDim2.new(0, 0, 0, 35)
content.BackgroundTransparency = 1

-- Create Button
local function createButton(text, index)
    local btn = Instance.new("TextButton", content)
    btn.Text = text
    btn.TextSize = 15
    btn.Font = Enum.Font.FredokaOne
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = Color3.fromRGB(0, 32, 96)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, (index - 1) * 45)
    btn.BorderSizePixel = 0
    local c = Instance.new("UICorner", btn)
    c.CornerRadius = UDim.new(0, 8)
    return btn
end

-- TP to Base
local function DeliverBrainrot()
    for _, plot in ipairs(workspace.Plots:GetChildren()) do
        local sign = plot:FindFirstChild("PlotSign")
        if sign and sign:FindFirstChild("YourBase") and sign.YourBase.Enabled then
            local hitbox = plot:FindFirstChild("DeliveryHitbox")
            if hitbox then
                for i = 1, tpAmt do
                    hrp.CFrame = hitbox.CFrame * CFrame.new(0, -3, 0)
                    RunService.Heartbeat:Wait()
                end
                for _ = 1, 2 do
                    hrp.CFrame = CFrame.new(0, -3e38, 0)
                    RunService.Heartbeat:Wait()
                end
                for i = 1, math.floor(tpAmt / 16) do
                    hrp.CFrame = hitbox.CFrame * CFrame.new(0, -3, 0)
                    RunService.Heartbeat:Wait()
                end
                local dist = (hrp.Position - hitbox.Position).Magnitude
                print(dist <= MAX_DISTANCE_OK and "[TP]: ✅ Başarılı" or "[TP]: ❌ Uzakta ("..math.floor(dist)..")")
            end
        end
    end
end

-- Tween Steal
local function TweenSteal()
    local JITTER = 0.0002
    local delivery
    for _, v in ipairs(workspace.Plots:GetDescendants()) do
        if v.Name == "DeliveryHitbox" and v.Parent:FindFirstChild("PlotSign") and v.Parent.PlotSign:FindFirstChild("YourBase") and v.Parent.PlotSign.YourBase.Enabled then
            delivery = v
            break
        end
    end
    if not delivery then return end
    local target = delivery.CFrame * CFrame.new(0, random:NextInteger(-3, -1), 0)
    local start = hrp.Position
    for i = 1, TELEPORT_ITERATIONS do
        local progress = i / TELEPORT_ITERATIONS
        local curve = progress * progress * (3 - 2 * progress)
        local newPos = start:Lerp(target.Position, curve) + Vector3.new(
            random:NextNumber(-JITTER, JITTER),
            random:NextNumber(-JITTER, JITTER),
            random:NextNumber(-JITTER, JITTER)
        )
        hrp.CFrame = CFrame.new(newPos) * (hrp.CFrame - hrp.Position)
        RunService.Heartbeat:Wait()
    end
    for _ = 1, 3 do
        hrp.CFrame = CFrame.new(0, -3e38, 0)
        RunService.Heartbeat:Wait()
        hrp.CFrame = target
        RunService.Heartbeat:Wait()
    end
    local dist = (hrp.Position - target.Position).Magnitude
    print(dist <= MAX_DISTANCE_OK and "[Tween]: ✅ Başarılı" or "[Tween]: ❌ Uzakta ("..math.floor(dist)..")")
end

-- Butonlar
local b1 = createButton("TP to Base", 1)
b1.MouseButton1Click:Connect(DeliverBrainrot)

local b2 = createButton("Tween Steal", 2)
b2.MouseButton1Click:Connect(TweenSteal)

createButton("ESP Player (yakında)", 3)
createButton("ESP Brainrots (yakında)", 4)

-- Minimize/Kapat
local minimized = false
minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    frame.Size = minimized and UDim2.new(0, 230, 0, 35) or UDim2.new(0, 230, 0, 210)
end)

closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

print("👁️")
