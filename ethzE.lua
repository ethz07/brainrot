local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local petData = {
	Common = {
		"Noobini Pizzanini",
		"Lirilì Larilà",
		"Tim Cheese",
		"Fluriflura",
		"Svinina Bombardino",
		"Pipi Kiwi"
	},
	Rare = {
		"Trippi Troppi",
		"Tung Tung Tung Sahur",
		"Gangster Footera",
		"Bandito Bobritto",
		"Boneca Ambalabu",
		"Cacto Hipopotamo",
		"Ta Ta Ta Ta Sahur",
		"Tric Trac Baraboom"
	},
	Epic = {
		"Cappuccino Assassino",
		"Brr Brr Patapim",
		"Trulimero Trulicina",
		"Bambini Crostini",
		"Bananita Dolphinita",
		"Perochello Lemonchello",
		"Brri Brri Bicus Dicus Bombicus",
		"Avocadini Guffo"
	},
	Legendary = {
		"Burbaloni Loliloli",
		"Chimpanzini Bananini",
		"Ballerina Cappuccina",
		"Chef Crabracadabra",
		"Lionel Cactuseli",
		"Glorbo Fruttodrillo",
		"Blueberrinni Octopusini",
		"Strawberrelli Flamingelli",
		"Pandaccini Bananini"
	},
	Mythic = {
		"Mythic Lucky Block",
		"Frigo Camelo",
		"Orangutini Ananassini",
		"Rhino Toasterino",
		"Bombardiro Crocodilo",
		"Bombombini Gusini",
		"Cavallo Virtuoso",
		"Spioniro Golubiro",
		"Zibra Zubra Zibralini",
		"Tigrilini Watermelini"
	},
	["BrainrotGod"] = {
		{"Brainrot God Lucky Block", nil},
		{"Cocofanto Elefanto", "$10K/s"},
		{"Girafa Celestre", "$20K/s"},
		{"Gattatino Neonino", "$25K/s"},
		{"Matteo", "$50K/s"},
		{"Tralalero Tralala", "$50K/s"},
		{"Tigroligre Frutonni", "$60K/s"},
		{"Espresso Signora", "$70K/s"},
		{"Odin Din Din Dun", "$75K/s"},
		{"Statutino Libertino", "$75K/s"},
		{"Orcalero Orcala", "$100K/s"},
		{"Trenostruzzo Turbo 3000", "$150K/s"},
		{"Ballerino Lololo", "$200K/s"}
	},
	Secret = {
		{"Secret Lucky Block", nil},
		{"La Vacca Saturno Saturnita", "$250K/s"},
		{"Chimpanzini Spiderini", "$325K/s"},
		{"Torrtuginni Dragonfrutini", "$350K/s"},
		{"Los Tralaleritos", "$500K/s"},
		{"Las Tralaleritas", "$650K/s"},
		{"Graipuss Medussi", "$1M/s"},
		{"Pot Hotspot", "$2.5M/s"},
		{"La Grande Combinasion", "$10M/s"},
		{"Nuclearo Dinossauro", "$15M/s"},
		{"Garama and Madundung", "$50M/s"}
	}
}

-- 💡 ethz Pet ESP Hub (Animasyonlu, Şık, Toggle Sistemi, Multi ESP)

local workspace = game:GetService("Workspace")

-- ESP'yi sil
local function clearESP(name)
	for _, model in pairs(workspace:GetDescendants()) do
		if model:IsA("Model") and model.Name == name then
			local esp = model:FindFirstChild("PetESP")
			if esp then esp:Destroy() end
			local gui = model:FindFirstChild("PetESPLabel")
			if gui then gui:Destroy() end
		end
	end
end

-- ESP oluştur
local function createESP(name)
	for _, model in pairs(workspace:GetDescendants()) do
		if model:IsA("Model") and model.Name == name then
			if model:FindFirstChild("PetESP") then continue end

			local h = Instance.new("Highlight")
			h.Name = "PetESP"
			h.FillColor = Color3.fromRGB(0, 255, 0)
			h.FillTransparency = 0.6
			h.OutlineColor = Color3.fromRGB(255, 255, 255)
			h.OutlineTransparency = 0
			h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			h.Adornee = model
			h.Parent = model

			local tag = Instance.new("BillboardGui")
			tag.Name = "PetESPLabel"
			tag.Adornee = model
			tag.Size = UDim2.new(0, 100, 0, 20)
			tag.StudsOffset = Vector3.new(0, 2.5, 0)
			tag.AlwaysOnTop = true

			local lbl = Instance.new("TextLabel", tag)
			lbl.Size = UDim2.new(1, 0, 1, 0)
			lbl.BackgroundTransparency = 1
			lbl.Text = name
			lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
			lbl.Font = Enum.Font.FredokaOne
			lbl.TextScaled = true
			tag.Parent = model
		end
	end
end

-- Ana GUI oluştur
local function createGUI()
	local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
	gui.Name = "EthzESP_Hub"
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.IgnoreGuiInset = true

	local frame = Instance.new("Frame", gui)
	frame.Size = UDim2.new(0, 260, 0, 350)
	frame.Position = UDim2.new(0.5, -130, 0.5, -175)
	frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	frame.BorderSizePixel = 0
	frame.Active = true
	frame.Draggable = true
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

	local titleBar = Instance.new("Frame", frame)
	titleBar.Size = UDim2.new(1, 0, 0, 35)
	titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
	Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)

	local title = Instance.new("TextLabel", titleBar)
	title.Text = "ETHZ FARM TTS"
	title.Font = Enum.Font.FredokaOne
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 18
	title.Size = UDim2.new(1, -70, 1, 0)
	title.Position = UDim2.new(0, 10, 0, 0)
	title.BackgroundTransparency = 1
	title.TextXAlignment = Enum.TextXAlignment.Left

	local minimize = Instance.new("TextButton", titleBar)
	minimize.Text = "-"
	minimize.Font = Enum.Font.FredokaOne
	minimize.TextSize = 18
	minimize.Size = UDim2.new(0, 30, 0, 30)
	minimize.Position = UDim2.new(1, -65, 0, 2)
	minimize.BackgroundTransparency = 1
	minimize.TextColor3 = Color3.fromRGB(255, 215, 0)

	local close = Instance.new("TextButton", titleBar)
	close.Text = "X"
	close.Font = Enum.Font.FredokaOne
	close.TextSize = 18
	close.Size = UDim2.new(0, 30, 0, 30)
	close.Position = UDim2.new(1, -35, 0, 2)
	close.BackgroundTransparency = 1
	close.TextColor3 = Color3.fromRGB(255, 0, 0)

	local scroll = Instance.new("ScrollingFrame", frame)
	scroll.Size = UDim2.new(1, 0, 1, -35)
	scroll.Position = UDim2.new(0, 0, 0, 35)
	scroll.CanvasSize = UDim2.new(0, 0, 0, 600)
	scroll.ScrollBarThickness = 5
	scroll.BackgroundTransparency = 1
	local uiList = Instance.new("UIListLayout", scroll)
	uiList.Padding = UDim.new(0, 8)
	uiList.SortOrder = Enum.SortOrder.LayoutOrder

	local categoryToggles = {}

	local function addCategory(name)
		createPetListGUI(name, petData[name])
		local holder = Instance.new("Frame", scroll)
		holder.Size = UDim2.new(1, -10, 0, 35)
		holder.BackgroundTransparency = 1

		local btn = Instance.new("TextButton", holder)
		btn.Text = name .. " ESP"
		btn.Size = UDim2.new(0.75, 0, 1, 0)
		btn.Font = Enum.Font.FredokaOne
		btn.TextSize = 14
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
		btn.BorderSizePixel = 0
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

		local toggle = Instance.new("Frame", holder)
		toggle.Size = UDim2.new(0, 25, 0, 25)
		toggle.Position = UDim2.new(1, -30, 0.5, -12)
		toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
		toggle.BorderSizePixel = 1
		toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

		categoryToggles[name] = false

		btn.MouseButton1Click:Connect(function()
			categoryToggles[name] = not categoryToggles[name]
			toggle.BackgroundColor3 = categoryToggles[name] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)

			if categoryToggles[name] then
				createESP(name)
			else
				clearESP(name)
			end
		end)
	end

	local petCategories = {"Common", "Rare", "Epic", "Legendary", "Mythic", "BrainrotGod", "Secret"}
	for _, cat in ipairs(petCategories) do
		addCategory(cat)
	end

	minimize.MouseButton1Click:Connect(function()
		scroll.Visible = not scroll.Visible
		frame.Size = scroll.Visible and UDim2.new(0, 260, 0, 350) or UDim2.new(0, 260, 0, 35)
	end)

	close.MouseButton1Click:Connect(function()
		gui:Destroy()
	end)
end

-- 💡 ethz Pet ESP Hub (Animasyonlu, Şık, Toggle Sistemi, Multi ESP)


-- 📦 Pet listesi (isim + değer) local petData = { Common = { {"Noobini Pizzanini"}, {"Lirilì Larilà"}, {"Tim Cheese"}, {"Fluriflura"}, {"Svinina Bombardino"}, {"Pipi Kiwi"} }, Rare = { {"Trippi Troppi"}, {"Tung Tung Tung Sahur"}, {"Gangster Footera"}, {"Bandito Bobritto"}, {"Boneca Ambalabu"}, {"Cacto Hipopotamo"}, {"Ta Ta Ta Ta Sahur"}, {"Tric Trac Baraboom"} }, Epic = { {"Cappuccino Assassino"}, {"Brr Brr Patapim"}, {"Trulimero Trulicina"}, {"Bambini Crostini"}, {"Bananita Dolphinita"}, {"Perochello Lemonchello"}, {"Brri Brri Bicus Dicus Bombicus"}, {"Avocadini Guffo"} }, Legendary = { {"Burbaloni Loliloli"}, {"Chimpanzini Bananini"}, {"Ballerina Cappuccina"}, {"Chef Crabracadabra"}, {"Lionel Cactuseli"}, {"Glorbo Fruttodrillo"}, {"Blueberrinni Octopusini"}, {"Strawberrelli Flamingelli"}, {"Pandaccini Bananini"} }, Mythic = { {"Mythic Lucky Block"}, {"Frigo Camelo"}, {"Orangutini Ananassini"}, {"Rhino Toasterino"}, {"Bombardiro Crocodilo"}, {"Bombombini Gusini"}, {"Cavallo Virtuoso"}, {"Spioniro Golubiro"}, {"Zibra Zubra Zibralini"}, {"Tigrilini Watermelini"} }, BrainrotGod = { {"Brainrot God Lucky Block"}, {"Cocofanto Elefanto", "$10K/s"}, {"Girafa Celestre", "$20K/s"}, {"Gattatino Neonino", "$25K/s"}, {"Matteo", "$50K/s"}, {"Tralalero Tralala", "$50K/s"}, {"Tigroligre Frutonni", "$60K/s"}, {"Espresso Signora", "$70K/s"}, {"Odin Din Din Dun", "$75K/s"}, {"Statutino Libertino", "$75K/s"}, {"Orcalero Orcala", "$100K/s"}, {"Trenostruzzo Turbo 3000", "$150K/s"}, {"Ballerino Lololo", "$200K/s"} }, Secret = { {"Secret Lucky Block"}, {"La Vacca Saturno Saturnita", "$250K/s"}, {"Chimpanzini Spiderini", "$325K/s"}, {"Torrtuginni Dragonfrutini", "$350K/s"}, {"Los Tralaleritos", "$500K/s"}, {"Las Tralaleritas", "$650K/s"}, {"Graipuss Medussi", "$1M/s"}, {"Pot Hotspot", "$2.5M/s"}, {"La Grande Combinasion", "$10M/s"}, {"Nuclearo Dinossauro", "$15M/s"}, {"Garama and Madundung", "$50M/s"} } }

local function createPetListGUI(category, pets) local gui = Instance.new("ScreenGui", LocalPlayer.PlayerGui) gui.Name = "PetList_" .. category gui.IgnoreGuiInset = true gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 300)
frame.Position = UDim2.new(0.5, -125, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", frame)
title.Text = category .. " Pets"
title.Font = Enum.Font.FredokaOne
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -70, 0, 30)
title.Position = UDim2.new(0, 10, 0, 0)
title.TextXAlignment = Enum.TextXAlignment.Left

local close = Instance.new("TextButton", frame)
close.Text = "X"
close.Size = UDim2.new(0, 25, 0, 25)
close.Position = UDim2.new(1, -30, 0, 3)
close.TextColor3 = Color3.fromRGB(255, 0, 0)
close.BackgroundTransparency = 1
close.Font = Enum.Font.FredokaOne
close.TextSize = 18
close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -10, 1, -40)
scroll.Position = UDim2.new(0, 5, 0, 35)
scroll.CanvasSize = UDim2.new(0, 0, 0, #pets * 40)
scroll.ScrollBarThickness = 5
scroll.BackgroundTransparency = 1
local list = Instance.new("UIListLayout", scroll)
list.Padding = UDim.new(0, 6)
list.SortOrder = Enum.SortOrder.LayoutOrder

local espToggles = {}

for _, entry in pairs(pets) do
	local name, val = unpack(entry)
	local holder = Instance.new("Frame", scroll)
	holder.Size = UDim2.new(1, 0, 0, 35)
	holder.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
	Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 6)

	local btn = Instance.new("TextButton", holder)
	btn.Text = name
	btn.Size = UDim2.new(0.6, 0, 1, 0)
	btn.Position = UDim2.new(0, 0, 0, 0)
	btn.BackgroundTransparency = 1
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextSize = 13
	btn.Font = Enum.Font.FredokaOne

	local toggle = Instance.new("Frame", holder)
	toggle.Size = UDim2.new(0, 22, 0, 22)
	toggle.Position = UDim2.new(1, -30, 0.5, -11)
	toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	toggle.BorderSizePixel = 1
	toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

	if val then
		local label = Instance.new("TextLabel", holder)
		label.Text = val
		label.Font = Enum.Font.FredokaOne
		label.TextSize = 12
		label.TextColor3 = Color3.fromRGB(255, 215, 0)
		label.TextStrokeTransparency = 0
		label.BackgroundTransparency = 1
		label.Position = UDim2.new(0.6, 5, 0, 0)
		label.Size = UDim2.new(0.4, -35, 1, 0)
	end

	espToggles[name] = false
	btn.MouseButton1Click:Connect(function()
		espToggles[name] = not espToggles[name]
		toggle.BackgroundColor3 = espToggles[name] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
		if espToggles[name] then
			createESP(name)
		else
			clearESP(name)
		end
	end)
end

-- createGUI() kısmında addCategory içinde bu GUI'yi çağır: -- örnek: createPetListGUI(name, petData[name])
createGUI()
