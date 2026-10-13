-- LocalScript: taruh di StarterGui atau StarterPlayerScripts
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local CONFIG = {
	Title = "LUCKY BLOCK LUCKER",
	Duration = 120,
	Size = 0.55,
	CloseOnFinish = false,
	MascotImage = "", -- isi dengan "rbxassetid://ID_GAMBAR_TENGKORAK"
	Footer = "tipsy.angelstore for in-use",
	OnFinished = function() end,
}

local COLORS = {
	Panel = Color3.fromRGB(231, 226, 234),
	Outline = Color3.fromRGB(30, 30, 36),
	Dark = Color3.fromRGB(24, 24, 28),
	BarFill = Color3.fromRGB(72, 72, 82),
	Text = Color3.fromRGB(255, 255, 255),
	Title = Color3.fromRGB(28, 28, 34),
	Dot = Color3.fromRGB(255, 200, 40),
	DotDone = Color3.fromRGB(70, 220, 110),
	Footer = Color3.fromRGB(170, 165, 175),
}

local function create(className, props, children)
	local instance = Instance.new(className)
	for key, value in pairs(props) do
		instance[key] = value
	end
	for _, child in ipairs(children or {}) do
		child.Parent = instance
	end
	return instance
end

local function corner(radius)
	return create("UICorner", { CornerRadius = UDim.new(0, radius) })
end

local function stroke(thickness, color)
	return create("UIStroke", {
		Thickness = thickness,
		Color = color,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	})
end

local old = player.PlayerGui:FindFirstChild("LuckyBlockLoader")
if old then
	old:Destroy()
end

local screenGui = create("ScreenGui", {
	Name = "LuckyBlockLoader",
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	DisplayOrder = 100,
	Parent = player:WaitForChild("PlayerGui"),
})

local panel = create("Frame", {
	Name = "Panel",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.55),
	Size = UDim2.fromOffset(400, 330),
	BackgroundColor3 = COLORS.Panel,
	BorderSizePixel = 0,
	Parent = screenGui,
}, {
	corner(26),
	stroke(3, COLORS.Outline),
})

local scale = create("UIScale", { Parent = panel })
local function updateScale()
	local viewport = workspace.CurrentCamera.ViewportSize
	scale.Scale = math.clamp(math.min(viewport.X / 700, viewport.Y / 560), 0.5, 1.4) * CONFIG.Size
end
updateScale()
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)

-- Mascot
local mascot
if CONFIG.MascotImage ~= "" then
	mascot = create("ImageLabel", {
		Name = "Mascot",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0, -10),
		Size = UDim2.fromOffset(130, 130),
		BackgroundTransparency = 1,
		Image = CONFIG.MascotImage,
		ScaleType = Enum.ScaleType.Fit,
		ZIndex = 5,
		Parent = panel,
	})
else
	mascot = create("TextLabel", {
		Name = "Mascot",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0, -10),
		Size = UDim2.fromOffset(130, 130),
		BackgroundTransparency = 1,
		Text = "💀",
		TextScaled = true,
		ZIndex = 5,
		Parent = panel,
	})
end

TweenService:Create(
	mascot,
	TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
	{ Position = UDim2.new(0.5, 0, 0, -22), Rotation = 4 }
):Play()

-- Close button
local closeButton = create("TextButton", {
	Name = "Close",
	AnchorPoint = Vector2.new(1, 0),
	Position = UDim2.new(1, -14, 0, 14),
	Size = UDim2.fromOffset(44, 44),
	BackgroundColor3 = COLORS.Dark,
	BorderSizePixel = 0,
	Text = "✕",
	TextColor3 = COLORS.Text,
	TextSize = 22,
	Font = Enum.Font.GothamBlack,
	AutoButtonColor = false,
	ZIndex = 6,
	Parent = panel,
}, {
	corner(12),
})

closeButton.MouseEnter:Connect(function()
	TweenService:Create(closeButton, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(60, 60, 70) }):Play()
end)
closeButton.MouseLeave:Connect(function()
	TweenService:Create(closeButton, TweenInfo.new(0.12), { BackgroundColor3 = COLORS.Dark }):Play()
end)

-- Title
create("TextLabel", {
	Name = "Title",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.35),
	Size = UDim2.new(0.9, 0, 0, 36),
	BackgroundTransparency = 1,
	Text = CONFIG.Title,
	TextColor3 = COLORS.Title,
	TextSize = 26,
	Font = Enum.Font.GothamBlack,
	Parent = panel,
})

-- Status pill
local pill = create("Frame", {
	Name = "Pill",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.48),
	Size = UDim2.fromOffset(120, 30),
	BackgroundColor3 = COLORS.Dark,
	BorderSizePixel = 0,
	Parent = panel,
}, {
	corner(15),
})

local dot = create("Frame", {
	Name = "Dot",
	AnchorPoint = Vector2.new(0, 0.5),
	Position = UDim2.new(0, 14, 0.5, 0),
	Size = UDim2.fromOffset(14, 14),
	BackgroundColor3 = COLORS.Dot,
	BorderSizePixel = 0,
	Parent = pill,
}, {
	corner(7),
})

local pillText = create("TextLabel", {
	Name = "PillText",
	AnchorPoint = Vector2.new(0, 0.5),
	Position = UDim2.new(0, 36, 0.5, 0),
	Size = UDim2.new(1, -44, 1, 0),
	BackgroundTransparency = 1,
	Text = "LOADING",
	TextColor3 = COLORS.Text,
	TextSize = 15,
	Font = Enum.Font.GothamBold,
	TextXAlignment = Enum.TextXAlignment.Left,
	Parent = pill,
})

-- Progress bar
local barBackground = create("Frame", {
	Name = "Bar",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.67),
	Size = UDim2.new(0.92, 0, 0, 56),
	BackgroundColor3 = COLORS.Dark,
	BorderSizePixel = 0,
	ClipsDescendants = true,
	Parent = panel,
}, {
	corner(14),
})

local barFill = create("Frame", {
	Name = "Fill",
	Size = UDim2.fromScale(0, 1),
	BackgroundColor3 = COLORS.BarFill,
	BorderSizePixel = 0,
	Parent = barBackground,
}, {
	corner(14),
})

local barText = create("TextLabel", {
	Name = "BarText",
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
	Text = "LOADING... 0%",
	TextColor3 = COLORS.Text,
	TextSize = 22,
	Font = Enum.Font.GothamBlack,
	ZIndex = 3,
	Parent = barBackground,
})

-- Footer
create("TextLabel", {
	Name = "Footer",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.92),
	Size = UDim2.new(0.9, 0, 0, 14),
	BackgroundTransparency = 1,
	Text = CONFIG.Footer,
	TextColor3 = COLORS.Footer,
	TextSize = 10,
	Font = Enum.Font.Gotham,
	Parent = panel,
})

-- Drag (mouse + touch)
local dragging = false
local dragStartInput = Vector3.zero
local dragStartPosition = panel.Position
local dragInput

local function isPointerStart(input)
	return input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch
end

panel.InputBegan:Connect(function(input)
	if not isPointerStart(input) then
		return
	end
	dragging = true
	dragInput = input
	dragStartInput = input.Position
	dragStartPosition = panel.Position
	input.Changed:Connect(function()
		if input.UserInputState == Enum.UserInputState.End then
			dragging = false
		end
	end)
end)

UserInputService.InputChanged:Connect(function(input)
	if not dragging then
		return
	end
	local isMove = input.UserInputType == Enum.UserInputType.MouseMovement
		or (input.UserInputType == Enum.UserInputType.Touch and input == dragInput)
	if not isMove then
		return
	end
	local viewport = screenGui.AbsoluteSize
	local delta = input.Position - dragStartInput
	local newX = math.clamp(dragStartPosition.X.Scale + delta.X / viewport.X, 0.05, 0.95)
	local newY = math.clamp(dragStartPosition.Y.Scale + delta.Y / viewport.Y, 0.08, 0.95)
	panel.Position = UDim2.fromScale(newX, newY)
end)

-- Open animation
panel.Size = UDim2.fromOffset(0, 0)
TweenService:Create(
	panel,
	TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
	{ Size = UDim2.fromOffset(400, 330) }
):Play()

-- Progress logic
local closed = false

local function closePanel()
	if closed then
		return
	end
	closed = true
	local tween = TweenService:Create(
		panel,
		TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In),
		{ Size = UDim2.fromOffset(0, 0) }
	)
	tween:Play()
	tween.Completed:Wait()
	screenGui:Destroy()
end

closeButton.MouseButton1Click:Connect(closePanel)

task.spawn(function()
	task.wait(0.45)
	local duration = CONFIG.Duration
	local startTime = os.clock()

	while not closed do
		local elapsed = os.clock() - startTime
		local alpha = math.clamp(elapsed / duration, 0, 1)
		barFill.Size = UDim2.fromScale(alpha, 1)
		barText.Text = ("LOADING... %d%%"):format(math.floor(alpha * 100))
		if alpha >= 1 then
			break
		end
		RunService.RenderStepped:Wait()
	end

	if closed then
		return
	end

	barFill.Size = UDim2.fromScale(1, 1)
	barText.Text = "COMPLETE! 100%"
	pillText.Text = "READY"
	dot.BackgroundColor3 = COLORS.DotDone

	CONFIG.OnFinished()
	if CONFIG.CloseOnFinish then
		task.wait(0.8)
		closePanel()
	end
end)
