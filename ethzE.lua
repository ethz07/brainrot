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

local petGui = Instance.new("ScreenGui", player.PlayerGui)
petGui.Name = "PetESPMainGui"
petGui.ResetOnSpawn = false
petGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local petFrame = Instance.new("Frame", petGui)
petFrame.Size = UDim2.new(0, 250, 0, 270)
petFrame.Position = UDim2.new(0.1, 0, 0.15, 0)
petFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
petFrame.BorderSizePixel = 0
petFrame.Active = true
petFrame.Draggable = true
local petUICorner = Instance.new("UICorner", petFrame)
petUICorner.CornerRadius = UDim.new(0, 12)

local petTitle = Instance.new("TextLabel", petFrame)
petTitle.Size = UDim2.new(1, 0, 0, 30)
petTitle.Position = UDim2.new(0, 0, 0, 0)
petTitle.BackgroundTransparency = 1
petTitle.Text = "🐾 Pet ESP Menu"
petTitle.Font = Enum.Font.FredokaOne
petTitle.TextColor3 = Color3.new(1, 1, 1)
petTitle.TextSize = 18

local toggleStates = {}
local openWindows = {}

local function createToggleButton(petType, index)
    local button = Instance.new("TextButton", petFrame)
    button.Size = UDim2.new(0.75, 0, 0, 30)
    button.Position = UDim2.new(0.05, 0, 0, 30 + (index - 1) * 35)
    button.Text = petType .. " ESP"
    button.Font = Enum.Font.FredokaOne
    button.TextSize = 14
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.TextColor3 = Color3.new(1, 1, 1)
    local corner = Instance.new("UICorner", button)
    corner.CornerRadius = UDim.new(0, 8)

    local circle = Instance.new("Frame", petFrame)
    circle.Size = UDim2.new(0, 18, 0, 18)
    circle.Position = UDim2.new(0.82, 0, 0, 35 + (index - 1) * 35)
    circle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    circle.BorderColor3 = Color3.new(0, 0, 0)
    circle.BorderSizePixel = 1
    circle.Name = petType .. "_Indicator"
    local circCorner = Instance.new("UICorner", circle)
    circCorner.CornerRadius = UDim.new(1, 0)

    toggleStates[petType] = false

    button.MouseButton1Click:Connect(function()
        toggleStates[petType] = not toggleStates[petType]
        circle.BackgroundColor3 = toggleStates[petType] and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
        if toggleStates[petType] then
            local win = createPetListWindow(petType)
            openWindows[petType] = win
        else
            if openWindows[petType] then
                openWindows[petType]:Destroy()
                openWindows[petType] = nil
            end
            clearPetHighlights(petType)
        end
    end)
end

local categories = {"Common", "Rare", "Epic", "Legendary", "Mythic", "BrainrotGod", "Secret"}
for i, cat in ipairs(categories) do
    createToggleButton(cat, i)
end

local function createHighlight(targetName, category)
    local target = workspace:FindFirstChild(targetName)
    if not target then return end

    if target:FindFirstChild("ESP_HL_" .. category) then return end

    local hl = Instance.new("Highlight")
    hl.Name = "ESP_HL_" .. category
    hl.FillColor = Color3.fromRGB(0, 255, 0)
    hl.FillTransparency = 0.65
    hl.OutlineColor = Color3.new(1, 1, 1)
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Adornee = target
    hl.Parent = target

    local tag = Instance.new("BillboardGui", target)
    tag.Name = "ESP_NAME_" .. category
    tag.Adornee = target
    tag.Size = UDim2.new(0, 120, 0, 20)
    tag.StudsOffset = Vector3.new(0, 2.5, 0)
    tag.AlwaysOnTop = true

    local text = Instance.new("TextLabel", tag)
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = target.Name
    text.Font = Enum.Font.FredokaOne
    text.TextColor3 = Color3.new(1, 1, 1)
    text.TextStrokeColor3 = Color3.new(0, 0, 0)
    text.TextStrokeTransparency = 0.3
    text.TextScaled = true
end

function clearPetHighlights(category)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Highlight") and obj.Name == "ESP_HL_" .. category then
            obj:Destroy()
        end
        if obj:IsA("BillboardGui") and obj.Name == "ESP_NAME_" .. category then
            obj:Destroy()
        end
    end
end

function createPetListWindow(petType)
    local gui = Instance.new("ScreenGui", player.PlayerGui)
    gui.Name = petType .. "_PetListGui"

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 250, 0, 280)
    frame.Position = UDim2.new(0.4, math.random(-100,100), 0.25, math.random(-50,50))
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 12)

    local top = Instance.new("Frame", frame)
    top.Size = UDim2.new(1, 0, 0, 30)
    top.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    top.BorderSizePixel = 0
    local topCorner = Instance.new("UICorner", top)
    topCorner.CornerRadius = UDim.new(0, 12)

    local close = Instance.new("TextButton", top)
    close.Text = "×"
    close.Font = Enum.Font.FredokaOne
    close.TextSize = 18
    close.TextColor3 = Color3.new(1, 0.2, 0.2)
    close.Size = UDim2.new(0, 30, 0, 30)
    close.Position = UDim2.new(1, -30, 0, 0)
    close.BackgroundTransparency = 1

    local title = Instance.new("TextLabel", top)
    title.Text = petType .. " Pets"
    title.Font = Enum.Font.FredokaOne
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Size = UDim2.new(1, -30, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextSize = 15

    local scroll = Instance.new("ScrollingFrame", frame)
    scroll.Size = UDim2.new(1, -10, 1, -40)
    scroll.Position = UDim2.new(0, 5, 0, 35)
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.ScrollBarThickness = 5
    scroll.BackgroundTransparency = 1

    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0, 4)

    local data = petData[petType]

    for _, item in ipairs(data) do
        local petName, value = nil, nil
        if typeof(item) == "string" then
            petName = item
        elseif typeof(item) == "table" then
            petName = item.name
            value = item.value
        end

        local btn = Instance.new("TextButton", scroll)
        btn.Size = UDim2.new(1, 0, 0, 30)
        btn.Text = petName
        btn.Font = Enum.Font.FredokaOne
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
        btn.TextSize = 14
        local c = Instance.new("UICorner", btn)
        c.CornerRadius = UDim.new(0, 8)

        if value then
            local val = Instance.new("TextLabel", btn)
            val.Text = value
            val.Font = Enum.Font.FredokaOne
            val.TextColor3 = Color3.fromRGB(255, 225, 0)
            val.TextStrokeColor3 = Color3.new(0,0,0)
            val.TextStrokeTransparency = 0.3
            val.Size = UDim2.new(1, 0, 1, 0)
            val.Position = UDim2.new(0, 0, 0, 0)
            val.BackgroundTransparency = 1
            val.TextXAlignment = Enum.TextXAlignment.Right
            val.TextSize = 12
        end

        btn.MouseButton1Click:Connect(function()
            createHighlight(petName, petType)
        end)
    end

    scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)

    close.MouseButton1Click:Connect(function()
        gui:Destroy()
        toggleStates[petType] = false
        local circle = petFrame:FindFirstChild(petType .. "_Indicator")
        if circle then
            circle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        end
        clearPetHighlights(petType)
    end)

    return gui
end

print("working")
