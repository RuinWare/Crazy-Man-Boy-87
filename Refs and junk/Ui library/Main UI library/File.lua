-- !strict

local SHARED_PATHS = {
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

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/RuinWare/Crazy-Man-Boy-87/refs/heads/main/Refs%20and%20junk/Ui%20library/Main%20UI%20library/UI"))()

-- Logic cos

--[[
============================================================================

E     M     O     T     E          L     O     G     I     C

============================================================================
]]--


local function buildEmoteChanger(tab, window)
	local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local PATHS = SHARED_PATHS

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
tab:CreateSection({ name = "Emotes", icon = 121586615710226 })
tab:CreateLeftRow()
        tab:CreateDivider({ text = "Emote Changer" })

	tab:CreateToggle({
		name = "Use Textbox",
                icon = 131412776187171,
		value = false,
		callback = function(v) state.UseTextbox = v end,
	})

tab:CreateInput({
    name = "Current Emote",
    icon = 130515857256476,
    placeholder = "e.g. Smug Dance",
    callback = function(text)
        local found = findEmote(text)
        state.Current = found
        Library:Notify({
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
			Library:Notify({
				title = "Emote Swapper",
				content = found and ("Found: "..getDisplayName(found)) or ("Not found: "..text),
				duration = 3,
			})
		end,
	})

	tab:CreateInput({
		name = "Variant",
                icon = 96729358707744,
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
                icon = 94713520185581,
		options = buildEmoteList(),
		multiSelect = false,
		callback = function(selected)
			local picked = type(selected) == "table" and selected[1] or selected
			state.Dropdown = findEmote(picked)
		end,
	})

	tab:CreateButton({
		name = "Change Emotes",
        icon = 105433648935304,
		callback = function()
			local target = state.Current
			if not target then
				Library:Notify({ title = "Emote Swapper", content = "Current emote not found.", duration = 5 })
				return
			end
			local source = state.UseTextbox and state.SuggestedText or state.Dropdown
			if not source then
				Library:Notify({ title = "Emote Swapper", content = "Suggested emote not found.", duration = 5 })
				return
			end
			if target == source then
				local ok = resetItem(target)
				Library:Notify({
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
            Library:Notify({
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
tab:CreateRightRow()
tab:CreateSection({ name = "Cosmetics", icon = 85228918424110 })
	
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
			Library:Notify({
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
			Library:Notify({
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
				Library:Notify({ title = "Cosmetic Swapper", content = "Current cosmetic not found.", duration = 5 })
				return
			end
			local source = state.UseTextbox and state.SuggestedText or state.Dropdown
			if not source then
				Library:Notify({ title = "Cosmetic Swapper", content = "Suggested cosmetic not found.", duration = 5 })
				return
			end
			if target == source then
				local ok = resetItem(target)
				Library:Notify({
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
			Library:Notify({
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

-- window

local window = Library:CreateWindow({
    name = "RuinWare Client",
    icon = 98691154054966,
    subtitle = "Evade",
})

-- tabs
-- main
local tab = window:CreateTab({ name = "Main", icon = 83935746771599 })

tab:CreateLeftRow()

tab:CreateSection({ name = "Movement" })

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
	haveMB = true,
	haveKeybinds = true,
    value = false,
    flag = "AutoJump_Toggle",
    callback = function(v)
        autoJumpEnabled = v
      end,
})

tab:CreateToggle({
    name = "Ramp Protection",
    icon = 111308594268728,
    value = false,
    flag = "AutoJump_RampProtection_Toggle",
    callback = function(value)
        rampProtection = value
    end,
})

tab:CreateToggle({
    name = "Only Trigger On Look Down",
    icon = 128804949999663,
    value = false,
    flag = "AutoJump_LookDown_Toggle",
    callback = function(value)
        lookDownOnly = value
    end,
})

tab:CreateToggle({
    name = "Only Trigger On Move",
    icon = 135743813499745,
    value = false,
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
    value = 0,
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
        value = false,
		haveMB = true,
		haveKeybinds = true,
        flag = "DelayJump_Toggle",
        callback = function(v) 
         djEnabled = v 
          end,
    })
	
    tab:CreateToggle({
        name = "Legit Jump Ramp Protection",
        icon = 111308594268728,
        value = false,
        flag = "DelayJump_Ramp_Toggle",
        callback = function(v) djRamp = v end,
    })

    tab:CreateToggle({
        name = "Legit Jump Only Look Down",
        icon = 128804949999663,
        value = false,
        flag = "DelayJump_LookDown_Toggle",
        callback = function(v) djLookDown = v end,
    })

    tab:CreateToggle({
        name = "Legit Jump Only On Move",
        icon = 135743813499745,
        value = false,
        flag = "DelayJump_MoveOnly_Toggle",
        callback = function(v) djMoveOnly = v end,
    })

    tab:CreateSlider({
        name = "Legit Jump Move Hold",
        icon = 136077598178846,
        range = {0, 5},
        increment = 0.05,
        suffix = "s",
        value = 0,
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
        value = false,
		haveMB = true,
		haveKeybinds = true,
        flag = "HoldJump_Toggle",
        callback = function(v)
            hjEnabled = v
       end,
    })
	
    tab:CreateToggle({
        name = "Hold Jump Ramp Protection",
        icon = 111308594268728,
        value = false,
        flag = "HoldJump_Ramp_Toggle",
        callback = function(v) hjRamp = v end,
    })

    tab:CreateToggle({
        name = "Hold Jump Only Look Down",
        icon = 128804949999663,
        value = false,
        flag = "HoldJump_LookDown_Toggle",
        callback = function(v) hjLookDown = v end,
    })

    tab:CreateToggle({
        name = "Hold Jump Only On Move",
        icon = 135743813499745,
        value = false,
        flag = "HoldJump_MoveOnly_Toggle",
        callback = function(v) hjMoveOnly = v end,
    })

    tab:CreateSlider({
        name = "Hold Jump Move Hold",
        icon = 136077598178846,
        range = {0, 5},
        increment = 0.05,
        suffix = "s",
        value = 0,
        flag = "HoldJump_MoveHold",
        callback = function(v) hjMoveHold = v end,
    })
end

-- vis

local VisTab = window:CreateTab({ name = "Visuals", icon = 126802044806598 })

-- ex

local ExTab = window:CreateTab({ name = "Extra", icon = 108740503011398 })

-- play

local PlyrTab = window:CreateTab({ name = "Player", icon = 98364829449527 })

-- tas

local TasTab = window:CreateTab({ name = "TAS", icon = 106970371098897 })

-- af

local AfTab = window:CreateTab({ name = "Auto Farm", icon = 96086831296475 })

-- atmo

local AtmoTab = window:CreateTab({ name = "Atmosphere", icon = 90547516100800 })

-- cos

local CosTab = window:CreateTab({ name = "Cosmetics", icon = 93893786571261 })
buildEmoteChanger(CosTab, window)
buildCosmeticChanger(CosTab, window)
-- map

local MapTab = window:CreateTab({ name = "Map", icon = 78731952302365 })
