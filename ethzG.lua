local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")
local Camera = Workspace.CurrentCamera
local player = Players.LocalPlayer
local LocalPlayer = player
local TeleportService = game:GetService("TeleportService")

-- instances
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local toggleFrame = Instance.new("Frame")
local toggleUICorner = Instance.new("UICorner", toggleFrame)
local toggleStroke = Instance.new("UIStroke", toggleFrame)
local toggleButton = Instance.new("TextButton")
local mainFrame = Instance.new("Frame")
local mainCorner = Instance.new("UICorner", mainFrame)
local mainStroke = Instance.new("UIStroke", mainFrame)
local titleLabel = Instance.new("TextLabel")
local boostBtn = Instance.new("TextButton")
local boostMobileGui = Instance.new("ScreenGui")
local boostFrame = Instance.new("Frame")
local boostRGBStroke = Instance.new("UIStroke", boostFrame)
local boostMiniBtn = Instance.new("TextButton", boostFrame)
local boostMobileGuiBtn = Instance.new("TextButton")
local floatBtn = Instance.new("TextButton")
local floatGuiBtn = Instance.new("TextButton")
local floatGui = Instance.new("ScreenGui")
local floatFrame = Instance.new("Frame")
local floatRGB = Instance.new("UIStroke", floatFrame)
local timerLabel = Instance.new("TextLabel", floatFrame)
local startBtn = Instance.new("TextButton", floatFrame)
local autoKickBtn = Instance.new("TextButton")
local nameEspBtn = Instance.new("TextButton")
local bodyEspBtn = Instance.new("TextButton")
local espBtn = Instance.new("TextButton")
local brainrotBtn = Instance.new("TextButton")
local RejoinBtn = Instance.new("TextButton")
-- other
local lastStealValue = LocalPlayer:WaitForChild("leaderstats"):WaitForChild("Steals").Value
local autoKickEnabled = false
local FLIGHT_TIME = 20
local FLIGHT_SPEED = 38
local FLOAT_HEIGHT = 2.8
local flying = false
local flightConn = nil
local timerConn = nil
local flightEndTime = 0
local startY = nil
local bodyPosition = nil
local wasBoostEnabledBeforeFloat = false -- yedekleme
local boostEnabled = false
local godModeEnabled = false
local wasBoostEnabledBeforeFloat = false
local boostConns, connections = {}, {}
local lastPart = nil
local highlights, nametags = {}, {}
local hue = 0
local activeNotifications = {}
local espEnabled = false
local nametagESPEnabled = false
local bodyESPEnabled = false

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
	notifFrame.BackgroundTransparency = 1
	notifFrame.AnchorPoint = Vector2.new(1, 0)
	notifFrame.Position = UDim2.new(1, 300, 0, 20)
	notifFrame.ZIndex = 1000
	notifFrame.Parent = notifGui

	Instance.new("UICorner", notifFrame).CornerRadius = UDim.new(0, 12)

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
	Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

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
		local targetY = 20 + (i - 1) * 70
		TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Position = UDim2.new(1, -20, 0, targetY)
		}):Play()
	end

	TweenService:Create(notifFrame, TweenInfo.new(0.3), { BackgroundTransparency = 0.1 }):Play()

	local function removeNotification()
		local tweenOut = TweenService:Create(notifFrame, TweenInfo.new(0.4), {
			BackgroundTransparency = 1,
			Position = UDim2.new(1, 300, 0, notifFrame.Position.Y.Offset)
		})
		tweenOut:Play()
		tweenOut.Completed:Wait()
		notifFrame:Destroy()

		for i, frame in ipairs(activeNotifications) do
			if frame == notifFrame then
				table.remove(activeNotifications, i)
				break
			end
		end

		for i, frame in ipairs(activeNotifications) do
			local targetY = 20 + (i - 1) * 70
			TweenService:Create(frame, TweenInfo.new(0.3), {
				Position = UDim2.new(1, -20, 0, targetY)
			}):Play()
		end
	end

	closeBtn.MouseButton1Click:Connect(removeNotification)
	task.spawn(function()
		task.wait(duration)
		removeNotification()
	end)
end

RunService.RenderStepped:Connect(function()
	hue = (hue + 0.01) % 1
	local color = Color3.fromHSV(hue, 1, 1)
	for _, notif in ipairs(activeNotifications) do
		local stroke = notif:FindFirstChild("RGBStroke")
		local title = notif:FindFirstChild("RGBTitle")
		if stroke then stroke.Color = color end
		if title then title.TextColor3 = color end
	end
end)
-- how to use: showNotification("text here", duration here: 5)

-- are you sure? gui
function ShowConfirmation(promptText, onConfirm)
	local screenGui = player:WaitForChild("PlayerGui"):FindFirstChild("ConfirmationGui") or Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
	screenGui.Name = "ConfirmationGui"
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.ResetOnSpawn = false
	screenGui.Enabled = true
	screenGui.IgnoreGuiInset = true
	
	-- GUI zaten varsa temizle
	screenGui:ClearAllChildren()
	
	-- Dim arka plan
	local dimBg = Instance.new("Frame")
	dimBg.Size = UDim2.new(1, 0, 1, 0)
	dimBg.BackgroundColor3 = Color3.new(0, 0, 0)
	dimBg.BackgroundTransparency = 1
	dimBg.ZIndex = 10
	dimBg.Parent = screenGui

	-- Ana pencere
	local confirmGui = Instance.new("Frame")
	confirmGui.Size = UDim2.new(0, 280, 0, 150)
	confirmGui.Position = UDim2.new(0.5, -140, 0.5, -75)
	confirmGui.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	confirmGui.BackgroundTransparency = 1
	confirmGui.ZIndex = 11
	confirmGui.Parent = screenGui
	local corner = Instance.new("UICorner", confirmGui)
	corner.CornerRadius = UDim.new(0, 12)

	-- Soru yazısı
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -20, 0, 50)
	label.Position = UDim2.new(0, 10, 0, 15)
	label.Text = promptText or "Are you sure?"
	label.TextColor3 = Color3.new(1, 1, 1)
	label.Font = Enum.Font.Gotham
	label.TextSize = 16
	label.BackgroundTransparency = 1
	label.ZIndex = 12
	label.TextWrapped = true
	label.Parent = confirmGui

	-- Yes butonu
	local yesBtn = Instance.new("TextButton")
	yesBtn.Size = UDim2.new(0.5, -15, 0, 36)
	yesBtn.Position = UDim2.new(0, 10, 1, -50)
	yesBtn.Text = "Yes"
	yesBtn.TextSize = 14
	yesBtn.Font = Enum.Font.GothamBold
	yesBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 75)
	yesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	yesBtn.ZIndex = 12
	yesBtn.Parent = confirmGui
	Instance.new("UICorner", yesBtn).CornerRadius = UDim.new(0, 8)

	-- No butonu
	local noBtn = Instance.new("TextButton")
	noBtn.Size = UDim2.new(0.5, -15, 0, 36)
	noBtn.Position = UDim2.new(0.5, 5, 1, -50)
	noBtn.Text = "No"
	noBtn.TextSize = 14
	noBtn.Font = Enum.Font.GothamBold
	noBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	noBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	noBtn.ZIndex = 12
	noBtn.Parent = confirmGui
	Instance.new("UICorner", noBtn).CornerRadius = UDim.new(0, 8)

	-- Göster animasyonu
	TweenService:Create(dimBg, TweenInfo.new(0.3), {BackgroundTransparency = 0.85}):Play()
	TweenService:Create(confirmGui, TweenInfo.new(0.3), {BackgroundTransparency = 0.15}):Play()

	-- YES tıklandıysa
	yesBtn.MouseButton1Click:Connect(function()
		screenGui:Destroy()
		if typeof(onConfirm) == "function" then
			onConfirm()
		end
	end)

	-- NO tıklandıysa
	noBtn.MouseButton1Click:Connect(function()
		TweenService:Create(dimBg, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
		TweenService:Create(confirmGui, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
		task.delay(0.3, function()
			screenGui:Destroy()
		end)
	end)
end

-- player esp func
local function applyESPToPlayer(plr)
	if plr == LocalPlayer then return end
	local char = plr.Character or plr.CharacterAdded:Wait()

	if nametagESPEnabled then
	local head = char:WaitForChild("Head", 2)
	if head and not head:FindFirstChild("NameTagESP") then
		local tag = Instance.new("BillboardGui")
		tag.Name = "NameTagESP"
		tag.Adornee = head
		tag.Size = UDim2.new(0, 100, 0, 20)
		tag.StudsOffset = Vector3.new(0, 2.5, 0)
		tag.AlwaysOnTop = true
		tag.Parent = head

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.Text = plr.DisplayName
		label.TextColor3 = Color3.new(1, 1, 1)
		label.Font = Enum.Font.GothamBold
		label.TextScaled = true
		label.Parent = tag

		local stroke = Instance.new("UIStroke")
		stroke.Thickness = 1.2
		stroke.Color = Color3.fromRGB(170, 170, 170) -- açık gri kenar
		stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
		stroke.Parent = label

		nametags[plr] = tag
		end
	end

	if bodyESPEnabled then
		if not char:FindFirstChild("BodyESP") then
			local hl = Instance.new("Highlight")
			hl.Name = "BodyESP"
			hl.Adornee = char
			hl.FillColor = Color3.fromHSV(hue, 1, 1)
			hl.FillTransparency = 0.55
			hl.OutlineColor = Color3.fromRGB(255, 255, 255)
			hl.OutlineTransparency = 0.4 -- daha ince görünüm
			hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			hl.Parent = char
			highlights[plr] = hl
		end
	end
end

local function clearESPs()
	for _, tag in pairs(nametags) do if tag then tag:Destroy() end end
	for _, h in pairs(highlights) do if h then h:Destroy() end end
	table.clear(nametags)
	table.clear(highlights)
end

local function updateAllESPs()
	clearESPs()
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			applyESPToPlayer(plr)
		end
	end
end

RunService.RenderStepped:Connect(function()
	hue = (hue + 0.005) % 1
	for _, hl in pairs(highlights) do
		if hl and hl:IsA("Highlight") then
			hl.FillColor = Color3.fromHSV(hue, 1, 1)
		end
	end
end)

Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		task.wait(0.2)
		applyESPToPlayer(plr)
	end)
end)

for _, plr in ipairs(Players:GetPlayers()) do
	plr.CharacterAdded:Connect(function()
		task.wait(0.2)
		applyESPToPlayer(plr)
	end)
end
-- BASE TIME ESP
local SmartESP = {}
SmartESP.__index = SmartESP

function SmartESP.new()
	local self = setmetatable({}, SmartESP)
	self:Initialize()
	return self
end

function SmartESP:Initialize()
	self.settings = {
		maxDistance = 1000,
		updateInterval = 0.3,
		baseSize = UDim2.new(0, 150, 0, 30),
		offset = Vector3.new(0, 4, 0),
		colors = {
			myPlot = Color3.fromRGB(0, 200, 255),
			locked = Color3.fromRGB(245, 205, 48), -- yellow
			unlocked = Color3.fromRGB(0, 255, 0), -- green
			noOwner = Color3.fromRGB(150, 150, 150),
			newOwner = Color3.fromRGB(200, 0, 200)
		}
	}

	self.state = {
		active = false,
		instances = {},
		connection = nil,
		lastUpdate = 0,
		plotsFolder = nil,
		myPlot = nil,
		previousOwners = {}
	}

	self:FindMyPlot()
end

function SmartESP:FindMyPlot()
	local plotsFolder = self:FindPlotsFolder()
	if not plotsFolder then return end
	for _, plot in plotsFolder:GetChildren() do
		local yourBase = plot:FindFirstChild("YourBase", true)
		if yourBase and yourBase:IsA("BoolValue") and yourBase.Value then
			self.state.myPlot = plot.Name
			break
		end
	end
end

function SmartESP:FindPlotsFolder()
	if not self.state.plotsFolder or not self.state.plotsFolder.Parent then
		local possibleNames = {"Plots", "PlotSystem", "PlotsSystem", "Bases"}
		for _, name in ipairs(possibleNames) do
			local folder = workspace:FindFirstChild(name)
			if folder then
				self.state.plotsFolder = folder
				break
			end
		end
	end
	return self.state.plotsFolder
end

function SmartESP:CreateESP(plot, mainPart)
	if self.state.instances[plot.Name] then return self.state.instances[plot.Name] end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "ESP_" .. plot.Name
	billboard.Size = self.settings.baseSize
	billboard.StudsOffset = self.settings.offset
	billboard.AlwaysOnTop = true
	billboard.Adornee = mainPart
	billboard.MaxDistance = self.settings.maxDistance
	billboard.Parent = mainPart

	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.TextScaled = true
	label.Font = Enum.Font.GothamBold
	label.TextStrokeTransparency = 0.3
	label.TextStrokeColor3 = Color3.new(0, 0, 0) -- siyah kenarlık
	label.TextColor3 = Color3.fromRGB(255, 255, 255) -- geçici
	label.Text = ""
	label.Parent = billboard

	self.state.instances[plot.Name] = billboard
	return billboard
end

function SmartESP:UpdateOwnership(plot)
	local ownerValue = plot:FindFirstChild("Owner", true)
	local plotName = plot.Name
	if ownerValue then
		local currentOwner = tostring(ownerValue.Value)
		local previousOwner = self.state.previousOwners[plotName]
		if currentOwner ~= previousOwner then
			if (previousOwner == nil or previousOwner == "") and currentOwner ~= "" then
				self.state.previousOwners[plotName] = currentOwner
				return "NEW OWNER"
			end
			self.state.previousOwners[plotName] = currentOwner
		end
		if currentOwner == "" or currentOwner == nil then
			self.state.previousOwners[plotName] = nil
		end
	end
	return nil
end

function SmartESP:Update()
	if tick() - self.state.lastUpdate < self.settings.updateInterval then return end
	self.state.lastUpdate = tick()
	local plotsFolder = self:FindPlotsFolder()
	if not plotsFolder then return end
	self:FindMyPlot()

	for _, plot in plotsFolder:GetChildren() do
		local mainPart = plot:FindFirstChild("Main", true) or plot:FindFirstChild("BasePart", true)
		local timeLabel = plot:FindFirstChild("RemainingTime", true)
		local ownerValue = plot:FindFirstChild("Owner", true)

		if mainPart then
			local ownershipStatus = self:UpdateOwnership(plot)
			local isMyPlot = plot.Name == self.state.myPlot

			local billboard = self:CreateESP(plot, mainPart)
			local label = billboard:FindFirstChild("Label")

			if not label then continue end

			if isMyPlot then
				label.Text = "MY BASE"
				label.TextColor3 = self.settings.colors.myPlot
			elseif ownershipStatus == "NEW OWNER" then
				label.Text = "CLAIMED"
				label.TextColor3 = self.settings.colors.newOwner
			elseif ownerValue and (ownerValue.Value == nil or ownerValue.Value == "") then
				label.Text = "UNCLAIMED"
				label.TextColor3 = self.settings.colors.noOwner
			elseif timeLabel then
				local isUnlocked = (timeLabel.Text == "0s" or timeLabel.Text == "")
				if isUnlocked then
					label.Text = "UNLOCKED"
					label.TextColor3 = self.settings.colors.unlocked
				else
					label.Text = timeLabel.Text
					label.TextColor3 = self.settings.colors.locked
				end
			end
			
			local camera = workspace.CurrentCamera
			if camera then
				local distance = (camera.CFrame.Position - mainPart.Position).Magnitude
				local scale = math.clamp(1.0 - (distance / self.settings.maxDistance), 0.4, 0.8)
				billboard.Size = UDim2.new(0, self.settings.baseSize.X.Offset * scale, 0, self.settings.baseSize.Y.Offset * scale)
			end
		elseif self.state.instances[plot.Name] then
			self.state.instances[plot.Name]:Destroy()
			self.state.instances[plot.Name] = nil
			self.state.previousOwners[plot.Name] = nil
		end
	end
end

function SmartESP:Toggle()
	self.state.active = not self.state.active
	if self.state.connection then
		self.state.connection:Disconnect()
		self.state.connection = nil
	end
	if self.state.active then
		self.state.connection = RunService.Heartbeat:Connect(function()
			self:Update()
		end)
		self:Update()
	else
		self:ClearAll()
	end
end

function SmartESP:ClearAll()
	for _, instance in pairs(self.state.instances) do
		if instance then instance:Destroy() end
	end
	self.state.instances = {}
	self.state.previousOwners = {}
end

local espSystem = SmartESP.new()

-- BOOST Func
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
		part.Transparency = 1
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

-----------MAIN---------
gui.ResetOnSpawn = false
gui.Name = "RGBTabGUI"
gui.Parent = player:WaitForChild("PlayerGui")

toggleFrame.Size = UDim2.new(0, 60, 0, 60)
toggleFrame.Position = UDim2.new(0, 10, 0, 10)
toggleFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
toggleFrame.Active = true
toggleFrame.Draggable = true
toggleFrame.Parent = gui

toggleUICorner.CornerRadius = UDim.new(0, 4)

toggleStroke.Thickness = 2
toggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

toggleButton.Size = UDim2.new(1, 0, 1, 0)
toggleButton.BackgroundTransparency = 1
toggleButton.Text = "Toggle"
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.TextSize = 12
toggleButton.Font = Enum.Font.GothamBold
toggleButton.AutoButtonColor = false
toggleButton.Parent = toggleFrame

mainFrame.Size = UDim2.new(0, 300, 0, 285)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -140)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BackgroundTransparency = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

mainCorner.CornerRadius = UDim.new(0, 16)

mainStroke.Thickness = 3
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

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

-------------BOOST---------
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

----------BOOST MOBILE GUI------------
boostMobileGui.Name = "BoostMobileGUI"
boostMobileGui.ResetOnSpawn = false
boostMobileGui.Enabled = false
boostMobileGui.Parent = player:WaitForChild("PlayerGui")

boostFrame.Size = UDim2.new(0, 160, 0, 60)
boostFrame.Position = UDim2.new(0.5, -90, 0.7, 0)
boostFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
boostFrame.BackgroundTransparency = 0.15
boostFrame.Active = true
boostFrame.Draggable = true
boostFrame.ZIndex = 20
boostFrame.Parent = boostMobileGui
Instance.new("UICorner", boostFrame).CornerRadius = UDim.new(0, 10)

boostRGBStroke.Thickness = 2
boostRGBStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
boostRGBStroke.Color = Color3.fromRGB(255, 0, 0)

boostMiniBtn.Size = UDim2.new(1, -20, 0, 25)
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

boostBtn:GetPropertyChangedSignal("Text"):Connect(function()
	boostMiniBtn.Text = boostBtn.Text
end)

RunService.RenderStepped:Connect(function()
	if boostRGBStroke then
		boostRGBStroke.Color = Color3.fromHSV(hue, 1, 1)
	end
end)
-------------------FLOAT--------------
floatBtn.Name = "FloatButton"
floatBtn.Text = "Float: OFF"
floatBtn.Size = UDim2.new(1, -20, 0, 36)
floatBtn.Position = UDim2.new(0, 10, 0, 152)
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
-------------FLOAT MOBILE GUI----------
floatGui.Name = "FloatMobileGUI"
floatGui.ResetOnSpawn = false
floatGui.Enabled = false
floatGui.Parent = player:WaitForChild("PlayerGui")

floatFrame.Size = UDim2.new(0, 160, 0, 60)
floatFrame.Position = UDim2.new(0.5, -80, 0.6, 0)
floatFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
floatFrame.BackgroundTransparency = 0.15
floatFrame.Active = true
floatFrame.Draggable = true
floatFrame.ZIndex = 20
floatFrame.Parent = floatGui
Instance.new("UICorner", floatFrame).CornerRadius = UDim.new(0, 10)

floatRGB.Thickness = 2
floatRGB.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
floatRGB.Color = Color3.fromRGB(255, 0, 0)

timerLabel.Size = UDim2.new(1, 0, 0, 20)
timerLabel.Position = UDim2.new(0, 0, 0, 0)
timerLabel.BackgroundTransparency = 1
timerLabel.Text = "Timer: 20.0s"
timerLabel.Font = Enum.Font.Gotham
timerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
timerLabel.TextSize = 12
timerLabel.ZIndex = 21

startBtn.Size = UDim2.new(1, -20, 0, 25)
startBtn.Position = UDim2.new(0, 10, 0, 30)
startBtn.Text = "Start"
startBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 12
startBtn.ZIndex = 21
Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0, 6)
---------FLOAT FUNCTIONS---------
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

player.CharacterAdded:Connect(stopFlight)

-----------AUTO KICK----------
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

--------------------VISUAL------------------
-------------------ESP-----------------------
nameEspBtn.Text = "Nametag ESP: OFF"
nameEspBtn.Size = UDim2.new(1, -20, 0, 36)
nameEspBtn.Position = UDim2.new(0, 10, 0, 70)
nameEspBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
nameEspBtn.TextColor3 = Color3.new(1,1,1)
nameEspBtn.Font = Enum.Font.GothamBold
nameEspBtn.TextSize = 14
nameEspBtn.Visible = false
nameEspBtn.Parent = mainFrame
Instance.new("UICorner", nameEspBtn).CornerRadius = UDim.new(0, 8)

bodyEspBtn.Text = "Highlight ESP: OFF"
bodyEspBtn.Size = UDim2.new(1, -20, 0, 36)
bodyEspBtn.Position = UDim2.new(0, 10, 0, 110)
bodyEspBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
bodyEspBtn.TextColor3 = Color3.new(1,1,1)
bodyEspBtn.Font = Enum.Font.GothamBold
bodyEspBtn.TextSize = 14
bodyEspBtn.Visible = false
bodyEspBtn.Parent = mainFrame
Instance.new("UICorner", bodyEspBtn).CornerRadius = UDim.new(0, 8)

nameEspBtn.MouseButton1Click:Connect(function()
	nametagESPEnabled = not nametagESPEnabled
	nameEspBtn.Text = nametagESPEnabled and "Nametag ESP: ON" or "Nametag ESP: OFF"
	updateAllESPs()
end)

bodyEspBtn.MouseButton1Click:Connect(function()
	bodyESPEnabled = not bodyESPEnabled
	bodyEspBtn.Text = bodyESPEnabled and "Highlight ESP: ON" or "Highlight ESP: OFF"
	updateAllESPs()
end)

--basetime
espBtn.Text = "Time ESP: OFF"
espBtn.Size = UDim2.new(1, -20, 0, 36)
espBtn.Position = UDim2.new(0, 10, 0, 150)
espBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
espBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
espBtn.Font = Enum.Font.GothamBold
espBtn.TextSize = 14
espBtn.AutoButtonColor = false
espBtn.Visible = false
espBtn.Parent = mainFrame
Instance.new("UICorner", espBtn).CornerRadius = UDim.new(0, 8)

espBtn.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	espSystem:Toggle()
	espBtn.Text = espEnabled and "Time ESP: ON" or "Time ESP: OFF"
end)

-- Brainrot ESP
brainrotBtn.Text = "Brainrot ESP"
brainrotBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
brainrotBtn.Font = Enum.Font.GothamBold
brainrotBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
brainrotBtn.TextSize = 14
brainrotBtn.Size = UDim2.new(1, -20, 0, 36)
brainrotBtn.Position = UDim2.new(0, 10, 0, 190)
brainrotBtn.Visible = false
brainrotBtn.Parent = mainFrame
Instance.new("UICorner", brainrotBtn).CornerRadius = UDim.new(0, 8)

brainrotBtn.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ethz07/brainrot/refs/heads/main/ethzE.lua"))()
end)

-------------MISC-------------
--Kick and rejoin
RejoinBtn.Name = "RejoinButton"
RejoinBtn.Text = "Rejoin"
RejoinBtn.Size = UDim2.new(1, -20, 0, 36)
RejoinBtn.Position = UDim2.new(0, 10, 0, 110)
RejoinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
RejoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RejoinBtn.TextSize = 14
RejoinBtn.Font = Enum.Font.GothamBold
RejoinBtn.Visible = false
RejoinBtn.Parent = mainFrame
local UICornerRejoin = Instance.new("UICorner", RejoinBtn)
UICornerRejoin.CornerRadius = UDim.new(0, 8)

RejoinBtn.MouseButton1Click:Connect(function()
	local placeId = game.PlaceId
	local instanceId = game.JobId
	TeleportService:TeleportToPlaceInstance(placeId, instanceId)
end)

-------------setUp-----------
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
		nameEspBtn.Visible = (button.Name == "VisualButton")
                bodyEspBtn.Visible = (button.Name == "VisualButton")
		espBtn.Visible = (button.Name == "VisualButton")
		brainrotBtn.Visible = (button.Name == "VisualButton")
		RejoinBtn.Visible = (button.Name == "MiscButton")
	end)

	buttons[i] = button
	buttonStrokes[button] = stroke
end

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

selectedButton = buttons[1]
selectedStroke = buttonStrokes[selectedButton]
selectedStroke.Enabled = true
boostBtn.Visible = true
floatBtn.Visible = true
floatGuiBtn.Visible = true
boostMobileGuiBtn.Visible = true
autoKickBtn.Visible = true

print("RENZ SCRIPT")
