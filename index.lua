-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create Main Window
local Window = Rayfield:CreateWindow({
    Name = "NEBULA TELEPORT HUB",
    LoadingTitle = "Detecting Sea...",
    LoadingSubtitle = "Please wait",
    Theme = "Default",
    KeySystem = false
})

-- Create Teleport Tab
local TeleportTab = Window:CreateTab("Teleport", 4483362458)

-- TweenService for Smooth & Fast Teleportation
local TweenService = game:GetService("TweenService")

-- Function for Ultra Smooth & Fast Teleport
local function SmoothTeleport(targetPos)
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart

        -- Make sure it's fast and ultra smooth
        local distance = (hrp.Position - targetPos).Magnitude
        local tweenTime = math.clamp(distance / 300, 0.5, 2) -- Smooth but fast

        local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(targetPos)})

        -- Enable NoClip for seamless teleport
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

        -- Prevent character freezing
        local function ResetCharacter()
            if char:FindFirstChildOfClass("Humanoid") then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                humanoid:Move(Vector3.new(0, 0, 0))
                humanoid.Jump = true
            end
        end

        -- Start teleport
        EnableNoclip()
        tween:Play()

        -- Ensure proper rendering and reset character
        tween.Completed:Connect(function()
            wait(0.3)
            DisableNoclip()
            ResetCharacter()
            print("Smooth Teleport Complete!")
        end)
    end
end

-- Define Teleport Locations for Each Sea
local Locations = {
    ["First Sea"] = {
        {"Starter Island", Vector3.new(-1149, 19, 3827)},
        {"Jungle", Vector3.new(-1601, 37, 152)},
        {"Pirate Village", Vector3.new(-1140, 5, 3852)},
        {"Desert", Vector3.new(978, 7, 4372)},
        {"Frozen Village", Vector3.new(1183, 27, -1213)},
        {"Marine Fortress", Vector3.new(-4841, 20, 4309)}
    },
    ["Second Sea"] = {
        {"Dock", Vector3.new(81, 19, 2832)},
        {"Kingdom of Rose", Vector3.new(-392, 123, 605)},
        {"Usoap's Island", Vector3.new(-5242, 8, 4045)},
        {"Ice Castle", Vector3.new(5670, 28, -6520)},
        {"Hot and Cold", Vector3.new(-6000, 15, -5000)}
    },
    ["Third Sea"] = {
        {"Port Town", Vector3.new(-290, 45, 5450)},
        {"Hydra Island", Vector3.new(5200, 635, 3450)},
        {"Great Tree", Vector3.new(2300, 25, -6500)},
        {"Floating Turtle", Vector3.new(-10000, 400, -9000)},
        {"Castle on the Sea", Vector3.new(-5000, 300, -5000)}
    }
}

-- Auto Detect Which Sea the Player Is In
local function DetectSea()
    local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return "First Sea" end -- Default to First Sea

    local pos = hrp.Position
    if pos.X >= -6000 and pos.X <= 6000 and pos.Z >= -7000 and pos.Z <= 7000 then
        return "First Sea"
    elseif pos.X >= -10000 and pos.X <= 10000 and pos.Z >= -12000 and pos.Z <= 12000 then
        return "Second Sea"
    else
        return "Third Sea"
    end
end

-- Add Buttons Based on Detected Sea
local function LoadTeleportButtons()
    local sea = DetectSea()
    TeleportTab:CreateSection(sea .. " Islands")

    for _, location in ipairs(Locations[sea]) do
        TeleportTab:CreateButton({
            Name = location[1],
            Callback = function()
                SmoothTeleport(location[2])
            end
        })
    end
end

-- Load Buttons for Current Sea
LoadTeleportButtons()

-- Show UI
Window:Show()
