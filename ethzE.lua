local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- Pet Kategorileri
local petData = {
    ["Common"] = {
        "Noobini Pizzanini", "Lirilì Larilà", "Tim Cheese", "Fluriflura", "Svinina Bombardino", "Pipi Kiwi"
    },
    ["Rare"] = {
        "Trippi Troppi", "Tung Tung Tung Sahur", "Gangster Footera", "Bandito Bobritto", "Boneca Ambalabu",
        "Cacto Hipopotamo", "Ta Ta Ta Ta Sahur", "Tric Trac Baraboom"
    },
    ["Epic"] = {
        "Cappuccino Assassino", "Brr Brr Patapim", "Trulimero Trulicina", "Bambini Crostini", "Bananita Dolphinita",
        "Perochello Lemonchello", "Brri Brri Bicus Dicus Bombicus", "Avocadini Guffo"
    },
    ["Legendary"] = {
        "Burbaloni Loliloli", "Chimpanzini Bananini", "Ballerina Cappuccina", "Chef Crabracadabra", "Lionel Cactuseli",
        "Glorbo Fruttodrillo", "Blueberrinni Octopusini", "Strawberrelli Flamingelli", "Pandaccini Bananini"
    },
    ["Mythic"] = {
        "Mythic Lucky Block", "Frigo Camelo", "Orangutini Ananassini", "Rhino Toasterino", "Bombardiro Crocodilo",
        "Bombombini Gusini", "Cavallo Virtuoso", "Spioniro Golubiro", "Zibra Zubra Zibralini", "Tigrilini Watermelini"
    },
    ["BrainrotGod"] = {
        {name="Brainrot God Lucky Block", value="Unknown"}, {name="Cocofanto Elefanto", value="$10K/s"},
        {name="Girafa Celestre", value="$20K/s"}, {name="Gattatino Neonino", value="$25K/s"},
        {name="Matteo", value="$50K/s"}, {name="Tralalero Tralala", value="$50K/s"},
        {name="Tigroligre Frutonni", value="$60K/s"}, {name="Espresso Signora", value="$70K/s"},
        {name="Odin Din Din Dun", value="$75K/s"}, {name="Statutino Libertino", value="$75K/s"},
        {name="Orcalero Orcala", value="$100K/s"}, {name="Trenostruzzo Turbo 3000", value="$150K/s"},
        {name="Ballerino Lololo", value="$200K/s"}
    },
    ["Secret"] = {
        {name="Secret Lucky Block", value="Unknown"}, {name="La Vacca Saturno Saturnita", value="$250K/s"},
        {name="Chimpanzini Spiderini", value="$325K/s"}, {name="Torrtuginni Dragonfrutini", value="$350K/s"},
        {name="Los Tralaleritos", value="$500K/s"}, {name="Las Tralaleritas", value="$650K/s"},
        {name="Graipuss Medussi", value="$1M/s"}, {name="Pot Hotspot", value="$2.5M/s"},
        {name="La Grande Combinasion", value="$10M/s"}, {name="Nuclearo Dinossauro", value="$15M/s"},
        {name="Garama and Madundung", value="$50M/s"}
    }
}

local mainGui = Instance.new("ScreenGui", player.PlayerGui)
mainGui.Name = "PetESP_UI"
mainGui.ResetOnSpawn = false
mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local mainFrame = Instance.new("Frame", mainGui)
mainFrame.Size = UDim2.new(0, 220, 0, 260)
mainFrame.Position = UDim2.new(0.02, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

local uicorner = Instance.new("UICorner", mainFrame)
uicorner.CornerRadius = UDim.new(0, 10)

local titleBar = Instance.new("Frame", mainFrame)
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
local titleCorner = Instance.new("UICorner", titleBar)
titleCorner.CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", titleBar)
title.Text = "Brainrot ESP"
title.Font = Enum.Font.FredokaOne
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 16
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.TextXAlignment = Enum.TextXAlignment.Left

-- ✅ Minimize/Close
local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Text = "×"
closeBtn.Font = Enum.Font.FredokaOne
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.Size = UDim2.new(0, 30, 1, 0)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.BackgroundTransparency = 1

-- Minimize Butonu
local minimizeBtn = Instance.new("TextButton", titleBar)
minimizeBtn.Text = "−"
minimizeBtn.Font = Enum.Font.FredokaOne
minimizeBtn.TextSize = 18
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 80)
minimizeBtn.Size = UDim2.new(0, 30, 1, 0)
minimizeBtn.Position = UDim2.new(1, -60, 0, 0)
minimizeBtn.BackgroundTransparency = 1

local minimized = false

minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    contentFrame.Visible = not minimized
end)

local contentFrame = Instance.new("ScrollingFrame", mainFrame)
contentFrame.Size = UDim2.new(1, -10, 1, -40)
contentFrame.Position = UDim2.new(0, 5, 0, 35)
contentFrame.ScrollBarThickness = 5
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
contentFrame.BackgroundTransparency = 1

local listLayout = Instance.new("UIListLayout", contentFrame)
listLayout.Padding = UDim.new(0, 4)

closeBtn.MouseButton1Click:Connect(function()
    mainGui:Destroy()
end)

local toggleStates = {}
local openWindows = {}

local function createToggleButton(petType, index)
    local button = Instance.new("TextButton", contentFrame)
    button.Size = UDim2.new(1, 0, 0, 30)
    button.Text = petType .. " ESP"
    button.Font = Enum.Font.FredokaOne
    button.TextSize = 13
    button.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Başlangıç: kırmızı
    button.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)

    toggleStates[petType] = false

    button.MouseButton1Click:Connect(function()
        toggleStates[petType] = not toggleStates[petType]
        button.TextColor3 = toggleStates[petType] and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 80, 80)

        if toggleStates[petType] then
            if openWindows[petType] then
                openWindows[petType]:Destroy()
                openWindows[petType] = nil
            end
            local win = createPetWindow(petType)
            openWindows[petType] = win
        else
            if openWindows[petType] then
                openWindows[petType]:Destroy()
                openWindows[petType] = nil
            end
            clearHighlightsForCategory(petType)
        end
    end)
end

local categories = {"Secret", "BrainrotGod", "Mythic", "Legendary", "Epic", "Rare", "Common"}
-- Bu kodla eski for döngüsünü değiştir:
for i, cat in ipairs(categories) do
    createToggleButton(cat, i)
end

function highlightAll(name, category)
    for _, inst in ipairs(workspace:GetDescendants()) do
        if inst.Name == name and not inst:FindFirstChild("ESP_HL_"..category) then
            local hl = Instance.new("Highlight")
            hl.Name = "ESP_HL_" .. category
            hl.FillColor = Color3.fromRGB(0, 255, 0)
            hl.FillTransparency = 0.65
            hl.OutlineColor = Color3.new(1, 1, 1)
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Adornee = inst
            hl.Parent = inst

            local tag = Instance.new("BillboardGui", inst)
            tag.Name = "ESP_NAME_" .. category
            tag.Adornee = inst
            tag.Size = UDim2.new(0, 120, 0, 20)
            tag.StudsOffset = Vector3.new(0, 2.5, 0)
            tag.AlwaysOnTop = true

            local label = Instance.new("TextLabel", tag)
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = inst.Name
            label.TextColor3 = Color3.fromRGB(255,255,255)
            label.Font = Enum.Font.FredokaOne
            label.TextScaled = true
        end
    end
end

function clearHighlightsForCategory(category)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Highlight") and obj.Name:match("ESP_HL_"..category) then
            obj:Destroy()
        elseif obj:IsA("BillboardGui") and obj.Name:match("ESP_NAME_"..category) then
            obj:Destroy()
        end
    end
end

function createPetWindow(category)
    local gui = Instance.new("ScreenGui", player.PlayerGui)
    gui.Name = category .. "_Window"

    local win = Instance.new("Frame", gui)
    win.Size = UDim2.new(0, 200, 0, 240)
    win.Position = UDim2.new(0.25, math.random(-50,50), 0.25, math.random(-30,30))
    win.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    win.Active = true
    win.Draggable = true
    Instance.new("UICorner", win).CornerRadius = UDim.new(0, 10)

    local top = Instance.new("Frame", win)
    top.Size = UDim2.new(1, 0, 0, 30)
    top.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Instance.new("UICorner", top).CornerRadius = UDim.new(0, 10)

    local close = Instance.new("TextButton", top)
    close.Text = "×"
    close.Font = Enum.Font.FredokaOne
    close.TextSize = 18
    close.TextColor3 = Color3.fromRGB(255, 80, 80)
    close.Size = UDim2.new(0, 30, 1, 0)
    close.Position = UDim2.new(1, -30, 0, 0)
    close.BackgroundTransparency = 1

    local scroll = Instance.new("ScrollingFrame", win)
    scroll.Size = UDim2.new(1, -10, 1, -35)
    scroll.Position = UDim2.new(0, 5, 0, 30)
    scroll.ScrollBarThickness = 5
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.BackgroundTransparency = 1
    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0, 3)

    for _, item in ipairs(petData[category]) do
        local name, val = item.name or item, item.value
        local btn = Instance.new("TextButton", scroll)
        btn.Size = UDim2.new(1, 0, 0, 38)
        btn.BackgroundColor3 = Color3.fromRGB(50, 60, 85)
        btn.Text = name
        btn.Font = Enum.Font.FredokaOne
        btn.TextColor3 = Color3.new(1,1,1)
        btn.TextSize = 14
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

        if val then
            local valLbl = Instance.new("TextLabel", btn)
            valLbl.Text = val
            valLbl.Font = Enum.Font.FredokaOne
            valLbl.TextColor3 = Color3.fromRGB(255, 225, 0)
            valLbl.TextStrokeColor3 = Color3.new(0,0,0)
            valLbl.TextStrokeTransparency = 0.3
            valLbl.Size = UDim2.new(1, -6, 0, 12)
            valLbl.Position = UDim2.new(0, 3, 1, -12)
            valLbl.BackgroundTransparency = 1
            valLbl.TextScaled = true
        end

        btn.MouseButton1Click:Connect(function()
            highlightAll(name, category)
        end)
    end
    scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y+6)

    close.MouseButton1Click:Connect(function()
    gui:Destroy()
    toggleStates[category] = false
    clearHighlightsForCategory(category)
    -- Buton yazısını kırmızıya çevir
    for _, btn in ipairs(contentFrame:GetChildren()) do
        if btn:IsA("TextButton") and btn.Text:find(category) then
            btn.TextColor3 = Color3.fromRGB(255, 80, 80)
        end
    end
end)

contentFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y+6)
print("✨ GUI yüklendi")


print("working")
