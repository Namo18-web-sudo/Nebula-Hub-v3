-- Load UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "NEBULA AUTO FARM",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by NEBULA",
    Theme = "Default",
    KeySystem = false
})

-- Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

-- Tween Teleport Function
local function TweenTeleport(targetPos)
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        local tweenInfo = TweenInfo.new((hrp.Position - targetPos).Magnitude / 300, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(targetPos)})

        -- NoClip to avoid walls
        local function EnableNoclip()
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end

        local function DisableNoclip()
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = true
                end
            end
        end

        -- Start teleporting
        EnableNoclip()
        tween:Play()

        -- Stop noclip after teleport
        tween.Completed:Connect(function()
            wait(0.2)
            DisableNoclip()
        end)
    end
end

-- Quest & NPC Data
local QuestData = {
    {Level = 1, QuestNPC = "Bandit Quest Giver", QuestName = "Bandits", MobName = "Bandit", QuestPos = Vector3.new(1059, 16, 1547), MobPos = Vector3.new(1147, 17, 1639)},
    {Level = 10, QuestNPC = "Jungle Quest Giver", QuestName = "Monkeys", MobName = "Monkey", QuestPos = Vector3.new(-1601, 37, 152), MobPos = Vector3.new(-1442, 40, 68)},
    {Level = 30, QuestNPC = "Pirate Quest Giver", QuestName = "Pirates", MobName = "Pirate", QuestPos = Vector3.new(-1140, 5, 3852), MobPos = Vector3.new(-1211, 7, 3912)}
}

-- Get the best quest
local function GetBestQuest()
    local playerLevel = player.Data.Level.Value
    local bestQuest = QuestData[1]

    for _, quest in ipairs(QuestData) do
        if playerLevel >= quest.Level then
            bestQuest = quest
        end
    end

    return bestQuest
end

-- Take Quest
local function TakeQuest()
    local quest = GetBestQuest()
    TweenTeleport(quest.QuestPos)
    wait(1)

    -- Interact with NPC
    local args = {
        [1] = quest.QuestNPC,
        [2] = quest.QuestName
    }
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", unpack(args))
end

-- Gather & Levitate Above NPCs
local function GatherMobs()
    local quest = GetBestQuest()
    TweenTeleport(quest.MobPos + Vector3.new(0, 20, 0)) -- Levitate above mobs

    -- Wait for mobs to load
    wait(1)

    -- Group NPCs together
    for _, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
        if v.Name == quest.MobName and v:FindFirstChild("HumanoidRootPart") then
            v.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(math.random(-5, 5), 0, math.random(-5, 5))
        end
    end
end

-- Auto-Kill NPCs
local function AutoKill()
    local quest = GetBestQuest()
    while true do
        wait(0.1)

        for _, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
            if v.Name == quest.MobName and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                -- Attack NPC
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("HitboxAttack", v)
            end
        end

        -- Check if quest is done
        if player.PlayerGui.Main.Quest.Visible == false then
            return
        end
    end
end

-- AutoFarm Loop
local function AutoFarm()
    while true do
        TakeQuest()
        GatherMobs()
        AutoKill()
        wait(1)
    end
end

-- UI Button
local AutoFarmTab = Window:CreateTab("Auto Farm", 4483362458)
AutoFarmTab:CreateButton({
    Name = "Start Auto Farm",
    Callback = function()
        AutoFarm()
    end
})
