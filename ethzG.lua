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

-- Float sistem ortak değişkenleri
local floatActive = false
local floatTimeLeft = 0
local floatTimerConn = nil
local floatVelocityConn = nil
local floatEndTime = 0
local floatBodyPos = nil
local floatStartY = nil

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

-- godmode


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

-- boost btn
local boostBtn = Instance.new("TextButton")
boostBtn.Name = "BoostButton"
boostBtn.Text = "Boost: OFF"
boostBtn.Size = UDim2.new(1, -20, 0, 36)
boostBtn.Position = UDim2.new(0, 10, 0, 70)
boostBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
boostBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
boostBtn.Font = Enum.Font.GothamBold
boostBtn.TextSize = 14
boostBtn.AutoButtonColor = false
boostBtn.Visible = false
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

--[[
RunService.RenderStepped:Connect(function()
	if boostEnabled and boostStroke.Enabled then
		hue = (hue + 0.01) % 1
		boostStroke.Color = Color3.fromHSV(hue, 1, 1)
	end
end)
]]--

-- inf msg
local function showFloatInfo()
	local infoGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
	infoGui.Name = "FloatInfoGUI"
	infoGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local msg = Instance.new("TextLabel")
	msg.Size = UDim2.new(0, 280, 0, 30)
	msg.Position = UDim2.new(0.5, -140, 0.92, 0)
	msg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	msg.TextColor3 = Color3.fromRGB(0, 0, 0)
	msg.BorderColor3 = Color3.fromRGB(0, 0, 0)
	msg.BorderSizePixel = 2
	msg.Font = Enum.Font.GothamSemibold
	msg.TextSize = 14
	msg.Text = "inf: You cannot use buttons with the same feature at the same time."
	msg.Parent = infoGui

	task.delay(2.5, function()
		if infoGui then infoGui:Destroy() end
	end)
end
-- end

-- float system..
local floatBtn = Instance.new("TextButton", mainFrame)
floatBtn.Text = "Float: ON"
floatBtn.Font = Enum.Font.GothamBold
floatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
floatBtn.TextSize = 14
floatBtn.Size = UDim2.new(0.9, 0, 0, 36)
floatBtn.Position = UDim2.new(0.05, 0, 0, 120)
floatBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
floatBtn.Visible = false
floatBtn.AutoButtonColor = false

local floatCorner = Instance.new("UICorner", floatBtn)
floatCorner.CornerRadius = UDim.new(0, 8)

local floatStroke = Instance.new("UIStroke", floatBtn)
floatStroke.Thickness = 2
floatStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
floatStroke.Color = Color3.fromRGB(255, 0, 0)
floatStroke.Enabled = false

-- float variables etc.
local floatActive = false
local mobileFloatActive = false
local floatHue = 0
local floatFlightTime = 20
local floatTimer = 0
local floatTimerConn = nil
local floatBodyPosition = nil
local floatStartY = nil
local floatConn = nil
local floatRoot = nil

-- Float Mobile GUI Butonu
local floatMobileBtn = Instance.new("TextButton", mainFrame)
floatMobileBtn.Text = "Float Mobile GUI"
floatMobileBtn.Font = Enum.Font.GothamBold
floatMobileBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
floatMobileBtn.TextSize = 14
floatMobileBtn.Size = UDim2.new(0, 240, 0, 36)
floatMobileBtn.Position = UDim2.new(0.5, -120, 0, 160) -- FloatBtn'in biraz altı
floatMobileBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
floatMobileBtn.Visible = false
floatMobileBtn.AutoButtonColor = false

local floatMobileUICorner = Instance.new("UICorner", floatMobileBtn)
floatMobileUICorner.CornerRadius = UDim.new(0, 8)

local floatMobileStroke = Instance.new("UIStroke", floatMobileBtn)
floatMobileStroke.Thickness = 2
floatMobileStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
floatMobileStroke.Color = Color3.fromRGB(255, 255, 255)

local mobileFloatGui = Instance.new("ScreenGui")
mobileFloatGui.Name = "FloatMobileGUI"
mobileFloatGui.ResetOnSpawn = false
mobileFloatGui.IgnoreGuiInset = true
mobileFloatGui.Enabled = false -- Başta kapalı
mobileFloatGui.Parent = player:WaitForChild("PlayerGui")

-- Ana Frame
local mobileFrame = Instance.new("Frame")
mobileFrame.Size = UDim2.new(0, 200, 0, 100)
mobileFrame.Position = UDim2.new(0.5, -100, 0.7, 0)
mobileFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mobileFrame.BackgroundTransparency = 0.15
mobileFrame.Active = true
mobileFrame.Draggable = true
mobileFrame.Parent = mobileFloatGui

-- Köşe ve Çerçeve
local corner = Instance.new("UICorner", mobileFrame)
corner.CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", mobileFrame)
stroke.Thickness = 2
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

floatMobileBtn.MouseButton1Click:Connect(function()
	if floatActive or mobileFloatActive then
		showFloatInfo("inf: You cannot use buttons with the same feature at the same time.")
		return
	end

	-- Toggle GUI
	mobileFloatGui.Enabled = not mobileFloatGui.Enabled
end)

local mobileFlightConn, mobileTimerConn
local mobileFlightEnd = 0
local mobileBodyPos
local mobileStartY

local function stopMobileFloat()
	mobileFloatActive = false
	mobileFloatBtn.Text = "Float: ON"
	floatBtn.Text = "Float: ON" -- Diğer butonu da senkronla

	if mobileFlightConn then mobileFlightConn:Disconnect() end
	if mobileTimerConn then mobileTimerConn:Disconnect() end
	mobileFlightConn, mobileTimerConn = nil, nil

	if mobileBodyPos then
		mobileBodyPos:Destroy()
		mobileBodyPos = nil
	end
end

local function startMobileFloat()
	if floatActive then
		showFloatInfo("inf: You cannot use buttons with the same feature at the same time.")
		return
	end

	local character = player.Character or player.CharacterAdded:Wait()
	local root = character:WaitForChild("HumanoidRootPart")

	mobileBodyPos = Instance.new("BodyPosition")
	mobileBodyPos.MaxForce = Vector3.new(0, math.huge, 0)
	mobileBodyPos.Position = root.Position + Vector3.new(0, 2.8, 0)
	mobileBodyPos.P = 5000
	mobileBodyPos.D = 500
	mobileBodyPos.Parent = root

	mobileStartY = root.Position.Y + 2.8
	mobileFloatActive = true
	mobileFloatBtn.Text = "Float: ..."
	floatBtn.Text = "Float: ..." -- Diğer float butonuna da yansıt
	mobileFlightEnd = tick() + 20 -- 20 saniye

	-- Hareket ve zaman
	mobileFlightConn = RunService.Heartbeat:Connect(function()
		local camLook = Camera.CFrame.LookVector
		local flatLook = Vector3.new(camLook.X, 0, camLook.Z).Unit * 38
		root.Velocity = Vector3.new(flatLook.X, root.Velocity.Y, flatLook.Z)
		root.CFrame = CFrame.new(root.Position, root.Position + flatLook)
		mobileBodyPos.Position = Vector3.new(root.Position.X, mobileStartY, root.Position.Z)
	end)

	mobileTimerConn = RunService.Heartbeat:Connect(function()
		local timeLeft = mobileFlightEnd - tick()
		local display = string.format("Float: %04.1fs", math.max(0, timeLeft))
		mobileFloatBtn.Text = display
		floatBtn.Text = display
		if timeLeft <= 0 then stopMobileFloat() end
	end)

	enableGodMode() -- senin planladığın fonksiyon
end

-- Buton işlevi
mobileFloatBtn.MouseButton1Click:Connect(function()
	if mobileFloatActive then
		stopMobileFloat()
		disableGodMode()
	else
		startMobileFloat()
	end
end)

player.CharacterAdded:Connect(stopMobileFloat)

local function stopFloat()
	floatActive = false
	if floatConn then floatConn:Disconnect() end
	if floatTimerConn then floatTimerConn:Disconnect() end
	floatConn, floatTimerConn = nil, nil

	if floatBodyPos then
		floatBodyPos:Destroy()
		floatBodyPos = nil
	end

	floatBtn.Text = "Float: ON"
	floatStroke.Color = Color3.fromRGB(255, 255, 255)
	floatStroke.Enabled = false

	-- Mobile GUI güncelle
	if timerLabel and timerLabel.Parent and timerLabel.Visible then
		timerLabel.Text = "Timer: 20.0s"
	end
	if floatMobileBtn then
		floatMobileBtn.Text = "Float: ON"
	end

	disableGodMode()
end

local function startFloat()
	local char = player.Character or player.CharacterAdded:Wait()
	local root = char:WaitForChild("HumanoidRootPart")

	-- Float aktif edildi
	floatActive = true
	flightEndTime = tick() + FLIGHT_TIME
	startY = root.Position.Y + FLOAT_HEIGHT

	-- Buton görselini güncelle
	floatBtn.Text = "Float: ..."
	floatStroke.Enabled = true

	if floatMobileBtn then
		floatMobileBtn.Text = "Float: ..."
	end

	-- RGB Efekti
	floatRGBConn = RunService.RenderStepped:Connect(function()
		if floatActive and floatStroke.Enabled then
			hue = (hue + 0.01) % 1
			floatStroke.Color = Color3.fromHSV(hue, 1, 1)
		end
	end)

	-- BodyPosition oluştur
	floatBodyPos = Instance.new("BodyPosition")
	floatBodyPos.MaxForce = Vector3.new(0, math.huge, 0)
	floatBodyPos.Position = root.Position + Vector3.new(0, FLOAT_HEIGHT, 0)
	floatBodyPos.P = 5000
	floatBodyPos.D = 500
	floatBodyPos.Parent = root

	-- Hareket & yön verme
	floatConn = RunService.Heartbeat:Connect(function()
		if not char or not root then return end
		floatBodyPos.Position = Vector3.new(root.Position.X, startY, root.Position.Z)

		local look = Camera.CFrame.LookVector
		local flatLook = Vector3.new(look.X, 0, look.Z).Unit * FLIGHT_SPEED
		root.Velocity = Vector3.new(flatLook.X, root.Velocity.Y, flatLook.Z)
		root.CFrame = CFrame.new(root.Position, root.Position + flatLook)
	end)

	-- Timer kontrolü
	floatTimerConn = RunService.Heartbeat:Connect(function()
		local remaining = flightEndTime - tick()
		local txt = string.format("Float: %04.1fs", math.max(0, remaining))

		-- GUI’lere aktar
		if floatBtn then floatBtn.Text = txt end
		if floatMobileBtn then floatMobileBtn.Text = txt end
		if timerLabel then timerLabel.Text = "Timer: " .. string.format("%04.1fs", math.max(0, remaining)) end

		if remaining <= 0 then
			stopFloat()
		end
	end)

	enableGodMode()
end

floatBtn.MouseButton1Click:Connect(function()
	if mobileFloatActive then
		-- engelleyici
		local infoMsg = Instance.new("TextLabel", gui)
		infoMsg.Size = UDim2.new(0, 260, 0, 22)
		infoMsg.Position = UDim2.new(0.5, -130, 1, -80)
		infoMsg.BackgroundColor3 = Color3.new(1, 1, 1)
		infoMsg.TextColor3 = Color3.new(0, 0, 0)
		infoMsg.Font = Enum.Font.GothamBold
		infoMsg.TextSize = 13
		infoMsg.Text = "inf: You cannot use buttons with the same feature at the same time."
		infoMsg.BorderSizePixel = 2
		infoMsg.BorderColor3 = Color3.new(0, 0, 0)

		task.delay(2.5, function()
			if infoMsg then infoMsg:Destroy() end
		end)
		return
	end

	if not floatActive then
		startFloat()
		floatStroke.Enabled = true
	else
		stopFloat()
		floatStroke.Enabled = false
	end
end)

-- Float süre güncelleme ve RGB efekti
RunService.RenderStepped:Connect(function()
	if floatActive then
		local timeLeft = math.max(0, floatEndTime - tick())
		floatBtn.Text = string.format("Float: %04.1fs", timeLeft)
		floatStroke.Color = Color3.fromHSV((tick() * 0.5) % 1, 1, 1)

		-- Mobile GUI açıksa onun timerLabel'ı da güncellenir
		if timerLabel and timerLabel.Parent and timerLabel.Visible then
			timerLabel.Text = string.format("Timer: %04.1fs", timeLeft)
		end
	else
		floatBtn.Text = "Float: ON"
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
