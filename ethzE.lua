local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Ana GUI
local mainGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
mainGui.Name = "PetESPMainGUI"
mainGui.ResetOnSpawn = false
mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 350)
frame.Position = UDim2.new(0.02, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = mainGui

local UICorner = Instance.new("UICorner", frame)
UICorner.CornerRadius = UDim.new(0, 10)

-- Başlık
local title = Instance.new("TextLabel", frame)
title.Text = "Pet ESP Toggle"
title.Font = Enum.Font.FredokaOne
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 18
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
title.Parent = frame

local UICorner2 = Instance.new("UICorner", title)
UICorner2.CornerRadius = UDim.new(0, 10)

-- Toggle Durum Göstergesi Oluştur
local function createToggleIndicator(parent)
	local indicator = Instance.new("Frame", parent)
	indicator.Size = UDim2.new(0, 20, 0, 20)
	indicator.Position = UDim2.new(1, -25, 0.5, -10)
	indicator.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
	indicator.BorderColor3 = Color3.fromRGB(0, 0, 0)
	indicator.BorderSizePixel = 1
	local corner = Instance.new("UICorner", indicator)
	corner.CornerRadius = UDim.new(1, 0)
	return indicator
end

-- ESP Toggle Sistemleri
local toggleStates = {}
local petCategories = {
	["Common ESP"] = common_pets,
	["Rare ESP"] = rare_pets,
	["Epic ESP"] = epic_pets,
	["Legendary ESP"] = legendary_pets,
	["Mythic ESP"] = mythic_pets,
	["BrainrotGod ESP"] = brainrotgod_pets,
	["Secret ESP"] = secret_pets
}
local buttons = {}

local function createMainButton(name, i)
	local btn = Instance.new("TextButton", frame)
	btn.Text = name
	btn.Font = Enum.Font.FredokaOne
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.TextSize = 14
	btn.Size = UDim2.new(0.85, 0, 0, 35)
	btn.Position = UDim2.new(0.075, 0, 0, 40 + (i - 1) * 40)
	btn.BackgroundColor3 = Color3.fromRGB(0, 32, 96)
	btn.BorderSizePixel = 0
	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, 6)

	local indicator = createToggleIndicator(btn)
	toggleStates[name] = false

	btn.MouseButton1Click:Connect(function()
		toggleStates[name] = not toggleStates[name]
		indicator.BackgroundColor3 = toggleStates[name] and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(150, 0, 0)

		if toggleStates[name] then
			-- Alt GUI'yi aç
			spawn(function()
				loadPetGui(name, petCategories[name])
			end)
		else
			-- İlgili highlight'ları sil
			clearCategoryESP(petCategories[name])
		end
	end)
	buttons[name] = btn
end

-- Butonları oluştur
local i = 1
for catName, _ in pairs(petCategories) do
	createMainButton(catName, i)
	i += 1
end

-- 2. Alt GUI paneli ve pet ESP toggle'ları
function loadPetGui(categoryName, petList)
	local petGui = Instance.new("ScreenGui", player.PlayerGui)
	petGui.Name = categoryName:gsub(" ", "") .. "_Panel"
	petGui.ResetOnSpawn = false
	local frame = Instance.new("Frame", petGui)
	frame.Size = UDim2.new(0, 300, 0, 40 + #petList * 35)
	frame.Position = UDim2.new(0.35, 0, 0.3, 0)
	frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	frame.BorderSizePixel = 0
	frame.Active = true
	frame.Draggable = true

	local title = Instance.new("TextLabel", frame)
	title.Text = categoryName
	title.Font = Enum.Font.FredokaOne
	title.TextColor3 = Color3.new(1, 1, 1)
	title.TextSize = 16
	title.Size = UDim2.new(1, -60, 0, 30)
	title.Position = UDim2.new(0, 10, 0, 5)
	title.BackgroundTransparency = 1
	title.TextXAlignment = Enum.TextXAlignment.Left

	local close = Instance.new("TextButton", frame)
	close.Text = "X"
	close.Font = Enum.Font.FredokaOne
	close.TextColor3 = Color3.fromRGB(255, 100, 100)
	close.TextSize = 18
	close.Size = UDim2.new(0, 25, 0, 25)
	close.Position = UDim2.new(1, -30, 0, 5)
	close.BackgroundTransparency = 1

	local minimize = Instance.new("TextButton", frame)
	minimize.Text = "-"
	minimize.Font = Enum.Font.FredokaOne
	minimize.TextColor3 = Color3.fromRGB(255, 255, 0)
	minimize.TextSize = 18
	minimize.Size = UDim2.new(0, 25, 0, 25)
	minimize.Position = UDim2.new(1, -60, 0, 5)
	minimize.BackgroundTransparency = 1

	local content = Instance.new("Frame", frame)
	content.Position = UDim2.new(0, 0, 0, 35)
	content.Size = UDim2.new(1, 0, 1, -35)
	content.BackgroundTransparency = 1

	local petToggles = {}

	for i, pet in ipairs(petList) do
		local btn = Instance.new("TextButton", content)
		btn.Text = pet
		btn.Size = UDim2.new(0.85, 0, 0, 30)
		btn.Position = UDim2.new(0.075, 0, 0, (i - 1) * 35)
		btn.Font = Enum.Font.FredokaOne
		btn.TextScaled = true
		btn.BackgroundColor3 = Color3.fromRGB(0, 32, 96)
		btn.TextColor3 = Color3.new(1, 1, 1)
		local corner = Instance.new("UICorner", btn)
		corner.CornerRadius = UDim.new(0, 6)

		local state = false

		btn.MouseButton1Click:Connect(function()
			state = not state
			if state then
				btn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
				highlightPet(pet)
			else
				btn.BackgroundColor3 = Color3.fromRGB(0, 32, 96)
				clearESPByName(pet)
			end
		end)
	end

	minimize.MouseButton1Click:Connect(function()
		content.Visible = not content.Visible
	end)

	close.MouseButton1Click:Connect(function()
		petGui:Destroy()
		-- tüm highlight'ları temizle
		for _, p in ipairs(petList) do
			clearESPByName(p)
		end
		toggleStates[categoryName] = false
		if buttons[categoryName] then
			buttons[categoryName].BackgroundColor3 = Color3.fromRGB(0, 32, 96)
			local ind = buttons[categoryName]:FindFirstChildOfClass("Frame")
			if ind then
				ind.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
			end
		end
	end)
end

-- 3. ESP highlight + tag oluşturma
local activeHighlights = {}

function highlightPet(petName)
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("Model") and obj.Name == petName then
			if activeHighlights[obj] then continue end

			local h = Instance.new("Highlight", obj)
			h.Name = "PetESP"
			h.FillColor = Color3.fromRGB(0, 255, 0)
			h.FillTransparency = 0.65
			h.OutlineColor = Color3.fromRGB(255, 255, 255)
			h.OutlineTransparency = 0
			h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			h.Adornee = obj

			local tag = Instance.new("BillboardGui", obj)
			tag.Name = "PetTag"
			tag.Adornee = obj:FindFirstChildWhichIsA("BasePart")
			tag.Size = UDim2.new(0, 100, 0, 20)
			tag.StudsOffset = Vector3.new(0, 3, 0)
			tag.AlwaysOnTop = true

			local text = Instance.new("TextLabel", tag)
			text.Size = UDim2.new(1, 0, 1, 0)
			text.BackgroundTransparency = 1
			text.Text = petName
			text.TextColor3 = Color3.new(1, 1, 1)
			text.TextScaled = true
			text.Font = Enum.Font.FredokaOne

			activeHighlights[obj] = true
		end
	end
end

-- 3.1 Belirli bir pet'in ESP'sini temizle
function clearESPByName(petName)
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("Model") and obj.Name == petName then
			if obj:FindFirstChild("PetESP") then
				obj.PetESP:Destroy()
			end
			if obj:FindFirstChild("PetTag") then
				obj.PetTag:Destroy()
			end
			activeHighlights[obj] = nil
		end
	end
end

-- 3.2 Bir kategoriye ait tüm petlerin ESP'sini temizle
function clearCategoryESP(petList)
	for _, name in ipairs(petList) do
		clearESPByName(name)
	end
end

-- 4. Yeni petler eklendikçe ESP ekle (aktifse)
RunService.Heartbeat:Connect(function()
	for categoryName, isEnabled in pairs(toggleStates) do
		if isEnabled then
			local list = petCategories[categoryName]
			for _, petName in ipairs(list) do
				for _, obj in ipairs(workspace:GetDescendants()) do
					if obj:IsA("Model") and obj.Name == petName and not obj:FindFirstChild("PetESP") then
						highlightPet(petName)
					end
				end
			end
		end
	end
end)

-- 5. Oyuncu respawn olursa tüm GUI'leri kapat
player.CharacterAdded:Connect(function()
	for _, gui in ipairs(player.PlayerGui:GetChildren()) do
		if gui.Name:find("_Panel") or gui.Name == "PetESPMainGUI" then
			gui:Destroy()
		end
	end
end)
