local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")
local Camera = Workspace.CurrentCamera

local player = Players.LocalPlayer
local LocalPlayer = player

-- flag
local boostEnabled = false
local boostConns = {}
local lastPart = nil
local nametagESPEnabled = false
local bodyESPEnabled = false
local highlights = {}
local nametags = {}

local boostEnabled = false -- Başta boost kapalı
local hue = 0

local function enableBoost()
	local player = game.Players.LocalPlayer
	local char = player.Character or player.CharacterAdded:Wait()
	local hum = char:WaitForChild("Humanoid")

	local DEFAULT_SPEED = 48
	local DEFAULT_JUMP = 75
	hum.WalkSpeed = DEFAULT_SPEED
	hum.JumpPower = DEFAULT_JUMP

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

	local function protect()
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
	protect()
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

--[[ RGB animasyonu (sadece boost açıkken çalışır)
RunService.RenderStepped:Connect(function()
	if boostEnabled and boostStroke.Enabled then
		hue = (hue + 0.01) % 1
		boostStroke.Color = Color3.fromHSV(hue, 1, 1)
	end
end)
]]--

local connections = {}
local godModeEnabled = false

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

local characterAddedConn
local function connectCharacter()
    characterAddedConn = player.CharacterAdded:Connect(function(char)
        local hum = char:WaitForChild("Humanoid")
        protectHumanoid(hum)
    end)
    table.insert(connections, characterAddedConn)

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
        if conn and conn.Disconnect then
            conn:Disconnect()
        end
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
mainFrame.Size = UDim2.new(0, 300, 0, 280)
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

-- Sekmeler (Ortalanmış ve eşit boyutta)
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
boostBtn.Size = UDim2.new(1, -20, 0, 36) -- 🔹 Tam genişlik - 10px boşluk sağ & sol
boostBtn.Position = UDim2.new(0, 10, 0, 70) -- 🔹 10px içten başlasın
boostBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
boostBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
boostBtn.Font = Enum.Font.GothamBold
boostBtn.TextSize = 14
boostBtn.AutoButtonColor = false
boostBtn.Visible = false -- 🔹 Başta görünmesin
boostBtn.ZIndex = 10
boostBtn.Parent = mainFrame

Instance.new("UICorner", boostBtn).CornerRadius = UDim.new(0, 8)

local boostStroke = Instance.new("UIStroke", boostBtn)
boostStroke.Thickness = 2
boostStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
boostStroke.Color = Color3.fromRGB(255, 0, 0)
boostStroke.Enabled = false

local boostEnabled = false
boostBtn.MouseButton1Click:Connect(function()
	boostEnabled = not boostEnabled
	if boostEnabled then
		boostBtn.Text = "Boost: ON"
		boostStroke.Enabled = true
		enableBoost()
	else
		boostBtn.Text = "Boost: OFF"
		boostStroke.Enabled = false
		disableBoost()
	end
end)

--[[ RGB
RunService.RenderStepped:Connect(function()
	if boostEnabled and boostStroke.Enabled then
		hue = (hue + 0.01) % 1
		boostStroke.Color = Color3.fromHSV(hue, 1, 1)
	end
end)
--]]

local floatBtn = Instance.new("TextButton")
floatBtn.Name = "FloatButton"
floatBtn.Text = "Float: Disabled"
floatBtn.Size = UDim2.new(1, -20, 0, 36) -- Yanlardan boşluk
floatBtn.Position = UDim2.new(0, 10, 0, 110) -- Boost’un altı
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

local floatStroke = Instance.new("UIStroke", floatBtn)
floatStroke.Thickness = 2
floatStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
floatStroke.Color = Color3.fromRGB(255, 0, 0)
floatStroke.Enabled = false

-- float
local floatGuiBtn = Instance.new("TextButton")
floatGuiBtn.Name = "FloatGUIOpener"
floatGuiBtn.Text = "Float Mobile GUI"
floatGuiBtn.Size = UDim2.new(1, -20, 0, 36)
floatGuiBtn.Position = UDim2.new(0, 10, 0, 150)
floatGuiBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
floatGuiBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
floatGuiBtn.Font = Enum.Font.GothamBold
floatGuiBtn.TextSize = 14
floatGuiBtn.AutoButtonColor = false
floatGuiBtn.Visible = false
floatGuiBtn.ZIndex = 10
floatGuiBtn.Parent = mainFrame

Instance.new("UICorner", floatGuiBtn).CornerRadius = UDim.new(0, 8)

local floatGuiBtnStroke = Instance.new("UIStroke", floatGuiBtn)
floatGuiBtnStroke.Thickness = 2
floatGuiBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
floatGuiBtnStroke.Color = Color3.fromRGB(255, 255, 255)
floatGuiBtnStroke.Enabled = false

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
		boostStroke.Enabled = true
	end

	if flightConn then flightConn:Disconnect() end
	if timerConn then timerConn:Disconnect() end
	flightConn, timerConn = nil, nil

	if bodyPosition then
		bodyPosition:Destroy()
		bodyPosition = nil
	end

	floatBtn.Text = "Float: OFF"
	floatStroke.Enabled = false
	startBtn.Text = "Start Float"
end

local function startFlight()
	local character = player.Character or player.CharacterAdded:Wait()
	local root = character:WaitForChild("HumanoidRootPart")

	if boostEnabled then
		wasBoostEnabledBeforeFloat = true
		disableBoost()
		boostBtn.Text = "Boost: OFF"
		boostStroke.Enabled = false
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
	floatStroke.Enabled = true

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
		timerLabel = = string.format("Timer: %.1fs", math.max(0, remaining))
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

local hue = 0

RunService.RenderStepped:Connect(function()
	hue = (hue + 0.005) % 1
	local color = Color3.fromHSV(hue, 1, 1)

	-- Diyelim ki GUI'nin etrafındaki çerçeve bu:
	if floatRGB then
		floatRGB.Color = color
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
	end)

	buttons[i] = button
	buttonStrokes[button] = stroke
end

-- Toggle Aç/Kapat
toggleButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

-- 🔁 RGB Döngüsü
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
end)

-- Başlangıçta Main seçili
selectedButton = buttons[1]
selectedStroke = buttonStrokes[selectedButton]
selectedStroke.Enabled = true
boostBtn.Visible = true
floatBtn.Visible = true
floatGuiBtn.Visible = true
