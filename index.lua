-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create Main Window
local Window = Rayfield:CreateWindow({
    Name = "NEBULA AUTOFARM HUB",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by NEBULA",
    Theme = "Default",
    KeySystem = false
})

-- Create AutoFarm Tab
local FarmTab = Window:CreateTab("AutoFarm", 4483362458)

-- AutoFarm Toggle
local AutoFarm = false
local Toggle = FarmTab:CreateToggle({
    Name = "AutoFarm",
    CurrentValue = false,
    Flag = "AutoFarm",
    Callback = function(value)
        AutoFarm = value
        if AutoFarm then
            StartAutoFarm()
        end
    end
})

-- Function to Equip Weapon
local function EquipWeapon(weapon)
    for _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.Name == weapon then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
        end
    end
end

-- Smooth Movement Function
local function MoveToPosition(targetPos)
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        hrp.CFrame = CFrame.new(targetPos) * CFrame.new(0, 15, 0) -- Stay above ground
        task.wait(0.1)
    end
end

-- Quest Data
local Quests = {
    { Level = 0, Name = "Bandits", NPC = "Bandit Quest Giver", CFrame = CFrame.new(-1139, 16, 3790), Mob = "Bandit", QuestID = 1 },
    { Level = 10, Name = "Monkeys", NPC = "Jungle Quest Giver", CFrame = CFrame.new(-1600, 36, 152), Mob = "Monkey", QuestID = 2 },
    { Level = 15, Name = "Gorillas", NPC = "Jungle Quest Giver", CFrame = CFrame.new(-1600, 36, 152), Mob = "Gorilla", QuestID = 3 },
    { Level = 30, Name = "Pirates", NPC = "Pirate Quest Giver", CFrame = CFrame.new(-1140, 5, 3852), Mob = "Pirate", QuestID = 4 },
    { Level = 40, Name = "Brutes", NPC = "Pirate Quest Giver", CFrame = CFrame.new(-1140, 5, 3852), Mob = "Brute", QuestID = 5 },
    { Level = 60, Name = "Desert Bandits", NPC = "Desert Quest Giver", CFrame = CFrame.new(920, 7, 4475), Mob = "Desert Bandit", QuestID = 6 },
    { Level = 75, Name = "Desert Officers", NPC = "Desert Quest Giver", CFrame = CFrame.new(920, 7, 4475), Mob = "Desert Officer", QuestID = 7 },
}

-- Function to Take Quest
local function TakeQuest(quest)
    if not quest then return end
    MoveToPosition(quest.CFrame.Position) -- Smooth teleport to quest giver
    task.wait(1)

    local args = {
        [1] = quest.NPC,
        [2] = quest.Name
    }
    local success = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", unpack(args))

    if success then
        print("Quest taken successfully!")
    else
        print("Failed to take quest.")
    end
end

-- Function to Attack NPCs
local function AttackNPCs(quest)
    if not quest then return end

    for _, enemy in pairs(workspace.Enemies:GetChildren()) do
        if enemy.Name == quest.Mob and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") then
            repeat
                task.wait()
                EquipWeapon("Combat") -- Change to preferred weapon
                MoveToPosition(enemy.HumanoidRootPart.Position) -- Smoothly move to enemy
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("HitNPC", enemy) -- Ensures kill is counted
            until enemy.Humanoid.Health <= 0 or not AutoFarm
        end
    end
end

-- AutoFarm Function
function StartAutoFarm()
    while AutoFarm do
        task.wait(0.1)
        local level = game.Players.LocalPlayer.Data.Level.Value
        local bestQuest

        -- Find the best quest for the player's level
        for _, quest in ipairs(Quests) do
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
