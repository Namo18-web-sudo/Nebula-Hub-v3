-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Create UI Window
local Window = Rayfield:CreateWindow({
    Name = "Blox Fruits Teleport Hub",
    LoadingTitle = "Teleporting...",
    LoadingSubtitle = "By YourName",
    Theme = "Dark",
})

-- Function for Safe Teleporting with Instant Stop
local function SafeTeleport(destination)
    local player = game.Players.LocalPlayer
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        Rayfield:Notify({
            Title = "Error",
            Content = "Character not found!",
            Duration = 3,
            Type = "Error"
        })
        return
    end

    local hrp = player.Character.HumanoidRootPart
    local tweenService = game:GetService("TweenService")
    local distance = (hrp.Position - destination).Magnitude
    local speed = 200  -- Adjust teleport speed
    local time = distance / speed

    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
    local tween = tweenService:Create(hrp, tweenInfo, {Position = destination})
    
    -- Start the teleport
    tween:Play()

    -- Check every 0.1 seconds if we reached the location
    local connection
    connection = game:GetService("RunService").Heartbeat:Connect(function()
        if (hrp.Position - destination).Magnitude < 5 then  -- Stops if within 5 studs
            tween:Cancel()  -- Stop teleporting immediately
            connection:Disconnect()  -- Stop checking position
            Rayfield:Notify({
                Title = "Teleport Complete!",
                Content = "You have arrived.",
                Duration = 3,
                Type = "Success"
            })
        end
    end)
end

-- First Sea Locations
local FirstSea = {
    ["Starter Island"] = Vector3.new(-655, 8, 4622),
    ["Jungle"] = Vector3.new(-1335, 12, 304),
    ["Pirate Village"] = Vector3.new(-1122, 14, 3855),
    ["Marine Fortress"] = Vector3.new(-4500, 20, 4260),
    ["Sky Island"] = Vector3.new(-4924, 295, -2773),
    ["Magma Island"] = Vector3.new(-5231, 10, 8463),
    ["Fountain City"] = Vector3.new(3350, 14, -4953),
}

-- Second Sea Locations
local SecondSea = {
    ["Dock"] = Vector3.new(2272, 12, 3794),
    ["Kingdom of Rose"] = Vector3.new(-394, 122, 598),
    ["Green Zone"] = Vector3.new(-2387, 72, -3166),
    ["Graveyard"] = Vector3.new(-5414, 11, -721),
    ["Ice Castle"] = Vector3.new(5407, 28, -6230),
    ["Hot and Cold"] = Vector3.new(-5847, 15, -4472),
    ["Forgotten Island"] = Vector3.new(-3054, 238, -10191),
}

-- Third Sea Locations
local ThirdSea = {
    ["Port Town"] = Vector3.new(-290, 44, 5450),
    ["Hydra Island"] = Vector3.new(5228, 604, 345),
    ["Great Tree"] = Vector3.new(2250, 25, -6525),
    ["Floating Turtle"] = Vector3.new(-11000, 600, -9000),
    ["Haunted Castle"] = Vector3.new(-9515, 142, 5537),
    ["Sea of Treats"] = Vector3.new(-190, 50, -12000),
}

-- Create Tabs
local FirstSeaTab = Window:CreateTab("First Sea", 4483362458)
local SecondSeaTab = Window:CreateTab("Second Sea", 4483362458)
local ThirdSeaTab = Window:CreateTab("Third Sea", 4483362458)

-- Function to Create Teleport Buttons
local function CreateTeleportButtons(tab, locations)
    for name, position in pairs(locations) do
        tab:CreateButton({
            Name = "Teleport to " .. name,
            Callback = function()
                SafeTeleport(position)
            end
        })
    end
end

-- Generate Teleport Buttons
CreateTeleportButtons(FirstSeaTab, FirstSea)
CreateTeleportButtons(SecondSeaTab, SecondSea)
CreateTeleportButtons(ThirdSeaTab, ThirdSea)

-- Misc Tab for Extra Features
local MiscTab = Window:CreateTab("Misc", 4483362458)

-- Teleport to Nearest Chest
MiscTab:CreateButton({
    Name = "Teleport to Nearest Chest",
    Callback = function()
        local player = game.Players.LocalPlayer
        local closestChest = nil
        local shortestDistance = math.huge

        for _, obj in pairs(workspace:GetChildren()) do
            if obj.Name:lower():find("chest") and obj:IsA("Model") then
                local distance = (player.Character.HumanoidRootPart.Position - obj:GetPivot().Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestChest = obj
                end
            end
        end

        if closestChest then
            SafeTeleport(closestChest:GetPivot().Position)
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "No chests found!",
                Duration = 3,
                Type = "Error"
            })
        end
    end
})
