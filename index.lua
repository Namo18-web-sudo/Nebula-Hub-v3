local TweenService = game:GetService("TweenService")

local function TweenTeleport(targetPos)
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart

        -- Create a Tween to move the player smoothly
        local tweenInfo = TweenInfo.new((hrp.Position - targetPos).Magnitude / 150, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(targetPos)})

        -- Temporary Noclip to avoid getting stuck
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

        -- Prevent movement freeze
        local function ResetCharacter()
            if char:FindFirstChildOfClass("Humanoid") then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                humanoid:Move(Vector3.new(0, 0, 0)) -- Forces an update
                humanoid.Jump = true -- Jumps to unfreeze
            end
        end

        -- Start Tweening
        EnableNoclip()
        tween:Play()

        -- Ensure the map loads properly before restoring collision
        tween.Completed:Connect(function()
            wait(0.5) -- Small delay to allow rendering
            DisableNoclip()
            ResetCharacter() -- Fix stuck movement
            print("Teleport complete!")
        end)
    end
end
