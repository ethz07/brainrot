-- ethz Steal Script
-- by _ethz

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer

local player = Players.LocalPlayer
local function GetHRP()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end
local random = Random.new()

local tpAmt = 150
local MAX_DISTANCE_OK = 60
local TELEPORT_ITERATIONS = 110

-- main
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ethzStealGUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 245, 0, 200)
frame.Position = UDim2.new(0.5, -115, 0.45, 0) -- ortalanmış
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- FPS Göstergesi
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(0, 80, 0, 25)
fpsLabel.Position = UDim2.new(1, -90, 0, 10)
fpsLabel.AnchorPoint = Vector2.new(0, 0)
fpsLabel.BackgroundTransparency = 0.2
fpsLabel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
fpsLabel.TextSize = 14
fpsLabel.Font = Enum.Font.FredokaOne
fpsLabel.Text = "FPS: ..."
fpsLabel.Parent = gui

-- FPS Ölçüm
task.spawn(function()
    local lastTime = tick()
    local frameCount = 0
    while fpsLabel and fpsLabel.Parent do
        frameCount += 1
        if tick() - lastTime >= 1 then
            fpsLabel.Text = "FPS: " .. frameCount
            frameCount = 0
            lastTime = tick()
        end
        RunService.RenderStepped:Wait()
    end
end)

local function showSuccessIcon()
    local successIcon = Instance.new("TextLabel")
    successIcon.Size = UDim2.new(0, 60, 0, 60)
    successIcon.Position = UDim2.new(0.5, -30, 0, -10)
    successIcon.BackgroundTransparency = 1
    successIcon.Text = "✅"
    successIcon.TextColor3 = Color3.new(0, 1, 0)
    successIcon.TextSize = 50
    successIcon.Font = Enum.Font.FredokaOne
    successIcon.Parent = gui

    task.delay(1.5, function()
        if successIcon then successIcon:Destroy() end
    end)
end

-- Footer
local footer = Instance.new("TextLabel", frame)
footer.Text = "made by _ethz on discord"
footer.Font = Enum.Font.FredokaOne
footer.TextColor3 = Color3.fromRGB(180, 180, 180)
footer.TextSize = 12
footer.BackgroundTransparency = 1
footer.Size = UDim2.new(1, 0, 0, 20)
footer.Position = UDim2.new(0, 0, 1, -20)
footer.TextStrokeTransparency = 0.8
footer.TextYAlignment = Enum.TextYAlignment.Center
footer.TextXAlignment = Enum.TextXAlignment.Center

local dragging, dragInput, dragStart, startPos = false, nil, nil, nil

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 10)

-- Title Bar
local titleBar = Instance.new("Frame", frame)
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
titleBar.BorderSizePixel = 0
titleBar.Active = true
titleBar.Parent = frame
local titleCorner = Instance.new("UICorner", titleBar)
titleCorner.CornerRadius = UDim.new(0, 10)

-- Title
local title = Instance.new("TextLabel", titleBar)
title.Text = "ethz Script"
title.Font = Enum.Font.FredokaOne
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 18
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left

-- Buttons
local buttonFrame = Instance.new("Frame", titleBar)
buttonFrame.Size = UDim2.new(0, 60, 1, 0)
buttonFrame.Position = UDim2.new(1, -60, 0, 0)
buttonFrame.BackgroundTransparency = 1

local minimizeButton = Instance.new("TextButton", buttonFrame)
minimizeButton.Text = "-"
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 18
minimizeButton.TextColor3 = Color3.new(1, 1, 0)
minimizeButton.Size = UDim2.new(0.5, 0, 1, 0)
minimizeButton.BackgroundTransparency = 1

local closeButton = Instance.new("TextButton", buttonFrame)
closeButton.Text = "X"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 18
closeButton.TextColor3 = Color3.new(1, 0.2, 0.2)
closeButton.Size = UDim2.new(0.5, 0, 1, 0)
closeButton.Position = UDim2.new(0.5, 0, 0, 0)
closeButton.BackgroundTransparency = 1

-- Content
local content = Instance.new("Frame", frame)
content.Size = UDim2.new(1, 0, 1, -35)
content.Position = UDim2.new(0, 0, 0, 35)
content.BackgroundTransparency = 1

-- Create Button
local function createButton(text, index)
    local btn = Instance.new("TextButton", content)
    btn.Text = text
    btn.TextSize = 15
    btn.Font = Enum.Font.FredokaOne
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = Color3.fromRGB(0, 32, 96)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, (index - 1) * 45)
    btn.BorderSizePixel = 0
    local c = Instance.new("UICorner", btn)
    c.CornerRadius = UDim.new(0, 8)
    return btn
end

-- server stuff
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ethzKickHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Name = "MainFrame"
Frame.Size = UDim2.new(0, 245, 0, 140)
Frame.Position = UDim2.new(0.5, -122, 0.5, -70)
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui
Frame.Active = true
Frame.Draggable = true

local FrameCorner = Instance.new("UICorner", Frame)
FrameCorner.CornerRadius = UDim.new(0, 10)

local titleBar2 = Instance.new("Frame", Frame)
titleBar2.Size = UDim2.new(1, 0, 0, 35)
titleBar2.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
titleBar2.BorderSizePixel = 0
titleBar2.Active = true
local titleCorner2 = Instance.new("UICorner", titleBar2)
titleCorner2.CornerRadius = UDim.new(0, 10)

-- Minimize / Close Buttons (Server Stuff)
local buttonFrame2 = Instance.new("Frame", titleBar2)
buttonFrame2.Size = UDim2.new(0, 60, 1, 0)
buttonFrame2.Position = UDim2.new(1, -60, 0, 0)
buttonFrame2.BackgroundTransparency = 1

-- Minimize Button
local minimizeButton2 = Instance.new("TextButton", buttonFrame2)
minimizeButton2.Text = "-"
minimizeButton2.Font = Enum.Font.GothamBold
minimizeButton2.TextSize = 18
minimizeButton2.TextColor3 = Color3.new(1, 1, 0)
minimizeButton2.Size = UDim2.new(0.5, 0, 1, 0)
minimizeButton2.BackgroundTransparency = 1

-- Close Button
local closeButton2 = Instance.new("TextButton", buttonFrame2)
closeButton2.Text = "×"
closeButton2.Font = Enum.Font.GothamBold
closeButton2.TextSize = 18
closeButton2.TextColor3 = Color3.new(1, 0.2, 0.2)
closeButton2.Size = UDim2.new(0.5, 0, 1, 0)
closeButton2.Position = UDim2.new(0.5, 0, 0, 0)
closeButton2.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", titleBar2)
Title.Name = "Title"
Title.Text = "Server Stuff"
Title.Size = UDim2.new(1, -10, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.FredokaOne
Title.TextXAlignment = Enum.TextXAlignment.Left

local content2 = Instance.new("Frame", Frame)
content2.Name = "ServerContent"
content2.Size = UDim2.new(1, 0, 1, -35)
content2.Position = UDim2.new(0, 0, 0, 35)
content2.BackgroundTransparency = 1

local KickBtn = Instance.new("TextButton", content2)
KickBtn.Name = "KickButton"
KickBtn.Text = "Kick"
KickBtn.Size = UDim2.new(0.9, 0, 0, 40)
KickBtn.Position = UDim2.new(0.05, 0, 0, 5)
KickBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
KickBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
KickBtn.TextSize = 15
KickBtn.Font = Enum.Font.FredokaOne
KickBtn.BorderSizePixel = 0
local UICornerKick = Instance.new("UICorner", KickBtn)
UICornerKick.CornerRadius = UDim.new(0, 8)

KickBtn.MouseButton1Click:Connect(function()
	player:Kick("You Have Successfully Been Kicked By ethz Script")
end)

local RejoinBtn = Instance.new("TextButton", content2)
RejoinBtn.Name = "RejoinButton"
RejoinBtn.Text = "Rejoin"
RejoinBtn.Size = UDim2.new(0.9, 0, 0, 40)
RejoinBtn.Position = UDim2.new(0.05, 0, 0, 55)
RejoinBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
RejoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RejoinBtn.TextSize = 15
RejoinBtn.Font = Enum.Font.FredokaOne
RejoinBtn.BorderSizePixel = 0
local UICornerRejoin = Instance.new("UICorner", RejoinBtn)
UICornerRejoin.CornerRadius = UDim.new(0, 8)

RejoinBtn.MouseButton1Click:Connect(function()
	local placeId = game.PlaceId
	local instanceId = game.JobId
	TeleportService:TeleportToPlaceInstance(placeId, instanceId)
end)

-- İşlevler
local minimized2 = false
minimizeButton2.MouseButton1Click:Connect(function()
	minimized2 = not minimized2
	content2.Visible = not minimized2
	Frame.Size = minimized2 and UDim2.new(0, 245, 0, 35) or UDim2.new(0, 245, 0, 140)
end)

closeButton2.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

-- 1) Dört köşeden yüzey (dikdörtgen) oluşturan fonksiyon
local function createFullRectangle(name, cornerA, cornerB, cornerC, cornerD)
 local center = (cornerA + cornerB + cornerC + cornerD) / 4

 local side1 = (cornerA - cornerB).Magnitude
 local side2 = (cornerA - cornerD).Magnitude

 local edge1 = (cornerB - cornerA).Unit
 local edge2 = (cornerD - cornerA).Unit
 local normal = edge1:Cross(edge2).Unit

 local part = Instance.new("Part")
 part.Size = Vector3.new(side1, 110, side2)
 part.Anchored = true
 part.CanCollide = false
 part.Transparency = 1
 part.Position = center
 part.Name = name
 part.Parent = workspace

 local right = edge1
 local up = normal
 local back = edge2
 part.CFrame = CFrame.fromMatrix(center, right, up, back)

 return part
end

-- 2) Dikdörtgen verileri ve oluşturma
local rectangles = {
 {
  name = "Rect_4",
  corners = {
   Vector3.new(-525.723633, -4.738947, -78.891960),
   Vector3.new(-525.712646, -4.738956, -121.874443),
   Vector3.new(-293.494598, -4.738947, -121.893700),
   Vector3.new(-293.510406, -4.738955, -78.926765),
  }
 },
 {
  name = "Rect_3",
  corners = {
   Vector3.new(-525.751953, -4.738947, 28.107550),
   Vector3.new(-525.706848, -4.738956, -14.871658),
   Vector3.new(-293.483368, -4.738947, -14.873563),
   Vector3.new(-293.488586, -4.738956, 28.124617),
  }
 },
 {
  name = "Rect_2",
  corners = {
   Vector3.new(-525.713257, -4.738947, 135.095154),
   Vector3.new(-525.711426, -4.738956, 92.125351),
   Vector3.new(-293.477264, -4.738947, 92.121010),
   Vector3.new(-293.484131, -4.738955, 135.086609),
  }
 },
 {
  name = "Rect_1",
  corners = {
   Vector3.new(-525.709351, -4.804743, 242.094635),
   Vector3.new(-525.713135, -4.804754, 199.123734),
   Vector3.new(-293.499786, -4.738947, 199.107498),
   Vector3.new(-293.526947, -4.738956, 242.061844),
  }
 }
}

for _, rect in pairs(rectangles) do
 createFullRectangle(rect.name, unpack(rect.corners))
end

-- 3) Yüksekte kare bloklar
local highPoints = {
 { name = "High_4", pos = Vector3.new(-410.591339, 20, -99.639153) },
 { name = "High_3", pos = Vector3.new(-410.946167, 20, 6.816273) },
 { name = "High_2", pos = Vector3.new(-411.538971, 20, 116.529350) },
 { name = "High_1", pos = Vector3.new(-410.954254, 20, 220.240616) },
}

for _, point in pairs(highPoints) do
 local part = Instance.new("Part")
 part.Size = Vector3.new(10, 1, 10)
 part.Position = point.pos
 part.Transparency = 1
 part.Anchored = true
 part.CanCollide = true
 part.Name = point.name
 part.Parent = workspace
end

-- 4) Üstlerine yazı ekle (koordinat sırasına göre numara verir)

local rectNames = { "Rect_4", "Rect_3", "Rect_2", "Rect_1" }
for i, name in ipairs(rectNames) do
 local part = workspace:FindFirstChild(name)
 if part then
  local surfaceGui = Instance.new("SurfaceGui")
  surfaceGui.Face = Enum.NormalId.Top
  surfaceGui.AlwaysOnTop = true
  surfaceGui.Parent = part

  local label = Instance.new("TextLabel")
  label.Size = UDim2.new(1, 0, 1, 0)
  label.BackgroundTransparency = 1
  label.Text = "prt " .. tostring(5 - i)
  label.TextColor3 = Color3.new(1, 1, 1)
  label.TextStrokeTransparency = 0.5
  label.TextStrokeColor3 = Color3.new(0, 0, 0)
  label.TextScaled = true
  label.Font = Enum.Font.SourceSansBold
  label.Parent = surfaceGui
 end
end

local highNames = { "High_4", "High_3", "High_2", "High_1" }
for i, name in ipairs(highNames) do
 local part = workspace:FindFirstChild(name)
 if part then
  local surfaceGui = Instance.new("SurfaceGui")
  surfaceGui.Face = Enum.NormalId.Top
  surfaceGui.AlwaysOnTop = true
  surfaceGui.Parent = part

  local label = Instance.new("TextLabel")
  label.Size = UDim2.new(1, 0, 1, 0)
  label.BackgroundTransparency = 1
  label.Text = "prt " .. tostring(5 - i)
  label.TextColor3 = Color3.new(1, 1, 1)
  label.TextStrokeTransparency = 0.5
  label.TextStrokeColor3 = Color3.new(0, 0, 0)
  label.TextScaled = true
  label.Font = Enum.Font.SourceSansBold
  label.Parent = surfaceGui
 end
end

-- Kendi base'inin Purchases.PlotBlock.Hitbox'unu bulur
local function getOwnPlotHitbox()
    for _, plot in ipairs(workspace.Plots:GetChildren()) do
        local plotSign = plot:FindFirstChild("PlotSign")
        if plotSign and plotSign:FindFirstChild("YourBase") and plotSign.YourBase.Enabled then
            local parentPlot = plotSign.Parent
            local grandParent = parentPlot and parentPlot.Parent
            local correctPlot = grandParent and grandParent:FindFirstChild(parentPlot.Name)

            if correctPlot and correctPlot:FindFirstChild("Purchases") then
                local block = correctPlot.Purchases:FindFirstChild("PlotBlock")
                if block and block:FindFirstChild("Hitbox") then
                    return block.Hitbox
                end
            end
        end
    end
    return nil
end

-- TP to Base
local function DeliverBrainrot()
    for _, plot in ipairs(workspace.Plots:GetChildren()) do
        local sign = plot:FindFirstChild("PlotSign")
        if sign and sign:FindFirstChild("YourBase") and sign.YourBase.Enabled then
            local hitbox = plot:FindFirstChild("DeliveryHitbox")
            if hitbox then
                for i = 1, tpAmt do
                    GetHRP().CFrame = hitbox.CFrame * CFrame.new(0, -3, 0)
                    RunService.Heartbeat:Wait()
                end
                for _ = 1, 2 do
                    GetHRP().CFrame = CFrame.new(0, -3e38, 0)
                    RunService.Heartbeat:Wait()
                end
                for i = 1, math.floor(tpAmt / 16) do
                    GetHRP().CFrame = hitbox.CFrame * CFrame.new(0, -3, 0)
                    RunService.Heartbeat:Wait()
                end
                local dist = (GetHRP().Position - hitbox.Position).Magnitude
                print(dist <= MAX_DISTANCE_OK and "[TP]: ✅ Başarılı" or "[TP]: ❌ Uzakta ("..math.floor(dist)..")")
            end
        end
    end
end

-- 💡 Dikdörtgen içinde mi kontrol eden fonksiyon
local function isPointInRect(point, rect)
    if not rect then return false end
    local cf = rect.CFrame
    local size = rect.Size
    local localPos = cf:PointToObjectSpace(point)
    return math.abs(localPos.X) <= size.X / 2 and math.abs(localPos.Z) <= size.Z / 2
end

-- 🧠 Teslim kutusunu ve base index’i bulur
local function getOwnPlotHitboxAndBaseIndex()
    local rects = {
        workspace:FindFirstChild("Rect_1"),
        workspace:FindFirstChild("Rect_2"),
        workspace:FindFirstChild("Rect_3"),
        workspace:FindFirstChild("Rect_4"),
    }

    for _, plot in ipairs(workspace.Plots:GetChildren()) do
        local sign = plot:FindFirstChild("PlotSign")
        if sign and sign:FindFirstChild("YourBase") and sign.YourBase.Enabled then
            local delivery = plot:FindFirstChild("DeliveryHitbox")
            if delivery then
                for i, rect in ipairs(rects) do
                    if isPointInRect(delivery.Position, rect) then
                        return delivery, i
                    end
                end
            end
        end
    end
    return nil, nil
end

-- 🚀 Tween Steal Fonksiyonu
local function TweenSteal()
    local delivery, baseIndex = getOwnPlotHitboxAndBaseIndex()
    if not delivery or not baseIndex then
        warn("[TweenSteal]: ❌ Teslim kutusu ya da base alanı tespit edilemedi.")
        return
    end

    local deliveryPos = (delivery.CFrame * CFrame.new(0, -2.5, 0)).Position

    -- 📶 Ping ve FPS ölç
    local fps = 60
    local ping = 50
    local stats = game:GetService("Stats")
    local net = stats:FindFirstChild("Network")
    if net and net:FindFirstChild("Ping") then
        ping = net.Ping:GetValue()
    end

    local rects = {
        workspace:FindFirstChild("Rect_1"),
        workspace:FindFirstChild("Rect_2"),
        workspace:FindFirstChild("Rect_3"),
        workspace:FindFirstChild("Rect_4"),
    }

    local highs = {
        workspace:FindFirstChild("High_1"),
        workspace:FindFirstChild("High_2"),
        workspace:FindFirstChild("High_3"),
        workspace:FindFirstChild("High_4"),
    }

    -- 📍 Şu an hangi dikdörtgendeyiz?
    local currentIndex = nil
    for i, rect in ipairs(rects) do
        if isPointInRect(GetHRP().Position, rect) then
            currentIndex = i
            break
        end
    end

    if not currentIndex then
        warn("[TweenSteal]: ❌ Geçerli dikdörtgen üzerinde değilsin.")
        return
    end

	local function tweenMove(startPos, endPos)
    local height = 10 -- 
    local steps = 100 -- if up. slow
    local delay = 1 / 25
    local random = Random.new()

    for i = 1, steps do
        local t = i / steps
        local smooth = t * t * (3 - 2 * t)

        local horizontal = startPos:Lerp(endPos, smooth)
        local verticalOffset = math.sin(math.pi * smooth) * height
        local jitter = Vector3.new(
            random:NextNumber(-0.001, 0.001),
            random:NextNumber(-0.001, 0.001),
            random:NextNumber(-0.001, 0.001)
        )

        local finalPos = horizontal + Vector3.new(0, verticalOffset, 0) + jitter
        GetHRP().CFrame = CFrame.new(finalPos)
        task.wait(delay)
    end
	end

    -- 🔁 Sıralı geçiş: current → base
    local step = currentIndex > baseIndex and -1 or 1
    for i = currentIndex, baseIndex, step do
        local high = highs[i]
        if high then
            tweenMove(GetHRP().Position, high.Position + Vector3.new(0, 2, 0))
        end
    end

    -- 🎯 Hedefe (delivery kutusuna) son geçiş
    tweenMove(GetHRP().Position, deliveryPos)

    -- 📌 Konum sabitleme
    for _ = 1, 2 do
        GetHRP().Anchored = true
        GetHRP().CFrame = CFrame.new(0, -3e38, 0)
        task.wait(0.1)
        GetHRP().CFrame = CFrame.new(deliveryPos)
        GetHRP().Anchored = false
        task.wait(0.1)
    end

    -- ✅ Son kontrol
    local finalDist = (GetHRP().Position - deliveryPos).Magnitude
    if finalDist <= 60 then
        print("[TweenSteal]: ✅ Başarıyla teslim edildi!")
        showSuccessIcon()
    else
        warn("[TweenSteal]: ❌ Mesafe fazla:", math.floor(finalDist))
    end
end

-- Butonlar
local b1 = createButton("TP to Base", 1)
b1.MouseButton1Click:Connect(DeliverBrainrot)

local b2 = createButton("Start Steal", 2)
b2.MouseButton1Click:Connect(TweenSteal)

createButton("ESP Player", 3)
-- createButton("ESP Brainrots (Soon)", 3)

-- Minimize/Kapat
local minimized = false
minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    frame.Size = minimized and UDim2.new(0, 245, 0, 35) or UDim2.new(0, 245, 0, 200)
end)

closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- ESP lolalalaalalala
local espEnabled = false
local highlights = {}
local nameTags = {}
local updateConnection

local function clearESP()
    for _, h in pairs(highlights) do
        h:Destroy()
    end
    highlights = {}
    for _, t in pairs(nameTags) do
        t:Destroy()
    end
    nameTags = {}
end

local function createESP(player)
    if player == Players.LocalPlayer then return end
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    -- Highlight
    local hl = Instance.new("Highlight")
    hl.Name = "ethzESP"
    hl.FillColor = Color3.fromRGB(0, 32, 96)
    hl.FillTransparency = 0.6
    hl.OutlineColor = Color3.new(1, 1, 1)
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Adornee = character
    hl.Parent = character
    highlights[player] = hl

    -- NameTag
    local head = character:FindFirstChild("Head")
    if head then
        local tag = Instance.new("BillboardGui")
        tag.Name = "ethzNameTag"
        tag.Adornee = head
        tag.Size = UDim2.new(0, 100, 0, 20)
        tag.StudsOffset = Vector3.new(0, 2.5, 0)
        tag.AlwaysOnTop = true

        local nameLabel = Instance.new("TextLabel", tag)
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = player.DisplayName
        nameLabel.TextColor3 = Color3.fromRGB(250, 250, 250)
        nameLabel.TextSize = 12
        nameLabel.Font = Enum.Font.FredokaOne
        nameLabel.TextScaled = true

        tag.Parent = head
        nameTags[player] = tag
    end
end

local function updateESP()
    clearESP()
    for _, player in pairs(Players:GetPlayers()) do
        createESP(player)
    end
end

local espButton = content:GetChildren()[3] -- 3. buton (ESP Player)
espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        updateESP()
        updateConnection = RunService.Heartbeat:Connect(function(dt)
            if tick() % 1 < dt then
                updateESP()
            end
        end)
        espButton.BackgroundColor3 = Color3.fromRGB(0, 150, 96) -- aktif renk
    else
        if updateConnection then updateConnection:Disconnect() end
        clearESP()
        espButton.BackgroundColor3 = Color3.fromRGB(0, 32, 96) -- orijinal renk
    end
end)

-- Yeni oyuncular geldiğinde otomatik ekleme (ölü doğdu vs.)
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        if espEnabled then
            task.wait(1)
            createESP(p)
        end
    end)
end)

print("👁️")
