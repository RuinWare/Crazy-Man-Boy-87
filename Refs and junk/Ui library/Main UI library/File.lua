local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/RuinWare/Crazy-Man-Boy-87/refs/heads/main/Refs%20and%20junk/Ui%20library/Main%20UI%20library/UI"))()

local window = Library:CreateWindow({
    name = "RuinWare Client",
    icon = 98691154054966,
    subtitle = "Evade",
})

-- tabs
-- main
local tab = window:CreateTab({ name = "Main", icon = 83935746771599 })

tab:CreateSection({ name = "Movement" })

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

-- map

local MapTab = window:CreateTab({ name = "Map", icon = 78731952302365 })
