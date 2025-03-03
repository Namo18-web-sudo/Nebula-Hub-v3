-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create Main Window
local Window = Rayfield:CreateWindow({
    Name = "NEBULA TELEPORT HUB",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by NEBULA",
    Theme = "Default",
    KeySystem = false
})

-- Create Teleport Tab
local TeleportTab = Window:CreateTab("Teleport", 4483362458)

-- Function to Smooth Teleport
local function SmoothTeleport(targetPos)
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        while (hrp.Position - targetPos).Magnitude > 5 do
            task.wait()
            hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(targetPos), 0.2)
        end
    end
end

-- First Sea Locations
local FirstSea = {
    {"Starter Island", Vector3.new(-1149, 19, 3827)},
    {"Jungle", Vector3.new(-1601, 37, 152)},
    {"Pirate Village", Vector3.new(-1140, 5, 3852)},
    {"Desert", Vector3.new(978, 7, 4372)},
    {"Frozen Village", Vector3.new(1183, 27, -1213)},
    {"Marine Fortress", Vector3.new(-4841, 20, 4309)}
}

-- Second Sea Locations
local SecondSea = {
    {"Dock", Vector3.new(81, 19, 2832)},
    {"Kingdom of Rose", Vector3.new(-392, 123, 605)},
    {"Usoap's Island", Vector3.new(-5242, 8, 4045)},
    {"Ice Castle", Vector3.new(5670, 28, -6520)},
    {"Hot and Cold", Vector3.new(-6000, 15, -5000)}
}

-- Third Sea Locations
local ThirdSea = {
    {"Port Town", Vector3.new(-290, 45, 5450)},
    {"Hydra Island", Vector3.new(5200, 635, 3450)},
    {"Great Tree", Vector3.new(2300, 25, -6500)},
    {"Floating Turtle", Vector3.new(-10000, 400, -9000)},
    {"Castle on the Sea", Vector3.new(-5000, 300, -5000)}
}

-- Function to Add Teleport Buttons
local function AddTeleportButtons(tab, locations)
    for _, location in ipairs(locations) do
        tab:CreateButton({
            Name = location[1],
            Callback = function()
                SmoothTeleport(location[2])
            end
        })
    end
end

-- Add Teleport Sections
local FirstSeaTab = TeleportTab:CreateSection("First Sea")
AddTeleportButtons(TeleportTab, FirstSea)

local SecondSeaTab = TeleportTab:CreateSection("Second Sea")
AddTeleportButtons(TeleportTab, SecondSea)

local ThirdSeaTab = TeleportTab:CreateSection("Third Sea")
AddTeleportButtons(TeleportTab, ThirdSea)
