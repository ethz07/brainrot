local Players = game:GetService("Players") 
local RunService = game:GetService("RunService") 
local TweenService = game:GetService("TweenService") 
local LocalPlayer = Players.LocalPlayer 
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")

categoryToggles = {}
local activePetNames = {}

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

-- rainbow
local GRAPHEMES_PER_COLOR_LOOP = 16
local COLOR_SATURATION = 0.75

local function rainbowifyText(text: string): string
	local rainbowText = ""
	local currentColorIndex = Random.new():NextNumber() * GRAPHEMES_PER_COLOR_LOOP 
	for first, last in utf8.graphemes(text) do 
		local grapheme = text:sub(first, last)
		local isColoredGrapheme = grapheme ~= " "
		
		rainbowText ..= if not isColoredGrapheme then grapheme else ('<font color="#%s">%s</font>'):format(
			Color3.fromHSV(currentColorIndex / GRAPHEMES_PER_COLOR_LOOP % 1, COLOR_SATURATION, 1):ToHex(),
			grapheme
		)
		
		if isColoredGrapheme then
			currentColorIndex += 1
		end
	end
	return rainbowText
	end

local openPetGUIs = {}

local function clearESP(name)
	for _, model in pairs(Workspace:GetChildren()) do
		if model:IsA("Model") and model.Name == name then
			-- Etiket
			local label = model:FindFirstChild("PetESPLabel")
			if label then label:Destroy() end

			-- Beam & Attachments
			local part = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
			if part then
				local beam = part:FindFirstChild("PetESP_Beam")
				if beam then beam:Destroy() end

				local att = part:FindFirstChild("PetESP_Attachment")
				if att then att:Destroy() end
			end

			-- Oyuncu tarafındaki attachment
			local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			if root then
				local playerAtt = root:FindFirstChild("PlayerESP_Attachment")
				if playerAtt then playerAtt:Destroy() end
			end
		end
	end
	end

local function createESP(name, category)
	for _, model in pairs(Workspace:GetChildren()) do
		if model:IsA("Model") and model.Name == name and not model:FindFirstChild("PetESPLabel") then
			-- Billboard GUI
			local tag = Instance.new("BillboardGui")
			tag.Name = "PetESPLabel"
			tag.Adornee = model
			tag.Size = UDim2.new(0, 100, 0, 20)
			tag.StudsOffset = Vector3.new(0, 2.5, 0)
			tag.AlwaysOnTop = true
			tag.LightInfluence = 0
			tag.Parent = model

			local lbl = Instance.new("TextLabel", tag)
			lbl.Size = UDim2.new(1, 0, 1, 0)
			lbl.BackgroundTransparency = 1
			lbl.Font = Enum.Font.FredokaOne
			lbl.TextScaled = true
			lbl.RichText = true

			-- Renkler
			local lineColor1, lineColor2 = Color3.new(1,1,1), Color3.new(1,1,1)

			if category == "Secret" then
				lbl.Text = name
				lbl.TextColor3 = Color3.fromRGB(0, 0, 0)
				lbl.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
				lbl.TextStrokeTransparency = 0
				lineColor1 = Color3.fromRGB(255,255,255)
				lineColor2 = Color3.fromRGB(0,0,0)

			elseif category == "BrainrotGod" then
				lbl.Text = rainbowifyText(name)
				lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
				lbl.TextStrokeTransparency = 0.2
				-- Renk karışık olacak, beam kısmında özel ayarlanır

			else
				-- Kategoriye göre renk belirle
				if category == "Common" then
					lineColor1 = Color3.fromRGB(100, 100, 150)
					lineColor2 = Color3.fromRGB(150, 150, 200)
				elseif category == "Rare" then
					lineColor1 = Color3.fromRGB(80, 120, 200)
					lineColor2 = Color3.fromRGB(120, 160, 255)
				elseif category == "Epic" then
					lineColor1 = Color3.fromRGB(180, 70, 255)
					lineColor2 = Color3.fromRGB(210, 100, 255)
				elseif category == "Legendary" then
					lineColor1 = Color3.fromRGB(255, 215, 0)
					lineColor2 = Color3.fromRGB(255, 235, 100)
				elseif category == "Mythic" then
					lineColor1 = Color3.fromRGB(200, 50, 50)
					lineColor2 = Color3.fromRGB(255, 100, 100)
				end
				lbl.Text = name
				lbl.TextColor3 = lineColor2
				lbl.TextStrokeColor3 = lineColor1
				lbl.TextStrokeTransparency = 0
			end

			-- Line (Beam)
			local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			local primaryPart = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
			if root and primaryPart then
				local petAttachment = Instance.new("Attachment", primaryPart)
				petAttachment.Name = "PetESP_Attachment"

				local playerAttachment = Instance.new("Attachment")
				playerAttachment.Name = "PlayerESP_Attachment"
				playerAttachment.Position = Vector3.new(0, 0, 0)
				playerAttachment.Parent = root

				local beam = Instance.new("Beam")
				beam.Name = "PetESP_Beam"
				beam.Attachment0 = playerAttachment
				beam.Attachment1 = petAttachment
				beam.FaceCamera = true
				beam.Width0 = 0.15
				beam.Width1 = 0.15
				beam.Transparency = NumberSequence.new(0.4)

				if category == "BrainrotGod" then
					local colors = {}
					for i = 0, 1, 0.2 do
						local hsv = Color3.fromHSV(i, 1, 1)
						table.insert(colors, ColorSequenceKeypoint.new(i, hsv))
					end
					beam.Color = ColorSequence.new(colors)
				elseif category == "Secret" then
					beam.Color = ColorSequence.new{
						ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
						ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
					}
					beam.Transparency = NumberSequence.new(0.5)
				else
					beam.Color = ColorSequence.new{
						ColorSequenceKeypoint.new(0, lineColor1),
						ColorSequenceKeypoint.new(1, lineColor2)
					}
				end

				beam.Parent = primaryPart
			end
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
			createESP(name, category)
			activePetNames[name] = true
		else
			clearESP(name)
			activePetNames[name] = nil
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
	frame.Size = UDim2.new(0, 260, 0, 150)
	frame.Position = UDim2.new(0.5, -130, 1, -160)
	frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	frame.Active = true
	frame.Draggable = true
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

	local titleBar = Instance.new("Frame", frame)
	titleBar.Size = UDim2.new(1, 0, 0, 35)
	titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
	Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 8)
	titleBar.Parent = frame

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
	buttonFrame.Parent = titleBar

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

	local scroll = Instance.new("ScrollingFrame", frame)
	scroll.Size = UDim2.new(1, -10, 1, -50)
	scroll.Position = UDim2.new(0, 5, 0, 40)
	scroll.BackgroundTransparency = 1
	scroll.CanvasSize = UDim2.new(0, 0, 0, 300)
	scroll.ScrollBarThickness = 5

	local listLayout = Instance.new("UIListLayout", scroll)
	listLayout.Padding = UDim.new(0, 5)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	local petCategories = {"Secret", "BrainrotGod", "Mythic", "Legendary", "Epic", "Rare", "Common"}

	for _, name in ipairs(petCategories) do
		local btn = Instance.new("TextButton", scroll)
		btn.Text = name .. " ESP"
		btn.Size = UDim2.new(0.9, 0, 0, 30)
		btn.Font = Enum.Font.FredokaOne
		btn.TextSize = 14
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
		btn.BorderSizePixel = 0
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

		local toggle = Instance.new("Frame", btn)
		toggle.Size = UDim2.new(0, 20, 0, 20)
		toggle.Position = UDim2.new(1, -25, 0.5, -10)
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

	local footer = Instance.new("TextLabel", frame)
	footer.Text = "by _ethz on discord"
	footer.Font = Enum.Font.FredokaOne
	footer.TextColor3 = Color3.fromRGB(180, 180, 180)
	footer.TextSize = 12
	footer.BackgroundTransparency = 1
	footer.Size = UDim2.new(1, 0, 0, 20)
	footer.Position = UDim2.new(0, 0, 1, -20)
	footer.TextStrokeTransparency = 0.8
	footer.TextYAlignment = Enum.TextYAlignment.Center
	footer.TextXAlignment = Enum.TextXAlignment.Center

	local minimized = false
	minimizeButton.MouseButton1Click:Connect(function()
		minimized = not minimized
		scroll.Visible = not minimized
		frame.Size = minimized and UDim2.new(0, 260, 0, 35) or UDim2.new(0, 260, 0, 150)
	end)

	closeButton.MouseButton1Click:Connect(function()
		gui:Destroy()
	end)
	end

function sendNotification(title, text, duration)
	local StarterGui = game:GetService("StarterGui")
	StarterGui:SetCore("SendNotification", {
		Title = title,
		Text = text,
		Duration = duration or 5
	})
end

function playSound()
	local sound = Instance.new("Sound", game:GetService("SoundService"))
	sound.SoundId = "rbxassetid://9118823103" -- ding ses
	sound.Volume = 2
	sound:Play()
	game.Debris:AddItem(sound, 5)
end

local knownPets = {} -- ?

task.spawn(function()
	while true do
		for petName, _ in pairs(activePetNames) do
			for _, model in pairs(Workspace:GetChildren()) do
				if model:IsA("Model") and model.Name == petName and not model:FindFirstChild("PetESPLabel") then
					createESP(petName, category)
					sendNotification("New Pet!", petName .. " ESP uygulandı!", 5)
					playSound()
				end
			end
		end
		task.wait(1.2)
	end
end)

createMainGUI()
print("ZzZzZ")
print("by _ethz on discord!")
