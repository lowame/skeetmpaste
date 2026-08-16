local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local TS=game:GetService("TweenService")
local lp=Players.LocalPlayer
local gui=Instance.new("ScreenGui")
gui.Name="gamesense"
gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
gui.ResetOnSpawn=false
gui.IgnoreGuiInset=true
local ok=pcall(function() gui.Parent=(gethui and gethui()) or game:GetService("CoreGui") end)
if not ok or not gui.Parent then gui.Parent=lp:WaitForChild("PlayerGui") end
local T={
bg=Color3.fromRGB(13,13,13),
side=Color3.fromRGB(16,16,16),
panel=Color3.fromRGB(22,22,22),
border=Color3.fromRGB(42,42,42),
ctrl=Color3.fromRGB(31,31,31),
ctrlB=Color3.fromRGB(54,54,54),
text=Color3.fromRGB(200,200,200),
dim=Color3.fromRGB(125,125,125),
accent=Color3.fromRGB(158,200,40),
yellow=Color3.fromRGB(200,200,90),
white=Color3.fromRGB(235,235,235)
}
local F_BODY=Enum.Font.RobotoCondensed
local F_BOLD=Enum.Font.ArialBold
local settings={}
local openList=nil
local binding=false
local function inst(c,p,parent)
local o=Instance.new(c)
for k,v in pairs(p) do o[k]=v end
if parent then o.Parent=parent end
return o
end
local ICONC=Color3.fromRGB(145,145,145)
local function icon(kind,parent)
local f=inst("Frame",{BackgroundTransparency=1,Size=UDim2.fromOffset(28,28),Parent=parent})
local function r(x,y,w,h,rot)
local q=inst("Frame",{BackgroundColor3=ICONC,BorderSizePixel=0,Position=UDim2.fromOffset(x,y),Size=UDim2.fromOffset(w,h),Parent=f})
if rot then q.Rotation=rot end
return q
end
local function c(x,y,w,h,fill,sw)
local q=inst("Frame",{BackgroundColor3=ICONC,BackgroundTransparency=fill and 0 or 1,BorderSizePixel=0,Position=UDim2.fromOffset(x,y),Size=UDim2.fromOffset(w,h),Parent=f})
inst("UICorner",{CornerRadius=UDim.new(1,0),Parent=q})
if sw then inst("UIStroke",{Color=ICONC,Thickness=sw,Parent=q}) end
return q
end
if kind=="aimbot" then
c(3,9,12,12,true)
r(5,20,8,3)
r(15,6,10,2)
r(19,2,2,10)
r(16,3,10,2,45)
r(16,3,10,2,-45)
elseif kind=="antiaim" then
c(2,2,24,24,false,2)
c(10,7,8,8,true)
c(7,14,14,10,true)
r(2,12,26,2,45)
elseif kind=="trigger" then
c(4,4,20,20,false,2)
r(13,0,2,5)
r(13,23,2,5)
r(0,13,5,2)
r(23,13,5,2)
c(13,13,2,2,true)
elseif kind=="visuals" then
c(6,6,16,16,false,2)
c(6,6,8,16,true)
r(13,0,2,4)
r(13,24,2,4)
r(0,13,4,2)
r(24,13,4,2)
elseif kind=="misc" then
c(3,8,13,13,false,3)
r(8,4,3,4)
r(8,21,3,4)
r(0,13,3,3)
r(16,13,3,3)
c(8,13,3,3,true)
c(16,15,10,10,false,2)
r(20,12,2,3)
r(20,25,2,3)
r(13,19,3,2)
r(26,19,3,2)
c(20,19,2,2,true)
elseif kind=="knife" then
local b=r(3,12,15,6)
inst("UICorner",{CornerRadius=UDim.new(1,0),Parent=b})
r(17,14,7,3)
c(23,12,5,5,false,2)
elseif kind=="players" then
c(9,4,10,10,true)
local d=r(5,15,18,10)
inst("UICorner",{CornerRadius=UDim.new(1,0),Parent=d})
elseif kind=="configs" then
c(4,4,20,20,false,2)
r(9,4,10,6)
r(8,13,12,11)
elseif kind=="gun" then
r(0,4,16,4)
r(16,5,6,2)
r(1,8,4,7,12)
r(10,8,3,6)
end
return f
end
local function bindbtn(parent,pos,initial)
local b=inst("TextButton",{AutoButtonColor=false,BackgroundTransparency=1,Position=pos,Size=UDim2.fromOffset(38,18),TextColor3=T.dim,Font=F_BODY,TextSize=11,Text=initial,Parent=parent})
b.MouseButton1Click:Connect(function()
b.Text="[...]"
binding=true
local conn
conn=UIS.InputBegan:Connect(function(inp)
local done=false
local res="[-]"
if inp.UserInputType==Enum.UserInputType.Keyboard then
if inp.KeyCode==Enum.KeyCode.Escape then res="[-]" else res="["..inp.KeyCode.Name.."]" end
done=true
elseif inp.UserInputType.Name:match("MouseButton") then
res="[M"..inp.UserInputType.Name:sub(-1).."]"
done=true
end
if done then
b.Text=res
binding=false
conn:Disconnect()
end
end)
end)
return b
end
local WIN_W,WIN_H=762,662
local window=Instance.new("CanvasGroup")
window.Size=UDim2.fromOffset(WIN_W,WIN_H)
window.Position=UDim2.new(0.5,-WIN_W/2,0.5,-WIN_H/2)
window.BackgroundColor3=T.bg
window.BorderSizePixel=0
window.GroupTransparency=1
window.Visible=false
window.ClipsDescendants=true
window.Parent=gui
inst("UIStroke",{Color=Color3.fromRGB(45,45,45),Thickness=1,Parent=window})
local grad=inst("Frame",{BackgroundColor3=Color3.fromRGB(30,30,30),BorderSizePixel=0,Size=UDim2.new(1,0,0,2),Parent=window})
inst("UIGradient",{Color=ColorSequence.new({
ColorSequenceKeypoint.new(0,Color3.fromRGB(124,60,255)),
ColorSequenceKeypoint.new(0.25,Color3.fromRGB(255,60,166)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,122,60)),
ColorSequenceKeypoint.new(0.75,Color3.fromRGB(255,210,60)),
ColorSequenceKeypoint.new(1,Color3.fromRGB(163,255,60))
}),Parent=grad})
local side=inst("Frame",{BackgroundColor3=T.side,BorderSizePixel=0,Size=UDim2.new(0,90,1,0),Parent=window})
inst("Frame",{BackgroundColor3=T.border,BorderSizePixel=0,Position=UDim2.fromOffset(90,0),Size=UDim2.new(0,1,1,0),Parent=window})
local topbox=inst("TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.fromRGB(28,28,28),Size=UDim2.fromOffset(90,90),Text="",Parent=side})
inst("UIStroke",{Color=T.border,Parent=topbox})
inst("Frame",{BackgroundColor3=T.border,BorderSizePixel=0,Position=UDim2.fromOffset(0,90),Size=UDim2.new(1,0,0,1),Parent=side})
local pages={}
local tabOrder={"aimbot","antiaim","trigger","visuals","misc","skins","players","configs"}
local iconKind={aimbot="aimbot",antiaim="antiaim",trigger="trigger",visuals="visuals",misc="misc",skins="knife",players="players",configs="configs"}
for _,id in ipairs(tabOrder) do
pages[id]=inst("Frame",{BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),Position=UDim2.fromOffset(90,0),Visible=false,ClipsDescendants=true,Parent=window})
end
local function group(page,x,y,w,h,title)
inst("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(x+2,y-9),Size=UDim2.fromOffset(w,16),Text=title,Font=F_BOLD,TextSize=12,TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,Parent=page})
local b=inst("Frame",{BackgroundColor3=T.panel,BorderSizePixel=0,Position=UDim2.fromOffset(x,y),Size=UDim2.fromOffset(w,h),Parent=page})
inst("UIStroke",{Color=T.border,Thickness=1,Parent=b})
return {b=b,y=10,w=w,page=page}
end
local function label(g,o)
local ind=o.indent or 0
local w=g.w-24-ind
local row=inst("Frame",{BackgroundTransparency=1,Position=UDim2.fromOffset(12+ind,g.y),Size=UDim2.fromOffset(w,18),Parent=g.b})
inst("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(0,0),Size=UDim2.new(1,-40,1,0),Text=o.text,Font=F_BODY,TextSize=12,TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,Parent=row})
if o.bind then bindbtn(row,UDim2.new(1,-38,0,0),o.bind) end
g.y=g.y+18
end
local function checkbox(g,o)
local ind=o.indent or 0
local w=g.w-24-ind
local row=inst("TextButton",{AutoButtonColor=false,BackgroundTransparency=1,Position=UDim2.fromOffset(12+ind,g.y),Size=UDim2.fromOffset(w,20),Text="",Parent=g.b})
local box=inst("Frame",{BackgroundColor3=T.ctrl,BorderSizePixel=0,AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,0,0.5,0),Size=UDim2.fromOffset(10,10),Parent=row})
inst("UIStroke",{Color=T.ctrlB,Parent=box})
local fill=inst("Frame",{BackgroundColor3=T.accent,BorderSizePixel=0,Size=UDim2.new(1,0,1,0),BackgroundTransparency=o.default and 0 or 1,Parent=box})
inst("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(20,0),Size=UDim2.new(1,-58,1,0),Text=o.text,Font=F_BODY,TextSize=12,TextColor3=o.yellow and T.yellow or T.text,TextXAlignment=Enum.TextXAlignment.Left,Parent=row})
if o.bind then bindbtn(row,UDim2.new(1,-38,0,1),o.bind) end
local on=o.default or false
settings[o.id]=on
row.MouseButton1Click:Connect(function()
on=not on
settings[o.id]=on
fill.BackgroundTransparency=on and 0 or 1
end)
g.y=g.y+22
end
local function dropdown(g,o)
local ind=o.indent or 0
local w=g.w-24-ind
if o.label then label(g,{text=o.label,indent=ind,bind=o.bind}) end
local btn=inst("TextButton",{AutoButtonColor=false,BackgroundColor3=T.ctrl,Position=UDim2.fromOffset(12+ind,g.y),Size=UDim2.fromOffset(w,22),Text="",Parent=g.b})
inst("UIStroke",{Color=T.ctrlB,Parent=btn})
local txt=inst("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(8,0),Size=UDim2.new(1,-26,1,0),Text=o.default,Font=F_BODY,TextSize=12,TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,Parent=btn})
inst("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(1,-16,0,0),Size=UDim2.fromOffset(12,22),Text="▾",Font=F_BODY,TextSize=10,TextColor3=T.dim,Parent=btn})
settings[o.id]=o.default
local list=nil
local function close()
if list then list.Visible=false end
openList=nil
end
local function open()
if not list then
list=inst("Frame",{BackgroundColor3=Color3.fromRGB(27,27,27),BorderSizePixel=0,ZIndex=60,Visible=false,Parent=g.page})
inst("UIStroke",{Color=T.border,Parent=list})
for i,opt in ipairs(o.options) do
local ob=inst("TextButton",{AutoButtonColor=false,BackgroundColor3=Color3.fromRGB(27,27,27),Position=UDim2.fromOffset(2,2+(i-1)*18),Size=UDim2.new(1,-4,0,18),ZIndex=61,Text=opt,Font=F_BODY,TextSize=12,TextColor3=T.text,Parent=list})
ob.MouseEnter:Connect(function() ob.BackgroundColor3=Color3.fromRGB(40,40,40) end)
ob.MouseLeave:Connect(function() ob.BackgroundColor3=Color3.fromRGB(27,27,27) end)
ob.MouseButton1Click:Connect(function()
txt.Text=opt
settings[o.id]=opt
close()
end)
end
end
list.Position=UDim2.fromOffset(btn.AbsolutePosition.X-g.page.AbsolutePosition.X,btn.AbsolutePosition.Y-g.page.AbsolutePosition.Y+24)
list.Size=UDim2.fromOffset(btn.AbsoluteSize.X,#o.options*18+4)
list.Visible=true
openList=close
end
btn.MouseButton1Click:Connect(function()
if list and list.Visible then close() return end
if openList then openList() end
open()
end)
g.y=g.y+26
end
local function slider(g,o)
local ind=o.indent or 0
local w=g.w-24-ind
local trackY=g.y+8
local track=inst("Frame",{BackgroundColor3=T.ctrl,BorderSizePixel=0,Position=UDim2.fromOffset(12+ind,trackY),Size=UDim2.fromOffset(w,6),Parent=g.b})
local fill=inst("Frame",{BackgroundColor3=T.accent,BorderSizePixel=0,Size=UDim2.fromOffset(2,6),Parent=track})
local vlab=inst("TextLabel",{BackgroundTransparency=1,AnchorPoint=Vector2.new(0.5,0),Font=F_BOLD,TextSize=11,TextColor3=T.white,Text="",Parent=track})
local grab=inst("TextButton",{AutoButtonColor=false,BackgroundTransparency=1,Position=UDim2.fromOffset(12+ind,trackY-5),Size=UDim2.fromOffset(w,16),Text="",Parent=g.b})
local function set(r)
r=math.clamp(r,0,1)
local val=math.floor(o.min+(o.max-o.min)*r+0.5)
settings[o.id]=val
fill.Size=UDim2.fromOffset(math.max(2,w*r),6)
vlab.Text=tostring(val)..(o.suffix or "")
vlab.Position=UDim2.fromOffset(w*r,5)
end
local dr=false
local function fromX(x)
set((x-track.AbsolutePosition.X)/w)
end
grab.MouseButton1Down:Connect(function(x)
dr=true
fromX(x)
end)
UIS.InputChanged:Connect(function(inp)
if dr and inp.UserInputType==Enum.UserInputType.MouseMovement then
fromX(inp.Position.X)
end
end)
UIS.InputEnded:Connect(function(inp)
if inp.UserInputType==Enum.UserInputType.MouseButton1 then dr=false end
end)
set((o.default-o.min)/(o.max-o.min))
g.y=g.y+24
end
local pAim=pages.aimbot
local gW=group(pAim,20,40,305,58,"Weapon type")
local wrow=inst("TextButton",{AutoButtonColor=false,BackgroundTransparency=1,Position=UDim2.fromOffset(12,gW.y),Size=UDim2.fromOffset(281,26),Text="",Parent=gW.b})
local wbox=inst("Frame",{BackgroundColor3=T.ctrl,BorderSizePixel=0,AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,0,0.5,0),Size=UDim2.fromOffset(10,10),Parent=wrow})
inst("UIStroke",{Color=T.ctrlB,Parent=wbox})
inst("Frame",{BackgroundColor3=T.accent,BorderSizePixel=0,Size=UDim2.new(1,0,1,0),Parent=wbox})
inst("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(20,0),Size=UDim2.fromOffset(120,26),Text="Global",Font=F_BODY,TextSize=12,TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,Parent=wrow})
local gun=icon("gun",wrow)
gun.Position=UDim2.new(1,-46,0.5,-8)
inst("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(1,-16,0,0),Size=UDim2.fromOffset(12,26),Text="▾",Font=F_BODY,TextSize=10,TextColor3=T.dim,Parent=wrow})
local gA=group(pAim,20,115,305,520,"Aimbot")
checkbox(gA,{id="aim_enabled",text="Enabled",bind="[M5]"})
label(gA,{text="Target selection",indent=1})
dropdown(gA,{id="aim_targetsel",indent=1,default="Cycle",options={"Cycle","Closest to crosshair","Highest damage","Lowest health"}})
label(gA,{text="Target hitbox",indent=1})
dropdown(gA,{id="aim_hitbox",indent=1,default="Head",options={"Head","Chest","Stomach","Nearest"}})
label(gA,{text="Multi-point",indent=1,bind="[-]"})
dropdown(gA,{id="aim_multipoint",indent=1,default="-",options={"-","Head","Chest","Stomach"}})
label(gA,{text="Minimum hit chance",indent=1})
slider(gA,{id="aim_hitchance",indent=1,min=0,max=100,default=50,suffix="%"})
label(gA,{text="Minimum damage",indent=1})
slider(gA,{id="aim_mindmg",indent=1,min=0,max=100,default=10})
checkbox(gA,{id="aim_mindmgovr",text="Minimum damage override",indent=1,bind="[-]"})
checkbox(gA,{id="aim_prefersafe",text="Prefer safe point",indent=1})
label(gA,{text="Force safe point",indent=1,bind="[-]"})
label(gA,{text="Avoid unsafe hitboxes",indent=1})
dropdown(gA,{id="aim_avoidunsafe",indent=1,default="-",options={"-","Head","Chest","Stomach"}})
checkbox(gA,{id="aim_forcebody",text="Force body aim",indent=1,bind="[-]"})
checkbox(gA,{id="aim_forcebodypeek",text="Force body aim on peek",indent=1})
checkbox(gA,{id="aim_quickstop",text="Quick stop",indent=1,bind="[-]"})
checkbox(gA,{id="aim_doubletap",text="Double tap",indent=1,bind="[-]",yellow=true})
checkbox(gA,{id="aim_autoscope",text="Automatic scope",indent=1})
local gO=group(pAim,340,40,300,520,"Other")
label(gO,{text="Accuracy boost",indent=1})
dropdown(gO,{id="aim_accboost",indent=1,default="Low",options={"Off","Low","Medium","High"}})
checkbox(gO,{id="aim_aacorr",text="Anti-aim correction"})
checkbox(gO,{id="aim_autofire",text="Automatic fire"})
checkbox(gO,{id="aim_autopen",text="Automatic penetration"})
checkbox(gO,{id="aim_silent",text="Silent aim"})
checkbox(gO,{id="aim_norecoil",text="Remove recoil"})
checkbox(gO,{id="aim_delayshot",text="Delay shot"})
checkbox(gO,{id="aim_qpa",text="Quick peek assist",bind="[-]"})
label(gO,{text="Duck peek assist",bind="[-]"})
checkbox(gO,{id="aim_reduceaim",text="Reduce aim step"})
label(gO,{text="Maximum FOV"})
slider(gO,{id="aim_fov",min=0,max=180,default=180,suffix="°"})
checkbox(gO,{id="aim_logmisses",text="Log misses due to spread",default=true})
label(gO,{text="Low FPS mitigations"})
dropdown(gO,{id="aim_lowfps",default="-",options={"-","On","Off"}})
local pAA=pages.antiaim
local gAA=group(pAA,20,40,305,560,"Anti-aimbot angles")
checkbox(gAA,{id="aa_enabled",text="Enabled",bind="[-]"})
label(gAA,{text="Pitch",indent=1})
dropdown(gAA,{id="aa_pitch",indent=1,default="Off",options={"Off","Up","Down","Zero"}})
label(gAA,{text="Yaw base",indent=1})
dropdown(gAA,{id="aa_yawbase",indent=1,default="Local view",options={"Local view","At targets"}})
label(gAA,{text="Yaw",indent=1})
dropdown(gAA,{id="aa_yaw",indent=1,default="Off",options={"Off","Forward","Left","Right","Back"}})
label(gAA,{text="Body yaw",indent=1})
dropdown(gAA,{id="aa_bodyyaw",indent=1,default="Off",options={"Off","Jitter","Opposite"}})
checkbox(gAA,{id="aa_edgeyaw",text="Edge yaw",indent=1})
checkbox(gAA,{id="aa_freestand",text="Freestanding",indent=1,bind="[-]"})
label(gAA,{text="Roll",indent=1})
slider(gAA,{id="aa_roll",indent=1,min=-60,max=60,default=0,suffix="°"})
local gFL=group(pAA,340,40,300,210,"Fake lag")
checkbox(gFL,{id="fl_enabled",text="Enabled",bind="[-]"})
label(gFL,{text="Amount",indent=1})
dropdown(gFL,{id="fl_amount",indent=1,default="Dynamical",options={"Dynamical","Constant"}})
label(gFL,{text="Variance",indent=1})
slider(gFL,{id="fl_variance",indent=1,min=0,max=100,default=0,suffix="%"})
label(gFL,{text="Limit",indent=1})
slider(gFL,{id="fl_limit",indent=1,min=0,max=16,default=13})
local gAO=group(pAA,340,275,300,300,"Other")
checkbox(gAO,{id="ao_slowmo",text="Slow motion",bind="[CAP]"})
label(gAO,{text="Leg movement",indent=1})
dropdown(gAO,{id="ao_legmove",indent=1,default="Off",options={"Off","On"}})
checkbox(gAO,{id="ao_onshot",text="On shot anti-aim",bind="[-]",yellow=true})
checkbox(gAO,{id="ao_fakepeek",text="Fake peek",bind="[X]",yellow=true})
local sideBtns={}
local topIcon=nil
local current=nil
local function setTab(id)
if openList then openList() end
for _,tid in ipairs(tabOrder) do
pages[tid].Visible=(tid==id)
end
for tid,b in pairs(sideBtns) do
b.BackgroundColor3=(tid==id) and Color3.fromRGB(28,28,28) or T.side
end
if topIcon then topIcon:Destroy() end
topIcon=icon(iconKind[id],topbox)
topIcon.Position=UDim2.new(0.5,-14,0.5,-14)
current=id
end
for i=2,#tabOrder do
local id=tabOrder[i]
local b=inst("TextButton",{AutoButtonColor=false,BackgroundColor3=T.side,Size=UDim2.fromOffset(90,74),Position=UDim2.fromOffset(0,94+(i-2)*74),Text="",Parent=side})
local ic=icon(iconKind[id],b)
ic.Position=UDim2.new(0.5,-14,0.5,-14)
b.MouseButton1Click:Connect(function()
setTab(id)
end)
sideBtns[id]=b
end
topbox.MouseButton1Click:Connect(function()
setTab("aimbot")
end)
setTab("aimbot")
local drag=inst("TextButton",{AutoButtonColor=false,BackgroundTransparency=1,Position=UDim2.fromOffset(90,0),Size=UDim2.fromOffset(WIN_W-90,14),Text="",ZIndex=8,Parent=window})
local dOn=false
local dOff=Vector2.new(0,0)
drag.MouseButton1Down:Connect(function(x,y)
dOn=true
dOff=Vector2.new(x-window.AbsolutePosition.X,y-window.AbsolutePosition.Y)
end)
UIS.InputEnded:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseButton1 then dOn=false end
end)
UIS.InputChanged:Connect(function(i)
if dOn and i.UserInputType==Enum.UserInputType.MouseMovement then
window.Position=UDim2.fromOffset(i.Position.X-dOff.X,i.Position.Y-dOff.Y)
end
end)
local function showMenu()
if openList then openList() end
window.Visible=true
TS:Create(window,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{GroupTransparency=0}):Play()
end
local function hideMenu()
if openList then openList() end
local t=TS:Create(window,TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{GroupTransparency=1})
t:Play()
t.Completed:Connect(function()
window.Visible=false
end)
end
UIS.InputBegan:Connect(function(inp,gpe)
if gpe then return end
if binding then return end
if inp.KeyCode==Enum.KeyCode.P then
if window.Visible then hideMenu() else showMenu() end
end
end)
local note=Instance.new("CanvasGroup")
note.Size=UDim2.fromOffset(250,62)
note.Position=UDim2.new(1,-270,1,-82)
note.BackgroundColor3=Color3.fromRGB(18,18,18)
note.BorderSizePixel=0
note.Parent=gui
inst("UIStroke",{Color=T.border,Parent=note})
inst("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(12,10),Size=UDim2.fromOffset(226,20),Text="gamesense injected",Font=F_BODY,TextSize=13,TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,Parent=note})
local nbar=inst("Frame",{BackgroundColor3=T.accent,BorderSizePixel=0,Position=UDim2.fromOffset(12,44),Size=UDim2.fromOffset(226,3),Parent=note})
task.wait(0.3)
local nt=TS:Create(nbar,TweenInfo.new(2.6,Enum.EasingStyle.Linear),{Size=UDim2.fromOffset(0,3)})
nt:Play()
nt.Completed:Connect(function()
local f=TS:Create(note,TweenInfo.new(0.35,Enum.EasingStyle.Quad),{GroupTransparency=1})
f:Play()
f.Completed:Connect(function()
note:Destroy()
showMenu()
end)
end)
_G.gamesense={settings=settings,window=window}
