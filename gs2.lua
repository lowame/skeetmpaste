local playersService = game:GetService("Players")
local userInput = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")
local coreGui = game:GetService("CoreGui")
local localPlayer = playersService.LocalPlayer

if type(getgenv) == "function" then
    if getgenv().gsMenuLoaded then
        return
    end
    getgenv().gsMenuLoaded = true
end

local WIDTH = 832
local HEIGHT = 744

local palette = {
    accent = Color3.fromRGB(154, 200, 32),
    yellow = Color3.fromRGB(196, 196, 62),
    mainBg = Color3.fromRGB(18, 18, 18),
    sideBg = Color3.fromRGB(12, 12, 12),
    panel = Color3.fromRGB(24, 24, 24),
    panelBorder = Color3.fromRGB(42, 42, 42),
    control = Color3.fromRGB(35, 35, 35),
    controlBorder = Color3.fromRGB(54, 54, 54),
    listBg = Color3.fromRGB(29, 29, 29),
    listHover = Color3.fromRGB(44, 44, 44),
    track = Color3.fromRGB(61, 61, 61),
    boxOff = Color3.fromRGB(61, 61, 61),
    header = Color3.fromRGB(235, 235, 235),
    text = Color3.fromRGB(206, 206, 206),
    textMid = Color3.fromRGB(178, 178, 178),
    dim = Color3.fromRGB(112, 112, 112),
    bind = Color3.fromRGB(92, 92, 92),
    icon = Color3.fromRGB(122, 122, 122),
    iconActive = Color3.fromRGB(235, 235, 235),
    tabHover = Color3.fromRGB(22, 22, 22),
    tabActive = Color3.fromRGB(34, 34, 34),
    black = Color3.fromRGB(0, 0, 0),
    white = Color3.fromRGB(245, 245, 245),
}

local FONT = Enum.Font.Code

local function tween(obj, duration, props, style, direction)
    local info = TweenInfo.new(duration, style or Enum.EasingStyle.Quart, direction or Enum.EasingDirection.Out)
    local tw = tweenService:Create(obj, info, props)
    tw:Play()
    return tw
end

local function tween(obj, duration, props, style, direction)
    local info = TweenInfo.new(duration, style or Enum.EasingStyle.Quart, direction or Enum.EasingStyle.Out)
    local tw = tweenService:Create(obj, info, props)
    tw:Play()
    return tw
end

local icons = {}

icons.head = {
    "..............",
    "..######......",
    ".########.....",
    ".###.######...",
    ".##########...",
    ".##########.#.",
    ".############.",
    ".##########.#.",
    "..#########...",
    "...#######....",
    "....#####.....",
    "......##......",
    "..............",
    "..............",
}

icons.antiaim = {
    "....######....",
    "..##......##..",
    ".#..........#.",
    ".#........#.#.",
    "#.........#..#",
    "#........#...#",
    "#.......#....#",
    "#......#.....#",
    "#.....#......#",
    ".#..#........#",
    ".#.#........#.",
    "..##......##..",
    "....######....",
    "..............",
}

icons.crosshair = {
    "......##......",
    "...########...",
    "..##......##..",
    ".#..........#.",
    "#............#",
    "#.....##.....#",
    "##....##....##",
    "##....##....##",
    "#.....##.....#",
    "#............#",
    ".#..........#.",
    "..##......##..",
    "...########...",
    "......##......",
}

icons.visuals = {
    "......##......",
    "..#........#..",
    "...########...",
    "..##########..",
    ".########..##.",
    ".########...#.",
    "##.######...#.",
    "##.######...#.",
    ".########...#.",
    ".########..##.",
    "..##########..",
    "...########...",
    "..#........#..",
    "......##......",
}

icons.misc = {
    "....##..##....",
    "....######....",
    "..##########..",
    ".####....####.",
    ".##........##.",
    "###........###",
    "###........###",
    ".##........##.",
    ".####....####.",
    "..##########..",
    "....######....",
    "....##..##....",
    "..............",
    "..............",
}

icons.skins = {
    ".............#",
    "...........##.",
    ".........###..",
    ".......####...",
    ".....####.....",
    "...####.......",
    ".####.........",
    "####..........",
    "###...........",
    "###...........",
    "##............",
    "..............",
    "..............",
    "..............",
}

icons.players = {
    "....######....",
    "...########...",
    "...########...",
    "...########...",
    "....######....",
    ".....####.....",
    "..............",
    "...########...",
    "..##########..",
    ".############.",
    ".############.",
    ".############.",
    "..............",
    "..............",
}

icons.configs = {
    "############..",
    "#....####..##.",
    "#....####...#.",
    "#...........#.",
    "#...........#.",
    "#.#######...#.",
    "#.#.....#...#.",
    "#.#.....#...#.",
    "#.#######...#.",
    "#############.",
    "..............",
    "..............",
    "..............",
    "..............",
}

icons.gun = {
    "..................",
    ".################.",
    ".################.",
    "..####..#####..##.",
    "...##.......##....",
    "..##........##....",
    ".##..............",
}

icons.cursor = {
    "o...........",
    "oo..........",
    "o#o.........",
    "o##o........",
    "o###o.......",
    "o####o......",
    "o#####o.....",
    "o######o....",
    "o#######o...",
    "o########o..",
    "o#########o.",
    "o####ooooo..",
    "o##o........",
    "oo.o........",
    "..oo........",
}

local function drawPixels(map, scale, parent, colorMap)
    local colors = colorMap or { ["#"] = palette.icon }
    local width = 0
    for _, row in ipairs(map) do
        if #row > width then
            width = #row
        end
    end
    local holder = new("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, width * scale, 0, #map * scale),
        Parent = parent,
    })
    local pixels = {}
    for y, row in ipairs(map) do
        local x = 1
        while x <= #row do
            local char = row:sub(x, x)
            if colors[char] then
                local start = x
                while x <= #row and row:sub(x, x) == char do
                    x = x + 1
                end
                local pixel = new("Frame", {
                    BackgroundColor3 = colors[char],
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, (start - 1) * scale, 0, (y - 1) * scale),
                    Size = UDim2.new(0, (x - start) * scale, 0, scale),
                    Parent = holder,
                })
                table.insert(pixels, pixel)
            else
                x = x + 1
            end
        end
    end
    return holder, pixels
end

local gui = new("ScreenGui", {
    Name = "gsui",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})

local old = coreGui:FindFirstChild("gsui")
if old then
    old:Destroy()
end

local parented = pcall(function()
    gui.Parent = coreGui
end)
if not parented then
    gui.Parent = localPlayer:WaitForChild("PlayerGui")
end

local holder = new("Frame", {
    Name = "holder",
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundTransparency = 1,
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = UDim2.new(0, WIDTH, 0, HEIGHT),
    Parent = gui,
})

local scaler = new("UIScale", { Scale = 1, Parent = holder })

local root = new("Frame", {
    Name = "root",
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = palette.mainBg,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = UDim2.new(0, WIDTH, 0, 0),
    Visible = false,
    ZIndex = 1,
    Parent = holder,
})

new("UIStroke", { Color = palette.black, Thickness = 1, Parent = root })

local topBar = new("Frame", {
    BackgroundColor3 = palette.accent,
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 0, 2),
    ZIndex = 2,
    Parent = root,
})

new("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(124, 58, 237)),
        ColorSequenceKeypoint.new(0.25, Color3.fromRGB(236, 72, 153)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(245, 158, 11)),
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(234, 179, 8)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(132, 204, 22)),
    }),
    Parent = topBar,
})

local sidebar = new("Frame", {
    BackgroundColor3 = palette.sideBg,
    BorderSizePixel = 0,
    Position = UDim2.new(0, 0, 0, 2),
    Size = UDim2.new(0, 96, 1, -2),
    ZIndex = 2,
    Parent = root,
})

local sideEdge = new("Frame", {
    BackgroundColor3 = palette.panelBorder,
    BorderSizePixel = 0,
    Position = UDim2.new(1, 0, 0, 0),
    Size = UDim2.new(0, 1, 1, 0),
    ZIndex = 3,
    Parent = sidebar,
})

local pagesArea = new("Frame", {
    BackgroundTransparency = 1,
    ClipsDescendants = true,
    Position = UDim2.new(0, 97, 0, 2),
    Size = UDim2.new(1, -97, 1, -2),
    ZIndex = 2,
    Parent = root,
})

local dropdowns = {}
local openDropdown = nil
local capturing = nil
local menuOpen = false

local function rectContains(frame, point)
    local pos = frame.AbsolutePosition
    local size = frame.AbsoluteSize
    return point.X >= pos.X and point.X <= pos.X + size.X and point.Y >= pos.Y and point.Y <= pos.Y + size.Y
end

local function startCapture(bindButton, previous)
    capturing = { button = bindButton, previous = previous }
    bindButton.Text = "[...]"
end

local pages = {}
local tabButtons = {}
local tabHighlights = {}
local tabPixels = {}
local currentTab = 1

local function selectTab(index)
    currentTab = index
    for i = 1, #pages do
        pages[i].Visible = (i == index)
    end
    for i = 1, #tabButtons do
        local active = (i == index)
        tabHighlights[i].BackgroundTransparency = active and 0 or 1
        for _, pixel in ipairs(tabPixels[i]) do
            pixel.BackgroundColor3 = active and palette.iconActive or palette.icon
        end
    end
end

local function createColumn(parent, x)
    local column = new("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, x, 0, 24),
        Size = UDim2.new(0, 326, 1, -48),
        Parent = parent,
    })
    new("UIListLayout", {
        Padding = UDim.new(0, 18),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = column,
    })
    return column
end

local function createPanel(column, title, height, order)
    local panelHolder = new("Frame", {
        BackgroundTransparency = 1,
        LayoutOrder = order,
        Size = UDim2.new(1, 0, 0, height),
        Parent = column,
    })
    new("TextLabel", {
        BackgroundTransparency = 1,
        Font = FONT,
        Text = title,
        TextColor3 = palette.header,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(1, 0, 0, 18),
        Parent = panelHolder,
    })
    local box = new("Frame", {
        BackgroundColor3 = palette.panel,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 20),
        Size = UDim2.new(1, 0, 1, -20),
        Parent = panelHolder,
    })
    new("UIStroke", { Color = palette.panelBorder, Thickness = 1, Parent = box })
    local content = new("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 14, 0, 12),
        Size = UDim2.new(1, -28, 1, -24),
        Parent = box,
    })
    new("UIListLayout", {
        Padding = UDim.new(0, 9),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = content,
    })
    local orderCounter = 0
    local panel = {}
    panel.content = content
    panel.next = function()
        orderCounter = orderCounter + 1
        return orderCounter
    end
    return panel
end

local function addCheckbox(panel, cfg)
    local row = new("TextButton", {
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        LayoutOrder = panel.next(),
        Size = UDim2.new(1, 0, 0, 15),
        Parent = panel.content,
    })
    local box = nil
    if cfg.box ~= false then
        box = new("Frame", {
            BackgroundColor3 = cfg.enabled and palette.accent or palette.boxOff,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 1, 0, 2),
            Size = UDim2.new(0, 11, 0, 11),
            ZIndex = 2,
            Parent = row,
        })
    end
    local label = new("TextLabel", {
        BackgroundTransparency = 1,
        Font = FONT,
        Text = cfg.label,
        TextColor3 = cfg.yellow and palette.yellow or (cfg.dim and palette.dim or palette.text),
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Position = UDim2.new(0, 24, 0, 0),
        Size = UDim2.new(1, -74, 1, 0),
        Parent = row,
    })
    local state = cfg.enabled or false
    if cfg.bind then
        local bind = new("TextButton", {
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            Font = FONT,
            Text = "[" .. cfg.bind .. "]",
            TextColor3 = palette.bind,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Right,
            Position = UDim2.new(1, -50, 0, 0),
            Size = UDim2.new(0, 50, 1, 0),
            ZIndex = 2,
            Parent = row,
        })
        bind.MouseEnter:Connect(function()
            tween(bind, 0.12, { TextColor3 = palette.dim })
        end)
        bind.MouseLeave:Connect(function()
            tween(bind, 0.12, { TextColor3 = palette.bind })
        end)
        bind.MouseButton1Click:Connect(function()
            startCapture(bind, "[" .. cfg.bind .. "]")
        end)
    end
    row.MouseEnter:Connect(function()
        if not cfg.dim then
            tween(label, 0.12, { TextColor3 = palette.header })
        end
    end)
    row.MouseLeave:Connect(function()
        tween(label, 0.12, { TextColor3 = cfg.yellow and palette.yellow or (cfg.dim and palette.dim or palette.text) })
    end)
    row.MouseButton1Click:Connect(function()
        if not box then
            return
        end
        state = not state
        tween(box, 0.15, { BackgroundColor3 = state and palette.accent or palette.boxOff })
    end)
    return row
end

local function addDropdown(panel, cfg)
    local hasLabel = cfg.label ~= nil
    local holderFrame = new("Frame", {
        BackgroundTransparency = 1,
        LayoutOrder = panel.next(),
        Size = UDim2.new(1, 0, 0, hasLabel and 40 or 23),
        Parent = panel.content,
    })
    if hasLabel then
        new("TextLabel", {
            BackgroundTransparency = 1,
            Font = FONT,
            Text = cfg.label,
            TextColor3 = palette.text,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Size = UDim2.new(1, 0, 0, 14),
            Parent = holderFrame,
        })
    end
    local button = new("TextButton", {
        AutoButtonColor = false,
        BackgroundColor3 = palette.control,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, hasLabel and 17 or 0),
        Size = UDim2.new(1, 0, 0, 23),
        Parent = holderFrame,
    })
    new("UIStroke", { Color = palette.controlBorder, Thickness = 1, Parent = button })
    local value = new("TextLabel", {
        BackgroundTransparency = 1,
        Font = FONT,
        Text = cfg.current,
        TextColor3 = palette.textMid,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Position = UDim2.new(0, 9, 0, 0),
        Size = UDim2.new(1, -30, 1, 0),
        Parent = button,
    })
    new("TextLabel", {
        BackgroundTransparency = 1,
        Font = FONT,
        Text = "v",
        TextColor3 = palette.dim,
        TextSize = 10,
        Position = UDim2.new(1, -18, 0, 0),
        Size = UDim2.new(0, 12, 1, 0),
        Parent = button,
    })
    local list = new("Frame", {
        BackgroundColor3 = palette.listBg,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Position = UDim2.new(0, 0, 1, 2),
        Size = UDim2.new(1, 0, 0, 0),
        Visible = false,
        ZIndex = 40,
        Parent = button,
    })
    new("UIStroke", { Color = palette.panelBorder, Thickness = 1, Parent = list })
    new("UIListLayout", {
        Padding = UDim.new(0, 0),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = list,
    })
    local fullHeight = #cfg.options * 19
    for i, option in ipairs(cfg.options) do
        local optBtn = new("TextButton", {
            AutoButtonColor = false,
            BackgroundColor3 = palette.listBg,
            BorderSizePixel = 0,
            Font = FONT,
            LayoutOrder = i,
            Text = option,
            TextColor3 = palette.text,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Size = UDim2.new(1, 0, 0, 19),
            ZIndex = 41,
            Parent = list,
        })
        new("UIPadding", { PaddingLeft = UDim.new(0, 9), Parent = optBtn })
        optBtn.MouseEnter:Connect(function()
            tween(optBtn, 0.1, { BackgroundColor3 = palette.listHover })
        end)
        optBtn.MouseLeave:Connect(function()
            tween(optBtn, 0.1, { BackgroundColor3 = palette.listBg })
        end)
        optBtn.MouseButton1Click:Connect(function()
            value.Text = option
            dd.close()
        end)
    end
    local dd = {}
    dd.button = button
    dd.list = list
    dd.isOpen = false
    function dd.close()
        dd.isOpen = false
        if openDropdown == dd then
            openDropdown = nil
        end
        local tw = tween(list, 0.16, { Size = UDim2.new(1, 0, 0, 0) }, Enum.EasingStyle.Quint)
        tw.Completed:Connect(function()
            if not dd.isOpen then
                list.Visible = false
            end
        end)
    end
    function dd.open()
        if openDropdown and openDropdown ~= dd then
            openDropdown.close()
        end
        openDropdown = dd
        dd.isOpen = true
        local viewport = workspace.Camera.ViewportSize
        local bottom = button.AbsolutePosition.Y + button.AbsoluteSize.Y
        if bottom + fullHeight + 6 > viewport.Y then
            list.Position = UDim2.new(0, 0, 0, -fullHeight - 4)
        else
            list.Position = UDim2.new(0, 0, 1, 2)
        end
        list.Visible = true
        tween(list, 0.18, { Size = UDim2.new(1, 0, 0, fullHeight) }, Enum.EasingStyle.Quint)
    end
    button.MouseButton1Click:Connect(function()
        if dd.isOpen then
            dd.close()
        else
            dd.open()
        end
    end)
    table.insert(dropdowns, dd)
    return dd
end

local function addSlider(panel, cfg)
    local holderFrame = new("Frame", {
        BackgroundTransparency = 1,
        LayoutOrder = panel.next(),
        Size = UDim2.new(1, 0, 0, 32),
        Parent = panel.content,
    })
    new("TextLabel", {
        BackgroundTransparency = 1,
        Font = FONT,
        Text = cfg.label,
        TextColor3 = palette.text,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(1, 0, 0, 14),
        Parent = holderFrame,
    })
    local track = new("Frame", {
        BackgroundColor3 = palette.track,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 19),
        Size = UDim2.new(1, 0, 0, 5),
        Parent = holderFrame,
    })
    local fill = new("Frame", {
        BackgroundColor3 = palette.accent,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 0, 1, 0),
        Parent = track,
    })
    local valueLabel = new("TextLabel", {
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundTransparency = 1,
        Font = FONT,
        TextColor3 = palette.header,
        TextSize = 12,
        Position = UDim2.new(0, 0, 1, 4),
        Size = UDim2.new(0, 60, 0, 14),
        Parent = track,
    })
    local grab = new("TextButton", {
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, -6),
        Size = UDim2.new(1, 0, 1, 12),
        Parent = track,
    })
    local value = cfg.value
    local function render()
        local frac = (value - cfg.min) / (cfg.max - cfg.min)
        frac = math.clamp(frac, 0, 1)
        fill.Size = UDim2.new(frac, 0, 1, 0)
        local labelFrac = math.clamp(frac, 0.04, 0.96)
        valueLabel.Position = UDim2.new(labelFrac, 0, 1, 4)
        valueLabel.Text = tostring(math.floor(value + 0.5)) .. (cfg.suffix or "")
    end
    local function setFromMouse(mouseX)
        local trackPos = track.AbsolutePosition.X
        local trackWidth = track.AbsoluteSize.X
        local frac = math.clamp((mouseX - trackPos) / trackWidth, 0, 1)
        value = cfg.min + (cfg.max - cfg.min) * frac
        render()
    end
    local dragConn = nil
    grab.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            setFromMouse(input.Position.X)
            dragConn = runService.RenderStepped:Connect(function()
                local location = userInput:GetMouseLocation()
                setFromMouse(location.X)
            end)
        end
    end)
    grab.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dragConn then
            dragConn:Disconnect()
            dragConn = nil
        end
    end)
    render()
    return holderFrame
end

local function addWeaponRow(panel)
    local row = new("TextButton", {
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        LayoutOrder = panel.next(),
        Size = UDim2.new(1, 0, 0, 30),
        Parent = panel.content,
    })
    local box = new("Frame", {
        BackgroundColor3 = palette.accent,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 1, 0, 9),
        Size = UDim2.new(0, 11, 0, 11),
        ZIndex = 2,
        Parent = row,
    })
    local label = new("TextLabel", {
        BackgroundTransparency = 1,
        Font = FONT,
        Text = "Global",
        TextColor3 = palette.header,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Position = UDim2.new(0, 24, 0, 0),
        Size = UDim2.new(1, -90, 1, 0),
        Parent = row,
    })
    local gunHolder, gunPixels = drawPixels(icons.gun, 1, row, { ["#"] = palette.textMid })
    gunHolder.Position = UDim2.new(1, -46, 0.5, -4)
    new("TextLabel", {
        BackgroundTransparency = 1,
        Font = FONT,
        Text = "v",
        TextColor3 = palette.dim,
        TextSize = 10,
        Position = UDim2.new(1, -18, 0, 0),
        Size = UDim2.new(0, 12, 1, 0),
        Parent = row,
    })
    local state = true
    local list = new("Frame", {
        BackgroundColor3 = palette.listBg,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Position = UDim2.new(0, 0, 1, 2),
        Size = UDim2.new(1, 0, 0, 0),
        Visible = false,
        ZIndex = 40,
        Parent = row,
    })
    new("UIStroke", { Color = palette.panelBorder, Thickness = 1, Parent = list })
    new("UIListLayout", { Padding = UDim.new(0, 0), SortOrder = Enum.SortOrder.LayoutOrder, Parent = list })
    local options = { "Global", "Pistols", "Rifles", "SMG", "Sniper", "Heavy" }
    local fullHeight = #options * 19
    for i, option in ipairs(options) do
        local optBtn = new("TextButton", {
            AutoButtonColor = false,
            BackgroundColor3 = palette.listBg,
            BorderSizePixel = 0,
            Font = FONT,
            LayoutOrder = i,
            Text = option,
            TextColor3 = palette.text,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Size = UDim2.new(1, 0, 0, 19),
            ZIndex = 41,
            Parent = list,
        })
        new("UIPadding", { PaddingLeft = UDim.new(0, 9), Parent = optBtn })
        optBtn.MouseEnter:Connect(function()
            tween(optBtn, 0.1, { BackgroundColor3 = palette.listHover })
        end)
        optBtn.MouseLeave:Connect(function()
            tween(optBtn, 0.1, { BackgroundColor3 = palette.listBg })
        end)
        optBtn.MouseButton1Click:Connect(function()
            label.Text = option
            dd.close()
        end)
    end
    local dd = {}
    dd.button = row
    dd.list = list
    dd.isOpen = false
    function dd.close()
        dd.isOpen = false
        if openDropdown == dd then
            openDropdown = nil
        end
        local tw = tween(list, 0.16, { Size = UDim2.new(1, 0, 0, 0) }, Enum.EasingStyle.Quint)
        tw.Completed:Connect(function()
            if not dd.isOpen then
                list.Visible = false
            end
        end)
    end
    function dd.open()
        if openDropdown and openDropdown ~= dd then
            openDropdown.close()
        end
        openDropdown = dd
        dd.isOpen = true
        list.Position = UDim2.new(0, 0, 1, 2)
        list.Visible = true
        tween(list, 0.18, { Size = UDim2.new(1, 0, 0, fullHeight) }, Enum.EasingStyle.Quint)
    end
    row.MouseButton1Click:Connect(function()
        if dd.isOpen then
            dd.close()
        else
            dd.open()
        end
    end)
    box.InputBegan:Connect(function()
    end)
    table.insert(dropdowns, dd)
    return row
end

local pageAimbot = new("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Parent = pagesArea })
local pageAntiAim = new("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Parent = pagesArea, Visible = false })
local pageEmpty = {}
for i = 1, 6 do
    pageEmpty[i] = new("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Parent = pagesArea, Visible = false })
end
pages = { pageAimbot, pageAntiAim, pageEmpty[1], pageEmpty[2], pageEmpty[3], pageEmpty[4], pageEmpty[5], pageEmpty[6] }

do
    local left = createColumn(pageAimbot, 30)
    local right = createColumn(pageAimbot, 386)
    local weaponPanel = createPanel(left, "Weapon type", 62, 1)
    addWeaponRow(weaponPanel)
    local aimPanel = createPanel(left, "Aimbot", 614, 2)
    addCheckbox(aimPanel, { label = "Enabled", bind = "M5" })
    addDropdown(aimPanel, { label = "Target selection", current = "Cycle", options = { "Cycle", "Best hitbox", "Highest damage", "Closest to crosshair" } })
    addDropdown(aimPanel, { label = "Target hitbox", current = "Head", options = { "Head", "Neck", "Chest", "Stomach", "Pelvis" } })
    addDropdown(aimPanel, { label = "Multi-point", current = "-", bind = "-", options = { "-", "Head", "Chest", "Stomach" } })
    addSlider(aimPanel, { label = "Minimum hit chance", min = 0, max = 100, value = 50, suffix = "%" })
    addSlider(aimPanel, { label = "Minimum damage", min = 0, max = 100, value = 10 })
    addCheckbox(aimPanel, { label = "Minimum damage override", bind = "-" })
    addCheckbox(aimPanel, { label = "Prefer safe point" })
    addCheckbox(aimPanel, { label = "Force safe point", bind = "-", box = false, dim = true })
    addDropdown(aimPanel, { label = "Avoid unsafe hitboxes", current = "-", options = { "-", "Head", "Chest", "Stomach", "Legs" } })
    addCheckbox(aimPanel, { label = "Force body aim", bind = "-", box = false, dim = true })
    addCheckbox(aimPanel, { label = "Force body aim on peek" })
    addCheckbox(aimPanel, { label = "Quick stop", bind = "-" })
    addCheckbox(aimPanel, { label = "Double tap", bind = "-", yellow = true })
    addCheckbox(aimPanel, { label = "Automatic scope" })
    local otherPanel = createPanel(right, "Other", 694, 1)
    addDropdown(otherPanel, { label = "Accuracy boost", current = "Low", options = { "Off", "Low", "Medium", "High" } })
    addCheckbox(otherPanel, { label = "Anti-aim correction" })
    addCheckbox(otherPanel, { label = "Automatic fire" })
    addCheckbox(otherPanel, { label = "Automatic penetration" })
    addCheckbox(otherPanel, { label = "Silent aim" })
    addCheckbox(otherPanel, { label = "Remove recoil" })
    addCheckbox(otherPanel, { label = "Delay shot" })
    addCheckbox(otherPanel, { label = "Quick peek assist", bind = "-" })
    addCheckbox(otherPanel, { label = "Duck peek assist", bind = "-", box = false, dim = true })
    addCheckbox(otherPanel, { label = "Reduce aim step" })
    addSlider(otherPanel, { label = "Maximum FOV", min = 0, max = 180, value = 180, suffix = "°" })
    addCheckbox(otherPanel, { label = "Log misses due to spread", enabled = true })
    addDropdown(otherPanel, { label = "Low FPS mitigations", current = "-", options = { "-", "Off", "On" } })
end

do
    local left = createColumn(pageAntiAim, 30)
    local right = createColumn(pageAntiAim, 386)
    local anglesPanel = createPanel(left, "Anti-aimbot angles", 694, 1)
    addCheckbox(anglesPanel, { label = "Enabled" })
    addDropdown(anglesPanel, { label = "Pitch", current = "Off", options = { "Off", "Down", "Up", "Zero" } })
    addDropdown(anglesPanel, { label = "Yaw base", current = "Local view", options = { "Local view", "At target", "Direction" } })
    addDropdown(anglesPanel, { label = "Yaw", current = "Off", options = { "Off", "Left", "Right", "Center", "Spin" } })
    addDropdown(anglesPanel, { label = "Body yaw", current = "Off", options = { "Off", "Opposite", "Jitter" } })
    addCheckbox(anglesPanel, { label = "Edge yaw" })
    addCheckbox(anglesPanel, { label = "Freestanding", bind = "-" })
    addSlider(anglesPanel, { label = "Roll", min = -50, max = 50, value = 0, suffix = "°" })
    local lagPanel = createPanel(right, "Fake lag", 330, 1)
    addCheckbox(lagPanel, { label = "Enabled", bind = "-" })
    addDropdown(lagPanel, { label = "Amount", current = "Dynamic", options = { "Dynamic", "Maximum", "Fluctuate", "Slider" } })
    addSlider(lagPanel, { label = "Variance", min = 0, max = 100, value = 0, suffix = "%" })
    addSlider(lagPanel, { label = "Limit", min = 0, max = 16, value = 13 })
    local otherPanel = createPanel(right, "Other", 346, 2)
    addCheckbox(otherPanel, { label = "Slow motion", bind = "CAP" })
    addDropdown(otherPanel, { label = "Leg movement", current = "Off", options = { "Off", "Always", "On move" } })
    addCheckbox(otherPanel, { label = "On shot anti-aim", bind = "-", yellow = true })
    addCheckbox(otherPanel, { label = "Fake peek", bind = "X", yellow = true })
end

local tabIcons = { icons.head, icons.antiaim, icons.crosshair, icons.visuals, icons.misc, icons.skins, icons.players, icons.configs }

for i, iconMap in ipairs(tabIcons) do
    local cell = new("TextButton", {
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, (i - 1) * 78),
        Size = UDim2.new(1, 0, 0, 78),
        ZIndex = 3,
        Parent = sidebar,
    })
    local highlight = new("Frame", {
        BackgroundColor3 = palette.tabActive,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, -1),
        BackgroundTransparency = 1,
        ZIndex = 2,
        Parent = cell,
    })
    local separator = new("Frame", {
        BackgroundColor3 = Color3.fromRGB(31, 31, 31),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 8, 1, -1),
        Size = UDim2.new(1, -16, 0, 1),
        ZIndex = 3,
        Parent = cell,
    })
    local iconHolder, pixels = drawPixels(iconMap, 2, cell, { ["#"] = palette.icon })
    iconHolder.AnchorPoint = Vector2.new(0.5, 0.5)
    iconHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
    cell.MouseEnter:Connect(function()
        if currentTab ~= i then
            highlight.BackgroundTransparency = 0
            highlight.BackgroundColor3 = palette.tabHover
        end
    end)
    cell.MouseLeave:Connect(function()
        if currentTab ~= i then
            highlight.BackgroundTransparency = 1
        else
            highlight.BackgroundColor3 = palette.tabActive
        end
    end)
    cell.MouseButton1Click:Connect(function()
        selectTab(i)
    end)
    tabButtons[i] = cell
    tabHighlights[i] = highlight
    tabPixels[i] = pixels
end

local cursorFrame, cursorPixels = drawPixels(icons.cursor, 1, gui, { ["#"] = palette.white, ["o"] = palette.black })
cursorFrame.ZIndex = 100
cursorFrame.Visible = false

runService.RenderStepped:Connect(function()
    if cursorFrame.Visible then
        local location = userInput:GetMouseLocation()
        cursorFrame.Position = UDim2.new(0, location.X, 0, location.Y)
    end
end)

local openTween = nil

local function setMenu(open)
    menuOpen = open
    if openTween then
        openTween:Cancel()
    end
    if open then
        root.Visible = true
        cursorFrame.Visible = true
        userInput.MouseIconEnabled = false
        openTween = tween(root, 0.35, { Size = UDim2.new(0, WIDTH, 0, HEIGHT) }, Enum.EasingStyle.Quint)
    else
        cursorFrame.Visible = false
        userInput.MouseIconEnabled = true
        local tw = tween(root, 0.25, { Size = UDim2.new(0, WIDTH, 0, 0) }, Enum.EasingStyle.Quint)
        tw.Completed:Connect(function()
            if not menuOpen then
                root.Visible = false
            end
        end)
        openTween = tw
    end
end

local function applyScale()
    local viewport = workspace.Camera.ViewportSize
    local scale = math.min(1, (viewport.Y - 30) / HEIGHT, (viewport.X - 30) / WIDTH)
    scaler.Scale = math.max(0.4, scale)
end
applyScale()
workspace.Camera:GetPropertyChangedSignal("ViewportSize"):Connect(applyScale)

local function showBootNotification(callback)
    local plate = new("Frame", {
        BackgroundColor3 = Color3.fromRGB(16, 16, 16),
        BorderSizePixel = 0,
        Position = UDim2.new(1, 20, 1, -64),
        Size = UDim2.new(0, 250, 0, 52),
        ZIndex = 60,
        Parent = gui,
    })
    new("UIStroke", { Color = Color3.fromRGB(46, 46, 46), Thickness = 1, Parent = plate })
    new("TextLabel", {
        BackgroundTransparency = 1,
        Font = FONT,
        Text = "gamesense injected",
        TextColor3 = palette.header,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Position = UDim2.new(0, 14, 0.5, -8),
        Size = UDim2.new(1, -28, 0, 16),
        ZIndex = 61,
        Parent = plate,
    })
    local bar = new("Frame", {
        BackgroundColor3 = palette.accent,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, -3),
        Size = UDim2.new(1, 0, 0, 3),
        ZIndex = 61,
        Parent = plate,
    })
    tween(plate, 0.4, { Position = UDim2.new(1, -262, 1, -64) }, Enum.EasingStyle.Quint)
    task.wait(0.55)
    tween(bar, 3, { Size = UDim2.new(0, 0, 0, 3) }, Enum.EasingStyle.Linear)
    task.wait(3.05)
    local out = tween(plate, 0.35, { Position = UDim2.new(1, 20, 1, -64) }, Enum.EasingStyle.Quart)
    out.Completed:Connect(function()
        plate:Destroy()
        if callback then
            callback()
        end
    end)
end

userInput.InputBegan:Connect(function(input, processed)
    if capturing then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == Enum.KeyCode.Escape then
                capturing.button.Text = capturing.previous
            else
                capturing.button.Text = "[" .. input.KeyCode.Name .. "]"
            end
        elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
            capturing.button.Text = "[M1]"
        elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
            capturing.button.Text = "[M2]"
        elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
            capturing.button.Text = "[M3]"
        end
        capturing = nil
        return
    end
    if processed then
        return
    end
    if input.KeyCode == Enum.KeyCode.P then
        setMenu(not menuOpen)
        return
    end
    if input.UserInputType == Enum.UserInputType.MouseButton1 and openDropdown then
        local location = userInput:GetMouseLocation()
        local dd = openDropdown
        if not rectContains(dd.button, location) and not rectContains(dd.list, location) then
            dd.close()
        end
    end
end)

selectTab(1)

showBootNotification(function()
    setMenu(true)
end)
