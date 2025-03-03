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

-- TweenService for Smooth Teleport
local TweenService = game:GetService("TweenService")
local function TweenTeleport(targetPos)
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        
        -- Create a Tween to move the player smoothly
        local tweenInfo = TweenInfo.new((hrp.Position - targetPos).Magnitude / 150, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(targetPos)})
        
        -- Enable Noclip temporarily
        local function Noclip()
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then
                    v.CanCollide = false
                end
            end
        end
        
        -- Start Tweening
        Noclip()
        tween:Play()
        
        -- Stop Noclip after teleport
        tween.Completed:Connect(function()
            wait(0.2)
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = true
                end
            end
            print("Teleport complete!")
        end)
    end
end

-- Teleport Locations
local Locations = {
    FirstSea = {
        {"Starter Island", Vector3.new(-1149, 19, 3827)},
        {"Jungle", Vector3.new(-1601, 37, 152)},
        {"Pirate Village", Vector3.new(-1140, 5, 3852)},
        {"Desert", Vector3.new(978, 7, 4372)},
        {"Frozen Village", Vector3.new(1183, 27, -1213)},
        {"Marine Fortress", Vector3.new(-4841, 20, 4309)}
    },
    SecondSea = {
        {"Dock", Vector3.new(81, 19, 2832)},
        {"Kingdom of Rose", Vector3.new(-392, 123, 605)},
        {"Usoap's Island", Vector3.new(-5242, 8, 4045)},
        {"Ice Castle", Vector3.new(5670, 28, -6520)},
        {"Hot and Cold", Vector3.new(-6000, 15, -5000)}
    },
    ThirdSea = {
        {"Port Town", Vector3.new(-290, 45, 5450)},
        {"Hydra Island", Vector3.new(5200, 635, 3450)},
        {"Great Tree", Vector3.new(2300, 25, -6500)},
        {"Floating Turtle", Vector3.new(-10000, 400, -9000)},
        {"Castle on the Sea", Vector3.new(-5000, 300, -5000)}
    }
}

-- Function to Add Teleport Buttons
local function AddTeleportButtons(tab, locations)
    for _, location in ipairs(locations) do
        tab:CreateButton({
            Name = location[1],
            Callback = function()
                TweenTeleport(location[2])
            end
        })
    end
end

-- Add Teleport Sections
TeleportTab:CreateSection("First Sea")
AddTeleportButtons(TeleportTab, Locations.FirstSea)

TeleportTab:CreateSection("Second Sea")
AddTeleportButtons(TeleportTab, Locations.SecondSea)

TeleportTab:CreateSection("Third Sea")
AddTeleportButtons(TeleportTab, Locations.ThirdSea)
