-- w
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

tab:CreateSection({ name = "Jumping" })

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

main:CreateRightRow()

tab:CreateSection({ name = "Movement" })

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

tab:CreateToggle({
    name = "Easy Bounce",
    icon = 116414714090955,
    value = false,
	haveMB = true,
	haveKeybinds = true,
    flag = "EasyBounce_Toggle",
    callback = function(v)
        easyBounceEnabled = v
    end,
})

tab:CreateSlider({
    name = "Easy Bounce Multiplier",
    icon = 120597962040224,
    range = {1.08, 3.00},
    increment = 0.01,
    suffix = "x",
    value = 1.5,
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
    value = false,
	haveMB = true,
	haveKeybinds = true,
    flag = "HardBounce_Toggle",
    callback = function(value)
        hardBounceEnabled = value
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
    value = false,
	haveMB = true,
	haveKeybinds = true,
    flag = "LegitBounce_Toggle",
    callback = function(value)
        legitBounceEnabled = value
    end,
})

--[[
===========================
EF
===========================
]]--

do
    local emoteFlingEnabled = false
    local EMOTE_FLING_MULTIPLIER = 5.00

    local emoteFlingStateConn
    local emoteFlingLastYVelocity = 0
    local emoteFlingAirStartTime = 0
    local emoteFlingWasInAir = false

    local function attachEmoteFling(char)
        local hum = char:WaitForChild("Humanoid")
        local root = char:WaitForChild("HumanoidRootPart")

        if emoteFlingStateConn then emoteFlingStateConn:Disconnect() end
        emoteFlingStateConn = hum.StateChanged:Connect(function(_, newState)
            if not emoteFlingEnabled then return end
            if newState ~= Enum.HumanoidStateType.Landed then return end
            if hum.Health <= 0 then return end
            if not emoteFlingWasInAir then return end
            if (tick() - emoteFlingAirStartTime) < 2 then return end
            local bounceVel = math.abs(emoteFlingLastYVelocity) * EMOTE_FLING_MULTIPLIER
            if bounceVel < 10 then return end
            root.AssemblyLinearVelocity = Vector3.new(
                root.AssemblyLinearVelocity.X,
                bounceVel,
                root.AssemblyLinearVelocity.Z
            )
        end)
    end

    if player.Character then
        task.spawn(attachEmoteFling, player.Character)
    end
    player.CharacterAdded:Connect(function(char)
        task.spawn(attachEmoteFling, char)
    end)

    RunService.Heartbeat:Connect(function()
        if not emoteFlingEnabled then return end
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root then return end

        emoteFlingLastYVelocity = root.AssemblyLinearVelocity.Y

        if hum.FloorMaterial == Enum.Material.Air then
            if not emoteFlingWasInAir then
                emoteFlingWasInAir = true
                emoteFlingAirStartTime = tick()
            end
        else
            emoteFlingWasInAir = false
        end
    end)

    tab:CreateDivider()
	
    tab:CreateToggle({
        name = "Emote Fling",
        value = false,
		haveMB = false,
		haveKeybinds = false,
        flag = "EmoteFling_Toggle",
        callback = function(v)
            emoteFlingEnabled = v
        end,
    })
end

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

local UpdateCharacterDataRegistry = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Registry"):WaitForChild("UpdateCharacterDataRegistry")
local CharacterTask = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Character"):WaitForChild("CharacterTask")
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
    name = "Infinite Slide",
    icon = 84806424467602,
    value = false,
	haveMB = true,
	haveKeybinds = true,
    flag = "InfSlide_Toggle",
    callback = function(v)
        infSlideEnabled = v
    end,
})

tab:CreateSlider({
    name = "Inf Slide Speed",
    icon = 79297485010070,
    range = {1, 90},
    increment = 1,
    value = 25,
    flag = "InfSlide_Speed",
    callback = function(v) infSlideSpeed = v end,
})

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
    name = "Y Baseplate Surf",
    icon = 139863028132428,
    value = false,
	haveMB = true,
	haveKeybinds = true,
    flag = "YLock_Toggle",
    callback = function(value)
        yLockEnabled = value
        toggleYLock(value)
    end,
})

tab:CreateToggle({
    name = "Y Lock Surf",
    icon = 139863028132428,
    value = false,
	haveMB = true,
	haveKeybinds = true,
    flag = "YLock_Toggle",
    callback = function(v)
        if v then
local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")

if _G.RuinWareYLockConnection then
    _G.RuinWareYLockConnection:Disconnect()
end

local lockedY = nil

_G.RuinWareYLockConnection = runService.RenderStepped:Connect(function()
    local character = player.Character
    if not character then return end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if not lockedY then
        lockedY = hrp.Position.Y
    end

    local pos = hrp.Position
    local look = hrp.CFrame.LookVector
    local flatLook = Vector3.new(look.X, 0, look.Z)
    
    if flatLook.Magnitude < 0.01 then flatLook = Vector3.new(0, 0, -1) end
    flatLook = flatLook.Unit

    hrp.CFrame = CFrame.lookAt(Vector3.new(pos.X, lockedY, pos.Z), Vector3.new(pos.X, lockedY, pos.Z) + flatLook)

    local vel = hrp.AssemblyLinearVelocity
    if math.abs(vel.Y) > 0.1 then
        hrp.AssemblyLinearVelocity = Vector3.new(vel.X, 0, vel.Z)
    end
end)
			else
				if _G.RuinWareYLockConnection then
    _G.RuinWareYLockConnection:Disconnect()
    _G.RuinWareYLockConnection = nil
				end
	    end
	end,
})

--[[
============================================================================
PX SURF
============================================================================
]]--

do
    -- ========================================
    -- EDIT THESE URLs
    -- ========================================
    local ON_URL  = "https://raw.githubusercontent.com/RuinWare/ExtraRW/refs/heads/main/Pixelsurfon"
    local OFF_URL = "https://raw.githubusercontent.com/RuinWare/ExtraRW/refs/heads/main/Pxlsof"
    -- ========================================

    local pixelSurfEnabled = false
    local pixelSurfActive = false

    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude

    local function runURL(url)
        if not url or url == "" then return end
        pcall(function()
            local src = game:HttpGet(url)
            if loadstring then loadstring(src)() end
        end)
    end

local function isTouchingWall(char, root)
    rayParams.FilterDescendantsInstances = {char}
    local origin = root.Position
    -- Cast from 3 heights (lower, center, upper) so small alignment errors don't matter
    local heightOffsets = { -0.8, 0, 0.8 }
    local rayLength = 1.65 -- was 1.5, now detects walls from ~2x farther away
    for _, yOff in ipairs(heightOffsets) do
        local castOrigin = origin + Vector3.new(0, yOff, 0)
        for i = 0, 15 do -- 16 directions instead of 8
            local angle = (math.pi / 8) * i
            local dir = Vector3.new(math.cos(angle), 0, math.sin(angle))
            local result = workspace:Raycast(castOrigin, dir * rayLength, rayParams)
            if result then
                return true
            end
        end
    end
    return false
end

    RunService.Heartbeat:Connect(function()
        if not pixelSurfEnabled then return end
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root then return end

        local airborne = hum.FloorMaterial == Enum.Material.Air
        local shouldActivate = airborne and isTouchingWall(char, root)

        if shouldActivate and not pixelSurfActive then
            pixelSurfActive = true
            runURL(ON_URL)
        elseif not shouldActivate and pixelSurfActive then
            pixelSurfActive = false
            runURL(OFF_URL)
        end
    end)

    tab:CreateToggle({
        name = "Pixel Surf",
		icon = 76201258239230,
        value = false,
		haveMB = true,
		haveKeybinds = true,
        flag = "PixelSurf_Toggle",
        callback = function(v)
            pixelSurfEnabled = v
            if not v and pixelSurfActive then
                pixelSurfActive = false
                runURL(OFF_URL)
            end
        end,
    })
end

--[[
===========================
DOWNED DASH
===========================
]]--

do
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local downedDashEnabled = false
    local downedDashActive = false
    local downedDashSpeed = 55.5

    local ddHum, ddRoot
    local anchorPart, weldConstraint, cachedBm
    local UpdateCharacterDataRegistry

    local function getRemote()
        if UpdateCharacterDataRegistry and UpdateCharacterDataRegistry.Parent then
            return UpdateCharacterDataRegistry
        end
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if not remotes then return nil end
        local registry = remotes:FindFirstChild("Registry")
        if not registry then return nil end
        UpdateCharacterDataRegistry = registry:FindFirstChild("UpdateCharacterDataRegistry")
        return UpdateCharacterDataRegistry
    end

    local function cleanup()
        if weldConstraint then
            pcall(function() weldConstraint:Destroy() end)
            weldConstraint = nil
        end
        if anchorPart then
            pcall(function() anchorPart:Destroy() end)
            anchorPart = nil
        end
        if cachedBm and cachedBm.Parent then
            pcall(function() cachedBm.Enabled = true end)
        end
        cachedBm = nil
    end

    local function activate(root)
        if not root or not root.Parent then return end
        cleanup()

        anchorPart = Instance.new("Part")
        anchorPart.Name = "DownedDashAnchor"
        anchorPart.Size = Vector3.new(2, 2, 2)
        anchorPart.Transparency = 1
        anchorPart.CanCollide = false
        anchorPart.CanQuery = false
        anchorPart.CanTouch = false
        anchorPart.Anchored = true
        anchorPart.Massless = true
        anchorPart.CFrame = root.CFrame
        anchorPart.Parent = workspace

        weldConstraint = Instance.new("WeldConstraint")
        weldConstraint.Name = "DownedDashWeld"
        weldConstraint.Part0 = root
        weldConstraint.Part1 = anchorPart
        weldConstraint.Parent = root

        -- Also disable the BaseMover constraint as backup — the weld pins the
        -- HRP but the constraint will still try to apply velocity and jitter
        local bm = root:FindFirstChild("LinearVelocity")
        if bm and bm:IsA("LinearVelocity") then
            cachedBm = bm
            pcall(function() bm.Enabled = false end)
        end
    end

    local function ddAttach(char)
        ddHum = char:WaitForChild("Humanoid")
        ddRoot = char:WaitForChild("HumanoidRootPart")
        downedDashActive = false
        cleanup()
    end

    if player.Character then task.spawn(ddAttach, player.Character) end
    player.CharacterAdded:Connect(function(c) task.spawn(ddAttach, c) end)
    player.CharacterRemoving:Connect(function() cleanup() end)

    local function hasState(args, target, depth)
        depth = depth or 0
        if depth > 5 then return false end
        for _, a in ipairs(args) do
            if type(a) == "string" and a == target then return true end
            if type(a) == "table" then
                for _, v in pairs(a) do
                    if type(v) == "string" and v == target then return true end
                    if type(v) == "table" and hasState({v}, target, depth + 1) then return true end
                end
            end
        end
        return false
    end

    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        if getnamecallmethod() == "FireServer" and downedDashEnabled then
            local remote = getRemote()
            if remote and self == remote then
                local args = {...}
                if hasState(args, "Downed") then
                    downedDashActive = true
                    if ddRoot then activate(ddRoot) end
                elseif hasState(args, "Idle") then
                    downedDashActive = false
                    cleanup()
                end
            end
        end
        return oldNamecall(self, ...)
    end)

    RunService.Heartbeat:Connect(function(dt)
        if not downedDashEnabled or not downedDashActive then return end
        if not anchorPart or not anchorPart.Parent then
            if ddRoot then activate(ddRoot) end
            return
        end
        if not ddRoot or not ddRoot.Parent then return end

        local cam = workspace.CurrentCamera
        if not cam then return end
        local look = cam.CFrame.LookVector
        local dir = Vector3.new(look.X, 0, look.Z)
        if dir.Magnitude > 0.001 then dir = dir.Unit end

        local speed = downedDashSpeed * 0.5
        anchorPart.CFrame = anchorPart.CFrame + dir * speed * dt
    end)

    tab:CreateLeftRow()
	
	tab:CreateSection({ name = "Advanced" })

    tab:CreateToggle({
        name = "Overhaul Auto Downed Dash",
        value = false,
        flag = "DownedDash_Toggle",
        callback = function(v)
            downedDashEnabled = v
            if not v then
                downedDashActive = false
                cleanup()
            end
        end,
    })

    tab:CreateSlider({
        name = "Downed Dash Speed",
        range = {33.3, 555.5},
        increment = 0.1,
        suffix = "",
        value = 55.5,
        flag = "DownedDash_Slider",
        callback = function(v) downedDashSpeed = v end,
    })
end

--[[
===========================
EASY EDGE
===========================
]]--

do
    local edgeTrimpEnabled = false
    local edgeTrimpPower = 100

    local TRIMP_HORIZONTAL_DISTANCE = 1.1
    local TRIMP_VERTICAL_MIN = -0.5
    local TRIMP_VERTICAL_MAX = 1.5
    local RAY_LENGTH = 5
    local COOLDOWN = 0.4

    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude

    local lastTrigger = 0

    local function getFeetInfo(char, root)
        local bestY = nil
        local names = { "RightFoot", "LeftFoot", "RightLowerLeg", "LeftLowerLeg", "Right Leg", "Left Leg" }
        for _, name in ipairs(names) do
            local part = char:FindFirstChild(name)
            if part and part:IsA("BasePart") then
                local bottomY = part.Position.Y - part.Size.Y / 2
                if not bestY or bottomY < bestY then
                    bestY = bottomY
                end
            end
        end
        if not bestY then
            bestY = root.Position.Y - 3
        end
        return Vector3.new(root.Position.X, bestY, root.Position.Z)
    end

    local function tryTrimpAt(origin, feetY)
        for i = 0, 15 do
            local angle = (math.pi * 2 / 16) * i
            local dir = Vector3.new(math.cos(angle), 0, math.sin(angle))

            local result = workspace:Raycast(origin, dir * RAY_LENGTH, rayParams)
            if result and result.Instance and result.Distance <= TRIMP_HORIZONTAL_DISTANCE then
                local part = result.Instance
                local wallTopY = part.Position.Y + (part.Size.Y / 2)
                local delta = wallTopY - feetY

                if delta >= TRIMP_VERTICAL_MIN and delta <= TRIMP_VERTICAL_MAX then
                    return true
                end
            end
        end
        return false
    end

    local function checkEdgeTrimp()
        if not edgeTrimpEnabled then return end
        if tick() - lastTrigger < COOLDOWN then return end

        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root then return end
        if hum.Health <= 0 then return end

        rayParams.FilterDescendantsInstances = {char}

        local feetPos = getFeetInfo(char, root)
        local heights = { 0, 0.3, 0.6, 0.9, 1.2, 1.5 }

        for _, h in ipairs(heights) do
            local origin = Vector3.new(feetPos.X, feetPos.Y + h, feetPos.Z)
            if tryTrimpAt(origin, feetPos.Y) then
                lastTrigger = tick()
                root.AssemblyLinearVelocity = Vector3.new(
                    root.AssemblyLinearVelocity.X,
                    edgeTrimpPower,
                    root.AssemblyLinearVelocity.Z
                )
                return
            end
        end
    end

    RunService.Heartbeat:Connect(checkEdgeTrimp)

tab:CreateDivider()

    tab:CreateToggle({
        name = "Easy Edge Trimp",
        value = false,
        flag = "EdgeTrimp_Toggle",
		haveMB = true,
		haveKeybinds = true,
        callback = function(value) 
           edgeTrimpEnabled = value
       end,
    })

    tab:CreateSlider({
        name = "Power:",
        range = {10, 500},
        increment = 1,
        suffix = "",
        value = 100,
        flag = "EdgeTrimp_Power",
        callback = function(v) edgeTrimpPower = v end,
    })
end

--[[
===========================
SUPERJUMP
===========================
]]--

do
    local superJumpEnabled = false
    local superJumpYVelocity = 100
    local superJumpXVelocity = 50
    local superJumpDecaying = false
    local superJumpDecayRate = 5
    local sjHum, sjRoot

    local function sjAttach(char)
        sjHum = char:WaitForChild("Humanoid")
        sjRoot = char:WaitForChild("HumanoidRootPart")
    end

    if player.Character then task.spawn(sjAttach, player.Character) end
    player.CharacterAdded:Connect(function(c) task.spawn(sjAttach, c) end)

    local function triggerSuperJump()
        if not superJumpEnabled then return end
        if not sjRoot or not sjRoot.Parent then return end
        if not sjHum or sjHum.Health <= 0 then return end

        local look = sjRoot.CFrame.LookVector
        local forward = Vector3.new(look.X, 0, look.Z)
        if forward.Magnitude > 0.001 then forward = forward.Unit end

        sjRoot.AssemblyLinearVelocity = Vector3.new(
            forward.X * superJumpXVelocity,
            superJumpYVelocity,
            forward.Z * superJumpXVelocity
        )

        superJumpDecaying = true
    end

    RunService.Heartbeat:Connect(function(dt)
        if not superJumpDecaying then return end
        if not sjRoot or not sjRoot.Parent then
            superJumpDecaying = false
            return
        end

        local vel = sjRoot.AssemblyLinearVelocity
        local horizontal = Vector3.new(vel.X, 0, vel.Z)

        if horizontal.Magnitude < 1 then
            superJumpDecaying = false
            return
        end

        local decay = math.exp(-superJumpDecayRate * dt)
        horizontal = horizontal * decay

        sjRoot.AssemblyLinearVelocity = Vector3.new(horizontal.X, vel.Y, horizontal.Z)
    end)

tab:CreateDivider()

    tab:CreateToggle({
        name = "Super Jump",
        value = false,
		haveMB = true,
		haveKeybinds = true,
        flag = "SuperJump_Toggle",
        callback = function(v)
           superJumpEnabled = v

       end,
    })

    tab:CreateSlider({
        name = "Y Velocity",
        range = {10, 500},
        increment = 1,
        suffix = "",
        value = 100,
        flag = "SuperJump_YVelocity",
        callback = function(v) superJumpYVelocity = v end,
    })

    tab:CreateSlider({
        name = "X Velocity",
        range = {0, 500},
        increment = 1,
        suffix = "",
        value = 50,
        flag = "SuperJump_XVelocity",
        callback = function(v) superJumpXVelocity = v end,
    })
end
--[[
============================================================================
F JUMP
===========================================================================
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

    tab:CreateSection({ name = "Pushing" })

    tab:CreateToggle({
        name = "Frontal Jump",
        icon = 89569262948298,
        value = false,
        flag = "FrontalJump_Toggle",
        callback = function(v)
            frontalEnabled = v
            if fHum then fHum.WalkSpeed = v and 0 or 16 end
        end,
    })
	
    tab:CreateToggle({
        name = "Frontal Jump Ramp Protection",
        icon = 111308594268728,
        value = false,
        flag = "FrontalJump_Ramp_Toggle",
        callback = function(v) frontalRamp = v end,
    })
	
    tab:CreateSlider({
        name = "Frontal Jump Speed",
        icon = 79297485010070,
        range = {33.3, 555.5},
        increment = 0.1,
        suffix = "",
        value = 55.5,
        flag = "FrontalJump_Slider",
        callback = function(v) frontalSlider = v end,
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
