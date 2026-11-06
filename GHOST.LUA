-- GHOSTIN HUB - completo com foto da Nezuko
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

local BALL_RADIUS = 70
local TARGET_PART = "Head"
local AIM_SMOOTH = 0.85

local espColor = Color3.fromRGB(255,60,60)
local nameColor = Color3.fromRGB(255,255,255)
local distColor = Color3.fromRGB(200,200,200)
local skeletonColor = Color3.fromRGB(0,255,120)
local healthColor = Color3.fromRGB(0,255,0)
local espThickness = 2

-- 🖼️ FOTO DA NEZUKO (ID do decalque)
local ANIME_IMAGE_ID = "rbxassetid://5444301611"

local aimlockEnabled, lockedTarget = false, nil
local espEnabled, espBoxEnabled, espLineEnabled = true, true, true
local espNameEnabled, espDistEnabled = true, true
local espSkeletonEnabled, espHealthEnabled = true, true
local panelColor = Color3.fromRGB(18,16,24)
local titleColor = Color3.fromRGB(60,30,100)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GhostinHubGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local ballButton = Instance.new("Frame")
ballButton.Size = UDim2.new(0, BALL_RADIUS*2, 0, BALL_RADIUS*2)
ballButton.Position = UDim2.new(0.5, -BALL_RADIUS, 0.5, -BALL_RADIUS)
ballButton.BackgroundTransparency = 1
ballButton.BorderSizePixel = 0
ballButton.Visible = false
ballButton.Parent = screenGui
Instance.new("UICorner", ballButton).CornerRadius = UDim.new(1,0)

local ballStroke = Instance.new("UIStroke")
ballStroke.Thickness = 2
ballStroke.Color = Color3.fromRGB(255,0,0)
ballStroke.Parent = ballButton

local centerDot = Instance.new("Frame")
centerDot.Size = UDim2.new(0,5,0,5)
centerDot.Position = UDim2.new(0.5,-2.5,0.5,-2.5)
centerDot.BackgroundColor3 = Color3.fromRGB(255,0,0)
centerDot.BorderSizePixel = 0
centerDot.Parent = ballButton
Instance.new("UICorner", centerDot).CornerRadius = UDim.new(1,0)

local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0,50,0,50)
openButton.Position = UDim2.new(0,15,0.5,-25)
openButton.BackgroundColor3 = Color3.fromRGB(60,30,100)
openButton.Text = "☰"
openButton.TextColor3 = Color3.fromRGB(230,200,255)
openButton.Font = Enum.Font.GothamBlack
openButton.TextSize = 24
openButton.Visible = false
openButton.ZIndex = 10
openButton.Parent = screenGui
Instance.new("UICorner", openButton).CornerRadius = UDim.new(0,12)

local panelFrame = Instance.new("Frame")
panelFrame.Size = UDim2.new(0,680,0,500)
panelFrame.Position = UDim2.new(0.5,-340,0.5,-250)
panelFrame.BackgroundColor3 = panelColor
panelFrame.Visible = false -- O painel só aparece depois da KEY correta
panelFrame.Active = true
panelFrame.ClipsDescendants = true
panelFrame.Parent = screenGui
Instance.new("UICorner", panelFrame).CornerRadius = UDim.new(0,16)

-- TELA DE KEY (adicionada sem alterar o visual nem as opções do painel original)
local GHOST_KEY = "GHOST"

local keyFrame = Instance.new("Frame")
keyFrame.Name = "GhostKeyFrame"
keyFrame.Size = UDim2.new(0, 350, 0, 220)
keyFrame.Position = UDim2.new(0.5, -175, 0.5, -110)
keyFrame.BackgroundColor3 = panelColor
keyFrame.BorderSizePixel = 0
keyFrame.ZIndex = 20
keyFrame.Parent = screenGui
Instance.new("UICorner", keyFrame).CornerRadius = UDim.new(0, 16)

local keyStroke = Instance.new("UIStroke")
keyStroke.Thickness = 1.5
keyStroke.Color = Color3.fromRGB(140, 80, 220)
keyStroke.Transparency = 0.2
keyStroke.Parent = keyFrame

local keyTitle = Instance.new("TextLabel")
keyTitle.Size = UDim2.new(1, -20, 0, 48)
keyTitle.Position = UDim2.new(0, 10, 0, 12)
keyTitle.BackgroundTransparency = 1
keyTitle.Text = "GHOSTIN HUB"
keyTitle.TextColor3 = Color3.fromRGB(240, 210, 255)
keyTitle.Font = Enum.Font.GothamBlack
keyTitle.TextSize = 24
keyTitle.ZIndex = 21
keyTitle.Parent = keyFrame

local keySubtitle = Instance.new("TextLabel")
keySubtitle.Size = UDim2.new(1, -20, 0, 22)
keySubtitle.Position = UDim2.new(0, 10, 0, 55)
keySubtitle.BackgroundTransparency = 1
keySubtitle.Text = "DIGITE A KEY PARA CONTINUAR"
keySubtitle.TextColor3 = Color3.fromRGB(200, 170, 240)
keySubtitle.Font = Enum.Font.GothamMedium
keySubtitle.TextSize = 11
keySubtitle.ZIndex = 21
keySubtitle.Parent = keyFrame

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(1, -40, 0, 38)
keyBox.Position = UDim2.new(0, 20, 0, 88)
keyBox.BackgroundColor3 = Color3.fromRGB(35, 30, 48)
keyBox.BorderSizePixel = 0
keyBox.PlaceholderText = "DIGITE SUA KEY"
keyBox.PlaceholderColor3 = Color3.fromRGB(155, 145, 170)
keyBox.Text = ""
keyBox.TextColor3 = Color3.fromRGB(240, 230, 255)
keyBox.Font = Enum.Font.GothamBold
keyBox.TextSize = 14
keyBox.ClearTextOnFocus = false
keyBox.ZIndex = 21
keyBox.Parent = keyFrame
Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0, 8)

local verifyKey = Instance.new("TextButton")
verifyKey.Size = UDim2.new(1, -40, 0, 36)
verifyKey.Position = UDim2.new(0, 20, 0, 137)
verifyKey.BackgroundColor3 = titleColor
verifyKey.BorderSizePixel = 0
verifyKey.Text = "VERIFICAR KEY"
verifyKey.TextColor3 = Color3.fromRGB(255, 255, 255)
verifyKey.Font = Enum.Font.GothamBlack
verifyKey.TextSize = 13
verifyKey.ZIndex = 21
verifyKey.Parent = keyFrame
Instance.new("UICorner", verifyKey).CornerRadius = UDim.new(0, 8)

local keyStatus = Instance.new("TextLabel")
keyStatus.Size = UDim2.new(1, -20, 0, 24)
keyStatus.Position = UDim2.new(0, 10, 0, 180)
keyStatus.BackgroundTransparency = 1
keyStatus.Text = "AGUARDANDO KEY..."
keyStatus.TextColor3 = Color3.fromRGB(200, 170, 240)
keyStatus.Font = Enum.Font.GothamBold
keyStatus.TextSize = 11
keyStatus.ZIndex = 21
keyStatus.Parent = keyFrame

local function verifyGhostKey()
    if string.upper(keyBox.Text) == GHOST_KEY then
        keyStatus.Text = "KEY CORRETA!"
        keyStatus.TextColor3 = Color3.fromRGB(70, 230, 120)
        verifyKey.Active = false
        task.wait(0.35)
        keyFrame:Destroy()
        panelFrame.Visible = true
    else
        keyStatus.Text = "KEY INVÁLIDA!"
        keyStatus.TextColor3 = Color3.fromRGB(255, 75, 85)
        keyBox.Text = ""
    end
end

verifyKey.MouseButton1Click:Connect(verifyGhostKey)
keyBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then verifyGhostKey() end
end)

local panelStroke = Instance.new("UIStroke")
panelStroke.Thickness = 1.5
panelStroke.Color = Color3.fromRGB(140,80,220)
panelStroke.Transparency = 0.2
panelStroke.Parent = panelFrame

local header = Instance.new("Frame")
header.Size = UDim2.new(1,0,0,60)
header.BackgroundColor3 = titleColor
header.BorderSizePixel = 0
header.ZIndex = 2
header.Parent = panelFrame
Instance.new("UICorner", header).CornerRadius = UDim.new(0,16)

local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1,0,0,20)
headerFix.Position = UDim2.new(0,0,1,-20)
headerFix.BackgroundColor3 = titleColor
headerFix.BorderSizePixel = 0
headerFix.ZIndex = 2
headerFix.Parent = header

local titleBar = Instance.new("TextLabel")
titleBar.Size = UDim2.new(0.55,0,1,0)
titleBar.Position = UDim2.new(0.03,0,0,0)
titleBar.BackgroundTransparency = 1
titleBar.Text = "GHOSTIN HUB"
titleBar.TextColor3 = Color3.fromRGB(240,210,255)
titleBar.Font = Enum.Font.GothamBlack
titleBar.TextSize = 26
titleBar.TextXAlignment = Enum.TextXAlignment.Left
titleBar.ZIndex = 3
titleBar.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(0.55,0,0,16)
subtitle.Position = UDim2.new(0.03,0,0,38)
subtitle.BackgroundTransparency = 1
subtitle.Text = "aimlock • esp • skeleton • health"
subtitle.TextColor3 = Color3.fromRGB(200,170,240)
subtitle.Font = Enum.Font.GothamMedium
subtitle.TextSize = 11
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.ZIndex = 3
subtitle.Parent = header

-- 🖼️ FOTO DA NEZUKO NO HEADER
local animeImage = Instance.new("ImageLabel")
animeImage.Size = UDim2.new(0, 48, 0, 48)
animeImage.Position = UDim2.new(1, -105, 0.5, -24)
animeImage.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
animeImage.BackgroundTransparency = 0.3
animeImage.Image = ANIME_IMAGE_ID
animeImage.ScaleType = Enum.ScaleType.Crop
animeImage.ZIndex = 4
animeImage.Parent = header
Instance.new("UICorner", animeImage).CornerRadius = UDim.new(1, 0)

local animeStroke = Instance.new("UIStroke")
animeStroke.Thickness = 2
animeStroke.Color = Color3.fromRGB(180, 120, 255)
animeStroke.Parent = animeImage

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,36,0,36)
closeBtn.Position = UDim2.new(1,-48,0.5,-18)
closeBtn.BackgroundColor3 = Color3.fromRGB(180,50,70)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBlack
closeBtn.TextSize = 18
closeBtn.ZIndex = 5
closeBtn.Parent = header
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,10)

local dragging, dragStart, startPos
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = panelFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        panelFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

local col1 = Instance.new("Frame")
col1.Size = UDim2.new(0,300,1,-80)
col1.Position = UDim2.new(0,20,0,70)
col1.BackgroundTransparency = 1
col1.ZIndex = 2
col1.Parent = panelFrame

local col1Title = Instance.new("TextLabel")
col1Title.Size = UDim2.new(1,0,0,20)
col1Title.BackgroundTransparency = 1
col1Title.Text = "AIMLOCK & ESP"
col1Title.TextColor3 = Color3.fromRGB(200,160,255)
col1Title.Font = Enum.Font.GothamBold
col1Title.TextSize = 12
col1Title.TextXAlignment = Enum.TextXAlignment.Left
col1Title.ZIndex = 2
col1Title.Parent = col1

local function createToggle(text,yPos,parent,initial)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,0,32)
    btn.Position = UDim2.new(0,0,0,yPos)
    btn.BackgroundColor3 = Color3.fromRGB(40,35,55)
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.ZIndex = 2
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,-60,1,0)
    label.Position = UDim2.new(0,16,0,0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220,220,230)
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 3
    label.Parent = btn
    local sw = Instance.new("Frame")
    sw.Size = UDim2.new(0,40,0,20)
    sw.Position = UDim2.new(1,-50,0.5,-10)
    sw.BackgroundColor3 = initial and Color3.fromRGB(50,180,80) or Color3.fromRGB(60,55,75)
    sw.BorderSizePixel = 0
    sw.ZIndex = 3
    sw.Parent = btn
    Instance.new("UICorner", sw).CornerRadius = UDim.new(1,0)
    local kn = Instance.new("Frame")
    kn.Size = UDim2.new(0,16,0,16)
    kn.Position = initial and UDim2.new(0,22,0.5,-8) or UDim2.new(0,2,0.5,-8)
    kn.BackgroundColor3 = initial and Color3.fromRGB(240,255,245) or Color3.fromRGB(150,150,160)
    kn.BorderSizePixel = 0
    kn.ZIndex = 4
    kn.Parent = sw
    Instance.new("UICorner", kn).CornerRadius = UDim.new(1,0)
    return btn, sw, kn
end

local function updToggle(sw,kn,on)
    sw.BackgroundColor3 = on and Color3.fromRGB(50,180,80) or Color3.fromRGB(60,55,75)
    kn.Position = on and UDim2.new(0,22,0.5,-8) or UDim2.new(0,2,0.5,-8)
    kn.BackgroundColor3 = on and Color3.fromRGB(240,255,245) or Color3.fromRGB(150,150,160)
end

local aimBtn, aimSw, aimKnob = createToggle("Aimlock", 28, col1, false)
local espBtn, espSw, espKnob = createToggle("ESP", 64, col1, true)
local boxBtn, boxSw, boxKnob = createToggle("Box", 100, col1, true)
local lineBtn, lineSw, lineKnob = createToggle("Linha", 136, col1, true)
local nameBtn, nameSw, nameKnob = createToggle("Nome", 172, col1, true)
local distBtn, distSw, distKnob = createToggle("Distância", 208, col1, true)
local skelBtn, skelSw, skelKnob = createToggle("Skeleton", 244, col1, true)
local healthBtn, healthSw, healthKnob = createToggle("Health Bar", 280, col1, true)

local col2 = Instance.new("Frame")
col2.Size = UDim2.new(0,320,1,-80)
col2.Position = UDim2.new(0,340,0,70)
col2.BackgroundTransparency = 1
col2.ZIndex = 2
col2.Parent = panelFrame

local col2Title = Instance.new("TextLabel")
col2Title.Size = UDim2.new(1,0,0,20)
col2Title.BackgroundTransparency = 1
col2Title.Text = "FOV • GROSSURA • CORES"
col2Title.TextColor3 = Color3.fromRGB(200,160,255)
col2Title.Font = Enum.Font.GothamBold
col2Title.TextSize = 12
col2Title.TextXAlignment = Enum.TextXAlignment.Left
col2Title.ZIndex = 2
col2Title.Parent = col2

local fovLabel = Instance.new("TextLabel")
fovLabel.Size = UDim2.new(1,0,0,22)
fovLabel.Position = UDim2.new(0,0,0,26)
fovLabel.BackgroundTransparency = 1
fovLabel.Text = "Raio do FOV: "..BALL_RADIUS.."px"
fovLabel.TextColor3 = Color3.fromRGB(220,200,255)
fovLabel.Font = Enum.Font.GothamBold
fovLabel.TextSize = 12
fovLabel.TextXAlignment = Enum.TextXAlignment.Left
fovLabel.ZIndex = 3
fovLabel.Parent = col2

local function smBtn(t,x,y,p)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0,40,0,30)
    b.Position = UDim2.new(0,x,0,y)
    b.BackgroundColor3 = Color3.fromRGB(70,50,110)
    b.Text = t
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBlack
    b.TextSize = 18
    b.ZIndex = 3
    b.Parent = p
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
    return b
end

local minusBtn = smBtn("-",0,56,col2)
local fovBox = Instance.new("TextBox")
fovBox.Size = UDim2.new(0,170,0,30)
fovBox.Position = UDim2.new(0,48,0,56)
fovBox.BackgroundColor3 = Color3.fromRGB(35,30,48)
fovBox.Text = tostring(BALL_RADIUS)
fovBox.TextColor3 = Color3.fromRGB(220,200,255)
fovBox.Font = Enum.Font.GothamBold
fovBox.TextSize = 14
fovBox.ZIndex = 3
fovBox.Parent = col2
Instance.new("UICorner", fovBox).CornerRadius = UDim.new(0,8)
local plusBtn = smBtn("+",226,56,col2)

local thickLabel = Instance.new("TextLabel")
thickLabel.Size = UDim2.new(1,0,0,22)
thickLabel.Position = UDim2.new(0,0,0,96)
thickLabel.BackgroundTransparency = 1
thickLabel.Text = "Grossura: "..espThickness
thickLabel.TextColor3 = Color3.fromRGB(220,200,255)
thickLabel.Font = Enum.Font.GothamBold
thickLabel.TextSize = 12
thickLabel.TextXAlignment = Enum.TextXAlignment.Left
thickLabel.ZIndex = 3
thickLabel.Parent = col2

local thickMinus = smBtn("-",0,124,col2)
local thickBox = Instance.new("TextBox")
thickBox.Size = UDim2.new(0,170,0,30)
thickBox.Position = UDim2.new(0,48,0,124)
thickBox.BackgroundColor3 = Color3.fromRGB(35,30,48)
thickBox.Text = tostring(espThickness)
thickBox.TextColor3 = Color3.fromRGB(220,200,255)
thickBox.Font = Enum.Font.GothamBold
thickBox.TextSize = 14
thickBox.ZIndex = 3
thickBox.Parent = col2
Instance.new("UICorner", thickBox).CornerRadius = UDim.new(0,8)
local thickPlus = smBtn("+",226,124,col2)

local pColorLabel = Instance.new("TextLabel")
pColorLabel.Size = UDim2.new(1,0,0,18)
pColorLabel.Position = UDim2.new(0,0,0,164)
pColorLabel.BackgroundTransparency = 1
pColorLabel.Text = "Cor do painel"
pColorLabel.TextColor3 = Color3.fromRGB(200,160,255)
pColorLabel.Font = Enum.Font.GothamBold
pColorLabel.TextSize = 11
pColorLabel.TextXAlignment = Enum.TextXAlignment.Left
pColorLabel.ZIndex = 3
pColorLabel.Parent = col2

local panelPalette = {
    {Color3.fromRGB(18,16,24),Color3.fromRGB(60,30,100)},
    {Color3.fromRGB(14,22,32),Color3.fromRGB(25,70,110)},
    {Color3.fromRGB(16,26,18),Color3.fromRGB(30,85,40)},
    {Color3.fromRGB(32,14,14),Color3.fromRGB(110,25,25)},
    {Color3.fromRGB(32,22,10),Color3.fromRGB(110,70,20)},
    {Color3.fromRGB(32,14,28),Color3.fromRGB(110,25,85)},
    {Color3.fromRGB(12,12,14),Color3.fromRGB(55,55,60)},
}
for i,pair in ipairs(panelPalette) do
    local s = Instance.new("TextButton")
    s.Size = UDim2.new(0,32,0,26)
    s.Position = UDim2.new(0,(i-1)*38,0,186)
    s.BackgroundColor3 = pair[2]
    s.Text = ""
    s.ZIndex = 3
    s.Parent = col2
    Instance.new("UICorner", s).CornerRadius = UDim.new(0,6)
    s.MouseButton1Click:Connect(function()
        panelFrame.BackgroundColor3 = pair[1]
        header.BackgroundColor3 = pair[2]
        headerFix.BackgroundColor3 = pair[2]
    end)
end

local espColorLabel = Instance.new("TextLabel")
espColorLabel.Size = UDim2.new(1,0,0,18)
espColorLabel.Position = UDim2.new(0,0,0,220)
espColorLabel.BackgroundTransparency = 1
espColorLabel.Text = "Cores do ESP"
espColorLabel.TextColor3 = Color3.fromRGB(200,160,255)
espColorLabel.Font = Enum.Font.GothamBold
espColorLabel.TextSize = 11
espColorLabel.TextXAlignment = Enum.TextXAlignment.Left
espColorLabel.ZIndex = 3
espColorLabel.Parent = col2

local espPalette = {
    Color3.fromRGB(255,60,60),Color3.fromRGB(255,150,0),
    Color3.fromRGB(255,255,0),Color3.fromRGB(0,255,100),
    Color3.fromRGB(0,200,255),Color3.fromRGB(100,100,255),
    Color3.fromRGB(255,0,255),Color3.fromRGB(255,255,255),
    Color3.fromRGB(0,0,0),
}

local function colorRow(text,y,setter)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0,90,0,16)
    lbl.Position = UDim2.new(0,0,0,y)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(200,200,220)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 3
    lbl.Parent = col2
    for i,c in ipairs(espPalette) do
        local sw = Instance.new("TextButton")
        sw.Size = UDim2.new(0,18,0,16)
        sw.Position = UDim2.new(0,90+(i-1)*20,0,y)
        sw.BackgroundColor3 = c
        sw.Text = ""
        sw.ZIndex = 3
        sw.Parent = col2
        Instance.new("UICorner", sw).CornerRadius = UDim.new(0,4)
        sw.MouseButton1Click:Connect(function() setter(c) end)
    end
end

colorRow("Box/Linha",242,function(c) espColor = c end)
colorRow("Nome",262,function(c) nameColor = c end)
colorRow("Distância",282,function(c) distColor = c end)
colorRow("Skeleton",302,function(c) skeletonColor = c end)
colorRow("Health",322,function(c) healthColor = c end)

local function setFOV(n)
    n = math.clamp(math.floor(n),10,1000)
    BALL_RADIUS = n
    ballButton.Size = UDim2.new(0,n*2,0,n*2)
    ballButton.Position = UDim2.new(0.5,-n,0.5,-n)
    fovLabel.Text = "Raio do FOV: "..n.."px"
    fovBox.Text = tostring(n)
end
plusBtn.MouseButton1Click:Connect(function() setFOV(BALL_RADIUS+10) end)
minusBtn.MouseButton1Click:Connect(function() setFOV(BALL_RADIUS-10) end)
fovBox.FocusLost:Connect(function()
    local n = tonumber(fovBox.Text)
    if n then setFOV(n) else fovBox.Text = tostring(BALL_RADIUS) end
end)

local function setThick(n)
    n = math.clamp(math.floor(n),1,10)
    espThickness = n
    thickLabel.Text = "Grossura: "..n
    thickBox.Text = tostring(n)
end
thickPlus.MouseButton1Click:Connect(function() setThick(espThickness+1) end)
thickMinus.MouseButton1Click:Connect(function() setThick(espThickness-1) end)
thickBox.FocusLost:Connect(function()
    local n = tonumber(thickBox.Text)
    if n then setThick(n) else thickBox.Text = tostring(espThickness) end
end)

local function showPanel() panelFrame.Visible = true; openButton.Visible = false end
local function hidePanel() panelFrame.Visible = false; openButton.Visible = true end
local function togglePanel() if panelFrame.Visible then hidePanel() else showPanel() end end
closeBtn.MouseButton1Click:Connect(hidePanel)
openButton.MouseButton1Click:Connect(showPanel)

local function setAim(state)
    aimlockEnabled = state
    updToggle(aimSw,aimKnob,state)
    ballButton.Visible = state
    ballStroke.Color = state and Color3.fromRGB(50,255,50) or Color3.fromRGB(255,0,0)
    centerDot.BackgroundColor3 = state and Color3.fromRGB(50,255,50) or Color3.fromRGB(255,0,0)
    if not state then lockedTarget = nil end
end

local function isAlive(plr)
    if not plr or not plr.Parent then return false end
    local ch = plr.Character
    if not ch then return false end
    local p = ch:FindFirstChild(TARGET_PART)
    local h = ch:FindFirstChildOfClass("Humanoid")
    if not p or not h or h.Health <= 0 then return false end
    return true, p
end

local function findFOV()
    local ap = ballButton.AbsolutePosition
    local as = ballButton.AbsoluteSize
    local c = Vector2.new(ap.X+as.X/2, ap.Y+as.Y/2)
    local cl, sh, cp = nil, BALL_RADIUS, nil
    for _,o in ipairs(Players:GetPlayers()) do
        if o == player then continue end
        local ok, pt = isAlive(o)
        if ok then
            local sp, on = Camera:WorldToViewportPoint(pt.Position)
            if on then
                local d = (Vector2.new(sp.X,sp.Y)-c).Magnitude
                if d <= BALL_RADIUS and d < sh then sh = d; cl = o; cp = pt end
            end
        end
    end
    return cl, cp
end

local drawings = {}
local BONES = {
    {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
    {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
    {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
    {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
    {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
}

local function ensure(plr)
    if drawings[plr] then return drawings[plr] end
    local t = {
        box = Drawing.new("Square"),
        line = Drawing.new("Line"),
        name = Drawing.new("Text"),
        dist = Drawing.new("Text"),
        hbg = Drawing.new("Square"),
        hfill = Drawing.new("Square"),
        bones = {},
    }
    t.box.Filled = false; t.box.Visible = false
    t.line.Visible = false
    t.name.Center = true; t.name.Outline = true; t.name.Size = 14; t.name.Visible = false
    t.dist.Center = true; t.dist.Outline = true; t.dist.Size = 12; t.dist.Visible = false
    t.hbg.Filled = true; t.hbg.Visible = false
    t.hfill.Filled = true; t.hfill.Visible = false
    for i = 1, #BONES do
        local l = Drawing.new("Line")
        l.Visible = false
        t.bones[i] = l
    end
    drawings[plr] = t
    return t
end

local function hide(plr)
    local t = drawings[plr]
    if not t then return end
    t.box.Visible = false; t.line.Visible = false; t.name.Visible = false
    t.dist.Visible = false; t.hbg.Visible = false; t.hfill.Visible = false
    for _,l in pairs(t.bones) do l.Visible = false end
end

local function updateESP()
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr == player then continue end
        local ch = plr.Character
        local hu = ch and ch:FindFirstChildOfClass("Humanoid")
        local hr = ch and ch:FindFirstChild("HumanoidRootPart")
        if not ch or not hu or hu.Health <= 0 or not hr or not espEnabled then hide(plr); continue end
        local t = ensure(plr)
        local hd = ch:FindFirstChild("Head") or hr
        local hp, on = Camera:WorldToViewportPoint(hd.Position + Vector3.new(0,0.5,0))
        local fp = Camera:WorldToViewportPoint(hr.Position - Vector3.new(0,3,0))
        if not on then hide(plr); continue end
        t.box.Color = espColor; t.box.Thickness = espThickness
        t.line.Color = espColor; t.line.Thickness = espThickness
        t.name.Color = nameColor
        t.dist.Color = distColor
        for _,l in pairs(t.bones) do l.Color = skeletonColor; l.Thickness = espThickness end
        local bx, bh = 0, 0
        t.box.Visible = espBoxEnabled
        if espBoxEnabled then
            bh = math.abs(fp.Y-hp.Y)
            local w = bh/2
            bx = hp.X-w/2
            t.box.Size = Vector2.new(w,bh)
            t.box.Position = Vector2.new(bx,hp.Y)
        end
        t.line.Visible = espLineEnabled
        if espLineEnabled then
            t.line.From = Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y)
            t.line.To = Vector2.new(hp.X,hp.Y)
        end
        t.name.Visible = espNameEnabled
        if espNameEnabled then
            t.name.Text = plr.Name
            t.name.Position = Vector2.new(hp.X,hp.Y-18)
        end
        t.dist.Visible = espDistEnabled
        if espDistEnabled then
            t.dist.Text = math.floor((Camera.CFrame.Position-hr.Position).Magnitude).."m"
            t.dist.Position = Vector2.new(hp.X,fp.Y+4)
        end
        if espHealthEnabled then
            local pct = hu.Health/hu.MaxHealth
            local bh2 = bh > 0 and bh or math.abs(fp.Y-hp.Y)
            local bxx = (bx > 0) and (bx-9) or (hp.X-30)
            t.hbg.Size = Vector2.new(5,bh2)
            t.hbg.Position = Vector2.new(bxx,hp.Y)
            t.hbg.Color = Color3.fromRGB(30,30,30)
            t.hbg.Visible = true
            local fh = bh2*pct
            t.hfill.Size = Vector2.new(5,fh)
            t.hfill.Position = Vector2.new(bxx,hp.Y+(bh2-fh))
            t.hfill.Color = healthColor
            t.hfill.Visible = true
        else
            t.hbg.Visible = false; t.hfill.Visible = false
        end
        if espSkeletonEnabled then
            for i,b in ipairs(BONES) do
                local a = ch:FindFirstChild(b[1])
                local c = ch:FindFirstChild(b[2])
                local l = t.bones[i]
                if a and c then
                    local pa, oa = Camera:WorldToViewportPoint(a.Position)
                    local pb, ob = Camera:WorldToViewportPoint(c.Position)
                    if oa and ob then
                        l.From = Vector2.new(pa.X,pa.Y)
                        l.To = Vector2.new(pb.X,pb.Y)
                        l.Visible = true
                    else l.Visible = false end
                else l.Visible = false end
            end
        else
            for _,l in pairs(t.bones) do l.Visible = false end
        end
    end
end

Players.PlayerRemoving:Connect(function(plr)
    local t = drawings[plr]
    if t then
        t.box:Remove(); t.line:Remove(); t.name:Remove(); t.dist:Remove()
        t.hbg:Remove(); t.hfill:Remove()
        for _,l in pairs(t.bones) do l:Remove() end
        drawings[plr] = nil
    end
    if lockedTarget == plr then lockedTarget = nil end
end)

aimBtn.MouseButton1Click:Connect(function() setAim(not aimlockEnabled) end)
espBtn.MouseButton1Click:Connect(function() espEnabled = not espEnabled; updToggle(espSw,espKnob,espEnabled) end)
boxBtn.MouseButton1Click:Connect(function() espBoxEnabled = not espBoxEnabled; updToggle(boxSw,boxKnob,espBoxEnabled) end)
lineBtn.MouseButton1Click:Connect(function() espLineEnabled = not espLineEnabled; updToggle(lineSw,lineKnob,espLineEnabled) end)
nameBtn.MouseButton1Click:Connect(function() espNameEnabled = not espNameEnabled; updToggle(nameSw,nameKnob,espNameEnabled) end)
distBtn.MouseButton1Click:Connect(function() espDistEnabled = not espDistEnabled; updToggle(distSw,distKnob,espDistEnabled) end)
skelBtn.MouseButton1Click:Connect(function() espSkeletonEnabled = not espSkeletonEnabled; updToggle(skelSw,skelKnob,espSkeletonEnabled) end)
healthBtn.MouseButton1Click:Connect(function() espHealthEnabled = not espHealthEnabled; updToggle(healthSw,healthKnob,espHealthEnabled) end)

RunService.RenderStepped:Connect(function()
    updateESP()
    if aimlockEnabled then
        if not lockedTarget then
            local f = findFOV()
            if f then lockedTarget = f end
        end
        local ok, pt = isAlive(lockedTarget)
        if ok then
            local la = CFrame.new(Camera.CFrame.Position, pt.Position)
            Camera.CFrame = Camera.CFrame:Lerp(la, AIM_SMOOTH)
            ballStroke.Color = Color3.fromRGB(50,255,50)
        else
            lockedTarget = nil
            ballStroke.Color = Color3.fromRGB(255,200,0)
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.K then togglePanel()
    elseif input.KeyCode == Enum.KeyCode.Q then setAim(not aimlockEnabled)
    elseif input.KeyCode == Enum.KeyCode.X then setAim(not aimlockEnabled)
    elseif input.KeyCode == Enum.KeyCode.Z then espEnabled = not espEnabled; updToggle(espSw,espKnob,espEnabled)
    elseif input.KeyCode == Enum.KeyCode.C then espSkeletonEnabled = not espSkeletonEnabled; updToggle(skelSw,skelKnob,espSkeletonEnabled)
    elseif input.KeyCode == Enum.KeyCode.H then espHealthEnabled = not espHealthEnabled; updToggle(healthSw,healthKnob,espHealthEnabled)
    end
end)

print("[GHOSTIN HUB] Carregado com foto da Nezuko!")
