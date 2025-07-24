--🔄 NOTIFICATION SYSTEM - FULLY RGB INTEGRATED local TweenService = game:GetService("TweenService") local RunService = game:GetService("RunService") local Players = game:GetService("Players") local player = Players.LocalPlayer

local hue = 0 local activeNotifications = {}

function showNotification(message, duration) duration = duration or 4

local notifGui = player:WaitForChild("PlayerGui"):FindFirstChild("AdvancedNotificationGui")
if not notifGui then
	notifGui = Instance.new("ScreenGui")
	notifGui.Name = "AdvancedNotificationGui"
	notifGui.ResetOnSpawn = false
	notifGui.IgnoreGuiInset = true
	notifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	notifGui.Parent = player:WaitForChild("PlayerGui")
end

local notifFrame = Instance.new("Frame")
notifFrame.Size = UDim2.new(0, 280, 0, 60)
notifFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
notifFrame.BackgroundTransparency = 0.1
notifFrame.AnchorPoint = Vector2.new(1, 0)
notifFrame.Position = UDim2.new(1, 300, 0, 20)
notifFrame.ZIndex = 1000
notifFrame.Parent = notifGui

local corner = Instance.new("UICorner", notifFrame)
corner.CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", notifFrame)
stroke.Thickness = 2
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Color = Color3.fromHSV(hue, 1, 1)
stroke.Name = "RGBStroke"

local titleLabel = Instance.new("TextLabel", notifFrame)
titleLabel.Size = UDim2.new(0, 130, 0, 20)
titleLabel.Position = UDim2.new(0, 10, 0, 5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Renz Notify"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 15
titleLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 1001
titleLabel.Name = "RGBTitle"

local label = Instance.new("TextLabel", notifFrame)
label.Size = UDim2.new(1, -30, 0, 40)
label.Position = UDim2.new(0, 10, 0, 25)
label.BackgroundTransparency = 1
label.Text = message
label.Font = Enum.Font.Gotham
label.TextSize = 13
label.TextColor3 = Color3.new(1, 1, 1)
label.TextWrapped = true
label.TextXAlignment = Enum.TextXAlignment.Left
label.ZIndex = 1001

local closeBtn = Instance.new("TextButton", notifFrame)
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -30, 0, 6)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.ZIndex = 1002
local closeCorner = Instance.new("UICorner", closeBtn)
closeCorner.CornerRadius = UDim.new(0, 6)

closeBtn.MouseEnter:Connect(function()
	closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
end)
closeBtn.MouseLeave:Connect(function()
	closeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
end)

local sound = Instance.new("Sound", notifFrame)
sound.SoundId = "rbxassetid://12221967"
sound.Volume = 0.7
sound:Play()

table.insert(activeNotifications, notifFrame)
for i, frame in ipairs(activeNotifications) do
	local targetY = 20 + (i - 1) * (frame.Size.Y.Offset + 10)
	TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Position = UDim2.new(1, -20, 0, targetY)
	}):Play()
end

notifFrame.BackgroundTransparency = 1
TweenService:Create(notifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
	BackgroundTransparency = 0.1,
	Position = notifFrame.Position
}):Play()

local function removeNotification()
	TweenService:Create(notifFrame, TweenInfo.new(0.4), {
		BackgroundTransparency = 1,
		Position = UDim2.new(1, 300, 0, notifFrame.Position.Y.Offset)
	}):Play()
	task.wait(0.4)
	notifFrame:Destroy()
	for i, frame in ipairs(activeNotifications) do
		if frame == notifFrame then
			table.remove(activeNotifications, i)
			break
		end
	end
end

closeBtn.MouseButton1Click:Connect(removeNotification)
task.delay(duration, removeNotification)

end

-- 🔁 RGB UPDATE DÖNGÜSÜNE EKLE: RunService.RenderStepped:Connect(function() hue = (hue + 0.01) % 1 local rgbColor = Color3.fromHSV(hue, 1, 1)

for _, notif in ipairs(activeNotifications) do
	local stroke = notif:FindFirstChild("RGBStroke")
	local title = notif:FindFirstChild("RGBTitle")
	if stroke then stroke.Color = rgbColor end
	if title then title.TextColor3 = rgbColor end
end

end)

showNotification("🔥 Yeni Pet Geldi!", 4)

