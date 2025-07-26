local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local hue = 0
local selectedPetNames = {} -- tıklanan pet isimleri buraya yazılacak
local currentESPInstances = {} -- mevcut gösterilen ESP'leri takip eder

local petButtons = {
	["Brainrot God"] = {
		"Brainrot God Lucky Block",
		"Piccione Macchina",
		"Ballerino Lololo",
		"Trenostruzzo Turbo 3000",
		"Orcalero Orcala",
		"Statutino Libertino",
		"Odin Din Din Dun",
		"Espresso Signora",
		"Tigroligre Frutonni",
		"Tralalero Tralala",
		"Matteo",
		"Gattatino Neonino",
		"Girafa Celestre",
		"Cocofanto Elefanto"
	},
	["Secret"] = {
		"Secret Lucky Block",
		"Garama and Madundung",
		"Nuclearo Dinossauro",
		"La Grande Combinasion",
		"Chicleteira Bicicleteira",
		"Pot Hotspot",
		"Graipuss Medussi",
		"Las Vaquitas Saturnitas",
		"Las Tralaleritas",
		"Los Tralaleritos",
		"Torrtuginni Dragonfrutini",
		"Chimpanzini Spiderini",
		"La Vacca Saturno Saturnita"
	}
}

local function createAnimalESP(spawnPart, displayNameText, generationText, rarityText)
	local existing = spawnPart:FindFirstChild("AnimalESP")
	if existing then existing:Destroy() end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "AnimalESP"
	billboard.Adornee = spawnPart
	billboard.Size = UDim2.new(0, 200, 0, 80)
	billboard.StudsOffset = Vector3.new(0, 4, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = spawnPart

	local function createLabel(text, yOffset)
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 0.33, 0)
		label.Position = UDim2.new(0, 0, yOffset, 0)
		label.BackgroundTransparency = 1
		label.Text = text
		label.TextScaled = true
		label.Font = Enum.Font.GothamBold
		label.TextColor3 = Color3.new(1, 1, 1)
		label.TextStrokeTransparency = 0.4
		label.TextStrokeColor3 = Color3.new(0, 0, 0)
		label.Parent = billboard
	end

	createLabel(displayNameText, 0)
	createLabel(generationText, 0.33)
	createLabel(rarityText, 0.66)

	table.insert(currentESPInstances, billboard)
end

local function clearAllAnimalESP()
	for _, gui in pairs(currentESPInstances) do
		if gui and gui.Parent then gui:Destroy() end
	end
	table.clear(currentESPInstances)
end

local function scanAllBases()
	clearAllAnimalESP()

	local plotsFolder = workspace:FindFirstChild("Plots") or workspace:FindFirstChild("PlotSystem") or workspace:FindFirstChild("Bases")
	if not plotsFolder then return end

	for _, base in pairs(plotsFolder:GetChildren()) do
		local podiums = base:FindFirstChild("AnimalPodiums")
		if podiums then
			for _, podium in pairs(podiums:GetChildren()) do
				local basePart = podium:FindFirstChild("Base")
				if basePart then
					local spawn = basePart:FindFirstChild("Spawn")
					if spawn then
						local attachment = spawn:FindFirstChild("Attachment")
						local overhead = attachment and attachment:FindFirstChild("AnimalOverHead")
						if overhead then
							local displayName = overhead:FindFirstChild("DisplayName")
							local generation = overhead:FindFirstChild("Generation")
							local rarity = overhead:FindFirstChild("Rarity")

							if displayName and generation and rarity then
								if table.find(selectedPetNames, displayName.Text) then
									createAnimalESP(spawn, displayName.Text, generation.Text, rarity.Text)
								end
							end
						end
					end
				end
			end
		end
	end
end

scanAllBases()

local gui = Instance.new("ScreenGui")
gui.Name = "RGBTabGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local toggleFrame = Instance.new("Frame")
toggleFrame.Size = UDim2.new(0, 60, 0, 60)
toggleFrame.Position = UDim2.new(0, 10, 0, 10)
toggleFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
toggleFrame.Active = true
toggleFrame.Draggable = true
toggleFrame.Parent = gui

Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0, 4)

local toggleStroke = Instance.new("UIStroke", toggleFrame)
toggleStroke.Thickness = 2
toggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

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
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 16)

local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Thickness = 3
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -10, 0, 16)
titleLabel.Position = UDim2.new(0, 5, 0, 2)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Brainrot ESP | Renz SCRIPT"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamSemibold
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Center
titleLabel.TextYAlignment = Enum.TextYAlignment.Top
titleLabel.Parent = mainFrame

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -95)
scrollFrame.Position = UDim2.new(0, 10, 0, 70)
scrollFrame.BackgroundTransparency = 1
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 6
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.Visible = true
scrollFrame.Parent = mainFrame

local function createPetButtons(category)
	for _, child in ipairs(scrollFrame:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end

	for i, petName in ipairs(petButtons[category] or {}) do
		local btn = Instance.new("TextButton")
		btn.Text = petName
		btn.Size = UDim2.new(1, 0, 0, 32)
		btn.Position = UDim2.new(0, 0, 0, (i - 1) * 36)
		btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 13
		btn.AutoButtonColor = true
		btn.Parent = scrollFrame
		btn.Visible = true
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

		btn.MouseButton1Click:Connect(function()
			print("Selected pet:", petName, "from", category)
			table.clear(selectedPetNames)
table.insert(selectedPetNames, petName)
scanAllBases()
		end)
	end
end

-- func

local buttonNames = {"Brainrot God", "Secret"}
local buttons = {}
local buttonStrokes = {}
local selectedButton = nil
local selectedStroke = nil

local buttonWidth = 130
local buttonSpacing = 20
local totalWidth = (#buttonNames * buttonWidth) + ((#buttonNames - 1) * buttonSpacing)
local startX = (mainFrame.Size.X.Offset - totalWidth) / 2

for i, name in ipairs(buttonNames) do
	local btnName = name
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

	Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)

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
		createPetButtons(btnName)
	end)

	buttons[i] = button
	buttonStrokes[button] = stroke
end

selectedButton = buttons[1]
selectedStroke = buttonStrokes[selectedButton]
selectedStroke.Enabled = true
createPetButtons(buttonNames[1])

RunService.RenderStepped:Connect(function()
	hue = (hue + 0.01) % 1
	local rgb = Color3.fromHSV(hue, 1, 1)

	mainStroke.Color = rgb
	toggleStroke.Color = rgb
	toggleButton.TextColor3 = rgb

	if selectedButton and selectedStroke then
		selectedButton.TextColor3 = rgb
		selectedStroke.Color = rgb
	end
end)

toggleButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

print("sss")
