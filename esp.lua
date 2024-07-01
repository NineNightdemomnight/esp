local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Create a new Highlight template
local highlightTemplate = Instance.new("Highlight")
highlightTemplate.Name = "Highlight"
highlightTemplate.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
highlightTemplate.Color = Color3.fromRGB(255, 0, 0)  -- Set the default highlight color
highlightTemplate.OutlineColor = Color3.fromRGB(0, 0, 0)
highlightTemplate.OutlineTransparency = 0.5

local highlightEnabled = true  -- Variable to track if Highlight is enabled

-- Function to add Highlight to a player's HumanoidRootPart
local function addHighlight(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart:FindFirstChild("Highlight") then
            local highlightClone = highlightTemplate:Clone()
            highlightClone.Adornee = humanoidRootPart
            highlightClone.Parent = humanoidRootPart
        end
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

-- Function to toggle Highlight on and off
local function toggleHighlight()
    highlightEnabled = not highlightEnabled  -- Toggle the boolean value
    for _, player in ipairs(Players:GetPlayers()) do
        if highlightEnabled then
            addHighlight(player)  -- Add Highlight if enabled
        else
            removeHighlight(player)  -- Remove Highlight if disabled
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
        if highlightEnabled then
            -- Add Highlight when a new Character is added
            addHighlight(player)
        end
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

-- Improved Heartbeat connection to optimize performance
RunService.Heartbeat:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if highlightEnabled then
                addHighlight(player)  -- Ensure all players have Highlight
            end
        end
    end
end)

-- Add Command for Toggle Highlight
local Commands = Instance.new("Folder")
Commands.Name = "Commands"
Commands.Parent = game.ServerScriptService

local function createCommand(name, callback)
    local command = Instance.new("RemoteFunction")
    command.Name = name
    command.Parent = Commands
    command.OnServerInvoke = callback
end

createCommand("ToggleHighlight", function()
    toggleHighlight()  -- Toggle Highlight on and off
end)

-- Bind Ctrl+X to toggle Highlight
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.X and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        toggleHighlight()  -- Toggle Highlight when Ctrl+X is pressed
    end
end)
