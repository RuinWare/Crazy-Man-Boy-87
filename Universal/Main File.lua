--[[
===========================
EARLY DECLARATIONS
===========================
]]--

_G.SPEEDCHANGER_SLIDERQ = 16
getgenv().SPEEDCHANGER_SLIDERQ = 16

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/gen2"))()

-- WINDOW
local window = Rayfield:CreateWindow({
    name = "RuinWare Client",
    icon = 98691154054966,
    subtitle = "Universal",
    sidebarLayout = true,
    theme = "Default",
    showIcon = 98691154054966,
    showName = "RuinWare",

})

--[[
===========================
MAIN
===========================
]]--

local tab = window:CreateTab({ name = "Main", icon = 83935746771599 })

tab:CreateDivider({ text = "Player" })

do
local RunService = game:GetService("RunService")
_G.SPEEDCHANGER_SLIDERQ = 16
local speedEnabled = false

tab:CreateToggle({
    name = "Speed Changer",
    flag = "SpeedChanger",
    value = false,
    callback = function(v) speedEnabled = v end,
})

tab:CreateSlider({
    name = "Speed:",
    flag = "SpeedSlider",
    range = {16, 200},
    increment = 1,
    value = 16,
    callback = function(v) SPEEDCHANGER_SLIDERQ = v end,
})

RunService.Heartbeat:Connect(function()
    local char = game.Players.LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = speedEnabled and SPEEDCHANGER_SLIDERQ or 16
           end
     end)
end

--[[
===========================
FLY
===========================
]]--

do
    local flyEnabled = false
    local flySpeed = 100
    local flyHum, flyRoot

    local function flyAttach(char)
        flyHum = char:WaitForChild("Humanoid")
        flyRoot = char:WaitForChild("HumanoidRootPart")
        if flyEnabled then flyHum.WalkSpeed = 0 end
    end

    if player.Character then task.spawn(flyAttach, player.Character) end
    player.CharacterAdded:Connect(function(c) task.spawn(flyAttach, c) end)

    RunService.Heartbeat:Connect(function(dt)
        if not flyEnabled then return end
        if not flyHum or not flyRoot or not flyRoot.Parent then return end
        if flyHum.Health <= 0 then return end

        flyHum.WalkSpeed = 0

        local moveDir = flyHum.MoveDirection
        local moveFlat = Vector3.new(moveDir.X, 0, moveDir.Z)

        if moveFlat.Magnitude < 0.001 then
            flyRoot.AssemblyLinearVelocity = Vector3.zero
            return
        end
        moveFlat = moveFlat.Unit

        local cam = workspace.CurrentCamera
        local camLook = cam and cam.CFrame.LookVector or Vector3.new(0, 0, -1)
        local camFlat = Vector3.new(camLook.X, 0, camLook.Z)

        local verticalComponent = 0
        if camFlat.Magnitude > 0.01 then
            camFlat = camFlat.Unit
            local forwardness = camFlat:Dot(moveFlat)
            verticalComponent = forwardness * camLook.Y * flySpeed * 0.55
        else
            verticalComponent = camLook.Y * flySpeed * 0.55
        end

        local horizontal = moveFlat * flySpeed * dt
        local vertical = Vector3.new(0, verticalComponent * dt, 0)

        flyRoot.CFrame = flyRoot.CFrame + horizontal + vertical
        flyRoot.AssemblyLinearVelocity = Vector3.zero
    end)

    tab:CreateDivider({ text = "Fly" })

    tab:CreateToggle({
        name = "Fly",
		icon = 101627766519965,
        currentValue = false,
        flag = "Fly_Toggle",
        callback = function(v)
            flyEnabled = v
            if flyHum then
                flyHum.WalkSpeed = v and 0 or 16
            end
        end,
    })
    
    tab:CreateSlider({
        name = "Fly Speed",
		icon = 79297485010070,
        range = {16.6, 500.5},
        increment = 0.1,
        suffix = " sps",
        currentValue = 100,
        flag = "Fly_Slider",
        callback = function(v) flySpeed = v end,
    })
end
