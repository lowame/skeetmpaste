local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

print("[gs] start")

local Accent = Color3.fromRGB(88, 159, 255)
local Background = Color3.fromRGB(28, 28, 32)
local Header = Color3.fromRGB(38, 38, 44)
local Section = Color3.fromRGB(35, 35, 40)
local SectionBody = Color3.fromRGB(32, 32, 36)
local TabBg = Color3.fromRGB(25, 25, 28)
local Text = Color3.fromRGB(235, 235, 235)
local TextDim = Color3.fromRGB(140, 140, 145)

local gui = Instance.new("ScreenGui")
gui.Name = "gs_ui"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999999

local ok, err

ok, err = pcall(function()
	if gethui then
		gui.Parent = gethui()
	end
end)
if not gui.Parent then
	ok, err = pcall(function()
		gui.Parent = game:GetService("CoreGui")
	end)
end
if not gui.Parent then
	gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end
print("[gs] gui parent:", tostring(gui.Parent))

local function make(class, props, parent)
	local o = Instance.new(class)
	for k, v in pairs(props) do
		o[k] = v
	end
	o.Parent = parent
	return o
end

local function corner(o, r)
	make("UICorner", { CornerRadius = UDim.new(0, r or 3) }, o)
end

local function stroke(o, c, th)
	return make("UIStroke", { Color = c or Color3.fromRGB(55, 55, 62), Thickness = th or 1 }, o)
end

local function label(text, size, pos, parent, col, align)
	return make("TextLabel", {
		BackgroundTransparency = 1,
		Position = pos,
		Size = size,
		Font = Enum.Font.Gotham,
		Text = text,
		TextColor3 = col or Text,
		TextSize = 13,
		TextXAlignment = align or Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
	}, parent)
end

local menu = make("CanvasGroup", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.5, 0),
	Size = UDim2.new(0, 740, 0, 480),
	BackgroundColor3 = Background,
	Visible = false,
	GroupTransparency = 0,
	Parent = gui,
})
corner(menu, 4)

local topbar = make("Frame", {
	Size = UDim2.new(1, 0, 0, 34),
	BackgroundColor3 = Header,
	Parent = menu,
})
corner(topbar, 4)
make("Frame", { Size = UDim2.new(1, 0, 0, 4), Position = UDim2.new(0, 0, 0, 30), BackgroundColor3 = Background, BorderSizePixel = 0, Parent = topbar })

label("gamesense", UDim2.new(0, 0, 1, 0), UDim2.new(0, 12, 0, 0), topbar, Text)
local userLbl = label("user", UDim2.new(0, 0, 1, 0), UDim2.new(1, -12, 0, 0), topbar, Accent, Enum.TextXAlignment.Right)

local tabHolder = make("Frame", {
	Position = UDim2.new(0, 0, 0, 34),
	Size = UDim2.new(0, 110, 1, -34),
	BackgroundColor3 = TabBg,
	Parent = menu,
})
make("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }, tabHolder)
make("UIPadding", { PaddingTop = UDim.new(0, 8) }, tabHolder)

local content = make("Frame", {
	Position = UDim2.new(0, 110, 0, 34),
	Size = UDim2.new(1, -110, 1, -34),
	BackgroundTransparency = 1,
	Parent = menu,
})

local tabs = {}

local function createTab(name)
	local btn = make("TextButton", {
		Size = UDim2.new(1, -12, 0, 26),
		BackgroundTransparency = 1,
		Font = Enum.Font.Gotham,
		Text = name,
		TextColor3 = TextDim,
		TextSize = 13,
		Parent = tabHolder,
	})
	local bar = make("Frame", { Size = UDim2.new(0, 2, 0, 0), BackgroundColor3 = Accent, BorderSizePixel = 0, Parent = btn })
	local page = make("Frame", {
		Size = UDim2.new(1, -16, 1, -16),
		Position = UDim2.new(0, 8, 0, 8),
		BackgroundTransparency = 1,
		Visible = false,
		Parent = content,
	})
	tabs[#tabs + 1] = { btn = btn, bar = bar, page = page, name = name }
	return page
end

local function selectTab(name)
	for _, t in ipairs(tabs) do
		local on = t.name == name
		t.page.Visible = on
		TweenService:Create(t.bar, TweenInfo.new(0.2), { Size = on and UDim2.new(0, 2, 1, 0) or UDim2.new(0, 2, 0, 0) }):Play()
		TweenService:Create(t.btn, TweenInfo.new(0.2), { TextColor3 = on and Text or TextDim }):Play()
	end
end

local function createColumn(parent, order)
	local col = make("Frame", {
		Size = UDim2.new(0.5, -6, 1, 0),
		BackgroundTransparency = 1,
		LayoutOrder = order,
		Parent = parent,
	})
	make("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, col)
	return col
end

local function createSection(col, title)
	local sec = make("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundColor3 = Section,
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = col,
	})
	corner(sec, 3)
	stroke(sec)
	label(title:upper(), UDim2.new(1, -12, 0, 24), UDim2.new(0, 10, 0, 2), sec, Text)
	local body = make("Frame", {
		Position = UDim2.new(0, 6, 0, 28),
		Size = UDim2.new(1, -12, 0, 0),
		BackgroundColor3 = SectionBody,
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = sec,
	})
	corner(body, 3)
	make("UIPadding", { PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) }, body)
	make("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }, body)
	return body
end

local function checkbox(parent, text)
	local btn = make("TextButton", {
		Size = UDim2.new(1, 0, 0, 18),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		Parent = parent,
	})
	local box = make("Frame", {
		Size = UDim2.new(0, 14, 0, 14),
		Position = UDim2.new(0, 0, 0.5, -7),
		BackgroundColor3 = Color3.fromRGB(45, 45, 50),
		Parent = btn,
	})
	corner(box, 2)
	local mark = make("Frame", { Size = UDim2.new(1, -4, 1, -4), Position = UDim2.new(0, 2, 0, 2), BackgroundColor3 = Accent, Visible = false, Parent = box })
	corner(mark, 2)
	label(text, UDim2.new(1, -20, 1, 0), UDim2.new(0, 22, 0, 0), btn, Text)
	local on = false
	btn.MouseButton1Click:Connect(function()
		on = not on
		mark.Visible = on
		TweenService:Create(box, TweenInfo.new(0.15), { BackgroundColor3 = on and Color3.fromRGB(60, 90, 140) or Color3.fromRGB(45, 45, 50) }):Play()
	end)
end

local function slider(parent, text, min, max)
	local holder = make("Frame", { Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, Parent = parent })
	local lbl = label(text .. "  [" .. tostring(min) .. "]", UDim2.new(1, 0, 0, 14), UDim2.new(0, 0, 0, 0), holder, Text)
	local track = make("Frame", {
		Size = UDim2.new(1, 0, 0, 4),
		Position = UDim2.new(0, 0, 0, 20),
		BackgroundColor3 = Color3.fromRGB(50, 50, 56),
		Parent = holder,
	})
	corner(track, 2)
	local fill = make("Frame", { Size = UDim2.new(0.35, 0, 1, 0), BackgroundColor3 = Accent, Parent = track })
	corner(fill, 2)
	local val = min + (max - min) * 0.35
	local dragging = false
	local function setFromX(x)
		local rel = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
		fill.Size = UDim2.new(rel, 0, 1, 0)
		val = math.floor(min + (max - min) * rel)
		lbl.Text = text .. "  [" .. tostring(val) .. "]"
	end
	track.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			setFromX(i.Position.X)
		end
	end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)
	RunService.RenderStepped:Connect(function()
		if dragging then setFromX(UserInputService:GetMouseLocation().X) end
	end)
end

local function dropdown(parent, text, options)
	local holder = make("Frame", { Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, Parent = parent })
	label(text, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), holder, Text)
	local btn = make("TextButton", {
		Size = UDim2.new(0, 100, 1, 0),
		Position = UDim2.new(1, -100, 0, 0),
		BackgroundColor3 = Color3.fromRGB(45, 45, 50),
		Font = Enum.Font.Gotham,
		Text = options[1],
		TextColor3 = Text,
		TextSize = 12,
		Parent = holder,
	})
	corner(btn, 2)
	local idx = 1
	btn.MouseButton1Click:Connect(function()
		idx = idx % #options + 1
		btn.Text = options[idx]
	end)
end

local function multibox(parent, text, options)
	local holder = make("Frame", { Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, Parent = parent })
	label(text, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), holder, Text)
	local btn = make("TextButton", {
		Size = UDim2.new(0, 100, 1, 0),
		Position = UDim2.new(1, -100, 0, 0),
		BackgroundColor3 = Color3.fromRGB(45, 45, 50),
		Font = Enum.Font.Gotham,
		Text = "select",
		TextColor3 = Text,
		TextSize = 12,
		Parent = holder,
	})
	corner(btn, 2)
	btn.MouseButton1Click:Connect(function()
		local t = {}
		for i = 1, math.min(#options, 2) do t[#t + 1] = options[i] end
		btn.Text = table.concat(t, ", ")
	end)
end

local function colorpicker(parent, text, col)
	col = col or Color3.fromRGB(88, 159, 255)
	local btn = make("TextButton", { Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Parent = parent })
	label(text, UDim2.new(1, -26, 1, 0), UDim2.new(0, 0, 0, 0), btn, Text)
	local sw = make("Frame", { Size = UDim2.new(0, 18, 0, 12), Position = UDim2.new(1, -20, 0.5, -6), BackgroundColor3 = col, Parent = btn })
	corner(sw, 2)
end

local function keybind(parent, text, key)
	local btn = make("TextButton", { Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, Text = "", Parent = parent })
	label(text, UDim2.new(1, -40, 1, 0), UDim2.new(0, 0, 0, 0), btn, Text)
	local kb = make("TextLabel", {
		Size = UDim2.new(0, 36, 0, 14),
		Position = UDim2.new(1, -36, 0.5, -7),
		BackgroundColor3 = Color3.fromRGB(45, 45, 50),
		Font = Enum.Font.Gotham,
		Text = key or "-",
		TextColor3 = TextDim,
		TextSize = 11,
		Parent = btn,
	})
	corner(kb, 2)
end

local splash = make("Frame", {
	AnchorPoint = Vector2.new(1, 1),
	Position = UDim2.new(1, -16, 1, -16),
	Size = UDim2.new(0, 200, 0, 44),
	BackgroundColor3 = Background,
	Parent = gui,
})
corner(splash, 4)
stroke(splash)
label("gamesense injected", UDim2.new(1, -12, 0, 18), UDim2.new(0, 10, 0, 4), splash, Text)
local barBg = make("Frame", {
	Size = UDim2.new(1, -20, 0, 3),
	Position = UDim2.new(0, 10, 1, -9),
	BackgroundColor3 = Color3.fromRGB(50, 50, 56),
	Parent = splash,
})
corner(barBg, 2)
local barFill = make("Frame", { Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = Accent, Parent = barBg })
corner(barFill, 2)

local function hideSplash()
	local t1 = TweenService:Create(splash, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { BackgroundTransparency = 1 })
	for _, c in ipairs(splash:GetDescendants()) do
		if c:IsA("TextLabel") then
			TweenService:Create(c, TweenInfo.new(0.45), { TextTransparency = 1 }):Play()
		elseif c:IsA("Frame") then
			TweenService:Create(c, TweenInfo.new(0.45), { BackgroundTransparency = 1 }):Play()
		elseif c:IsA("UIStroke") then
			TweenService:Create(c, TweenInfo.new(0.45), { Transparency = 1 }):Play()
		end
	end
	t1:Play()
	t1.Completed:Wait()
	splash.Visible = false
	menu.Visible = true
	menu.GroupTransparency = 1
	local t2 = TweenService:Create(menu, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { GroupTransparency = 0 })
	t2:Play()
	print("[gs] menu open, toggle: P")
end

local function build()
	local rage = createTab("RAGE")
	local c1 = createColumn(rage, 1)
	local c2 = createColumn(rage, 2)
	local s1 = createSection(c1, "General")
	keybind(s1, "Enabled", "E")
	dropdown(s1, "Target selection", { "Cycle", "Closest", "Low health" })
	slider(s1, "Target hitchance", 0, 100)
	dropdown(s1, "Multipoint", { "Head", "Chest", "Body" })
	local s2 = createSection(c2, "Accuracy")
	checkbox(s2, "Auto scope")
	checkbox(s2, "Auto stop")
	slider(s2, "Minimum damage", 0, 130)
	dropdown(s2, "Hitscan", { "Default", "Strict", "Safe" })

	local aa = createTab("AA")
	local c3 = createColumn(aa, 1)
	local c4 = createColumn(aa, 2)
	local s3 = createSection(c3, "Anti-aim")
	checkbox(s3, "Enabled")
	keybind(s3, "Invert", "X")
	dropdown(s3, "Pitch", { "Off", "Down", "Up", "Zero" })
	dropdown(s3, "Yaw base", { "At targets", "Local view" })
	dropdown(s3, "Yaw", { "Static", "180", "Jitter", "Random" })
	local s4 = createSection(c4, "Fake angle")
	checkbox(s4, "Enabled")
	slider(s4, "Fake limit", 0, 60)
	checkbox(s4, "Avoid opposite")
	dropdown(s4, "Lby mode", { "Off", "Opposite", "Sync" })

	local visuals = createTab("VISUALS")
	local c5 = createColumn(visuals, 1)
	local c6 = createColumn(visuals, 2)
	local s5 = createSection(c5, "Players")
	checkbox(s5, "Enabled")
	checkbox(s5, "Bounding box")
	checkbox(s5, "Health bar")
	checkbox(s5, "Name")
	checkbox(s5, "Weapon")
	checkbox(s5, "Skeleton")
	colorpicker(s5, "Color", Color3.fromRGB(120, 190, 255))
	local s6 = createSection(c6, "World")
	checkbox(s6, "Removals")
	multibox(s6, "Removals", { "smoke", "flash", "scope", "sky" })
	checkbox(s6, "Nightmode")
	slider(s6, "Field of view", 90, 130)
	checkbox(s6, "Thirdperson")
	keybind(s6, "Toggle", "V")

	local misc = createTab("MISC")
	local c7 = createColumn(misc, 1)
	local c8 = createColumn(misc, 2)
	local s7 = createSection(c7, "Movement")
	checkbox(s7, "Auto strafe")
	checkbox(s7, "Bunny hop")
	checkbox(s7, "Edge jump")
	local s8 = createSection(c8, "Other")
	checkbox(s8, "Auto accept")
	checkbox(s8, "Watermark")
	dropdown(s8, "Menu color", { "Default", "Pastel", "Mono" })
	slider(s8, "Menu opacity", 0, 100)

	local skins = createTab("SKINS")
	local c9 = createColumn(skins, 1)
	local s9 = createSection(c9, "Weapon")
	dropdown(s9, "Knife", { "Default", "Karambit", "Butterfly", "M9 Bayonet" })
	dropdown(s9, "Glove", { "Default", "Sport", "Specialist" })
	checkbox(s9, "Auto apply")

	createTab("CONFIG")
	createTab("LUA")

	selectTab("RAGE")
end

ok, err = pcall(build)
if not ok then
	print("[gs] build error:", err)
	splash.Visible = false
	menu.Visible = true
	return
end

userLbl.Text = LocalPlayer and (LocalPlayer.DisplayName or LocalPlayer.Name) or "user"

TweenService:Create(barFill, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Size = UDim2.new(1, 0, 1, 0) }):Play()
task.delay(3, function()
	local o, e = pcall(hideSplash)
	if not o then
		print("[gs] splash error:", e)
		splash.Visible = false
		menu.Visible = true
	end
end)

local open = true
UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.KeyCode == Enum.KeyCode.P then
		open = not open
		menu.Visible = open
	end
end)

local dragging = false
local dragInput, dragStart, startPos
topbar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = menu.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)
topbar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		menu.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

print("[gs] loaded ok")
