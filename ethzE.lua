local Players = game:GetService("Players") local RunService = game:GetService("RunService") local TweenService = game:GetService("TweenService") local LocalPlayer = Players.LocalPlayer local Workspace = game:GetService("Workspace")

local SoundService = game:GetService("SoundService")

local petData = {
	Common = {
		{"Noobini Pizzanini"}, {"Lirilì Larilà"}, {"Tim Cheese"}, {"Fluriflura"}, {"Svinina Bombardino"}, {"Pipi Kiwi"}
	},
	Rare = {
		{"Trippi Troppi"}, {"Tung Tung Tung Sahur"}, {"Gangster Footera"}, {"Bandito Bobritto"},
		{"Boneca Ambalabu"}, {"Cacto Hipopotamo"}, {"Ta Ta Ta Ta Sahur"}, {"Tric Trac Baraboom"}
	},
	Epic = {
		{"Cappuccino Assassino"}, {"Brr Brr Patapim"}, {"Trulimero Trulicina"}, {"Bambini Crostini"},
		{"Bananita Dolphinita"}, {"Perochello Lemonchello"}, {"Brri Brri Bicus Dicus Bombicus"}, {"Avocadini Guffo"}
	},
	Legendary = {
		{"Burbaloni Loliloli"}, {"Chimpanzini Bananini"}, {"Ballerina Cappuccina"}, {"Chef Crabracadabra"},
		{"Lionel Cactuseli"}, {"Glorbo Fruttodrillo"}, {"Blueberrinni Octopusini"}, {"Strawberrelli Flamingelli"},
		{"Pandaccini Bananini"}
	},
	Mythic = {
		{"Mythic Lucky Block"}, {"Frigo Camelo"}, {"Orangutini Ananassini"}, {"Rhino Toasterino"},
		{"Bombardiro Crocodilo"}, {"Bombombini Gusini"}, {"Cavallo Virtuoso"}, {"Spioniro Golubiro"},
		{"Zibra Zubra Zibralini"}, {"Tigrilini Watermelini"}
	},
	BrainrotGod = {
		{"Brainrot God Lucky Block"}, {"Cocofanto Elefanto", "$10K/s"}, {"Girafa Celestre", "$20K/s"},
		{"Gattatino Neonino", "$25K/s"}, {"Matteo", "$50K/s"}, {"Tralalero Tralala", "$50K/s"},
		{"Tigroligre Frutonni", "$60K/s"}, {"Espresso Signora", "$70K/s"}, {"Odin Din Din Dun", "$75K/s"},
		{"Statutino Libertino", "$75K/s"}, {"Orcalero Orcala", "$100K/s"}, {"Trenostruzzo Turbo 3000", "$150K/s"},
		{"Ballerino Lololo", "$200K/s"}
	},
	Secret = {
		{"Secret Lucky Block"}, {"La Vacca Saturno Saturnita", "$250K/s"}, {"Chimpanzini Spiderini", "$325K/s"},
		{"Torrtuginni Dragonfrutini", "$350K/s"}, {"Los Tralaleritos", "$500K/s"}, {"Las Tralaleritas", "$650K/s"},
		{"Graipuss Medussi", "$1M/s"}, {"Pot Hotspot", "$2.5M/s"}, {"La Grande Combinasion", "$10M/s"},
		{"Nuclearo Dinossauro", "$15M/s"}, {"Garama and Madundung", "$50M/s"}
	}
}

local categoryToggles = {}

local openPetGUIs = {}

local function clearESP(name) for _, model in pairs(Workspace:GetDescendants()) do if model:IsA("Model") and model.Name == name then local esp = model:FindFirstChild("PetESP") if esp then esp:Destroy() end local gui = model:FindFirstChild("PetESPLabel") if gui then gui:Destroy() end end end end

local function createESP(name) for _, model in pairs(Workspace:GetDescendants()) do if model:IsA("Model") and model.Name == name then if model:FindFirstChild("PetESP") then continue end

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

local function createPetListGUI(category, pets) if openPetGUIs[category] then openPetGUIs[category]:Destroy() openPetGUIs[category] = nil return end

local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "PetList_" .. category
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
openPetGUIs[category] = gui

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 200)
frame.Position = UDim2.new(0.5, -125, 1, -210)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", frame)
title.Text = category .. " Pets"
title.Font = Enum.Font.FredokaOne
title.TextSize = 14
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -50, 0, 25)
title.Position = UDim2.new(0, 10, 0, 0)
title.TextXAlignment = Enum.TextXAlignment.Left

local close = Instance.new("TextButton", frame)
close.Text = "X"
close.Size = UDim2.new(0, 25, 0, 25)
close.Position = UDim2.new(1, -30, 0, 0)
close.TextColor3 = Color3.fromRGB(255, 0, 0)
close.BackgroundTransparency = 1
close.Font = Enum.Font.FredokaOne
close.TextSize = 18
close.MouseButton1Click:Connect(function()
	gui:Destroy()
	openPetGUIs[category] = nil
end)

local minimize = Instance.new("TextButton", frame)
minimize.Text = "-"
minimize.Size = UDim2.new(0, 25, 0, 25)
minimize.Position = UDim2.new(1, -60, 0, 3)
minimize.TextColor3 = Color3.fromRGB(255, 215, 0)
minimize.BackgroundTransparency = 1
minimize.Font = Enum.Font.FredokaOne
minimize.TextSize = 18

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -10, 1, -30)
scroll.Position = UDim2.new(0, 5, 0, 30)
scroll.CanvasSize = UDim2.new(0, 0, 0, #pets * 40)
scroll.ScrollBarThickness = 5
scroll.BackgroundTransparency = 1
local list = Instance.new("UIListLayout", scroll)
list.Padding = UDim.new(0, 6)
list.SortOrder = Enum.SortOrder.LayoutOrder

local minimized = false
local originalSize = frame.Size
local originalScrollVisible = scroll.Visible

minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        scroll.Visible = false
        frame.Size = UDim2.new(0, 250, 0, 35)
    else
        scroll.Visible = true
        frame.Size = originalSize
    end
end)

for _, entry in pairs(pets) do
	local name, val = unpack(entry)
	local holder = Instance.new("Frame", scroll)
	holder.Size = UDim2.new(1, 0, 0, 30)
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

	local isOn = false
	btn.MouseButton1Click:Connect(function()
		isOn = not isOn
		toggle.BackgroundColor3 = isOn and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
		if isOn then
			createESP(name)
		else
			clearESP(name)
		end
	end)
end

end

local function createMainGUI()
    local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
    gui.Name = "Brainrot ESP"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 260, 0, 295)
    frame.Position = UDim2.new(0.5, -130, 1, -270)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    frame.Active = true
    frame.Draggable = true
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

    local titleBar = Instance.new("Frame", frame)
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    titleBar.BorderSizePixel = 0
    Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 8)

    local title = Instance.new("TextLabel", titleBar)
    title.Text = "Brainrot ESP"
    title.Font = Enum.Font.FredokaOne
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 16
    title.Size = UDim2.new(1, -60, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.TextXAlignment = Enum.TextXAlignment.Left

    local buttonFrame = Instance.new("Frame", titleBar)
    buttonFrame.Size = UDim2.new(0, 60, 1, 0)
    buttonFrame.Position = UDim2.new(1, -60, 0, 0)
    buttonFrame.BackgroundTransparency = 1

    local minimizeButton = Instance.new("TextButton", buttonFrame)
    minimizeButton.Text = "-"
    minimizeButton.Font = Enum.Font.FredokaOne
    minimizeButton.TextSize = 18
    minimizeButton.TextColor3 = Color3.fromRGB(255, 215, 0)
    minimizeButton.Size = UDim2.new(0.5, 0, 1, 0)
    minimizeButton.BackgroundTransparency = 1

    local closeButton = Instance.new("TextButton", buttonFrame)
    closeButton.Text = "X"
    closeButton.Font = Enum.Font.FredokaOne
    closeButton.TextSize = 18
    closeButton.TextColor3 = Color3.fromRGB(255, 50, 50)
    closeButton.Size = UDim2.new(0.5, 0, 1, 0)
    closeButton.Position = UDim2.new(0.5, 0, 0, 0)
    closeButton.BackgroundTransparency = 1

    buttonFrame.Parent = titleBar

    local content = Instance.new("Frame", frame)
    content.Name = "Content"
    content.Size = UDim2.new(1, 0, 1, -35)
    content.Position = UDim2.new(0, 0, 0, 35)
    content.BackgroundTransparency = 1

    local list = Instance.new("UIListLayout", content)
    list.Padding = UDim.new(0, 6)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local petCategories = {"Common", "Rare", "Epic", "Legendary", "Mythic", "BrainrotGod", "Secret"}

    for _, name in ipairs(petCategories) do
        local btnFrame = Instance.new("Frame", content)
        btnFrame.Size = UDim2.new(0.9, 0, 0, 32)
        btnFrame.BackgroundTransparency = 1

        local btn = Instance.new("TextButton", btnFrame)
        btn.Text = name .. " ESP"
        btn.Size = UDim2.new(0.75, 0, 1, 0)
        btn.Font = Enum.Font.FredokaOne
        btn.TextSize = 14
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        btn.BorderSizePixel = 0
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

        local toggle = Instance.new("Frame", btnFrame)
        toggle.Size = UDim2.new(0, 25, 0, 25)
        toggle.Position = UDim2.new(1, -30, 0.5, -12)
        toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        toggle.BorderSizePixel = 1
        toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

        local state = false
        btn.MouseButton1Click:Connect(function()
            state = not state
            toggle.BackgroundColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            createPetListGUI(name, petData[name])
        end)
    end

    local minimized = false
    minimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        content.Visible = not minimized
        frame.Size = minimized and UDim2.new(0, 260, 0, 35) or UDim2.new(0, 260, 0, 295)
    end)

    closeButton.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)
end

-- Bildirim sesi
local function playNotifySound()
	local sound = Instance.new("Sound", SoundService)
	sound.SoundId = "rbxassetid://9118823102" -- Bildirim sesi örneği
	sound.Volume = 1
	sound:Play()
	game.Debris:AddItem(sound, 3)
end

-- Sağ alttan görsel bildirim
local function notifyPetSpawn(petName)
	local screenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
	screenGui.Name = "EthzNotification"
	screenGui.ResetOnSpawn = false

	local frame = Instance.new("Frame", screenGui)
	frame.Size = UDim2.new(0, 230, 0, 40)
	frame.Position = UDim2.new(1, -240, 1, -50)
	frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
	frame.BorderSizePixel = 0
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

	local text = Instance.new("TextLabel", frame)
	text.Size = UDim2.new(1, -10, 1, 0)
	text.Position = UDim2.new(0, 5, 0, 0)
	text.BackgroundTransparency = 1
	text.Text = "Yeni Pet Geldi: " .. petName
	text.Font = Enum.Font.FredokaOne
	text.TextColor3 = Color3.fromRGB(255, 255, 255)
	text.TextScaled = true

	playNotifySound()

	-- Otomatik yok etme
	delay(5, function()
		screenGui:Destroy()
	end)
end

local knownPets = {}

RunService.Heartbeat:Connect(function()
	for _, model in pairs(workspace:GetDescendants()) do
		if model:IsA("Model") and not knownPets[model] then
			for category, pets in pairs(petData) do
				for _, entry in ipairs(pets) do
					local petName = typeof(entry) == "table" and entry[1] or entry
					if model.Name == petName then
						if categoryToggles[category] then
							knownPets[model] = true
							createESP(model.Name)
							showNotification("Yeni Pet Geldi: " .. petName)
						end
					end
				end
			end
		end
	end
end)

createMainGUI()
print("zzz")
