-- Load Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Create UI Window
local Window = Rayfield:CreateWindow({
    Name = "NEBULA AutoFarm Hub",
    LoadingTitle = "Loading AutoFarm...",
    LoadingSubtitle = "By NEBULA",
    Theme = "Dark",
})

-- Variables
local player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Anti AFK
player.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

-- Function to Equip Weapon
local function EquipWeapon(weapon)
    for _, tool in pairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.Name == weapon then
            player.Character.Humanoid:EquipTool(tool)
        end
    end
end

-- First Sea Quests & NPCs
local FirstSeaQuests = {
    { Level = 0, Name = "Bandits", NPC = "Bandit Quest Giver", CFrame = CFrame.new(-1139, 16, 3790), Mob = "Bandit" },
    { Level = 10, Name = "Monkeys", NPC = "Jungle Quest Giver", CFrame = CFrame.new(-1600, 36, 152), Mob = "Monkey" },
    { Level = 15, Name = "Gorillas", NPC = "Jungle Quest Giver", CFrame = CFrame.new(-1600, 36, 152), Mob = "Gorilla" },
    { Level = 30, Name = "Pirates", NPC = "Pirate Quest Giver", CFrame = CFrame.new(-1140, 5, 3852), Mob = "Pirate" },
    { Level = 40, Name = "Brutes", NPC = "Pirate Quest Giver", CFrame = CFrame.new(-1140, 5, 3852), Mob = "Brute" },
    { Level = 60, Name = "Desert Bandits", NPC = "Desert Quest Giver", CFrame = CFrame.new(920, 7, 4475), Mob = "Desert Bandit" },
    { Level = 75, Name = "Desert Officers", NPC = "Desert Quest Giver", CFrame = CFrame.new(920, 7, 4475), Mob = "Desert Officer" },
}

-- Function to Get Quest
local function TakeQuest(quest)
    if not quest then return end
    player.Character.HumanoidRootPart.CFrame = quest.CFrame
    task.wait(1)

    local args = {
        [1] = quest.NPC,
        [2] = quest.Name
    }
    ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", unpack(args))
end

-- Function to Find and Attack NPCs
local function AttackNPCs(quest)
    if not quest then return end

    for _, enemy in pairs(workspace.Enemies:GetChildren()) do
        if enemy.Name == quest.Mob and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") then
            repeat
                task.wait()
                EquipWeapon("Combat") -- Change to preferred weapon
                player.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 15, 0)
                enemy.Humanoid.Health = 0
            until enemy.Humanoid.Health <= 0 or not _G.AutoFarm
        end
    end
end

-- AutoFarm Function
local function AutoFarm()
    while _G.AutoFarm do
        task.wait(0.1)
        local level = player.Data.Level.Value
        local bestQuest

        -- Find the best quest for the player's level
        for _, quest in ipairs(FirstSeaQuests) do
            if level >= quest.Level then
                bestQuest = quest
            end
        end

        if bestQuest then
            TakeQuest(bestQuest)
            task.wait(1)
            AttackNPCs(bestQuest)
        end
    end
end

-- Create UI Tab
local FarmTab = Window:CreateTab("Auto Farm", 4483362458)

-- AutoFarm Toggle Button
FarmTab:CreateToggle({
    Name = "AutoFarm Level (First Sea)",
    CurrentValue = false,
    Flag = "AutoFarm",
    Callback = function(Value)
        _G.AutoFarm = Value
        if Value then
            AutoFarm()
        end
    end,
})
