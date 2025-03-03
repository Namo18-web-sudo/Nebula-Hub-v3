-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Main Window
local Window = Rayfield:CreateWindow({
    Name = "NEBULA AUTO FARM",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by NEBULA",
    Theme = "Default",
    KeySystem = false
})

-- Create AutoFarm Tab
local AutoFarmTab = Window:CreateTab("Auto Farm", 4483362458)

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

-- Function to Tween Teleport
local function TweenTeleport(targetPos)
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        local tweenInfo = TweenInfo.new((hrp.Position - targetPos).Magnitude / 300, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(targetPos)})
        
        -- NoClip (Walk through walls)
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

        -- Fix Movement Stuck
        local function ResetCharacter()
            if char:FindFirstChildOfClass("Humanoid") then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                humanoid:Move(Vector3.new(0, 0, 0))
                humanoid.Jump = true
            end
        end

        -- Start Teleport
        EnableNoclip()
        tween:Play()

        -- Restore after teleport
        tween.Completed:Connect(function()
            wait(0.2)
            DisableNoclip()
            ResetCharacter()
            print("Teleport complete!")
        end)
    end
end

-- Quest Locations & NPCs by Level
local QuestData = {
    {Level = 1, QuestNPC = "Bandit Quest Giver", QuestName = "Bandits", MobName = "Bandit", QuestPos = Vector3.new(1059, 16, 1547), MobPos = Vector3.new(1147, 17, 1639)},
    {Level = 10, QuestNPC = "Jungle Quest Giver", QuestName = "Monkeys", MobName = "Monkey", QuestPos = Vector3.new(-1601, 37, 152), MobPos = Vector3.new(-1442, 40, 68)},
    {Level = 30, QuestNPC = "Pirate Quest Giver", QuestName = "Pirates", MobName = "Pirate", QuestPos = Vector3.new(-1140, 5, 3852), MobPos = Vector3.new(-1211, 7, 3912)}
    -- Add more based on level
}

-- Get the best quest for player level
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

-- Accept Quest
local function TakeQuest()
    local quest = GetBestQuest()
    TweenTeleport(quest.QuestPos)
    wait(1)

    -- Interact with Quest NPC
    local args = {
        [1] = quest.QuestNPC,
        [2] = quest.QuestName
    }
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", unpack(args))
    print("Quest Taken: " .. quest.QuestName)
end

-- Gather NPCs
local function GatherMobs()
    local quest = GetBestQuest()
    TweenTeleport(quest.MobPos + Vector3.new(0, 15, 0)) -- Stay above NPCs

    -- Wait for Mobs to load
    wait(1)

    -- Group NPCs together
    for _, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
        if v.Name == quest.MobName and v:FindFirstChild("HumanoidRootPart") then
            v.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(math.random(-5, 5), 0, math.random(-5, 5))
        end
    end
    print("Grouped NPCs")
end

-- Attack Mobs
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
            print("Quest Completed!")
            return
        end
    end
end

-- AutoFarm Main Loop
local function AutoFarm()
    while true do
        TakeQuest()
        GatherMobs()
        AutoKill()
        wait(1) -- Prevent crashes
    end
end

-- UI Button to Start Auto Farm
AutoFarmTab:CreateButton({
    Name = "Start Auto Farm",
    Callback = function()
        AutoFarm()
    end
})
