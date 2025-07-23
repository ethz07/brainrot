-- ethz ESP + Boost GUI - Tümleşik Versiyon
-- by _ethz

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local LocalPlayer = player

-- GLOBAL FLAGS
local boostEnabled = false
local boostConns = {}
local lastPart = nil
local nametagESPEnabled = false
local bodyESPEnabled = false
local highlights = {}
local nametags = {}
_G.brainrotESPloaded = false

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ethzMainGUI"
gui.ResetOnSpawn = false

-- Ana Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 270, 0, 320)
frame.Position = UDim2.new(0.5, -135, 0.5, -160)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- TitleBar
local titleBar = Instance.new("Frame", frame)
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
titleBar.BorderSizePixel = 0
titleBar.Active = true
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)

-- Title
local title = Instance.new("TextLabel", titleBar)
title.Text = "ethz ESP Panel"
title.Font = Enum.Font.FredokaOne
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left

-- Minimize & Close Butonları
local buttonFrame = Instance.new("Frame", titleBar)
buttonFrame.Size = UDim2.new(0, 60, 1, 0)
buttonFrame.Position = UDim2.new(1, -60, 0, 0)
buttonFrame.BackgroundTransparency = 1

local minimizeBtn = Instance.new("TextButton", buttonFrame)
minimizeBtn.Text = "-"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.TextColor3 = Color3.new(1, 1, 0)
minimizeBtn.Size = UDim2.new(0.5, 0, 1, 0)
minimizeBtn.BackgroundTransparency = 1

local closeBtn = Instance.new("TextButton", buttonFrame)
closeBtn.Text = "×"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.new(1, 0.2, 0.2)
closeBtn.Size = UDim2.new(0.5, 0, 1, 0)
closeBtn.Position = UDim2.new(0.5, 0, 0, 0)
closeBtn.BackgroundTransparency = 1

-- Scroll Alanı
local scrolling = Instance.new("ScrollingFrame", frame)
scrolling.Size = UDim2.new(1, 0, 1, -35)
scrolling.Position = UDim2.new(0, 0, 0, 35)
scrolling.CanvasSize = UDim2.new(0, 0, 0, 700)
scrolling.ScrollBarThickness = 6
scrolling.BackgroundTransparency = 1
scrolling.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrolling.CanvasPosition = Vector2.new(0, 0)

-- Minimize / Close işlevi
local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	scrolling.Visible = not minimized
	frame.Size = minimized and UDim2.new(0, 270, 0, 35) or UDim2.new(0, 270, 0, 320)
end)

closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- BOOST Ayraç
local boostLabel = Instance.new("TextLabel", scrolling)
boostLabel.Text = "——— BOOST ———"
boostLabel.Font = Enum.Font.FredokaOne
boostLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
boostLabel.TextSize = 12
boostLabel.Position = UDim2.new(0, 0, 0, 0)
boostLabel.Size = UDim2.new(1, 0, 0, 20)
boostLabel.BackgroundTransparency = 1

-- BOOST Toggle Butonu
local boostBtn = Instance.new("TextButton", scrolling)
boostBtn.Text = "Enable Boost"
boostBtn.Font = Enum.Font.FredokaOne
boostBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
boostBtn.TextSize = 14
boostBtn.Size = UDim2.new(0.9, 0, 0, 30)
boostBtn.Position = UDim2.new(0.05, 0, 0, 25)
boostBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Instance.new("UICorner", boostBtn).CornerRadius = UDim.new(0, 6)

-- BRAINROT ESP Ayraç
local separator1 = Instance.new("TextLabel", scrolling)
separator1.Text = "——— Brainrot ESP ———"
separator1.Font = Enum.Font.FredokaOne
separator1.TextColor3 = Color3.fromRGB(180, 180, 180)
separator1.TextSize = 12
separator1.Position = UDim2.new(0, 0, 0, 70)
separator1.Size = UDim2.new(1, 0, 0, 20)
separator1.BackgroundTransparency = 1

-- Brainrot ESP Butonu
local brainrotBtn = Instance.new("TextButton", scrolling)
brainrotBtn.Text = "Brainrot ESP"
brainrotBtn.Font = Enum.Font.FredokaOne
brainrotBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
brainrotBtn.TextSize = 14
brainrotBtn.Size = UDim2.new(0.9, 0, 0, 30)
brainrotBtn.Position = UDim2.new(0.05, 0, 0, 95)
brainrotBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50) -- koyu gri
Instance.new("UICorner", brainrotBtn).CornerRadius = UDim.new(0, 8)

brainrotBtn.MouseButton1Click:Connect(function()
	if not _G.brainrotESPloaded then
		_G.brainrotESPloaded = true
		loadstring(game:HttpGet("https://raw.githubusercontent.com/ethz07/brainrot/refs/heads/main/ethzE.lua"))()
	else
		warn("✅ Brainrot ESP zaten yüklendi.")
	end
end)

-- PLAYER ESP Ayraç
local separator2 = Instance.new("TextLabel", scrolling)
separator2.Text = "——— Player ESP ———"
separator2.Font = Enum.Font.FredokaOne
separator2.TextColor3 = Color3.fromRGB(180, 180, 180)
separator2.TextSize = 12
separator2.Position = UDim2.new(0, 0, 0, 135)
separator2.Size = UDim2.new(1, 0, 0, 20)
separator2.BackgroundTransparency = 1

local nameBtn = Instance.new("TextButton", scrolling)
nameBtn.Text = "Nametag ESP"
nameBtn.Font = Enum.Font.FredokaOne
nameBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
nameBtn.TextSize = 14
nameBtn.Size = UDim2.new(0.7, 0, 0, 30)
nameBtn.Position = UDim2.new(0.05, 0, 0, 160)
nameBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
Instance.new("UICorner", nameBtn).CornerRadius = UDim.new(0, 6)

local nameToggle = Instance.new("Frame", nameBtn)
nameToggle.Size = UDim2.new(0, 20, 0, 20)
nameToggle.Position = UDim2.new(1.1, 0, 0.5, -10)
nameToggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
nameToggle.BorderSizePixel = 1
nameToggle.BorderColor3 = Color3.new(0, 0, 0)
Instance.new("UICorner", nameToggle).CornerRadius = UDim.new(1, 0)

nameBtn.MouseButton1Click:Connect(function()
	nametagESPEnabled = not nametagESPEnabled
	nameToggle.BackgroundColor3 = nametagESPEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
	for _, tag in pairs(nametags) do tag:Destroy() end
	table.clear(nametags)
	if nametagESPEnabled then
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer then
				local char = plr.Character
				local head = char and char:FindFirstChild("Head")
				if head then
					local tag = Instance.new("BillboardGui")
					tag.Name = "NameTagESP"
					tag.Adornee = head
					tag.Size = UDim2.new(0, 100, 0, 20)
					tag.StudsOffset = Vector3.new(0, 2.5, 0)
					tag.AlwaysOnTop = true
					tag.Parent = head
					local label = Instance.new("TextLabel", tag)
					label.Size = UDim2.new(1, 0, 1, 0)
					label.BackgroundTransparency = 1
					label.Text = plr.DisplayName
					label.TextColor3 = Color3.fromRGB(255, 255, 255)
					label.Font = Enum.Font.FredokaOne
					label.TextScaled = true
					nametags[plr] = tag
				end
			end
		end
	end
end)

-- BODY ESP TOGGLE
local bodyBtn = Instance.new("TextButton", scrolling)
bodyBtn.Text = "Body ESP"
bodyBtn.Font = Enum.Font.FredokaOne
bodyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
bodyBtn.TextSize = 14
bodyBtn.Size = UDim2.new(0.7, 0, 0, 30)
bodyBtn.Position = UDim2.new(0.05, 0, 0, 200)
bodyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
Instance.new("UICorner", bodyBtn).CornerRadius = UDim.new(0, 6)

local bodyToggle = Instance.new("Frame", bodyBtn)
bodyToggle.Size = UDim2.new(0, 20, 0, 20)
bodyToggle.Position = UDim2.new(1.1, 0, 0.5, -10)
bodyToggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
bodyToggle.BorderSizePixel = 1
bodyToggle.BorderColor3 = Color3.new(0, 0, 0)
Instance.new("UICorner", bodyToggle).CornerRadius = UDim.new(1, 0)

bodyBtn.MouseButton1Click:Connect(function()
	bodyESPEnabled = not bodyESPEnabled
	bodyToggle.BackgroundColor3 = bodyESPEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
	for _, h in pairs(highlights) do h:Destroy() end
	table.clear(highlights)
	if bodyESPEnabled then
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer then
				local char = plr.Character
				if char then
					local hl = Instance.new("Highlight")
					hl.Name = "BodyESP"
					hl.Adornee = char
					hl.FillColor = Color3.fromRGB(0, 32, 96)
					hl.FillTransparency = 0.6
					hl.OutlineColor = Color3.fromRGB(255, 255, 255)
					hl.OutlineTransparency = 0
					hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					hl.Parent = char
					highlights[plr] = hl
				end
			end
		end
		end

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

-- BOOST Devre Dışı
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

-- Boost Buton Fonksiyonu
boostBtn.MouseButton1Click:Connect(function()
	boostEnabled = not boostEnabled
	boostBtn.Text = boostEnabled and "Disable Boost" or "Enable Boost"
	if boostEnabled then
		enableBoost()
	else
		disableBoost()
	end
end)
		
