--// 📦 Servisler
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local hue = 0

--// 🧱 Ana GUI
local gui = Instance.new("ScreenGui")
gui.Name = "RGBTabGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

--// 🔘 Toggle Butonu
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

--// 🪟 Ana Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 300)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 16)

local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Thickness = 3
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

--// Başlık
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

--// Scroll Alanı
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -110)
scrollFrame.Position = UDim2.new(0, 10, 0, 70)
scrollFrame.BackgroundTransparency = 1
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 6
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.Parent = mainFrame

--// Toggle Görünürlük
toggleButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

--// Sekmeler
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

--// Pet Buton Listesi
local petButtons = {
	["Brainrot God"] = {
		"Brainrot God Lucky Block",
		"Orcalero Orcala",
		"Trenostruzzo Turbo 3000",
		"Ballerino Lololo",
		"Piccione Macchina",
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

local function createPetButtons(category)
	scrollFrame:ClearAllChildren()
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
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

		btn.MouseButton1Click:Connect(function()
			print("Selected pet:", petName, "from", category)
		end)
	end
end

-- Başlangıçta ilk sekme aktif
selectedButton = buttons[1]
selectedStroke = buttonStrokes[selectedButton]
selectedStroke.Enabled = true
createPetButtons(buttonNames[1])

-- RGB Efekti
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
print("ss")
