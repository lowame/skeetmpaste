local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local gethui = gethui or function() return game:GetService("CoreGui") end
local parent = gethui()

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GamesenseUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = parent

local notifyFrame = Instance.new("Frame")
notifyFrame.Size = UDim2.new(0, 260, 0, 60)
notifyFrame.Position = UDim2.new(1, 280, 1, -80)
notifyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
notifyFrame.BorderSizePixel = 0
notifyFrame.Parent = screenGui

local notifyCorner = Instance.new("UICorner")
notifyCorner.CornerRadius = UDim.new(0, 4)
notifyCorner.Parent = notifyFrame

local notifyTitle = Instance.new("TextLabel")
notifyTitle.Size = UDim2.new(1, -20, 0, 20)
notifyTitle.Position = UDim2.new(0, 10, 0, 8)
notifyTitle.BackgroundTransparency = 1
notifyTitle.Text = "gamesense injected"
notifyTitle.TextColor3 = Color3.fromRGB(235, 235, 235)
notifyTitle.TextXAlignment = Enum.TextXAlignment.Left
notifyTitle.Font = Enum.Font.Code
notifyTitle.TextSize = 14
notifyTitle.Parent = notifyFrame

local notifyBarBg = Instance.new("Frame")
notifyBarBg.Size = UDim2.new(1, -20, 0, 2)
notifyBarBg.Position = UDim2.new(0, 10, 1, -10)
notifyBarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
notifyBarBg.BorderSizePixel = 0
notifyBarBg.Parent = notifyFrame

local notifyBar = Instance.new("Frame")
notifyBar.Size = UDim2.new(1, 0, 1, 0)
notifyBar.BackgroundColor3 = Color3.fromRGB(235, 60, 60)
notifyBar.BorderSizePixel = 0
notifyBar.Parent = notifyBarBg

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 560, 0, 400)
mainFrame.Position = UDim2.new(0.5, -280, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 4)
mainCorner.Parent = mainFrame

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 30)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 4)
headerCorner.Parent = header

local headerLine = Instance.new("Frame")
headerLine.Size = UDim2.new(1, 0, 0, 1)
headerLine.Position = UDim2.new(0, 0, 1, 0)
headerLine.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
headerLine.BorderSizePixel = 0
headerLine.Parent = header

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -40, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "gamesense"
titleText.TextColor3 = Color3.fromRGB(235, 235, 235)
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Font = Enum.Font.Code
titleText.TextSize = 14
titleText.Parent = header

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 130, 1, -30)
sidebar.Position = UDim2.new(0, 0, 0, 30)
sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

local sideLine = Instance.new("Frame")
sideLine.Size = UDim2.new(0, 1, 1, 0)
sideLine.Position = UDim2.new(1, 0, 0, 0)
sideLine.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
sideLine.BorderSizePixel = 0
sideLine.Parent = sidebar

local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -130, 1, -30)
contentArea.Position = UDim2.new(0, 130, 0, 30)
contentArea.BackgroundTransparency = 1
contentArea.Parent = mainFrame

local dragging = false
local dragInput, mousePos, framePos

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = mainFrame.Position
    end
end)

header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - mousePos
        mainFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end
end)

local tabs = {}
local pages = {}

local function createTab(name, yPos)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, 0, 0, 30)
    tabBtn.Position = UDim2.new(0, 0, 0, yPos)
    tabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    tabBtn.BorderSizePixel = 0
    tabBtn.Text = ""
    tabBtn.Parent = sidebar

    local tabText = Instance.new("TextLabel")
    tabText.Size = UDim2.new(1, -20, 1, 0)
    tabText.Position = UDim2.new(0, 10, 0, 0)
    tabText.BackgroundTransparency = 1
    tabText.Text = name
    tabText.TextColor3 = Color3.fromRGB(140, 140, 140)
    tabText.TextXAlignment = Enum.TextXAlignment.Left
    tabText.Font = Enum.Font.Code
    tabText.TextSize = 13
    tabText.Parent = tabBtn

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -20, 1, -20)
    page.Position = UDim2.new(0, 10, 0, 10)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
    page.Visible = false
    page.Parent = contentArea

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    layout.Parent = page

    table.insert(tabs, {btn = tabBtn, txt = tabText, page = page})

    tabBtn.MouseButton1Click:Connect(function()
        for _, v in ipairs(tabs) do
            v.page.Visible = false
            v.txt.TextColor3 = Color3.fromRGB(140, 140, 140)
        end
        page.Visible = true
        tabText.TextColor3 = Color3.fromRGB(235, 235, 235)
    end)

    return page
end

local currentY = 0
local function addElement(parent, name, elementType, extra)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 20)
    container.BackgroundTransparency = 1
    container.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(180, 180, 180)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Code
    label.TextSize = 13
    label.Parent = container

    if elementType == "Toggle" then
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(0, 20, 0, 14)
        toggleBtn.Position = UDim2.new(1, -20, 0.5, -7)
        toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        toggleBtn.BorderSizePixel = 0
        toggleBtn.Text = ""
        toggleBtn.Parent = container

        local tCorner = Instance.new("UICorner")
        tCorner.CornerRadius = UDim.new(0, 2)
        tCorner.Parent = toggleBtn

        local state = false
        toggleBtn.MouseButton1Click:Connect(function()
            state = not state
            toggleBtn.BackgroundColor3 = state and Color3.fromRGB(235, 60, 60) or Color3.fromRGB(30, 30, 30)
        end)
    elseif elementType == "Slider" then
        local sliderBg = Instance.new("Frame")
        sliderBg.Size = UDim2.new(0, 120, 0, 14)
        sliderBg.Position = UDim2.new(1, -120, 0.5, -7)
        sliderBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        sliderBg.BorderSizePixel = 0
        sliderBg.Parent = container

        local sCorner = Instance.new("UICorner")
        sCorner.CornerRadius = UDim.new(0, 2)
        sCorner.Parent = sliderBg

        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
        sliderFill.BackgroundColor3 = Color3.fromRGB(235, 60, 60)
        sliderFill.BorderSizePixel = 0
        sliderFill.Parent = sliderBg

        local fCorner = Instance.new("UICorner")
        fCorner.CornerRadius = UDim.new(0, 2)
        fCorner.Parent = sliderFill

        local valLabel = Instance.new("TextLabel")
        valLabel.Size = UDim2.new(1, 0, 1, 0)
        valLabel.BackgroundTransparency = 1
        valLabel.Text = extra and tostring(extra) or "50"
        valLabel.TextColor3 = Color3.fromRGB(235, 235, 235)
        valLabel.Font = Enum.Font.Code
        valLabel.TextSize = 12
        valLabel.Parent = sliderBg
    elseif elementType == "Dropdown" then
        local dropBtn = Instance.new("TextButton")
        dropBtn.Size = UDim2.new(0, 120, 0, 14)
        dropBtn.Position = UDim2.new(1, -120, 0.5, -7)
        dropBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        dropBtn.BorderSizePixel = 0
        dropBtn.Text = extra or "Default"
        dropBtn.TextColor3 = Color3.fromRGB(235, 235, 235)
        dropBtn.Font = Enum.Font.Code
        dropBtn.TextSize = 12
        dropBtn.Parent = container

        local dCorner = Instance.new("UICorner")
        dCorner.CornerRadius = UDim.new(0, 2)
        dCorner.Parent = dropBtn
    end

    return container
end

local pageAimbot = createTab("Aimbot", 0)
currentY = 0
addElement(pageAimbot, "Enabled", "Toggle")
addElement(pageAimbot, "Target selection", "Dropdown", "Cycle")
addElement(pageAimbot, "Target hitbox", "Dropdown", "Head")
addElement(pageAimbot, "Minimum hit chance", "Slider", 50)
addElement(pageAimbot, "Maximum FOV", "Slider", 180)
addElement(pageAimbot, "Accuracy boost", "Toggle")
addElement(pageAimbot, "Anti-aim correction", "Toggle")

local pageAntiAim = createTab("Anti-aimbot angles", 30)
addElement(pageAntiAim, "Enabled", "Toggle")
addElement(pageAntiAim, "Pitch", "Dropdown", "Down")
addElement(pageAntiAim, "Yaw base", "Dropdown", "Forward")

local pageFakeLag = createTab("Fake lag", 60)
addElement(pageFakeLag, "Enabled", "Toggle")
addElement(pageFakeLag, "Amount", "Slider", 14)
addElement(pageFakeLag, "Variance", "Slider", 50)
addElement(pageFakeLag, "Limit", "Slider", 16)

local pageOther = createTab("Other", 90)
addElement(pageOther, "Slow motion", "Toggle")
addElement(pageOther, "Leg movement", "Toggle")
addElement(pageOther, "On shot anti-aim", "Toggle")
addElement(pageOther, "Fake peek", "Toggle")

tabs[1].page.Visible = true
tabs[1].txt.TextColor3 = Color3.fromRGB(235, 235, 235)

UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.P then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local showTween = TweenService:Create(notifyFrame, tweenInfo, {Position = UDim2.new(1, -280, 1, -80)})
showTween:Play()

showTween.Completed:Connect(function()
    local barTween = TweenService:Create(notifyBar, TweenInfo.new(3, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)})
    barTween:Play()
    
    barTween.Completed:Connect(function()
        local hideTween = TweenService:Create(notifyFrame, tweenInfo, {Position = UDim2.new(1, 280, 1, -80)})
        hideTween:Play()
        hideTween.Completed:Connect(function()
            notifyFrame.Visible = false
            mainFrame.Visible = true
        end)
    end)
end)
