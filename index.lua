-- Load Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Create UI Window
local Window = Rayfield:CreateWindow({
    Name = "NEBULA Teleport Hub",
    LoadingTitle = "Teleporting...",
    LoadingSubtitle = "By NEBULA",
    Theme = "Dark",
})

-- Bypass Anti-Cheat Teleport Function
local function BypassTeleport(destination)
    local player = game.Players.LocalPlayer
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        Rayfield:Notify({ Title = "Error", Content = "Character not found!", Duration = 3, Type = "Error" })
        return
    end

    local hrp = player.Character.HumanoidRootPart
    local tweenService = game:GetService("TweenService")

    -- Adjusted Speed for Bypass
    local speed = 100
    local timeToReach = (destination - hrp.Position).Magnitude / speed

    -- Start Bypass Method (Fake Position)
    hrp.Anchored = true
    hrp.CFrame = CFrame.new(destination)

    -- Smooth Tween for Anti-Cheat Bypass
    local tween = tweenService:Create(hrp, TweenInfo.new(timeToReach, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Position = destination})
    tween:Play()
    tween.Completed:Wait()

    -- Wait, then Restore Movement
    task.wait(0.2)
    hrp.Anchored = false

    Rayfield:Notify({ Title = "Teleport Complete!", Content = "Arrived Successfully!", Duration = 3, Type = "Success" })
end

-- Locations
local FirstSea = { ["Starter Island"] = Vector3.new(-655, 8, 4622), ["Jungle"] = Vector3.new(-1335, 12, 304) }
local SecondSea = { ["Dock"] = Vector3.new(2272, 12, 3794), ["Green Zone"] = Vector3.new(-2387, 72, -3166) }
local ThirdSea = { ["Port Town"] = Vector3.new(-290, 44, 5450), ["Great Tree"] = Vector3.new(2250, 25, -6525) }
local SeaSwitch = { ["First Sea"] = Vector3.new(-1836, 10, 1714), ["Second Sea"] = Vector3.new(-11, 10, 2799), ["Third Sea"] = Vector3.new(5545, 606, -3222) }

-- Create UI Tabs
local FirstSeaTab = Window:CreateTab("First Sea", 4483362458)
local SecondSeaTab = Window:CreateTab("Second Sea", 4483362458)
local ThirdSeaTab = Window:CreateTab("Third Sea", 4483362458)

-- Function to Create Buttons
local function CreateTeleportButtons(tab, locations)
    for name, position in pairs(locations) do
        tab:CreateButton({
            Name = "Teleport to " .. name,
            Callback = function() BypassTeleport(position) end
        })
    end
end

-- Add Locations to UI
CreateTeleportButtons(FirstSeaTab, FirstSea)
CreateTeleportButtons(SecondSeaTab, SecondSea)
CreateTeleportButtons(ThirdSeaTab, ThirdSea)

-- Teleport Between Seas
FirstSeaTab:CreateButton({ Name = "Go to Second Sea", Callback = function() BypassTeleport(SeaSwitch["Second Sea"]) end })
FirstSeaTab:CreateButton({ Name = "Go to Third Sea", Callback = function() BypassTeleport(SeaSwitch["Third Sea"]) end })
SecondSeaTab:CreateButton({ Name = "Go to First Sea", Callback = function() BypassTeleport(SeaSwitch["First Sea"]) end })
SecondSeaTab:CreateButton({ Name = "Go to Third Sea", Callback = function() BypassTeleport(SeaSwitch["Third Sea"]) end })
ThirdSeaTab:CreateButton({ Name = "Go to First Sea", Callback = function() BypassTeleport(SeaSwitch["First Sea"]) end })
ThirdSeaTab:CreateButton({ Name = "Go to Second Sea", Callback = function() BypassTeleport(SeaSwitch["Second Sea"]) end })
