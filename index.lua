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

        -- Increased speed (change 300 for even faster TP)
        local tweenInfo = TweenInfo.new((hrp.Position - targetPos).Magnitude / 300, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(targetPos)})

        -- Temporary NoClip
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

        -- Prevent being stuck
        local function ResetCharacter()
            if char:FindFirstChildOfClass("Humanoid") then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                humanoid:Move(Vector3.new(0, 0, 0))
                humanoid.Jump = true
            end
        end

        -- Start teleportation
        EnableNoclip()
        tween:Play()

        -- Fix rendering issues
        tween.Completed:Connect(function()
            wait(0.2)
            DisableNoclip()
            ResetCharacter()
            print("Teleport complete!")
        end)
    end
end

-- Teleport Locations
local Locations = {
    {"Starter Island", Vector3.new(-1149, 19, 3827)},
    {"Jungle", Vector3.new(-1601, 37, 152)},
    {"Pirate Village", Vector3.new(-1140, 5, 3852)},
    {"Desert", Vector3.new(978, 7, 4372)},
    {"Frozen Village", Vector3.new(1183, 27, -1213)},
    {"Marine Fortress", Vector3.new(-4841, 20, 4309)}
}

-- Add Teleport Buttons
for _, location in ipairs(Locations) do
    TeleportTab:CreateButton({
        Name = location[1],
        Callback = function()
            TweenTeleport(location[2])
        end
    })
end

-- Show UI
Window:Show()
