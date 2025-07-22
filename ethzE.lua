local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local petsData = {
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
	local frameCorner = Instance.new("UICorner", frame)
	frameCorner.CornerRadius = UDim.new(0, 10)

	-- Başlık barı
	local titleBar = Instance.new("Frame", frame)
	titleBar.Size = UDim2.new(1, 0, 0, 35)
	titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
	titleBar.BorderSizePixel = 0
	local titleCorner = Instance.new("UICorner", titleBar)
	titleCorner.CornerRadius = UDim.new(0, 10)

	local title = Instance.new("TextLabel", titleBar)
	title.Text = "ETHZ FARM TTS"
	title.Font = Enum.Font.FredokaOne
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 18
	title.Size = UDim2.new(1, -70, 1, 0)
	title.Position = UDim2.new(0, 10, 0, 0)
	title.BackgroundTransparency = 1
	title.TextXAlignment = Enum.TextXAlignment.Left

	-- Minimize Butonu
	local minimize = Instance.new("TextButton", titleBar)
	minimize.Text = "-"
	minimize.Font = Enum.Font.FredokaOne
	minimize.TextSize = 18
	minimize.Size = UDim2.new(0, 30, 0, 30)
	minimize.Position = UDim2.new(1, -65, 0, 2)
	minimize.BackgroundTransparency = 1
	minimize.TextColor3 = Color3.fromRGB(255, 215, 0)

	-- Close Butonu
	local close = Instance.new("TextButton", titleBar)
	close.Text = "X"
	close.Font = Enum.Font.FredokaOne
	close.TextSize = 18
	close.Size = UDim2.new(0, 30, 0, 30)
	close.Position = UDim2.new(1, -35, 0, 2)
	close.BackgroundTransparency = 1
	close.TextColor3 = Color3.fromRGB(255, 0, 0)

	-- Scroll alanı
	local scroll = Instance.new("ScrollingFrame", frame)
	scroll.Size = UDim2.new(1, 0, 1, -35)
	scroll.Position = UDim2.new(0, 0, 0, 35)
	scroll.CanvasSize = UDim2.new(0, 0, 0, 600)
	scroll.ScrollBarThickness = 5
	scroll.BackgroundTransparency = 1
	local uiList = Instance.new("UIListLayout", scroll)
	uiList.Padding = UDim.new(0, 8)
	uiList.SortOrder = Enum.SortOrder.LayoutOrder

	-- Toggle durumları
	local categoryToggles = {}

	-- Buton oluşturma fonksiyonu
	local function addCategory(name)
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
		local corner = Instance.new("UICorner", btn)
		corner.CornerRadius = UDim.new(0, 6)

		local toggle = Instance.new("Frame", holder)
		toggle.Size = UDim2.new(0, 25, 0, 25)
		toggle.Position = UDim2.new(1, -30, 0.5, -12)
		toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
		toggle.BorderSizePixel = 1
		toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
		local tCorner = Instance.new("UICorner", toggle)
		tCorner.CornerRadius = UDim.new(1, 0)

		categoryToggles[name] = false

		btn.MouseButton1Click:Connect(function()
			categoryToggles[name] = not categoryToggles[name]
			toggle.BackgroundColor3 = categoryToggles[name] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
			-- Load / Unload GUI burada olacak (devam scriptinde)
		end)
	end

	-- Kategoriler
	local petCategories = {"Common", "Rare", "Epic", "Legendary", "Mythic", "BrainrotGod", "Secret"}
	for _, cat in ipairs(petCategories) do
		addCategory(cat)
	end

	-- Buton işlevleri
	minimize.MouseButton1Click:Connect(function()
		scroll.Visible = not scroll.Visible
		frame.Size = scroll.Visible and UDim2.new(0, 260, 0, 350) or UDim2.new(0, 260, 0, 35)
	end)

	close.MouseButton1Click:Connect(function()
		gui:Destroy()
	end)
end


function loadPetWindow(category, petList)
	local gui = Instance.new("ScreenGui", Players.LocalPlayer.PlayerGui)
	gui.Name = "ESP_" .. category

	local frame = Instance.new("Frame", gui)
	frame.Size = UDim2.new(0, 260, 0, 300)
	frame.Position = UDim2.new(0.5, -130, 0.5, -150)
	frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	frame.Active = true
	frame.Draggable = true

	local uic = Instance.new("UICorner", frame)
	uic.CornerRadius = UDim.new(0, 10)

	local titleBar = Instance.new("Frame", frame)
	titleBar.Size = UDim2.new(1, 0, 0, 35)
	titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	titleBar.BorderSizePixel = 0
	titleBar.Active = true
	local titleUIC = Instance.new("UICorner", titleBar)
	titleUIC.CornerRadius = UDim.new(0, 10)
	titleBar.Parent = frame

	local title = Instance.new("TextLabel", titleBar)
	title.Size = UDim2.new(1, -70, 1, 0)
	title.Position = UDim2.new(0, 10, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = category .. " Pets"
	title.TextColor3 = Color3.new(1, 1, 1)
	title.Font = Enum.Font.FredokaOne
	title.TextSize = 16
	title.TextXAlignment = Enum.TextXAlignment.Left

	local scroll = Instance.new("ScrollingFrame", frame)
	scroll.Size = UDim2.new(1, -10, 1, -45)
	scroll.Position = UDim2.new(0, 5, 0, 40)
	scroll.BackgroundTransparency = 1
	scroll.ScrollBarThickness = 5
	local uiList = Instance.new("UIListLayout", scroll)
	uiList.Padding = UDim.new(0, 6)
	uiList.SortOrder = Enum.SortOrder.LayoutOrder

	local highlights = {}

	local function clearHighlights()
		for _, h in pairs(highlights) do
			if h.Highlight then h.Highlight:Destroy() end
			if h.TextGui then h.TextGui:Destroy() end
		end
		highlights = {}
	end

	local function createHighlightFor(name)
		for _, inst in pairs(workspace:GetDescendants()) do
			if inst:IsA("Model") and inst.Name == name then
				local h = Instance.new("Highlight")
				h.Name = "PetESP"
				h.FillColor = Color3.fromRGB(0, 255, 0)
				h.FillTransparency = 0.6
				h.OutlineColor = Color3.fromRGB(255, 255, 255)
				h.OutlineTransparency = 0
				h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				h.Adornee = inst
				h.Parent = inst

				local textGui = Instance.new("BillboardGui", inst)
				textGui.Adornee = inst
				textGui.Size = UDim2.new(0, 100, 0, 20)
				textGui.StudsOffset = Vector3.new(0, 2.5, 0)
				textGui.AlwaysOnTop = true

				local lbl = Instance.new("TextLabel", textGui)
				lbl.Size = UDim2.new(1, 0, 1, 0)
				lbl.BackgroundTransparency = 1
				lbl.Text = name
				lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
				lbl.Font = Enum.Font.FredokaOne
				lbl.TextScaled = true

				table.insert(highlights, {Highlight = h, TextGui = textGui})
			end
		end
	end

	-- Petleri değer sıralamasına göre sırala
	local sorted = {}
	for _, v in ipairs(petList) do
		if typeof(v) == "table" then
			local name = v[1]
			local val = v[2] and tonumber(v[2]:gsub("[^%d.]", "")) or 0
			table.insert(sorted, {name = name, value = val, raw = v[2]})
		else
			table.insert(sorted, {name = v, value = 0})
		end
	end
	table.sort(sorted, function(a, b)
		return a.value < b.value
	end)

	for _, entry in ipairs(sorted) do
		local container = Instance.new("Frame", scroll)
		container.Size = UDim2.new(1, -4, 0, 30)
		container.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		local uic = Instance.new("UICorner", container)
		uic.CornerRadius = UDim.new(0, 5)

		local btn = Instance.new("TextButton", container)
		btn.Size = UDim2.new(0.7, 0, 1, 0)
		btn.Position = UDim2.new(0, 0, 0, 0)
		btn.Text = entry.name
		btn.BackgroundTransparency = 1
		btn.TextColor3 = Color3.new(1, 1, 1)
		btn.TextSize = 13
		btn.Font = Enum.Font.FredokaOne

		local valLabel = nil
		if entry.raw then
			valLabel = Instance.new("TextLabel", container)
			valLabel.Size = UDim2.new(0.3, 0, 1, 0)
			valLabel.Position = UDim2.new(0.7, 0, 0, 0)
			valLabel.Text = entry.raw
			valLabel.Font = Enum.Font.FredokaOne
			valLabel.TextSize = 13
			valLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
			valLabel.TextStrokeTransparency = 0
			valLabel.BackgroundTransparency = 1
		end

		btn.MouseButton1Click:Connect(function()
			clearHighlights()
			createHighlightFor(entry.name)
		end)
	end

	scroll.CanvasSize = UDim2.new(0, 0, 0, uiList.AbsoluteContentSize.Y + 10)

	local close = Instance.new("TextButton", titleBar)
	close.Text = "X"
	close.Size = UDim2.new(0, 30, 0, 30)
	close.Position = UDim2.new(1, -35, 0, 2)
	close.BackgroundTransparency = 1
	close.TextColor3 = Color3.new(1, 0.2, 0.2)
	close.Font = Enum.Font.GothamBold
	close.TextSize = 18
	close.MouseButton1Click:Connect(function()
		clearHighlights()
		gui:Destroy()
		local mainGui = Players.LocalPlayer.PlayerGui:FindFirstChild("EthzESP_Hub")
		if mainGui then
			local scroll = mainGui:FindFirstChildOfClass("ScrollingFrame")
			if scroll then
				for _, f in pairs(scroll:GetChildren()) do
					if f:IsA("Frame") and f:FindFirstChild("TextButton") then
						local txt = f.TextButton.Text
						if txt:match(category) then
							f:FindFirstChildOfClass("Frame").BackgroundColor3 = Color3.fromRGB(255, 0, 0)
						end
					end
				end
			end
		end
	end)
end

print("working")

createGUI()
