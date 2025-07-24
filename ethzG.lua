local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")

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

-- RGB animasyonu (sadece boost açıkken çalışır)
RunService.RenderStepped:Connect(function()
	if boostEnabled and boostStroke.Enabled then
		hue = (hue + 0.01) % 1
		boostStroke.Color = Color3.fromHSV(hue, 1, 1)
	end
end)


-- Ana GUI
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
boostBtn.Text = "Boost: ON"
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
		boostBtn.Text = "Boost: OFF"
		boostStroke.Enabled = true
		enableBoost()
	else
		boostBtn.Text = "Boost: ON"
		boostStroke.Enabled = false
		disableBoost()
	end
end)

-- RGB
RunService.RenderStepped:Connect(function()
	if boostEnabled and boostStroke.Enabled then
		hue = (hue + 0.01) % 1
		boostStroke.Color = Color3.fromHSV(hue, 1, 1)
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
