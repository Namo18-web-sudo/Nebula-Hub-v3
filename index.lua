_G.AutoFarm = true -- Toggle AutoFarm ON/OFF

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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

-- Function to Fly Above NPCs
local function FlyAbove(target)
    if target and target:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame + Vector3.new(0, 20, 0)
    end
end

-- List of Quests for First, Second, and Third Sea
local Quests = {
    { Level = 0, Name = "Bandits", NPC = "Bandit Quest Giver", CFrame = CFrame.new(-1139, 16, 3790), Mob = "Bandit" },
    { Level = 10, Name = "Monkeys", NPC = "Jungle Quest Giver", CFrame = CFrame.new(-1600, 36, 152), Mob = "Monkey" },
    { Level = 15, Name = "Gorillas", NPC = "Jungle Quest Giver", CFrame = CFrame.new(-1600, 36, 152), Mob = "Gorilla" },
    { Level = 30, Name = "Pirates", NPC = "Pirate Quest Giver", CFrame = CFrame.new(-1140, 5, 3852), Mob = "Pirate" },
    { Level = 40, Name = "Brutes", NPC = "Pirate Quest Giver", CFrame = CFrame.new(-1140, 5, 3852), Mob = "Brute" },
    { Level = 60, Name = "Desert Bandits", NPC = "Desert Quest Giver", CFrame = CFrame.new(920, 7, 4475), Mob = "Desert Bandit" },
    { Level = 75, Name = "Desert Officers", NPC = "Desert Quest Giver", CFrame = CFrame.new(920, 7, 4475), Mob = "Desert Officer" },
}

-- Function to Take Quest
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
                FlyAbove(enemy) -- Fly above the enemy
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

-- Run AutoFarm
AutoFarm()
