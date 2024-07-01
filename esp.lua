local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local highlightTemplate = Instance.new("Highlight")
highlightTemplate.Name = "Highlight"
highlightTemplate.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

-- Function to add Highlight to a player's HumanoidRootPart
local function addHighlight(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
        local highlight = humanoidRootPart:FindFirstChild("Highlight")
        if not highlight then
            local highlightClone = highlightTemplate:Clone()
            highlightClone.Adornee = humanoidRootPart
            highlightClone.Parent = humanoidRootPart
        end

        -- Example of additional features
        highlightTemplate.Color = Color3.fromRGB(255, 0, 0) -- Change color of the highlight
        highlightTemplate.OutlineColor = Color3.fromRGB(0, 0, 0) -- Add an outline to the highlight
        highlightTemplate.OutlineTransparency = 0.5 -- Change the transparency of the outline
        highlightTemplate.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    end
end

-- Function to remove Highlight from a player's HumanoidRootPart
local function removeHighlight(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
        local highlight = humanoidRootPart:FindFirstChild("Highlight")
        if highlight then
            highlight:Destroy()
        end
    end
end

-- Add Highlight for existing players
for _, player in ipairs(Players:GetPlayers()) do
    addHighlight(player)
end

-- PlayerAdded event
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        addHighlight(player)
        -- Notify when a player joins
        local notif = Instance.new("TextLabel")
        notif.Text = player.Name .. " has joined the game"
        notif.Size = UDim2.new(1, 0, 0, 50)
        notif.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        notif.TextColor3 = Color3.fromRGB(255, 255, 255)
        notif.Parent = player.PlayerGui:FindFirstChildOfClass("ScreenGui")
        wait(3)
        notif:Destroy()
    end)
end)

-- PlayerRemoving event
Players.PlayerRemoving:Connect(function(player)
    removeHighlight(player)
    -- Notify when a player leaves
    local notif = Instance.new("TextLabel")
    notif.Text = player.Name .. " has left the game"
    notif.Size = UDim2.new(1, 0, 0, 50)
    notif.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    notif.TextColor3 = Color3.fromRGB(255, 255, 255)
    notif.Parent = player.PlayerGui:FindFirstChildOfClass("ScreenGui")
    wait(3)
    notif:Destroy()
end)

-- CharacterAdded event
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        -- Make sure to call addHighlight when CharacterAdded
        addHighlight(player)
    end)
end)

-- Update highlights during Heartbeat
RunService.Heartbeat:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        addHighlight(player) -- Ensure all players have Highlight
    end
end)
