-- Turn Binds Keys On

-- ============================================================
-- SETTINGS
-- ============================================================
local FLAG = "TurnKeys"       -- name of this key setup (the Off script needs the same flag)
local LEFK = Enum.KeyCode.Q     -- the key you hold to turn LEFT  (change this: Enum.KeyCode.Q, Enum.KeyCode.LeftShift, "q" ...)
local RIGHK = Enum.KeyCode.E    -- the key you hold to turn RIGHT (change this: Enum.KeyCode.E, Enum.KeyCode.RightShift, "e" ...)
local PIXELS = KTB              -- how far a mouse would move every frame, in pixels (decimals work too, like 0.5)

-- The keys the script actually uses. They follow LEFK and RIGHK, so don't change these.
local LEFTKEY = LEFK
local RIGHTKEY = RIGHK

-- ============================================================
-- DO NOT EDIT BELOW THIS LINE
-- ============================================================
-- Hold the LEFT key to turn the camera left, hold the RIGHT key to turn it right.
-- Let go and it stops. Holding both cancels out. Keys are ignored while typing in a text box.
-- The turn is fed into Roblox's own camera input (like moving the mouse a tiny bit each
-- frame), so nothing is forced, only left/right is added, and no executor functions are used.
-- Run Turn Binds Keys Off (same FLAG) to switch the whole key setup off.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Flag rules: no spaces and none of these characters
local FLAG_FORBIDDEN = [===['";*()^%$+×÷=/€£¥₩`~\|<>{}[]▪︎○●□■♤♡◇♧☆⊙°•¤《》¡¿,.]===]

local function flagProblem(flag)
	if type(flag) ~= "string" or flag == "" then
		return "the flag is empty"
	end
	if flag:find("%s") then
		return "the flag contains a space"
	end
	local banned = { [160] = true, [0x200B] = true, [0x3000] = true }
	for _, cp in utf8.codes(FLAG_FORBIDDEN) do
		banned[cp] = true
	end
	for _, cp in utf8.codes(flag) do
		if banned[cp] then
			return 'the flag contains a character that is not allowed: "' .. utf8.char(cp) .. '"'
		end
	end
	return nil
end

local flagOk, problem = pcall(flagProblem, FLAG)
if not flagOk then problem = "the flag is not valid text" end
if problem then
	warn("Turn Binds Keys: " .. problem .. " (FLAG = " .. tostring(FLAG) .. ")")
	return
end

local BIND = "TurnKeys_" .. FLAG -- the On and Off scripts find each other through the flag

-- Attribute names only allow letters, numbers and underscores, so encode anything else
local ATTRIBUTE = "TurnKeysRun_" .. (FLAG:gsub("[^%w]", function(c)
	return string.format("_%02X", string.byte(c))
end))

local player = Players.LocalPlayer

local function getKey(value)
	if typeof(value) == "EnumItem" then
		if value.EnumType == Enum.KeyCode and value ~= Enum.KeyCode.Unknown then
			return value
		end
		return nil
	end
	-- a key name also works, in any letter case ("Q", "q", "LeftShift" ...)
	local wanted = string.lower(tostring(value))
	for _, item in ipairs(Enum.KeyCode:GetEnumItems()) do
		if item ~= Enum.KeyCode.Unknown and string.lower(item.Name) == wanted then
			return item
		end
	end
	return nil
end

LEFTKEY = getKey(LEFTKEY)
RIGHTKEY = getKey(RIGHTKEY)
if not LEFTKEY or not RIGHTKEY then
	warn("Turn Binds Keys: LEFK and RIGHK must be keys like Enum.KeyCode.Q or Enum.KeyCode.LeftShift (LEFK = "
		.. tostring(LEFK) .. ", RIGHK = " .. tostring(RIGHK) .. ")")
	return
end
if LEFTKEY == RIGHTKEY then
	warn("Turn Binds Keys: LEFK and RIGHK need to be different keys.")
	return
end
if type(PIXELS) ~= "number" or PIXELS <= 0 then
	warn("Turn Binds Keys: PIXELS must be a number above 0 (PIXELS = " .. tostring(PIXELS) .. ")")
	return
end

-- Roblox's camera turns about 0.5 degrees for every pixel of mouse movement
local radiansPerFrame = math.rad(PIXELS * 0.5)

-- Each run gets its own id, so running this again (same flag) replaces the old one
local runId = tostring(os.clock())
local renderName = BIND .. runId

local connections = {}
local leftHeld, rightHeld = false, false
local pending -- the shared camera-input table (nil = turn the camera directly instead)

-- Find the default camera's input module
local function findCameraInput()
	local ok, result = pcall(function()
		local playerScripts = player:WaitForChild("PlayerScripts", 3)
		local playerModule = playerScripts:WaitForChild("PlayerModule", 3)
		local cameraModule = playerModule:WaitForChild("CameraModule", 3)
		return require(cameraModule:WaitForChild("CameraInput", 3))
	end)
	if ok and type(result) == "table" and type(result.getRotation) == "function" then
		return result
	end
	return nil
end

-- Add our turn to the camera's input once per frame (shared with the other Turn Binds scripts)
local cameraInput = findCameraInput()
if cameraInput then
	local hooked = pcall(function()
		pending = cameraInput.TurnBindsPending
		if not pending then
			pending = {}
			cameraInput.TurnBindsPending = pending

			local originalGetRotation = cameraInput.getRotation
			cameraInput.getRotation = function(...)
				local rotation = originalGetRotation(...)
				if typeof(rotation) ~= "Vector2" then return rotation end

				local extra = Vector2.zero
				for flag, amount in pairs(pending) do
					extra += amount
					pending[flag] = Vector2.zero -- used up, so it only counts once per frame
				end
				return rotation + extra
			end
		end
	end)
	if not hooked then pending = nil end
end
if not pending then
	warn("Turn Binds Keys: the default camera input wasn't found, turning the camera directly instead.")
end

-- Stop system: clears any turn that is still waiting for the next frame
local function stopTurning()
	if pending then pending[BIND] = Vector2.zero end
end

local function releaseAll()
	leftHeld, rightHeld = false, false
	stopTurning()
end

-- Shut everything down (used by the Off script and when this script gets replaced)
local function shutdown()
	pcall(function()
		RunService:UnbindFromRenderStep(renderName)
	end)
	for _, c in ipairs(connections) do c:Disconnect() end
	table.clear(connections)
	releaseAll()
end

-- Keys
connections[#connections + 1] = UserInputService.InputBegan:Connect(function(input)
	if UserInputService:GetFocusedTextBox() then return end
	if input.KeyCode == LEFTKEY then
		leftHeld = true
	elseif input.KeyCode == RIGHTKEY then
		rightHeld = true
	end
end)

connections[#connections + 1] = UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == LEFTKEY then
		leftHeld = false
	elseif input.KeyCode == RIGHTKEY then
		rightHeld = false
	else
		return
	end
	if not leftHeld and not rightHeld then stopTurning() end
end)

-- If the window loses focus or a text box takes over while a key is down, let go of everything
connections[#connections + 1] = UserInputService.WindowFocusReleased:Connect(releaseAll)
connections[#connections + 1] = UserInputService.TextBoxFocused:Connect(releaseAll)

-- The turn itself: runs every frame, just before the camera reads its input
local function turn()
	local direction = (rightHeld and 1 or 0) - (leftHeld and 1 or 0) -- 1 = right, -1 = left, 0 = none
	if direction == 0 then return end

	if pending then
		pending[BIND] = Vector2.new(direction * radiansPerFrame, 0)
	else
		local camera = workspace.CurrentCamera
		if not camera then return end

		local pivot = camera.CFrame.Position
		if camera.CameraType == Enum.CameraType.Custom then
			pivot = camera.Focus.Position
		end
		camera.CFrame = CFrame.new(pivot) * CFrame.Angles(0, -direction * radiansPerFrame, 0) * CFrame.new(-pivot) * camera.CFrame
	end
end

local priority = pending and Enum.RenderPriority.Input.Value or Enum.RenderPriority.Camera.Value + 1
RunService:BindToRenderStep(renderName, priority, turn)

-- The Off script (or a newer run with the same flag) changes this, which shuts this run down
player:SetAttribute(ATTRIBUTE, runId)
connections[#connections + 1] = player:GetAttributeChangedSignal(ATTRIBUTE):Connect(function()
	if player:GetAttribute(ATTRIBUTE) ~= runId then shutdown() end
end)
