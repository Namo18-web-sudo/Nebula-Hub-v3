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
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")

-- Anti AFK
player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Function to Equip Weapon
local function EquipWeapon(weapon)
    for _, tool in pairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.Name == weapon then
            player.Character.Humanoid:EquipTool(tool)
        end
    end
end

-- List of First Sea Islands & Quests
local FirstSeaQuests = {
    { Level = 0, Name = "Bandits", NPC = "Bandit Quest Giver", CFrame = CFrame.new(-1139, 16, 3790), Mob = "Bandit" },
    { Level = 10, Name = "Monkeys", NPC = "Jungle Quest Giver", CFrame = CFrame.new(-1600, 36, 152), Mob = "Monkey" },
    { Level = 15, Name = "Gorillas", NPC = "Jungle Quest Giver", CFrame = CFrame.new(-1600, 36, 152), Mob = "Gorilla" },
    { Level = 30, Name = "Pirates", NPC = "Pirate Quest Giver", CFrame = CFrame.new(-1140, 5, 3852), Mob = "Pirate" },
    { Level = 40, Name = "Brutes", NPC = "Pirate Quest Giver", CFrame = CFrame.new(-1140, 5, 3852), Mob = "Brute" },
    { Level = 60, Name = "Desert Bandits", NPC = "Desert Quest Giver", CFrame = CFrame.new(920, 7, 4475), Mob = "Desert Bandit" },
    { Level = 75, Name = "Desert Officers", NPC = "Desert Quest Giver", CFrame = CFrame.new(920, 7, 4475), Mob = "Desert Officer" },
    { Level = 90, Name = "Snow Bandits", NPC = "Frozen Quest Giver", CFrame = CFrame.new(1389, 87, -1298), Mob = "Snow Bandit" },
    { Level = 105, Name = "Snowman", NPC = "Frozen Quest Giver", CFrame = CFrame.new(1389, 87, -1298), Mob = "Snowman" },
    { Level = 120, Name = "Chief Petty Officers", NPC = "Marine Quest Giver", CFrame = CFrame.new(-5038, 28, 4326), Mob = "Chief Petty Officer" },
    { Level = 150, Name = "Sky Bandits", NPC = "Sky Quest Giver", CFrame = CFrame.new(-4840, 718, -2623), Mob = "Sky Bandit" },
    { Level = 175, Name = "Dark Masters", NPC = "Sky Quest Giver", CFrame = CFrame.new(-4840, 718, -2623), Mob = "Dark Master" },
    { Level = 190, Name = "Prisoners", NPC = "Prison Quest Giver", CFrame = CFrame.new(5310, 2, 476), Mob = "Prisoner" },
    { Level = 250, Name = "Toga Warriors", NPC = "Colosseum Quest Giver", CFrame = CFrame.new(-1576, 7, -2985), Mob = "Toga Warrior" },
    { Level = 275, Name = "Gladiators", NPC = "Colosseum Quest Giver", CFrame = CFrame.new(-1576, 7, -2985), Mob = "Gladiator" },
    { Level = 300, Name = "Military Soldiers", NPC = "Magma Quest Giver", CFrame = CFrame.new(-5319, 12, 8517), Mob = "Military Soldier" },
    { Level = 375, Name = "Fishman Warriors", NPC = "Fishman Quest Giver", CFrame = CFrame.new(61122, 18, 1569), Mob = "Fishman Warrior" },
    { Level = 400, Name = "Fishman Commandos", NPC = "Fishman Quest Giver", CFrame = CFrame.new(61122, 18, 1569), Mob = "Fishman Commando" },
    { Level = 450, Name = "God's Guards", NPC = "Sky Exp. Quest Giver", CFrame = CFrame.new(-4722, 845, -1918), Mob = "God's Guard" },
    { Level = 475, Name = "Shandas", NPC = "Sky Exp. Quest Giver", CFrame = CFrame.new(-4722, 845, -1918), Mob = "Shanda" },
}

-- AutoFarm Function
local function AutoFarm()
    while _G.AutoFarm do
        task.wait(0.1)

        -- Check if Player Exists
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            continue
        end

        -- Get Current Level
        local level = player.Data.Level.Value

        -- Find Correct Quest
        local bestQuest
        for _, quest in ipairs(FirstSeaQuests) do
            if level >= quest.Level then
                bestQuest = quest
            end
        end

        if bestQuest then
            -- Teleport to Quest NPC
            player.Character.HumanoidRootPart.CFrame = bestQuest.CFrame
            task.wait(1)

            -- Start Quest
            local args = {
                [1] = bestQuest.NPC,
                [2] = bestQuest.Name
            }
            ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", unpack(args))
            task.wait(0.5)

            -- Find & Attack Enemies
            for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                if enemy.Name == bestQuest.Mob and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") then
                    repeat
                        task.wait()
                        EquipWeapon("Combat") -- Change to preferred weapon
                        player.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 10, 0)
                        enemy.Humanoid.Health = 0
                    until enemy.Humanoid.Health <= 0 or not _G.AutoFarm
                end
            end
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
