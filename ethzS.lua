local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local lastPart = nil

-------------------------------
-- Hız ve zıplama sabitleme --
-------------------------------
local function preventSpeedAndJumpDrop()
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")

    local DEFAULT_SPEED = 48
    local DEFAULT_JUMP = 75

    hum.WalkSpeed = DEFAULT_SPEED
    hum.JumpPower = DEFAULT_JUMP

    RunService.RenderStepped:Connect(function()
        if hum.WalkSpeed < DEFAULT_SPEED then
            hum.WalkSpeed = DEFAULT_SPEED
        end
        if hum.JumpPower < DEFAULT_JUMP then
            hum.JumpPower = DEFAULT_JUMP
        end
    end)

    hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if hum.WalkSpeed < DEFAULT_SPEED then
            hum.WalkSpeed = DEFAULT_SPEED
        end
    end)
    hum:GetPropertyChangedSignal("JumpPower"):Connect(function()
        if hum.JumpPower < DEFAULT_JUMP then
            hum.JumpPower = DEFAULT_JUMP
        end
    end)
end

------------------------
-- Zıplama Partı Oluştur --
------------------------
local function createJumpPart()
    local character = player.Character
    if not character then return end

    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if lastPart and lastPart.Parent then
        lastPart:Destroy()
    end

    local part = Instance.new("Part")
    part.Size = Vector3.new(8, 1, 8)
    part.Position = root.Position - Vector3.new(0, 3.1, 0)
    part.Anchored = true
    part.CanCollide = true
    part.Transparency = 0.7
    part.Color = Color3.new(0, 0, 0)
    part.Material = Enum.Material.ForceField
    part.Name = "JumpPad"
    part.Parent = workspace

    lastPart = part

    delay(0.8, function()
        if part and part.Parent then
            part:Destroy()
        end
    end)
end

--------------------------------
-- Sonsuz Zıplama (PC + Mobil) --
--------------------------------
local function enableInfiniteJump()
    local function bindJump(humanoid)
        UserInputService.JumpRequest:Connect(function()
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end)
    end

    player.CharacterAdded:Connect(function(char)
        local hum = char:WaitForChild("Humanoid")
        bindJump(hum)
    end)

    if player.Character then
        local hum = player.Character:FindFirstChild("Humanoid")
        if hum then
            bindJump(hum)
        end
    end
end

--------------------------
-- Zıplama Tuşunu Dinle --
--------------------------
local function setupJumpPlatform()
    -- Space tuşu (PC)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.Space then
            createJumpPart()
        end
    end)

    -- Mobil ve diğer durumlar (Jumping olayı)
    local function bindJumping(humanoid)
        humanoid.Jumping:Connect(function(isJumping)
            if isJumping then
                createJumpPart()
            end
        end)
    end

    player.CharacterAdded:Connect(function(char)
        local hum = char:WaitForChild("Humanoid")
        bindJumping(hum)
    end)

    if player.Character then
        local hum = player.Character:FindFirstChild("Humanoid")
        if hum then
            bindJumping(hum)
        end
    end
end

-----------------------
-- Gelişmiş GodMode --
-----------------------
local function enableGodMode()
    local function protectHumanoid(humanoid)
        RunService.Heartbeat:Connect(function()
            if humanoid and humanoid.Health > 0 and humanoid.Health < humanoid.MaxHealth then
                humanoid.Health = humanoid.MaxHealth
            end
        end)

        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if humanoid.Health <= 0 then
                humanoid.Health = humanoid.MaxHealth
            end
        end)

        humanoid.Died:Connect(function()
            task.wait()
            humanoid.Health = humanoid.MaxHealth
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end)

        RunService.RenderStepped:Connect(function()
            if humanoid and humanoid.Health <= 1 then
                humanoid.Health = humanoid.MaxHealth
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
        end)
    end

    player.CharacterAdded:Connect(function(char)
        local hum = char:WaitForChild("Humanoid")
        protectHumanoid(hum)
    end)

    if player.Character then
        local hum = player.Character:FindFirstChild("Humanoid")
        if hum then
            protectHumanoid(hum)
        end
    end
end

--------------------------
-- Başlatıcı Fonksiyonlar --
--------------------------
preventSpeedAndJumpDrop()
setupJumpPlatform()
enableInfiniteJump()
enableGodMode()
