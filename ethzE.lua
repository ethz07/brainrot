-- ethz ESP GUI Full System (by @ethz)
-- Tüm pet verilerini al
-- PET LİSTESİ (ayrıştırma için)
local petData = [[
- Common

Noobini Pizzanini
Lirilì Larilà
Tim Cheese
Fluriflura
Svinina Bombardino
Pipi Kiwi

- Rare

Trippi Troppi
Tung Tung Tung Sahur
Gangster Footera
Bandito Bobritto
Boneca Ambalabu
Cacto Hipopotamo
Ta Ta Ta Ta Sahur
Tric Trac Baraboom

- Epic

Cappuccino Assassino
Brr Brr Patapim
Trulimero Trulicina
Bambini Crostini
Bananita Dolphinita
Perochello Lemonchello
Brri Brri Bicus Dicus Bombicus
Avocadini Guffo

- Legendary

Burbaloni Loliloli
Chimpanzini Bananini
Ballerina Cappuccina
Chef Crabracadabra
Lionel Cactuseli
Glorbo Fruttodrillo
Blueberrinni Octopusini
Strawberrelli Flamingelli
Pandaccini Bananini

- Mythic

Mythic Lucky Block
Frigo Camelo
Orangutini Ananassini
Rhino Toasterino
Bombardiro Crocodilo
Bombombini Gusini
Cavallo Virtuoso
Spioniro Golubiro
Zibra Zubra Zibralini
Tigrilini Watermelini

- Brainrot God

Brainrot God Lucky Block - Unknown
Cocofanto Elefanto - $10K/s
Girafa Celestre - $20K/s
Gattatino Neonino - $25K/s
Matteo - $50K/s
Tralalero Tralala - $50K/s
Tigroligre Frutonni - $60K/s
Espresso Signora - $70K/s
Odin Din Din Dun - $75K/s
Statutino Libertino - $75K/s
Orcalero Orcala - $100K/s
Trenostruzzo Turbo 3000 - $150K/s
Ballerino Lololo - $200K/s

- Secret

Secret Lucky Block - Unknown
La Vacca Saturno Saturnita - $250K/s
Chimpanzini Spiderini - $325K/s
Torrtuginni Dragonfrutini - $350K/s
Los Tralaleritos - $500K/s
Las Tralaleritas - $650K/s
Graipuss Medussi - $1M/s
Pot Hotspot - $2.5M/s
La Grande Combinasion - $10M/s
Nuclearo Dinossauro - $15M/s
Garama and Madundung - $50M/s
]]

-- LİSTEYİ PARSE ET
local parsedPets = {}
local currentCategory = nil

for line in petData:gmatch("[^\r\n]+") do
	if line:match("^%s*%-") then
		currentCategory = line:match("^%-+%s*(.+)")
		parsedPets[currentCategory] = {}
	elseif currentCategory and line:match("%S") then
		table.insert(parsedPets[currentCategory], line)
	end
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Toggle durumları
local toggleStates = {}
local openGuis = {}

-- Ana GUI
local mainGui = Instance.new("ScreenGui", playerGui)
mainGui.Name = "ethzESPMainGui"
mainGui.ResetOnSpawn = false
mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local mainFrame = Instance.new("Frame", mainGui)
mainFrame.Size = UDim2.new(0, 260, 0, 340)
mainFrame.Position = UDim2.new(0, 20, 0.5, -170)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local titleBar = Instance.new("Frame", mainFrame)
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", titleBar)
title.Text = "ethz ESP Hub"
title.Font = Enum.Font.FredokaOne
title.TextSize = 16
title.TextColor3 = Color3.new(1,1,1)
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left

local minimizeBtn = Instance.new("TextButton", titleBar)
minimizeBtn.Text = "-"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.TextColor3 = Color3.new(1, 1, 0)
minimizeBtn.Size = UDim2.new(0, 20, 0, 20)
minimizeBtn.Position = UDim2.new(1, -45, 0, 8)
minimizeBtn.BackgroundTransparency = 1

local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.new(1, 0.2, 0.2)
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Position = UDim2.new(1, -25, 0, 8)
closeBtn.BackgroundTransparency = 1

local content = Instance.new("Frame", mainFrame)
content.Name = "ButtonArea"
content.Size = UDim2.new(1, 0, 1, -35)
content.Position = UDim2.new(0, 0, 0, 35)
content.BackgroundTransparency = 1

-- Toggle yuvarlak ikon oluştur
local function createToggleCircle(state)
	local circle = Instance.new("Frame")
	circle.Size = UDim2.new(0, 20, 0, 20)
	circle.BackgroundColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
	circle.BorderSizePixel = 1
	circle.BorderColor3 = Color3.new(0, 0, 0)
	Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
	return circle
end

-- Toggle durumunu GUI dışında da kontrol için ayarla
_G.ethzToggle = function(category, state)
	toggleStates[category] = state
	for _, btn in pairs(content:GetChildren()) do
		if btn:IsA("TextButton") and btn.Name == category and btn:FindFirstChild("ToggleCircle") then
			btn.ToggleCircle.BackgroundColor3 = state and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
		end
	end
end

-- Buton oluşturucu
local categories = {
	"Common", "Rare", "Epic", "Legendary", "Mythic", "Brainrot God", "Secret"
}

for i, category in ipairs(categories) do
	local btn = Instance.new("TextButton", content)
	btn.Name = category
	btn.Size = UDim2.new(0.85, 0, 0, 40)
	btn.Position = UDim2.new(0.075, 0, 0, (i-1)*45)
	btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	btn.Text = category .. " ESP"
	btn.Font = Enum.Font.FredokaOne
	btn.TextColor3 = Color3.new(1,1,1)
	btn.TextSize = 14
	btn.TextXAlignment = Enum.TextXAlignment.Left
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

	local toggle = createToggleCircle(false)
	toggle.Name = "ToggleCircle"
	toggle.Position = UDim2.new(1, -25, 0.5, -10)
	toggle.Parent = btn

	toggleStates[category] = false

	btn.MouseButton1Click:Connect(function()
		toggleStates[category] = not toggleStates[category]
		toggle.BackgroundColor3 = toggleStates[category] and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
		if toggleStates[category] then
			if _G.ethzOpenCategory then _G.ethzOpenCategory(category) end
		else
			if _G.ethzCloseCategory then _G.ethzCloseCategory(category) end
		end
	end)
end

-- Minimize & Close
minimizeBtn.MouseButton1Click:Connect(function()
	content.Visible = not content.Visible
	mainFrame.Size = content.Visible and UDim2.new(0, 260, 0, 340) or UDim2.new(0, 260, 0, 35)
end)

closeBtn.MouseButton1Click:Connect(function()
	for _, v in pairs(toggleStates) do
		if v and _G.ethzCloseCategory then
			_G.ethzCloseCategory(category)
		end
	end
	mainGui:Destroy()
end)

-- ..

local toggleStates = {}

local function createCategoryButton(category, index)
	local btn = Instance.new("TextButton", content)
	btn.Size = UDim2.new(0.85, 0, 0, 35)
	btn.Position = UDim2.new(0.05, 0, 0, (index-1) * 40)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.FredokaOne
	btn.TextSize = 14
	btn.Text = category .. " ESP"
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.AutoButtonColor = false
	btn.Name = category
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

	local circle = createToggleCircle(false)
	circle.Position = UDim2.new(1, -25, 0.5, -10)
	circle.Parent = btn

	toggleStates[category] = false

	btn.MouseButton1Click:Connect(function()
		toggleStates[category] = not toggleStates[category]
		circle.BackgroundColor3 = toggleStates[category] and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
		if toggleStates[category] then
			_G.ethzOpenCategory(category)
		else
			if _G.ethzCloseCategory then
				_G.ethzCloseCategory(category)
			end
		end
	end)
end

for i, cat in ipairs(categories) do
	createCategoryButton(cat, i)
end

minimize.MouseButton1Click:Connect(function()
	content.Visible = not content.Visible
	frame.Size = content.Visible and UDim2.new(0, 270, 0, 400) or UDim2.new(0, 270, 0, 35)
end)

close.MouseButton1Click:Connect(function()
	mainGui:Destroy()
end)

-- Font ve değer ayarları
local FONT = Enum.Font.FredokaOne

local function createPetGUI(category, petList)
	local gui = Instance.new("ScreenGui", playerGui)
	gui.Name = "PetGUI_" .. category
	gui.ResetOnSpawn = false

	local frame = Instance.new("Frame", gui)
	frame.Size = UDim2.new(0, 260, 0, 300)
	frame.Position = UDim2.new(0, 300, 0.5, -150)
	frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	frame.BorderSizePixel = 0
	frame.Active = true
	frame.Draggable = true
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

	local titleBar = Instance.new("Frame", frame)
	titleBar.Size = UDim2.new(1, 0, 0, 35)
	titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	titleBar.BorderSizePixel = 0
	Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)
	titleBar.Parent = frame

	local title = Instance.new("TextLabel", titleBar)
	title.Text = category .. " Pets"
	title.Font = FONT
	title.TextColor3 = Color3.new(1,1,1)
	title.TextSize = 16
	title.BackgroundTransparency = 1
	title.Size = UDim2.new(1, -40, 1, 0)
	title.Position = UDim2.new(0, 10, 0, 0)
	title.TextXAlignment = Enum.TextXAlignment.Left

	local closeBtn = Instance.new("TextButton", titleBar)
	closeBtn.Text = "X"
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.TextSize = 16
	closeBtn.TextColor3 = Color3.new(1, 0.2, 0.2)
	closeBtn.Size = UDim2.new(0, 20, 0, 20)
	closeBtn.Position = UDim2.new(1, -30, 0, 8)
	closeBtn.BackgroundTransparency = 1

	local minBtn = Instance.new("TextButton", titleBar)
	minBtn.Text = "-"
	minBtn.Font = Enum.Font.GothamBold
	minBtn.TextSize = 16
	minBtn.TextColor3 = Color3.new(1, 1, 0)
	minBtn.Size = UDim2.new(0, 20, 0, 20)
	minBtn.Position = UDim2.new(1, -55, 0, 8)
	minBtn.BackgroundTransparency = 1

	local scroll = Instance.new("ScrollingFrame", frame)
	scroll.Position = UDim2.new(0, 0, 0, 35)
	scroll.Size = UDim2.new(1, 0, 1, -35)
	scroll.CanvasSize = UDim2.new(0, 0, 0, #petList * 60)
	scroll.ScrollBarThickness = 6
	scroll.BackgroundTransparency = 1

	local layout = Instance.new("UIListLayout", scroll)
	layout.Padding = UDim.new(0, 5)
end

	local activeESP = {}

	-- ESP highlight sistemi için referanslar
local allESP = {} -- her kategori için highlight'lar

local function clearESP(category)
	if allESP[category] then
		for _, esp in pairs(allESP[category]) do
			if esp.hl then esp.hl:Destroy() end
			if esp.gui then esp.gui:Destroy() end
		end
		allESP[category] = nil
	end
end

local function createESP(category, petName)
	clearESP(category)
	allESP[category] = {}

	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("Model") or obj:IsA("Part") then
			if obj.Name == petName then
				local hl = Instance.new("Highlight")
				hl.Adornee = obj
				hl.FillColor = Color3.fromRGB(0, 255, 0)
				hl.OutlineColor = Color3.new(1, 1, 1)
				hl.FillTransparency = 0.65
				hl.OutlineTransparency = 0
				hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				hl.Parent = obj

				local gui = Instance.new("BillboardGui", obj)
				gui.Size = UDim2.new(0, 100, 0, 25)
				gui.StudsOffset = Vector3.new(0, 3, 0)
				gui.AlwaysOnTop = true

				local label = Instance.new("TextLabel", gui)
				label.Size = UDim2.new(1, 0, 1, 0)
				label.BackgroundTransparency = 1
				label.Text = petName
				label.Font = Enum.Font.FredokaOne
				label.TextColor3 = Color3.new(1, 1, 1)
				label.TextStrokeColor3 = Color3.new(0, 0, 0)
				label.TextStrokeTransparency = 0.2
				label.TextScaled = true

				table.insert(allESP[category], {hl = hl, gui = gui})
			end
		end
	end
end

-- Kategori GUI oluşturur
_G.ethzOpenCategory = function(category)
	if openGuis[category] then return end

	local petList = parsedPets[category]
	if not petList then return end

	local gui = Instance.new("ScreenGui", playerGui)
	gui.Name = "PetGUI_" .. category
	gui.ResetOnSpawn = false

	local frame = Instance.new("Frame", gui)
	frame.Size = UDim2.new(0, 240, 0, 300)
	frame.Position = UDim2.new(0, 300, 0.5, -150)
	frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	frame.BorderSizePixel = 0
	frame.Active = true
	frame.Draggable = true
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

	local titleBar = Instance.new("Frame", frame)
	titleBar.Size = UDim2.new(1, 0, 0, 35)
	titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)
	titleBar.Parent = frame

	local title = Instance.new("TextLabel", titleBar)
	title.Text = category .. " Pets"
	title.Font = Enum.Font.FredokaOne
	title.TextColor3 = Color3.new(1,1,1)
	title.TextSize = 16
	title.BackgroundTransparency = 1
	title.Size = UDim2.new(1, -40, 1, 0)
	title.Position = UDim2.new(0, 10, 0, 0)
	title.TextXAlignment = Enum.TextXAlignment.Left

	local closeBtn = Instance.new("TextButton", titleBar)
	closeBtn.Text = "X"
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.TextSize = 16
	closeBtn.TextColor3 = Color3.new(1, 0.2, 0.2)
	closeBtn.Size = UDim2.new(0, 20, 0, 20)
	closeBtn.Position = UDim2.new(1, -30, 0, 8)
	closeBtn.BackgroundTransparency = 1

	local minBtn = Instance.new("TextButton", titleBar)
	minBtn.Text = "-"
	minBtn.Font = Enum.Font.GothamBold
	minBtn.TextSize = 16
	minBtn.TextColor3 = Color3.new(1, 1, 0)
	minBtn.Size = UDim2.new(0, 20, 0, 20)
	minBtn.Position = UDim2.new(1, -55, 0, 8)
	minBtn.BackgroundTransparency = 1

	local scroll = Instance.new("ScrollingFrame", frame)
	scroll.Position = UDim2.new(0, 0, 0, 35)
	scroll.Size = UDim2.new(1, 0, 1, -35)
	scroll.CanvasSize = UDim2.new(0, 0, 0, #petList * 50)
	scroll.ScrollBarThickness = 6
	scroll.BackgroundTransparency = 1

	local layout = Instance.new("UIListLayout", scroll)
	layout.Padding = UDim.new(0, 4)

	for _, line in ipairs(petList) do
		local name, value = line:match("^(.-)%s+%-%s+(%$.-)$")
		name = name or line

		local btn = Instance.new("TextButton", scroll)
		btn.Size = UDim2.new(1, -10, 0, value and 50 or 40)
		btn.BackgroundColor3 = Color3.fromRGB(45, 45, 75)
		btn.Text = name
		btn.Name = name
		btn.Font = Enum.Font.FredokaOne
		btn.TextSize = 14
		btn.TextColor3 = Color3.new(1,1,1)
		btn.TextXAlignment = Enum.TextXAlignment.Left
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

		local toggle = Instance.new("Frame", btn)
		toggle.Size = UDim2.new(0, 18, 0, 18)
		toggle.Position = UDim2.new(1, -25, 0.5, -9)
		toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
		toggle.BorderSizePixel = 1
		toggle.BorderColor3 = Color3.new(0, 0, 0)
		Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

		local active = false

		btn.MouseButton1Click:Connect(function()
			active = not active
			toggle.BackgroundColor3 = active and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
			if active then
				createESP(category, name)
			else
				clearESP(category)
			end
		end)

		if value then
			local lbl = Instance.new("TextLabel", btn)
			lbl.Text = value
			lbl.Font = Enum.Font.FredokaOne
			lbl.TextColor3 = Color3.new(1, 1, 0)
			lbl.TextSize = 12
			lbl.Position = UDim2.new(0, 10, 1, -18)
			lbl.Size = UDim2.new(1, -20, 0, 15)
			lbl.BackgroundTransparency = 1
			lbl.TextStrokeTransparency = 0
			lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
		end
	end

	minBtn.MouseButton1Click:Connect(function()
		scroll.Visible = not scroll.Visible
		frame.Size = scroll.Visible and UDim2.new(0, 240, 0, 300) or UDim2.new(0, 240, 0, 35)
	end)

	closeBtn.MouseButton1Click:Connect(function()
		clearESP(category)
		gui:Destroy()
		openGuis[category] = nil
		if _G.ethzToggle then
			_G.ethzToggle(category, false)
		end
	end)

	openGuis[category] = gui
end

-- Kapat fonksiyonu
_G.ethzCloseCategory = function(category)
	if openGuis[category] then
		openGuis[category]:Destroy()
		openGuis[category] = nil
		clearESP(category)
		if _G.ethzToggle then
			_G.ethzToggle(category, false)
		end
	end
end
