-- Keyboard Overlay
-- Shows the left half of a keyboard (NohBoard style). Keys light up while you hold them.
-- Drag it from anywhere. Its position is saved between sessions.

-- ============================================================
-- SETTINGS
-- ============================================================
-- Colors are plain numbers: { red, green, blue }, each from 0 to 255
local PRESSED_COLOR = { KBOPC }               -- the color a key turns while it is pressed
local PRESSED_TEXT_COLOR = { 255, 255, 255 }         -- the color of the letter while it is pressed
local KEY_COLOR = { KBOKC }                     -- a key when it is not pressed
local KEY_TEXT_COLOR = { 254, 254, 254 }             -- the letter on a key when it is not pressed
local KEY_TRANSPARENCY = 0                              -- 0 = solid keys, 1 = invisible keys

local BACKGROUND_COLOR = { KBOBGC }              -- the gray box behind the keys
local BACKGROUND_TRANSPARENCY = KBOT                    -- 0 = solid, 1 = invisible

local KEY_SIZE = 44                                     -- size of a normal key, in pixels
local KEY_GAP = 4                                       -- space between keys, in pixels
local PADDING = 10                                      -- space between the keys and the edge of the gray box
local TEXT_SIZE = 14
local TILT = KBOTT                                         -- leans every key (degrees): 0 = |=|, 10 = /=/, -10 = \=\   (the letters stay straight)
local PRESS_FADE = 0.05                                 -- how fast a key changes color (seconds)

local SPAWN = Vector2.new(0.15, 0.78)                   -- where it first appears (0-1 of the screen)
local SAVE_POSITION = true                              -- remember where you left it
local SAVE_FILE = "KeyboardOverlay_Position.json"
local DISPLAY_ORDER = 2147483000
local SCREEN_MARGIN = 6                                 -- it can't be dragged closer than this to the screen edge

-- ============================================================
-- THE KEYS (left half of the keyboard)
-- width is in "key units": 1 = a normal key, so Space is much wider than W
-- ============================================================
local ROWS = {
	{
		{ label = "Tab", width = 1.5, codes = { Enum.KeyCode.Tab } },
		{ label = "Q", width = 1, codes = { Enum.KeyCode.Q } },
		{ label = "W", width = 1, codes = { Enum.KeyCode.W } },
		{ label = "E", width = 1, codes = { Enum.KeyCode.E } },
		{ label = "R", width = 1, codes = { Enum.KeyCode.R } },
		{ label = "T", width = 1, codes = { Enum.KeyCode.T } },
	},
	{
		{ label = "Caps", width = 1.75, codes = { Enum.KeyCode.CapsLock } },
		{ label = "A", width = 1, codes = { Enum.KeyCode.A } },
		{ label = "S", width = 1, codes = { Enum.KeyCode.S } },
		{ label = "D", width = 1, codes = { Enum.KeyCode.D } },
		{ label = "F", width = 1, codes = { Enum.KeyCode.F } },
		{ label = "G", width = 1, codes = { Enum.KeyCode.G } },
	},
	{
		{ label = "Shift", width = 2.25, codes = { Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift } },
		{ label = "Z", width = 1, codes = { Enum.KeyCode.Z } },
		{ label = "X", width = 1, codes = { Enum.KeyCode.X } },
		{ label = "C", width = 1, codes = { Enum.KeyCode.C } },
		{ label = "V", width = 1, codes = { Enum.KeyCode.V } },
	},
	{
		{ label = "Ctrl", width = 1.5, codes = { Enum.KeyCode.LeftControl, Enum.KeyCode.RightControl } },
		{ label = "Alt", width = 1.25, codes = { Enum.KeyCode.LeftAlt, Enum.KeyCode.RightAlt } },
		{ label = "Space", width = 3.75, codes = { Enum.KeyCode.Space } },
	},
}

-- ============================================================
-- DO NOT EDIT BELOW THIS LINE
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")
local HttpService = game:GetService("HttpService")

local TAG = "KeyboardOverlayGui" -- DeleteKeyboardOverlay finds it with this
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local function make(class, props, parent)
	local inst = Instance.new(class)
	for key, value in pairs(props) do
		inst[key] = value
	end
	inst.Parent = parent
	return inst
end

local function isPress(input)
	return input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch
end

local function rgb(color)
	return Color3.fromRGB(
		math.clamp(color[1] or 0, 0, 255),
		math.clamp(color[2] or 0, 0, 255),
		math.clamp(color[3] or 0, 0, 255)
	)
end
local pressedColor = rgb(PRESSED_COLOR)
local pressedTextColor = rgb(PRESSED_TEXT_COLOR)
local keyColor = rgb(KEY_COLOR)
local keyTextColor = rgb(KEY_TEXT_COLOR)
local backgroundColor = rgb(BACKGROUND_COLOR)

local function p2(input)
	return Vector2.new(input.Position.X, input.Position.Y)
end

local CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
local rng = Random.new()
local function randomName(length)
	local out = {}
	for i = 1, length do
		local n = rng:NextInteger(1, #CHARS)
		out[i] = CHARS:sub(n, n)
	end
	return table.concat(out)
end

-- Highest place available: hidden UI container > CoreGui > PlayerGui
local function parentGui(gui)
	local targets = {}
	if gethui then
		local ok, container = pcall(gethui)
		if ok and container then targets[#targets + 1] = container end
	end
	local okCore, coreGui = pcall(function() return game:GetService("CoreGui") end)
	if okCore and coreGui then targets[#targets + 1] = coreGui end
	targets[#targets + 1] = playerGui

	for _, target in ipairs(targets) do
		local ok = pcall(function() gui.Parent = target end)
		if ok and gui.Parent == target then return end
	end
end

-- Running this again replaces the old overlay instead of stacking a second one
local function removeOld()
	local function scan(container)
		if not container then return end
		local ok, children = pcall(function() return container:GetChildren() end)
		if not ok then return end
		for _, child in ipairs(children) do
			if child:IsA("ScreenGui") and child:GetAttribute(TAG) then child:Destroy() end
		end
	end
	for _, inst in ipairs(CollectionService:GetTagged(TAG)) do
		if inst:IsA("ScreenGui") then inst:Destroy() end
	end
	scan(playerGui)
	pcall(function() scan(game:GetService("CoreGui")) end)
	if gethui then pcall(function() scan(gethui()) end) end
end
removeOld()

----------------------------------------------------------------
-- Saved position (kept in a file, so it survives between sessions)
----------------------------------------------------------------
local canUseFiles = type(writefile) == "function" and type(readfile) == "function" and type(isfile) == "function"
local memoryStore = _G
pcall(function()
	if getgenv then memoryStore = getgenv() end
end)

local function loadPosition()
	local raw
	if canUseFiles then
		local ok, result = pcall(function()
			if isfile(SAVE_FILE) then return HttpService:JSONDecode(readfile(SAVE_FILE)) end
			return nil
		end)
		if ok then raw = result end
	else
		raw = memoryStore.KeyboardOverlayPosition
	end
	if type(raw) == "table" and type(raw.x) == "number" and type(raw.y) == "number" then
		return Vector2.new(raw.x, raw.y)
	end
	return nil
end

local function savePosition(fraction)
	if not SAVE_POSITION then return end
	local data = { x = fraction.X, y = fraction.Y }
	if canUseFiles then
		pcall(function()
			writefile(SAVE_FILE, HttpService:JSONEncode(data))
		end)
	else
		memoryStore.KeyboardOverlayPosition = data
	end
end

----------------------------------------------------------------
-- Work out the size of the keyboard
----------------------------------------------------------------
local PITCH = KEY_SIZE + KEY_GAP -- distance from one key to the next

local rowWidth = {}
local widest = 0
for index, row in ipairs(ROWS) do
	local total = 0
	for _, key in ipairs(row) do total += key.width end
	rowWidth[index] = total
	widest = math.max(widest, total)
end

-- Leaning keys: each key is a parallelogram. At the top it is shifted right (or left) by `shear`
-- compared to the bottom, so the board needs that much extra room at the sides.
local tiltRadians = math.rad(math.clamp(TILT, -45, 45))
local shear = KEY_SIZE * math.abs(math.tan(tiltRadians))
local sideInset = PADDING + shear / 2

local boardWidth = widest * PITCH - KEY_GAP + sideInset * 2
local boardHeight = #ROWS * PITCH - KEY_GAP + PADDING * 2
local halfWidth = boardWidth / 2
local halfHeight = boardHeight / 2

----------------------------------------------------------------
-- Build the overlay
----------------------------------------------------------------
local screenGui = make("ScreenGui", {
	Name = randomName(20),
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	DisplayOrder = DISPLAY_ORDER,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, nil)
screenGui:SetAttribute(TAG, true)
CollectionService:AddTag(screenGui, TAG)
parentGui(screenGui)

local function viewport()
	local size = screenGui.AbsoluteSize
	if size.X < 1 or size.Y < 1 then
		size = workspace.CurrentCamera.ViewportSize
	end
	return size
end

-- keeps the whole keyboard on the screen
local function clampCenter(center)
	local v = viewport()
	local minX, minY = halfWidth + SCREEN_MARGIN, halfHeight + SCREEN_MARGIN
	return Vector2.new(
		math.clamp(center.X, minX, math.max(minX, v.X - minX)),
		math.clamp(center.Y, minY, math.max(minY, v.Y - minY))
	)
end

local center
do
	local v = viewport()
	local saved = SAVE_POSITION and loadPosition() or nil
	if saved then
		center = Vector2.new(v.X * saved.X, v.Y * saved.Y)
	else
		center = Vector2.new(v.X * SPAWN.X, v.Y * SPAWN.Y)
	end
	center = clampCenter(center)
end

local board = make("Frame", {
	Name = "Board",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromOffset(math.floor(center.X), math.floor(center.Y)),
	Size = UDim2.fromOffset(boardWidth, boardHeight),
	BackgroundColor3 = backgroundColor,
	BackgroundTransparency = BACKGROUND_TRANSPARENCY,
	BorderSizePixel = 0,
	ZIndex = 1,
}, screenGui)
make("UICorner", { CornerRadius = UDim.new(0, 10) }, board)

-- The keys: every row starts at the left, so the wider keys (Tab, Caps, Shift) push the letters over
-- a little more on each row, just like on a real keyboard.
-- A leaning key is made from a tall, rotated bar that is cut off at the top and bottom by a box the
-- height of the key (that leaves a parallelogram). The letter sits on top and is never rotated.
local keyEntries = {}
for rowIndex, row in ipairs(ROWS) do
	local x = 0
	for _, key in ipairs(row) do
		local keyWidth = key.width * PITCH - KEY_GAP

		local clip = make("Frame", {
			Name = key.label,
			Position = UDim2.fromOffset(sideInset + x * PITCH - shear / 2, PADDING + (rowIndex - 1) * PITCH),
			Size = UDim2.fromOffset(keyWidth + shear, KEY_SIZE),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			ZIndex = 2,
		}, board)
		local fill = make("Frame", {
			Name = "Fill",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(keyWidth * math.cos(tiltRadians), KEY_SIZE * 2 + keyWidth),
			Rotation = TILT,
			BackgroundColor3 = keyColor,
			BackgroundTransparency = KEY_TRANSPARENCY,
			BorderSizePixel = 0,
			ZIndex = 2,
		}, clip)
		local label = make("TextLabel", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Text = key.label,
			TextColor3 = keyTextColor,
			TextSize = TEXT_SIZE,
			Font = Enum.Font.GothamMedium,
			ZIndex = 3,
		}, clip)
		keyEntries[#keyEntries + 1] = { fill = fill, label = label, codes = key.codes, pressed = false }
		x += key.width
	end
end

-- a see-through layer over everything: it catches the dragging, so you can drag from anywhere
local dragArea = make("TextButton", {
	Name = "DragArea",
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
	Text = "",
	AutoButtonColor = false,
	Selectable = false,
	ZIndex = 10,
}, board)

----------------------------------------------------------------
-- Keys lighting up
----------------------------------------------------------------
local held = {} -- KeyCode -> true while that key is down

local function refreshKey(entry)
	local pressed = false
	for _, code in ipairs(entry.codes) do
		if held[code] then
			pressed = true
			break
		end
	end
	if pressed == entry.pressed then return end
	entry.pressed = pressed

	local info = TweenInfo.new(PRESS_FADE, Enum.EasingStyle.Linear)
	TweenService:Create(entry.fill, info, { BackgroundColor3 = pressed and pressedColor or keyColor }):Play()
	TweenService:Create(entry.label, info, { TextColor3 = pressed and pressedTextColor or keyTextColor }):Play()
end

local function refreshAll()
	for _, entry in ipairs(keyEntries) do refreshKey(entry) end
end

local connections = {}

-- Every key press counts, even while you are typing in chat or a text box
connections[#connections + 1] = UserInputService.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		held[input.KeyCode] = true
		refreshAll()
	end
end)
connections[#connections + 1] = UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		held[input.KeyCode] = nil
		refreshAll()
	end
end)
-- if the window loses focus while a key is down, let go of everything so nothing stays lit
connections[#connections + 1] = UserInputService.WindowFocusReleased:Connect(function()
	table.clear(held)
	refreshAll()
end)

----------------------------------------------------------------
-- Dragging (from anywhere on the keyboard)
----------------------------------------------------------------
local dragging = nil

dragArea.InputBegan:Connect(function(input)
	if not isPress(input) or dragging then return end
	dragging = { input = input, start = p2(input), origin = center }
	input.Changed:Connect(function()
		if input.UserInputState == Enum.UserInputState.End then
			dragging = nil
			local v = viewport()
			savePosition(Vector2.new(center.X / v.X, center.Y / v.Y))
		end
	end)
end)

connections[#connections + 1] = UserInputService.InputChanged:Connect(function(input)
	if not dragging then return end
	if input.UserInputType ~= Enum.UserInputType.MouseMovement and input ~= dragging.input then return end
	center = clampCenter(dragging.origin + (p2(input) - dragging.start))
	board.Position = UDim2.fromOffset(math.floor(center.X), math.floor(center.Y))
end)

-- if the screen changes size, keep the keyboard on it
connections[#connections + 1] = RunService.RenderStepped:Connect(function()
	local clamped = clampCenter(center)
	if clamped ~= center then
		center = clamped
		board.Position = UDim2.fromOffset(math.floor(center.X), math.floor(center.Y))
	end
end)

screenGui.Destroying:Connect(function()
	for _, c in ipairs(connections) do c:Disconnect() end
	table.clear(connections)
end)
