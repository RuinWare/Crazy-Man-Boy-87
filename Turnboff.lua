-- Turn Binds Keys Off

-- ============================================================
-- SETTINGS
-- ============================================================
local FLAG = "TurnKeys"       -- the flag of the key setup to switch off (same as in Turn Binds Keys On)

-- ============================================================
-- DO NOT EDIT BELOW THIS LINE
-- ============================================================
-- Switches the whole key setup with this flag off: the keys stop doing anything and any
-- turning stops right away. Run Turn Binds Keys On again to switch it back on.

local Players = game:GetService("Players")

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

Players.LocalPlayer:SetAttribute(ATTRIBUTE, false)
