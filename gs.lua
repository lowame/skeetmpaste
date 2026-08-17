local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

local Accent = Color3.fromRGB(96, 162, 255)
local WindowBg = Color3.fromRGB(26, 26, 26)
local GroupBg = Color3.fromRGB(34, 34, 34)
local GroupBorder = Color3.fromRGB(14, 14, 14)
local BoxBg = Color3.fromRGB(22, 22, 22)
local BoxBorder = Color3.fromRGB(48, 48, 48)
local TrackBg = Color3.fromRGB(16, 16, 16)
local Line = Color3.fromRGB(12, 12, 12)
local TextBright = Color3.fromRGB(228, 228, 228)
local TextDim = Color3.fromRGB(150, 150, 150)
local TextFaint = Color3.fromRGB(104, 104, 104)
local Font = Enum.Font.Code
local MenuW, MenuH = 740, 446

local gui = Instance.new("ScreenGui")
gui.Name = "gs_ui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local function tryParent(target)
	return pcall(function()
		local old = target:FindFirstChild("gs_ui")
		if old then
			old:Destroy()
		end
		gui.Parent = target
	end) and gui.Parent == target
end

local placed = false
if gethui then
	placed = tryParent(gethui())
end
if not placed then
	placed = tryParent(game:GetService("CoreGui"))
end
if not placed then
	tryParent(LocalPlayer:WaitForChild("PlayerGui"))
end

local function make(class, props, parent)
	local o = Instance.new(class)
	for k, v in pairs(props) do
		o[k] = v
	end
	o.Parent = parent
	return o
end

local function textLabel(parent, props)
	local t = {
		BackgroundTransparency = 1,
		Font = Font,
		Text = "",
		TextColor3 = TextDim,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
	}
	for k, v in pairs(props) do
		t[k] = v
	end
	return make("TextLabel", t, parent)
end

local function stroke(o, color, thickness)
	return make("UIStroke", { Color = color, Thickness = thickness or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, o)
end

local library = { elements = {}, tab = nil }
local menuReady = false
local menuOpen = false
local activeDrag = nil
local listeningBind = nil
local popupScrim = nil
local activeList = nil
local activePicker = nil

local function closePopups()
	if popupScrim then
		popupScrim:Destroy()
		popupScrim = nil
	end
	if activeList then
		activeList.frame:Destroy()
		activeList = nil
	end
	if activePicker then
		activePicker.frame:Destroy()
		activePicker = nil
	end
end

local menu = make("CanvasGroup", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.5, 0),
	Size = UDim2.new(0, MenuW, 0, MenuH),
	BackgroundColor3 = WindowBg,
	BorderSizePixel = 0,
	Visible = false,
	GroupTransparency = 0,
}, gui)
stroke(menu, Color3.fromRGB(0, 0, 0), 1)

local function openScrim()
	popupScrim = make("TextButton", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "",
		ZIndex = 40,
		AutoButtonColor = false,
	}, menu)
	popupScrim.MouseButton1Click:Connect(closePopups)
end

local function setOpen(v)
	if v == menuOpen or not menuReady then
		return
	end
	menuOpen = v
	if v then
		menu.Visible = true
		menu.GroupTransparency = 1
		TweenService:Create(menu, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { GroupTransparency = 0 }):Play()
	else
		closePopups()
		local tw = TweenService:Create(menu, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { GroupTransparency = 1 })
		tw.Completed:Connect(function()
			if not menuOpen then
				menu.Visible = false
			end
		end)
		tw:Play()
	end
end

local topbar = make("Frame", { Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1 }, menu)
make("Frame", { Position = UDim2.new(0, 0, 1, -1), Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = Line, BorderSizePixel = 0 }, topbar)

local tabRow = make("Frame", { Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -44, 1, 0), BackgroundTransparency = 1 }, topbar)
make("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 16), SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Center }, tabRow)

local closeBtn = make("TextButton", {
	Position = UDim2.new(1, -22, 0, 0),
	Size = UDim2.new(0, 22, 1, 0),
	BackgroundTransparency = 1,
	AutoButtonColor = false,
	Font = Font,
	Text = "x",
	TextColor3 = TextFaint,
	TextSize = 13,
}, topbar)
closeBtn.MouseEnter:Connect(function() closeBtn.TextColor3 = Color3.fromRGB(235, 90, 90) end)
closeBtn.MouseLeave:Connect(function() closeBtn.TextColor3 = TextFaint end)
closeBtn.MouseButton1Click:Connect(function() setOpen(false) end)

local footer = make("Frame", { Position = UDim2.new(0, 0, 1, -34), Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1 }, menu)
make("Frame", { Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = Line, BorderSizePixel = 0 }, footer)
local leftInfo = make("Frame", { Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(0.6, 0, 1, 0), BackgroundTransparency = 1 }, footer)
make("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Center }, leftInfo)

local avatar = make("Frame", { Size = UDim2.new(0, 22, 0, 22), BackgroundColor3 = BoxBg, BorderSizePixel = 0, LayoutOrder = 1 }, leftInfo)
stroke(avatar, BoxBorder, 1)
local avatarImg = make("ImageLabel", { Position = UDim2.new(0, 2, 0, 2), Size = UDim2.new(1, -4, 1, -4), BackgroundTransparency = 1, Image = "" }, avatar)
pcall(function()
	avatarImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "/w=48/h=48"
end)
textLabel(leftInfo, { AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 0, 14), Text = LocalPlayer.Name, TextColor3 = TextBright, TextSize = 12, LayoutOrder = 2 })
textLabel(leftInfo, { AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 0, 14), Text = "uid: " .. LocalPlayer.UserId, TextColor3 = TextFaint, TextSize = 12, LayoutOrder = 3 })
textLabel(footer, { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 0, 14), Text = "gamesense.pub", TextColor3 = TextFaint, TextSize = 12 })

local content = make("Frame", { Position = UDim2.new(0, 0, 0, 29), Size = UDim2.new(1, 0, 1, -63), BackgroundTransparency = 1 }, menu)

local function addCheckbox(parent, name, default)
	local state = default and true or false
	local row = make("Frame", { Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1 }, parent)
	local btn = make("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", AutoButtonColor = false }, row)
	local box = make("Frame", { Position = UDim2.new(0, 1, 0.5, -6), Size = UDim2.new(0, 13, 0, 13), BackgroundColor3 = BoxBg, BorderSizePixel = 0 }, btn)
	stroke(box, BoxBorder, 1)
	local fill = make("Frame", { Position = UDim2.new(0, 3, 0, 3), Size = UDim2.new(1, -6, 1, -6), BackgroundColor3 = Accent, BorderSizePixel = 0, Visible = state }, box)
	local txt = textLabel(btn, { Position = UDim2.new(0, 22, 0, 0), Size = UDim2.new(1, -22, 1, 0), Text = name, TextColor3 = state and TextBright or TextDim })
	local rec = { type = "check", name = name, get = function() return state end }
	function rec.set(v)
		state = v and true or false
		fill.Visible = state
		txt.TextColor3 = state and TextBright or TextDim
	end
	btn.MouseEnter:Connect(function() txt.TextColor3 = TextBright end)
	btn.MouseLeave:Connect(function() txt.TextColor3 = state and TextBright or TextDim end)
	btn.MouseButton1Click:Connect(function() rec.set(not state) end)
	library.elements[#library.elements + 1] = rec
	return rec
end

local function addSlider(parent, name, min, max, default, unit, isFloat)
	unit = unit or ""
	local holder = make("Frame", { Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1 }, parent)
	textLabel(holder, { Size = UDim2.new(1, -52, 0, 13), Text = name })
	local valL = textLabel(holder, { Position = UDim2.new(1, -52, 0, 0), Size = UDim2.new(0, 52, 0, 13), Text = "", TextColor3 = TextBright, TextXAlignment = Enum.TextXAlignment.Right })
	local track = make("Frame", { Position = UDim2.new(0, 2, 0, 19), Size = UDim2.new(1, -4, 0, 4), BackgroundColor3 = TrackBg, BorderSizePixel = 0 }, holder)
	local fill = make("Frame", { Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = Accent, BorderSizePixel = 0 }, track)
	local value = default
	local function fmt(v)
		if isFloat then
			return string.format("%.1f", v)
		end
		return tostring(math.floor(v + 0.5))
	end
	local function apply(v)
		value = math.clamp(v, min, max)
		fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
		valL.Text = fmt(value) .. unit
	end
	local rec = { type = "slider", name = name, get = function() return value end, set = apply }
	apply(default)
	local function fromX(x)
		local rel = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
		apply(min + (max - min) * rel)
	end
	holder.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			fromX(input.Position.X)
			activeDrag = fromX
		end
	end)
	library.elements[#library.elements + 1] = rec
	return rec
end

local function addDropdown(parent, name, options, defaultIndex)
	defaultIndex = defaultIndex or 1
	local row = make("Frame", { Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1 }, parent)
	textLabel(row, { Position = UDim2.new(0, 2, 0, 0), Size = UDim2.new(1, -112, 1, 0), Text = name })
	local btn = make("TextButton", {
		Position = UDim2.new(1, -104, 0.5, -8),
		Size = UDim2.new(0, 104, 0, 16),
		BackgroundColor3 = BoxBg,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Font = Font,
		Text = options[defaultIndex],
		TextColor3 = TextBright,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, row)
	stroke(btn, BoxBorder, 1)
	make("UIPadding", { PaddingLeft = UDim.new(0, 6) }, btn)
	textLabel(btn, { Position = UDim2.new(1, -14, 0, 0), Size = UDim2.new(0, 12, 1, 0), Text = "v", TextColor3 = TextFaint, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Center })
	local index = defaultIndex
	local rec = { type = "dropdown", name = name, options = options, get = function() return index end }
	function rec.set(i)
		if options[i] then
			index = i
			btn.Text = options[i]
		end
	end
	local function openList()
		if activeList and activeList.owner == rec then
			closePopups()
			return
		end
		closePopups()
		openScrim()
		local listW = 104
		for _, o in ipairs(options) do
			listW = math.max(listW, #o * 7 + 22)
		end
		local itemH = 17
		local listH = #options * itemH
		local mp = menu.AbsolutePosition
		local ap = btn.AbsolutePosition
		local x = math.max(4, math.min(ap.X - mp.X, MenuW - listW - 6))
		local y = ap.Y - mp.Y + 21
		if y + listH > MenuH - 4 then
			y = ap.Y - mp.Y - listH - 5
		end
		local frame = make("Frame", {
			Position = UDim2.fromOffset(x, math.max(4, y)),
			Size = UDim2.fromOffset(listW, listH),
			BackgroundColor3 = GroupBg,
			BorderSizePixel = 0,
			ZIndex = 41,
		}, menu)
		stroke(frame, Color3.fromRGB(0, 0, 0), 1)
		make("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }, frame)
		for i, opt in ipairs(options) do
			local item = make("TextButton", {
				Size = UDim2.new(1, 0, 0, itemH),
				BackgroundTransparency = 1,
				AutoButtonColor = false,
				Font = Font,
				Text = opt,
				TextColor3 = i == index and TextBright or TextDim,
				TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = 42,
				LayoutOrder = i,
			}, frame)
			make("UIPadding", { PaddingLeft = UDim.new(0, 6) }, item)
			if i == index then
				make("Frame", { Position = UDim2.new(0, 0, 0.5, -4), Size = UDim2.new(0, 2, 0, 9), BackgroundColor3 = Accent, BorderSizePixel = 0, ZIndex = 43 }, item)
			end
			item.MouseEnter:Connect(function()
				item.BackgroundTransparency = 0
				item.BackgroundColor3 = Color3.fromRGB(44, 44, 44)
				item.TextColor3 = TextBright
			end)
			item.MouseLeave:Connect(function()
				item.BackgroundTransparency = 1
				item.TextColor3 = i == index and TextBright or TextDim
			end)
			item.MouseButton1Click:Connect(function()
				rec.set(i)
				closePopups()
			end)
		end
		activeList = { owner = rec, frame = frame }
	end
	btn.MouseButton1Click:Connect(openList)
	library.elements[#library.elements + 1] = rec
	return rec
end

local function addColor(parent, name, defaultColor)
	defaultColor = defaultColor or Accent
	local row = make("Frame", { Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1 }, parent)
	local swatch = make("Frame", { Position = UDim2.new(1, -26, 0.5, -6), Size = UDim2.new(0, 26, 0, 12), BackgroundColor3 = defaultColor, BorderSizePixel = 0 }, row)
	stroke(swatch, Color3.fromRGB(0, 0, 0), 1)
	textLabel(row, { Position = UDim2.new(0, 2, 0, 0), Size = UDim2.new(1, -34, 1, 0), Text = name })
	local btn = make("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", AutoButtonColor = false }, row)
	local h, s, v = Color3.toHSV(defaultColor)
	local rec = { type = "color", name = name, get = function() return Color3.fromHSV(h, s, v) end }
	local function openPicker()
		if activePicker and activePicker.owner == rec then
			closePopups()
			return
		end
		closePopups()
		openScrim()
		local frame = make("Frame", { Size = UDim2.fromOffset(150, 168), BackgroundColor3 = GroupBg, BorderSizePixel = 0, ZIndex = 41 }, menu)
		stroke(frame, Color3.fromRGB(0, 0, 0), 1)
		local mp = menu.AbsolutePosition
		local ap = swatch.AbsolutePosition
		local x = math.max(4, math.min(ap.X - mp.X, MenuW - 156))
		local y = ap.Y - mp.Y + 18
		if y + 168 > MenuH - 4 then
			y = ap.Y - mp.Y - 172
		end
		frame.Position = UDim2.fromOffset(x, math.max(4, y))
		local sv = make("Frame", { Position = UDim2.new(0, 8, 0, 8), Size = UDim2.new(1, -16, 0, 112), BackgroundColor3 = Color3.fromHSV(h, 1, 1), BorderSizePixel = 0, ZIndex = 42 }, frame)
		local whiteG = make("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, ZIndex = 43 }, sv)
		make("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) }) }, whiteG)
		local blackG = make("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(0, 0, 0), BorderSizePixel = 0, ZIndex = 44 }, sv)
		make("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) }), Rotation = 90 }, blackG)
		local dot = make("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(0, 6, 0, 6), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, ZIndex = 46 }, sv)
		stroke(dot, Color3.fromRGB(0, 0, 0), 1)
		local hueBar = make("Frame", { Position = UDim2.new(0, 8, 0, 126), Size = UDim2.new(1, -16, 0, 8), BorderSizePixel = 0, ZIndex = 42 }, frame)
		local hueKeys = {}
		for i = 0, 6 do
			hueKeys[#hueKeys + 1] = ColorSequenceKeypoint.new(i / 6, Color3.fromHSV((i / 6) % 1, 1, 1))
		end
		make("UIGradient", { Color = ColorSequence.new(hueKeys) }, hueBar)
		local hueDot = make("Frame", { AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0, 0, 0, -1), Size = UDim2.new(0, 3, 1, 2), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, ZIndex = 44 }, hueBar)
		stroke(hueDot, Color3.fromRGB(0, 0, 0), 1)
		local preview = make("Frame", { Position = UDim2.new(0, 8, 0, 140), Size = UDim2.new(0, 30, 0, 14), BackgroundColor3 = Color3.fromHSV(h, s, v), BorderSizePixel = 0, ZIndex = 42 }, frame)
		stroke(preview, Color3.fromRGB(0, 0, 0), 1)
		local rgbL = textLabel(frame, { Position = UDim2.new(0, 44, 0, 140), Size = UDim2.new(1, -52, 0, 14), Text = "", TextSize = 11, ZIndex = 42 })
		local function refresh()
			local c = Color3.fromHSV(h, s, v)
			swatch.BackgroundColor3 = c
			preview.BackgroundColor3 = c
			sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
			dot.Position = UDim2.new(s, 0, 1 - v, 0)
			hueDot.Position = UDim2.new(h, 0, 0, -1)
			rgbL.Text = math.floor(c.R * 255 + 0.5) .. " " .. math.floor(c.G * 255 + 0.5) .. " " .. math.floor(c.B * 255 + 0.5)
		end
		local function setSV(x, y)
			s = math.clamp((x - sv.AbsolutePosition.X) / math.max(sv.AbsoluteSize.X, 1), 0, 1)
			v = 1 - math.clamp((y - sv.AbsolutePosition.Y) / math.max(sv.AbsoluteSize.Y, 1), 0, 1)
			refresh()
		end
		local function setH(x)
			h = math.clamp((x - hueBar.AbsolutePosition.X) / math.max(hueBar.AbsoluteSize.X, 1), 0, 1)
			refresh()
		end
		sv.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				setSV(input.Position.X, input.Position.Y)
				activeDrag = setSV
			end
		end)
		hueBar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				setH(input.Position.X)
				activeDrag = setH
			end
		end)
		refresh()
		activePicker = { owner = rec, frame = frame, refresh = refresh }
	end
	btn.MouseButton1Click:Connect(openPicker)
	function rec.set(c)
		h, s, v = Color3.toHSV(c)
		swatch.BackgroundColor3 = Color3.fromHSV(h, s, v)
		if activePicker and activePicker.owner == rec and activePicker.refresh then
			activePicker.refresh()
		end
	end
	library.elements[#library.elements + 1] = rec
	return rec
end

local function addBind(parent, name)
	local row = make("Frame", { Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1 }, parent)
	textLabel(row, { Position = UDim2.new(0, 2, 0, 0), Size = UDim2.new(1, -66, 1, 0), Text = name })
	local btn = make("TextButton", {
		Position = UDim2.new(1, -62, 0.5, -7),
		Size = UDim2.new(0, 62, 0, 15),
		BackgroundColor3 = BoxBg,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Font = Font,
		Text = "[ none ]",
		TextColor3 = TextFaint,
		TextSize = 11,
	}, row)
	stroke(btn, BoxBorder, 1)
	local rec = { type = "bind", name = name, key = nil, get = function() return rec.key end }
	function rec.set(k)
		rec.key = k
		btn.Text = "[ " .. (k or "none") .. " ]"
		btn.TextColor3 = k and TextBright or TextFaint
	end
	function rec.confirm(k)
		rec.set(k)
		listeningBind = nil
	end
	btn.MouseButton1Click:Connect(function()
		listeningBind = rec
		btn.Text = "[ ... ]"
		btn.TextColor3 = TextBright
	end)
	library.elements[#library.elements + 1] = rec
	return rec
end

local function addButton(parent, name)
	local btn = make("TextButton", {
		Size = UDim2.new(1, 0, 0, 22),
		BackgroundColor3 = BoxBg,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Font = Font,
		Text = name,
		TextColor3 = TextDim,
		TextSize = 13,
	}, parent)
	stroke(btn, BoxBorder, 1)
	local rec = { type = "button", name = name, callback = nil, setCallback = function(self, fn) self.callback = fn end }
	btn.MouseEnter:Connect(function() btn.TextColor3 = TextBright end)
	btn.MouseLeave:Connect(function() btn.TextColor3 = TextDim end)
	btn.MouseButton1Click:Connect(function()
		btn.BackgroundColor3 = Accent
		TweenService:Create(btn, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = BoxBg }):Play()
		if rec.callback then
			rec.callback()
		end
	end)
	library.elements[#library.elements + 1] = rec
	return rec
end

local function addInput(parent, placeholder)
	local box = make("TextBox", {
		Size = UDim2.new(1, 0, 0, 20),
		BackgroundColor3 = BoxBg,
		BorderSizePixel = 0,
		Font = Font,
		Text = "",
		PlaceholderText = placeholder or "",
		PlaceholderColor3 = TextFaint,
		TextColor3 = TextBright,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false,
	}, parent)
	stroke(box, BoxBorder, 1)
	make("UIPadding", { PaddingLeft = UDim.new(0, 6) }, box)
	local rec = { type = "input", name = placeholder or "", get = function() return box.Text end, set = function(t) box.Text = t end }
	library.elements[#library.elements + 1] = rec
	return rec
end

local function addText(parent, str)
	textLabel(parent, { Size = UDim2.new(1, 0, 0, 14), Text = str, TextColor3 = TextFaint, TextSize = 12 })
end

local function addGroup(col, title, items)
	local box = make("Frame", { Size = UDim2.new(1, 0, 0, 0), BackgroundColor3 = GroupBg, BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.Y }, col)
	stroke(box, GroupBorder, 1)
	textLabel(box, { Position = UDim2.new(0, 8, 0, 0), Size = UDim2.new(1, -16, 0, 20), Text = title, TextColor3 = TextFaint, TextSize = 12 })
	local body = make("Frame", { Position = UDim2.new(0, 8, 0, 20), Size = UDim2.new(1, -16, 0, 0), BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y }, box)
	make("UIListLayout", { Padding = UDim.new(0, 7), SortOrder = Enum.SortOrder.LayoutOrder }, body)
	make("UIPadding", { PaddingBottom = UDim.new(0, 8) }, body)
	for _, item in ipairs(items) do
		local t = item[1]
		if t == "check" then
			addCheckbox(body, item[2], item[3])
		elseif t == "slider" then
			addSlider(body, item[2], item[3], item[4], item[5], item[6], item[7])
		elseif t == "dropdown" then
			addDropdown(body, item[2], item[3], item[4])
		elseif t == "color" then
			addColor(body, item[2], item[3])
		elseif t == "bind" then
			addBind(body, item[2])
		elseif t == "button" then
			addButton(body, item[2])
		elseif t == "input" then
			addInput(body, item[2])
		elseif t == "text" then
			addText(body, item[2])
		end
	end
end

local pages = {}
local function addPage(tabName, columns)
	local page = make("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false }, content)
	local n = #columns
	local pad = 12
	local gap = 12
	local colW = math.floor((MenuW - pad * 2 - gap * (n - 1)) / n + 0.5)
	for ci, groups in ipairs(columns) do
		local col = make("Frame", {
			Position = UDim2.new(0, pad + (ci - 1) * (colW + gap), 0, 10),
			Size = UDim2.new(0, colW, 1, -20),
			BackgroundTransparency = 1,
		}, page)
		make("UIListLayout", { Padding = UDim.new(0, 12), SortOrder = Enum.SortOrder.LayoutOrder }, col)
		for _, g in ipairs(groups) do
			addGroup(col, g[1], g[2])
		end
	end
	pages[#pages + 1] = { name = tabName, page = page }
end

local playerNames = {}
for _, p in ipairs(Players:GetPlayers()) do
	playerNames[#playerNames + 1] = p.Name
end
if #playerNames == 0 then
	playerNames = { "none" }
end

local menuData = {
	{ "rage", {
		{
			{ "aimbot", {
				{ "bind", "enabled" },
				{ "dropdown", "target selection", { "cycle", "closest", "lowest hp", "highest damage" }, 1 },
				{ "dropdown", "target hitbox", { "head", "chest", "stomach", "nearest" }, 1 },
				{ "dropdown", "multipoint", { "off", "low", "medium", "high" }, 1 },
				{ "slider", "minimum hit chance", 0, 100, 50, "%" },
				{ "slider", "minimum damage", 0, 130, 10, "" },
				{ "check", "double tap", true },
				{ "check", "quick stop" },
				{ "check", "auto scope" },
			} },
		},
		{
			{ "other", {
				{ "check", "silent aim" },
				{ "check", "delay shot" },
				{ "bind", "auto peek" },
				{ "bind", "slow walk" },
				{ "check", "duck peek" },
				{ "slider", "maximum fov", 0, 180, 180, "" },
				{ "dropdown", "hitscan", { "normal", "high", "safe" }, 1 },
				{ "check", "log misses" },
			} },
		},
	} },
	{ "anti-aim", {
		{
			{ "anti-aimbot angles", {
				{ "bind", "enabled" },
				{ "dropdown", "pitch", { "off", "down", "up", "zero" }, 1 },
				{ "dropdown", "yaw base", { "local view", "at targets" }, 1 },
				{ "dropdown", "yaw", { "off", "static", "180", "jitter", "random" }, 1 },
				{ "dropdown", "body yaw", { "off", "static", "jitter" }, 1 },
				{ "check", "freestanding" },
				{ "slider", "roll", -180, 180, 0, "" },
			} },
		},
		{
			{ "fake lag", {
				{ "bind", "enabled" },
				{ "dropdown", "amount", { "dynamic", "maximum", "factor" }, 1 },
				{ "slider", "variance", 0, 100, 75, "%" },
				{ "slider", "limit", 1, 16, 13, "" },
			} },
		},
		{
			{ "other", {
				{ "dropdown", "legs", { "off", "always", "never" }, 1 },
				{ "check", "fake shot" },
				{ "check", "air duck" },
				{ "check", "jump shot" },
			} },
		},
	} },
	{ "legit", {
		{
			{ "aimbot", {
				{ "check", "enabled" },
				{ "bind", "aim key" },
				{ "dropdown", "target hitbox", { "head", "chest", "nearest" }, 2 },
				{ "slider", "smoothing", 0, 20, 5, "" },
				{ "check", "auto fire" },
			} },
		},
		{
			{ "triggerbot", {
				{ "check", "enabled" },
				{ "bind", "key" },
				{ "slider", "shot delay", 0, 300, 50, "ms" },
				{ "check", "head only" },
				{ "check", "in air" },
			} },
		},
	} },
	{ "triggerbot", {
		{
			{ "general", {
				{ "check", "enabled" },
				{ "bind", "key" },
				{ "slider", "reaction time", 0, 200, 60, "ms" },
				{ "check", "head only" },
			} },
		},
		{
			{ "filters", {
				{ "check", "smoke check" },
				{ "check", "flash check" },
				{ "check", "walls" },
				{ "check", "in air" },
			} },
		},
	} },
	{ "players", {
		{
			{ "player", {
				{ "dropdown", "selection", playerNames, 1 },
				{ "check", "mute" },
				{ "bind", "spectate" },
			} },
		},
		{
			{ "friends", {
				{ "check", "highlight" },
				{ "color", "friend color", Color3.fromRGB(120, 220, 120) },
			} },
		},
	} },
	{ "visuals", {
		{
			{ "esp", {
				{ "check", "enabled" },
				{ "check", "box" },
				{ "check", "name" },
				{ "check", "health" },
				{ "check", "weapon" },
				{ "check", "ammo" },
				{ "check", "skeleton" },
				{ "color", "box color", Color3.fromRGB(255, 255, 255) },
				{ "color", "name color", Color3.fromRGB(255, 255, 255) },
			} },
		},
		{
			{ "glow", {
				{ "check", "glow" },
				{ "slider", "intensity", 0, 10, 4, "" },
				{ "color", "glow color", Accent },
				{ "check", "chams" },
				{ "color", "chams visible", Accent },
				{ "color", "chams hidden", Color3.fromRGB(255, 96, 160) },
			} },
		},
		{
			{ "world", {
				{ "check", "nightmode" },
				{ "color", "night color", Color3.fromRGB(40, 40, 60) },
				{ "slider", "fov", 90, 130, 100, "" },
				{ "check", "thirdperson" },
				{ "bind", "tp key" },
			} },
		},
	} },
	{ "misc", {
		{
			{ "movement", {
				{ "check", "bunny hop" },
				{ "check", "auto strafe" },
				{ "check", "edge jump" },
				{ "check", "slide walk" },
			} },
		},
		{
			{ "main", {
				{ "check", "watermark" },
				{ "check", "clan tag" },
				{ "check", "auto accept" },
				{ "bind", "menu key" },
			} },
		},
	} },
	{ "lua", {
		{
			{ "scripts", {
				{ "text", "no scripts found" },
				{ "button", "refresh" },
				{ "button", "reload all" },
			} },
		},
		{
			{ "editor", {
				{ "text", "load a script to edit" },
				{ "button", "load" },
				{ "button", "unload" },
			} },
		},
	} },
	{ "config", {
		{
			{ "config", {
				{ "check", "load on start" },
				{ "button", "load" },
				{ "button", "save" },
				{ "button", "create" },
				{ "button", "delete" },
				{ "button", "refresh" },
			} },
		},
		{
			{ "name", {
				{ "input", "config name" },
				{ "text", "loaded: none" },
			} },
		},
	} },
}

local tabButtons = {}
for _, def in ipairs(menuData) do
	local btn = make("TextButton", {
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Font = Font,
		Text = def[1],
		TextColor3 = TextDim,
		TextSize = 13,
		LayoutOrder = #tabButtons + 1,
	}, tabRow)
	addPage(def[1], def[2])
	tabButtons[#tabButtons + 1] = { name = def[1], btn = btn }
end

local function selectTab(name)
	library.tab = name
	for _, t in ipairs(tabButtons) do
		t.btn.TextColor3 = t.name == name and TextBright or TextDim
	end
	for _, p in ipairs(pages) do
		p.page.Visible = p.name == name
	end
end

for _, t in ipairs(tabButtons) do
	t.btn.MouseEnter:Connect(function() t.btn.TextColor3 = TextBright end)
	t.btn.MouseLeave:Connect(function() t.btn.TextColor3 = library.tab == t.name and TextBright or TextDim end)
	t.btn.MouseButton1Click:Connect(function() selectTab(t.name) end)
end
selectTab("rage")

for _, e in ipairs(library.elements) do
	if e.type == "bind" and e.name == "menu key" then
		e.set("p")
	end
end

local dragging = false
local dragStart, startPos
topbar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		closePopups()
		dragStart = input.Position
		startPos = menu.Position
	end
end)
topbar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UserInputService.InputBegan:Connect(function(input, processed)
	if listeningBind then
		if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode ~= Enum.KeyCode.Unknown then
			listeningBind.confirm(string.lower(input.KeyCode.Name))
			listeningBind = nil
		end
		return
	end
	if processed then
		return
	end
	if input.KeyCode == Enum.KeyCode.P then
		setOpen(not menuOpen)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		if dragging and menuOpen then
			local delta = input.Position - dragStart
			menu.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		elseif activeDrag then
			activeDrag(input.Position.X, input.Position.Y)
		end
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
		activeDrag = nil
	end
end)

local plaque = make("CanvasGroup", {
	AnchorPoint = Vector2.new(1, 1),
	Position = UDim2.new(1, 6, 1, -14),
	Size = UDim2.new(0, 198, 0, 44),
	BackgroundColor3 = WindowBg,
	BorderSizePixel = 0,
	GroupTransparency = 1,
}, gui)
stroke(plaque, Color3.fromRGB(0, 0, 0), 1)
textLabel(plaque, { Position = UDim2.new(0, 10, 0, 5), Size = UDim2.new(1, -20, 0, 16), Text = "gamesense injected", TextColor3 = TextBright, TextSize = 13 })
local pBarBg = make("Frame", { Position = UDim2.new(0, 10, 1, -12), Size = UDim2.new(1, -20, 0, 3), BackgroundColor3 = TrackBg, BorderSizePixel = 0 }, plaque)
local pBar = make("Frame", { Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = Accent, BorderSizePixel = 0 }, pBarBg)

task.spawn(function()
	TweenService:Create(plaque, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { GroupTransparency = 0, Position = UDim2.new(1, -14, 1, -14) }):Play()
	task.wait(0.45)
	TweenService:Create(pBar, TweenInfo.new(2.6, Enum.EasingStyle.Linear), { Size = UDim2.new(1, 0, 1, 0) }):Play()
	task.wait(2.75)
	local out = TweenService:Create(plaque, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { GroupTransparency = 1 })
	out:Play()
	out.Completed:Wait()
	plaque:Destroy()
	menuReady = true
	setOpen(true)
end)

library.menu = menu
library.open = setOpen
library.isOpen = function()
	return menuOpen
end
if getgenv then
	getgenv().gamesense = library
end

print("[gamesense] loaded")
