local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")
local Camera = Workspace.CurrentCamera

local player = Players.LocalPlayer
local LocalPlayer = player

-- instance


local hue = 0
local activeNotifications = {}

function showNotification(message, duration) 
	duration = duration or 4

local notifGui = player:WaitForChild("PlayerGui"):FindFirstChild("AdvancedNotificationGui")
if not notifGui then
	notifGui = Instance.new("ScreenGui")
	notifGui.Name = "AdvancedNotificationGui"
	notifGui.ResetOnSpawn = false
	notifGui.IgnoreGuiInset = true
	notifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	notifGui.Parent = game:GetService("CoreGui")
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

RunService.RenderStepped:Connect(function() hue = (hue + 0.01) % 1 local rgbColor = Color3.fromHSV(hue, 1, 1)

for _, notif in ipairs(activeNotifications) do
	local stroke = notif:FindFirstChild("RGBStroke")
	local title = notif:FindFirstChild("RGBTitle")
	if stroke then stroke.Color = rgbColor end
	if title then title.TextColor3 = rgbColor end
end

end)
-- how to use: showNotification("text here", duratiom here: 5)

local boostEnabled = false
local godModeEnabled = false
local wasBoostEnabledBeforeFloat = false
local boostConns, connections = {}, {}
local lastPart = nil
local highlights, nametags = {}, {}
local hue = 0

-- BOOST FONKSİYONLARI
local function enableBoost()
	local char = player.Character or player.CharacterAdded:Wait()
	local hum = char:WaitForChild("Humanoid")
	local DEFAULT_SPEED, DEFAULT_JUMP = 48, 85
	hum.WalkSpeed, hum.JumpPower = DEFAULT_SPEED, DEFAULT_JUMP

	table.insert(boostConns, RunService.RenderStepped:Connect(function()
		if hum.WalkSpeed < DEFAULT_SPEED then hum.WalkSpeed = DEFAULT_SPEED end
		if hum.JumpPower < DEFAULT_JUMP then hum.JumpPower = DEFAULT_JUMP end
	end))

	table.insert(boostConns, hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
		if hum.WalkSpeed < DEFAULT_SPEED then hum.WalkSpeed = DEFAULT_SPEED end
	end))

	table.insert(boostConns, hum:GetPropertyChangedSignal("JumpPower"):Connect(function()
		if hum.JumpPower < DEFAULT_JUMP then hum.JumpPower = DEFAULT_JUMP end
	end))

	local function createJumpPart()
		local root = char:FindFirstChild("HumanoidRootPart")
		if not root then return end
		if lastPart and lastPart.Parent then lastPart:Destroy() end

		local part = Instance.new("Part")
		part.Size = Vector3.new(8, 1, 8)
		part.Position = root.Position - Vector3.new(0, 3.1, 0)
		part.Anchored = true
		part.CanCollide = true
		part.Transparency = 0.7
		part.Color = Color3.new(0, 0, 0)
		part.Material = Enum.Material.ForceField
		part.Name = "JumpPad"
		part.Parent = workspace

		lastPart = part
		delay(0.8, function()
			if part and part.Parent then part:Destroy() end
		end)
	end

	table.insert(boostConns, UserInputService.JumpRequest:Connect(function()
		hum:ChangeState(Enum.HumanoidStateType.Jumping)
	end))

	table.insert(boostConns, UserInputService.InputBegan:Connect(function(input, gpe)
		if not gpe and input.KeyCode == Enum.KeyCode.Space then
			createJumpPart()
		end
	end))

	table.insert(boostConns, hum.Jumping:Connect(function(isJumping)
		if isJumping then createJumpPart() end
	end))

	-- Protect (boost içinde godmode)
	table.insert(boostConns, RunService.Heartbeat:Connect(function()
		if hum and hum.Health < hum.MaxHealth and hum.Health > 0 then
			hum.Health = hum.MaxHealth
		end
	end))

	table.insert(boostConns, hum:GetPropertyChangedSignal("Health"):Connect(function()
		if hum.Health <= 0 then
			hum.Health = hum.MaxHealth
		end
	end))

	table.insert(boostConns, hum.Died:Connect(function()
		task.wait()
		hum.Health = hum.MaxHealth
		hum:ChangeState(Enum.HumanoidStateType.Running)
	end))

	table.insert(boostConns, RunService.RenderStepped:Connect(function()
		if hum and hum.Health <= 1 then
			hum.Health = hum.MaxHealth
			hum:ChangeState(Enum.HumanoidStateType.Running)
		end
	end))
end

local function disableBoost()
	for _, conn in pairs(boostConns) do
		if conn and typeof(conn) == "RBXScriptConnection" then
			conn:Disconnect()
		end
	end
	boostConns = {}
	if lastPart and lastPart.Parent then
		lastPart:Destroy()
		lastPart = nil
	end
end

-- GODMODE
local function protectHumanoid(humanoid)
	table.insert(connections, RunService.Heartbeat:Connect(function()
		if godModeEnabled and humanoid and humanoid.Health > 0 and humanoid.Health < humanoid.MaxHealth then
			humanoid.Health = humanoid.MaxHealth
		end
	end))

	table.insert(connections, humanoid:GetPropertyChangedSignal("Health"):Connect(function()
		if godModeEnabled and humanoid.Health <= 0 then
			humanoid.Health = humanoid.MaxHealth
		end
	end))

	table.insert(connections, humanoid.Died:Connect(function()
		if godModeEnabled then
			task.wait()
			humanoid.Health = humanoid.MaxHealth
			humanoid:ChangeState(Enum.HumanoidStateType.Running)
		end
	end))

	table.insert(connections, RunService.RenderStepped:Connect(function()
		if godModeEnabled and humanoid and humanoid.Health <= 1 then
			humanoid.Health = humanoid.MaxHealth
			humanoid:ChangeState(Enum.HumanoidStateType.Running)
		end
	end))
end

local function connectCharacter()
	local charConn = player.CharacterAdded:Connect(function(char)
		local hum = char:WaitForChild("Humanoid")
		protectHumanoid(hum)
	end)
	table.insert(connections, charConn)

	if player.Character then
		local hum = player.Character:FindFirstChild("Humanoid")
		if hum then
			protectHumanoid(hum)
		end
	end
end

function enableGodMode()
	if godModeEnabled then return end
	godModeEnabled = true
	connectCharacter()
end

function disableGodMode()
	if not godModeEnabled then return end
	godModeEnabled = false
	for _, conn in pairs(connections) do
		if conn and conn.Disconnect then conn:Disconnect() end
	end
	connections = {}
end

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false
gui.Name = "RGBTabGUI"
gui.Parent = player:WaitForChild("PlayerGui")

-- 🟦 Toggle Frame
local toggleFrame = Instance.new("Frame")
toggleFrame.Size = UDim2.new(0, 60, 0, 20)
toggleFrame.Position = UDim2.new(0, 10, 0, 10)
toggleFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
toggleFrame.Active = true
toggleFrame.Draggable = true
toggleFrame.Parent = gui

local toggleUICorner = Instance.new("UICorner", toggleFrame)
toggleUICorner.CornerRadius = UDim.new(0, 4)

local toggleStroke = Instance.new("UIStroke", toggleFrame)
toggleStroke.Thickness = 2
toggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Toggle Butonu
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(1, 0, 1, 0)
toggleButton.BackgroundTransparency = 1
toggleButton.Text = "Toggle"
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.TextSize = 12
toggleButton.Font = Enum.Font.GothamBold
toggleButton.AutoButtonColor = false
toggleButton.Parent = toggleFrame

-- 🟥 Ana Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 285)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -140)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BackgroundTransparency = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0, 16)

local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Thickness = 3
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Başlık
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -10, 0, 16)
titleLabel.Position = UDim2.new(0, 5, 0, 2)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Steal a Brainrot | Renz SCRIPT"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamSemibold
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Center
titleLabel.TextYAlignment = Enum.TextYAlignment.Top
titleLabel.Parent = mainFrame

local buttonNames = {"Main", "Visual", "Misc"}
local buttons = {}
local buttonStrokes = {}

local selectedButton = nil
local selectedStroke = nil
local hue = 0

local buttonWidth = 80
local buttonSpacing = 10
local totalWidth = (#buttonNames * buttonWidth) + ((#buttonNames - 1) * buttonSpacing)
local startX = (mainFrame.Size.X.Offset - totalWidth) / 2

-- BOOST BUTONU
local boostBtn = Instance.new("TextButton")
boostBtn.Name = "BoostButton"
boostBtn.Text = "Boost: OFF"
boostBtn.Size = UDim2.new(1, -20, 0, 36) 
boostBtn.Position = UDim2.new(0, 10, 0, 70) -- 🔹 
boostBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
boostBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
boostBtn.Font = Enum.Font.GothamBold
boostBtn.TextSize = 14
boostBtn.AutoButtonColor = false
boostBtn.Visible = false 
boostBtn.ZIndex = 10
boostBtn.Parent = mainFrame
Instance.new("UICorner", boostBtn).CornerRadius = UDim.new(0, 8)

local boostEnabled = false
boostBtn.MouseButton1Click:Connect(function()
	boostEnabled = not boostEnabled
	if boostEnabled then
		boostBtn.Text = "Boost: ON"
		enableBoost()
	else
		boostBtn.Text = "Boost: OFF"
		disableBoost()
	end
end)

-- BOOST MOBILE GUI
local boostMobileGui = Instance.new("ScreenGui")
boostMobileGui.Name = "BoostMobileGUI"
boostMobileGui.ResetOnSpawn = false
boostMobileGui.Enabled = false
boostMobileGui.Parent = player:WaitForChild("PlayerGui")

local boostFrame = Instance.new("Frame")
boostFrame.Size = UDim2.new(0, 180, 0, 60)
boostFrame.Position = UDim2.new(0.5, -90, 0.7, 0)
boostFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
boostFrame.BackgroundTransparency = 0.15
boostFrame.Active = true
boostFrame.Draggable = true
boostFrame.ZIndex = 20
boostFrame.Parent = boostMobileGui

Instance.new("UICorner", boostFrame).CornerRadius = UDim.new(0, 10)

local boostRGBStroke = Instance.new("UIStroke", boostFrame)
boostRGBStroke.Thickness = 2
boostRGBStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
boostRGBStroke.Color = Color3.fromRGB(255, 0, 0)

local boostMiniBtn = Instance.new("TextButton", boostFrame)
boostMiniBtn.Size = UDim2.new(1, -20, 0, 30)
boostMiniBtn.Position = UDim2.new(0, 10, 0, 15)
boostMiniBtn.Text = "Boost: OFF"
boostMiniBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
boostMiniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
boostMiniBtn.BackgroundTransparency = 1
boostMiniBtn.Font = Enum.Font.GothamBold
boostMiniBtn.TextSize = 16
boostMiniBtn.ZIndex = 21
boostMiniBtn.TextXAlignment = Enum.TextXAlignment.Center
boostMiniBtn.TextYAlignment = Enum.TextYAlignment.Center

Instance.new("UICorner", boostMiniBtn).CornerRadius = UDim.new(0, 6)

-- Mobil GUI Açma Butonu (ana GUI'ye)
local boostMobileGuiBtn = Instance.new("TextButton")
boostMobileGuiBtn.Name = "BoostGUIOpener"
boostMobileGuiBtn.Text = "Boost Mobile GUI"
boostMobileGuiBtn.Size = UDim2.new(1, -20, 0, 36)
boostMobileGuiBtn.Position = UDim2.new(0, 10, 0, 110) -- Float GUI'nin altı
boostMobileGuiBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
boostMobileGuiBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
boostMobileGuiBtn.Font = Enum.Font.GothamBold
boostMobileGuiBtn.TextSize = 14
boostMobileGuiBtn.AutoButtonColor = false
boostMobileGuiBtn.Visible = false
boostMobileGuiBtn.ZIndex = 10
boostMobileGuiBtn.Parent = mainFrame

Instance.new("UICorner", boostMobileGuiBtn).CornerRadius = UDim.new(0, 8)

boostMobileGuiBtn.MouseButton1Click:Connect(function()
	boostMobileGui.Enabled = not boostMobileGui.Enabled
end)

-- Mini Boost buton tıklaması
boostMiniBtn.MouseButton1Click:Connect(function()
	boostEnabled = not boostEnabled
	if boostEnabled then
		boostBtn.Text = "Boost: ON"
		boostMiniBtn.Text = "Boost: ON"
		enableBoost()
	else
		boostBtn.Text = "Boost: OFF"
		boostMiniBtn.Text = "Boost: OFF"
		disableBoost()
	end
end)

-- Ana Boost butonu değişince mini GUI'yi de güncelle
boostBtn:GetPropertyChangedSignal("Text"):Connect(function()
	boostMiniBtn.Text = boostBtn.Text
end)

-- RGB animasyonu boost mobile GUI'de de uygula
RunService.RenderStepped:Connect(function()
	if boostRGBStroke then
		boostRGBStroke.Color = Color3.fromHSV(hue, 1, 1)
	end
end)

-- float
local floatBtn = Instance.new("TextButton")
floatBtn.Name = "FloatButton"
floatBtn.Text = "Float: OFF"
floatBtn.Size = UDim2.new(1, -20, 0, 36) -- Yanlardan boşluk
floatBtn.Position = UDim2.new(0, 10, 0, 152) -- Boost’un altı
floatBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
floatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
floatBtn.Font = Enum.Font.GothamBold
floatBtn.TextSize = 14
floatBtn.AutoButtonColor = false
floatBtn.Visible = false
floatBtn.Active = false
floatBtn.Selectable = false
floatBtn.ZIndex = 10
floatBtn.Parent = mainFrame
Instance.new("UICorner", floatBtn).CornerRadius = UDim.new(0, 8)

-- float
local floatGuiBtn = Instance.new("TextButton")
floatGuiBtn.Name = "FloatGUIOpener"
floatGuiBtn.Text = "Float Mobile GUI"
floatGuiBtn.Size = UDim2.new(1, -20, 0, 36)
floatGuiBtn.Position = UDim2.new(0, 10, 0, 192)
floatGuiBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
floatGuiBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
floatGuiBtn.Font = Enum.Font.GothamBold
floatGuiBtn.TextSize = 14
floatGuiBtn.AutoButtonColor = false
floatGuiBtn.Visible = false
floatGuiBtn.ZIndex = 10
floatGuiBtn.Parent = mainFrame

Instance.new("UICorner", floatGuiBtn).CornerRadius = UDim.new(0, 8)

-- FLOAT BUTTON (Boost'un hemen altına)
-- DRAGGABLE FLOAT MOBILE GUI
local floatGui = Instance.new("ScreenGui")
floatGui.Name = "FloatMobileGUI"
floatGui.ResetOnSpawn = false
floatGui.Enabled = false
floatGui.Parent = player:WaitForChild("PlayerGui")

local floatFrame = Instance.new("Frame")
floatFrame.Size = UDim2.new(0, 200, 0, 80)
floatFrame.Position = UDim2.new(0.5, -100, 0.6, 0)
floatFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
floatFrame.BackgroundTransparency = 0.15
floatFrame.Active = true
floatFrame.Draggable = true
floatFrame.ZIndex = 20
floatFrame.Parent = floatGui

Instance.new("UICorner", floatFrame).CornerRadius = UDim.new(0, 10)

local floatRGB = Instance.new("UIStroke", floatFrame)
floatRGB.Thickness = 2
floatRGB.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
floatRGB.Color = Color3.fromRGB(255, 0, 0)

local timerLabel = Instance.new("TextLabel", floatFrame)
timerLabel.Size = UDim2.new(1, 0, 0, 30)
timerLabel.Position = UDim2.new(0, 0, 0, 0)
timerLabel.BackgroundTransparency = 1
timerLabel.Text = "Timer: 20.0s"
timerLabel.Font = Enum.Font.Gotham
timerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
timerLabel.TextSize = 14
timerLabel.ZIndex = 21
timerLabel.Parent = floatFrame

local startBtn = Instance.new("TextButton", floatFrame)
startBtn.Size = UDim2.new(1, -20, 0, 30)
startBtn.Position = UDim2.new(0, 10, 0, 40)
startBtn.Text = "Start Float"
startBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 14
startBtn.ZIndex = 21

Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0, 6)

-- Float ayarları
local FLIGHT_TIME = 20
local FLIGHT_SPEED = 38
local FLOAT_HEIGHT = 2.8

-- Float değişkenleri
local flying = false
local flightConn = nil
local timerConn = nil
local flightEndTime = 0
local startY = nil
local bodyPosition = nil

-- Boost durumu yedeklemek için
local wasBoostEnabledBeforeFloat = false

local function stopFlight()
	flying = false
	disableGodMode()

	if wasBoostEnabledBeforeFloat then
		wasBoostEnabledBeforeFloat = false
		boostEnabled = true
		enableBoost()
		boostBtn.Text = "Boost: ON"
	end

	if flightConn then flightConn:Disconnect() end
	if timerConn then timerConn:Disconnect() end
	flightConn, timerConn = nil, nil

	if bodyPosition then
		bodyPosition:Destroy()
		bodyPosition = nil
	end

	floatBtn.Text = "Float: OFF"
	startBtn.Text = "Start Float"
end

local function startFlight()
	local character = player.Character or player.CharacterAdded:Wait()
	local root = character:WaitForChild("HumanoidRootPart")

	if boostEnabled then
		wasBoostEnabledBeforeFloat = true
		disableBoost()
		boostBtn.Text = "Boost: OFF"
		boostEnabled = false
	else
		wasBoostEnabledBeforeFloat = false
	end

	enableGodMode()

	if bodyPosition then bodyPosition:Destroy() end
	bodyPosition = Instance.new("BodyPosition")
	bodyPosition.MaxForce = Vector3.new(0, math.huge, 0)
	bodyPosition.Position = root.Position + Vector3.new(0, FLOAT_HEIGHT, 0)
	bodyPosition.P = 5000
	bodyPosition.D = 500
	bodyPosition.Parent = root

	startY = root.Position.Y + FLOAT_HEIGHT
	flying = true
	flightEndTime = tick() + FLIGHT_TIME
	startBtn.Text = "Stop Float"

	flightConn = RunService.Heartbeat:Connect(function()
		if not player.Character then return end
		local root = player.Character:FindFirstChild("HumanoidRootPart")
		if not root or not workspace.CurrentCamera then return end

		bodyPosition.Position = Vector3.new(root.Position.X, startY, root.Position.Z)
		local look = workspace.CurrentCamera.CFrame.LookVector
		look = Vector3.new(look.X, 0, look.Z).Unit * FLIGHT_SPEED
		root.Velocity = Vector3.new(look.X, root.Velocity.Y, look.Z)
		root.CFrame = CFrame.new(root.Position, root.Position + look)
	end)

	timerConn = RunService.Heartbeat:Connect(function()
		local remaining = flightEndTime - tick()
		floatBtn.Text = string.format("Timer: %.1fs", math.max(0, remaining))
		timerLabel.Text = string.format("Timer: %.1fs", math.max(0, remaining))
		if remaining <= 0 then stopFlight() end
	end)
end

-- Float butonu bağlantısı
startBtn.MouseButton1Click:Connect(function()
	if flying then
		stopFlight()
	else
		startFlight()
	end
end)

floatGuiBtn.MouseButton1Click:Connect(function()
	floatGui.Enabled = not floatGui.Enabled
end)

-- Karakter respawn olursa float durmalı
player.CharacterAdded:Connect(stopFlight)

-- AUTO KICK BUTONU
local autoKickBtn = Instance.new("TextButton")
autoKickBtn.Name = "AutoKickButton"
autoKickBtn.Text = "Enable Auto Kick"
autoKickBtn.Size = UDim2.new(0, 280, 0, 36)
autoKickBtn.Position = UDim2.new(0, 10, 0, 234)
autoKickBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
autoKickBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoKickBtn.Font = Enum.Font.GothamBold
autoKickBtn.TextSize = 14
autoKickBtn.AutoButtonColor = false
autoKickBtn.Visible = true
autoKickBtn.ZIndex = 10
autoKickBtn.Parent = mainFrame
Instance.new("UICorner", autoKickBtn).CornerRadius = UDim.new(0, 8)

local autoKickEnabled = false
local lastStealValue = LocalPlayer:WaitForChild("leaderstats"):WaitForChild("Steals").Value

autoKickBtn.MouseButton1Click:Connect(function()
	autoKickEnabled = not autoKickEnabled
	autoKickBtn.Text = autoKickEnabled and "Disable Auto Kick" or "Enable Auto Kick"

	if autoKickEnabled then
		showNotification("This will auto-kick you after stealing.\nClick again to disable.", 5)
		print("Auto Kick ENABLED")
	else
		print("Auto Kick DISABLED")
	end
end)

-- Steal değişimi dinleme
LocalPlayer.leaderstats.Steals:GetPropertyChangedSignal("Value"):Connect(function()
	if autoKickEnabled then
		local newVal = LocalPlayer.leaderstats.Steals.Value
		if newVal > lastStealValue then
			task.wait(0.5)
			LocalPlayer:Kick("Successfully Auto-Kicked After Steal.")
		end
		lastStealValue = newVal
	end
end)

for i, name in ipairs(buttonNames) do
	local button = Instance.new("TextButton")
	button.Name = name .. "Button"
	button.Text = name
	button.Size = UDim2.new(0, buttonWidth, 0, 36)
	button.Position = UDim2.new(0, startX + (i - 1) * (buttonWidth + buttonSpacing), 0, 20)
	button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 14
	button.AutoButtonColor = false
	button.Parent = mainFrame

	local uicorner = Instance.new("UICorner", button)
	uicorner.CornerRadius = UDim.new(0, 8)

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 2
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Parent = button
	stroke.Enabled = false

	button.MouseButton1Click:Connect(function()
		selectedButton = button
		selectedStroke = stroke
		for _, btn in ipairs(buttons) do
			if btn ~= selectedButton then
				btn.TextColor3 = Color3.fromRGB(255, 255, 255)
				buttonStrokes[btn].Enabled = false
			end
		end
		stroke.Enabled = true
	        boostBtn.Visible = (button.Name == "MainButton")
		floatBtn.Visible = (button.Name == "MainButton")
		floatGuiBtn.Visible = (button.Name == "MainButton")
		boostMobileGuiBtn.Visible = (button.Name == "MainButton")
		autoKickBtn.Visible = (button.Name == "MainButton")
	end)

	buttons[i] = button
	buttonStrokes[button] = stroke
end

-- Toggle Aç/Kapat
toggleButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

RunService.RenderStepped:Connect(function()
	hue = (hue + 0.01) % 1
	local rgbColor = Color3.fromHSV(hue, 1, 1)

	mainStroke.Color = rgbColor

	if selectedButton and selectedStroke then
		selectedButton.TextColor3 = rgbColor
		selectedStroke.Color = rgbColor
	end

	toggleButton.TextColor3 = rgbColor
	toggleStroke.Color = rgbColor

	if floatRGB then
		floatRGB.Color = rgbColor
	end
end)

-- Başlangıçta Main seçili
selectedButton = buttons[1]
selectedStroke = buttonStrokes[selectedButton]
selectedStroke.Enabled = true
boostBtn.Visible = true
floatBtn.Visible = true
floatGuiBtn.Visible = true
boostMobileGuiBtn.Visible = true
autoKickBtn.Visible = true

print("RENZ SCRIPT.")
