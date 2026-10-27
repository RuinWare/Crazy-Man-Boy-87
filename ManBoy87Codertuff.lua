-- RUINWARE V.0.0
-- CRAZY TUFF SCRIPT
-- ONE EXTRA LINE OF CODE
-- ONE MORE
-- DONT ATTEMPT TO: STEAL, HARVEST, DEOBF RUINWARE. DO NOT DISTRIBUTE WITHOUT PERMISSION FROM STAFF, COPYRIGHT 2026, RuinWare

-- RW WARNINGS
print("RuinWare Loaded.")
print("RuinWare Copyright 2026©")
warn("⚠️ ANY ATTEMPT TO CRACK, DEOBFUSCATE THIS SCRIPT WILL NOT BE TOLERATED. MAY RESULT IN A BAN AND OR LEGAL ACTION.")


-- Load main
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/gen2"))()

--[[
============================================================================

E     M     O     T     E          L     O     G     I     C

============================================================================
]]--


local function buildEmoteChanger(tab, window)
	local ReplicatedStorage = game:GetService("ReplicatedStorage")

	local PATHS = {
		{"Items","ItemPacks","Gamepass","Unorganized","EmotePack","Emotes"},
		{"Items","ItemPacks","Gamepass","Unorganized","EclipseSet","Emotes"},
		{"Items","ItemPacks","Gamepass","Unorganized","DogSet","Emotes"},
		{"Items","ItemPacks","Gamepass","Unorganized","Cats","Emotes"},
		{"Items","ItemPacks","Gamepass","Unorganized","Animals","Emotes"},
		{"Items","ItemPacks","Gamepass","Legacy","StPatricks2023","Emotes"},
		{"Items","ItemPacks","Gamepass","Legacy","Military","Emotes"},
		{"Items","ItemPacks","Gamepass","2026","RelicEmotesNew","Emotes"},
		{"Items","ItemPacks","Gamepass","2026","PoseidonSet","Emotes"},
		{"Items","ItemPacks","Gamepass","2026","BeeSet","Emotes"},
		{"Items","ItemPacks","EventsDailyShop","Thanksgiving2025","Emotes"},
		{"Items","ItemPacks","EventsDailyShop","OldRoblox","Emotes"},
		{"Items","ItemPacks","EventsDailyShop","NewYears2024","Emotes"},
		{"Items","ItemPacks","EventsDailyShop","LunarNewYear","Emotes"},
		{"Items","ItemPacks","Events","2026","Valentines2026","Emotes"},
		{"Items","ItemPacks","Events","2026","StPatricks2026","Emotes"},
		{"Items","ItemPacks","Events","2026","Spring2026","Emotes"},
		{"Items","ItemPacks","Events","2026","SUMMER26","Emotes"},
		{"Items","ItemPacks","Events","2026","HLWN2026","Emotes"},
		{"Items","ItemPacks","Events","2025","XMAS25","Emotes","DailyShop"},
		{"Items","ItemPacks","Events","2025","XMAS25","Emotes","Battlepass"},
		{"Items","ItemPacks","Events","2025","Valentines2025","Emotes"},
		{"Items","ItemPacks","Events","2025","Summer2025","Emotes"},
		{"Items","ItemPacks","Events","2025","StPatricks2025","Emotes"},
		{"Items","ItemPacks","Events","2025","Hlwn2025","Emotes"},
		{"Items","ItemPacks","Events","2024","Xmas2024","Emotes"},
		{"Items","ItemPacks","Events","2024","Valentines2024","Emotes"},
		{"Items","ItemPacks","Events","2024","StPatricks2024","Emotes"},
		{"Items","ItemPacks","Events","2024","Hlwn2024","Emotes"},
		{"Items","ItemPacks","Events","2024","Halloween2024","Emotes"},
		{"Items","ItemPacks","Events","2023","Hlwn2023","Emotes"},
		{"Items","ItemPacks","Events","2023","Halloween2023","Emotes"},
		{"Items","ItemPacks","Events","2023","Xmas2023","Emotes"},
		{"Items","ItemPacks","Events","2023","Valentines2023","Emotes"},
		{"Items","ItemPacks","Events","2023","StPatricks2023","Emotes"},
		{"Items","ItemPacks","Events","2023","Summer2023","Emotes"},
		{"Items","ItemPacks","Events","2022","Hlwn2022","Emotes"},
		{"Items","ItemPacks","Events","2022","Halloween2022","Emotes"},
		{"Items","ItemPacks","Events","2022","Xmas2022","Emotes"},
		{"Items","ItemPacks","Events","2022","Valentines2022","Emotes"},
		{"Items","ItemPacks","Collab","ST","Emotes"},
		{"Items","ItemPacks","Base","Special","Emotes"},
		{"Items","ItemPacks","Base","NewShop","Emotes"},
		{"Items","ItemPacks","Base","LevelShop","Emotes"},
		{"Items","ItemPacks","Base","DailyShop","Emotes"},
		{"Items","BaseItems","Emotes"},
		{"Items","ItemPacks","Integration","M3GAN","Emotes"},
		{"Items","ItemPacks","Gamepass","Unorganized","Gems","Emotes"},
		{"Items","ItemPacks","Gamepass","Unorganized","LunarNewYearSet","Emotes"},
		{"Items","ItemPacks","Gamepass","Unorganized","MusicEmotesPack1","Emotes"},
		{"Items","ItemPacks","Gamepass","Unorganized","RelicEmotesVaulted","Emotes"},
	}

	local EXPAND_NAMES       = { battlepass = true, dailyshop = true, admin = true }
	local ROCKINSTRIDE_SOUND = 114846968069031

	local _snapshots      = {}
	local _displayNames   = {}
	local _emoteCache     = nil
	local variantState    = {}
	local selectedVariant = 1

	local state = {
		Current       = nil,
		SuggestedText = nil,
		Dropdown      = nil,
		UseTextbox    = false,
	}

	local function resolvePath(keys)
		local ok, result = pcall(function()
			local obj = ReplicatedStorage
			for _, k in ipairs(keys) do obj = obj[k] end
			return obj
		end)
		if ok and typeof(result) == "Instance" then return result end
		return nil
	end

	local function getItemScript(item)
		if item:IsA("ModuleScript") then return item end
		for _, c in ipairs(item:GetChildren()) do
			if c:IsA("ModuleScript") then return c end
		end
		return nil
	end

	local function takeSnapshot(item)
		if _snapshots[item] then return end
		local script = getItemScript(item)
		local dataSnap = nil
		if script then
			local ok, data = pcall(require, script)
			if ok and type(data) == "table" then
				dataSnap = {}
				for k, v in pairs(data) do
					if type(v) == "table" then
						local sub = {}
						for k2, v2 in pairs(v) do sub[k2] = v2 end
						dataSnap[k] = sub
					else
						dataSnap[k] = v
					end
				end
			end
		end
		local childrenSnap = {}
		for _, c in ipairs(item:GetChildren()) do
			table.insert(childrenSnap, c:Clone())
		end
		_snapshots[item] = { data = dataSnap, children = childrenSnap }
	end

	local function getDisplayName(item)
		takeSnapshot(item)
		local cached = _displayNames[item]
		if cached then return cached end
		local script = getItemScript(item)
		if script then
			local ok, data = pcall(require, script)
			if ok and type(data) == "table"
				and type(data.AppearanceInfo) == "table"
				and type(data.AppearanceInfo.Name) == "string" then
				_displayNames[item] = data.AppearanceInfo.Name
				return data.AppearanceInfo.Name
			end
		end
		return item.Name
	end

	local function resetItem(item)
		local snap = _snapshots[item]
		if not snap then return false end
		if snap.data then
			local script = getItemScript(item)
			if script then
				local ok, data = pcall(require, script)
				if ok and type(data) == "table" then
					pcall(function()
						for k, v in pairs(snap.data) do
							if type(v) == "table" then
								data[k] = data[k] or {}
								for k2, v2 in pairs(v) do data[k][k2] = v2 end
							else
								data[k] = v
							end
						end
					end)
				end
			end
		end
		for _, c in ipairs(item:GetChildren()) do c:Destroy() end
		for _, c in ipairs(snap.children) do
			pcall(function() c:Clone().Parent = item end)
		end
		variantState[item] = nil
		return true
	end

	local function syncEmoteScript(target, source)
		local tScript = getItemScript(target)
		local sScript = getItemScript(source)
		if not tScript or not sScript then return end
		local ok1, tData = pcall(require, tScript)
		local ok2, sData = pcall(require, sScript)
		if not ok1 or not ok2 then return end
		if type(tData) ~= "table" or type(sData) ~= "table" then return end

		pcall(function()
			if type(tData.AppearanceInfo) == "table" and type(sData.AppearanceInfo) == "table" then
				tData.AppearanceInfo.Name    = sData.AppearanceInfo.Name
				tData.AppearanceInfo.Desc    = sData.AppearanceInfo.Desc
				tData.AppearanceInfo.Creator = sData.AppearanceInfo.Creator
			end
			if type(tData.UIInfo) == "table" and type(sData.UIInfo) == "table" then
				tData.UIInfo.Header = sData.UIInfo.Header
				tData.UIInfo.Rarity = sData.UIInfo.Rarity
			end
			if type(tData.EmoteInfo) == "table" and type(sData.EmoteInfo) == "table" then
				tData.EmoteInfo.SpeedMult = sData.EmoteInfo.SpeedMult
				if source.Name == "RockinStride" then
					tData.EmoteInfo.Sound = ROCKINSTRIDE_SOUND
				else
					tData.EmoteInfo.Sound = sData.EmoteInfo.Sound
				end
			end
		end)
	end

	local function getEmoteItems()
		if _emoteCache then return _emoteCache end
		local all, seen = {}, {}
		for _, path in ipairs(PATHS) do
			local f = resolvePath(path)
			if f then
				for _, child in ipairs(f:GetChildren()) do
					if child:IsA("Folder") and EXPAND_NAMES[child.Name:lower()] then
						for _, inner in ipairs(child:GetChildren()) do
							if not seen[inner] then seen[inner] = true; table.insert(all, inner) end
						end
					else
						if not seen[child] then seen[child] = true; table.insert(all, child) end
					end
				end
			end
		end
		_emoteCache = all
		return all
	end

	local function findEmote(name)
		if not name then return nil end
		local target = name:lower():match("^%s*(.-)%s*$")
		if target == "" then return nil end
		for _, it in ipairs(getEmoteItems()) do
			if it.Name:lower() == target or getDisplayName(it):lower() == target then
				return it
			end
		end
		return nil
	end

	local function buildEmoteList()
		local names, seen = {}, {}
		for _, it in ipairs(getEmoteItems()) do
			local dn = getDisplayName(it)
			if not seen[dn] then seen[dn] = true; table.insert(names, dn) end
		end
		table.sort(names)
		return names
	end

	local function cacheVariants(emote)
		local sel = emote:FindFirstChild("Selection")
		if not sel then return end
		local cache = {}
		for i = 1, 3 do
			local v = sel:FindFirstChild(tostring(i))
			if v then
				local kids = {}
				for _, c in ipairs(v:GetChildren()) do table.insert(kids, c:Clone()) end
				cache[i] = kids
			end
		end
		if next(cache) then
			variantState[emote] = { cache = cache, applied = nil }
			sel:Destroy()
		end
	end

	local function applyVariant(emote)
		local s = variantState[emote]
		if not s or s.applied == selectedVariant then return end
		local kids = s.cache[selectedVariant]
		if not kids then return end
		for _, c in ipairs(emote:GetChildren()) do c:Destroy() end
		for _, c in ipairs(kids) do
			pcall(function() c:Clone().Parent = emote end)
		end
		s.applied = selectedVariant
	end
--[[
============================================================================
E     D     I     T     S
============================================================================
]]--
        tab:CreateDivider({ text = "Emote Changer" })
	tab:CreateToggle({
		name = "Use Textbox",
                icon = 131412776187171,
		value = false,
		callback = function(v) state.UseTextbox = v end,
	})

	tab:CreateInput({
		name = "Current Emote",
                icon = 75272415197329,
		placeholder = "e.g. Smug Dance",
		callback = function(text)
			local found = findEmote(text)
			state.Current = found
			window:Notify({
				title = "Emote Swapper",
				content = found and ("Found: "..getDisplayName(found)) or ("Not found: "..text),
				duration = 3,
			})
		end,
	})

	tab:CreateInput({
		name = "Suggested Emote",
                icon = 74401506935851,
		placeholder = "e.g. Broom of Doom",
		callback = function(text)
			local found = findEmote(text)
			state.SuggestedText = found
			window:Notify({
				title = "Emote Swapper",
				content = found and ("Found: "..getDisplayName(found)) or ("Not found: "..text),
				duration = 3,
			})
		end,
	})

	tab:CreateInput({
		name = "Variant",
                icon = 138273988376377,
		placeholder = "1",
		numeric = true,
		callback = function(text)
			local n = tonumber(text)
			if n and n >= 1 and n <= 3 then
				selectedVariant = math.floor(n)
				for _, s in pairs(variantState) do s.applied = nil end
			end
		end,
	})

	local EmoteDropdown = tab:CreateDropdown({
		name = "Emote List",
                icon = 119388489350677,
		options = buildEmoteList(),
		multiSelect = false,
		callback = function(selected)
			local picked = type(selected) == "table" and selected[1] or selected
			state.Dropdown = findEmote(picked)
		end,
	})

	tab:CreateButton({
		name = "Change Emotes",
        icon = 96709237281649,
		callback = function()
			local target = state.Current
			if not target then
				window:Notify({ title = "Emote Swapper", content = "Current emote not found.", duration = 5 })
				return
			end
			local source = state.UseTextbox and state.SuggestedText or state.Dropdown
			if not source then
				window:Notify({ title = "Emote Swapper", content = "Suggested emote not found.", duration = 5 })
				return
			end
			if target == source then
				local ok = resetItem(target)
				window:Notify({
					title = "Emote Swapper",
					content = ok and ("Reset "..target.Name.." to default.") or "No snapshot available to reset.",
					duration = 5,
				})
				return
			end
			variantState[target] = nil
			for _, c in ipairs(target:GetChildren()) do c:Destroy() end
			local n = 0
			for _, c in ipairs(source:GetChildren()) do
				local ok = pcall(function() c:Clone().Parent = target end)
				if ok then n += 1 end
			end
			syncEmoteScript(target, source)
			window:Notify({
				title = "Emote Swapper",
				content = ("Swapped %s -> %s (%d)"):format(target.Name, getDisplayName(source), n),
				duration = 5,
			})
		end,
	})

	task.spawn(function()
		task.wait(2)
		while true do
			for _, emote in ipairs(getEmoteItems()) do
				if not variantState[emote] and emote:FindFirstChild("Selection") then
					cacheVariants(emote)
				end
			end
			for emote, s in pairs(variantState) do
				if not emote.Parent then
					variantState[emote] = nil
				else
					pcall(applyVariant, emote)
				end
			end
			task.wait(1)
		end
	end)

	task.delay(5, function()
		pcall(function()
			_emoteCache = nil
			EmoteDropdown:SetOptions(buildEmoteList())
		end)
	end)
end

--[[
============================================================================

C     O     S     M     E     T     I     C          L     O     G     I     C

============================================================================
]]--

local function buildCosmeticChanger(tab, window)
	local ReplicatedStorage = game:GetService("ReplicatedStorage")

	local COSMETIC_PATHS = {
		{"Items","ItemPacks","Gamepass","Legacy","StPatricks2023","Cosmetics"},
		{"Items","ItemPacks","Base","Admin","Cosmetics"},
		{"Items","ItemPacks","Gamepass","Legacy","Military","Cosmetics"},
		{"Items","ItemPacks","Gamepass","2026","PoseidonSet","Cosmetics"},
		{"Items","ItemPacks","Gamepass","2026","BeeSet","Cosmetics"},
		{"Items","ItemPacks","EventsDailyShop","OldRoblox","Cosmetics"},
		{"Items","ItemPacks","EventsDailyShop","NewYears2024","Cosmetics"},
		{"Items","ItemPacks","EventsDailyShop","LunarNewYear","Cosmetics"},
		{"Items","ItemPacks","EventsDailyShop","Easter","Cosmetics"},
		{"Items","ItemPacks","EventsDailyShop","Birthday25","Cosmetics"},
		{"Items","ItemPacks","EventsDailyShop","Anniversary26","Cosmetics"},
		{"Items","ItemPacks","Collab","TowerBlitz","Cosmetics"},
		{"Items","ItemPacks","Base","UpperLevel","Cosmetics"},
		{"Items","ItemPacks","Base","Special","Cosmetics"},
		{"Items","ItemPacks","Base","ForsakenCollabUpdate","Cosmetics"},
		{"Items","ItemPacks","Base","DailyShop","Cosmetics","UnusualNew2"},
		{"Items","ItemPacks","Base","DailyShop","Cosmetics","UnusualNew"},
		{"Items","ItemPacks","Base","DailyShop","Cosmetics","Unusual"},
		{"Items","ItemPacks","Base","DailyShop","Cosmetics","Normal"},
		{"Items","ItemPacks","Base","DailyShop","Cosmetics","Character"},
		{"Items","ItemPacks","Gamepass","Unorganized","Animals","Cosmetics"},
		{"Items","ItemPacks","Gamepass","Unorganized","RetroCosmeticsSet","Cosmetics"},
		{"Items","ItemPacks","Gamepass","Unorganized","LunarNewYearSet","Cosmetics"},
		{"Items","ItemPacks","Gamepass","Unorganized","Gems","Cosmetics"},
		{"Items","ItemPacks","Gamepass","Unorganized","Future","Cosmetics"},
		{"Items","ItemPacks","Gamepass","Unorganized","EclipseSet","Cosmetics"},
		{"Items","ItemPacks","Gamepass","Unorganized","DogSet","Cosmetics"},
		{"Items","ItemPacks","Gamepass","Unorganized","Cats","Cosmetics"},
		{"Items","ItemPacks","Events","2026","HLWN2026","Cosmetics"},
		{"Items","ItemPacks","Events","2024","Halloween2024","Cosmetics"},
		{"Items","ItemPacks","Events","2024","Halloween2024","Cosmetics","HLWN24EXCLUSIVE"},
		{"Items","ItemPacks","Events","2023","Valentines2023","Cosmetics"},
		{"Items","ItemPacks","Events","2023","Christmas2023","Cosmetics"},
		{"Items","ItemPacks","Events","2022","Xmas2022","Cosmetics"},
		{"Items","ItemPacks","Events","2022","Xmas2022","Cosmetics","XMASExclusive"},
		{"Items","ItemPacks","Events","2022","Xmas2022","Cosmetics","XMasGamepass"},
		{"Items","ItemPacks","Events","2022","Halloween2022","Cosmetics"},
		{"Items","ItemPacks","Events","2022","Halloween2022","Cosmetics","HalloweenExclusive"},
		{"Items","ItemPacks","Events","2026","Valentines2026","Cosmetics"},
		{"Items","ItemPacks","Events","2026","StPatricks2026","Cosmetics"},
		{"Items","ItemPacks","Events","2026","Spring2026","Cosmetics"},
		{"Items","ItemPacks","Events","2026","SUMMER26","Cosmetics"},
		{"Items","ItemPacks","Events","2025","XMAS25","Cosmetics"},
		{"Items","ItemPacks","Events","2025","Valentines2025","Cosmetics"},
		{"Items","ItemPacks","Events","2025","Summer2025","Cosmetics"},
		{"Items","ItemPacks","Events","2025","StPatricks2025","Cosmetics"},
		{"Items","ItemPacks","Events","2025","Hlwn2025","Cosmetics"},
		{"Items","ItemPacks","Events","2024","Xmas2024","Cosmetics"},
		{"Items","ItemPacks","Events","2024","Valentines2024","Cosmetics"},
		{"Items","ItemPacks","Events","2024","StPatricks2024","Cosmetics"},
	}

	local _snapshots    = {}
	local _displayNames = {}
	local _cosmeticCache = nil

	local state = {
		Current       = nil,
		SuggestedText = nil,
		Dropdown      = nil,
		UseTextbox    = false,
	}

	local function resolvePath(keys)
		local ok, result = pcall(function()
			local obj = ReplicatedStorage
			for _, k in ipairs(keys) do obj = obj[k] end
			return obj
		end)
		if ok and typeof(result) == "Instance" then return result end
		return nil
	end

	local function buildContainerKeys(paths)
		local set = {}
		for _, p in ipairs(paths) do set[table.concat(p, "/")] = true end
		return set
	end

	local function isTierFolder(name)
		local n = name:lower():match("^tier%s*(%d+)$")
		if not n then return false end
		local num = tonumber(n)
		return num and num >= 1 and num <= 40
	end

	local function enumerateFrom(inst, key, containerKeys)
		local items = {}
		for _, child in ipairs(inst:GetChildren()) do
			local childKey = key .. "/" .. child.Name
			if containerKeys[childKey] or isTierFolder(child.Name) then
				for _, it in ipairs(enumerateFrom(child, childKey, containerKeys)) do
					table.insert(items, it)
				end
			else
				table.insert(items, child)
			end
		end
		return items
	end

	local COSMETIC_CONTAINERS = buildContainerKeys(COSMETIC_PATHS)

	local function getItemScript(item)
		if item:IsA("ModuleScript") then return item end
		for _, c in ipairs(item:GetChildren()) do
			if c:IsA("ModuleScript") then return c end
		end
		return nil
	end

	local function takeSnapshot(item)
		if _snapshots[item] then return end
		local script = getItemScript(item)
		local dataSnap = nil
		if script then
			local ok, data = pcall(require, script)
			if ok and type(data) == "table" then
				dataSnap = {}
				for k, v in pairs(data) do
					if type(v) == "table" then
						local sub = {}
						for k2, v2 in pairs(v) do sub[k2] = v2 end
						dataSnap[k] = sub
					else
						dataSnap[k] = v
					end
				end
			end
		end
		local childrenSnap = {}
		for _, c in ipairs(item:GetChildren()) do
			table.insert(childrenSnap, c:Clone())
		end
		_snapshots[item] = { data = dataSnap, children = childrenSnap }
	end

	local function getDisplayName(item)
		takeSnapshot(item)
		local cached = _displayNames[item]
		if cached then return cached end
		local script = getItemScript(item)
		if script then
			local ok, data = pcall(require, script)
			if ok and type(data) == "table"
				and type(data.AppearanceInfo) == "table"
				and type(data.AppearanceInfo.Name) == "string" then
				_displayNames[item] = data.AppearanceInfo.Name
				return data.AppearanceInfo.Name
			end
		end
		return item.Name
	end

	local function resetItem(item)
		local snap = _snapshots[item]
		if not snap then return false end
		if snap.data then
			local script = getItemScript(item)
			if script then
				local ok, data = pcall(require, script)
				if ok and type(data) == "table" then
					pcall(function()
						for k, v in pairs(snap.data) do
							if type(v) == "table" then
								data[k] = data[k] or {}
								for k2, v2 in pairs(v) do data[k][k2] = v2 end
							else
								data[k] = v
							end
						end
					end)
				end
			end
		end
		for _, c in ipairs(item:GetChildren()) do c:Destroy() end
		for _, c in ipairs(snap.children) do
			pcall(function() c:Clone().Parent = item end)
		end
		return true
	end

	local function syncCosmeticScript(target, source)
		local tScript = getItemScript(target)
		local sScript = getItemScript(source)
		if not tScript or not sScript then return end
		local ok1, tData = pcall(require, tScript)
		local ok2, sData = pcall(require, sScript)
		if not ok1 or not ok2 then return end
		if type(tData) ~= "table" or type(sData) ~= "table" then return end

		pcall(function()
			if type(tData.AppearanceInfo) == "table" and type(sData.AppearanceInfo) == "table" then
				tData.AppearanceInfo.Name    = sData.AppearanceInfo.Name
				tData.AppearanceInfo.Desc    = sData.AppearanceInfo.Desc
				tData.AppearanceInfo.Creator = sData.AppearanceInfo.Creator
				tData.AppearanceInfo.Icon    = sData.AppearanceInfo.Icon
			end
			if type(tData.UIInfo) == "table" and type(sData.UIInfo) == "table" then
				tData.UIInfo.Header   = sData.UIInfo.Header
				tData.UIInfo.Overview = sData.UIInfo.Overview
				tData.UIInfo.Rarity   = sData.UIInfo.Rarity
			end
			if type(tData.EquipInfo) == "table" and type(sData.EquipInfo) == "table" then
				tData.EquipInfo.SlotType = sData.EquipInfo.SlotType
			end
			if type(tData.CosmeticInfo) == "table" and type(sData.CosmeticInfo) == "table" then
				tData.CosmeticInfo.Unusual = sData.CosmeticInfo.Unusual
			end
		end)
	end

	local function getCosmeticItems()
		if _cosmeticCache then return _cosmeticCache end
		local all, seen = {}, {}
		for _, path in ipairs(COSMETIC_PATHS) do
			local inst = resolvePath(path)
			if inst then
				local key = table.concat(path, "/")
				for _, it in ipairs(enumerateFrom(inst, key, COSMETIC_CONTAINERS)) do
					if not seen[it] then seen[it] = true; table.insert(all, it) end
				end
			end
		end
		_cosmeticCache = all
		return all
	end

	local function findCosmetic(name)
		if not name then return nil end
		local target = name:lower():match("^%s*(.-)%s*$")
		if target == "" then return nil end
		for _, it in ipairs(getCosmeticItems()) do
			if it.Name:lower() == target or getDisplayName(it):lower() == target then
				return it
			end
		end
		return nil
	end

	local function buildCosmeticList()
		local names, seen = {}, {}
		for _, it in ipairs(getCosmeticItems()) do
			local dn = getDisplayName(it)
			if not seen[dn] then seen[dn] = true; table.insert(names, dn) end
		end
		table.sort(names)
		return names
	end

--[[
============================================================================
E     D     I     T     S
============================================================================
]]--

        tab:CreateDivider({ text = "Cosmetic Changer" })
	tab:CreateToggle({
		name = "Use Textbox",
        icon = 131412776187171,
		value = false,
		callback = function(v) state.UseTextbox = v end,
	})

	tab:CreateInput({
		name = "Current Cosmetic",
                icon = 130515857256476,
		placeholder = "e.g. Haha",
		callback = function(text)
			local found = findCosmetic(text)
			state.Current = found
			window:Notify({
				title = "Cosmetic Swapper",
				content = found and ("Found: "..getDisplayName(found)) or ("Not found: "..text),
				duration = 3,
			})
		end,
	})

	tab:CreateInput({
		name = "Suggested Cosmetic",
                icon = 74401506935851,
		placeholder = "e.g. Blood Moon",
		callback = function(text)
			local found = findCosmetic(text)
			state.SuggestedText = found
			window:Notify({
				title = "Cosmetic Swapper",
				content = found and ("Found: "..getDisplayName(found)) or ("Not found: "..text),
				duration = 3,
			})
		end,
	})

	local CosmeticDropdown = tab:CreateDropdown({
		name = "Cosmetic List",
        icon = 94713520185581,
		options = buildCosmeticList(),
		multiSelect = false,
		callback = function(selected)
			local picked = type(selected) == "table" and selected[1] or selected
			state.Dropdown = findCosmetic(picked)
		end,
	})

	tab:CreateButton({
		name = "Change Cosmetics",
        icon = 105433648935304,
		callback = function()
			local target = state.Current
			if not target then
				window:Notify({ title = "Cosmetic Swapper", content = "Current cosmetic not found.", duration = 5 })
				return
			end
			local source = state.UseTextbox and state.SuggestedText or state.Dropdown
			if not source then
				window:Notify({ title = "Cosmetic Swapper", content = "Suggested cosmetic not found.", duration = 5 })
				return
			end
			if target == source then
				local ok = resetItem(target)
				window:Notify({
					title = "Cosmetic Swapper",
					content = ok and ("Reset "..target.Name.." to default.") or "No snapshot available to reset.",
					duration = 5,
				})
				return
			end
			for _, c in ipairs(target:GetChildren()) do c:Destroy() end
			local n = 0
			for _, c in ipairs(source:GetChildren()) do
				local ok = pcall(function() c:Clone().Parent = target end)
				if ok then n += 1 end
			end
			syncCosmeticScript(target, source)
			window:Notify({
				title = "Cosmetic Swapper",
				content = ("Swapped %s -> %s (%d)"):format(target.Name, getDisplayName(source), n),
				duration = 5,
			})
		end,
	})

	task.delay(5, function()
		pcall(function()
			_cosmeticCache = nil
			CosmeticDropdown:SetOptions(buildCosmeticList())
		end)
	end)
end

--[[
============================================================================
============================================================================




END END END END END END END END END END END END END END END END END END END








L           O          G          I          C                    E          N          D








END END END END END END END END END END END END END END END END END END END




============================================================================
============================================================================
]]--

-- WINDOW
local window = Rayfield:CreateWindow({
    name = "RuinWare Client",
    icon = 98691154054966,
    subtitle = "Evade",
    sidebarLayout = true,
    theme = "Default",
    showIcon = 98691154054966,
    showName = "RuinWare",

})

--[[
============================================================================

M     A     I     N          (     T     A     B     )

============================================================================
]]--

local tab = window:CreateTab({ name = "Main", icon = 83935746771599 })

tab:CreateDivider({ text = "Movement" })

--[[
============================================================================
AUTO JUMP
============================================================================
]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local autoJumpEnabled = false
local lookDownOnly = false
local moveOnly = false
local rampProtection = false

local moveHoldThreshold = 0
local moveAccum = 0
local wasMovingCheck = false
local wasGroundedCheck = true
local airborneStartCheck = 0
local groundStoppedAtCheck = 0
local lastTickCheck = 0

local STOP_GRACE = 0.6
local AIR_GRACE = 5.0

local LOOK_DOWN_THRESHOLD = -0.7

local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude

local function isGroundFlat(root)
    if not rampProtection then return true end
    local result = workspace:Raycast(root.Position, Vector3.new(0, -10, 0), rayParams)
    if not result then return false end
    local angle = math.deg(math.acos(result.Normal.Unit.Y))
    return angle <= 8
end

local function isLookingDownEnough()
    if not lookDownOnly then return true end
    local cam = workspace.CurrentCamera
    if not cam then return false end
    return cam.CFrame.LookVector.Y <= LOOK_DOWN_THRESHOLD
end

local function isMoving(hum)
    local moving = hum.MoveDirection.Magnitude > 0
    local grounded = hum.FloorMaterial ~= Enum.Material.Air
    local now = tick()

    if lastTickCheck == 0 then lastTickCheck = now end
    local dt = now - lastTickCheck
    lastTickCheck = now
    if dt < 0 or dt > 0.5 then dt = 0 end

    if moving and grounded and wasMovingCheck then
        moveAccum = moveAccum + dt
    end

    if not grounded and wasGroundedCheck then
        if groundStoppedAtCheck > 0 and (now - groundStoppedAtCheck) >= STOP_GRACE then
            moveAccum = 0
        end
        groundStoppedAtCheck = 0
        airborneStartCheck = now
    elseif grounded and not wasGroundedCheck then
        local airtime = airborneStartCheck > 0 and (now - airborneStartCheck) or 0
        airborneStartCheck = 0
        if airtime >= AIR_GRACE then
            moveAccum = 0
        end
        if not moving then
            groundStoppedAtCheck = now
        end
    end
    wasGroundedCheck = grounded

    if not moving then
        if wasMovingCheck and grounded then
            groundStoppedAtCheck = now
        end
        wasMovingCheck = false
    else
        if not wasMovingCheck then
            if groundStoppedAtCheck > 0 and grounded and (now - groundStoppedAtCheck) >= STOP_GRACE then
                moveAccum = 0
            end
            wasMovingCheck = true
        end
        groundStoppedAtCheck = 0
    end

    if not moveOnly then return true end
    if not moving then return false end
    return moveAccum >= moveHoldThreshold
end

local function tryJump(hum, root)
    if not autoJumpEnabled then return end
    if hum.Health <= 0 then return end
    if not isGroundFlat(root) then return end
    if not isLookingDownEnough() then return end
    if not isMoving(hum) then return end
    hum:ChangeState(Enum.HumanoidStateType.Jumping)
end

local stateConn

local function attachToCharacter(char)
    local hum = char:WaitForChild("Humanoid")
    local root = char:WaitForChild("HumanoidRootPart")

    rayParams.FilterDescendantsInstances = {char}

    if stateConn then stateConn:Disconnect() end
    stateConn = hum.StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Landed
        or newState == Enum.HumanoidStateType.Running
        or newState == Enum.HumanoidStateType.RunningNoPhysics then
            tryJump(hum, root)
        end
    end)
end

if player.Character then
    task.spawn(attachToCharacter, player.Character)
end
player.CharacterAdded:Connect(function(char)
    task.spawn(attachToCharacter, char)
end)

RunService.PreSimulation:Connect(function()
    if not autoJumpEnabled then return end
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end
    if hum.FloorMaterial == Enum.Material.Air then return end
    tryJump(hum, root)
end)

tab:CreateToggle({
    name = "Auto Jump",
    icon = 109475752270721,
    currentValue = false,
    flag = "AutoJump_Toggle",
    callback = function(value)
        autoJumpEnabled = value
    end,
})

tab:CreateToggle({
    name = "Ramp Protection",
    icon = 111308594268728,
    currentValue = false,
    flag = "AutoJump_RampProtection_Toggle",
    callback = function(value)
        rampProtection = value
    end,
})

tab:CreateToggle({
    name = "Only Trigger On Look Down",
    icon = 128804949999663,
    currentValue = false,
    flag = "AutoJump_LookDown_Toggle",
    callback = function(value)
        lookDownOnly = value
    end,
})

tab:CreateToggle({
    name = "Only Trigger On Move",
    icon = 135743813499745,
    currentValue = false,
    flag = "AutoJump_MoveOnly_Toggle",
    callback = function(value)
        moveOnly = value
    end,
})

tab:CreateSlider({
    name = "Move Hold Time",
    icon = 136077598178846,
    range = {0, 5},
    increment = 0.05,
    suffix = "s",
    currentValue = 0,
    flag = "AutoJump_MoveHold",
    callback = function(value)
        moveHoldThreshold = value
    end,
})

--[[
============================================================================
LEGIT JUMP
============================================================================
]]--

do
    local djEnabled = false
    local djRamp = false
    local djLookDown = false
    local djMoveOnly = false
    local djMoveHold = 0

    local djRay = RaycastParams.new()
    djRay.FilterType = Enum.RaycastFilterType.Exclude

    local djTickCount = 0
    local djTargetTick = 0
    local djLanded = false
    local djMoveAccum = 0
    local djWasMoving = false
    local djLastTick = 0

    local DJ_LOOK_THRESH = -0.7

    local function djFlat(root)
        if not djRamp then return true end
        local r = workspace:Raycast(root.Position, Vector3.new(0, -10, 0), djRay)
        if not r then return false end
        return math.deg(math.acos(r.Normal.Unit.Y)) <= 8
    end

    local function djLookOK()
        if not djLookDown then return true end
        local cam = workspace.CurrentCamera
        if not cam then return false end
        return cam.CFrame.LookVector.Y <= DJ_LOOK_THRESH
    end

    local function djMoving(hum)
        local moving = hum.MoveDirection.Magnitude > 0
        local now = tick()
        local dt = now - djLastTick
        djLastTick = now
        if dt < 0 or dt > 0.5 then dt = 0 end
        if moving and djWasMoving then djMoveAccum = djMoveAccum + dt end
        if not moving then djMoveAccum = 0 end
        djWasMoving = moving
        if not djMoveOnly then return true end
        return moving and djMoveAccum >= djMoveHold
    end

    local djConn

    local function djAttach(char)
        local hum = char:WaitForChild("Humanoid")
        local root = char:WaitForChild("HumanoidRootPart")
        djRay.FilterDescendantsInstances = {char}
        if djConn then djConn:Disconnect() end
        djConn = hum.StateChanged:Connect(function(_, s)
            if s == Enum.HumanoidStateType.Landed then
                djTickCount = 0
                djTargetTick = math.random(2, 6)
                djLanded = true
            end
        end)
    end

    if player.Character then task.spawn(djAttach, player.Character) end
    player.CharacterAdded:Connect(function(c) task.spawn(djAttach, c) end)

    RunService.PreSimulation:Connect(function()
        if not djEnabled then return end
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root then return end
        if hum.Health <= 0 then return end
        if hum.FloorMaterial == Enum.Material.Air then
            djLanded = false
            return
        end
        if not djLanded then return end
        if not djFlat(root) then return end
        if not djLookOK() then return end
        if not djMoving(hum) then return end
        djTickCount = djTickCount + 1
        if djTickCount >= djTargetTick then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
            djLanded = false
        end
    end)

    tab:CreateDivider()

    tab:CreateToggle({
        name = "Legit Jump",
        icon = 109475752270721,
        currentValue = false,
        flag = "DelayJump_Toggle",
        callback = function(v) djEnabled = v end,
    })

    tab:CreateToggle({
        name = "Legit Jump Ramp Protection",
        icon = 111308594268728,
        currentValue = false,
        flag = "DelayJump_Ramp_Toggle",
        callback = function(v) djRamp = v end,
    })

    tab:CreateToggle({
        name = "Legit Jump Only Look Down",
        icon = 128804949999663,
        currentValue = false,
        flag = "DelayJump_LookDown_Toggle",
        callback = function(v) djLookDown = v end,
    })

    tab:CreateToggle({
        name = "Legit Jump Only On Move",
        icon = 135743813499745,
        currentValue = false,
        flag = "DelayJump_MoveOnly_Toggle",
        callback = function(v) djMoveOnly = v end,
    })

    tab:CreateSlider({
        name = "Legit Jump Move Hold",
        icon = 136077598178846,
        range = {0, 5},
        increment = 0.05,
        suffix = "s",
        currentValue = 0,
        flag = "DelayJump_MoveHold",
        callback = function(v) djMoveHold = v end,
    })
end

--[[
============================================================================
HOLD JUMP
============================================================================
]]--

do
    local hjEnabled = false
    local hjRamp = false
    local hjLookDown = false
    local hjMoveOnly = false
    local hjMoveHold = 0

    local hjRay = RaycastParams.new()
    hjRay.FilterType = Enum.RaycastFilterType.Exclude

    local hjHeld = false
    local hjMoveAccum = 0
    local hjWasMoving = false
    local hjLastTick = 0

    local HJ_LOOK_THRESH = -0.7

    local function hjFlat(root)
        if not hjRamp then return true end
        local r = workspace:Raycast(root.Position, Vector3.new(0, -10, 0), hjRay)
        if not r then return false end
        return math.deg(math.acos(r.Normal.Unit.Y)) <= 8
    end

    local function hjLookOK()
        if not hjLookDown then return true end
        local cam = workspace.CurrentCamera
        if not cam then return false end
        return cam.CFrame.LookVector.Y <= HJ_LOOK_THRESH
    end

    local function hjMoving(hum)
        local moving = hum.MoveDirection.Magnitude > 0
        local now = tick()
        local dt = now - hjLastTick
        hjLastTick = now
        if dt < 0 or dt > 0.5 then dt = 0 end
        if moving and hjWasMoving then hjMoveAccum = hjMoveAccum + dt end
        if not moving then hjMoveAccum = 0 end
        hjWasMoving = moving
        if not hjMoveOnly then return true end
        return moving and hjMoveAccum >= hjMoveHold
    end

    local hjStateConn

    local function hjAttach(char)
        local hum = char:WaitForChild("Humanoid")
        local root = char:WaitForChild("HumanoidRootPart")
        hjRay.FilterDescendantsInstances = {char}
        if hjStateConn then hjStateConn:Disconnect() end
        hjStateConn = hum.StateChanged:Connect(function(_, s)
            if not hjEnabled or not hjHeld then return end
            if s ~= Enum.HumanoidStateType.Landed
            and s ~= Enum.HumanoidStateType.Running
            and s ~= Enum.HumanoidStateType.RunningNoPhysics then return end
            if hum.Health <= 0 then return end
            if not hjFlat(root) then return end
            if not hjLookOK() then return end
            if not hjMoving(hum) then return end
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end)
    end

    if player.Character then task.spawn(hjAttach, player.Character) end
    player.CharacterAdded:Connect(function(c) task.spawn(hjAttach, c) end)

    RunService.PreSimulation:Connect(function()
        if not hjEnabled or not hjHeld then return end
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root then return end
        if hum.FloorMaterial == Enum.Material.Air then return end
        if hum.Health <= 0 then return end
        if not hjFlat(root) then return end
        if not hjLookOK() then return end
        if not hjMoving(hum) then return end
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end)

    UserInputService.InputBegan:Connect(function(i, gp)
        if gp then return end
        if i.KeyCode == Enum.KeyCode.Space then hjHeld = true end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.KeyCode == Enum.KeyCode.Space then hjHeld = false end
    end)

    task.spawn(function()
        local pg = player:WaitForChild("PlayerGui")
        local tg = pg:WaitForChild("TouchGui", 30)
        if not tg then return end
        local f = tg:WaitForChild("TouchControlFrame", 10)
        if not f then return end
        local b = f:WaitForChild("JumpButton", 10)
        if not b then return end
        b.MouseButton1Down:Connect(function() hjHeld = true end)
        b.MouseButton1Up:Connect(function() hjHeld = false end)
        b.MouseLeave:Connect(function() hjHeld = false end)
    end)

    tab:CreateDivider()

    tab:CreateToggle({
        name = "Hold Jump",
        icon = 97668677854395,
        currentValue = false,
        flag = "HoldJump_Toggle",
        callback = function(v) hjEnabled = v end,
    })

    tab:CreateToggle({
        name = "Hold Jump Ramp Protection",
        icon = 111308594268728,
        currentValue = false,
        flag = "HoldJump_Ramp_Toggle",
        callback = function(v) hjRamp = v end,
    })

    tab:CreateToggle({
        name = "Hold Jump Only Look Down",
        icon = 128804949999663,
        currentValue = false,
        flag = "HoldJump_LookDown_Toggle",
        callback = function(v) hjLookDown = v end,
    })

    tab:CreateToggle({
        name = "Hold Jump Only On Move",
        icon = 135743813499745,
        currentValue = false,
        flag = "HoldJump_MoveOnly_Toggle",
        callback = function(v) hjMoveOnly = v end,
    })

    tab:CreateSlider({
        name = "Hold Jump Move Hold",
        icon = 136077598178846,
        range = {0, 5},
        increment = 0.05,
        suffix = "s",
        currentValue = 0,
        flag = "HoldJump_MoveHold",
        callback = function(v) hjMoveHold = v end,
    })
end

--[[
============================================================================
EASY BOUNCE
============================================================================
]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local easyBounceEnabled = false
local bounceMultiplier = 1.5

local bounceRayParams = RaycastParams.new()
bounceRayParams.FilterType = Enum.RaycastFilterType.Exclude

local lastYVelocity = 0
local bounceStateConn

local function bounceIsSteepEnough(root)
    local result = workspace:Raycast(root.Position, Vector3.new(0, -10, 0), bounceRayParams)
    if not result then return false end
    local angle = math.deg(math.acos(result.Normal.Unit.Y))
    return angle >= 12
end

local function attachEasyBounce(char)
    local hum = char:WaitForChild("Humanoid")
    local root = char:WaitForChild("HumanoidRootPart")
    bounceRayParams.FilterDescendantsInstances = {char}

    if bounceStateConn then bounceStateConn:Disconnect() end
    bounceStateConn = hum.StateChanged:Connect(function(_, newState)
        if not easyBounceEnabled then return end
        if newState ~= Enum.HumanoidStateType.Landed then return end
        if hum.Health <= 0 then return end
        if not bounceIsSteepEnough(root) then return end
        local bounceVel = math.abs(lastYVelocity) * bounceMultiplier
        if bounceVel < 10 then return end
        root.AssemblyLinearVelocity = Vector3.new(
            root.AssemblyLinearVelocity.X,
            bounceVel,
            root.AssemblyLinearVelocity.Z
        )
    end)
end

if player.Character then
    task.spawn(attachEasyBounce, player.Character)
end
player.CharacterAdded:Connect(function(char)
    task.spawn(attachEasyBounce, char)
end)

RunService.Heartbeat:Connect(function()
    if not easyBounceEnabled then return end
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    lastYVelocity = root.AssemblyLinearVelocity.Y
end)

tab:CreateDivider()

tab:CreateToggle({
    name = "Easy Bounce",
    icon = 116414714090955,
    currentValue = false,
    flag = "EasyBounce_Toggle",
    callback = function(value)
        easyBounceEnabled = value
    end,
})

tab:CreateSlider({
    name = "Easy Bounce Multiplier",
    icon = 120597962040224,
    range = {1.08, 3.00},
    increment = 0.01,
    suffix = "x",
    currentValue = 1.5,
    flag = "EasyBounce_Multiplier",
    callback = function(value)
        bounceMultiplier = value
    end,
})

--[[
============================================================================
HARD BOUNCE
============================================================================
]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local hardBounceEnabled = false
local hardBounceMultiplier = 1.5

local hardBounceRayParams = RaycastParams.new()
hardBounceRayParams.FilterType = Enum.RaycastFilterType.Exclude

local lastYVelocity = 0
local airStartTime = 0
local wasInAir = false
local hardBounceStateConn

local function attachHardBounce(char)
    local hum = char:WaitForChild("Humanoid")
    local root = char:WaitForChild("HumanoidRootPart")
    hardBounceRayParams.FilterDescendantsInstances = {char}

    if hardBounceStateConn then hardBounceStateConn:Disconnect() end
    hardBounceStateConn = hum.StateChanged:Connect(function(_, newState)
        if not hardBounceEnabled then return end
        if newState ~= Enum.HumanoidStateType.Landed then return end
        if hum.Health <= 0 then return end
        if not wasInAir then return end
        if (tick() - airStartTime) < 1 then return end
        local bounceVel = math.abs(lastYVelocity) * hardBounceMultiplier
        if bounceVel < 10 then return end
        root.AssemblyLinearVelocity = Vector3.new(
            root.AssemblyLinearVelocity.X,
            bounceVel,
            root.AssemblyLinearVelocity.Z
        )
    end)
end

if player.Character then
    task.spawn(attachHardBounce, player.Character)
end
player.CharacterAdded:Connect(function(char)
    task.spawn(attachHardBounce, char)
end)

RunService.Heartbeat:Connect(function()
    if not hardBounceEnabled then return end
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end

    lastYVelocity = root.AssemblyLinearVelocity.Y

    if hum.FloorMaterial == Enum.Material.Air then
        if not wasInAir then
            wasInAir = true
            airStartTime = tick()
        end
    else
        wasInAir = false
    end
end)

tab:CreateDivider()

tab:CreateToggle({
    name = "Hard Bounce",
    icon = 116414714090955,
    currentValue = false,
    flag = "HardBounce_Toggle",
    callback = function(value)
        hardBounceEnabled = value
    end,
})

tab:CreateSlider({
    name = "Hard Bounce Multiplier",
    icon = 120597962040224,
    range = {1.08, 3.00},
    increment = 0.01,
    suffix = "x",
    currentValue = 1.5,
    flag = "HardBounce_Multiplier",
    callback = function(value)
        hardBounceMultiplier = value
    end,
})

--[[
============================================================================
LEGIT BOUNCE
============================================================================
]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local legitBounceEnabled = false
local LEGIT_MULTIPLIER = 1.11

local legitRayParams = RaycastParams.new()
legitRayParams.FilterType = Enum.RaycastFilterType.Exclude

local legitLastYVelocity = 0
local legitAirStartTime = 0
local legitWasInAir = false
local legitStateConn

local function legitIsSteepEnough(root)
    local result = workspace:Raycast(root.Position, Vector3.new(0, -10, 0), legitRayParams)
    if not result then return false end
    local angle = math.deg(math.acos(result.Normal.Unit.Y))
    return angle >= 12
end

local function attachLegitBounce(char)
    local hum = char:WaitForChild("Humanoid")
    local root = char:WaitForChild("HumanoidRootPart")
    legitRayParams.FilterDescendantsInstances = {char}

    if legitStateConn then legitStateConn:Disconnect() end
    legitStateConn = hum.StateChanged:Connect(function(_, newState)
        if not legitBounceEnabled then return end
        if newState ~= Enum.HumanoidStateType.Landed then return end
        if hum.Health <= 0 then return end
        if not legitWasInAir then return end
        if (tick() - legitAirStartTime) < 1 then return end
        if not legitIsSteepEnough(root) then return end
        local bounceVel = math.abs(legitLastYVelocity) * LEGIT_MULTIPLIER
        if bounceVel < 10 then return end
        root.AssemblyLinearVelocity = Vector3.new(
            root.AssemblyLinearVelocity.X,
            bounceVel,
            root.AssemblyLinearVelocity.Z
        )
    end)
end

if player.Character then
    task.spawn(attachLegitBounce, player.Character)
end
player.CharacterAdded:Connect(function(char)
    task.spawn(attachLegitBounce, char)
end)

RunService.Heartbeat:Connect(function()
    if not legitBounceEnabled then return end
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end

    legitLastYVelocity = root.AssemblyLinearVelocity.Y

    if hum.FloorMaterial == Enum.Material.Air then
        if not legitWasInAir then
            legitWasInAir = true
            legitAirStartTime = tick()
        end
    else
        legitWasInAir = false
    end
end)

tab:CreateDivider()

tab:CreateToggle({
    name = "Legit Bounce",
    icon = 116414714090955,
    currentValue = false,
    flag = "LegitBounce_Toggle",
    callback = function(value)
        legitBounceEnabled = value
    end,
})

--[[
============================================================================
Fence bounce idk
============================================================================
]]--

-- failed again

--[[
============================================================================
INF SLIDE
============================================================================
]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local infSlideEnabled = false
local infSlideSpeed = 105
local sliding = false
local cachedTag = nil
local cachedService = nil
local cachedCharacter = nil

local UpdateCharacterDataRegistry = ReplicatedStorage:WaitForChild("Events"):WaitForChild("UpdateCharacterDataRegistry")
local CharacterTask = ReplicatedStorage:WaitForChild("Events"):WaitForChild("CharacterTask")
local CharacterServiceModule = ReplicatedStorage:WaitForChild("Services"):WaitForChild("Asset"):WaitForChild("CharacterService")

local crouchNames = {
    CrouchIdle=1, CrouchMove=1, Crouch_RootStraight=1,
    Slide=1, SlideAir=1,
    EmotingSlide=1, EmotingSlideAir=1,
    CarrySlide=1, CarrySlideAir=1,
    CarryCrouchIdle=1, CarryCrouchMove=1,
}
local standNames = {
    Idle=1, Move=1, Move_RootStraight=1, Air=1, Jumping=1,
}

local function getService()
    if cachedService then return cachedService end
    local ok, mod = pcall(require, CharacterServiceModule)
    if ok and type(mod) == "table" then cachedService = mod end
    return cachedService
end

local function getCharacter()
    if cachedCharacter then return cachedCharacter end
    local svc = getService()
    if not svc or not svc.GetLocalCharacter then return nil end
    local ok, char = pcall(svc.GetLocalCharacter, svc)
    if ok and type(char) == "table" then
        cachedCharacter = char
        if type(char.Tag) == "number" and not cachedTag then cachedTag = char.Tag end
        return char
    end
    return nil
end

local function getTag()
    if cachedTag then return cachedTag end
    getCharacter()
    return cachedTag
end

local function setLocalFriction(v)
    local char = getCharacter()
    if not char then return end
    local mv = char.Movement
    if not mv then return end
    local stats = mv.MoveStats
    if not stats then return end
    local mods = stats.Modifiers
    if not mods then return end
    mods.Friction = v
end

local function fireFriction(v)
    local tag = getTag()
    if not tag or not firesignal then return end
    pcall(firesignal, CharacterTask.OnClientEvent, tag, "ModifyMovement", {"Friction", v})
    setLocalFriction(v)
end

CharacterTask.OnClientEvent:Connect(function(first)
    if type(first) == "number" then
        cachedTag = first
        cachedCharacter = nil
    end
end)

player.CharacterAdded:Connect(function()
    cachedTag = nil
    cachedCharacter = nil
    sliding = false
end)

local function detect(args)
    for _, a in ipairs(args) do
        if type(a) == "table" then
            for _, v in pairs(a) do
                if type(v) == "string" then
                    if crouchNames[v] then return "crouch" end
                    if standNames[v] then return "stand" end
                end
            end
        end
    end
    return nil
end

local old
old = hookmetamethod(game, "__namecall", function(self, ...)
    if getnamecallmethod() == "FireServer" and self == UpdateCharacterDataRegistry then
        if infSlideEnabled then
            local kind = detect({...})
            if kind == "crouch" then
                sliding = true
            elseif kind == "stand" then
                sliding = false
                fireFriction(5)
            end
        end
    end
    return old(self, ...)
end)

RunService.Heartbeat:Connect(function()
    if sliding and infSlideEnabled then
        fireFriction(-infSlideSpeed)
    end
end)

tab:CreateDivider()

tab:CreateToggle({
    name = "Inf Slide",
    icon = 84806424467602,
    currentValue = false,
    flag = "InfSlide_Toggle",
    callback = function(v)
        infSlideEnabled = v
        if not v then
            sliding = false
            fireFriction(5)
        end
    end,
})

tab:CreateSlider({
    name = "Inf Slide Speed",
    icon = 79297485010070,
    range = {1, 105},
    increment = 1,
    currentValue = 105,
    flag = "InfSlide_Speed",
    callback = function(v) infSlideSpeed = v end,
})

--[[
============================================================================
CROUCH SPAM
============================================================================
]]--

-- broken :(

--[[
============================================================================
Y LOCK
============================================================================
]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local yLockEnabled = false
local yLockPart = nil
local yLockY = 0

local function createYLockPart()
    local part = Instance.new("Part")
    part.Name = "YLockPlatform"
    part.Size = Vector3.new(300, 1, 300)
    part.Anchored = true
    part.CanCollide = true
    part.CanQuery = false
    part.CanTouch = false
    part.Transparency = 1
    part.Material = Enum.Material.SmoothPlastic
    part.TopSurface = Enum.SurfaceType.Smooth
    part.BottomSurface = Enum.SurfaceType.Smooth
    part.Parent = workspace
    return part
end

local function toggleYLock(on)
    if on then
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        yLockY = root and (root.Position.Y - 1) or 0
        yLockPart = createYLockPart()
        yLockPart.Position = Vector3.new(
            root and root.Position.X or 0,
            yLockY,
            root and root.Position.Z or 0
        )
    else
        if yLockPart then
            yLockPart:Destroy()
            yLockPart = nil
        end
    end
end

RunService.Heartbeat:Connect(function()
    if not yLockEnabled then return end
    if not yLockPart then return end
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    yLockPart.Position = Vector3.new(root.Position.X, yLockY, root.Position.Z)
end)

player.CharacterAdded:Connect(function()
    if yLockEnabled then
        toggleYLock(false)
        task.wait(0.1)
        toggleYLock(true)
    end
end)

tab:CreateDivider()

tab:CreateToggle({
    name = "Y Lock",
    icon = 139863028132428,
    currentValue = false,
    flag = "YLock_Toggle",
    callback = function(value)
        yLockEnabled = value
        toggleYLock(value)
    end,
})

--[[
============================================================================
F JUMP
============================================================================
]]--

do
    local frontalEnabled = false
    local frontalRamp = true
    local frontalSlider = 55.5

    local fRay = RaycastParams.new()
    fRay.FilterType = Enum.RaycastFilterType.Exclude

    local fHum, fRoot

    local function frontalFlat(root)
        if not frontalRamp then return true end
        local r = workspace:Raycast(root.Position, Vector3.new(0, -10, 0), fRay)
        if not r then return false end
        return math.deg(math.acos(r.Normal.Unit.Y)) <= 8
    end

    local function frontalSPS()
        return frontalSlider * 0.5
    end

    local function fAttach(char)
        fHum = char:WaitForChild("Humanoid")
        fRoot = char:WaitForChild("HumanoidRootPart")
        fRay.FilterDescendantsInstances = {char}
        if frontalEnabled then fHum.WalkSpeed = 0 end
    end

    if player.Character then task.spawn(fAttach, player.Character) end
    player.CharacterAdded:Connect(function(c) task.spawn(fAttach, c) end)

    RunService.Heartbeat:Connect(function(dt)
        if not frontalEnabled then return end
        if not fHum or not fRoot or not fRoot.Parent then return end
        if fHum.Health <= 0 then return end

        local cam = workspace.CurrentCamera
        if not cam then return end

        local look = cam.CFrame.LookVector
        local dir = Vector3.new(look.X, 0, look.Z)
        if dir.Magnitude > 0.001 then dir = dir.Unit end

        local speed = frontalSPS()
        fRoot.CFrame = fRoot.CFrame + dir * speed * dt

        if fHum.FloorMaterial ~= Enum.Material.Air then
            if frontalFlat(fRoot) then
                fHum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)

    tab:CreateDivider()

    tab:CreateToggle({
        name = "Frontal Jump",
        icon = 89569262948298,
        currentValue = false,
        flag = "FrontalJump_Toggle",
        callback = function(v)
            frontalEnabled = v
            if fHum then fHum.WalkSpeed = v and 0 or 16 end
        end,
    })

    tab:CreateToggle({
        name = "Frontal Jump Ramp Protection",
        icon = 111308594268728,
        currentValue = false,
        flag = "FrontalJump_Ramp_Toggle",
        callback = function(v) frontalRamp = v end,
    })

    tab:CreateSlider({
        name = "Frontal Jump Speed",
        icon = 79297485010070,
        range = {33.3, 555.5},
        increment = 0.1,
        suffix = "",
        currentValue = 55.5,
        flag = "FrontalJump_Slider",
        callback = function(v) frontalSlider = v end,
    })
end

--[[
============================================================================
BW JUMP
============================================================================
]]--

do
    local backwardEnabled = false
    local backwardRamp = true
    local backwardSlider = 55.5

    local bRay = RaycastParams.new()
    bRay.FilterType = Enum.RaycastFilterType.Exclude

    local bHum, bRoot

    local function backwardFlat(root)
        if not backwardRamp then return true end
        local r = workspace:Raycast(root.Position, Vector3.new(0, -10, 0), bRay)
        if not r then return false end
        return math.deg(math.acos(r.Normal.Unit.Y)) <= 8
    end

    local function backwardSPS()
        return backwardSlider * 0.5
    end

    local function bAttach(char)
        bHum = char:WaitForChild("Humanoid")
        bRoot = char:WaitForChild("HumanoidRootPart")
        bRay.FilterDescendantsInstances = {char}
        if backwardEnabled then bHum.WalkSpeed = 0 end
    end

    if player.Character then task.spawn(bAttach, player.Character) end
    player.CharacterAdded:Connect(function(c) task.spawn(bAttach, c) end)

    RunService.Heartbeat:Connect(function(dt)
        if not backwardEnabled then return end
        if not bHum or not bRoot or not bRoot.Parent then return end
        if bHum.Health <= 0 then return end

        local cam = workspace.CurrentCamera
        if not cam then return end

        local look = cam.CFrame.LookVector
        local dir = Vector3.new(-look.X, 0, -look.Z)
        if dir.Magnitude > 0.001 then dir = dir.Unit end

        local speed = backwardSPS()
        bRoot.CFrame = bRoot.CFrame + dir * speed * dt

        if bHum.FloorMaterial ~= Enum.Material.Air then
            if backwardFlat(bRoot) then
                bHum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)

    tab:CreateDivider()

    tab:CreateToggle({
        name = "Backward Jump",
        icon = 89569262948298,
        currentValue = false,
        flag = "BackwardJump_Toggle",
        callback = function(v)
            backwardEnabled = v
            if bHum then bHum.WalkSpeed = v and 0 or 16 end
        end,
    })

    tab:CreateToggle({
        name = "Backward Jump Ramp Protection",
        icon = 111308594268728,
        currentValue = false,
        flag = "BackwardJump_Ramp_Toggle",
        callback = function(v) backwardRamp = v end,
    })

    tab:CreateSlider({
        name = "Backward Jump Speed",
        icon = 79297485010070,
        range = {33.3, 555.5},
        increment = 0.1,
        suffix = "",
        currentValue = 55.5,
        flag = "BackwardJump_Slider",
        callback = function(v) backwardSlider = v end,
    })
end

--[[
============================================================================
SPEED CHANGER
============================================================================
]]--

do
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local speedChangerEnabled = false
    local speedValue = 1500
    local cachedTag = nil
    local cachedService = nil
    local cachedCharacter = nil

    local CharacterTask = ReplicatedStorage:WaitForChild("Events"):WaitForChild("CharacterTask")
    local CharacterServiceModule = ReplicatedStorage:WaitForChild("Services"):WaitForChild("Asset"):WaitForChild("CharacterService")

    local function getService()
        if cachedService then return cachedService end
        local ok, mod = pcall(require, CharacterServiceModule)
        if ok and type(mod) == "table" then cachedService = mod end
        return cachedService
    end

    local function getCharacter()
        if cachedCharacter then return cachedCharacter end
        local svc = getService()
        if not svc or not svc.GetLocalCharacter then return nil end
        local ok, char = pcall(svc.GetLocalCharacter, svc)
        if ok and type(char) == "table" then
            cachedCharacter = char
            if type(char.Tag) == "number" and not cachedTag then cachedTag = char.Tag end
            return char
        end
        return nil
    end

    local function getTag()
        if cachedTag then return cachedTag end
        getCharacter()
        return cachedTag
    end

    local function setLocalSpeed(v)
        local char = getCharacter()
        if not char or not char.Movement or not char.Movement.MoveStats then return end
        local stats = char.Movement.MoveStats
        if stats.Modifiers then
            stats.Modifiers.Speed = v
        end
        if stats.MoveStats then
            stats.MoveStats.Speed = v
        end
    end

    local function fireSpeed(v)
        local tag = getTag()
        if not tag or not firesignal then return end
        pcall(firesignal, CharacterTask.OnClientEvent, tag, "ModifyMovement", {"Speed", v})
        setLocalSpeed(v)
    end

    CharacterTask.OnClientEvent:Connect(function(first)
        if type(first) == "number" then
            cachedTag = first
            cachedCharacter = nil
        end
    end)

    player.CharacterAdded:Connect(function()
        cachedTag = nil
        cachedCharacter = nil
    end)

    RunService.Heartbeat:Connect(function()
        if not speedChangerEnabled then return end
        fireSpeed(speedValue)
    end)

    tab:CreateDivider({ text = "Speed" })

    tab:CreateToggle({
        name = "Speed Changer",
		icon = 103917802962919,
        currentValue = false,
        flag = "SpeedChanger_Toggle",
        callback = function(v)
            speedChangerEnabled = v
            if not v then
                fireSpeed(1500)
            end
        end,
    })

    tab:CreateInput({
        name = "Speed Amount",
		icon = 79297485010070,
        placeholder = "1500",
        callback = function(text)
            local n = tonumber(text)
            if n then
                speedValue = n
                if speedChangerEnabled then
                    fireSpeed(speedValue)
                end
            end
        end,
    })
end

--[[
============================================================================
TP WALK
============================================================================
]]--

do
    local tpWalkEnabled = false
    local tpWalkSlider = 1500

    local function sliderToSPS(value)
        return 16.6 + (value - 1500) * (114.07 / 8500)
    end

    local tpHum, tpRoot

    local function tpAttach(char)
        tpHum = char:WaitForChild("Humanoid")
        tpRoot = char:WaitForChild("HumanoidRootPart")
        if tpWalkEnabled then tpHum.WalkSpeed = 0 end
    end

    if player.Character then task.spawn(tpAttach, player.Character) end
    player.CharacterAdded:Connect(function(char) task.spawn(tpAttach, char) end)

    RunService.Heartbeat:Connect(function(dt)
        if not tpWalkEnabled then return end
        if not tpHum or not tpRoot or not tpRoot.Parent then return end
        if tpHum.Health <= 0 then return end

        local moveDir = tpHum.MoveDirection
        if moveDir.Magnitude <= 0 then return end

        local speed = sliderToSPS(tpWalkSlider)
        local dir = moveDir.Unit
        tpRoot.CFrame = tpRoot.CFrame + Vector3.new(dir.X * speed * dt, 0, dir.Z * speed * dt)
    end)

    tab:CreateDivider()

    tab:CreateToggle({
        name = "TP Walk",
        icon = 104227978260927,
        currentValue = false,
        flag = "TPWalk_Toggle",
        callback = function(v)
            tpWalkEnabled = v
            if tpHum then tpHum.WalkSpeed = v and 0 or 16 end
        end,
    })

    tab:CreateSlider({
        name = "TP Walk Speed",
        icon = 79297485010070,
        range = {1500, 10000},
        increment = 1,
        suffix = "",
        currentValue = 1500,
        flag = "TPWalk_Slider",
        callback = function(v)
            tpWalkSlider = v
        end,
    })
end

--[[
============================================================================
IA
============================================================================
]]--

local instantAccelEnabled = false

local IA_SPEED = 16.6
local IA_BACKWARDS_MULT = 0.5
local IA_BACKWARDS_DOT = -0.3
local IA_DURATION = 2.5

local iaHum, iaRoot
local iaMoveStart = 0
local iaWasMoving = false

local function iaAttach(char)
    iaHum = char:WaitForChild("Humanoid")
    iaRoot = char:WaitForChild("HumanoidRootPart")
    iaMoveStart = 0
    iaWasMoving = false
    if instantAccelEnabled then iaHum.WalkSpeed = 0 end
end

if player.Character then task.spawn(iaAttach, player.Character) end
player.CharacterAdded:Connect(function(char) task.spawn(iaAttach, char) end)

RunService.Heartbeat:Connect(function(dt)
    if not instantAccelEnabled then return end
    if not iaHum or not iaRoot or not iaRoot.Parent then return end
    if iaHum.Health <= 0 then return end

    local moveDir = iaHum.MoveDirection
    local moving = moveDir.Magnitude > 0

    if moving and not iaWasMoving then
        iaMoveStart = tick()
    end
    iaWasMoving = moving

    if not moving then return end
    if tick() - iaMoveStart >= IA_DURATION then return end

    local wishDir = moveDir.Unit
    local backwards = iaRoot.CFrame.LookVector:Dot(wishDir) < IA_BACKWARDS_DOT
    local speed = backwards and (IA_SPEED * IA_BACKWARDS_MULT) or IA_SPEED

    iaRoot.CFrame = iaRoot.CFrame + Vector3.new(wishDir.X * speed * dt, 0, wishDir.Z * speed * dt)
end)

tab:CreateDivider()

tab:CreateToggle({
    name = "Instant Acceleration",
    icon = 99352190313338,
    currentValue = false,
    flag = "InstantAccel_Toggle",
    callback = function(value)
        instantAccelEnabled = value
        if iaHum then
            iaHum.WalkSpeed = value and 0 or 16
        end
    end,
})

--[[
============================================================================
FRICTION
============================================================================
]]--

do
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local frictionEnabled = false
    local frictionValue = 5
    local cachedTag = nil
    local cachedService = nil
    local cachedCharacter = nil

    local UpdateCharacterDataRegistry = ReplicatedStorage:WaitForChild("Events"):WaitForChild("UpdateCharacterDataRegistry")
    local CharacterTask = ReplicatedStorage:WaitForChild("Events"):WaitForChild("CharacterTask")
    local CharacterServiceModule = ReplicatedStorage:WaitForChild("Services"):WaitForChild("Asset"):WaitForChild("CharacterService")

    local function getService()
        if cachedService then return cachedService end
        local ok, mod = pcall(require, CharacterServiceModule)
        if ok and type(mod) == "table" then cachedService = mod end
        return cachedService
    end

    local function getCharacter()
        if cachedCharacter then return cachedCharacter end
        local svc = getService()
        if not svc or not svc.GetLocalCharacter then return nil end
        local ok, char = pcall(svc.GetLocalCharacter, svc)
        if ok and type(char) == "table" then
            cachedCharacter = char
            if type(char.Tag) == "number" and not cachedTag then cachedTag = char.Tag end
            return char
        end
        return nil
    end

    local function getTag()
        if cachedTag then return cachedTag end
        getCharacter()
        return cachedTag
    end

    local function setLocalFriction(v)
        local char = getCharacter()
        if not char or not char.Movement or not char.Movement.MoveStats or not char.Movement.MoveStats.Modifiers then return end
        char.Movement.MoveStats.Modifiers.Friction = v
    end

    local function fireFriction(v)
        local tag = getTag()
        if not tag or not firesignal then return end
        pcall(firesignal, CharacterTask.OnClientEvent, tag, "ModifyMovement", {"Friction", v})
        setLocalFriction(v)
    end

    CharacterTask.OnClientEvent:Connect(function(first)
        if type(first) == "number" then
            cachedTag = first
            cachedCharacter = nil
        end
    end)

    player.CharacterAdded:Connect(function()
        cachedTag = nil
        cachedCharacter = nil
    end)

    RunService.Heartbeat:Connect(function()
        if not frictionEnabled then return end
        fireFriction(frictionValue)
    end)

    tab:CreateDivider({ text = "Modifiers" })


    tab:CreateToggle({
        name = "Friction Changer",
        icon = 102876083492144,
        currentValue = false,
        flag = "FrictionChanger_Toggle",
        callback = function(v)
            frictionEnabled = v
            if not v then
                fireFriction(5)
            end
        end,
    })

    tab:CreateInput({
        name = "Friction Value",
        icon = 120640130652888,
        placeholder = "e.g. 5",
        currentValue = "5",
        flag = "FrictionChanger_Value",
        callback = function(text)
            local n = tonumber(text)
            if n then
                frictionValue = n
            end
        end,
    })
end

--[[
============================================================================
ASA CHANGER
============================================================================
]]--

do
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local airStrafeEnabled = false
    local airStrafeValue = 182
    local cachedTag = nil
    local cachedService = nil
    local cachedCharacter = nil

    local CharacterTask = ReplicatedStorage:WaitForChild("Events"):WaitForChild("CharacterTask")
    local CharacterServiceModule = ReplicatedStorage:WaitForChild("Services"):WaitForChild("Asset"):WaitForChild("CharacterService")

    local function getService()
        if cachedService then return cachedService end
        local ok, mod = pcall(require, CharacterServiceModule)
        if ok and type(mod) == "table" then cachedService = mod end
        return cachedService
    end

    local function getCharacter()
        if cachedCharacter then return cachedCharacter end
        local svc = getService()
        if not svc or not svc.GetLocalCharacter then return nil end
        local ok, char = pcall(svc.GetLocalCharacter, svc)
        if ok and type(char) == "table" then
            cachedCharacter = char
            if type(char.Tag) == "number" and not cachedTag then cachedTag = char.Tag end
            return char
        end
        return nil
    end

    local function getTag()
        if cachedTag then return cachedTag end
        getCharacter()
        return cachedTag
    end

    local function setLocalAirStrafe(v)
        local char = getCharacter()
        if not char or not char.Movement or not char.Movement.MoveStats then return end
        local stats = char.Movement.MoveStats
        if stats.Modifiers then
            stats.Modifiers.AirStrafeAcceleration = v
        end
        if stats.MoveStats then
            stats.MoveStats.AirStrafeAcceleration = v
        end
    end

    local function fireAirStrafe(v)
        local tag = getTag()
        if not tag or not firesignal then return end
        pcall(firesignal, CharacterTask.OnClientEvent, tag, "ModifyMovement", {"AirStrafeAcceleration", v})
        setLocalAirStrafe(v)
    end

    CharacterTask.OnClientEvent:Connect(function(first)
        if type(first) == "number" then
            cachedTag = first
            cachedCharacter = nil
        end
    end)

    player.CharacterAdded:Connect(function()
        cachedTag = nil
        cachedCharacter = nil
    end)

    RunService.Heartbeat:Connect(function()
        if not airStrafeEnabled then return end
        fireAirStrafe(airStrafeValue)
    end)

    tab:CreateDivider()

    tab:CreateToggle({
        name = "Air Strafe Acceleration Changer",
		icon = 76591949215082,
        currentValue = false,
        flag = "AirStrafe_Toggle",
        callback = function(v)
            airStrafeEnabled = v
            if not v then
                fireAirStrafe(182)
            end
        end,
    })

    tab:CreateSlider({
        name = "Air Strafe Acceleration",
		icon = 120597962040224,
        range = {182, 10000},
        increment = 1,
        suffix = "",
        currentValue = 182,
        flag = "AirStrafe_Slider",
        callback = function(v)
            airStrafeValue = v
        end,
    })
end

--[[
============================================================================
JC CHANGER
============================================================================
]]--

do
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local jumpCapEnabled = false
    local jumpCapValue = 2
    local cachedTag = nil
    local cachedService = nil
    local cachedCharacter = nil

    local CharacterTask = ReplicatedStorage:WaitForChild("Events"):WaitForChild("CharacterTask")
    local CharacterServiceModule = ReplicatedStorage:WaitForChild("Services"):WaitForChild("Asset"):WaitForChild("CharacterService")

    local function getService()
        if cachedService then return cachedService end
        local ok, mod = pcall(require, CharacterServiceModule)
        if ok and type(mod) == "table" then cachedService = mod end
        return cachedService
    end

    local function getCharacter()
        if cachedCharacter then return cachedCharacter end
        local svc = getService()
        if not svc or not svc.GetLocalCharacter then return nil end
        local ok, char = pcall(svc.GetLocalCharacter, svc)
        if ok and type(char) == "table" then
            cachedCharacter = char
            if type(char.Tag) == "number" and not cachedTag then cachedTag = char.Tag end
            return char
        end
        return nil
    end

    local function getTag()
        if cachedTag then return cachedTag end
        getCharacter()
        return cachedTag
    end

    local function setLocalJumpCap(v)
        local char = getCharacter()
        if not char or not char.Movement or not char.Movement.MoveStats then return end
        local stats = char.Movement.MoveStats
        if stats.Modifiers then
            stats.Modifiers.JumpCap = v
        end
        if stats.MoveStats then
            stats.MoveStats.JumpCap = v
        end
    end

    local function fireJumpCap(v)
        local tag = getTag()
        if not tag or not firesignal then return end
        pcall(firesignal, CharacterTask.OnClientEvent, tag, "ModifyMovement", {"JumpCap", v})
        setLocalJumpCap(v)
    end

    CharacterTask.OnClientEvent:Connect(function(first)
        if type(first) == "number" then
            cachedTag = first
            cachedCharacter = nil
        end
    end)

    player.CharacterAdded:Connect(function()
        cachedTag = nil
        cachedCharacter = nil
    end)

    RunService.Heartbeat:Connect(function()
        if not jumpCapEnabled then return end
        fireJumpCap(jumpCapValue)
    end)

    tab:CreateDivider()

    tab:CreateToggle({
        name = "Jump Cap Changer",
		icon = 116351309458675,
        currentValue = false,
        flag = "JumpCap_Toggle",
        callback = function(v)
            jumpCapEnabled = v
            if not v then
                fireJumpCap(2)
            end
        end,
    })

    tab:CreateInput({
        name = "Amount",
		icon = 120640130652888,
        placeholder = "e.g. 5",
        callback = function(text)
            local n = tonumber(text)
            if n then
                jumpCapValue = n
                if jumpCapEnabled then
                    fireJumpCap(jumpCapValue)
                end
            end
        end,
    })
end

--[[
============================================================================
G changer
============================================================================
]]--

do
    local gravityEnabled = false
    local gravityValue = 196.2
    local DEFAULT_GRAVITY = 196.2

    tab:CreateDivider()

    tab:CreateToggle({
        name = "Gravity Changer",
		icon = 137214837348305,
        currentValue = false,
        flag = "GravityChanger_Toggle",
        callback = function(v)
            gravityEnabled = v
            if v then
                workspace.Gravity = gravityValue
            else
                workspace.Gravity = DEFAULT_GRAVITY
            end
        end,
    })

    tab:CreateSlider({
        name = "Gravity",
		icon = 120597962040224,
        range = {0, 1000},
        increment = 0.1,
        suffix = "",
        currentValue = 196.2,
        flag = "GravityChanger_Slider",
        callback = function(v)
            gravityValue = v
            if gravityEnabled then
                workspace.Gravity = v
            end
        end,
    })
end

--[[
============================================================================
JUMP POWER
============================================================================
]]--

do
    local jumpHeightEnabled = false
    local jumpHeightValue = 50

    local jhHum, jhRoot

    local function applyJump()
        if not jumpHeightEnabled then return end
        if not jhHum or not jhRoot or not jhRoot.Parent then return end
        if jhHum.Health <= 0 then return end
        if jhHum.FloorMaterial == Enum.Material.Air then return end
        jhRoot.AssemblyLinearVelocity = Vector3.new(
            jhRoot.AssemblyLinearVelocity.X,
            jumpHeightValue,
            jhRoot.AssemblyLinearVelocity.Z
        )
    end

    local function jhAttach(char)
        jhHum = char:WaitForChild("Humanoid")
        jhRoot = char:WaitForChild("HumanoidRootPart")
        if jumpHeightEnabled then jhHum.JumpPower = 0 end
    end

    if player.Character then task.spawn(jhAttach, player.Character) end
    player.CharacterAdded:Connect(function(c) task.spawn(jhAttach, c) end)

    UserInputService.InputBegan:Connect(function(i, gp)
        if gp then return end
        if i.KeyCode == Enum.KeyCode.Space then
            applyJump()
        end
    end)

    task.spawn(function()
        local pg = player:WaitForChild("PlayerGui")
        local tg = pg:WaitForChild("TouchGui", 30)
        if not tg then return end
        local f = tg:WaitForChild("TouchControlFrame", 10)
        if not f then return end
        local b = f:WaitForChild("JumpButton", 10)
        if not b then return end
        b.MouseButton1Down:Connect(applyJump)
    end)

    tab:CreateDivider()

    tab:CreateToggle({
        name = "Jump Height Changer",
		icon = 97668677854395,
        currentValue = false,
        flag = "JumpHeight_Toggle",
        callback = function(v)
            jumpHeightEnabled = v
            if jhHum then
                jhHum.JumpPower = v and 0 or 50
            end
        end,
    })

    tab:CreateSlider({
        name = "Jump Height",
		icon = 120597962040224,
        range = {25, 1000},
        increment = 1,
        suffix = "Power",
        currentValue = 50,
        flag = "JumpHeight_Slider",
        callback = function(v) jumpHeightValue = v end,
    })
end

--[[
============================================================================
JUMP SPEED
============================================================================
]]--

--[[
do
    local jumpSpeedEnabled = false
    local jumpSpeedValue = 0.5

    local jsHum, jsRoot
    local jsActive = false
    local jsExtraG = 0

    local function jsAttach(char)
        jsHum = char:WaitForChild("Humanoid")
        jsRoot = char:WaitForChild("HumanoidRootPart")
        jsActive = false

        jsHum.StateChanged:Connect(function(_, newState)
            if newState ~= Enum.HumanoidStateType.Jumping then return end
            if not jumpSpeedEnabled then return end
            task.defer(function()
                if not jumpSpeedEnabled then return end
                if not jsHum or not jsRoot or not jsRoot.Parent then return end
                local vel = jsRoot.AssemblyLinearVelocity
                if vel.Y < 1 then return end
                local g = workspace.Gravity
                if g <= 0 then return end

                local v0 = vel.Y
                local H = (v0 * v0) / (2 * g)
                local T = jumpSpeedValue
                if T < 0.01 then T = 0.01 end

                local g_new = (8 * H) / (T * T)
                local v0_new = (4 * H) / T

                jsExtraG = g_new - g
                jsActive = true
                jsRoot.AssemblyLinearVelocity = Vector3.new(vel.X, v0_new, vel.Z)
            end)
        end)
    end

    if player.Character then task.spawn(jsAttach, player.Character) end
    player.CharacterAdded:Connect(function(c) task.spawn(jsAttach, c) end)

    RunService.PreSimulation:Connect(function(dt)
        if not jumpSpeedEnabled then return end
        if not jsActive then return end
        if not jsHum or not jsRoot or not jsRoot.Parent then
            jsActive = false
            return
        end
        if jsHum.FloorMaterial ~= Enum.Material.Air then
            jsActive = false
            return
        end
        local vel = jsRoot.AssemblyLinearVelocity
        jsRoot.AssemblyLinearVelocity = Vector3.new(
            vel.X,
            vel.Y - jsExtraG * dt,
            vel.Z
        )
    end)

    tab:CreateDivider()

    tab:CreateToggle({
        name = "Jump Speed Changer",
		icon = 79297485010070,
        currentValue = false,
        flag = "JumpSpeed_Toggle",
        callback = function(v) jumpSpeedEnabled = v end,
    })

    tab:CreateSlider({
        name = "Speed",
		icon = 120597962040224,
        range = {0.01, 5.00},
        increment = 0.01,
        suffix = "s",
        currentValue = 0.5,
        flag = "JumpSpeed_Slider",
        callback = function(v) jumpSpeedValue = v end,
    })
end
]]--

--[[
============================================================================
ESC
============================================================================
]]--

do
	local speedEnabled = false
	local currentSpeedValue = 16.6
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local modifiedEmotes = {} -- Saves original speeds to restore them when turned off

	local EMOTE_PATHS = {
		{"Items","ItemPacks","Gamepass","Unorganized","EmotePack","Emotes"},
		{"Items","ItemPacks","Gamepass","Unorganized","EclipseSet","Emotes"},
		{"Items","ItemPacks","Gamepass","Unorganized","DogSet","Emotes"},
		{"Items","ItemPacks","Gamepass","Unorganized","Cats","Emotes"},
		{"Items","ItemPacks","Gamepass","Unorganized","Animals","Emotes"},
		{"Items","ItemPacks","Gamepass","Legacy","StPatricks2023","Emotes"},
		{"Items","ItemPacks","Gamepass","Legacy","Military","Emotes"},
		{"Items","ItemPacks","Gamepass","2026","RelicEmotesNew","Emotes"},
		{"Items","ItemPacks","Gamepass","2026","PoseidonSet","Emotes"},
		{"Items","ItemPacks","Gamepass","2026","BeeSet","Emotes"},
		{"Items","ItemPacks","EventsDailyShop","Thanksgiving2025","Emotes"},
		{"Items","ItemPacks","EventsDailyShop","OldRoblox","Emotes"},
		{"Items","ItemPacks","EventsDailyShop","NewYears2024","Emotes"},
		{"Items","ItemPacks","EventsDailyShop","LunarNewYear","Emotes"},
		{"Items","ItemPacks","Events","2026","Valentines2026","Emotes"},
		{"Items","ItemPacks","Events","2026","StPatricks2026","Emotes"},
		{"Items","ItemPacks","Events","2026","Spring2026","Emotes"},
		{"Items","ItemPacks","Events","2026","SUMMER26","Emotes"},
		{"Items","ItemPacks","Events","2026","HLWN2026","Emotes"},
		{"Items","ItemPacks","Events","2025","XMAS25","Emotes","DailyShop"},
		{"Items","ItemPacks","Events","2025","XMAS25","Emotes","Battlepass"},
		{"Items","ItemPacks","Events","2025","Valentines2025","Emotes"},
		{"Items","ItemPacks","Events","2025","Summer2025","Emotes"},
		{"Items","ItemPacks","Events","2025","StPatricks2025","Emotes"},
		{"Items","ItemPacks","Events","2025","Hlwn2025","Emotes"},
		{"Items","ItemPacks","Events","2024","Xmas2024","Emotes"},
		{"Items","ItemPacks","Events","2024","Valentines2024","Emotes"},
		{"Items","ItemPacks","Events","2024","StPatricks2024","Emotes"},
		{"Items","ItemPacks","Events","2024","Hlwn2024","Emotes"},
		{"Items","ItemPacks","Events","2024","Halloween2024","Emotes"},
		{"Items","ItemPacks","Events","2023","Hlwn2023","Emotes"},
		{"Items","ItemPacks","Events","2023","Halloween2023","Emotes"},
		{"Items","ItemPacks","Events","2023","Xmas2023","Emotes"},
		{"Items","ItemPacks","Events","2023","Valentines2023","Emotes"},
		{"Items","ItemPacks","Events","2023","StPatricks2023","Emotes"},
		{"Items","ItemPacks","Events","2023","Summer2023","Emotes"},
		{"Items","ItemPacks","Events","2022","Hlwn2022","Emotes"},
		{"Items","ItemPacks","Events","2022","Halloween2022","Emotes"},
		{"Items","ItemPacks","Events","2022","Xmas2022","Emotes"},
		{"Items","ItemPacks","Events","2022","Valentines2022","Emotes"},
		{"Items","ItemPacks","Collab","ST","Emotes"},
		{"Items","ItemPacks","Base","Special","Emotes"},
		{"Items","ItemPacks","Base","NewShop","Emotes"},
		{"Items","ItemPacks","Base","LevelShop","Emotes"},
		{"Items","ItemPacks","Base","DailyShop","Emotes"},
		{"Items","BaseItems","Emotes"},
		{"Items","ItemPacks","Integration","M3GAN","Emotes"},
		{"Items","ItemPacks","Gamepass","Unorganized","Gems","Emotes"},
		{"Items","ItemPacks","Gamepass","Unorganized","LunarNewYearSet","Emotes"},
		{"Items","ItemPacks","Gamepass","Unorganized","MusicEmotesPack1","Emotes"},
		{"Items","ItemPacks","Gamepass","Unorganized","RelicEmotesVaulted","Emotes"},
	}

	local function resolvePath(keys)
		local ok, result = pcall(function()
			local obj = ReplicatedStorage
			for _, k in ipairs(keys) do obj = obj[k] end
			return obj
		end)
		if ok and typeof(result) == "Instance" then return result end
		return nil
	end

	local function getItemScript(item)
		if item:IsA("ModuleScript") then return item end
		for _, c in ipairs(item:GetChildren()) do
			if c:IsA("ModuleScript") then return c end
		end
		return nil
	end

	local function applySpeed()
		local targetMult = currentSpeedValue / 16.6 -- Maps 0-16.6 to 0-1
		
		for _, path in ipairs(EMOTE_PATHS) do
			local folder = resolvePath(path)
			if folder then
				for _, child in ipairs(folder:GetChildren()) do
					-- Handle expanded folders like Battlepass/DailyShop
					if child:IsA("Folder") and (child.Name:lower() == "battlepass" or child.Name:lower() == "dailyshop") then
						for _, inner in ipairs(child:GetChildren()) do
							local script = getItemScript(inner)
							if script then
								local ok, data = pcall(require, script)
								if ok and type(data) == "table" and data.EmoteInfo and data.EmoteInfo.SpeedMult then
									if not modifiedEmotes[inner] then
										modifiedEmotes[inner] = data.EmoteInfo.SpeedMult
									end
									data.EmoteInfo.SpeedMult = targetMult
								end
							end
						end
					else
						local script = getItemScript(child)
						if script then
							local ok, data = pcall(require, script)
							if ok and type(data) == "table" and data.EmoteInfo and data.EmoteInfo.SpeedMult then
								if not modifiedEmotes[child] then
									modifiedEmotes[child] = data.EmoteInfo.SpeedMult
								end
								data.EmoteInfo.SpeedMult = targetMult
							end
						end
					end
				end
			end
		end
	end

	local function revertSpeed()
		for item, originalSpeed in pairs(modifiedEmotes) do
			local script = getItemScript(item)
			if script then
				local ok, data = pcall(require, script)
				if ok and type(data) == "table" and data.EmoteInfo then
					-- Restores to the saved original
					data.EmoteInfo.SpeedMult = originalSpeed
				end
			end
		end
		modifiedEmotes = {}
	end

	tab:CreateDivider()

	tab:CreateToggle({
		name = "Change Emote Speed",
        icon = 121586615710226,
		currentValue = false,
		callback = function(v)
			speedEnabled = v
			if speedEnabled then
				applySpeed()
			else
				revertSpeed()
			end
		end,
	})

	tab:CreateSlider({
		name = "Speed",
        icon = 120597962040224,
		range = {0, 16.6},
		increment = 0.1,
		suffix = "",
		currentValue = 16.6,
		callback = function(v)
			currentSpeedValue = v
			if speedEnabled then
				applySpeed() -- Updates live while the toggle is on
			end
		end,
	})
end

--[[
============================================================================
BP UNME
============================================================================
]]--

do
	local bypassEnabled = false
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local modifiedEmotes = {} -- Saves original speeds to restore them when turned off

	local EMOTE_PATHS = {
		{"Items","ItemPacks","Gamepass","Unorganized","EmotePack","Emotes"},
		{"Items","ItemPacks","Gamepass","Unorganized","EclipseSet","Emotes"},
		{"Items","ItemPacks","Gamepass","Unorganized","DogSet","Emotes"},
		{"Items","ItemPacks","Gamepass","Unorganized","Cats","Emotes"},
		{"Items","ItemPacks","Gamepass","Unorganized","Animals","Emotes"},
		{"Items","ItemPacks","Gamepass","Legacy","StPatricks2023","Emotes"},
		{"Items","ItemPacks","Gamepass","Legacy","Military","Emotes"},
		{"Items","ItemPacks","Gamepass","2026","RelicEmotesNew","Emotes"},
		{"Items","ItemPacks","Gamepass","2026","PoseidonSet","Emotes"},
		{"Items","ItemPacks","Gamepass","2026","BeeSet","Emotes"},
		{"Items","ItemPacks","EventsDailyShop","Thanksgiving2025","Emotes"},
		{"Items","ItemPacks","EventsDailyShop","OldRoblox","Emotes"},
		{"Items","ItemPacks","EventsDailyShop","NewYears2024","Emotes"},
		{"Items","ItemPacks","EventsDailyShop","LunarNewYear","Emotes"},
		{"Items","ItemPacks","Events","2026","Valentines2026","Emotes"},
		{"Items","ItemPacks","Events","2026","StPatricks2026","Emotes"},
		{"Items","ItemPacks","Events","2026","Spring2026","Emotes"},
		{"Items","ItemPacks","Events","2026","SUMMER26","Emotes"},
		{"Items","ItemPacks","Events","2026","HLWN2026","Emotes"},
		{"Items","ItemPacks","Events","2025","XMAS25","Emotes","DailyShop"},
		{"Items","ItemPacks","Events","2025","XMAS25","Emotes","Battlepass"},
		{"Items","ItemPacks","Events","2025","Valentines2025","Emotes"},
		{"Items","ItemPacks","Events","2025","Summer2025","Emotes"},
		{"Items","ItemPacks","Events","2025","StPatricks2025","Emotes"},
		{"Items","ItemPacks","Events","2025","Hlwn2025","Emotes"},
		{"Items","ItemPacks","Events","2024","Xmas2024","Emotes"},
		{"Items","ItemPacks","Events","2024","Valentines2024","Emotes"},
		{"Items","ItemPacks","Events","2024","StPatricks2024","Emotes"},
		{"Items","ItemPacks","Events","2024","Hlwn2024","Emotes"},
		{"Items","ItemPacks","Events","2024","Halloween2024","Emotes"},
		{"Items","ItemPacks","Events","2023","Hlwn2023","Emotes"},
		{"Items","ItemPacks","Events","2023","Halloween2023","Emotes"},
		{"Items","ItemPacks","Events","2023","Xmas2023","Emotes"},
		{"Items","ItemPacks","Events","2023","Valentines2023","Emotes"},
		{"Items","ItemPacks","Events","2023","StPatricks2023","Emotes"},
		{"Items","ItemPacks","Events","2023","Summer2023","Emotes"},
		{"Items","ItemPacks","Events","2022","Hlwn2022","Emotes"},
		{"Items","ItemPacks","Events","2022","Halloween2022","Emotes"},
		{"Items","ItemPacks","Events","2022","Xmas2022","Emotes"},
		{"Items","ItemPacks","Events","2022","Valentines2022","Emotes"},
		{"Items","ItemPacks","Collab","ST","Emotes"},
		{"Items","ItemPacks","Base","Special","Emotes"},
		{"Items","ItemPacks","Base","NewShop","Emotes"},
		{"Items","ItemPacks","Base","LevelShop","Emotes"},
		{"Items","ItemPacks","Base","DailyShop","Emotes"},
		{"Items","BaseItems","Emotes"},
		{"Items","ItemPacks","Integration","M3GAN","Emotes"},
		{"Items","ItemPacks","Gamepass","Unorganized","Gems","Emotes"},
		{"Items","ItemPacks","Gamepass","Unorganized","LunarNewYearSet","Emotes"},
		{"Items","ItemPacks","Gamepass","Unorganized","MusicEmotesPack1","Emotes"},
		{"Items","ItemPacks","Gamepass","Unorganized","RelicEmotesVaulted","Emotes"},
	}

	local function resolvePath(keys)
		local ok, result = pcall(function()
			local obj = ReplicatedStorage
			for _, k in ipairs(keys) do obj = obj[k] end
			return obj
		end)
		if ok and typeof(result) == "Instance" then return result end
		return nil
	end

	local function getItemScript(item)
		if item:IsA("ModuleScript") then return item end
		for _, c in ipairs(item:GetChildren()) do
			if c:IsA("ModuleScript") then return c end
		end
		return nil
	end

	local function applyBypass()
		for _, path in ipairs(EMOTE_PATHS) do
			local folder = resolvePath(path)
			if folder then
				for _, child in ipairs(folder:GetChildren()) do
					-- Handle expanded folders like Battlepass/DailyShop
					if child:IsA("Folder") and (child.Name:lower() == "battlepass" or child.Name:lower() == "dailyshop") then
						for _, inner in ipairs(child:GetChildren()) do
							local script = getItemScript(inner)
							if script then
								local ok, data = pcall(require, script)
								if ok and type(data) == "table" and data.EmoteInfo and data.EmoteInfo.SpeedMult then
									if not modifiedEmotes[inner] then
										modifiedEmotes[inner] = data.EmoteInfo.SpeedMult
									end
									data.EmoteInfo.SpeedMult = 0.3
								end
							end
						end
					else
						local script = getItemScript(child)
						if script then
							local ok, data = pcall(require, script)
							if ok and type(data) == "table" and data.EmoteInfo and data.EmoteInfo.SpeedMult then
								if not modifiedEmotes[child] then
									modifiedEmotes[child] = data.EmoteInfo.SpeedMult
								end
								data.EmoteInfo.SpeedMult = 0.3
							end
						end
					end
				end
			end
		end
	end

	local function revertBypass()
		for item, originalSpeed in pairs(modifiedEmotes) do
			local script = getItemScript(item)
			if script then
				local ok, data = pcall(require, script)
				if ok and type(data) == "table" and data.EmoteInfo then
					-- Restores to the saved original (which is 0 for unmovable emotes)
					data.EmoteInfo.SpeedMult = originalSpeed
				end
			end
		end
		modifiedEmotes = {}
	end

	tab:CreateDivider({ text = "Emotes" })

	tab:CreateToggle({
		name = "Unmovable Emote Bypass",
        icon = 102876083492144,
		currentValue = false,
		callback = function(v)
			bypassEnabled = v
			if bypassEnabled then
				applyBypass()
			else
				revertBypass()
			end
		end,
	})
end

--[[
============================================================================
EW
============================================================================
]]--

do
	local walkEnabled = false
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local modifiedEmotes = {} -- Saves original speeds to restore them when turned off

	local EMOTE_PATHS = {
		{"Items","ItemPacks","Gamepass","Unorganized","EmotePack","Emotes"},
		{"Items","ItemPacks","Gamepass","Unorganized","EclipseSet","Emotes"},
		{"Items","ItemPacks","Gamepass","Unorganized","DogSet","Emotes"},
		{"Items","ItemPacks","Gamepass","Unorganized","Cats","Emotes"},
		{"Items","ItemPacks","Gamepass","Unorganized","Animals","Emotes"},
		{"Items","ItemPacks","Gamepass","Legacy","StPatricks2023","Emotes"},
		{"Items","ItemPacks","Gamepass","Legacy","Military","Emotes"},
		{"Items","ItemPacks","Gamepass","2026","RelicEmotesNew","Emotes"},
		{"Items","ItemPacks","Gamepass","2026","PoseidonSet","Emotes"},
		{"Items","ItemPacks","Gamepass","2026","BeeSet","Emotes"},
		{"Items","ItemPacks","EventsDailyShop","Thanksgiving2025","Emotes"},
		{"Items","ItemPacks","EventsDailyShop","OldRoblox","Emotes"},
		{"Items","ItemPacks","EventsDailyShop","NewYears2024","Emotes"},
		{"Items","ItemPacks","EventsDailyShop","LunarNewYear","Emotes"},
		{"Items","ItemPacks","Events","2026","Valentines2026","Emotes"},
		{"Items","ItemPacks","Events","2026","StPatricks2026","Emotes"},
		{"Items","ItemPacks","Events","2026","Spring2026","Emotes"},
		{"Items","ItemPacks","Events","2026","SUMMER26","Emotes"},
		{"Items","ItemPacks","Events","2026","HLWN2026","Emotes"},
		{"Items","ItemPacks","Events","2025","XMAS25","Emotes","DailyShop"},
		{"Items","ItemPacks","Events","2025","XMAS25","Emotes","Battlepass"},
		{"Items","ItemPacks","Events","2025","Valentines2025","Emotes"},
		{"Items","ItemPacks","Events","2025","Summer2025","Emotes"},
		{"Items","ItemPacks","Events","2025","StPatricks2025","Emotes"},
		{"Items","ItemPacks","Events","2025","Hlwn2025","Emotes"},
		{"Items","ItemPacks","Events","2024","Xmas2024","Emotes"},
		{"Items","ItemPacks","Events","2024","Valentines2024","Emotes"},
		{"Items","ItemPacks","Events","2024","StPatricks2024","Emotes"},
		{"Items","ItemPacks","Events","2024","Hlwn2024","Emotes"},
		{"Items","ItemPacks","Events","2024","Halloween2024","Emotes"},
		{"Items","ItemPacks","Events","2023","Hlwn2023","Emotes"},
		{"Items","ItemPacks","Events","2023","Halloween2023","Emotes"},
		{"Items","ItemPacks","Events","2023","Xmas2023","Emotes"},
		{"Items","ItemPacks","Events","2023","Valentines2023","Emotes"},
		{"Items","ItemPacks","Events","2023","StPatricks2023","Emotes"},
		{"Items","ItemPacks","Events","2023","Summer2023","Emotes"},
		{"Items","ItemPacks","Events","2022","Hlwn2022","Emotes"},
		{"Items","ItemPacks","Events","2022","Halloween2022","Emotes"},
		{"Items","ItemPacks","Events","2022","Xmas2022","Emotes"},
		{"Items","ItemPacks","Events","2022","Valentines2022","Emotes"},
		{"Items","ItemPacks","Collab","ST","Emotes"},
		{"Items","ItemPacks","Base","Special","Emotes"},
		{"Items","ItemPacks","Base","NewShop","Emotes"},
		{"Items","ItemPacks","Base","LevelShop","Emotes"},
		{"Items","ItemPacks","Base","DailyShop","Emotes"},
		{"Items","BaseItems","Emotes"},
		{"Items","ItemPacks","Integration","M3GAN","Emotes"},
		{"Items","ItemPacks","Gamepass","Unorganized","Gems","Emotes"},
		{"Items","ItemPacks","Gamepass","Unorganized","LunarNewYearSet","Emotes"},
		{"Items","ItemPacks","Gamepass","Unorganized","MusicEmotesPack1","Emotes"},
		{"Items","ItemPacks","Gamepass","Unorganized","RelicEmotesVaulted","Emotes"},
	}

	local function resolvePath(keys)
		local ok, result = pcall(function()
			local obj = ReplicatedStorage
			for _, k in ipairs(keys) do obj = obj[k] end
			return obj
		end)
		if ok and typeof(result) == "Instance" then return result end
		return nil
	end

	local function getItemScript(item)
		if item:IsA("ModuleScript") then return item end
		for _, c in ipairs(item:GetChildren()) do
			if c:IsA("ModuleScript") then return c end
		end
		return nil
	end

	local function applyWalk()
		for _, path in ipairs(EMOTE_PATHS) do
			local folder = resolvePath(path)
			if folder then
				for _, child in ipairs(folder:GetChildren()) do
					if child:IsA("Folder") and (child.Name:lower() == "battlepass" or child.Name:lower() == "dailyshop") then
						for _, inner in ipairs(child:GetChildren()) do
							local script = getItemScript(inner)
							if script then
								local ok, data = pcall(require, script)
								if ok and type(data) == "table" and data.EmoteInfo and data.EmoteInfo.SpeedMult then
									if not modifiedEmotes[inner] then
										modifiedEmotes[inner] = data.EmoteInfo.SpeedMult
									end
									data.EmoteInfo.SpeedMult = 2
								end
							end
						end
					else
						local script = getItemScript(child)
						if script then
							local ok, data = pcall(require, script)
							if ok and type(data) == "table" and data.EmoteInfo and data.EmoteInfo.SpeedMult then
								if not modifiedEmotes[child] then
									modifiedEmotes[child] = data.EmoteInfo.SpeedMult
								end
								data.EmoteInfo.SpeedMult = 2
							end
						end
					end
				end
			end
		end
	end

	local function revertWalk()
		for item, originalSpeed in pairs(modifiedEmotes) do
			local script = getItemScript(item)
			if script then
				local ok, data = pcall(require, script)
				if ok and type(data) == "table" and data.EmoteInfo then
					data.EmoteInfo.SpeedMult = originalSpeed
				end
			end
		end
		modifiedEmotes = {}
	end

	tab:CreateDivider()

	tab:CreateToggle({
		name = "Emote Walk",
        icon = 104227978260927,
		value = false,
		callback = function(v)
			walkEnabled = v
			if walkEnabled then
				applyWalk()
			else
				revertWalk()
			end
		end,
	})
end

--[[
============================================================================
EMOTE RUN
============================================================================
]]--

do
    local SRC_FWD_ON = [==[
-- LocalScript: ShiftlockOn  (detection system, FORWARD)
-- Watches the game's CharacterTask event:
--   FireServer("Emote", <any number except 0>)  -> shiftlock ON
--   FireServer("Emote", 0)                      -> shiftlock OFF
--   Respawning (new character)                  -> shiftlock OFF
-- While ON, the player faces the SAME direction as the camera and wins
-- any fight with the game (runs last every frame, every physics step, and
-- instantly when something changes the rotation).
-- Requires an executor with hookmetamethod / newcclosure / getnamecallmethod.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

assert(hookmetamethod and newcclosure and getnamecallmethod,
	"ShiftlockOn needs an executor with hookmetamethod support")

local player = Players.LocalPlayer
local NAME = "CustomShiftlock"         -- shiftlock is currently active
local SYSTEM = "CustomShiftlockSystem" -- detection system is running

if player:GetAttribute(SYSTEM) then return end -- already running

local event = ReplicatedStorage:WaitForChild("Events"):WaitForChild("CharacterTask")

local systemOn = true
local active = false
local loopConnections = {}
local hookConnections = {}
local hookedChar

player:SetAttribute(SYSTEM, true)
player:GetAttributeChangedSignal(SYSTEM):Connect(function()
	systemOn = player:GetAttribute(SYSTEM) == true
end)

local function stop()
	pcall(function()
		RunService:UnbindFromRenderStep(NAME)
	end)
	for _, c in ipairs(loopConnections) do c:Disconnect() end
	for _, c in ipairs(hookConnections) do c:Disconnect() end
	table.clear(loopConnections)
	table.clear(hookConnections)
	hookedChar = nil
	active = false
end

local function face()
	if not player:GetAttribute(NAME) then
		stop()
		return
	end

	local camera = workspace.CurrentCamera
	local char = player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not camera or not hum or not root then return end

	if char ~= hookedChar then
		hookedChar = char
		for _, c in ipairs(hookConnections) do c:Disconnect() end
		table.clear(hookConnections)
		table.insert(hookConnections, root:GetPropertyChangedSignal("CFrame"):Connect(face))
		table.insert(hookConnections, hum:GetPropertyChangedSignal("AutoRotate"):Connect(face))
	end

	hum.AutoRotate = false

	local align = root:FindFirstChild(NAME)
	if not align then
		local att = Instance.new("Attachment")
		att.Name = NAME .. "Attachment"
		att.Parent = root

		align = Instance.new("AlignOrientation")
		align.Name = NAME
		align.Mode = Enum.OrientationAlignmentMode.OneAttachment
		align.Attachment0 = att
		align.RigidityEnabled = true
		align.CFrame = root.CFrame
		align.Parent = root
	end

	local look = camera.CFrame.LookVector
	local flat = Vector3.new(look.X, 0, look.Z)
	if flat.Magnitude < 0.001 then return end
	flat = flat.Unit

	align.CFrame = CFrame.lookAt(root.Position, root.Position + flat)

	if root.CFrame.LookVector:Dot(flat) < 0.99999 then
		root.CFrame = CFrame.lookAt(root.Position, root.Position + flat)
		root.AssemblyAngularVelocity = Vector3.zero
	end
end

local function enable()
	if active or not systemOn then return end
	active = true
	player:SetAttribute(NAME, true)

	pcall(function()
		RunService:UnbindFromRenderStep(NAME)
	end)
	RunService:BindToRenderStep(NAME, Enum.RenderPriority.Last.Value, face)
	table.insert(loopConnections, RunService.Stepped:Connect(face))
	table.insert(loopConnections, RunService.Heartbeat:Connect(face))
end

local function disable()
	player:SetAttribute(NAME, false)
	stop()

	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if root then
		local align = root:FindFirstChild(NAME)
		if align then align:Destroy() end
		local att = root:FindFirstChild(NAME .. "Attachment")
		if att then att:Destroy() end
	end
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.AutoRotate = true
	end
end

player.CharacterAdded:Connect(function()
	if systemOn then
		disable()
	end
end)

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
	local method = getnamecallmethod()

	if systemOn and self == event and method == "FireServer" then
		local action, value = ...
		if action == "Emote" and type(value) == "number" then
			if value == 0 then
				task.defer(disable)
			else
				task.defer(enable)
			end
		end
	end

	return oldNamecall(self, ...)
end))
]==]

    local SRC_FWD_OFF = [==[
-- LocalScript: ShiftlockOff

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local NAME = "CustomShiftlock"
local SYSTEM = "CustomShiftlockSystem"

player:SetAttribute(SYSTEM, false)
player:SetAttribute(NAME, false)
pcall(function()
	RunService:UnbindFromRenderStep(NAME)
end)

local char = player.Character
if not char then return end

local root = char:FindFirstChild("HumanoidRootPart")
if root then
	local align = root:FindFirstChild(NAME)
	if align then align:Destroy() end
	local att = root:FindFirstChild(NAME .. "Attachment")
	if att then att:Destroy() end
end

local hum = char:FindFirstChildOfClass("Humanoid")
if hum then
	hum.AutoRotate = true
end
]==]

    local SRC_BWD_ON = [==[
-- LocalScript: ShiftlockBackOn  (detection system)
-- Watches the game's CharacterTask event:
--   FireServer("Emote", <any number except 0>)  -> backwards shiftlock ON
--   FireServer("Emote", 0)                      -> backwards shiftlock OFF
--   Respawning (new character)                  -> backwards shiftlock OFF
-- While ON, the player faces the OPPOSITE direction of the camera and wins
-- any fight with the game.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

assert(hookmetamethod and newcclosure and getnamecallmethod,
	"ShiftlockBackOn needs an executor with hookmetamethod support")

local player = Players.LocalPlayer
local NAME = "CustomShiftlockBack"
local SYSTEM = "CustomShiftlockBackSystem"

if player:GetAttribute(SYSTEM) then return end

local event = ReplicatedStorage:WaitForChild("Events"):WaitForChild("CharacterTask")

local systemOn = true
local active = false
local loopConnections = {}
local hookConnections = {}
local hookedChar

player:SetAttribute(SYSTEM, true)
player:GetAttributeChangedSignal(SYSTEM):Connect(function()
	systemOn = player:GetAttribute(SYSTEM) == true
end)

local function stop()
	pcall(function()
		RunService:UnbindFromRenderStep(NAME)
	end)
	for _, c in ipairs(loopConnections) do c:Disconnect() end
	for _, c in ipairs(hookConnections) do c:Disconnect() end
	table.clear(loopConnections)
	table.clear(hookConnections)
	hookedChar = nil
	active = false
end

local function face()
	if not player:GetAttribute(NAME) then
		stop()
		return
	end

	local camera = workspace.CurrentCamera
	local char = player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not camera or not hum or not root then return end

	if char ~= hookedChar then
		hookedChar = char
		for _, c in ipairs(hookConnections) do c:Disconnect() end
		table.clear(hookConnections)
		table.insert(hookConnections, root:GetPropertyChangedSignal("CFrame"):Connect(face))
		table.insert(hookConnections, hum:GetPropertyChangedSignal("AutoRotate"):Connect(face))
	end

	hum.AutoRotate = false

	local align = root:FindFirstChild(NAME)
	if not align then
		local att = Instance.new("Attachment")
		att.Name = NAME .. "Attachment"
		att.Parent = root

		align = Instance.new("AlignOrientation")
		align.Name = NAME
		align.Mode = Enum.OrientationAlignmentMode.OneAttachment
		align.Attachment0 = att
		align.RigidityEnabled = true
		align.CFrame = root.CFrame
		align.Parent = root
	end

	local look = camera.CFrame.LookVector
	local flat = Vector3.new(look.X, 0, look.Z)
	if flat.Magnitude < 0.001 then return end
	flat = -flat.Unit

	align.CFrame = CFrame.lookAt(root.Position, root.Position + flat)

	if root.CFrame.LookVector:Dot(flat) < 0.99999 then
		root.CFrame = CFrame.lookAt(root.Position, root.Position + flat)
		root.AssemblyAngularVelocity = Vector3.zero
	end
end

local function enable()
	if active or not systemOn then return end
	active = true
	player:SetAttribute(NAME, true)

	pcall(function()
		RunService:UnbindFromRenderStep(NAME)
	end)
	RunService:BindToRenderStep(NAME, Enum.RenderPriority.Last.Value, face)
	table.insert(loopConnections, RunService.Stepped:Connect(face))
	table.insert(loopConnections, RunService.Heartbeat:Connect(face))
end

local function disable()
	player:SetAttribute(NAME, false)
	stop()

	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if root then
		local align = root:FindFirstChild(NAME)
		if align then align:Destroy() end
		local att = root:FindFirstChild(NAME .. "Attachment")
		if att then att:Destroy() end
	end
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.AutoRotate = true
	end
end

player.CharacterAdded:Connect(function()
	if systemOn then
		disable()
	end
end)

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
	local method = getnamecallmethod()

	if systemOn and self == event and method == "FireServer" then
		local action, value = ...
		if action == "Emote" and type(value) == "number" then
			if value == 0 then
				task.defer(disable)
			else
				task.defer(enable)
			end
		end
	end

	return oldNamecall(self, ...)
end))
]==]

    local SRC_BWD_OFF = [==[
-- LocalScript: ShiftlockBackOff

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local NAME = "CustomShiftlockBack"
local SYSTEM = "CustomShiftlockBackSystem"

player:SetAttribute(SYSTEM, false)
player:SetAttribute(NAME, false)
pcall(function()
	RunService:UnbindFromRenderStep(NAME)
end)

local char = player.Character
if not char then return end

local root = char:FindFirstChild("HumanoidRootPart")
if root then
	local align = root:FindFirstChild(NAME)
	if align then align:Destroy() end
	local att = root:FindFirstChild(NAME .. "Attachment")
	if att then att:Destroy() end
end

local hum = char:FindFirstChildOfClass("Humanoid")
if hum then
	hum.AutoRotate = true
end
]==]

    local function runSource(src)
        if loadstring then
            local ok, fn = pcall(loadstring, src)
            if ok and fn then pcall(fn) end
        elseif getgenv and getgenv().loadstring then
            local ok, fn = pcall(getgenv().loadstring, src)
            if ok and fn then pcall(fn) end
        end
    end

    local enabled = false
    local mode = "Forward"
    local currentActive = nil

    local function apply()
        if currentActive == "forward" then
            runSource(SRC_FWD_OFF)
            currentActive = nil
        elseif currentActive == "backward" then
            runSource(SRC_BWD_OFF)
            currentActive = nil
        end

        if enabled then
            if mode == "Forward" then
                runSource(SRC_FWD_ON)
                currentActive = "forward"
            else
                runSource(SRC_BWD_ON)
                currentActive = "backward"
            end
        end
    end

    tab:CreateDivider()

    tab:CreateToggle({
        name = "Emote Run",
		icon = 113713061701553,
        currentValue = false,
        flag = "EmoteShiftlock_Toggle",
        callback = function(v)
            enabled = v
            apply()
        end,
    })

    tab:CreateDropdown({
        name = "Direction",
		icon = 110016491347992,
        options = { "Forward", "Backward" },
        currentOption = { "Forward" },
        multiSelect = false,
        callback = function(selected)
            local pick = type(selected) == "table" and selected[1] or selected
            if pick and pick ~= mode then
                mode = pick
                apply()
            end
        end,
    })
end

--[[
============================================================================
cs
============================================================================
]]--

do
    local spinEnabled = false
    local spinDirection = "Clockwise"
    local spinRPS = 1
    local spinAngle = 0
    local torsoRot = nil
    local baseC0 = nil
    local lastApplied = nil

    local function findTorsoRot()
        local rigs = workspace:FindFirstChild("Rigs")
        if not rigs then return nil end
        local rig = rigs:FindFirstChild(player.Name)
        if not rig then return nil end
        local joints = rig:FindFirstChild("Joints")
        if not joints then return nil end
        return joints:FindFirstChild("TorsoRot")
    end

    RunService.Heartbeat:Connect(function()
        if not spinEnabled then return end
        if not torsoRot or not torsoRot.Parent then
            torsoRot = findTorsoRot()
            baseC0 = nil
            lastApplied = nil
            return
        end
        local current = torsoRot.C0
        if lastApplied and current == lastApplied then
            return
        end
        baseC0 = current
    end)

    RunService.RenderStepped:Connect(function(dt)
        if not spinEnabled then return end
        if not torsoRot or not torsoRot.Parent then return end
        if not baseC0 then return end
        local dir = (spinDirection == "Clockwise") and -1 or 1
        spinAngle = (spinAngle + spinRPS * dir * 2 * math.pi * dt) % (2 * math.pi)
        local newC0 = baseC0 * CFrame.Angles(0, spinAngle, 0)
        torsoRot.C0 = newC0
        lastApplied = newC0
    end)

    player.CharacterAdded:Connect(function()
        torsoRot = nil
        baseC0 = nil
        lastApplied = nil
        spinAngle = 0
    end)

    tab:CreateDivider({ text = "Player" })

    tab:CreateToggle({
        name = "Character Spin",
        currentValue = false,
        flag = "CharacterSpin_Toggle",
        callback = function(v)
            spinEnabled = v
            if not v then
                spinAngle = 0
                torsoRot = nil
                baseC0 = nil
                lastApplied = nil
            end
        end,
    })

    tab:CreateDropdown({
        name = "Rotation",
        options = { "Clockwise", "Counterclockwise" },
        currentOption = { "Clockwise" },
        multiSelect = false,
        callback = function(selected)
            local pick = type(selected) == "table" and selected[1] or selected
            if pick then spinDirection = pick end
        end,
    })

    tab:CreateSlider({
        name = "Spin Speed",
        range = {0.1, 10},
        increment = 0.1,
        suffix = " RPS",
        currentValue = 1,
        flag = "CharacterSpin_Slider",
        callback = function(v) spinRPS = v end,
    })
end

--[[
============================================================================
PLAYER ROTATE THING
============================================================================
]]--

do
    local ON_TEMPLATE = [==[
-- LocalScript: ShiftlockRotateOn
-- Turns on automatically when run. Keeps the player rotated relative to the
-- camera direction, and wins any fight with the game (runs last every frame,
-- every physics step, and instantly when something changes the rotation).
-- To change the rotation: edit ROTATION below, then run this script again.

-- ================= EDIT THIS =================
-- Rotation in degrees, applied on top of the camera direction:
--   X = pitch (tilt forward / back)
--   Y = yaw   (0 = forward, 180 = backwards, 90 = left, -90 = right)
--   Z = roll  (tilt sideways)
local ROTATION = Vector3.new(0, 90, 0)
-- =============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local NAME = "CustomShiftlockRotate" -- must match ShiftlockRotateOff

-- Each run gets its own id, so running this again replaces the old run
local runId = tostring(os.clock())
local BIND = NAME .. runId

local rotation = CFrame.fromEulerAnglesYXZ(
	math.rad(ROTATION.X),
	math.rad(ROTATION.Y),
	math.rad(ROTATION.Z)
)

local loopConnections = {}
local hookConnections = {}
local hookedChar

local function stop()
	pcall(function()
		RunService:UnbindFromRenderStep(BIND)
	end)
	for _, c in ipairs(loopConnections) do c:Disconnect() end
	for _, c in ipairs(hookConnections) do c:Disconnect() end
	table.clear(loopConnections)
	table.clear(hookConnections)
	hookedChar = nil
end

local function face()
	-- Off script (or a newer run) changes this, which shuts this run down
	if player:GetAttribute(NAME) ~= runId then
		stop()
		return
	end

	local camera = workspace.CurrentCamera
	local char = player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not camera or not hum or not root then return end

	-- Hook the current character: react the instant anything touches rotation
	if char ~= hookedChar then
		hookedChar = char
		for _, c in ipairs(hookConnections) do c:Disconnect() end
		table.clear(hookConnections)
		table.insert(hookConnections, root:GetPropertyChangedSignal("CFrame"):Connect(face))
		table.insert(hookConnections, hum:GetPropertyChangedSignal("AutoRotate"):Connect(face))
	end

	hum.AutoRotate = false

	-- Physics-level lock
	local align = root:FindFirstChild(NAME)
	if not align then
		local att = Instance.new("Attachment")
		att.Name = NAME .. "Attachment"
		att.Parent = root

		align = Instance.new("AlignOrientation")
		align.Name = NAME
		align.Mode = Enum.OrientationAlignmentMode.OneAttachment
		align.Attachment0 = att
		align.RigidityEnabled = true
		align.CFrame = root.CFrame
		align.Parent = root
	end

	local look = camera.CFrame.LookVector
	local flat = Vector3.new(look.X, 0, look.Z)
	if flat.Magnitude < 0.001 then return end

	-- Camera direction, then your ROTATION on top
	local target = CFrame.lookAt(root.Position, root.Position + flat.Unit) * rotation
	align.CFrame = target

	-- Only rewrite the CFrame if it's actually wrong (prevents event loops)
	local cur = root.CFrame
	if cur.LookVector:Dot(target.LookVector) < 0.99999
		or cur.UpVector:Dot(target.UpVector) < 0.99999 then
		root.CFrame = target
		root.AssemblyAngularVelocity = Vector3.zero
	end
end

player:SetAttribute(NAME, runId)

RunService:BindToRenderStep(BIND, Enum.RenderPriority.Last.Value, face)
table.insert(loopConnections, RunService.Stepped:Connect(face))
table.insert(loopConnections, RunService.Heartbeat:Connect(face))
]==]

    local OFF_SRC = [==[
-- LocalScript: ShiftlockRotateOff
-- Turns the rotating shiftlock off and restores normal character rotation.

local Players = game:GetService("Players")

local player = Players.LocalPlayer
local NAME = "CustomShiftlockRotate"

-- Every running copy of the On script sees this change and shuts itself down
player:SetAttribute(NAME, false)

local char = player.Character
if not char then return end

local root = char:FindFirstChild("HumanoidRootPart")
if root then
	local align = root:FindFirstChild(NAME)
	if align then align:Destroy() end
	local att = root:FindFirstChild(NAME .. "Attachment")
	if att then att:Destroy() end
end

local hum = char:FindFirstChildOfClass("Humanoid")
if hum then
	hum.AutoRotate = true
end
]==]

    local function runSource(src)
        if loadstring then
            local ok, fn = pcall(loadstring, src)
            if ok and fn then pcall(fn) end
        elseif getgenv and getgenv().loadstring then
            local ok, fn = pcall(getgenv().loadstring, src)
            if ok and fn then pcall(fn) end
        end
    end

    local enabled = false
    local pitch = 0
    local yaw = 90
    local roll = 0

    local function buildOnSource()
        local src = ON_TEMPLATE
        local search = "local ROTATION = Vector3.new(0, 90, 0)"
        local replacement = "local ROTATION = Vector3.new(" .. pitch .. ", " .. yaw .. ", " .. roll .. ")"
        local idx = src:find(search, 1, true)
        if idx then
            src = src:sub(1, idx - 1) .. replacement .. src:sub(idx + #search)
        end
        return src
    end

    local function stopAll()
        runSource(OFF_SRC)
    end

    local function startCurrent()
        runSource(buildOnSource())
    end

    tab:CreateDivider()

    tab:CreateToggle({
        name = "Player Rotation Changer",
        currentValue = false,
        flag = "PlayerRotation_Toggle",
        callback = function(v)
            enabled = v
            if v then
                startCurrent()
            else
                stopAll()
            end
        end,
    })

    tab:CreateSlider({
        name = "Pitch",
        range = {0, 359.9},
        increment = 0.1,
        suffix = "°",
        currentValue = 0,
        flag = "PlayerRotation_Pitch",
        callback = function(v)
            pitch = v
            if enabled then
                stopAll()
                startCurrent()
            end
        end,
    })

    tab:CreateSlider({
        name = "Yaw",
        range = {0, 359.9},
        increment = 0.1,
        suffix = "°",
        currentValue = 90,
        flag = "PlayerRotation_Yaw",
        callback = function(v)
            yaw = v
            if enabled then
                stopAll()
                startCurrent()
            end
        end,
    })

    tab:CreateSlider({
        name = "Roll",
        range = {0, 359.9},
        increment = 0.1,
        suffix = "°",
        currentValue = 0,
        flag = "PlayerRotation_Roll",
        callback = function(v)
            roll = v
            if enabled then
                stopAll()
                startCurrent()
            end
        end,
    })
end

--[[
============================================================================

V     I     S     U     A     L     S          (     T     A     B     )

============================================================================
]]--

local VisTab = window:CreateTab({ name = "Visuals", icon = 126802044806598 })

--[[
============================================================================
H and k
============================================================================
]]--

do
	local Players = game:GetService("Players")
	local LP = Players.LocalPlayer

	local headlessMode = "Off"
	local korbloxMode = "Off"
	local savedAccessories = {}

    VisTab:CreateDivider({ text = "Headless (R6)" })

	VisTab:CreateDropdown({
		name = "Headless",
        icon = 85858833083747,
		options = { "Off", "Only Head", "All" },
		default = { "Off" },
		multiSelect = false,
		callback = function(selected)
			headlessMode = type(selected) == "table" and selected[1] or selected
			if headlessMode ~= "All" then
				for rig, accs in pairs(savedAccessories) do
					if rig and rig.Parent then
						for _, acc in pairs(accs) do
							local exists = rig:FindFirstChild(acc.Name) or (rig:FindFirstChild("Head") and rig.Head:FindFirstChild(acc.Name))
							if not exists then
								acc:Clone().Parent = rig
							end
						end
					end
				end
				savedAccessories = {}
			end
		end,
	})

    VisTab:CreateDivider({ text = "Korblox (R6)" })

	VisTab:CreateDropdown({
		name = "Korblox",
        icon = 122114796313973,
		options = { "Off", "Right Leg", "Left Leg", "Both" },
		default = { "Off" },
		multiSelect = false,
		callback = function(selected)
			korbloxMode = type(selected) == "table" and selected[1] or selected
		end,
	})

	task.spawn(function()
		while true do
			local rigs = workspace:FindFirstChild("Rigs")
			if rigs then
				for _, child in ipairs(rigs:GetChildren()) do
					if child.Name == LP.Name then
						local rig = child
						local head = rig:FindFirstChild("Head")

						if head then
							if headlessMode == "Only Head" or headlessMode == "All" then
								head.Transparency = 1
								for _, d in ipairs(head:GetDescendants()) do
									if d:IsA("BasePart") or d:IsA("Decal") or d:IsA("Texture") then
										d.Transparency = 1
									end
								end
							elseif headlessMode == "Off" then
								head.Transparency = 0
								for _, d in ipairs(head:GetDescendants()) do
									if d:IsA("BasePart") or d:IsA("Decal") or d:IsA("Texture") then
										d.Transparency = 0
									end
								end
							end

							if headlessMode == "All" then
								if not savedAccessories[rig] then savedAccessories[rig] = {} end
								local function process(container)
									for _, c in ipairs(container:GetChildren()) do
										if c:IsA("Accessory") or c:IsA("Hat") or c.Name == "Hair" or c:IsA("Face") then
											if not savedAccessories[rig][c.Name] then
												savedAccessories[rig][c.Name] = c:Clone()
												c:Destroy()
											end
										end
									end
								end
								process(rig)
								process(head)
							elseif headlessMode == "Only Head" or headlessMode == "Off" then
								if savedAccessories[rig] then
									for accName, accClone in pairs(savedAccessories[rig]) do
										local exists = rig:FindFirstChild(accName) or head:FindFirstChild(accName)
										if not exists then
											accClone:Clone().Parent = rig
										end
									end
									savedAccessories[rig] = nil
								end
							end
						end

						local function applyKorblox(legName, enable)
							local leg = rig:FindFirstChild(legName) or rig:FindFirstChild(legName:gsub(" ", ""))
							if not leg then return end
							local mesh = leg:FindFirstChild("KorbloxMesh") or leg:FindFirstChildOfClass("SpecialMesh")
							
							if enable then
								if not mesh or mesh.Name ~= "KorbloxMesh" then
									if mesh then mesh:Destroy() end
									mesh = Instance.new("SpecialMesh")
									mesh.Name = "KorbloxMesh"
									mesh.MeshType = Enum.MeshType.FileMesh
									mesh.MeshId = "rbxassetid://14581620882"
									mesh.TextureId = "rbxassetid://14581621055"
									mesh.Offset = Vector3.new(0, 0.55, 0)
									mesh.Scale = Vector3.new(1.15, 1.15, 1.15)
									mesh.Parent = leg
								end
							else
								if mesh and mesh.Name == "KorbloxMesh" then mesh:Destroy() end
							end
						end

						if korbloxMode == "Both" then
							applyKorblox("Right Leg", true)
							applyKorblox("Left Leg", true)
						elseif korbloxMode == "Right Leg" then
							applyKorblox("Right Leg", true)
							applyKorblox("Left Leg", false)
						elseif korbloxMode == "Left Leg" then
							applyKorblox("Right Leg", false)
							applyKorblox("Left Leg", true)
						elseif korbloxMode == "Off" then
							applyKorblox("Right Leg", false)
							applyKorblox("Left Leg", false)
						end
					end
				end
			end
			task.wait(0.5)
		end
	end)
end

--[[
============================================================================
FOV
============================================================================
]]--

do
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local fovEnabled = false
    local fovValue = 90

    local function getSetSetting()
        local shared = ReplicatedStorage:FindFirstChild("Shared")
        if not shared then return nil end
        local ud = shared:FindFirstChild("UserData")
        if not ud then return nil end
        local remotes = ud:FindFirstChild("Remotes")
        if not remotes then return nil end
        return remotes:FindFirstChild("SetSetting")
    end

    local function fireFOV(value)
        local remote = getSetSetting()
        if not remote then return end
        pcall(function()
            remote:FireServer("FOV", value)
        end)
    end

    VisTab:CreateDivider()

    VisTab:CreateToggle({
        name = "FOV Changer",
        icon = 97562574851729,
        currentValue = false,
        flag = "FOVChanger_Toggle",
        callback = function(v)
            fovEnabled = v
            if v then
                fireFOV(fovValue)
            else
                fireFOV(90)
            end
        end,
    })

    VisTab:CreateInput({
        name = "FOV Value",
        icon = 80363621811850,
        placeholder = "e.g. 120",
        callback = function(text)
            local n = tonumber(text)
            if n then
                fovValue = n
                if fovEnabled then
                    fireFOV(fovValue)
                end
            end
        end,
    })
end

--[[
============================================================================

E     X     T     R     A     S          (     T     A     B     )

============================================================================
]]--

local ExTab = window:CreateTab({ name = "Extra", icon = 108740503011398 })

--[[
============================================================================

P     L     A     Y     E     R          (     T     A     B     )

============================================================================
]]--

local PlyrTab = window:CreateTab({ name = "Player", icon = 98364829449527 })

--[[
============================================================================

S     T     A     T     S               (     T     A     B     )

============================================================================
]]--

local StsTab = window:CreateTab({ name = "Stats", icon = 115151888442101 })

--[[
============================================================================

T     A     S          (     T     A     B     )

============================================================================
]]--

local TasTab = window:CreateTab({ name = "TAS", icon = 106970371098897 })

--[[
============================================================================

A     U     T     O          F     A     R     M          (     T     A     B     )

============================================================================
]]--

local AfTab = window:CreateTab({ name = "Auto Farm", icon = 96086831296475 })

--[[
============================================================================

A     T     M     O     S     P     H     E     R     E          (     T     A     B     )

============================================================================
]]--

local AtmoTab = window:CreateTab({ name = "Atmosphere", icon = 90547516100800 })


--[[
============================================================================

C     O     S     M     E     T     I     C     S          (     T     A     B     )

============================================================================
]]--

local CosTab = window:CreateTab({ name = "Cosmetics", icon = 93893786571261 })
buildEmoteChanger(CosTab, window)
buildCosmeticChanger(CosTab, window)

--[[
============================================================================

T     E     L     E     P     O     R     T          (     T     A     B     )

============================================================================
]]--

local TpTab = window:CreateTab({ name = "Teleport", icon = 138254104860948 })

--[[
============================================================================

V     C     L          (     T     A     B     )

============================================================================
]]--

local VclTab = window:CreateTab({ name = "Vehicle", icon = 12338080417 })

--[[
============================================================================

M     A     P          (     T     A     B     )

============================================================================
]]--

local MapTab = window:CreateTab({ name = "Map", icon = 78731952302365 })

--[[
============================================================================

S     C     P               (     T     A     B     )

============================================================================
]]--

local ScriptTab = window:CreateTab({ name = "Script Settings", icon = 89152067769809 })

do
    ScriptTab:CreateDivider({ text = "Appearance" })

    ScriptTab:CreateDropdown({
        name = "Change Theme",
        options = { "Default", "Cobalt", "Ember", "Amethyst", "Frost", "Rose" },
        currentOption = { "Default" },
        multiSelect = false,
        callback = function(selected)
            local pick = type(selected) == "table" and selected[1] or selected
            if pick then
                window:ChangeTheme(pick)
            end
        end,
    })
end

-- CREDITS
local CreTab = window:CreateTab({ name = "Credits", icon = 110016491347992 })

-- Scroll Logic tuff Boi

do
    local function addTabNav(targetTab, prevName, nextName)
        targetTab:CreateDivider()
        if prevName then
            targetTab:CreateButton({
                name = "Previous Tab",
				icon = 93740731423685,
                callback = function()
                    pcall(function() window:Navigate(prevName) end)
                end,
            })
        end
        if nextName then
            targetTab:CreateButton({
                name = "Next Tab",
				icon = 88792938137507,
                callback = function()
                    pcall(function() window:Navigate(nextName) end)
                end,
            })
        end
    end

    addTabNav(tab,       nil,              "Visuals")
    addTabNav(VisTab,    "Main",           "Extra")
    addTabNav(ExTab,     "Visuals",        "Player")
    addTabNav(PlyrTab,   "Extra",          "Stats")
    addTabNav(StsTab,    "Player",         "TAS")
    addTabNav(TasTab,    "Stats",          "Auto Farm")
    addTabNav(AfTab,     "TAS",            "Atmosphere")
    addTabNav(AtmoTab,   "Auto Farm",      "Cosmetics")
    addTabNav(CosTab,    "Atmosphere",     "Teleport")
    addTabNav(TpTab,     "Cosmetics",      "Vehicle")
    addTabNav(VclTab,    "Teleport",       "Map")
    addTabNav(MapTab,    "Vehicle",        "Script Settings")
    addTabNav(ScriptTab, "Map",            "Credits")
    addTabNav(CreTab,    "Script Settings", nil)
end

-- ==================
-- S C R I P T    E N D
-- ==================
-- ``
