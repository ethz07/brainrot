local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local hue = 0

local gui = Instance.new("ScreenGui")
gui.Name = "RGBTabGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Toggle Frame
local toggleFrame = Instance.new("Frame")
toggleFrame.Size = UDim2.new(0, 60, 0, 60)
toggleFrame.Position = UDim2.new(0, 10, 0, 10)
toggleFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
toggleFrame.Active = true
toggleFrame.Draggable = true
toggleFrame.Parent = gui

local toggleUICorner = Instance.new("UICorner", toggleFrame)
toggleUICorner.CornerRadius = UDim.new(0, 4)

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

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 285)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -140)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0, 16)

local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Thickness = 3
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Title Label
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

-- Toggle butonu, mainFrame'i göster/gizle
toggleButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

-- Sekme isimleri
local buttonNames = {"Brainrot God", "Secret"}
local buttons = {}
local buttonStrokes = {}

local selectedButton = nil
local selectedStroke = nil

-- Geniş ve ortalanmış butonlar
local buttonWidth = 130
local buttonSpacing = 20
local totalWidth = (#buttonNames * buttonWidth) + ((#buttonNames - 1) * buttonSpacing)
local startX = (mainFrame.Size.X.Offset - totalWidth) / 2

-- Butonları oluştur
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
	end)

	buttons[i] = button
	buttonStrokes[button] = stroke
end

RunService.RenderStepped:Connect(function()
	hue = (hue + 0.01) % 1
	local rgb = Color3.fromHSV(hue, 1, 1)

	-- Ana GUI renkleri
	mainStroke.Color = rgb
	toggleStroke.Color = rgb
	toggleButton.TextColor3 = rgb

	-- Seçilen butona RGB renk uygula
	if selectedButton and selectedStroke then
		selectedButton.TextColor3 = rgb
		selectedStroke.Color = rgb
	end
end)

-- İlk buton seçili olarak başlat
selectedButton = buttons[1]
selectedStroke = buttonStrokes[selectedButton]
selectedStroke.Enabled = true
