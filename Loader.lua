local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "ZackHubLoader"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = game:GetService("CoreGui")

-- Blur
local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = Lighting

TweenService:Create(
    blur,
    TweenInfo.new(0.35),
    {Size = 24}
):Play()

-- Background
local bg = Instance.new("Frame")
bg.Size = UDim2.fromScale(1,1)
bg.BackgroundColor3 = Color3.fromRGB(15,15,15)
bg.Parent = gui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,50)
title.Position = UDim2.new(0,0,0.42,0)
title.BackgroundTransparency = 1
title.Text = "ZackHub"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.Parent = bg

-- Status
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1,0,0,35)
status.Position = UDim2.new(0,0,0.5,0)
status.BackgroundTransparency = 1
status.Text = "Loading..."
status.Font = Enum.Font.Gotham
status.TextScaled = true
status.TextColor3 = Color3.fromRGB(200,200,200)
status.Parent = bg

local function closeLoader()
    TweenService:Create(
        blur,
        TweenInfo.new(0.35),
        {Size = 0}
    ):Play()

    TweenService:Create(
        bg,
        TweenInfo.new(0.35),
        {BackgroundTransparency = 1}
    ):Play()

    task.wait(0.4)
    blur:Destroy()
    gui:Destroy()
end

local placeId = game.PlaceId

if placeId == 891852901 then
    status.Text = "Loading Zackhub for Greenville..."
    task.wait(0.5)

    loadstring(game:HttpGet("https://raw.githubusercontent.com/5yed/ZackHub/refs/heads/main/GV.lua"))()
    closeLoader()

elseif placeId == 136020512003847 then
    status.Text = "Loading Zackhub for SDBR..."
    task.wait(0.5)

    loadstring(game:HttpGet("https://raw.githubusercontent.com/5yed/ZackHub/refs/heads/main/SDBR.lua"))()
    closeLoader()

else
    status.Text = "Unsupported Game"
    task.wait(2)
    closeLoader()

    warn("Unsupported game:", placeId)
end
