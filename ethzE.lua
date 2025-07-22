-- ethz ESP GUI Full System (by @ethz)
-- Tüm pet verilerini al
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

local categories = {
	"Common", "Rare", "Epic", "Legendary", "Mythic", "Brainrot God", "Secret"
}

local parsedPets = {}

for line in petData:gmatch("[^\r\n]+") do
	if line:match("^%-") then
		currentCategory = line:sub(3)
		parsedPets[currentCategory] = {}
	elseif currentCategory then
		table.insert(parsedPets[currentCategory], line)
	end
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local mainGui = Instance.new("ScreenGui", playerGui)
mainGui.Name = "ethzESPMainGui"
mainGui.ResetOnSpawn = false
mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Ana Frame
local frame = Instance.new("Frame", mainGui)
frame.Size = UDim2.new(0, 270, 0, 400)
frame.Position = UDim2.new(0, 20, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", frame)
title.Text = "ethz ESP Hub"
title.Font = Enum.Font.FredokaOne
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)
title.Size = UDim2.new(1, -40, 0, 35)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left

local minimize = Instance.new("TextButton", frame)
minimize.Text = "-"
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 18
minimize.TextColor3 = Color3.new(1, 1, 0)
minimize.Size = UDim2.new(0, 20, 0, 20)
minimize.Position = UDim2.new(1, -50, 0, 8)
minimize.BackgroundTransparency = 1

local close = Instance.new("TextButton", frame)
close.Text = "X"
close.Font = Enum.Font.GothamBold
close.TextSize = 18
close.TextColor3 = Color3.new(1, 0.2, 0.2)
close.Size = UDim2.new(0, 20, 0, 20)
close.Position = UDim2.new(1, -25, 0, 8)
close.BackgroundTransparency = 1

local content = Instance.new("Frame", frame)
content.Size = UDim2.new(1, 0, 1, -40)
content.Position = UDim2.new(0, 0, 0, 40)
content.BackgroundTransparency = 1

local function createToggleCircle(state)
	local circle = Instance.new("Frame")
	circle.Size = UDim2.new(0, 20, 0, 20)
	circle.BackgroundColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
	circle.BorderSizePixel = 1
	circle.BorderColor3 = Color3.new(0, 0, 0)
	Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
	return circle
end

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

	local activeESP = {}

	local function clearESP()
		for _, v in pairs(activeESP) do
			if v.hl then v.hl:Destroy() end
			if v.txt then v.txt:Destroy() end
		end
		activeESP = {}
	end

	local function addESP(name)
		local obj = workspace:FindFirstChild(name)
		if not obj then return end

		local hl = Instance.new("Highlight", obj)
		hl.FillColor = Color3.fromRGB(0,255,0)
		hl.OutlineColor = Color3.fromRGB(255,255,255)
		hl.FillTransparency = 0.65
		hl.OutlineTransparency = 0
		hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

		local tag = Instance.new("BillboardGui", obj)
		tag.Size = UDim2.new(0, 120, 0, 25)
		tag.StudsOffset = Vector3.new(0, 3, 0)
		tag.AlwaysOnTop = true

		local lbl = Instance.new("TextLabel", tag)
		lbl.Size = UDim2.new(1, 0, 1, 0)
		lbl.Text = name
		lbl.Font = FONT
		lbl.TextColor3 = Color3.new(1,1,1)
		lbl.TextScaled = true
		lbl.BackgroundTransparency = 1
		lbl.TextStrokeTransparency = 0.2
		lbl.TextStrokeColor3 = Color3.new(0,0,0)

		activeESP[name] = {hl = hl, txt = tag}
	end

	local function refreshESP()
		clearESP()
		for _, child in ipairs(scroll:GetChildren()) do
			if child:IsA("TextButton") and child:GetAttribute("Selected") then
				addESP(child.Name)
			end
		end
	end

	for _, line in ipairs(petList) do
		local name, value = line:match("^(.-)%s+%-%s+(%$.-)$")
		name = name or line
		local btn = Instance.new("TextButton", scroll)
		btn.Size = UDim2.new(1, -10, 0, value and 60 or 40)
		btn.BackgroundColor3 = Color3.fromRGB(45, 45, 75)
		btn.Text = name
		btn.Name = name
		btn.Font = FONT
		btn.TextSize = 14
		btn.TextColor3 = Color3.new(1,1,1)
		btn.TextXAlignment = Enum.TextXAlignment.Left
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

		btn.MouseButton1Click:Connect(function()
			local state = not btn:GetAttribute("Selected")
			btn:SetAttribute("Selected", state)
			btn.BackgroundColor3 = state and Color3.fromRGB(0,200,0) or Color3.fromRGB(45,45,75)
			refreshESP()
		end)

		if value then
			local valLabel = Instance.new("TextLabel", btn)
			valLabel.Text = value
			valLabel.Font = FONT
			valLabel.TextColor3 = Color3.new(1, 1, 0)
			valLabel.TextSize = 12
			valLabel.Position = UDim2.new(0, 10, 1, -18)
			valLabel.Size = UDim2.new(1, -20, 0, 15)
			valLabel.BackgroundTransparency = 1
			valLabel.TextStrokeTransparency = 0
			valLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
		end
	end

	minBtn.MouseButton1Click:Connect(function()
		scroll.Visible = not scroll.Visible
		frame.Size = scroll.Visible and UDim2.new(0, 260, 0, 300) or UDim2.new(0, 260, 0, 35)
	end)

	closeBtn.MouseButton1Click:Connect(function()
		clearESP()
		gui:Destroy()
		if _G.ethzToggle then
			_G.ethzToggle(category, false)
		end
	end)

	return gui
end

-- Global fonksiyonlar
local openGuis = {}

_G.ethzOpenCategory = function(cat)
	if openGuis[cat] then return end
	local list = parsedPets[cat]
	if list then
		openGuis[cat] = createPetGUI(cat, list)
	end
end

_G.ethzCloseCategory = function(cat)
	if openGuis[cat] then
		openGuis[cat]:Destroy()
		openGuis[cat] = nil
	end
end
