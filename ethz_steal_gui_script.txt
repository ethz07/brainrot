-- ethz Steal Script - Keyless & Custom GUI
-- Features: TP to Base (DeliverBrainrot), Tween Steal, ESP placeholders

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local random = Random.new()

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ethzStealScript"
gui.ResetOnSpawn = false

-- Frame
local frame = Instance.new("Frame", gui)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Size = UDim2.new(0, 250, 0, 340)
frame.Position = UDim2.new(0, 20, 0.5, -170)
frame.AnchorPoint = Vector2.new(0, 0.5)
frame.BorderSizePixel = 0

-- Title
local title = Instance.new("TextLabel", frame)
title.Text = "ethz Steal Script"
title.Font = Enum.Font.FredokaOne
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 20
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1

-- Footer
local footer = Instance.new("TextLabel", frame)
footer.Text = "made by _ethz on discord"
footer.Font = Enum.Font.FredokaOne
footer.TextColor3 = Color3.fromRGB(150, 150, 150)
footer.TextSize = 13
footer.Position = UDim2.new(0, 0, 1, -20)
footer.Size = UDim2.new(1, 0, 0, 20)
footer.BackgroundTransparency = 1

-- Function to create buttons
local function createButton(name, y)
    local btn = Instance.new("TextButton", frame)
    btn.Text = name
    btn.Font = Enum.Font.FredokaOne
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(0, 32, 96)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BorderSizePixel = 0
    return btn
end

-- DeliverBrainrot (TP to Base)
local function DeliverBrainrot()
    for _, plot in ipairs(workspace.Plots:GetChildren()) do
        local sign = plot:FindFirstChild("PlotSign")
        if sign and sign:FindFirstChild("YourBase") and sign.YourBase.Enabled then
            local hitbox = plot:FindFirstChild("DeliveryHitbox")
            if hitbox then
                local tpAmt = math.clamp(math.floor(player:GetNetworkPing()*1000*0.8), 10, 150)
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
            end
        end
    end
end

-- TweenSteal
local function TweenSteal()
    local TELEPORT_ITERATIONS = 85
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
end

-- Buttons
local btn1 = createButton("TP to Base", 50)
btn1.MouseButton1Click:Connect(DeliverBrainrot)

local btn2 = createButton("Tween Steal", 95)
btn2.MouseButton1Click:Connect(TweenSteal)

createButton("ESP Player", 140)
createButton("ESP Brainrots", 185)
