
local SCRIPT_VERSION = 353
local VERSION_URL = "https://raw.githubusercontent.com/binx-ux/airhub-binxix-v6/main/VERSION"

_G.BinxixUnloaded = false

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

local currentPlaceId = game.PlaceId

-- ===== BLOCKED GAMES =====
do
    local StarterGui = game:GetService("StarterGui")
    local blockedGames = {
        [83728249169833] = "Quick-Shot",
        [95721658376580] = "MTC",
        [109397169461300] = "SNIPER DUELS",
    }
    local gameName = blockedGames[currentPlaceId]
    if gameName then
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = "Binxix Hub V6",
                Text = gameName .. " is not supported.",
                Duration = 8
            })
        end)
        warn("[Binxix Hub V6] Script disabled on " .. gameName)
        _G.BinxixUnloaded = true
        error("[Binxix Hub V6] Script disabled on " .. gameName)
    end
end

-- ===== THEMES =====
local ThemePresets = {
    Purple = {
        Background = Color3.fromRGB(25, 25, 30), BackgroundDark = Color3.fromRGB(18, 18, 22), BackgroundLight = Color3.fromRGB(35, 35, 42),
        Accent = Color3.fromRGB(170, 100, 200), AccentDark = Color3.fromRGB(130, 70, 160), AccentBright = Color3.fromRGB(200, 130, 230), AccentPink = Color3.fromRGB(200, 100, 180),
        TextPrimary = Color3.fromRGB(220, 220, 225), TextSecondary = Color3.fromRGB(150, 150, 160), TextDim = Color3.fromRGB(100, 100, 110), TextHeader = Color3.fromRGB(180, 140, 200),
        Border = Color3.fromRGB(50, 50, 60), BorderLight = Color3.fromRGB(70, 70, 85),
        CheckboxEnabled = Color3.fromRGB(255, 255, 255), CheckboxDisabled = Color3.fromRGB(60, 60, 70),
        SliderBackground = Color3.fromRGB(45, 45, 55), SliderFill = Color3.fromRGB(180, 100, 200),
        TabActive = Color3.fromRGB(200, 130, 230), TabInactive = Color3.fromRGB(120, 120, 130),
        ESP_Close = Color3.fromRGB(255, 60, 60), ESP_Medium = Color3.fromRGB(255, 180, 50), ESP_Far = Color3.fromRGB(255, 255, 80), ESP_VeryFar = Color3.fromRGB(80, 255, 80),
    },
    Blue = {
        Background = Color3.fromRGB(20, 24, 32), BackgroundDark = Color3.fromRGB(14, 17, 24), BackgroundLight = Color3.fromRGB(30, 36, 48),
        Accent = Color3.fromRGB(70, 130, 220), AccentDark = Color3.fromRGB(50, 100, 180), AccentBright = Color3.fromRGB(100, 160, 255), AccentPink = Color3.fromRGB(70, 140, 230),
        TextPrimary = Color3.fromRGB(215, 220, 230), TextSecondary = Color3.fromRGB(140, 150, 170), TextDim = Color3.fromRGB(90, 100, 120), TextHeader = Color3.fromRGB(120, 170, 240),
        Border = Color3.fromRGB(40, 50, 65), BorderLight = Color3.fromRGB(55, 70, 90),
        CheckboxEnabled = Color3.fromRGB(255, 255, 255), CheckboxDisabled = Color3.fromRGB(50, 58, 72),
        SliderBackground = Color3.fromRGB(35, 42, 58), SliderFill = Color3.fromRGB(70, 140, 230),
        TabActive = Color3.fromRGB(100, 160, 255), TabInactive = Color3.fromRGB(110, 120, 140),
        ESP_Close = Color3.fromRGB(255, 60, 60), ESP_Medium = Color3.fromRGB(255, 180, 50), ESP_Far = Color3.fromRGB(255, 255, 80), ESP_VeryFar = Color3.fromRGB(80, 255, 80),
    },
    Red = {
        Background = Color3.fromRGB(28, 22, 22), BackgroundDark = Color3.fromRGB(20, 15, 15), BackgroundLight = Color3.fromRGB(42, 32, 32),
        Accent = Color3.fromRGB(200, 70, 70), AccentDark = Color3.fromRGB(160, 50, 50), AccentBright = Color3.fromRGB(240, 100, 100), AccentPink = Color3.fromRGB(220, 80, 80),
        TextPrimary = Color3.fromRGB(225, 215, 215), TextSecondary = Color3.fromRGB(160, 140, 140), TextDim = Color3.fromRGB(110, 90, 90), TextHeader = Color3.fromRGB(220, 130, 130),
        Border = Color3.fromRGB(60, 42, 42), BorderLight = Color3.fromRGB(85, 60, 60),
        CheckboxEnabled = Color3.fromRGB(255, 255, 255), CheckboxDisabled = Color3.fromRGB(70, 55, 55),
        SliderBackground = Color3.fromRGB(55, 38, 38), SliderFill = Color3.fromRGB(220, 80, 80),
        TabActive = Color3.fromRGB(240, 100, 100), TabInactive = Color3.fromRGB(130, 110, 110),
        ESP_Close = Color3.fromRGB(255, 60, 60), ESP_Medium = Color3.fromRGB(255, 180, 50), ESP_Far = Color3.fromRGB(255, 255, 80), ESP_VeryFar = Color3.fromRGB(80, 255, 80),
    },
    Green = {
        Background = Color3.fromRGB(20, 28, 22), BackgroundDark = Color3.fromRGB(14, 20, 16), BackgroundLight = Color3.fromRGB(30, 42, 34),
        Accent = Color3.fromRGB(60, 180, 90), AccentDark = Color3.fromRGB(40, 140, 70), AccentBright = Color3.fromRGB(80, 220, 120), AccentPink = Color3.fromRGB(60, 200, 100),
        TextPrimary = Color3.fromRGB(215, 225, 218), TextSecondary = Color3.fromRGB(140, 160, 145), TextDim = Color3.fromRGB(90, 110, 95), TextHeader = Color3.fromRGB(100, 200, 130),
        Border = Color3.fromRGB(40, 58, 45), BorderLight = Color3.fromRGB(55, 80, 62),
        CheckboxEnabled = Color3.fromRGB(255, 255, 255), CheckboxDisabled = Color3.fromRGB(50, 68, 55),
        SliderBackground = Color3.fromRGB(35, 52, 40), SliderFill = Color3.fromRGB(60, 200, 100),
        TabActive = Color3.fromRGB(80, 220, 120), TabInactive = Color3.fromRGB(110, 130, 115),
        ESP_Close = Color3.fromRGB(255, 60, 60), ESP_Medium = Color3.fromRGB(255, 180, 50), ESP_Far = Color3.fromRGB(255, 255, 80), ESP_VeryFar = Color3.fromRGB(80, 255, 80),
    },
    Rose = {
        Background = Color3.fromRGB(28, 22, 26), BackgroundDark = Color3.fromRGB(20, 15, 19), BackgroundLight = Color3.fromRGB(42, 32, 38),
        Accent = Color3.fromRGB(220, 80, 140), AccentDark = Color3.fromRGB(180, 55, 110), AccentBright = Color3.fromRGB(255, 110, 170), AccentPink = Color3.fromRGB(240, 90, 150),
        TextPrimary = Color3.fromRGB(225, 215, 222), TextSecondary = Color3.fromRGB(160, 140, 152), TextDim = Color3.fromRGB(110, 90, 100), TextHeader = Color3.fromRGB(240, 130, 175),
        Border = Color3.fromRGB(60, 42, 52), BorderLight = Color3.fromRGB(85, 60, 72),
        CheckboxEnabled = Color3.fromRGB(255, 255, 255), CheckboxDisabled = Color3.fromRGB(70, 55, 62),
        SliderBackground = Color3.fromRGB(55, 38, 48), SliderFill = Color3.fromRGB(240, 90, 150),
        TabActive = Color3.fromRGB(255, 110, 170), TabInactive = Color3.fromRGB(130, 110, 120),
        ESP_Close = Color3.fromRGB(255, 60, 60), ESP_Medium = Color3.fromRGB(255, 180, 50), ESP_Far = Color3.fromRGB(255, 255, 80), ESP_VeryFar = Color3.fromRGB(80, 255, 80),
    },
}

local currentThemeName = "Purple"
local Theme = {}
for k, v in pairs(ThemePresets.Purple) do Theme[k] = v end

local themeUpdateCallbacks = {}

local function applyTheme(themeName)
    local preset = ThemePresets[themeName]
    if not preset then return end
    currentThemeName = themeName
    for k, v in pairs(preset) do Theme[k] = v end
    for _, cb in ipairs(themeUpdateCallbacks) do pcall(cb) end
end

-- ===== GAME CONFIG =====
local supportedGames = {
    [286090429]      = {name = "Arsenal",               espEnabled = true},
    [9157605735]     = {name = "MiscGunTest-X",          espEnabled = false},
    [155615604]      = {name = "PR",                     espEnabled = true},
    [142823291]      = {name = "Murder Mystery 2",       espEnabled = false, loadScript = "https://raw.smokingscripts.org/vertex.lua",                                                                        scriptName = "Vertex"},
    [10449761463]    = {name = "The Strongest Battlegrounds", espEnabled = false, loadScript = "https://raw.githubusercontent.com/ATrainz/Phantasm/refs/heads/main/Games/TSB.lua", scriptName = "Phantasm"},
    [104715542330896] = {name = "BlockSpin", espEnabled = true, noMovement = true},
}

local currentGameData = supportedGames[currentPlaceId] or {name = "Universal", espEnabled = true}
local gameConfig = {espEnabled = currentGameData.espEnabled}

-- ===== EXTERNAL SCRIPT LOADER (unchanged logic) =====
if currentGameData.loadScript then
    local choiceMade, loadExternal = false, false
    local choiceGui = Instance.new("ScreenGui")
    choiceGui.Name = "BinxixLoader"
    choiceGui.ResetOnSpawn = false
    choiceGui.IgnoreGuiInset = true
    choiceGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    choiceGui.Parent = player:WaitForChild("PlayerGui")

    local dimBg = Instance.new("Frame")
    dimBg.Size = UDim2.new(1,0,1,0)
    dimBg.BackgroundColor3 = Color3.fromRGB(0,0,0)
    dimBg.BackgroundTransparency = 0.5
    dimBg.BorderSizePixel = 0
    dimBg.ZIndex = 100
    dimBg.Parent = choiceGui

    local choiceFrame = Instance.new("Frame")
    choiceFrame.Size = UDim2.new(0,320,0,160)
    choiceFrame.Position = UDim2.new(0.5,-160,0.5,-80)
    choiceFrame.BackgroundColor3 = Color3.fromRGB(25,25,30)
    choiceFrame.BorderSizePixel = 0
    choiceFrame.ZIndex = 101
    choiceFrame.Parent = choiceGui
    Instance.new("UICorner", choiceFrame).CornerRadius = UDim.new(0,8)
    local cs = Instance.new("UIStroke", choiceFrame)
    cs.Color = Color3.fromRGB(200,100,200); cs.Thickness = 1

    local function mkLabel(parent, text, pos, size, color, textSize, font, zindex)
        local l = Instance.new("TextLabel")
        l.Size = size; l.Position = pos
        l.BackgroundTransparency = 1; l.Text = text
        l.TextColor3 = color; l.TextSize = textSize
        l.Font = font or Enum.Font.SourceSans
        l.ZIndex = zindex or 102; l.Parent = parent
        return l
    end

    mkLabel(choiceFrame, "Binxix Hub V6", UDim2.new(0,8,0,12), UDim2.new(1,-16,0,24), Color3.fromRGB(200,100,200), 16, Enum.Font.SourceSansBold)
    mkLabel(choiceFrame, currentGameData.name .. " detected - choose your script:", UDim2.new(0,8,0,38), UDim2.new(1,-16,0,18), Color3.fromRGB(180,180,190), 12)

    local extBtn = Instance.new("TextButton")
    extBtn.Size = UDim2.new(0,135,0,40); extBtn.Position = UDim2.new(0,20,0,72)
    extBtn.BackgroundColor3 = Color3.fromRGB(40,100,60); extBtn.BorderSizePixel = 0
    extBtn.Text = "Load " .. (currentGameData.scriptName or "External")
    extBtn.TextColor3 = Color3.fromRGB(120,255,160); extBtn.TextSize = 13
    extBtn.Font = Enum.Font.SourceSansBold; extBtn.ZIndex = 102; extBtn.Parent = choiceFrame
    Instance.new("UICorner", extBtn).CornerRadius = UDim.new(0,6)

    local hubBtn = Instance.new("TextButton")
    hubBtn.Size = UDim2.new(0,135,0,40); hubBtn.Position = UDim2.new(0,165,0,72)
    hubBtn.BackgroundColor3 = Color3.fromRGB(80,40,100); hubBtn.BorderSizePixel = 0
    hubBtn.Text = "Load Binxix Hub"
    hubBtn.TextColor3 = Color3.fromRGB(200,150,255); hubBtn.TextSize = 13
    hubBtn.Font = Enum.Font.SourceSansBold; hubBtn.ZIndex = 102; hubBtn.Parent = choiceFrame
    Instance.new("UICorner", hubBtn).CornerRadius = UDim.new(0,6)

    mkLabel(choiceFrame, (currentGameData.scriptName or "") .. " = game-specific  |  Binxix Hub = universal", UDim2.new(0,8,0,120), UDim2.new(1,-16,0,14), Color3.fromRGB(120,120,130), 10, Enum.Font.SourceSansItalic)
    local timerLabel = mkLabel(choiceFrame, "", UDim2.new(0,8,0,136), UDim2.new(1,-16,0,14), Color3.fromRGB(100,100,110), 10)

    extBtn.MouseEnter:Connect(function() extBtn.BackgroundColor3 = Color3.fromRGB(50,130,75) end)
    extBtn.MouseLeave:Connect(function() extBtn.BackgroundColor3 = Color3.fromRGB(40,100,60) end)
    hubBtn.MouseEnter:Connect(function() hubBtn.BackgroundColor3 = Color3.fromRGB(100,50,130) end)
    hubBtn.MouseLeave:Connect(function() hubBtn.BackgroundColor3 = Color3.fromRGB(80,40,100) end)
    extBtn.MouseButton1Click:Connect(function() choiceMade = true; loadExternal = true end)
    hubBtn.MouseButton1Click:Connect(function() choiceMade = true; loadExternal = false end)

    task.spawn(function()
        for i = 10, 1, -1 do
            if choiceMade then break end
            timerLabel.Text = "Auto-loading " .. currentGameData.scriptName .. " in " .. i .. "s..."
            task.wait(1)
        end
        if not choiceMade then choiceMade = true; loadExternal = true end
    end)

    while not choiceMade do task.wait(0.1) end

    if loadExternal then
        _G.BinxixUnloaded = true
        extBtn:Destroy(); hubBtn:Destroy()
        local loadingLabel = Instance.new("TextLabel")
        loadingLabel.Size = UDim2.new(1,0,1,0)
        loadingLabel.BackgroundColor3 = Color3.fromRGB(25,25,30)
        loadingLabel.Text = "Loading " .. currentGameData.scriptName .. "..."
        loadingLabel.TextColor3 = Color3.fromRGB(200,200,210); loadingLabel.TextSize = 14
        loadingLabel.Font = Enum.Font.SourceSans; loadingLabel.ZIndex = 103; loadingLabel.Parent = choiceFrame
        task.spawn(function()
            task.wait(0.3)
            local success, err = pcall(function() loadstring(game:HttpGet(currentGameData.loadScript))() end)
            loadingLabel.Text = success and (currentGameData.scriptName .. " Loaded!") or ("Failed: " .. tostring(err))
            task.wait(success and 1.5 or 3)
            choiceGui:Destroy()
        end)
        return
    else
        choiceGui:Destroy()
        gameConfig.espEnabled = true
    end
end

-- ===== SETTINGS =====
local Settings = {
    ESP = {
        Enabled = false, BoxEnabled = true, NameEnabled = true, HealthEnabled = true,
        DistanceEnabled = true, TracerEnabled = true, SkeletonEnabled = false,
        HeadDotEnabled = true, OffscreenArrows = false, RainbowOutline = false, RainbowColor = false,
        OutlineEnabled = true, OutlineColor = Theme.AccentPink,
        TracerOrigin = "Bottom", TracerThickness = 1, TracerTransparency = 0,
        TracerRainbowOutline = false, TracerRainbowColor = false,
        BoxThickness = 1, SkeletonThickness = 1, Transparency = 0, FontSize = 13, Font = nil,
        Offset = 0, ArrowSize = 20, ArrowDistance = 500,
        ChamsEnabled = false, ChamsFillTransparency = 0.5,
        FilterMode = "Enemies",
    },
    Aimbot = {
        Enabled = false, Toggle = false, LockPart = "Head", Smoothness = 0.15,
        FOVRadius = 150, ShowFOV = true, FOVOpacity = 0.5, RequireLOS = true,
        Prediction = true, PredictionAmount = 0.12, StickyAim = true, MaxDistance = 500,
    },
    Crosshair = {
        Enabled = false, Style = "Cross", Size = 10, Thickness = 2, Gap = 4,
        Color = Theme.AccentPink, Outline = true, CenterDot = false,
    },
    Visuals = {
        Fullbright = false, NoFog = false, CustomFOV = false, FOVAmount = 70,
        ShowFPS = false, ShowVelocity = false,
    },
    Movement = {
        SpeedEnabled = false, Speed = 16, SpeedMethod = "WalkSpeed",
        JumpEnabled = false, JumpPower = 50, BunnyHop = false, BunnyHopSpeed = 30,
        Fly = false, FlySpeed = 50,
    },
    Combat = {
        KillAura = false, KillAuraRange = 15, KillAuraSpeed = 0.15, KillAuraMethod = "Click",
        TriggerBot = false, TriggerBotDelay = 0.05, TriggerBotFOV = 50,
        FastReload = false, FastFireRate = false, AlwaysAuto = false, NoSpread = false, NoRecoil = false,
    },
    StreamerMode = {
        Enabled = false, HideNames = true, HideChat = false, HideNotifications = false, FakeName = "Player",
    },
    Misc = {
        AntiAFK = false, AutoRejoin = false, AutoTPLoop = false, AutoTPLoopDelay = 0.2,
        AutoTPTargetName = "Nearest Enemy", AutoTPAntiDeath = true,
        ChatSpammer = false, ChatSpamMessage = "Binxix Hub V6 on top", ChatSpamDelay = 3,
    },
}

-- ===== PROFILE SYSTEM =====
local PROFILE_DIR = "BinxixHubV6_Profiles/"
local currentProfileName = "Default"

local function ensureProfileDir()
    pcall(function() if not isfolder(PROFILE_DIR) then makefolder(PROFILE_DIR) end end)
end

local function getProfilePath(name) return PROFILE_DIR .. name .. ".json" end

local function listProfiles()
    local profiles = {}
    pcall(function()
        ensureProfileDir()
        local files = listfiles(PROFILE_DIR)
        for _, file in ipairs(files) do
            local name = file:match("([^/\\]+)%.json$")
            if name then table.insert(profiles, name) end
        end
    end)
    if #profiles == 0 then table.insert(profiles, "Default") end
    return profiles
end

local function saveProfile(name)
    ensureProfileDir()
    return pcall(function()
        local saveData = {_meta = {theme = currentThemeName, version = "V6.5", game = currentGameData.name, profile = name}}
        for category, values in pairs(Settings) do
            saveData[category] = {}
            for key, val in pairs(values) do
                if typeof(val) == "boolean" or typeof(val) == "number" or typeof(val) == "string" then
                    saveData[category][key] = val
                elseif typeof(val) == "Color3" then
                    saveData[category][key] = {_type="Color3", R=math.floor(val.R*255), G=math.floor(val.G*255), B=math.floor(val.B*255)}
                elseif typeof(val) == "EnumItem" then
                    saveData[category][key] = {_type="Enum", Value=val.Name}
                end
            end
        end
        writefile(getProfilePath(name), HttpService:JSONEncode(saveData))
    end)
end

local function loadProfile(name)
    return pcall(function()
        local path = getProfilePath(name)
        if not isfile(path) then error("Profile not found: " .. name) end
        local saveData = HttpService:JSONDecode(readfile(path))
        if saveData._meta and saveData._meta.theme then applyTheme(saveData._meta.theme) end
        for category, values in pairs(saveData) do
            if category ~= "_meta" and Settings[category] then
                for key, val in pairs(values) do
                    if Settings[category][key] ~= nil then
                        if type(val) == "table" and val._type == "Color3" then
                            Settings[category][key] = Color3.fromRGB(val.R, val.G, val.B)
                        elseif type(val) ~= "table" then
                            Settings[category][key] = val
                        end
                    end
                end
            end
        end
        currentProfileName = name
    end)
end

local function deleteProfile(name)
    pcall(function()
        local path = getProfilePath(name)
        if isfile(path) then delfile(path) end
    end)
end

-- ===== STATE =====
local allConnections = {}
local espObjects = {}
local isUnloading = false
local currentTarget = nil
local isTracking = false
local toggleTrackingActive = false
local rightMouseTracking = nil
local flyBodyVelocity = nil
local flyBodyGyro = nil
local isFlying = false

-- ===== SKELETON CONNECTIONS =====
local SKELETON_CONNECTIONS_R15 = {
    {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
    {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
    {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
    {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
    {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
}
local SKELETON_CONNECTIONS_R6 = {
    {"Head","Torso"},{"Torso","Left Arm"},{"Torso","Right Arm"},{"Torso","Left Leg"},{"Torso","Right Leg"},
}

-- ===== NOTIFICATION SYSTEM =====
local notifScreenGui = nil

local function sendNotification(title, message, duration)
    duration = duration or 3
    if Settings.StreamerMode.Enabled and Settings.StreamerMode.HideNotifications then return end
    if not notifScreenGui then return end

    local notifHolder = notifScreenGui:FindFirstChild("NotifHolder")
    if not notifHolder then
        notifHolder = Instance.new("Frame")
        notifHolder.Name = "NotifHolder"
        notifHolder.Size = UDim2.new(0,220,1,0)
        notifHolder.Position = UDim2.new(1,-230,0,40)
        notifHolder.BackgroundTransparency = 1
        notifHolder.Parent = notifScreenGui
    end

    local notifCount = 0
    for _, child in ipairs(notifHolder:GetChildren()) do
        if child:IsA("Frame") then notifCount = notifCount + 1 end
    end

    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(1,0,0,52)
    notif.Position = UDim2.new(1,10,0,notifCount*58)
    notif.BackgroundColor3 = Color3.fromRGB(22,22,28)
    notif.BorderSizePixel = 1
    notif.BorderColor3 = Color3.fromRGB(60,60,75)
    notif.ClipsDescendants = true
    notif.Parent = notifHolder

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0,3,1,0)
    accentBar.BackgroundColor3 = Theme.AccentPink
    accentBar.BorderSizePixel = 0
    accentBar.Parent = notif

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1,-14,0,18)
    titleLbl.Position = UDim2.new(0,10,0,4)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = Theme.AccentBright
    titleLbl.TextSize = 12
    titleLbl.Font = Enum.Font.SourceSansBold
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.TextTruncate = Enum.TextTruncate.AtEnd
    titleLbl.Parent = notif

    local msgLbl = Instance.new("TextLabel")
    msgLbl.Size = UDim2.new(1,-14,0,20)
    msgLbl.Position = UDim2.new(0,10,0,22)
    msgLbl.BackgroundTransparency = 1
    msgLbl.Text = message
    msgLbl.TextColor3 = Color3.fromRGB(180,180,190)
    msgLbl.TextSize = 11
    msgLbl.Font = Enum.Font.SourceSans
    msgLbl.TextXAlignment = Enum.TextXAlignment.Left
    msgLbl.TextTruncate = Enum.TextTruncate.AtEnd
    msgLbl.Parent = notif

    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(1,0,0,2)
    progressBar.Position = UDim2.new(0,0,1,-2)
    progressBar.BackgroundColor3 = Theme.AccentPink
    progressBar.BorderSizePixel = 0
    progressBar.Parent = notif

    task.spawn(function()
        TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = UDim2.new(0,0,0,notifCount*58)
        }):Play()
        TweenService:Create(progressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
            Size = UDim2.new(0,0,0,2)
        }):Play()
        task.wait(duration)
        local tweenOut = TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Position = UDim2.new(1,10,0,notif.Position.Y.Offset)
        })
        tweenOut:Play()
        tweenOut.Completed:Wait()
        notif:Destroy()
        if notifHolder and notifHolder.Parent then
            local idx = 0
            for _, child in ipairs(notifHolder:GetChildren()) do
                if child:IsA("Frame") then
                    TweenService:Create(child, TweenInfo.new(0.2), {
                        Position = UDim2.new(child.Position.X.Scale, child.Position.X.Offset, 0, idx*58)
                    }):Play()
                    idx = idx + 1
                end
            end
        end
    end)
end

-- ===== HELPER FUNCTIONS =====
local function isSameTeam(p1, p2)
    if not p1.Team or not p2.Team then return false end
    return p1.Team == p2.Team
end

local function isValidESPTarget(admin, target)
    if target == admin then return false end
    local mode = Settings.ESP.FilterMode
    if mode == "All (No Team Check)" then return true
    elseif mode == "All" then return true
    elseif mode == "Team" then return isSameTeam(admin, target)
    else return not isSameTeam(admin, target) end
end

local function isValidTarget(admin, target)
    if target == admin then return false end
    if isSameTeam(admin, target) then return false end
    return true
end

local function hasLineOfSight(admin, target)
    local adminChar = admin.Character
    local targetChar = target.Character
    if not adminChar or not targetChar then return false end
    local adminHead = adminChar:FindFirstChild("Head")
    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
    if not adminHead or not targetHRP then return false end
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.FilterDescendantsInstances = {adminChar, targetChar}
    return Workspace:Raycast(adminHead.Position, (targetHRP.Position - adminHead.Position), rp) == nil
end

local function isInFOV(target, fovRadius)
    local camera = Workspace.CurrentCamera
    if not camera then return false end
    local targetChar = target.Character
    if not targetChar then return false end
    local lockPart = Settings.Aimbot.LockPart
    local targetPart = targetChar:FindFirstChild(lockPart) or targetChar:FindFirstChild("Head") or targetChar:FindFirstChild("HumanoidRootPart")
    if not targetPart then return false end
    local screenPos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
    if not onScreen or screenPos.Z < 0 then return false end
    local screenCenter = camera.ViewportSize / 2
    return (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude <= fovRadius
end

local function getNearestValidTarget()
    local adminChar = player.Character
    if not adminChar then return nil end
    local adminHRP = adminChar:FindFirstChild("HumanoidRootPart")
    if not adminHRP then return nil end
    local camera = Workspace.CurrentCamera
    if not camera then return nil end
    local screenCenter = camera.ViewportSize / 2
    local nearestPlayer, nearestDist = nil, math.huge
    for _, target in ipairs(Players:GetPlayers()) do
        if isValidTarget(player, target) then
            local targetChar = target.Character
            if targetChar then
                local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
                local targetHumanoid = targetChar:FindFirstChild("Humanoid")
                if targetHRP and targetHumanoid and targetHumanoid.Health > 0 then
                    if (adminHRP.Position - targetHRP.Position).Magnitude <= Settings.Aimbot.MaxDistance then
                        local lockPart = Settings.Aimbot.LockPart
                        local targetPart = targetChar:FindFirstChild(lockPart) or targetChar:FindFirstChild("Head") or targetHRP
                        if targetPart then
                            local screenPos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
                            if onScreen and screenPos.Z > 0 then
                                local d = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                                if d <= Settings.Aimbot.FOVRadius then
                                    if not Settings.Aimbot.RequireLOS or hasLineOfSight(player, target) then
                                        if d < nearestDist then nearestDist = d; nearestPlayer = target end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return nearestPlayer
end

local function getPredictedPosition(targetChar)
    local lockPart = Settings.Aimbot.LockPart
    local targetPart = targetChar:FindFirstChild(lockPart) or targetChar:FindFirstChild("Head") or targetChar:FindFirstChild("HumanoidRootPart")
    if not targetPart then return nil end
    local position = targetPart.Position
    if Settings.Aimbot.Prediction then
        local hrp = targetChar:FindFirstChild("HumanoidRootPart")
        if hrp then position = position + (hrp.AssemblyLinearVelocity * Settings.Aimbot.PredictionAmount) end
    end
    return position
end

local function startAimbotTracking()
    if rightMouseTracking then rightMouseTracking:Disconnect(); rightMouseTracking = nil end
    isTracking = true
    currentTarget = getNearestValidTarget()
    rightMouseTracking = RunService.RenderStepped:Connect(function()
        if isUnloading or _G.BinxixUnloaded then return end
        if not Settings.Aimbot.Enabled then return end
        if not isTracking then return end
        local camera = Workspace.CurrentCamera
        if not camera then return end
        if not currentTarget or not currentTarget.Character then
            currentTarget = getNearestValidTarget()
        else
            local targetChar = currentTarget.Character
            if targetChar then
                local h = targetChar:FindFirstChild("Humanoid")
                if not h or h.Health <= 0 then currentTarget = getNearestValidTarget()
                elseif not isInFOV(currentTarget, Settings.Aimbot.FOVRadius) then
                    if not Settings.Aimbot.StickyAim then currentTarget = getNearestValidTarget() end
                elseif Settings.Aimbot.RequireLOS and not hasLineOfSight(player, currentTarget) then
                    currentTarget = getNearestValidTarget()
                end
            else currentTarget = getNearestValidTarget() end
        end
        if currentTarget and currentTarget.Character then
            local targetPos = getPredictedPosition(currentTarget.Character)
            if targetPos then
                camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, targetPos), Settings.Aimbot.Smoothness)
            end
        end
    end)
    table.insert(allConnections, rightMouseTracking)
end

local function stopAimbotTracking()
    isTracking = false; currentTarget = nil
    if rightMouseTracking then rightMouseTracking:Disconnect(); rightMouseTracking = nil end
end

local function getESPColor(distance)
    if distance < 30 then return Theme.ESP_Close
    elseif distance < 75 then return Theme.ESP_Medium
    elseif distance < 150 then return Theme.ESP_Far
    else return Theme.ESP_VeryFar end
end

local function getHealthColor(percent)
    if percent > 0.6 then return Color3.fromRGB(80,255,80)
    elseif percent > 0.3 then return Color3.fromRGB(255,200,50)
    else return Color3.fromRGB(255,60,60) end
end

-- ===== ESP OBJECTS =====
local function createESPForPlayer(target)
    if target == player then return end
    if espObjects[target.UserId] then return end
    local espData = {}
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "BinxixESP"; billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0,150,0,50); billboard.StudsOffset = Vector3.new(0,3,0)
    billboard.LightInfluence = 0; billboard.MaxDistance = 1000

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"; nameLabel.Size = UDim2.new(1,0,0,14)
    nameLabel.BackgroundTransparency = 1; nameLabel.Text = target.Name
    nameLabel.TextColor3 = Color3.fromRGB(255,255,255); nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0); nameLabel.TextSize = 13
    nameLabel.Font = Enum.Font.SourceSansBold; nameLabel.Parent = billboard

    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Name = "DistanceLabel"; distanceLabel.Size = UDim2.new(1,0,0,12)
    distanceLabel.Position = UDim2.new(0,0,0,14); distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = "[0m]"; distanceLabel.TextColor3 = Theme.ESP_Far
    distanceLabel.TextStrokeTransparency = 0; distanceLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    distanceLabel.TextSize = 11; distanceLabel.Font = Enum.Font.SourceSans; distanceLabel.Parent = billboard

    local healthLabel = Instance.new("TextLabel")
    healthLabel.Name = "HealthLabel"; healthLabel.Size = UDim2.new(1,0,0,12)
    healthLabel.Position = UDim2.new(0,0,0,26); healthLabel.BackgroundTransparency = 1
    healthLabel.Text = "100 HP"; healthLabel.TextColor3 = Color3.fromRGB(80,255,80)
    healthLabel.TextStrokeTransparency = 0; healthLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    healthLabel.TextSize = 11; healthLabel.Font = Enum.Font.SourceSans; healthLabel.Parent = billboard

    espData.billboard = billboard; espData.nameLabel = nameLabel
    espData.distanceLabel = distanceLabel; espData.healthLabel = healthLabel
    espObjects[target.UserId] = espData
end

local function removeESPForPlayer(target)
    local espData = espObjects[target.UserId]
    if espData then
        if espData.billboard then espData.billboard:Destroy() end
        if espData.boxGui then espData.boxGui:Destroy() end
        if espData.boxHighlight then espData.boxHighlight:Destroy() end
        espObjects[target.UserId] = nil
    end
end

local function clearAllESP()
    for _, espData in pairs(espObjects) do
        if espData.billboard then espData.billboard:Destroy() end
        if espData.boxGui then espData.boxGui:Destroy() end
        if espData.boxHighlight then espData.boxHighlight:Destroy() end
    end
    espObjects = {}
end

local function updateESP()
    if not Settings.ESP.Enabled then
        for _, espData in pairs(espObjects) do
            if espData.billboard then espData.billboard.Enabled = false end
            if espData.boxGui then espData.boxGui.Visible = false end
        end
        return
    end
    local myChar = player.Character
    if not myChar then return end
    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end

    for _, target in ipairs(Players:GetPlayers()) do
        if target ~= player and isValidESPTarget(player, target) then
            local targetChar = target.Character
            if targetChar then
                local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
                local targetHead = targetChar:FindFirstChild("Head")
                local targetHumanoid = targetChar:FindFirstChild("Humanoid")
                if targetHRP and targetHead and targetHumanoid then
                    if not espObjects[target.UserId] then createESPForPlayer(target) end
                    local espData = espObjects[target.UserId]
                    if espData and espData.billboard then
                        espData.billboard.Adornee = targetHead
                        espData.billboard.Parent = targetChar
                        espData.billboard.Enabled = true
                        local distance = (myHRP.Position - targetHRP.Position).Magnitude
                        local espColor = getESPColor(distance)
                        if espData.nameLabel then
                            espData.nameLabel.Visible = Settings.ESP.NameEnabled
                            if Settings.StreamerMode.Enabled and Settings.StreamerMode.HideNames then
                                espData.nameLabel.Text = Settings.StreamerMode.FakeName .. " #" .. tostring(target.UserId):sub(-3)
                            else
                                espData.nameLabel.Text = target.DisplayName
                            end
                            espData.nameLabel.TextColor3 = Settings.ESP.RainbowColor and Color3.fromHSV(tick()%5/5,1,1) or espColor
                        end
                        if espData.distanceLabel then
                            espData.distanceLabel.Visible = Settings.ESP.DistanceEnabled
                            espData.distanceLabel.Text = string.format("[%dm]", math.floor(distance))
                            espData.distanceLabel.TextColor3 = espColor
                        end
                        if espData.healthLabel then
                            espData.healthLabel.Visible = Settings.ESP.HealthEnabled
                            local h = targetHumanoid.Health; local mh = targetHumanoid.MaxHealth
                            espData.healthLabel.Text = string.format("%d HP", math.floor(h))
                            espData.healthLabel.TextColor3 = getHealthColor(h/mh)
                        end
                        if Settings.ESP.BoxEnabled then
                            if not espData.boxHighlight then
                                espData.boxHighlight = Instance.new("Highlight")
                                espData.boxHighlight.Name = "BinxixBoxESP"
                                espData.boxHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            end
                            if Settings.ESP.ChamsEnabled then
                                espData.boxHighlight.FillTransparency = Settings.ESP.ChamsFillTransparency
                                espData.boxHighlight.FillColor = Settings.ESP.RainbowColor and Color3.fromHSV(tick()%5/5,1,1) or espColor
                            else
                                espData.boxHighlight.FillTransparency = 1
                            end
                            espData.boxHighlight.OutlineTransparency = Settings.ESP.OutlineEnabled and 0 or 1
                            espData.boxHighlight.Parent = targetChar
                            espData.boxHighlight.OutlineColor = Settings.ESP.RainbowOutline and Color3.fromHSV(tick()%5/5,1,1) or espColor
                            espData.boxHighlight.Enabled = true
                        else
                            if espData.boxHighlight then espData.boxHighlight.Enabled = false end
                        end
                    end
                end
            end
        else
            if espObjects[target.UserId] then removeESPForPlayer(target) end
        end
    end
end

local targetHighlight = nil

local function updateTargetMarker()
    if Settings.StreamerMode.Enabled then
        if targetHighlight then targetHighlight.Parent = nil end
        return
    end
    if currentTarget and currentTarget.Character and isTracking then
        if not targetHighlight then
            targetHighlight = Instance.new("Highlight")
            targetHighlight.Name = "BinxixLockMarker"
            targetHighlight.FillColor = Theme.AccentPink
            targetHighlight.FillTransparency = 0.7
            targetHighlight.OutlineColor = Theme.AccentBright
            targetHighlight.OutlineTransparency = 0
            targetHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        end
        targetHighlight.Parent = currentTarget.Character
    else
        if targetHighlight then targetHighlight.Parent = nil end
    end
end

local originalFogSettings = nil

local function enableNoFog()
    if not originalFogSettings then
        originalFogSettings = {FogStart=Lighting.FogStart, FogEnd=Lighting.FogEnd, FogColor=Lighting.FogColor, Atmospheres={}}
        for _, effect in ipairs(Lighting:GetChildren()) do
            if effect:IsA("Atmosphere") then
                table.insert(originalFogSettings.Atmospheres, {
                    instance=effect, Density=effect.Density, Offset=effect.Offset,
                    Color=effect.Color, Decay=effect.Decay, Glare=effect.Glare, Haze=effect.Haze
                })
            end
        end
    end
    Lighting.FogStart = 100000; Lighting.FogEnd = 100000
    for _, effect in ipairs(Lighting:GetChildren()) do
        if effect:IsA("Atmosphere") then
            effect.Density=0; effect.Offset=0; effect.Haze=0; effect.Glare=0
        end
    end
end

local function disableNoFog()
    if originalFogSettings then
        Lighting.FogStart = originalFogSettings.FogStart
        Lighting.FogEnd = originalFogSettings.FogEnd
        Lighting.FogColor = originalFogSettings.FogColor
        for _, data in ipairs(originalFogSettings.Atmospheres) do
            if data.instance and data.instance.Parent then
                data.instance.Density=data.Density; data.instance.Offset=data.Offset
                data.instance.Color=data.Color; data.instance.Decay=data.Decay
                data.instance.Glare=data.Glare; data.instance.Haze=data.Haze
            end
        end
    end
end

-- ===== GUN MODS (defined early so callbacks work) =====
local gunModOriginalValues = {FireRate={}, ReloadTime={}, EReloadTime={}, Auto={}, Spread={}, Recoil={}}
local weaponValueCache = {}
local weaponCacheBuilt = false

local function applyGunModToValue(v)
    local n = v.Name
    if Settings.Combat.FastReload and (n=="ReloadTime" or n=="EReloadTime") then
        local key = n=="ReloadTime" and "ReloadTime" or "EReloadTime"
        if not gunModOriginalValues[key][v] then gunModOriginalValues[key][v] = v.Value end
        v.Value = 0.01
    end
    if Settings.Combat.FastFireRate and (n=="FireRate" or n=="BFireRate") then
        if not gunModOriginalValues.FireRate[v] then gunModOriginalValues.FireRate[v] = v.Value end
        v.Value = 0.02
    end
    if Settings.Combat.AlwaysAuto and (n=="Auto" or n=="AutoFire" or n=="Automatic" or n=="AutoShoot" or n=="AutoGun") then
        if not gunModOriginalValues.Auto[v] then gunModOriginalValues.Auto[v] = v.Value end
        v.Value = true
    end
    if Settings.Combat.NoSpread and (n=="MaxSpread" or n=="Spread" or n=="SpreadControl") then
        if not gunModOriginalValues.Spread[v] then gunModOriginalValues.Spread[v] = v.Value end
        v.Value = 0
    end
    if Settings.Combat.NoRecoil and (n=="RecoilControl" or n=="Recoil") then
        if not gunModOriginalValues.Recoil[v] then gunModOriginalValues.Recoil[v] = v.Value end
        v.Value = 0
    end
end

local function buildWeaponCache()
    weaponValueCache = {}
    local weapons = game:GetService("ReplicatedStorage"):FindFirstChild("Weapons")
    if not weapons then return end
    for _, v in pairs(weapons:GetDescendants()) do
        if v:IsA("ValueBase") then
            local n = v.Name
            if n=="ReloadTime" or n=="EReloadTime" or n=="FireRate" or n=="BFireRate"
                or n=="Auto" or n=="AutoFire" or n=="Automatic" or n=="AutoShoot" or n=="AutoGun"
                or n=="MaxSpread" or n=="Spread" or n=="SpreadControl"
                or n=="RecoilControl" or n=="Recoil" then
                table.insert(weaponValueCache, v)
            end
        end
    end
    weaponCacheBuilt = true
end

pcall(function()
    local weapons = game:GetService("ReplicatedStorage"):FindFirstChild("Weapons")
    if weapons then
        weapons.DescendantAdded:Connect(function(v)
            if v:IsA("ValueBase") then
                local n = v.Name
                if n=="ReloadTime" or n=="EReloadTime" or n=="FireRate" or n=="BFireRate"
                    or n=="Auto" or n=="AutoFire" or n=="Automatic" or n=="AutoShoot" or n=="AutoGun"
                    or n=="MaxSpread" or n=="Spread" or n=="SpreadControl"
                    or n=="RecoilControl" or n=="Recoil" then
                    table.insert(weaponValueCache, v)
                    applyGunModToValue(v)
                end
            end
        end)
    end
end)

local function applyAllGunMods()
    if not weaponCacheBuilt then buildWeaponCache() end
    for _, v in ipairs(weaponValueCache) do
        if v and v.Parent then applyGunModToValue(v) end
    end
end

local function restoreGunMod(category)
    for obj, val in pairs(gunModOriginalValues[category]) do
        pcall(function() if obj and obj.Parent then obj.Value = val end end)
    end
    gunModOriginalValues[category] = {}
end

-- ===== FLY SYSTEM =====
local function startFly()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChild("Humanoid")
    if not hrp or not humanoid then return end
    isFlying = true
    if flyBodyVelocity then flyBodyVelocity:Destroy() end
    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.Name = "BinxixFlyVelocity"
    flyBodyVelocity.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
    flyBodyVelocity.Velocity = Vector3.new(0,0,0)
    flyBodyVelocity.Parent = hrp
    if flyBodyGyro then flyBodyGyro:Destroy() end
    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.Name = "BinxixFlyGyro"
    flyBodyGyro.MaxTorque = Vector3.new(math.huge,math.huge,math.huge)
    flyBodyGyro.P = 9000; flyBodyGyro.D = 500
    flyBodyGyro.Parent = hrp
    humanoid.PlatformStand = true
end

local function stopFly()
    isFlying = false
    local char = player.Character
    if char then
        local h = char:FindFirstChild("Humanoid")
        if h then h.PlatformStand = false end
    end
    if flyBodyVelocity then flyBodyVelocity:Destroy(); flyBodyVelocity = nil end
    if flyBodyGyro then flyBodyGyro:Destroy(); flyBodyGyro = nil end
end

-- ===== AUTO TP HELPERS =====
local function isTargetProtected(target)
    local targetChar = target.Character
    if not targetChar then return true end
    local targetHumanoid = targetChar:FindFirstChild("Humanoid")
    if not targetHumanoid then return true end
    for _, child in ipairs(targetChar:GetChildren()) do
        if child:IsA("ForceField") then return true end
    end
    if targetHumanoid:FindFirstChild("ForceField") then return true end
    if targetHumanoid.MaxHealth >= 999999 then return true end
    local invincibleAttrs = {"Invincible","SpawnProtection","Protected","SafeZone","Invulnerable","GodMode","Shielded"}
    for _, attrName in ipairs(invincibleAttrs) do
        local val = nil
        pcall(function() val = targetChar:GetAttribute(attrName) end)
        if val == true then return true end
        pcall(function() val = targetHumanoid:GetAttribute(attrName) end)
        if val == true then return true end
    end
    for _, child in ipairs(targetChar:GetChildren()) do
        local lowerName = child.Name:lower()
        if lowerName:find("shield") or lowerName:find("barrier") or lowerName:find("safezone")
            or lowerName:find("forcefield") or lowerName:find("spawn_protect") then
            if child:IsA("Part") or child:IsA("MeshPart") or child:IsA("BoolValue") or child:IsA("ForceField") then
                if child:IsA("BoolValue") and child.Value == true then return true
                elseif child:IsA("ForceField") or child:IsA("Part") or child:IsA("MeshPart") then return true end
            end
        end
    end
    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
    if targetHRP then
        local safeZoneNames = {"SafeZone","SpawnZone","Lobby","SafeArea","SpawnArea","Safe_Zone","Spawn_Zone"}
        for _, zoneName in ipairs(safeZoneNames) do
            local zone = Workspace:FindFirstChild(zoneName, true)
            if zone and zone:IsA("BasePart") then
                local zonePos = zone.Position; local zoneSize = zone.Size / 2; local tPos = targetHRP.Position
                if math.abs(tPos.X-zonePos.X)<zoneSize.X and math.abs(tPos.Y-zonePos.Y)<zoneSize.Y and math.abs(tPos.Z-zonePos.Z)<zoneSize.Z then
                    return true
                end
            end
        end
    end
    return false
end

-- ===== ANTI DEATH (forward declaration needed for BlockSpin lock) =====
local stopAntiDeath -- forward declared, defined inside createGUI

-- ====================================================================
-- MAIN GUI CREATION
-- ====================================================================
local function createGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BinxixHub_V6"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = player:WaitForChild("PlayerGui")
    notifScreenGui = screenGui

    -- ---- FOV Circle ----
    local fovCircle = Instance.new("Frame")
    fovCircle.Name = "FOVCircle"
    fovCircle.Size = UDim2.new(0,300,0,300)
    fovCircle.Position = UDim2.new(0.5,0,0.5,0)
    fovCircle.AnchorPoint = Vector2.new(0.5,0.5)
    fovCircle.BackgroundTransparency = 1
    fovCircle.Visible = false
    fovCircle.Parent = screenGui
    Instance.new("UICorner", fovCircle).CornerRadius = UDim.new(1,0)
    local fovStroke = Instance.new("UIStroke", fovCircle)
    fovStroke.Color = Theme.AccentPink; fovStroke.Thickness = 1; fovStroke.Transparency = 0.5

    local fovUpdateConn = RunService.RenderStepped:Connect(function()
        if isUnloading or _G.BinxixUnloaded then return end
        fovCircle.Size = UDim2.new(0,Settings.Aimbot.FOVRadius*2,0,Settings.Aimbot.FOVRadius*2)
        fovCircle.Visible = not Settings.StreamerMode.Enabled and Settings.Aimbot.Enabled and Settings.Aimbot.ShowFOV
        fovStroke.Transparency = 1 - Settings.Aimbot.FOVOpacity
    end)
    table.insert(allConnections, fovUpdateConn)

    -- ---- Tracer container ----
    local tracerContainer = Instance.new("Frame")
    tracerContainer.Name = "TracerContainer"
    tracerContainer.Size = UDim2.new(1,0,1,0)
    tracerContainer.BackgroundTransparency = 1
    tracerContainer.Parent = screenGui

    local TRACER_POOL_MAX = 30
    local tracerLinePool = {}
    local tracerPoolIndex = 0
    for i = 1, TRACER_POOL_MAX do
        local line = Instance.new("Frame")
        line.BackgroundColor3 = Color3.new(1,1,1); line.BorderSizePixel = 0
        line.AnchorPoint = Vector2.new(0.5,0.5); line.Visible = false
        line.Parent = tracerContainer; tracerLinePool[i] = line
    end

    local function resetTracerPool()
        for i = 1, tracerPoolIndex do tracerLinePool[i].Visible = false end
        tracerPoolIndex = 0
    end
    local function getTracerLine()
        tracerPoolIndex = tracerPoolIndex + 1
        if tracerPoolIndex > TRACER_POOL_MAX then tracerPoolIndex = TRACER_POOL_MAX; return nil end
        return tracerLinePool[tracerPoolIndex]
    end

    local function updateTracers()
        resetTracerPool()
        if not Settings.ESP.Enabled or not Settings.ESP.TracerEnabled then return end
        local myChar = player.Character
        if not myChar then return end
        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        local camera = Workspace.CurrentCamera
        if not camera then return end
        local screenSize = camera.ViewportSize
        local tracerOrigin = Settings.ESP.TracerOrigin
        local startPos
        if tracerOrigin == "Bottom" then startPos = Vector2.new(screenSize.X/2,screenSize.Y)
        elseif tracerOrigin == "Center" then startPos = Vector2.new(screenSize.X/2,screenSize.Y/2)
        elseif tracerOrigin == "Mouse" then local m=player:GetMouse(); startPos=Vector2.new(m.X,m.Y)
        else startPos = Vector2.new(screenSize.X/2,screenSize.Y) end

        for _, target in ipairs(Players:GetPlayers()) do
            if target ~= player and isValidESPTarget(player, target) then
                local targetChar = target.Character
                if targetChar then
                    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
                    if targetHRP then
                        local screenPos, onScreen = camera:WorldToViewportPoint(targetHRP.Position)
                        if onScreen and screenPos.Z > 0 then
                            local line = getTracerLine()
                            if not line then break end
                            local tsp = Vector2.new(screenPos.X, screenPos.Y)
                            local distance = (myHRP.Position - targetHRP.Position).Magnitude
                            local espColor = Settings.ESP.RainbowColor and Color3.fromHSV(tick()%5/5,1,1) or getESPColor(distance)
                            local thickness = Settings.ESP.TracerThickness or 1
                            local lineDist = (tsp - startPos).Magnitude
                            local center = (startPos + tsp) / 2
                            local angle = math.atan2(tsp.Y - startPos.Y, tsp.X - startPos.X)
                            line.Size = UDim2.new(0,lineDist,0,thickness)
                            line.Position = UDim2.new(0,center.X,0,center.Y)
                            line.Rotation = math.deg(angle)
                            line.BackgroundColor3 = espColor
                            line.Visible = true
                        end
                    end
                end
            end
        end
    end

    -- ---- Skeleton container ----
    local skeletonContainer = Instance.new("Frame")
    skeletonContainer.Name = "SkeletonContainer"
    skeletonContainer.Size = UDim2.new(1,0,1,0)
    skeletonContainer.BackgroundTransparency = 1
    skeletonContainer.Parent = screenGui

    local SKELETON_POOL_MAX = 200
    local skeletonLinePool = {}
    local skeletonPoolIndex = 0
    for i = 1, SKELETON_POOL_MAX do
        local line = Instance.new("Frame")
        line.BackgroundColor3 = Color3.new(1,1,1); line.BorderSizePixel = 0
        line.AnchorPoint = Vector2.new(0.5,0.5); line.Visible = false
        line.Parent = skeletonContainer; skeletonLinePool[i] = line
    end
    local function resetSkeletonPool()
        for i = 1, skeletonPoolIndex do skeletonLinePool[i].Visible = false end
        skeletonPoolIndex = 0
    end
    local function getSkeletonLine()
        skeletonPoolIndex = skeletonPoolIndex + 1
        if skeletonPoolIndex > SKELETON_POOL_MAX then skeletonPoolIndex = SKELETON_POOL_MAX; return nil end
        return skeletonLinePool[skeletonPoolIndex]
    end
    local function updateSkeletonESP()
        resetSkeletonPool()
        if not Settings.ESP.Enabled or not Settings.ESP.SkeletonEnabled then return end
        local myChar = player.Character
        if not myChar then return end
        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        local camera = Workspace.CurrentCamera
        if not camera then return end
        for _, target in ipairs(Players:GetPlayers()) do
            if target ~= player and isValidESPTarget(player, target) then
                local targetChar = target.Character
                if targetChar then
                    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
                    local distance = targetHRP and (myHRP.Position - targetHRP.Position).Magnitude or 1000
                    if distance <= 500 then
                        local espColor = Settings.ESP.RainbowColor and Color3.fromHSV(tick()%5/5,1,1) or getESPColor(distance)
                        local isR15 = targetChar:FindFirstChild("UpperTorso") ~= nil
                        local connections = isR15 and SKELETON_CONNECTIONS_R15 or SKELETON_CONNECTIONS_R6
                        local thickness = Settings.ESP.SkeletonThickness or 1
                        for _, conn in ipairs(connections) do
                            local part1 = targetChar:FindFirstChild(conn[1])
                            local part2 = targetChar:FindFirstChild(conn[2])
                            if part1 and part2 then
                                local pos1 = camera:WorldToViewportPoint(part1.Position)
                                local pos2 = camera:WorldToViewportPoint(part2.Position)
                                if pos1.Z > 0 and pos2.Z > 0 then
                                    local line = getSkeletonLine()
                                    if not line then break end
                                    local sp1 = Vector2.new(pos1.X, pos1.Y)
                                    local sp2 = Vector2.new(pos2.X, pos2.Y)
                                    local ld = (sp2-sp1).Magnitude
                                    local c = (sp1+sp2)/2
                                    local a = math.atan2(sp2.Y-sp1.Y, sp2.X-sp1.X)
                                    line.Size = UDim2.new(0,ld,0,thickness)
                                    line.Position = UDim2.new(0,c.X,0,c.Y)
                                    line.Rotation = math.deg(a)
                                    line.BackgroundColor3 = espColor
                                    line.Visible = true
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    -- ---- Arrow container ----
    local arrowContainer = Instance.new("Frame")
    arrowContainer.Name = "ArrowContainer"
    arrowContainer.Size = UDim2.new(1,0,1,0)
    arrowContainer.BackgroundTransparency = 1
    arrowContainer.Parent = screenGui

    local offscreenArrows = {}

    local function createArrow(color, size)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(0,size+30,0,size+16)
        container.BackgroundTransparency = 1
        container.AnchorPoint = Vector2.new(0.5,0.5)
        container.Parent = arrowContainer

        local glow = Instance.new("ImageLabel")
        glow.Size = UDim2.new(0,size+8,0,size+8)
        glow.Position = UDim2.new(0.5,0,0,0); glow.AnchorPoint = Vector2.new(0.5,0)
        glow.BackgroundTransparency = 1
        glow.Image = "rbxassetid://3926305904"
        glow.ImageRectOffset = Vector2.new(764,764); glow.ImageRectSize = Vector2.new(36,36)
        glow.ImageColor3 = color; glow.ImageTransparency = 0.6; glow.Parent = container

        local arrow = Instance.new("ImageLabel")
        arrow.Size = UDim2.new(0,size,0,size)
        arrow.Position = UDim2.new(0.5,0,0,4); arrow.AnchorPoint = Vector2.new(0.5,0)
        arrow.BackgroundTransparency = 1
        arrow.Image = "rbxassetid://3926305904"
        arrow.ImageRectOffset = Vector2.new(764,764); arrow.ImageRectSize = Vector2.new(36,36)
        arrow.ImageColor3 = color; arrow.Parent = container

        local distLabel = Instance.new("TextLabel")
        distLabel.Size = UDim2.new(1,0,0,12); distLabel.Position = UDim2.new(0,0,1,-12)
        distLabel.BackgroundTransparency = 1; distLabel.Text = ""
        distLabel.TextColor3 = color; distLabel.TextSize = 10
        distLabel.Font = Enum.Font.SourceSansBold
        distLabel.TextStrokeTransparency = 0.4; distLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
        distLabel.Parent = container

        return {container=container, arrow=arrow, glow=glow, distLabel=distLabel}
    end

    local function updateOffscreenArrows()
        for _, arrowData in pairs(offscreenArrows) do
            if arrowData and arrowData.container then arrowData.container:Destroy() end
        end
        offscreenArrows = {}
        if not Settings.ESP.Enabled or not Settings.ESP.OffscreenArrows then return end
        local myChar = player.Character
        if not myChar then return end
        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        local camera = Workspace.CurrentCamera
        if not camera then return end
        local screenSize = camera.ViewportSize
        local screenCenter = Vector2.new(screenSize.X/2, screenSize.Y/2)
        local padding = 60
        for _, target in ipairs(Players:GetPlayers()) do
            if target ~= player and isValidESPTarget(player, target) then
                local targetChar = target.Character
                if targetChar then
                    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
                    if targetHRP then
                        local distance = (myHRP.Position - targetHRP.Position).Magnitude
                        if distance <= (Settings.ESP.ArrowDistance or 500) then
                            local screenPos, onScreen = camera:WorldToViewportPoint(targetHRP.Position)
                            if not onScreen or screenPos.Z < 0 then
                                local espColor = Settings.ESP.RainbowColor and Color3.fromHSV(tick()%5/5,1,1) or getESPColor(distance)
                                local direction = (targetHRP.Position - camera.CFrame.Position)
                                local flatDir = Vector3.new(direction.X,0,direction.Z).Unit
                                local camLook = Vector3.new(camera.CFrame.LookVector.X,0,camera.CFrame.LookVector.Z).Unit
                                local camRight = Vector3.new(camera.CFrame.RightVector.X,0,camera.CFrame.RightVector.Z).Unit
                                local angle = math.atan2(flatDir:Dot(camRight), flatDir:Dot(camLook))
                                local radiusX = screenSize.X/2 - padding
                                local radiusY = screenSize.Y/2 - padding
                                local ax = math.clamp(screenCenter.X + math.sin(angle)*radiusX, padding, screenSize.X-padding)
                                local ay = math.clamp(screenCenter.Y - math.cos(angle)*radiusY, padding, screenSize.Y-padding)
                                local arrowSize = Settings.ESP.ArrowSize or 20
                                local arrowData = createArrow(espColor, arrowSize)
                                arrowData.container.Position = UDim2.new(0,ax,0,ay)
                                arrowData.arrow.Rotation = math.deg(angle)
                                arrowData.glow.Rotation = math.deg(angle)
                                arrowData.distLabel.Text = math.floor(distance) .. "m"
                                arrowData.distLabel.TextColor3 = espColor
                                offscreenArrows[target.UserId] = arrowData
                            end
                        end
                    end
                end
            end
        end
    end

    -- ---- Main ESP loop ----
    local espUpdateConn = RunService.RenderStepped:Connect(function()
        if isUnloading or _G.BinxixUnloaded then return end
        updateESP(); updateTracers(); updateSkeletonESP(); updateOffscreenArrows(); updateTargetMarker()
    end)
    table.insert(allConnections, espUpdateConn)

    local playerRemovingConn = Players.PlayerRemoving:Connect(function(target)
        if espObjects[target.UserId] then removeESPForPlayer(target) end
    end)
    table.insert(allConnections, playerRemovingConn)

    -- ====================================================================
    -- MAIN WINDOW
    -- ====================================================================
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0,500,0,520)
    mainFrame.Position = UDim2.new(0.5,-250,0.5,-260)
    mainFrame.BackgroundColor3 = Theme.BackgroundDark
    mainFrame.BorderSizePixel = 1
    mainFrame.BorderColor3 = Theme.Border
    mainFrame.Active = true; mainFrame.Visible = true
    mainFrame.Parent = screenGui

    table.insert(themeUpdateCallbacks, function()
        mainFrame.BackgroundColor3 = Theme.BackgroundDark
        mainFrame.BorderColor3 = Theme.Border
    end)

    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"; titleBar.Size = UDim2.new(1,0,0,26)
    titleBar.BackgroundColor3 = Theme.BackgroundDark
    titleBar.BorderSizePixel = 0; titleBar.Active = true
    titleBar.Parent = mainFrame
    table.insert(themeUpdateCallbacks, function() titleBar.BackgroundColor3 = Theme.BackgroundDark end)

    local dragging, dragStart, startPos2 = false, nil, nil
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos2 = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    local dragConn = UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos2.X.Scale, startPos2.X.Offset+delta.X, startPos2.Y.Scale, startPos2.Y.Offset+delta.Y)
        end
    end)
    table.insert(allConnections, dragConn)

    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(0,220,1,0); titleText.Position = UDim2.new(0,8,0,0)
    titleText.BackgroundTransparency = 1; titleText.Text = "Binxix Hub V6"
    titleText.TextColor3 = Theme.TextPrimary; titleText.TextSize = 12
    titleText.Font = Enum.Font.SourceSansBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left; titleText.Parent = titleBar

    local versionBadge = Instance.new("TextLabel")
    versionBadge.Size = UDim2.new(0,60,0,16); versionBadge.Position = UDim2.new(0,130,0,5)
    versionBadge.BackgroundColor3 = Theme.AccentDark; versionBadge.BorderSizePixel = 0
    versionBadge.Text = "v6." .. SCRIPT_VERSION
    versionBadge.TextColor3 = Theme.AccentBright; versionBadge.TextSize = 10
    versionBadge.Font = Enum.Font.SourceSans; versionBadge.Parent = titleBar
    Instance.new("UICorner", versionBadge).CornerRadius = UDim.new(0,3)

    local gameLabel = Instance.new("TextLabel")
    gameLabel.Size = UDim2.new(0,120,0,16); gameLabel.Position = UDim2.new(1,-280,0,5)
    gameLabel.BackgroundTransparency = 1; gameLabel.Text = currentGameData.name
    gameLabel.TextColor3 = Theme.TextDim; gameLabel.TextSize = 10
    gameLabel.Font = Enum.Font.SourceSans; gameLabel.Parent = titleBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0,26,0,26); closeBtn.Position = UDim2.new(1,-26,0,0)
    closeBtn.BackgroundColor3 = Theme.BackgroundDark; closeBtn.BorderSizePixel = 0
    closeBtn.Text = "x"; closeBtn.TextColor3 = Theme.TextSecondary
    closeBtn.TextSize = 14; closeBtn.Font = Enum.Font.SourceSansBold
    closeBtn.Parent = titleBar
    closeBtn.MouseEnter:Connect(function() closeBtn.BackgroundColor3 = Color3.fromRGB(200,60,60); closeBtn.TextColor3 = Color3.fromRGB(255,255,255) end)
    closeBtn.MouseLeave:Connect(function() closeBtn.BackgroundColor3 = Theme.BackgroundDark; closeBtn.TextColor3 = Theme.TextSecondary end)
    closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false end)

    local titleLine = Instance.new("Frame")
    titleLine.Size = UDim2.new(1,0,0,1); titleLine.Position = UDim2.new(0,0,1,-1)
    titleLine.BackgroundColor3 = Theme.Border; titleLine.BorderSizePixel = 0
    titleLine.Parent = titleBar

    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"; tabContainer.Size = UDim2.new(1,0,0,26)
    tabContainer.Position = UDim2.new(0,0,0,26)
    tabContainer.BackgroundColor3 = Theme.BackgroundDark; tabContainer.BorderSizePixel = 0
    tabContainer.Parent = mainFrame

    local tabLine2 = Instance.new("Frame")
    tabLine2.Size = UDim2.new(1,0,0,1); tabLine2.Position = UDim2.new(0,0,1,-1)
    tabLine2.BackgroundColor3 = Theme.Border; tabLine2.BorderSizePixel = 0
    tabLine2.Parent = tabContainer

    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"; contentArea.Size = UDim2.new(1,-8,1,-58)
    contentArea.Position = UDim2.new(0,4,0,54)
    contentArea.BackgroundTransparency = 1; contentArea.BorderSizePixel = 0
    contentArea.Parent = mainFrame

    local tabs = {"General","Aimbot","ESP","Crosshair","Players","Report","Settings"}
    local tabButtons = {}
    local tabPages = {}
    local tabBuilt = {}
    local activeTab = "General"

    local tabIndicator = Instance.new("Frame")
    tabIndicator.Name = "TabIndicator"; tabIndicator.Size = UDim2.new(0,54,0,2)
    tabIndicator.Position = UDim2.new(0,6,1,-2)
    tabIndicator.BackgroundColor3 = Theme.AccentPink; tabIndicator.BorderSizePixel = 0
    tabIndicator.ZIndex = 2; tabIndicator.Parent = tabContainer

    local tabWidth = 54
    for i, tabName in ipairs(tabs) do
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = tabName.."Tab"
        tabBtn.Size = UDim2.new(0,tabWidth,1,0)
        tabBtn.Position = UDim2.new(0,(i-1)*tabWidth+6,0,0)
        tabBtn.BackgroundTransparency = 1
        tabBtn.Text = tabName
        tabBtn.TextColor3 = i==1 and Theme.TabActive or Theme.TabInactive
        tabBtn.TextSize = 11; tabBtn.Font = Enum.Font.SourceSans
        tabBtn.Parent = tabContainer
        tabButtons[tabName] = tabBtn
        tabBuilt[tabName] = false
    end

    -- ========== UI BUILDER HELPERS ==========
    local function createSectionHeader(parent, text, posX, posY)
        local header = Instance.new("TextLabel")
        header.Size = UDim2.new(0,200,0,16); header.Position = UDim2.new(0,posX,0,posY)
        header.BackgroundTransparency = 1; header.Text = text
        header.TextColor3 = Theme.TextHeader; header.TextSize = 12
        header.Font = Enum.Font.SourceSansBold
        header.TextXAlignment = Enum.TextXAlignment.Left; header.Parent = parent
        local ul = Instance.new("Frame")
        ul.Size = UDim2.new(0,math.max(60,#text*6),0,1)
        ul.Position = UDim2.new(0,0,1,0)
        ul.BackgroundColor3 = Theme.AccentDark; ul.BorderSizePixel = 0; ul.Parent = header
        return header
    end

    local function createCheckbox(parent, text, posX, posY, default, callback)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(0,210,0,18); container.Position = UDim2.new(0,posX,0,posY)
        container.BackgroundTransparency = 1; container.Parent = parent

        local checkbox = Instance.new("Frame")
        checkbox.Size = UDim2.new(0,12,0,12); checkbox.Position = UDim2.new(0,0,0,3)
        checkbox.BackgroundColor3 = default and Theme.CheckboxEnabled or Theme.CheckboxDisabled
        checkbox.BorderSizePixel = 1; checkbox.BorderColor3 = Theme.BorderLight
        checkbox.Parent = container

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1,-18,1,0); label.Position = UDim2.new(0,18,0,0)
        label.BackgroundTransparency = 1; label.Text = text
        label.TextColor3 = Theme.TextPrimary; label.TextSize = 12
        label.Font = Enum.Font.SourceSans
        label.TextXAlignment = Enum.TextXAlignment.Left; label.Parent = container

        local isEnabled = default

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1,0,1,0); btn.BackgroundTransparency = 1
        btn.Text = ""; btn.Parent = container

        btn.MouseButton1Click:Connect(function()
            if isUnloading or _G.BinxixUnloaded then return end
            isEnabled = not isEnabled
            checkbox.BackgroundColor3 = isEnabled and Theme.CheckboxEnabled or Theme.CheckboxDisabled
            if callback then callback(isEnabled) end
        end)

        return {
            container = container,
            setValue = function(val)
                isEnabled = val
                checkbox.BackgroundColor3 = isEnabled and Theme.CheckboxEnabled or Theme.CheckboxDisabled
            end,
            getValue = function() return isEnabled end
        }
    end

    local function createSlider(parent, text, posX, posY, min, max, default, callback)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(0,210,0,32); container.Position = UDim2.new(0,posX,0,posY)
        container.BackgroundTransparency = 1; container.Parent = parent

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0,130,0,14); label.BackgroundTransparency = 1
        label.Text = text; label.TextColor3 = Theme.TextPrimary; label.TextSize = 12
        label.Font = Enum.Font.SourceSans; label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = container

        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0,60,0,14); valueLabel.Position = UDim2.new(1,-60,0,0)
        valueLabel.BackgroundTransparency = 1; valueLabel.Text = tostring(default)
        valueLabel.TextColor3 = Theme.AccentPink; valueLabel.TextSize = 12
        valueLabel.Font = Enum.Font.SourceSans
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right; valueLabel.Parent = container

        local sliderBg = Instance.new("Frame")
        sliderBg.Size = UDim2.new(1,0,0,4); sliderBg.Position = UDim2.new(0,0,0,18)
        sliderBg.BackgroundColor3 = Theme.SliderBackground; sliderBg.BorderSizePixel = 0
        sliderBg.Parent = container

        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new((default-min)/(max-min),0,1,0)
        sliderFill.BackgroundColor3 = Theme.SliderFill; sliderFill.BorderSizePixel = 0
        sliderFill.Parent = sliderBg

        local currentValue = default
        local draggingSlider = false

        local sliderBtn = Instance.new("TextButton")
        sliderBtn.Size = UDim2.new(1,0,0,16); sliderBtn.Position = UDim2.new(0,0,0,10)
        sliderBtn.BackgroundTransparency = 1; sliderBtn.Text = ""; sliderBtn.Parent = container

        sliderBtn.MouseButton1Down:Connect(function() draggingSlider = true end)

        local inputEndConn = UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider = false end
        end)
        table.insert(allConnections, inputEndConn)

        local updateConn = RunService.RenderStepped:Connect(function()
            if isUnloading or _G.BinxixUnloaded then return end
            if draggingSlider then
                local mouse = player:GetMouse()
                local relX = math.clamp((mouse.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                if max <= 1 then
                    currentValue = math.floor((min + relX*(max-min))*100)/100
                else
                    currentValue = math.floor(min + relX*(max-min) + 0.5)
                end
                sliderFill.Size = UDim2.new(relX,0,1,0)
                valueLabel.Text = tostring(currentValue)
                if callback then callback(currentValue) end
            end
        end)
        table.insert(allConnections, updateConn)

        return container
    end

    local function createDropdown(parent, text, posX, posY, options, default, callback)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(0,210,0,36); container.Position = UDim2.new(0,posX,0,posY)
        container.BackgroundTransparency = 1; container.Parent = parent

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0,95,0,16); label.BackgroundTransparency = 1
        label.Text = text; label.TextColor3 = Theme.TextPrimary; label.TextSize = 12
        label.Font = Enum.Font.SourceSans; label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = container

        local dropBtn = Instance.new("TextButton")
        dropBtn.Size = UDim2.new(0,105,0,18); dropBtn.Position = UDim2.new(1,-105,0,16)
        dropBtn.BackgroundColor3 = Theme.SliderBackground
        dropBtn.BorderSizePixel = 1; dropBtn.BorderColor3 = Theme.Border
        dropBtn.Text = default .. " v"; dropBtn.TextColor3 = Theme.TextPrimary
        dropBtn.TextSize = 11; dropBtn.Font = Enum.Font.SourceSans
        dropBtn.Parent = container

        local currentSelection = default
        local isOpen = false

        local optionsFrame = Instance.new("Frame")
        optionsFrame.Size = UDim2.new(0,105,0,#options*18)
        optionsFrame.BackgroundColor3 = Theme.Background
        optionsFrame.BorderSizePixel = 1; optionsFrame.BorderColor3 = Theme.Border
        optionsFrame.Visible = false; optionsFrame.ZIndex = 100
        optionsFrame.Parent = screenGui

        for i, opt in ipairs(options) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1,0,0,18); optBtn.Position = UDim2.new(0,0,0,(i-1)*18)
            optBtn.BackgroundColor3 = Theme.Background; optBtn.BorderSizePixel = 0
            optBtn.Text = opt; optBtn.TextColor3 = Theme.TextPrimary
            optBtn.TextSize = 11; optBtn.Font = Enum.Font.SourceSans
            optBtn.ZIndex = 101; optBtn.Parent = optionsFrame
            optBtn.MouseEnter:Connect(function() optBtn.BackgroundColor3 = Theme.AccentDark end)
            optBtn.MouseLeave:Connect(function() optBtn.BackgroundColor3 = Theme.Background end)
            optBtn.MouseButton1Click:Connect(function()
                currentSelection = opt
                dropBtn.Text = opt .. " v"
                isOpen = false; optionsFrame.Visible = false
                if callback then callback(opt) end
            end)
        end

        dropBtn.MouseButton1Click:Connect(function()
            isOpen = not isOpen
            if isOpen then
                local absPos = dropBtn.AbsolutePosition; local absSize = dropBtn.AbsoluteSize
                optionsFrame.Position = UDim2.new(0,absPos.X,0,absPos.Y+absSize.Y)
            end
            optionsFrame.Visible = isOpen
        end)

        return container
    end

    local function createButton(parent, text, posX, posY, w, h, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0,w or 180,0,h or 24)
        btn.Position = UDim2.new(0,posX,0,posY)
        btn.BackgroundColor3 = Theme.SliderBackground
        btn.BorderSizePixel = 1; btn.BorderColor3 = Theme.Border
        btn.Text = text; btn.TextColor3 = Theme.TextPrimary
        btn.TextSize = 11; btn.Font = Enum.Font.SourceSans
        btn.Parent = parent
        btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Theme.AccentDark end)
        btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Theme.SliderBackground end)
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    local function createWarningLabel(parent, text, posX, posY)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0,220,0,14); lbl.Position = UDim2.new(0,posX,0,posY)
        lbl.BackgroundTransparency = 1; lbl.Text = "[ Warning ] " .. text
        lbl.TextColor3 = Color3.fromRGB(255,110,60); lbl.TextSize = 10
        lbl.Font = Enum.Font.SourceSansItalic
        lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = parent
        return lbl
    end

    -- ======================================================
    -- AUTO TP LOOP + ANTI DEATH
    -- ======================================================
    local autoTPTarget = nil
    local autoTPLoopConn = nil
    local antiDeathConn = nil
    local antiDeathDiedConn = nil
    local lastSafeTPPosition = nil

    local function startAntiDeath()
        if antiDeathConn then return end
        antiDeathConn = RunService.Heartbeat:Connect(function()
            if isUnloading or _G.BinxixUnloaded then return end
            if not Settings.Misc.AutoTPLoop or not Settings.Misc.AutoTPAntiDeath then return end
            local char = player.Character
            if not char then return end
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then humanoid.Health = humanoid.MaxHealth end
            local hasFF = false
            for _, child in ipairs(char:GetChildren()) do
                if child:IsA("ForceField") then hasFF = true; break end
            end
            if not hasFF then
                pcall(function()
                    local ff = Instance.new("ForceField"); ff.Name = "BinxixAntiDeath"
                    ff.Visible = false; ff.Parent = char
                end)
            end
        end)
        table.insert(allConnections, antiDeathConn)

        local function hookDeath()
            local char = player.Character
            if not char then return end
            local humanoid = char:FindFirstChild("Humanoid")
            if not humanoid then return end
            if antiDeathDiedConn then pcall(function() antiDeathDiedConn:Disconnect() end) end
            antiDeathDiedConn = humanoid.Died:Connect(function()
                if not Settings.Misc.AutoTPLoop or not Settings.Misc.AutoTPAntiDeath then return end
                local savedPos = lastSafeTPPosition
                task.wait(0.1); player:LoadCharacter()
                local newChar = player.CharacterAdded:Wait()
                task.wait(0.5)
                local newHRP = newChar:WaitForChild("HumanoidRootPart", 5)
                local newHumanoid = newChar:WaitForChild("Humanoid", 5)
                if newHRP and savedPos and Settings.Misc.AutoTPLoop then
                    pcall(function()
                        local ff = Instance.new("ForceField"); ff.Name = "BinxixAntiDeath"
                        ff.Visible = false; ff.Parent = newChar
                    end)
                    if newHumanoid then newHumanoid.Health = newHumanoid.MaxHealth end
                    task.wait(0.1); newHRP.CFrame = savedPos
                end
                hookDeath()
            end)
            table.insert(allConnections, antiDeathDiedConn)
        end
        hookDeath()

        local charAddedConn = player.CharacterAdded:Connect(function(newChar)
            task.wait(0.5)
            if Settings.Misc.AutoTPLoop and Settings.Misc.AutoTPAntiDeath then
                pcall(function()
                    local ff = Instance.new("ForceField"); ff.Name = "BinxixAntiDeath"
                    ff.Visible = false; ff.Parent = newChar
                end)
                local h = newChar:WaitForChild("Humanoid", 5)
                if h then h.Health = h.MaxHealth end
                hookDeath()
            end
        end)
        table.insert(allConnections, charAddedConn)
    end

    stopAntiDeath = function()
        if antiDeathConn then pcall(function() antiDeathConn:Disconnect() end); antiDeathConn = nil end
        if antiDeathDiedConn then pcall(function() antiDeathDiedConn:Disconnect() end); antiDeathDiedConn = nil end
        pcall(function()
            local char = player.Character
            if char then
                for _, child in ipairs(char:GetChildren()) do
                    if child:IsA("ForceField") and child.Name == "BinxixAntiDeath" then child:Destroy() end
                end
            end
        end)
    end

    local function getNextTPTarget()
        local myChar = player.Character
        if not myChar then return nil end
        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
        if not myHRP then return nil end
        local targetName = Settings.Misc.AutoTPTargetName
        if targetName and targetName ~= "Nearest Enemy" then
            for _, target in ipairs(Players:GetPlayers()) do
                if target ~= player and (target.DisplayName == targetName or target.Name == targetName) then
                    local targetChar = target.Character
                    if targetChar then
                        local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
                        local h = targetChar:FindFirstChild("Humanoid")
                        if targetHRP and h and h.Health > 0 and not isTargetProtected(target) then return target end
                    end
                end
            end
            return nil
        end
        local nearest, nearestDist = nil, math.huge
        for _, target in ipairs(Players:GetPlayers()) do
            if target ~= player and isValidTarget(player, target) then
                local targetChar = target.Character
                if targetChar then
                    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
                    local h = targetChar:FindFirstChild("Humanoid")
                    if targetHRP and h and h.Health > 0 and not isTargetProtected(target) then
                        local dist = (myHRP.Position - targetHRP.Position).Magnitude
                        if dist < nearestDist then nearestDist = dist; nearest = target end
                    end
                end
            end
        end
        return nearest
    end

    local function startAutoTPLoop()
        if autoTPLoopConn then return end
        if Settings.Misc.AutoTPAntiDeath then startAntiDeath() end
        autoTPLoopConn = task.spawn(function()
            while Settings.Misc.AutoTPLoop and not isUnloading and not _G.BinxixUnloaded do
                local myChar = player.Character
                local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
                if myHRP then
                    autoTPTarget = getNextTPTarget()
                    if autoTPTarget then
                        local targetChar = autoTPTarget.Character
                        if targetChar then
                            local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
                            local h = targetChar:FindFirstChild("Humanoid")
                            if targetHRP and h and h.Health > 0 then
                                local targetPos = targetHRP.Position
                                local MIN_Y, MAX_Y = -50, 2000
                                local skipTarget = false
                                local safePosition = myHRP.CFrame
                                if targetPos.Y < MIN_Y or targetPos.Y > MAX_Y then skipTarget = true end
                                local rayParams = RaycastParams.new()
                                rayParams.FilterType = Enum.RaycastFilterType.Exclude
                                rayParams.FilterDescendantsInstances = {myChar, autoTPTarget.Character}
                                if not skipTarget then
                                    local groundCheck = Workspace:Raycast(targetPos, Vector3.new(0,-200,0), rayParams)
                                    if not groundCheck and targetPos.Y > 20 then
                                        local waitedForGround = false
                                        for _ = 1, 20 do
                                            task.wait(0.1)
                                            if not Settings.Misc.AutoTPLoop then break end
                                            local tChar = autoTPTarget and autoTPTarget.Character
                                            if not tChar then break end
                                            local tHRP = tChar:FindFirstChild("HumanoidRootPart")
                                            if not tHRP then break end
                                            local tPos = tHRP.Position
                                            if tPos.Y < MIN_Y then break end
                                            local gCheck = Workspace:Raycast(tPos, Vector3.new(0,-200,0), rayParams)
                                            if gCheck then waitedForGround = true; targetHRP = tHRP; break end
                                        end
                                        if not waitedForGround then skipTarget = true end
                                    end
                                end
                                if not skipTarget then
                                    local targetCF = targetHRP.CFrame
                                    local lookAtTarget = CFrame.lookAt(targetCF.Position + targetCF.LookVector*2, targetCF.Position)
                                    myHRP.CFrame = lookAtTarget; lastSafeTPPosition = lookAtTarget
                                    local camera = Workspace.CurrentCamera
                                    if camera then
                                        camera.CFrame = CFrame.lookAt(myHRP.Position+Vector3.new(0,2,0), targetHRP.Position)
                                    end
                                    task.wait(0.05)
                                    myChar = player.Character; myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
                                    if myHRP and myHRP.Position.Y < MIN_Y then
                                        myHRP.CFrame = safePosition; skipTarget = true
                                    end
                                end
                                if not skipTarget then
                                    while Settings.Misc.AutoTPLoop and not isUnloading and not _G.BinxixUnloaded do
                                        task.wait(0.05)
                                        myChar = player.Character; myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
                                        if not myHRP then break end
                                        if myHRP.Position.Y < MIN_Y then myHRP.CFrame = safePosition; break end
                                        local selfGround = Workspace:Raycast(myHRP.Position, Vector3.new(0,-10,0), rayParams)
                                        if selfGround then safePosition = myHRP.CFrame end
                                        targetChar = autoTPTarget and autoTPTarget.Character
                                        if not targetChar then break end
                                        local tHum = targetChar:FindFirstChild("Humanoid")
                                        if not tHum or tHum.Health <= 0 then break end
                                        targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
                                        if not targetHRP then break end
                                        if targetHRP.Position.Y < MIN_Y then break end
                                        if isTargetProtected(autoTPTarget) then break end
                                        local dist = (myHRP.Position - targetHRP.Position).Magnitude
                                        if dist > 5 and targetHRP.Position.Y > MIN_Y then
                                            local tCF = targetHRP.CFrame
                                            myHRP.CFrame = CFrame.lookAt(tCF.Position + tCF.LookVector*2, tCF.Position)
                                        end
                                        local cam = Workspace.CurrentCamera
                                        if cam then
                                            cam.CFrame = CFrame.lookAt(myHRP.Position+Vector3.new(0,1.5,0), targetHRP.Position+Vector3.new(0,1,0))
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                task.wait(Settings.Misc.AutoTPLoopDelay or 0.5)
            end
            autoTPTarget = nil; autoTPLoopConn = nil
        end)
    end

    local function stopAutoTPLoop()
        Settings.Misc.AutoTPLoop = false; autoTPTarget = nil; lastSafeTPPosition = nil
        stopAntiDeath()
        if autoTPLoopConn then pcall(function() task.cancel(autoTPLoopConn) end); autoTPLoopConn = nil end
    end

    -- ======================================================
    -- TAB PAGE CREATION FUNCTIONS (lazy - called on demand)
    -- ======================================================

    local autoTPCheckbox = nil
    local autoTPEnabled = false
    local autoTPToggleKey = Enum.KeyCode.T
    local waitingForTPKey = false
    local tpTargetBtn = nil

    local function buildGeneralTab(page)
        -- ── LEFT COLUMN ──────────────────────────────────────────────
        local leftY = 0

        -- Movement section: hidden entirely for noMovement games
        if not currentGameData.noMovement then
            createSectionHeader(page, "Movement", 0, leftY)
            createCheckbox(page, "Speed Boost", 0, leftY+22, false, function(e)
                Settings.Movement.SpeedEnabled = e
                if Settings.Movement.SpeedMethod == "WalkSpeed" then
                    local char = player.Character
                    if char then
                        local h = char:FindFirstChild("Humanoid")
                        if h then h.WalkSpeed = e and Settings.Movement.Speed or 16 end
                    end
                end
                if not e then
                    local char = player.Character
                    if char then
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        if hrp then local bv = hrp:FindFirstChild("BinxixSpeedVelocity"); if bv then bv:Destroy() end end
                        if Settings.Movement.SpeedMethod == "WalkSpeed" then
                            local h = char:FindFirstChild("Humanoid"); if h then h.WalkSpeed = 16 end
                        end
                    end
                end
            end)
            createSlider(page, "Speed", 0, leftY+44, 16, 200, 16, function(v)
                Settings.Movement.Speed = v
                if Settings.Movement.SpeedEnabled and Settings.Movement.SpeedMethod == "WalkSpeed" then
                    local char = player.Character
                    if char then local h = char:FindFirstChild("Humanoid"); if h then h.WalkSpeed = v end end
                end
            end)
            createDropdown(page, "Speed Method", 0, leftY+80, {"WalkSpeed","CFrame","Velocity"}, "WalkSpeed", function(v)
                local char = player.Character
                if char then
                    local h = char:FindFirstChild("Humanoid")
                    if h and Settings.Movement.SpeedMethod == "WalkSpeed" then h.WalkSpeed = 16 end
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then local bv = hrp:FindFirstChild("BinxixSpeedVelocity"); if bv then bv:Destroy() end end
                end
                Settings.Movement.SpeedMethod = v
                if Settings.Movement.SpeedEnabled and v == "WalkSpeed" then
                    if char then local h = char:FindFirstChild("Humanoid"); if h then h.WalkSpeed = Settings.Movement.Speed end end
                end
            end)
            createCheckbox(page, "High Jump", 0, leftY+120, false, function(e)
                Settings.Movement.JumpEnabled = e
                local char = player.Character
                if char then local h = char:FindFirstChild("Humanoid"); if h then h.JumpPower = e and Settings.Movement.JumpPower or 50 end end
            end)
            createSlider(page, "Jump Power", 0, leftY+142, 50, 300, 50, function(v)
                Settings.Movement.JumpPower = v
                if Settings.Movement.JumpEnabled then
                    local char = player.Character; if char then local h = char:FindFirstChild("Humanoid"); if h then h.JumpPower = v end end
                end
            end)
            createCheckbox(page, "Bunny Hop", 0, leftY+178, false, function(e) Settings.Movement.BunnyHop = e end)
            createSlider(page, "Bhop Speed", 0, leftY+200, 1, 100, 30, function(v) Settings.Movement.BunnyHopSpeed = v end)
            leftY = leftY + 240
        end

        -- Server section (always shown)
        createSectionHeader(page, "Server", 0, leftY)
        createButton(page, "Rejoin Server", 0, leftY+20, 180, 22, function()
            pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player) end)
        end)
        createButton(page, "Server Hop", 0, leftY+46, 180, 22, function()
            pcall(function() TeleportService:Teleport(game.PlaceId, player) end)
        end)
        leftY = leftY + 76

        createSectionHeader(page, "Gun Mods", 0, leftY)
        createWarningLabel(page, "May cause lag — WIP", 0, leftY+18)
        createCheckbox(page, "Fast Reload", 0, leftY+36, false, function(e)
            Settings.Combat.FastReload = e
            if e then applyAllGunMods() else restoreGunMod("ReloadTime"); restoreGunMod("EReloadTime") end
            sendNotification("Gun Mods", e and "Fast Reload on" or "Fast Reload off", 2)
        end)
        createCheckbox(page, "Fast Fire Rate", 0, leftY+58, false, function(e)
            Settings.Combat.FastFireRate = e
            if e then applyAllGunMods() else restoreGunMod("FireRate") end
            sendNotification("Gun Mods", e and "Fast Fire Rate on" or "Fast Fire Rate off", 2)
        end)
        createCheckbox(page, "Always Auto", 0, leftY+80, false, function(e)
            Settings.Combat.AlwaysAuto = e
            if e then applyAllGunMods() else restoreGunMod("Auto") end
            sendNotification("Gun Mods", e and "Always Auto on" or "Always Auto off", 2)
        end)
        createCheckbox(page, "No Spread", 0, leftY+102, false, function(e)
            Settings.Combat.NoSpread = e
            if e then applyAllGunMods() else restoreGunMod("Spread") end
            sendNotification("Gun Mods", e and "No Spread on" or "No Spread off", 2)
        end)
        createCheckbox(page, "No Recoil", 0, leftY+124, false, function(e)
            Settings.Combat.NoRecoil = e
            if e then applyAllGunMods() else restoreGunMod("Recoil") end
            sendNotification("Gun Mods", e and "No Recoil on" or "No Recoil off", 2)
        end)

        createSectionHeader(page, "Visuals", 240, 0)
        createCheckbox(page, "Fullbright", 240, 22, false, function(e)
            Settings.Visuals.Fullbright = e
            if e then
                Lighting.Ambient = Color3.fromRGB(255,255,255); Lighting.Brightness = 2
                Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
            else
                Lighting.Ambient = Color3.fromRGB(127,127,127); Lighting.Brightness = 1
                Lighting.OutdoorAmbient = Color3.fromRGB(127,127,127)
            end
        end)
        createCheckbox(page, "No Fog", 240, 44, false, function(e)
            Settings.Visuals.NoFog = e
            if e then enableNoFog() else disableNoFog() end
        end)
        createCheckbox(page, "Custom FOV", 240, 66, false, function(e)
            Settings.Visuals.CustomFOV = e
            local camera = Workspace.CurrentCamera
            if camera then camera.FieldOfView = e and Settings.Visuals.FOVAmount or 70 end
        end)
        createSlider(page, "FOV Amount", 240, 88, 30, 120, 70, function(v)
            Settings.Visuals.FOVAmount = v
            if Settings.Visuals.CustomFOV then
                local camera = Workspace.CurrentCamera; if camera then camera.FieldOfView = v end
            end
        end)
        createCheckbox(page, "Show FPS", 240, 124, false, function(e) Settings.Visuals.ShowFPS = e end)
        createCheckbox(page, "Show Velocity", 240, 146, false, function(e) Settings.Visuals.ShowVelocity = e end)

        -- Right column: Fly, Misc, Auto TP, Chat Spammer hidden for noMovement games
        local rightY = 172
        if not currentGameData.noMovement then
            createSectionHeader(page, "Fly", 240, rightY)
            createCheckbox(page, "Enable Fly  (F = toggle)", 240, rightY+22, false, function(e)
                Settings.Movement.Fly = e
                if e then startFly(); sendNotification("Fly", "On - press F to toggle", 2)
                else stopFly(); sendNotification("Fly", "Off", 2) end
            end)
            createSlider(page, "Fly Speed", 240, rightY+46, 10, 200, 50, function(v) Settings.Movement.FlySpeed = v end)
            rightY = rightY + 86

            createSectionHeader(page, "Misc", 240, rightY)
            createCheckbox(page, "Anti-AFK", 240, rightY+22, false, function(e) Settings.Misc.AntiAFK = e end)
            createCheckbox(page, "Auto-Rejoin", 240, rightY+44, false, function(e) Settings.Misc.AutoRejoin = e end)
            rightY = rightY + 70

            createSectionHeader(page, "Auto TP Loop", 240, rightY)
            createWarningLabel(page, "Risky - may cause ban", 240, rightY+18)
            rightY = rightY + 36

            local autoTPContainer = Instance.new("Frame")
            autoTPContainer.Size = UDim2.new(0,220,0,18); autoTPContainer.Position = UDim2.new(0,240,0,rightY)
            autoTPContainer.BackgroundTransparency = 1; autoTPContainer.Parent = page

            autoTPCheckbox = Instance.new("Frame")
            autoTPCheckbox.Size = UDim2.new(0,12,0,12); autoTPCheckbox.Position = UDim2.new(0,0,0,3)
            autoTPCheckbox.BackgroundColor3 = Theme.CheckboxDisabled
            autoTPCheckbox.BorderSizePixel = 1; autoTPCheckbox.BorderColor3 = Theme.BorderLight
            autoTPCheckbox.Parent = autoTPContainer

            local autoTPLabel = Instance.new("TextLabel")
            autoTPLabel.Size = UDim2.new(1,-18,1,0); autoTPLabel.Position = UDim2.new(0,18,0,0)
            autoTPLabel.BackgroundTransparency = 1; autoTPLabel.Text = "Auto TP Loop"
            autoTPLabel.TextColor3 = Theme.TextPrimary; autoTPLabel.TextSize = 12
            autoTPLabel.Font = Enum.Font.SourceSans
            autoTPLabel.TextXAlignment = Enum.TextXAlignment.Left; autoTPLabel.Parent = autoTPContainer

            local toggleAutoTP

            local autoTPBtn = Instance.new("TextButton")
            autoTPBtn.Size = UDim2.new(1,0,1,0); autoTPBtn.BackgroundTransparency = 1
            autoTPBtn.Text = ""; autoTPBtn.Parent = autoTPContainer
            autoTPBtn.MouseButton1Click:Connect(function() if toggleAutoTP then toggleAutoTP() end end)

            local tpKeybindRow = Instance.new("Frame")
            tpKeybindRow.Size = UDim2.new(0,220,0,18); tpKeybindRow.Position = UDim2.new(0,240,0,rightY+22)
            tpKeybindRow.BackgroundTransparency = 1; tpKeybindRow.Parent = page

            local tpKeybindLbl = Instance.new("TextLabel")
            tpKeybindLbl.Size = UDim2.new(0,70,1,0); tpKeybindLbl.BackgroundTransparency = 1
            tpKeybindLbl.Text = "TP Keybind:"; tpKeybindLbl.TextColor3 = Theme.TextSecondary
            tpKeybindLbl.TextSize = 11; tpKeybindLbl.Font = Enum.Font.SourceSans
            tpKeybindLbl.TextXAlignment = Enum.TextXAlignment.Left; tpKeybindLbl.Parent = tpKeybindRow

            local tpKeybindBtn = Instance.new("TextButton")
            tpKeybindBtn.Size = UDim2.new(0,80,0,18); tpKeybindBtn.Position = UDim2.new(0,72,0,0)
            tpKeybindBtn.BackgroundColor3 = Theme.SliderBackground
            tpKeybindBtn.BorderSizePixel = 1; tpKeybindBtn.BorderColor3 = Theme.Border
            tpKeybindBtn.Text = "T"; tpKeybindBtn.TextColor3 = Theme.AccentBright
            tpKeybindBtn.TextSize = 11; tpKeybindBtn.Font = Enum.Font.SourceSansBold
            tpKeybindBtn.Parent = tpKeybindRow

            tpKeybindBtn.MouseEnter:Connect(function()
                if not waitingForTPKey then tpKeybindBtn.BackgroundColor3 = Theme.AccentDark end
            end)
            tpKeybindBtn.MouseLeave:Connect(function()
                if not waitingForTPKey then tpKeybindBtn.BackgroundColor3 = Theme.SliderBackground end
            end)
            tpKeybindBtn.MouseButton1Click:Connect(function()
                waitingForTPKey = true
                tpKeybindBtn.Text = "Press key..."
                tpKeybindBtn.TextColor3 = Color3.fromRGB(255,255,100)
                tpKeybindBtn.BackgroundColor3 = Color3.fromRGB(60,60,40)
            end)
            local tpKbConn = UserInputService.InputBegan:Connect(function(input, gp)
                if waitingForTPKey and input.UserInputType == Enum.UserInputType.Keyboard then
                    autoTPToggleKey = input.KeyCode
                    tpKeybindBtn.Text = input.KeyCode.Name
                    tpKeybindBtn.TextColor3 = Theme.AccentBright
                    tpKeybindBtn.BackgroundColor3 = Theme.SliderBackground
                    waitingForTPKey = false
                end
            end)
            table.insert(allConnections, tpKbConn)

            local tpTargetDropFrame = Instance.new("Frame")
            tpTargetDropFrame.Size = UDim2.new(0,220,0,38); tpTargetDropFrame.Position = UDim2.new(0,240,0,rightY+44)
            tpTargetDropFrame.BackgroundTransparency = 1; tpTargetDropFrame.Parent = page

            local tpTargetLbl = Instance.new("TextLabel")
            tpTargetLbl.Size = UDim2.new(0,70,0,14); tpTargetLbl.BackgroundTransparency = 1
            tpTargetLbl.Text = "TP Target:"; tpTargetLbl.TextColor3 = Theme.TextSecondary
            tpTargetLbl.TextSize = 11; tpTargetLbl.Font = Enum.Font.SourceSans
            tpTargetLbl.TextXAlignment = Enum.TextXAlignment.Left; tpTargetLbl.Parent = tpTargetDropFrame

            tpTargetBtn = Instance.new("TextButton")
            tpTargetBtn.Size = UDim2.new(0,145,0,18); tpTargetBtn.Position = UDim2.new(0,72,0,0)
            tpTargetBtn.BackgroundColor3 = Theme.SliderBackground
            tpTargetBtn.BorderSizePixel = 1; tpTargetBtn.BorderColor3 = Theme.Border
            tpTargetBtn.Text = "Nearest Enemy v"; tpTargetBtn.TextColor3 = Theme.AccentBright
            tpTargetBtn.TextSize = 11; tpTargetBtn.Font = Enum.Font.SourceSans
            tpTargetBtn.TextTruncate = Enum.TextTruncate.AtEnd; tpTargetBtn.Parent = tpTargetDropFrame

            local tpDropdownOpen = false
            local tpDropdownFrame = nil

            local function closeTpDropdown()
                if tpDropdownFrame then tpDropdownFrame:Destroy(); tpDropdownFrame = nil end
                tpDropdownOpen = false
            end

            local function openTpDropdown()
                closeTpDropdown(); tpDropdownOpen = true
                local options = {"Nearest Enemy"}
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= player then table.insert(options, p.DisplayName) end
                end
                tpDropdownFrame = Instance.new("ScrollingFrame")
                tpDropdownFrame.Size = UDim2.new(0,145,0,math.min(#options*18,108))
                tpDropdownFrame.Position = UDim2.new(0,72,0,19)
                tpDropdownFrame.BackgroundColor3 = Theme.BackgroundDark
                tpDropdownFrame.BorderSizePixel = 1; tpDropdownFrame.BorderColor3 = Theme.AccentDark
                tpDropdownFrame.ScrollBarThickness = 3; tpDropdownFrame.ScrollBarImageColor3 = Theme.AccentDark
                tpDropdownFrame.CanvasSize = UDim2.new(0,0,0,#options*18)
                tpDropdownFrame.ScrollingDirection = Enum.ScrollingDirection.Y
                tpDropdownFrame.ZIndex = 50; tpDropdownFrame.Parent = tpTargetDropFrame
                for i, optionName in ipairs(options) do
                    local optBtn = Instance.new("TextButton")
                    optBtn.Size = UDim2.new(1,0,0,18); optBtn.Position = UDim2.new(0,0,0,(i-1)*18)
                    optBtn.BackgroundColor3 = Theme.BackgroundDark; optBtn.BackgroundTransparency = 0
                    optBtn.BorderSizePixel = 0; optBtn.Text = optionName
                    optBtn.TextColor3 = optionName == Settings.Misc.AutoTPTargetName and Theme.AccentBright or Theme.TextPrimary
                    optBtn.TextSize = 11; optBtn.Font = Enum.Font.SourceSans
                    optBtn.TextTruncate = Enum.TextTruncate.AtEnd; optBtn.ZIndex = 51; optBtn.Parent = tpDropdownFrame
                    optBtn.MouseEnter:Connect(function() optBtn.BackgroundColor3 = Theme.AccentDark end)
                    optBtn.MouseLeave:Connect(function() optBtn.BackgroundColor3 = Theme.BackgroundDark end)
                    optBtn.MouseButton1Click:Connect(function()
                        Settings.Misc.AutoTPTargetName = optionName
                        tpTargetBtn.Text = optionName .. " v"; closeTpDropdown()
                    end)
                end
            end

            tpTargetBtn.MouseEnter:Connect(function() if not tpDropdownOpen then tpTargetBtn.BackgroundColor3 = Theme.AccentDark end end)
            tpTargetBtn.MouseLeave:Connect(function() if not tpDropdownOpen then tpTargetBtn.BackgroundColor3 = Theme.SliderBackground end end)
            tpTargetBtn.MouseButton1Click:Connect(function()
                if tpDropdownOpen then closeTpDropdown() else openTpDropdown() end
            end)

            createSlider(page, "TP Delay (s)", 240, rightY+86, 0.05, 2, 0.2, function(v) Settings.Misc.AutoTPLoopDelay = v end)
            createCheckbox(page, "Anti-Death (TP)", 240, rightY+122, true, function(e)
                Settings.Misc.AutoTPAntiDeath = e
                if Settings.Misc.AutoTPLoop then
                    if e then startAntiDeath() else stopAntiDeath() end
                end
            end)

            rightY = rightY + 148

            createSectionHeader(page, "Chat Spammer", 240, rightY)
            createCheckbox(page, "Chat Spammer", 240, rightY+22, false, function(e)
                Settings.Misc.ChatSpammer = e
                sendNotification("Chat Spammer", e and "On" or "Off", 2)
            end)
            createSlider(page, "Spam Delay (s)", 240, rightY+44, 0.5, 10, 3, function(v) Settings.Misc.ChatSpamDelay = v end)

            local spamMsgLbl = Instance.new("TextLabel")
            spamMsgLbl.Size = UDim2.new(0,200,0,14); spamMsgLbl.Position = UDim2.new(0,240,0,rightY+80)
            spamMsgLbl.BackgroundTransparency = 1; spamMsgLbl.Text = "Spam Message:"
            spamMsgLbl.TextColor3 = Theme.TextSecondary; spamMsgLbl.TextSize = 11
            spamMsgLbl.Font = Enum.Font.SourceSans
            spamMsgLbl.TextXAlignment = Enum.TextXAlignment.Left; spamMsgLbl.Parent = page

            local spamMsgBox = Instance.new("TextBox")
            spamMsgBox.Size = UDim2.new(0,210,0,22); spamMsgBox.Position = UDim2.new(0,240,0,rightY+96)
            spamMsgBox.BackgroundColor3 = Theme.BackgroundDark
            spamMsgBox.BorderSizePixel = 1; spamMsgBox.BorderColor3 = Theme.Border
            spamMsgBox.Text = Settings.Misc.ChatSpamMessage
            spamMsgBox.PlaceholderText = "Enter spam message..."
            spamMsgBox.PlaceholderColor3 = Theme.TextDim; spamMsgBox.TextColor3 = Theme.TextPrimary
            spamMsgBox.TextSize = 11; spamMsgBox.Font = Enum.Font.SourceSans
            spamMsgBox.TextXAlignment = Enum.TextXAlignment.Left
            spamMsgBox.ClearTextOnFocus = false; spamMsgBox.Parent = page
            spamMsgBox.FocusLost:Connect(function()
                if spamMsgBox.Text ~= "" then Settings.Misc.ChatSpamMessage = spamMsgBox.Text end
            end)

            page.CanvasSize = UDim2.new(0,0,0,rightY+130)

            toggleAutoTP = function()
                if isUnloading or _G.BinxixUnloaded then return end
                autoTPEnabled = not autoTPEnabled
                Settings.Misc.AutoTPLoop = autoTPEnabled
                autoTPCheckbox.BackgroundColor3 = autoTPEnabled and Theme.CheckboxEnabled or Theme.CheckboxDisabled
                if autoTPEnabled then
                    startAutoTPLoop()
                    sendNotification("Auto TP", "On - targeting: " .. Settings.Misc.AutoTPTargetName, 2)
                else
                    stopAutoTPLoop()
                    sendNotification("Auto TP", "Off", 2)
                end
            end
        else
            -- BlockSpin (noMovement): only show a notice and set a smaller canvas
            local noMoveLbl = Instance.new("TextLabel")
            noMoveLbl.Size = UDim2.new(0,200,0,28); noMoveLbl.Position = UDim2.new(0,240,0,172)
            noMoveLbl.BackgroundColor3 = Color3.fromRGB(30,20,20)
            noMoveLbl.BorderSizePixel = 1; noMoveLbl.BorderColor3 = Color3.fromRGB(100,40,40)
            noMoveLbl.Text = "Movement disabled for " .. currentGameData.name
            noMoveLbl.TextColor3 = Color3.fromRGB(255,100,100); noMoveLbl.TextSize = 11
            noMoveLbl.Font = Enum.Font.SourceSansBold
            noMoveLbl.TextXAlignment = Enum.TextXAlignment.Center
            noMoveLbl.TextWrapped = true; noMoveLbl.Parent = page

            page.CanvasSize = UDim2.new(0,0,0,220)
        end
    end

    local function buildAimbotTab(page)
        createSectionHeader(page, "Aimbot Settings", 0, 0)
        createCheckbox(page, "Enabled", 0, 22, false, function(e)
            Settings.Aimbot.Enabled = e
            sendNotification("Aimbot", e and "On" or "Off", 2)
        end)
        createCheckbox(page, "Toggle Mode", 0, 44, false, function(e) Settings.Aimbot.Toggle = e end)
        createCheckbox(page, "Require Line of Sight", 0, 66, true, function(e) Settings.Aimbot.RequireLOS = e end)
        createCheckbox(page, "Prediction", 0, 88, true, function(e) Settings.Aimbot.Prediction = e end)
        createCheckbox(page, "Sticky Aim", 0, 110, true, function(e) Settings.Aimbot.StickyAim = e end)
        createSlider(page, "Smoothness", 0, 136, 0.05, 1, 0.15, function(v) Settings.Aimbot.Smoothness = v end)
        createSlider(page, "Prediction Amount", 0, 172, 0.05, 0.3, 0.12, function(v) Settings.Aimbot.PredictionAmount = v end)
        createDropdown(page, "Lock Part", 0, 210, {"Head","HumanoidRootPart","UpperTorso","Torso"}, "Head", function(v) Settings.Aimbot.LockPart = v end)

        createSectionHeader(page, "FOV Settings", 240, 0)
        createCheckbox(page, "Show FOV Circle", 240, 22, true, function(e) Settings.Aimbot.ShowFOV = e end)
        createSlider(page, "FOV Radius", 240, 50, 50, 400, 150, function(v) Settings.Aimbot.FOVRadius = v end)
        createSlider(page, "FOV Opacity", 240, 86, 0, 100, 50, function(v) Settings.Aimbot.FOVOpacity = v/100 end)
        createSlider(page, "Max Distance", 240, 122, 100, 1000, 500, function(v) Settings.Aimbot.MaxDistance = v end)

        createSectionHeader(page, "Combat", 0, 260)
        createCheckbox(page, "Kill Aura", 0, 282, false, function(e)
            Settings.Combat.KillAura = e
            sendNotification("Kill Aura", e and "On" or "Off", 2)
        end)
        createSlider(page, "Aura Range", 0, 304, 5, 50, 15, function(v) Settings.Combat.KillAuraRange = v end)
        createSlider(page, "Aura Speed", 0, 340, 0.05, 1, 0.15, function(v) Settings.Combat.KillAuraSpeed = v end)
        createDropdown(page, "Aura Method", 0, 376, {"Click","Touch"}, "Click", function(v) Settings.Combat.KillAuraMethod = v end)

        createCheckbox(page, "Trigger Bot", 240, 160, false, function(e)
            Settings.Combat.TriggerBot = e
            sendNotification("Trigger Bot", e and "On" or "Off", 2)
        end)
        createSlider(page, "Trigger Delay", 240, 184, 0.01, 0.5, 0.05, function(v) Settings.Combat.TriggerBotDelay = v end)
        createSlider(page, "Trigger FOV", 240, 220, 5, 200, 50, function(v) Settings.Combat.TriggerBotFOV = v end)

        page.CanvasSize = UDim2.new(0,0,0,430)
    end

    local function buildESPTab(page)
        if gameConfig.espEnabled then
            createSectionHeader(page, "ESP Properties", 0, 0)
            createCheckbox(page, "Enabled", 0, 22, false, function(e)
                Settings.ESP.Enabled = e
                sendNotification("ESP", e and "On" or "Off", 2)
            end)
            createDropdown(page, "Filter", 0, 44, {"Enemies","Team","All","All (No Team Check)"}, "Enemies", function(v)
                Settings.ESP.FilterMode = v
                sendNotification("ESP Filter", v, 2)
            end)
            createCheckbox(page, "Display Distance", 0, 84, true, function(e) Settings.ESP.DistanceEnabled = e end)
            createCheckbox(page, "Display Name", 0, 106, true, function(e) Settings.ESP.NameEnabled = e end)
            createCheckbox(page, "Display Health", 0, 128, true, function(e) Settings.ESP.HealthEnabled = e end)
            createCheckbox(page, "Display Box", 0, 150, true, function(e) Settings.ESP.BoxEnabled = e end)
            createCheckbox(page, "Chams (Wallhack Glow)", 0, 172, false, function(e)
                Settings.ESP.ChamsEnabled = e
                sendNotification("Chams", e and "On" or "Off", 2)
            end)
            createSlider(page, "Chams Fill", 0, 196, 0, 100, 50, function(v) Settings.ESP.ChamsFillTransparency = v/100 end)
            createCheckbox(page, "Rainbow Outline", 0, 232, false, function(e) Settings.ESP.RainbowOutline = e end)
            createCheckbox(page, "Rainbow Color", 0, 254, false, function(e) Settings.ESP.RainbowColor = e end)
            createCheckbox(page, "Outline", 0, 276, true, function(e) Settings.ESP.OutlineEnabled = e end)
            createDropdown(page, "Text Font", 0, 300, {"System","UI","Plex","Monospace"}, "System", function(v)
                local fontMap = {System=Enum.Font.SourceSans, UI=Enum.Font.GothamBold, Plex=Enum.Font.RobotoMono, Monospace=Enum.Font.Code}
                Settings.ESP.Font = fontMap[v] or Enum.Font.SourceSans
            end)
            createSlider(page, "Transparency", 0, 340, 0, 100, 0, function(v) Settings.ESP.Transparency = v/100 end)
            createSlider(page, "Font Size", 0, 376, 10, 24, 13, function(v) Settings.ESP.FontSize = v end)

            createSectionHeader(page, "Tracer Properties", 240, 0)
            createCheckbox(page, "Tracer Enabled", 240, 22, true, function(e) Settings.ESP.TracerEnabled = e end)
            createCheckbox(page, "Rainbow Outline", 240, 44, false, function(e) Settings.ESP.TracerRainbowOutline = e end)
            createCheckbox(page, "Rainbow Color", 240, 66, false, function(e) Settings.ESP.TracerRainbowColor = e end)
            createDropdown(page, "Position", 240, 92, {"Bottom","Center","Mouse"}, "Bottom", function(v) Settings.ESP.TracerOrigin = v end)
            createSlider(page, "Transparency", 240, 132, 0, 100, 0, function(v) Settings.ESP.TracerTransparency = v/100 end)
            createSlider(page, "Thickness", 240, 168, 1, 5, 1, function(v) Settings.ESP.TracerThickness = v end)

            createSectionHeader(page, "Skeleton ESP", 240, 208)
            createCheckbox(page, "Skeleton Enabled", 240, 230, false, function(e) Settings.ESP.SkeletonEnabled = e end)
            createSlider(page, "Skeleton Thickness", 240, 252, 1, 5, 1, function(v) Settings.ESP.SkeletonThickness = v end)

            createSectionHeader(page, "Offscreen Arrows", 0, 424)
            createCheckbox(page, "Arrows Enabled", 0, 446, false, function(e) Settings.ESP.OffscreenArrows = e end)
            createSlider(page, "Arrow Size", 0, 470, 10, 40, 20, function(v) Settings.ESP.ArrowSize = v end)
            createSlider(page, "Arrow Distance", 0, 506, 100, 1000, 500, function(v) Settings.ESP.ArrowDistance = v end)

            page.CanvasSize = UDim2.new(0,0,0,550)
        else
            local warnBox = Instance.new("Frame")
            warnBox.Size = UDim2.new(1,-16,0,100); warnBox.Position = UDim2.new(0,8,0,10)
            warnBox.BackgroundColor3 = Theme.BackgroundLight
            warnBox.BorderSizePixel = 1; warnBox.BorderColor3 = Theme.Border; warnBox.Parent = page

            local warnTitle = Instance.new("TextLabel")
            warnTitle.Size = UDim2.new(1,-20,0,18); warnTitle.Position = UDim2.new(0,10,0,10)
            warnTitle.BackgroundTransparency = 1
            warnTitle.Text = "[ Warning ] ESP not officially supported for " .. currentGameData.name
            warnTitle.TextColor3 = Color3.fromRGB(255,180,50); warnTitle.TextSize = 12
            warnTitle.Font = Enum.Font.SourceSansBold
            warnTitle.TextXAlignment = Enum.TextXAlignment.Left; warnTitle.Parent = warnBox

            local warnDesc = Instance.new("TextLabel")
            warnDesc.Size = UDim2.new(1,-20,0,16); warnDesc.Position = UDim2.new(0,10,0,32)
            warnDesc.BackgroundTransparency = 1
            warnDesc.Text = "You can force-enable it below, but it may be unstable."
            warnDesc.TextColor3 = Theme.TextSecondary; warnDesc.TextSize = 11
            warnDesc.Font = Enum.Font.SourceSans
            warnDesc.TextXAlignment = Enum.TextXAlignment.Left; warnDesc.Parent = warnBox

            local overrideBox = Instance.new("Frame")
            overrideBox.Size = UDim2.new(0,14,0,14); overrideBox.Position = UDim2.new(0,10,0,58)
            overrideBox.BackgroundColor3 = Theme.CheckboxDisabled
            overrideBox.BorderSizePixel = 1; overrideBox.BorderColor3 = Theme.BorderLight
            overrideBox.Parent = warnBox

            local overrideLbl = Instance.new("TextLabel")
            overrideLbl.Size = UDim2.new(0,280,0,16); overrideLbl.Position = UDim2.new(0,30,0,58)
            overrideLbl.BackgroundTransparency = 1; overrideLbl.Text = "Enable ESP anyway (use at your own risk)"
            overrideLbl.TextColor3 = Theme.TextPrimary; overrideLbl.TextSize = 12
            overrideLbl.Font = Enum.Font.SourceSans
            overrideLbl.TextXAlignment = Enum.TextXAlignment.Left; overrideLbl.Parent = warnBox

            local overrideBtn = Instance.new("TextButton")
            overrideBtn.Size = UDim2.new(1,0,0,40); overrideBtn.Position = UDim2.new(0,0,0,50)
            overrideBtn.BackgroundTransparency = 1; overrideBtn.Text = ""; overrideBtn.Parent = warnBox

            local overrideESPFrame = Instance.new("Frame")
            overrideESPFrame.Size = UDim2.new(1,0,1,-130); overrideESPFrame.Position = UDim2.new(0,0,0,130)
            overrideESPFrame.BackgroundTransparency = 1; overrideESPFrame.Visible = false; overrideESPFrame.Parent = page

            local espOverrideEnabled = false
            overrideBtn.MouseButton1Click:Connect(function()
                espOverrideEnabled = not espOverrideEnabled
                overrideBox.BackgroundColor3 = espOverrideEnabled and Theme.CheckboxEnabled or Theme.CheckboxDisabled
                gameConfig.espEnabled = espOverrideEnabled
                overrideESPFrame.Visible = espOverrideEnabled
                if espOverrideEnabled then
                    sendNotification("ESP Override", "Force-enabled - may be unstable", 3)
                else
                    Settings.ESP.Enabled = false
                    sendNotification("ESP Override", "Disabled", 2)
                end
            end)

            createSectionHeader(overrideESPFrame, "ESP (Override Mode)", 0, 0)
            createCheckbox(overrideESPFrame, "Enabled", 0, 22, false, function(e)
                Settings.ESP.Enabled = e; sendNotification("ESP", e and "On" or "Off", 2)
            end)
            createCheckbox(overrideESPFrame, "Display Name", 0, 44, true, function(e) Settings.ESP.NameEnabled = e end)
            createCheckbox(overrideESPFrame, "Display Health", 0, 66, true, function(e) Settings.ESP.HealthEnabled = e end)
            createCheckbox(overrideESPFrame, "Display Distance", 0, 88, true, function(e) Settings.ESP.DistanceEnabled = e end)
            createCheckbox(overrideESPFrame, "Display Box", 0, 110, true, function(e) Settings.ESP.BoxEnabled = e end)
            createCheckbox(overrideESPFrame, "Tracers", 0, 132, true, function(e) Settings.ESP.TracerEnabled = e end)
            createCheckbox(overrideESPFrame, "Rainbow Color", 0, 154, false, function(e) Settings.ESP.RainbowColor = e end)
            createDropdown(overrideESPFrame, "Tracer Position", 240, 0, {"Bottom","Center","Mouse"}, "Bottom", function(v) Settings.ESP.TracerOrigin = v end)
            createSlider(overrideESPFrame, "Thickness", 240, 40, 1, 5, 1, function(v) Settings.ESP.TracerThickness = v end)

            page.CanvasSize = UDim2.new(0,0,0,400)
        end
    end

    local function buildCrosshairTab(page)
        createSectionHeader(page, "Crosshair Settings", 0, 0)
        createCheckbox(page, "Enabled", 0, 22, false, function(e) Settings.Crosshair.Enabled = e end)
        createCheckbox(page, "Center Dot", 0, 44, false, function(e) Settings.Crosshair.CenterDot = e end)
        createCheckbox(page, "Outline", 0, 66, true, function(e) Settings.Crosshair.Outline = e end)
        createSlider(page, "Size", 0, 94, 5, 30, 10, function(v) Settings.Crosshair.Size = v end)
        createSlider(page, "Thickness", 0, 130, 1, 6, 2, function(v) Settings.Crosshair.Thickness = v end)
        createSlider(page, "Gap", 0, 166, 0, 20, 4, function(v) Settings.Crosshair.Gap = v end)
        createDropdown(page, "Style", 0, 206, {"Cross","Cross + Dot","Dot","Circle"}, "Cross", function(v) Settings.Crosshair.Style = v end)

        local previewHint = Instance.new("TextLabel")
        previewHint.Size = UDim2.new(1,-8,0,14); previewHint.Position = UDim2.new(0,0,0,250)
        previewHint.BackgroundTransparency = 1; previewHint.Text = "Preview visible in-game when Enabled is checked."
        previewHint.TextColor3 = Theme.TextDim; previewHint.TextSize = 10
        previewHint.Font = Enum.Font.SourceSans
        previewHint.TextXAlignment = Enum.TextXAlignment.Left; previewHint.Parent = page
    end

    local playerListEntries = {}
    local function buildPlayersTab(page)
        createSectionHeader(page, "Player List", 0, 0)

        local playerListScroll = Instance.new("ScrollingFrame")
        playerListScroll.Name = "PlayerListScroll"
        playerListScroll.Size = UDim2.new(1,0,1,-24); playerListScroll.Position = UDim2.new(0,0,0,22)
        playerListScroll.BackgroundTransparency = 1; playerListScroll.BorderSizePixel = 0
        playerListScroll.ScrollBarThickness = 4; playerListScroll.ScrollBarImageColor3 = Theme.AccentDark
        playerListScroll.CanvasSize = UDim2.new(0,0,0,0)
        playerListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        playerListScroll.Parent = page

        local playerListLayout = Instance.new("UIListLayout")
        playerListLayout.SortOrder = Enum.SortOrder.LayoutOrder; playerListLayout.Padding = UDim.new(0,2)
        playerListLayout.Parent = playerListScroll

        local function createPlayerEntry(target)
            if target == player then return end
            if playerListEntries[target.UserId] then return end

            local entry = Instance.new("Frame")
            entry.Size = UDim2.new(1,-4,0,42)
            entry.BackgroundColor3 = Theme.BackgroundLight
            entry.BorderSizePixel = 1; entry.BorderColor3 = Theme.Border
            entry.Parent = playerListScroll

            local nameLbl = Instance.new("TextLabel")
            nameLbl.Size = UDim2.new(0,130,0,16); nameLbl.Position = UDim2.new(0,6,0,3)
            nameLbl.BackgroundTransparency = 1
            if Settings.StreamerMode.Enabled and Settings.StreamerMode.HideNames then
                nameLbl.Text = Settings.StreamerMode.FakeName .. " #" .. tostring(target.UserId):sub(-3)
            else
                nameLbl.Text = target.DisplayName .. " (@" .. target.Name .. ")"
            end
            nameLbl.TextColor3 = Theme.TextPrimary; nameLbl.TextSize = 11
            nameLbl.Font = Enum.Font.SourceSansBold
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            nameLbl.TextTruncate = Enum.TextTruncate.AtEnd; nameLbl.Parent = entry

            local infoLbl = Instance.new("TextLabel")
            infoLbl.Size = UDim2.new(0,200,0,14); infoLbl.Position = UDim2.new(0,6,0,22)
            infoLbl.BackgroundTransparency = 1; infoLbl.Text = "..."
            infoLbl.TextColor3 = Theme.TextSecondary; infoLbl.TextSize = 10
            infoLbl.Font = Enum.Font.SourceSans
            infoLbl.TextXAlignment = Enum.TextXAlignment.Left; infoLbl.Parent = entry

            local spectateBtn = Instance.new("TextButton")
            spectateBtn.Size = UDim2.new(0,55,0,18); spectateBtn.Position = UDim2.new(1,-180,0,12)
            spectateBtn.BackgroundColor3 = Theme.SliderBackground
            spectateBtn.BorderSizePixel = 1; spectateBtn.BorderColor3 = Theme.Border
            spectateBtn.Text = "Spectate"; spectateBtn.TextColor3 = Theme.AccentBright
            spectateBtn.TextSize = 10; spectateBtn.Font = Enum.Font.SourceSans; spectateBtn.Parent = entry

            local isSpectating = false
            spectateBtn.MouseButton1Click:Connect(function()
                local targetChar = target.Character
                if targetChar then
                    local h = targetChar:FindFirstChild("Humanoid")
                    if h then
                        if isSpectating then
                            local myChar = player.Character
                            if myChar then
                                local mh = myChar:FindFirstChild("Humanoid")
                                if mh then Workspace.CurrentCamera.CameraSubject = mh end
                            end
                            spectateBtn.Text = "Spectate"; spectateBtn.TextColor3 = Theme.AccentBright
                            isSpectating = false; sendNotification("Spectate", "Stopped", 2)
                        else
                            Workspace.CurrentCamera.CameraSubject = h
                            spectateBtn.Text = "Stop"; spectateBtn.TextColor3 = Color3.fromRGB(255,100,100)
                            isSpectating = true; sendNotification("Spectate", "Watching " .. target.DisplayName, 2)
                        end
                    end
                end
            end)

            local copyBtn = Instance.new("TextButton")
            copyBtn.Size = UDim2.new(0,50,0,18); copyBtn.Position = UDim2.new(1,-120,0,12)
            copyBtn.BackgroundColor3 = Theme.SliderBackground
            copyBtn.BorderSizePixel = 1; copyBtn.BorderColor3 = Theme.Border
            copyBtn.Text = "Copy"; copyBtn.TextColor3 = Theme.TextPrimary
            copyBtn.TextSize = 10; copyBtn.Font = Enum.Font.SourceSans; copyBtn.Parent = entry
            copyBtn.MouseButton1Click:Connect(function()
                pcall(function() setclipboard(target.Name) end)
                copyBtn.Text = "Done!"; sendNotification("Copied", target.Name, 2)
                task.delay(1.5, function() if copyBtn and copyBtn.Parent then copyBtn.Text = "Copy" end end)
            end)

            local teamDot = Instance.new("Frame")
            teamDot.Size = UDim2.new(0,8,0,8); teamDot.Position = UDim2.new(1,-60,0,17)
            teamDot.BackgroundColor3 = target.Team and target.TeamColor.Color or Theme.TextDim
            teamDot.BorderSizePixel = 0; teamDot.Parent = entry
            Instance.new("UICorner", teamDot).CornerRadius = UDim.new(1,0)

            local healthBarBg = Instance.new("Frame")
            healthBarBg.Size = UDim2.new(0,40,0,6); healthBarBg.Position = UDim2.new(1,-50,0,18)
            healthBarBg.BackgroundColor3 = Color3.fromRGB(40,40,50); healthBarBg.BorderSizePixel = 0
            healthBarBg.Parent = entry

            local healthBarFill = Instance.new("Frame")
            healthBarFill.Size = UDim2.new(1,0,1,0)
            healthBarFill.BackgroundColor3 = Color3.fromRGB(80,255,80); healthBarFill.BorderSizePixel = 0
            healthBarFill.Parent = healthBarBg

            playerListEntries[target.UserId] = {entry=entry, infoLabel=infoLbl, healthBarFill=healthBarFill, teamDot=teamDot}
        end

        local function removePlayerEntry(target)
            local data = playerListEntries[target.UserId]
            if data then data.entry:Destroy(); playerListEntries[target.UserId] = nil end
        end

        for _, p in ipairs(Players:GetPlayers()) do createPlayerEntry(p) end

        local plrAddConn = Players.PlayerAdded:Connect(function(p)
            createPlayerEntry(p)
            sendNotification("Player Joined", p.DisplayName, 2)
        end)
        table.insert(allConnections, plrAddConn)

        local plrRemConn = Players.PlayerRemoving:Connect(function(p)
            removePlayerEntry(p)
            sendNotification("Player Left", p.DisplayName, 2)
        end)
        table.insert(allConnections, plrRemConn)

        local playerListUpdateConn = RunService.Heartbeat:Connect(function()
            if isUnloading or _G.BinxixUnloaded then return end
            if activeTab ~= "Players" then return end
            local myChar = player.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            for userId, data in pairs(playerListEntries) do
                local target = Players:GetPlayerByUserId(userId)
                if target then
                    local targetChar = target.Character
                    if targetChar then
                        local h = targetChar:FindFirstChild("Humanoid")
                        local tHRP = targetChar:FindFirstChild("HumanoidRootPart")
                        local healthText = "Dead"; local distText = "?"; local healthPct = 0
                        if h and h.Health > 0 then
                            healthPct = h.Health / h.MaxHealth
                            healthText = math.floor(h.Health) .. "/" .. math.floor(h.MaxHealth) .. " HP"
                        end
                        if myHRP and tHRP then
                            distText = math.floor((myHRP.Position - tHRP.Position).Magnitude) .. "m"
                        end
                        data.infoLabel.Text = healthText .. "  |  " .. distText
                        data.healthBarFill.Size = UDim2.new(math.clamp(healthPct,0,1),0,1,0)
                        data.healthBarFill.BackgroundColor3 = healthPct > 0.6 and Color3.fromRGB(80,255,80)
                            or healthPct > 0.3 and Color3.fromRGB(255,200,50) or Color3.fromRGB(255,60,60)
                        data.teamDot.BackgroundColor3 = target.Team and target.TeamColor.Color or Theme.TextDim
                    else
                        data.infoLabel.Text = "Loading..."
                        data.healthBarFill.Size = UDim2.new(0,0,1,0)
                    end
                end
            end
        end)
        table.insert(allConnections, playerListUpdateConn)
    end

    local chatSpyEnabled = false
    local chatSpyLog = {}
    local MAX_CHAT_LOG = 100

    local function buildReportTab(page)
        createSectionHeader(page, "Chat Spy", 0, 0)
        createCheckbox(page, "Enable Chat Spy", 0, 22, false, function(e)
            chatSpyEnabled = e
            sendNotification("Chat Spy", e and "Listening to all chats" or "Disabled", 2)
        end)
        local chatSpyInfoLbl = Instance.new("TextLabel")
        chatSpyInfoLbl.Size = UDim2.new(1,-8,0,14); chatSpyInfoLbl.Position = UDim2.new(0,0,0,44)
        chatSpyInfoLbl.BackgroundTransparency = 1
        chatSpyInfoLbl.Text = "Logs all chat messages. Prints to console (F9)."
        chatSpyInfoLbl.TextColor3 = Theme.TextDim; chatSpyInfoLbl.TextSize = 10
        chatSpyInfoLbl.Font = Enum.Font.SourceSans
        chatSpyInfoLbl.TextXAlignment = Enum.TextXAlignment.Left; chatSpyInfoLbl.Parent = page

        createSectionHeader(page, "Suggestions", 0, 68)
        local suggestInfoLbl = Instance.new("TextLabel")
        suggestInfoLbl.Size = UDim2.new(1,-8,0,14); suggestInfoLbl.Position = UDim2.new(0,0,0,88)
        suggestInfoLbl.BackgroundTransparency = 1; suggestInfoLbl.Text = "Have an idea for a new feature? Let us know."
        suggestInfoLbl.TextColor3 = Theme.TextDim; suggestInfoLbl.TextSize = 10
        suggestInfoLbl.Font = Enum.Font.SourceSans
        suggestInfoLbl.TextXAlignment = Enum.TextXAlignment.Left; suggestInfoLbl.Parent = page

        local suggestInputBox = Instance.new("TextBox")
        suggestInputBox.Size = UDim2.new(1,-8,0,60); suggestInputBox.Position = UDim2.new(0,0,0,106)
        suggestInputBox.BackgroundColor3 = Theme.BackgroundDark
        suggestInputBox.BorderSizePixel = 1; suggestInputBox.BorderColor3 = Theme.Border
        suggestInputBox.Text = ""; suggestInputBox.PlaceholderText = "Type your suggestion here..."
        suggestInputBox.PlaceholderColor3 = Theme.TextDim; suggestInputBox.TextColor3 = Theme.TextPrimary
        suggestInputBox.TextSize = 11; suggestInputBox.Font = Enum.Font.SourceSans
        suggestInputBox.TextXAlignment = Enum.TextXAlignment.Left
        suggestInputBox.TextYAlignment = Enum.TextYAlignment.Top
        suggestInputBox.TextWrapped = true; suggestInputBox.MultiLine = true
        suggestInputBox.ClearTextOnFocus = false; suggestInputBox.Parent = page

        local sendSuggestBtn = Instance.new("TextButton")
        sendSuggestBtn.Size = UDim2.new(0,130,0,24); sendSuggestBtn.Position = UDim2.new(0,0,0,172)
        sendSuggestBtn.BackgroundColor3 = Color3.fromRGB(40,100,60)
        sendSuggestBtn.BorderSizePixel = 1; sendSuggestBtn.BorderColor3 = Theme.Border
        sendSuggestBtn.Text = "Send Suggestion"; sendSuggestBtn.TextColor3 = Color3.fromRGB(120,255,160)
        sendSuggestBtn.TextSize = 12; sendSuggestBtn.Font = Enum.Font.SourceSansBold
        sendSuggestBtn.Parent = page
        sendSuggestBtn.MouseEnter:Connect(function() sendSuggestBtn.BackgroundColor3 = Color3.fromRGB(50,130,75) end)
        sendSuggestBtn.MouseLeave:Connect(function() sendSuggestBtn.BackgroundColor3 = Color3.fromRGB(40,100,60) end)

        local function getExecutorName()
            local name = "Unknown"
            pcall(function()
                if identifyexecutor then name = identifyexecutor()
                elseif getexecutorname then name = getexecutorname() end
            end)
            return name
        end

        local suggestCooldown = false
        sendSuggestBtn.MouseButton1Click:Connect(function()
            if suggestCooldown then sendNotification("Suggestion", "Please wait before sending another", 2); return end
            local suggestion = suggestInputBox.Text
            if suggestion == "" or #suggestion < 5 then sendNotification("Suggestion", "Write at least 5 characters", 2); return end
            suggestCooldown = true
            sendSuggestBtn.Text = "Sending..."; sendSuggestBtn.TextColor3 = Color3.fromRGB(255,200,80)
            local executorName = getExecutorName()
            local payload = {
                embeds = {{
                    title = "Suggestion - Binxix Hub V6",
                    color = 3066993,
                    fields = {
                        {name = "Suggestion", value = suggestion, inline = false},
                        {name = "Game", value = currentGameData.name .. " (" .. tostring(currentPlaceId) .. ")", inline = true},
                        {name = "Executor", value = executorName, inline = true},
                    },
                    footer = {text = "Binxix Hub V6 Suggestion Box"},
                    timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
                }}
            }
            local success = pcall(function()
                local jsonPayload = HttpService:JSONEncode(payload)
                local httpRequest = (syn and syn.request) or (http and http.request) or http_request or request or fluxus and fluxus.request
                if httpRequest then
                    httpRequest({Url="https://discord.com/api/webhooks/1469598356975124531/2gW0s_svmwzMFNPidKhyOztLVKPVPI3V2g1OT0VN3ownM6Fpzu1UZ1qFl33ojmnfNGbr", Method="POST", Headers={["Content-Type"]="application/json"}, Body=jsonPayload})
                else error("No HTTP function") end
            end)
            if success then
                sendSuggestBtn.Text = "Sent!"; sendSuggestBtn.TextColor3 = Color3.fromRGB(80,255,120)
                suggestInputBox.Text = ""; sendNotification("Suggestion", "Sent - thank you!", 3)
            else
                sendSuggestBtn.Text = "Failed"; sendSuggestBtn.TextColor3 = Color3.fromRGB(255,80,80)
                sendNotification("Suggestion", "Could not send", 3)
            end
            task.delay(5, function()
                suggestCooldown = false
                if sendSuggestBtn and sendSuggestBtn.Parent then
                    sendSuggestBtn.Text = "Send Suggestion"; sendSuggestBtn.TextColor3 = Color3.fromRGB(120,255,160)
                end
            end)
        end)

        createSectionHeader(page, "Bug Report", 0, 210)

        local disclaimerLbl = Instance.new("TextLabel")
        disclaimerLbl.Size = UDim2.new(1,-8,0,28); disclaimerLbl.Position = UDim2.new(0,0,0,230)
        disclaimerLbl.BackgroundColor3 = Color3.fromRGB(40,35,20)
        disclaimerLbl.BorderSizePixel = 1; disclaimerLbl.BorderColor3 = Color3.fromRGB(80,70,30)
        disclaimerLbl.Text = "  This will send: your executor name, game name, and bug description."
        disclaimerLbl.TextColor3 = Color3.fromRGB(255,200,80); disclaimerLbl.TextSize = 10
        disclaimerLbl.Font = Enum.Font.SourceSans
        disclaimerLbl.TextXAlignment = Enum.TextXAlignment.Left; disclaimerLbl.Parent = page

        local bugInputBox = Instance.new("TextBox")
        bugInputBox.Size = UDim2.new(1,-8,0,60); bugInputBox.Position = UDim2.new(0,0,0,262)
        bugInputBox.BackgroundColor3 = Theme.BackgroundDark
        bugInputBox.BorderSizePixel = 1; bugInputBox.BorderColor3 = Theme.Border
        bugInputBox.Text = ""; bugInputBox.PlaceholderText = "Describe the bug..."
        bugInputBox.PlaceholderColor3 = Theme.TextDim; bugInputBox.TextColor3 = Theme.TextPrimary
        bugInputBox.TextSize = 11; bugInputBox.Font = Enum.Font.SourceSans
        bugInputBox.TextXAlignment = Enum.TextXAlignment.Left
        bugInputBox.TextYAlignment = Enum.TextYAlignment.Top
        bugInputBox.TextWrapped = true; bugInputBox.MultiLine = true
        bugInputBox.ClearTextOnFocus = false; bugInputBox.Parent = page

        local sendReportBtn = Instance.new("TextButton")
        sendReportBtn.Size = UDim2.new(0,120,0,24); sendReportBtn.Position = UDim2.new(0,0,0,328)
        sendReportBtn.BackgroundColor3 = Theme.AccentDark
        sendReportBtn.BorderSizePixel = 1; sendReportBtn.BorderColor3 = Theme.Border
        sendReportBtn.Text = "Send Report"; sendReportBtn.TextColor3 = Theme.TextPrimary
        sendReportBtn.TextSize = 12; sendReportBtn.Font = Enum.Font.SourceSansBold; sendReportBtn.Parent = page
        sendReportBtn.MouseEnter:Connect(function() sendReportBtn.BackgroundColor3 = Theme.AccentBright end)
        sendReportBtn.MouseLeave:Connect(function() sendReportBtn.BackgroundColor3 = Theme.AccentDark end)

        local reportCooldown = false
        sendReportBtn.MouseButton1Click:Connect(function()
            if reportCooldown then sendNotification("Report", "Please wait before sending another", 2); return end
            local description = bugInputBox.Text
            if description == "" or #description < 5 then sendNotification("Report", "Please describe the bug (5+ chars)", 2); return end
            reportCooldown = true
            sendReportBtn.Text = "Sending..."; sendReportBtn.TextColor3 = Color3.fromRGB(255,200,80)
            local executorName = getExecutorName()
            local payload = {
                embeds = {{
                    title = "Bug Report - Binxix Hub V6",
                    color = 11163135,
                    fields = {
                        {name = "Executor", value = executorName, inline = true},
                        {name = "Game", value = currentGameData.name .. " (" .. tostring(currentPlaceId) .. ")", inline = true},
                        {name = "Description", value = description, inline = false},
                    },
                    footer = {text = "Binxix Hub V6 Bug Report"},
                    timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
                }}
            }
            local success = pcall(function()
                local jsonPayload = HttpService:JSONEncode(payload)
                local httpRequest = (syn and syn.request) or (http and http.request) or http_request or request or fluxus and fluxus.request
                if httpRequest then
                    httpRequest({Url="https://discord.com/api/webhooks/1466757772145070080/-3-YwfjgH-yEl8yeS_AmuW4E3jDL2aF4GrQdnl0woOtRd_mTF6J4BezIMNlTvvnieSaP", Method="POST", Headers={["Content-Type"]="application/json"}, Body=jsonPayload})
                else error("No HTTP function") end
            end)
            if success then
                sendReportBtn.Text = "Sent!"; sendReportBtn.TextColor3 = Color3.fromRGB(80,255,120)
                bugInputBox.Text = ""; sendNotification("Report", "Bug report sent - thank you!", 3)
            else
                sendReportBtn.Text = "Failed"; sendReportBtn.TextColor3 = Color3.fromRGB(255,80,80)
                sendNotification("Report", "Could not send", 3)
            end
            task.delay(5, function()
                reportCooldown = false
                if sendReportBtn and sendReportBtn.Parent then
                    sendReportBtn.Text = "Send Report"; sendReportBtn.TextColor3 = Theme.TextPrimary
                end
            end)
        end)

        local reportInfoLbl = Instance.new("TextLabel")
        reportInfoLbl.Size = UDim2.new(1,-8,0,20); reportInfoLbl.Position = UDim2.new(0,0,0,358)
        reportInfoLbl.BackgroundTransparency = 1
        reportInfoLbl.Text = "Be descriptive so we can fix the issue faster."
        reportInfoLbl.TextColor3 = Color3.fromRGB(255,200,80); reportInfoLbl.TextSize = 11
        reportInfoLbl.Font = Enum.Font.SourceSansBold
        reportInfoLbl.TextXAlignment = Enum.TextXAlignment.Left; reportInfoLbl.Parent = page

        createSectionHeader(page, "Community", 0, 390)
        local discordBtn = Instance.new("TextButton")
        discordBtn.Size = UDim2.new(0,160,0,26); discordBtn.Position = UDim2.new(0,0,0,410)
        discordBtn.BackgroundColor3 = Color3.fromRGB(88,101,242)
        discordBtn.BorderSizePixel = 1; discordBtn.BorderColor3 = Color3.fromRGB(70,80,200)
        discordBtn.Text = "Join Discord Server"; discordBtn.TextColor3 = Color3.fromRGB(255,255,255)
        discordBtn.TextSize = 12; discordBtn.Font = Enum.Font.SourceSansBold; discordBtn.Parent = page
        discordBtn.MouseEnter:Connect(function() discordBtn.BackgroundColor3 = Color3.fromRGB(110,120,255) end)
        discordBtn.MouseLeave:Connect(function() discordBtn.BackgroundColor3 = Color3.fromRGB(88,101,242) end)
        discordBtn.MouseButton1Click:Connect(function()
            pcall(function()
                if setclipboard then
                    setclipboard("https://discord.gg/S4nPV2Rx7F")
                    sendNotification("Discord", "Invite link copied to clipboard", 3)
                end
            end)
        end)

        page.CanvasSize = UDim2.new(0,0,0,450)
    end

    local currentToggleKey = Enum.KeyCode.RightControl
    local waitingForKey = false

    local function buildSettingsTab(page)
        createSectionHeader(page, "GUI Settings", 0, 0)
        createDropdown(page, "Theme", 0, 22, {"Purple","Blue","Red","Green","Rose"}, "Purple", function(v)
            applyTheme(v); sendNotification("Theme", "Switched to " .. v, 2)
        end)

        local keybindLbl = Instance.new("TextLabel")
        keybindLbl.Size = UDim2.new(0,100,0,20); keybindLbl.Position = UDim2.new(0,0,0,62)
        keybindLbl.BackgroundTransparency = 1; keybindLbl.Text = "Toggle Key:"
        keybindLbl.TextColor3 = Theme.TextSecondary; keybindLbl.TextSize = 11
        keybindLbl.Font = Enum.Font.SourceSans
        keybindLbl.TextXAlignment = Enum.TextXAlignment.Left; keybindLbl.Parent = page

        local keybindBtn = Instance.new("TextButton")
        keybindBtn.Size = UDim2.new(0,120,0,22); keybindBtn.Position = UDim2.new(0,100,0,62)
        keybindBtn.BackgroundColor3 = Theme.SliderBackground
        keybindBtn.BorderSizePixel = 1; keybindBtn.BorderColor3 = Theme.Border
        keybindBtn.Text = "RightControl"; keybindBtn.TextColor3 = Theme.AccentBright
        keybindBtn.TextSize = 11; keybindBtn.Font = Enum.Font.SourceSansBold; keybindBtn.Parent = page

        keybindBtn.MouseEnter:Connect(function()
            if not waitingForKey then keybindBtn.BackgroundColor3 = Theme.AccentDark end
        end)
        keybindBtn.MouseLeave:Connect(function()
            if not waitingForKey then keybindBtn.BackgroundColor3 = Theme.SliderBackground end
        end)
        keybindBtn.MouseButton1Click:Connect(function()
            waitingForKey = true; keybindBtn.Text = "Press a key..."
            keybindBtn.TextColor3 = Color3.fromRGB(255,255,100)
            keybindBtn.BackgroundColor3 = Color3.fromRGB(60,60,40)
        end)
        local kbConn = UserInputService.InputBegan:Connect(function(input, gp)
            if waitingForKey and input.UserInputType == Enum.UserInputType.Keyboard then
                currentToggleKey = input.KeyCode; keybindBtn.Text = input.KeyCode.Name
                keybindBtn.TextColor3 = Theme.AccentBright; keybindBtn.BackgroundColor3 = Theme.SliderBackground
                waitingForKey = false
            end
        end)
        table.insert(allConnections, kbConn)

        createSectionHeader(page, "Script Info", 0, 98)
        local infoLbl = Instance.new("TextLabel")
        infoLbl.Size = UDim2.new(0,300,0,80); infoLbl.Position = UDim2.new(0,0,0,118)
        infoLbl.BackgroundTransparency = 1
        infoLbl.Text = "Binxix Hub V6.5\nAirHub V2 Style Edition\nGun Mods / Chat Spy / Streamer Mode / Profiles\n\nGame: " .. currentGameData.name .. "\nPlace ID: " .. tostring(currentPlaceId)
        infoLbl.TextColor3 = Theme.TextSecondary; infoLbl.TextSize = 11
        infoLbl.Font = Enum.Font.SourceSans
        infoLbl.TextXAlignment = Enum.TextXAlignment.Left
        infoLbl.TextYAlignment = Enum.TextYAlignment.Top; infoLbl.Parent = page

        local unloadBtn = Instance.new("TextButton")
        unloadBtn.Size = UDim2.new(0,120,0,26); unloadBtn.Position = UDim2.new(0,0,0,210)
        unloadBtn.BackgroundColor3 = Color3.fromRGB(180,50,50)
        unloadBtn.BorderSizePixel = 1; unloadBtn.BorderColor3 = Theme.Border
        unloadBtn.Text = "Unload Script"; unloadBtn.TextColor3 = Theme.TextPrimary
        unloadBtn.TextSize = 12; unloadBtn.Font = Enum.Font.SourceSans; unloadBtn.Parent = page
        unloadBtn.MouseButton1Click:Connect(function()
            isUnloading = true; _G.BinxixUnloaded = true
            Settings.Combat.KillAura = false; Settings.Combat.TriggerBot = false
            Settings.Misc.ChatSpammer = false; Settings.Movement.SpeedEnabled = false
            pcall(function()
                local char = player.Character
                if char then
                    local h = char:FindFirstChild("Humanoid"); if h then h.WalkSpeed = 16 end
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then local bv = hrp:FindFirstChild("BinxixSpeedVelocity"); if bv then bv:Destroy() end end
                end
            end)
            Settings.Combat.FastReload = false; Settings.Combat.FastFireRate = false
            Settings.Combat.AlwaysAuto = false; Settings.Combat.NoSpread = false; Settings.Combat.NoRecoil = false
            pcall(function()
                if gunModOriginalValues then
                    for _, entries in pairs(gunModOriginalValues) do
                        for obj, originalVal in pairs(entries) do
                            pcall(function() obj.Value = originalVal end)
                        end
                    end
                end
            end)
            stopAutoTPLoop()
            for _, conn in ipairs(allConnections) do pcall(function() conn:Disconnect() end) end
            screenGui:Destroy()
        end)

        createSectionHeader(page, "Other Scripts", 0, 250)
        local function createScriptButton(text, posY, url)
            local btn = createButton(page, text, 0, posY, 200, 22, function()
                btn.Text = "Loading..."
                task.spawn(function()
                    local success = pcall(function() loadstring(game:HttpGet(url))() end)
                    btn.Text = success and "Loaded!" or "Failed"
                    task.wait(2); btn.Text = text
                end)
            end)
        end
        createScriptButton("Infinite Yield", 270, "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
        createScriptButton("Nameless Admin", 296, "https://raw.githubusercontent.com/ltseverydayyou/Nameless-Admin/main/Source.lua")

        createSectionHeader(page, "Streamer Mode", 240, 0)
        createCheckbox(page, "Streamer Mode", 240, 22, false, function(e)
            Settings.StreamerMode.Enabled = e
            sendNotification("Streamer Mode", e and "On - names hidden" or "Off", 2)
        end)
        createCheckbox(page, "Hide Player Names", 240, 44, true, function(e) Settings.StreamerMode.HideNames = e end)
        createCheckbox(page, "Hide Chat (Chat Spy)", 240, 66, false, function(e) Settings.StreamerMode.HideChat = e end)
        createCheckbox(page, "Hide Notifications", 240, 88, false, function(e) Settings.StreamerMode.HideNotifications = e end)

        local fakeNameLbl = Instance.new("TextLabel")
        fakeNameLbl.Size = UDim2.new(0,70,0,16); fakeNameLbl.Position = UDim2.new(0,240,0,110)
        fakeNameLbl.BackgroundTransparency = 1; fakeNameLbl.Text = "Fake Name:"
        fakeNameLbl.TextColor3 = Theme.TextSecondary; fakeNameLbl.TextSize = 11
        fakeNameLbl.Font = Enum.Font.SourceSans
        fakeNameLbl.TextXAlignment = Enum.TextXAlignment.Left; fakeNameLbl.Parent = page

        local fakeNameBox = Instance.new("TextBox")
        fakeNameBox.Size = UDim2.new(0,120,0,18); fakeNameBox.Position = UDim2.new(0,315,0,109)
        fakeNameBox.BackgroundColor3 = Theme.SliderBackground
        fakeNameBox.BorderSizePixel = 1; fakeNameBox.BorderColor3 = Theme.Border
        fakeNameBox.Text = "Player"; fakeNameBox.TextColor3 = Theme.TextPrimary
        fakeNameBox.TextSize = 11; fakeNameBox.Font = Enum.Font.SourceSans
        fakeNameBox.ClearTextOnFocus = false; fakeNameBox.Parent = page
        fakeNameBox.FocusLost:Connect(function()
            local name = fakeNameBox.Text
            if name == "" then name = "Player" end
            Settings.StreamerMode.FakeName = name
        end)

        createSectionHeader(page, "Profiles", 240, 136)

        local profileNameLbl = Instance.new("TextLabel")
        profileNameLbl.Size = UDim2.new(0,80,0,16); profileNameLbl.Position = UDim2.new(0,240,0,158)
        profileNameLbl.BackgroundTransparency = 1; profileNameLbl.Text = "Profile Name:"
        profileNameLbl.TextColor3 = Theme.TextSecondary; profileNameLbl.TextSize = 11
        profileNameLbl.Font = Enum.Font.SourceSans
        profileNameLbl.TextXAlignment = Enum.TextXAlignment.Left; profileNameLbl.Parent = page

        local profileNameBox = Instance.new("TextBox")
        profileNameBox.Size = UDim2.new(0,110,0,18); profileNameBox.Position = UDim2.new(0,325,0,157)
        profileNameBox.BackgroundColor3 = Theme.SliderBackground
        profileNameBox.BorderSizePixel = 1; profileNameBox.BorderColor3 = Theme.Border
        profileNameBox.Text = "Default"; profileNameBox.TextColor3 = Theme.AccentBright
        profileNameBox.TextSize = 11; profileNameBox.Font = Enum.Font.SourceSansBold
        profileNameBox.ClearTextOnFocus = false; profileNameBox.Parent = page

        local currentProfileLbl = Instance.new("TextLabel")
        currentProfileLbl.Size = UDim2.new(0,200,0,14); currentProfileLbl.Position = UDim2.new(0,240,0,178)
        currentProfileLbl.BackgroundTransparency = 1; currentProfileLbl.Text = "Active: " .. currentProfileName
        currentProfileLbl.TextColor3 = Theme.TextDim; currentProfileLbl.TextSize = 10
        currentProfileLbl.Font = Enum.Font.SourceSans
        currentProfileLbl.TextXAlignment = Enum.TextXAlignment.Left; currentProfileLbl.Parent = page

        local saveProfileBtn = Instance.new("TextButton")
        saveProfileBtn.Size = UDim2.new(0,58,0,22); saveProfileBtn.Position = UDim2.new(0,240,0,196)
        saveProfileBtn.BackgroundColor3 = Theme.SliderBackground
        saveProfileBtn.BorderSizePixel = 1; saveProfileBtn.BorderColor3 = Theme.Border
        saveProfileBtn.Text = "Save"; saveProfileBtn.TextColor3 = Color3.fromRGB(80,255,120)
        saveProfileBtn.TextSize = 11; saveProfileBtn.Font = Enum.Font.SourceSansBold; saveProfileBtn.Parent = page
        saveProfileBtn.MouseEnter:Connect(function() saveProfileBtn.BackgroundColor3 = Theme.AccentDark end)
        saveProfileBtn.MouseLeave:Connect(function() saveProfileBtn.BackgroundColor3 = Theme.SliderBackground end)
        saveProfileBtn.MouseButton1Click:Connect(function()
            local name = profileNameBox.Text == "" and "Default" or profileNameBox.Text
            local success = saveProfile(name)
            saveProfileBtn.Text = success and "Saved!" or "Error"
            if success then currentProfileName = name; currentProfileLbl.Text = "Active: " .. name; sendNotification("Profile", "Saved: " .. name, 2)
            else sendNotification("Profile", "Save failed", 3) end
            task.delay(1.5, function() if saveProfileBtn and saveProfileBtn.Parent then saveProfileBtn.Text = "Save" end end)
        end)

        local loadProfileBtn = Instance.new("TextButton")
        loadProfileBtn.Size = UDim2.new(0,58,0,22); loadProfileBtn.Position = UDim2.new(0,302,0,196)
        loadProfileBtn.BackgroundColor3 = Theme.SliderBackground
        loadProfileBtn.BorderSizePixel = 1; loadProfileBtn.BorderColor3 = Theme.Border
        loadProfileBtn.Text = "Load"; loadProfileBtn.TextColor3 = Theme.AccentBright
        loadProfileBtn.TextSize = 11; loadProfileBtn.Font = Enum.Font.SourceSansBold; loadProfileBtn.Parent = page
        loadProfileBtn.MouseEnter:Connect(function() loadProfileBtn.BackgroundColor3 = Theme.AccentDark end)
        loadProfileBtn.MouseLeave:Connect(function() loadProfileBtn.BackgroundColor3 = Theme.SliderBackground end)
        loadProfileBtn.MouseButton1Click:Connect(function()
            local name = profileNameBox.Text == "" and "Default" or profileNameBox.Text
            local success = loadProfile(name)
            loadProfileBtn.Text = success and "Done!" or "Error"
            if success then currentProfileLbl.Text = "Active: " .. name; sendNotification("Profile", "Loaded: " .. name, 3)
            else sendNotification("Profile", "Load failed", 3) end
            task.delay(1.5, function() if loadProfileBtn and loadProfileBtn.Parent then loadProfileBtn.Text = "Load" end end)
        end)

        local deleteProfileBtn = Instance.new("TextButton")
        deleteProfileBtn.Size = UDim2.new(0,58,0,22); deleteProfileBtn.Position = UDim2.new(0,364,0,196)
        deleteProfileBtn.BackgroundColor3 = Theme.SliderBackground
        deleteProfileBtn.BorderSizePixel = 1; deleteProfileBtn.BorderColor3 = Theme.Border
        deleteProfileBtn.Text = "Delete"; deleteProfileBtn.TextColor3 = Color3.fromRGB(255,80,80)
        deleteProfileBtn.TextSize = 11; deleteProfileBtn.Font = Enum.Font.SourceSansBold; deleteProfileBtn.Parent = page
        deleteProfileBtn.MouseEnter:Connect(function() deleteProfileBtn.BackgroundColor3 = Color3.fromRGB(100,30,30) end)
        deleteProfileBtn.MouseLeave:Connect(function() deleteProfileBtn.BackgroundColor3 = Theme.SliderBackground end)
        deleteProfileBtn.MouseButton1Click:Connect(function()
            local name = profileNameBox.Text == "" and "Default" or profileNameBox.Text
            deleteProfile(name); deleteProfileBtn.Text = "Gone!"
            sendNotification("Profile", "Deleted: " .. name, 2)
            task.delay(1.5, function() if deleteProfileBtn and deleteProfileBtn.Parent then deleteProfileBtn.Text = "Delete" end end)
        end)

        local profileListLbl = Instance.new("TextLabel")
        profileListLbl.Size = UDim2.new(0,200,0,14); profileListLbl.Position = UDim2.new(0,240,0,222)
        profileListLbl.BackgroundTransparency = 1; profileListLbl.Text = "Saved: " .. table.concat(listProfiles(),", ")
        profileListLbl.TextColor3 = Theme.TextDim; profileListLbl.TextSize = 10
        profileListLbl.Font = Enum.Font.SourceSans
        profileListLbl.TextXAlignment = Enum.TextXAlignment.Left
        profileListLbl.TextTruncate = Enum.TextTruncate.AtEnd; profileListLbl.Parent = page

        local refreshBtn = Instance.new("TextButton")
        refreshBtn.Size = UDim2.new(0,55,0,16); refreshBtn.Position = UDim2.new(0,240,0,240)
        refreshBtn.BackgroundColor3 = Theme.SliderBackground
        refreshBtn.BorderSizePixel = 1; refreshBtn.BorderColor3 = Theme.Border
        refreshBtn.Text = "Refresh"; refreshBtn.TextColor3 = Theme.TextSecondary
        refreshBtn.TextSize = 10; refreshBtn.Font = Enum.Font.SourceSans; refreshBtn.Parent = page
        refreshBtn.MouseButton1Click:Connect(function()
            profileListLbl.Text = "Saved: " .. table.concat(listProfiles(),", ")
        end)

        page.CanvasSize = UDim2.new(0,0,0,330)
    end

    -- ======================================================
    -- CREATE PAGES (scrolling frames) - shell only
    -- ======================================================
    local tabBuilders = {
        General = buildGeneralTab,
        Aimbot = buildAimbotTab,
        ESP = buildESPTab,
        Crosshair = buildCrosshairTab,
        Players = buildPlayersTab,
        Report = buildReportTab,
        Settings = buildSettingsTab,
    }

    for _, tabName in ipairs(tabs) do
        local useScrolling = tabName ~= "Crosshair" and tabName ~= "Players"
        local page
        if useScrolling then
            page = Instance.new("ScrollingFrame")
            page.ScrollBarThickness = 4
            page.ScrollBarImageColor3 = Theme.AccentDark
            page.CanvasSize = UDim2.new(0,0,0,400)
            page.ScrollingDirection = Enum.ScrollingDirection.Y
        else
            page = Instance.new("Frame")
        end
        page.Name = tabName .. "Page"
        page.Size = UDim2.new(1,0,1,0)
        page.BackgroundTransparency = 1
        page.Visible = tabName == "General"
        page.BorderSizePixel = 0
        page.Parent = contentArea
        tabPages[tabName] = page
    end

    buildGeneralTab(tabPages["General"])
    tabBuilt["General"] = true

    local function switchTab(tabName)
        if isUnloading or _G.BinxixUnloaded then return end
        activeTab = tabName

        if not tabBuilt[tabName] and tabBuilders[tabName] then
            tabBuilders[tabName](tabPages[tabName])
            tabBuilt[tabName] = true
        end

        for name, btn in pairs(tabButtons) do
            btn.TextColor3 = name == tabName and Theme.TabActive or Theme.TabInactive
        end

        local tabIndex = table.find(tabs, tabName)
        if tabIndex then
            TweenService:Create(tabIndicator, TweenInfo.new(0.15), {
                Position = UDim2.new(0,(tabIndex-1)*tabWidth+6,1,-2)
            }):Play()
        end

        for name, page in pairs(tabPages) do
            page.Visible = name == tabName
        end
    end

    for _, tabName in ipairs(tabs) do
        tabButtons[tabName].MouseButton1Click:Connect(function()
            switchTab(tabName)
        end)
    end

    -- ======================================================
    -- CUSTOM CROSSHAIR
    -- ======================================================
    local crosshairFrame = Instance.new("Frame")
    crosshairFrame.Name = "Crosshair"
    crosshairFrame.Size = UDim2.new(0,60,0,60)
    crosshairFrame.Position = UDim2.new(0.5,0,0.5,0)
    crosshairFrame.AnchorPoint = Vector2.new(0.5,0.5)
    crosshairFrame.BackgroundTransparency = 1
    crosshairFrame.Visible = false; crosshairFrame.Parent = screenGui

    local crosshairLines = {}
    for i = 1, 4 do
        local line = Instance.new("Frame")
        line.BackgroundColor3 = Theme.AccentPink; line.BorderSizePixel = 0
        line.AnchorPoint = Vector2.new(0.5,0.5); line.Parent = crosshairFrame
        crosshairLines[i] = line
    end
    local centerDot = Instance.new("Frame")
    centerDot.BackgroundColor3 = Theme.AccentPink; centerDot.BorderSizePixel = 0
    centerDot.AnchorPoint = Vector2.new(0.5,0.5); centerDot.Position = UDim2.new(0.5,0,0.5,0)
    centerDot.Visible = false; centerDot.Parent = crosshairFrame
    Instance.new("UICorner", centerDot).CornerRadius = UDim.new(1,0)

    local function updateCrosshair()
        local s = Settings.Crosshair
        if Settings.StreamerMode.Enabled then crosshairFrame.Visible = false; return end
        crosshairFrame.Visible = s.Enabled
        if not s.Enabled then return end
        local size, thickness, gap, color = s.Size, s.Thickness, s.Gap, s.Color
        for _, line in ipairs(crosshairLines) do line.Visible = false end
        centerDot.Visible = false
        if s.Style == "Cross" or s.Style == "Cross + Dot" then
            crosshairLines[1].Size = UDim2.new(0,thickness,0,size); crosshairLines[1].Position = UDim2.new(0.5,0,0.5,-(gap+size/2)); crosshairLines[1].BackgroundColor3 = color; crosshairLines[1].Visible = true
            crosshairLines[2].Size = UDim2.new(0,thickness,0,size); crosshairLines[2].Position = UDim2.new(0.5,0,0.5,(gap+size/2)); crosshairLines[2].BackgroundColor3 = color; crosshairLines[2].Visible = true
            crosshairLines[3].Size = UDim2.new(0,size,0,thickness); crosshairLines[3].Position = UDim2.new(0.5,-(gap+size/2),0.5,0); crosshairLines[3].BackgroundColor3 = color; crosshairLines[3].Visible = true
            crosshairLines[4].Size = UDim2.new(0,size,0,thickness); crosshairLines[4].Position = UDim2.new(0.5,(gap+size/2),0.5,0); crosshairLines[4].BackgroundColor3 = color; crosshairLines[4].Visible = true
            if s.Style == "Cross + Dot" then centerDot.Size = UDim2.new(0,thickness+2,0,thickness+2); centerDot.BackgroundColor3 = color; centerDot.Visible = true end
        elseif s.Style == "Dot" then
            centerDot.Size = UDim2.new(0,size,0,size); centerDot.BackgroundColor3 = color; centerDot.Visible = true
        elseif s.Style == "Circle" then
            centerDot.Size = UDim2.new(0,size*2,0,size*2); centerDot.BackgroundColor3 = Color3.fromRGB(0,0,0); centerDot.BackgroundTransparency = 0.8; centerDot.Visible = true
        end
        if s.CenterDot and s.Style ~= "Dot" then
            centerDot.Size = UDim2.new(0,4,0,4); centerDot.BackgroundColor3 = color; centerDot.Visible = true
        end
    end
    local crosshairUpdateConn = RunService.RenderStepped:Connect(function()
        if isUnloading or _G.BinxixUnloaded then return end
        updateCrosshair()
    end)
    table.insert(allConnections, crosshairUpdateConn)

    -- ======================================================
    -- SPEED BOOST
    -- ======================================================
    local speedVelocity = nil
    local speedMethodConn = RunService.Heartbeat:Connect(function(dt)
        if isUnloading or _G.BinxixUnloaded then return end
        if not Settings.Movement.SpeedEnabled then
            if speedVelocity then pcall(function() speedVelocity:Destroy() end); speedVelocity = nil end
            return
        end
        local method = Settings.Movement.SpeedMethod
        if method == "WalkSpeed" then
            if speedVelocity then pcall(function() speedVelocity:Destroy() end); speedVelocity = nil end
            return
        end
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if not hrp or not humanoid then return end
        humanoid.WalkSpeed = 16
        local moveDir = humanoid.MoveDirection
        if moveDir.Magnitude < 0.1 then
            if speedVelocity then pcall(function() speedVelocity:Destroy() end); speedVelocity = nil end
            return
        end
        local speed = Settings.Movement.Speed
        if method == "CFrame" then
            if speedVelocity then pcall(function() speedVelocity:Destroy() end); speedVelocity = nil end
            local worldMove = moveDir * speed * dt
            hrp.CFrame = hrp.CFrame + Vector3.new(worldMove.X,0,worldMove.Z)
        elseif method == "Velocity" then
            if not speedVelocity or speedVelocity.Parent ~= hrp then
                if speedVelocity then pcall(function() speedVelocity:Destroy() end) end
                speedVelocity = Instance.new("BodyVelocity"); speedVelocity.Name = "BinxixSpeedVelocity"
                speedVelocity.MaxForce = Vector3.new(100000,0,100000); speedVelocity.P = 10000
                speedVelocity.Parent = hrp
            end
            speedVelocity.Velocity = moveDir * speed
        end
    end)
    table.insert(allConnections, speedMethodConn)

    -- ======================================================
    -- BUNNY HOP
    -- ======================================================
    local bhopVelocity = nil
    local lastJumpTime = 0
    local currentBhopSpeed = 0

    local bunnyHopConn = RunService.RenderStepped:Connect(function(deltaTime)
        if isUnloading or _G.BinxixUnloaded then return end
        if not Settings.Movement.BunnyHop then
            if bhopVelocity then bhopVelocity:Destroy(); bhopVelocity = nil end
            currentBhopSpeed = 0; return
        end
        local char = player.Character
        if not char then return end
        local humanoid = char:FindFirstChild("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not humanoid or not hrp then return end
        local isHoldingSpace = UserInputService:IsKeyDown(Enum.KeyCode.Space)
        local isGrounded = humanoid:GetState() ~= Enum.HumanoidStateType.Jumping and humanoid:GetState() ~= Enum.HumanoidStateType.Freefall
        local targetBhopSpeed = 16 + (Settings.Movement.BunnyHopSpeed/100)*64
        if isHoldingSpace then
            if isGrounded then humanoid:ChangeState(Enum.HumanoidStateType.Jumping); lastJumpTime = tick() end
            if not isGrounded then
                local camera = Workspace.CurrentCamera
                if camera then
                    local lookVector = camera.CFrame.LookVector
                    local forwardDir = Vector3.new(lookVector.X,0,lookVector.Z).Unit
                    currentBhopSpeed = currentBhopSpeed + (targetBhopSpeed - currentBhopSpeed) * math.min(deltaTime*5,1)
                    if not bhopVelocity or bhopVelocity.Parent ~= hrp then
                        if bhopVelocity then bhopVelocity:Destroy() end
                        bhopVelocity = Instance.new("BodyVelocity"); bhopVelocity.Name = "BinxixBhopVelocity"
                        bhopVelocity.MaxForce = Vector3.new(8000,0,8000); bhopVelocity.P = 1000
                        bhopVelocity.Parent = hrp
                    end
                    bhopVelocity.Velocity = forwardDir * currentBhopSpeed
                end
            else
                if bhopVelocity and (tick()-lastJumpTime) > 0.08 then bhopVelocity:Destroy(); bhopVelocity = nil end
                currentBhopSpeed = currentBhopSpeed * 0.85
            end
        else
            if bhopVelocity then bhopVelocity:Destroy(); bhopVelocity = nil end
            currentBhopSpeed = 0
        end
    end)
    table.insert(allConnections, bunnyHopConn)

    -- ======================================================
    -- FOV MAINTENANCE
    -- ======================================================
    local fovMaintainConn = RunService.RenderStepped:Connect(function()
        if isUnloading or _G.BinxixUnloaded then return end
        if Settings.Visuals.CustomFOV then
            local camera = Workspace.CurrentCamera
            if camera and camera.FieldOfView ~= Settings.Visuals.FOVAmount then
                camera.FieldOfView = Settings.Visuals.FOVAmount
            end
        end
    end)
    table.insert(allConnections, fovMaintainConn)

    -- ======================================================
    -- FLY LOOP
    -- ======================================================
    local flyConn = RunService.RenderStepped:Connect(function()
        if isUnloading or _G.BinxixUnloaded then return end
        if Settings.Movement.Fly and isFlying then
            local char = player.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp or not flyBodyVelocity or not flyBodyGyro then return end
            local camera = Workspace.CurrentCamera
            local flySpeed = Settings.Movement.FlySpeed
            local moveDirection = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveDirection = moveDirection - Vector3.new(0,1,0)
            end
            if moveDirection.Magnitude > 0 then moveDirection = moveDirection.Unit end
            flyBodyVelocity.Velocity = moveDirection * flySpeed
            flyBodyGyro.CFrame = camera.CFrame
        elseif not Settings.Movement.Fly and isFlying then
            stopFly()
        end
    end)
    table.insert(allConnections, flyConn)

    -- ======================================================
    -- ANTI-AFK
    -- ======================================================
    local virtualUser = game:GetService("VirtualUser")
    local antiAfkConn = player.Idled:Connect(function()
        if Settings.Misc.AntiAFK then virtualUser:CaptureController(); virtualUser:ClickButton2(Vector2.new()) end
    end)
    table.insert(allConnections, antiAfkConn)

    -- ======================================================
    -- KILL AURA
    -- ======================================================
    local lastAuraSwing = 0
    local killAuraConn = RunService.Heartbeat:Connect(function()
        if isUnloading or _G.BinxixUnloaded then return end
        if not Settings.Combat.KillAura then return end
        local now = tick()
        if now - lastAuraSwing < Settings.Combat.KillAuraSpeed then return end
        local myChar = player.Character
        if not myChar then return end
        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        for _, target in ipairs(Players:GetPlayers()) do
            if isValidTarget(player, target) then
                local targetChar = target.Character
                if targetChar then
                    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
                    local h = targetChar:FindFirstChild("Humanoid")
                    if targetHRP and h and h.Health > 0 then
                        if (myHRP.Position - targetHRP.Position).Magnitude <= Settings.Combat.KillAuraRange then
                            if Settings.Combat.KillAuraMethod == "Click" then
                                pcall(function()
                                    local tool = myChar:FindFirstChildOfClass("Tool")
                                    if tool then tool:Activate() else game:GetService("VirtualUser"):ClickButton1(Vector2.new()) end
                                end)
                            elseif Settings.Combat.KillAuraMethod == "Touch" then
                                pcall(function()
                                    local tool = myChar:FindFirstChildOfClass("Tool")
                                    if tool then
                                        local handle = tool:FindFirstChild("Handle")
                                        if handle then
                                            for _, part in ipairs(targetChar:GetChildren()) do
                                                if part:IsA("BasePart") then
                                                    firetouchinterest(handle, part, 0)
                                                    task.defer(function() pcall(function() firetouchinterest(handle, part, 1) end) end)
                                                    break
                                                end
                                            end
                                        end
                                    end
                                end)
                            end
                            lastAuraSwing = now; break
                        end
                    end
                end
            end
        end
    end)
    table.insert(allConnections, killAuraConn)

    -- ======================================================
    -- TRIGGER BOT
    -- ======================================================
    local lastTriggerFire = 0
    local triggerBotAimlockActive = false

    local triggerBotConn = RunService.Heartbeat:Connect(function()
        if isUnloading or _G.BinxixUnloaded then return end
        if not Settings.Combat.TriggerBot then
            if triggerBotAimlockActive then
                triggerBotAimlockActive = false
                if not toggleTrackingActive then stopAimbotTracking() end
            end
            return
        end
        local now = tick()
        local camera = Workspace.CurrentCamera
        if not camera then return end
        local myChar = player.Character
        if not myChar then return end
        local myHumanoid = myChar:FindFirstChild("Humanoid")
        if not myHumanoid or myHumanoid.Health <= 0 then return end
        local screenCenter = camera.ViewportSize / 2
        local triggerFOV = Settings.Combat.TriggerBotFOV

        if Settings.Aimbot.Enabled then
            if isTracking and currentTarget then
                local targetChar = currentTarget.Character
                if targetChar then
                    local h = targetChar:FindFirstChild("Humanoid")
                    if h and h.Health > 0 then
                        local lockPart = Settings.Aimbot.LockPart
                        local targetPart = targetChar:FindFirstChild(lockPart) or targetChar:FindFirstChild("Head") or targetChar:FindFirstChild("HumanoidRootPart")
                        if targetPart then
                            local screenPos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
                            if onScreen and screenPos.Z > 0 then
                                local distFromCenter = (Vector2.new(screenPos.X,screenPos.Y) - screenCenter).Magnitude
                                if distFromCenter <= triggerFOV and (now - lastTriggerFire) >= Settings.Combat.TriggerBotDelay then
                                    pcall(function()
                                        local tool = myChar:FindFirstChildOfClass("Tool")
                                        if tool then tool:Activate() else game:GetService("VirtualUser"):ClickButton1(Vector2.new()) end
                                    end)
                                    lastTriggerFire = now
                                end
                            end
                        end
                    end
                end
            else
                local bestTarget = getNearestValidTarget()
                if bestTarget then
                    triggerBotAimlockActive = true; startAimbotTracking()
                else
                    if triggerBotAimlockActive then triggerBotAimlockActive = false; stopAimbotTracking() end
                end
            end
            return
        end

        if now - lastTriggerFire < Settings.Combat.TriggerBotDelay then return end
        for _, target in ipairs(Players:GetPlayers()) do
            if isValidTarget(player, target) then
                local targetChar = target.Character
                if targetChar then
                    local targetHead = targetChar:FindFirstChild("Head")
                    local h = targetChar:FindFirstChild("Humanoid")
                    if targetHead and h and h.Health > 0 then
                        local screenPos, onScreen = camera:WorldToViewportPoint(targetHead.Position)
                        if onScreen and screenPos.Z > 0 then
                            if (Vector2.new(screenPos.X,screenPos.Y) - screenCenter).Magnitude <= triggerFOV then
                                pcall(function()
                                    local tool = myChar:FindFirstChildOfClass("Tool")
                                    if tool then tool:Activate() else game:GetService("VirtualUser"):ClickButton1(Vector2.new()) end
                                end)
                                lastTriggerFire = now; break
                            end
                        end
                    end
                end
            end
        end
    end)
    table.insert(allConnections, triggerBotConn)

    -- ======================================================
    -- GUN MOD MAINTENANCE LOOP
    -- ======================================================
    local lastGunModCheck = 0
    local gunModConn = RunService.Heartbeat:Connect(function()
        if isUnloading or _G.BinxixUnloaded then return end
        local now = tick()
        if now - lastGunModCheck < 2 then return end
        lastGunModCheck = now
        local anyEnabled = Settings.Combat.FastReload or Settings.Combat.FastFireRate
            or Settings.Combat.AlwaysAuto or Settings.Combat.NoSpread or Settings.Combat.NoRecoil
        if not anyEnabled then return end
        if not weaponCacheBuilt then buildWeaponCache() end
        for _, v in ipairs(weaponValueCache) do
            if v and v.Parent then
                local n = v.Name
                if Settings.Combat.FastReload and (n=="ReloadTime" or n=="EReloadTime") and v.Value ~= 0.01 then v.Value = 0.01
                elseif Settings.Combat.FastFireRate and (n=="FireRate" or n=="BFireRate") and v.Value ~= 0.02 then v.Value = 0.02
                elseif Settings.Combat.AlwaysAuto and (n=="Auto" or n=="AutoFire" or n=="Automatic" or n=="AutoShoot" or n=="AutoGun") and v.Value ~= true then v.Value = true
                elseif Settings.Combat.NoSpread and (n=="MaxSpread" or n=="Spread" or n=="SpreadControl") and v.Value ~= 0 then v.Value = 0
                elseif Settings.Combat.NoRecoil and (n=="RecoilControl" or n=="Recoil") and v.Value ~= 0 then v.Value = 0
                end
            end
        end
    end)
    table.insert(allConnections, gunModConn)

    -- ======================================================
    -- CHAT SPAMMER
    -- ======================================================
    local lastChatSpam = 0
    local chatSpamConn = RunService.Heartbeat:Connect(function()
        if isUnloading or _G.BinxixUnloaded then return end
        if not Settings.Misc.ChatSpammer then return end
        local now = tick()
        if now - lastChatSpam < Settings.Misc.ChatSpamDelay then return end
        local message = Settings.Misc.ChatSpamMessage
        if message == "" then return end
        lastChatSpam = now
        pcall(function()
            local textChatService = game:GetService("TextChatService")
            local channels = textChatService:FindFirstChild("TextChannels")
            if channels then
                local rbxGeneral = channels:FindFirstChild("RBXGeneral")
                if rbxGeneral then rbxGeneral:SendAsync(message); return end
            end
        end)
        pcall(function()
            local myChar = player.Character
            if myChar then game:GetService("Chat"):Chat(myChar, message, Enum.ChatColor.White) end
        end)
        pcall(function()
            local remote = game:GetService("ReplicatedStorage"):FindFirstChild("SayMessageRequest", true)
            if remote then
                local sayMsg = remote:FindFirstChild("SayMessageRequest")
                if sayMsg then sayMsg:FireServer(message, "All") end
            end
        end)
    end)
    table.insert(allConnections, chatSpamConn)

    local chatSpyLog2 = {}
    local function addChatLog(playerName, message, channel)
        local timestamp = os.date("%H:%M:%S")
        local displayName = playerName
        if Settings.StreamerMode.Enabled and Settings.StreamerMode.HideNames then
            displayName = Settings.StreamerMode.FakeName .. " #" .. tostring(math.random(100,999))
        end
        local entry = {time=timestamp, player=displayName, msg=message, channel=channel or "All"}
        table.insert(chatSpyLog2, 1, entry)
        if #chatSpyLog2 > MAX_CHAT_LOG then table.remove(chatSpyLog2) end
        if chatSpyEnabled then
            local ch = channel and channel ~= "All" and " [" .. channel .. "]" or ""
            print("[ChatSpy]" .. ch .. " " .. playerName .. ": " .. message)
        end
    end

    pcall(function()
        local TextChatService = game:GetService("TextChatService")
        if TextChatService then
            local function hookChannel(channel)
                if channel:IsA("TextChannel") then
                    channel.MessageReceived:Connect(function(msgObj)
                        if not chatSpyEnabled then return end
                        local sender = msgObj.TextSource
                        if not sender then return end
                        local senderPlayer = Players:GetPlayerByUserId(sender.UserId)
                        if not senderPlayer then return end
                        local channelName = channel.Name:gsub("RBXGeneral","All"):gsub("RBXTeam","Team"):gsub("RBXWhisper","Whisper")
                        addChatLog(senderPlayer.DisplayName.." (@"..senderPlayer.Name..")", msgObj.Text, channelName)
                    end)
                end
            end
            for _, channel in ipairs(TextChatService:GetDescendants()) do hookChannel(channel) end
            TextChatService.DescendantAdded:Connect(hookChannel)
        end
    end)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            pcall(function()
                plr.Chatted:Connect(function(msg)
                    if not chatSpyEnabled then return end
                    addChatLog(plr.DisplayName.." (@"..plr.Name..")", msg, "All")
                end)
            end)
        end
    end

    local chatSpyPlayerConn = Players.PlayerAdded:Connect(function(plr)
        pcall(function()
            plr.Chatted:Connect(function(msg)
                if not chatSpyEnabled then return end
                addChatLog(plr.DisplayName.." (@"..plr.Name..")", msg, "All")
            end)
        end)
    end)
    table.insert(allConnections, chatSpyPlayerConn)

    -- ======================================================
    -- FPS + VELOCITY DISPLAY
    -- ======================================================
    local fpsContainer = Instance.new("Frame")
    fpsContainer.Name = "FPSContainer"; fpsContainer.Size = UDim2.new(0,100,0,26)
    fpsContainer.Position = UDim2.new(1,-110,0,10)
    fpsContainer.BackgroundColor3 = Color3.fromRGB(20,20,25)
    fpsContainer.BackgroundTransparency = 0.3
    fpsContainer.BorderSizePixel = 1; fpsContainer.BorderColor3 = Theme.Border
    fpsContainer.Visible = false; fpsContainer.Parent = screenGui

    local fpsLabel = Instance.new("TextLabel")
    fpsLabel.Size = UDim2.new(1,-10,1,0); fpsLabel.Position = UDim2.new(0,5,0,0)
    fpsLabel.BackgroundTransparency = 1; fpsLabel.Text = "FPS: 0"
    fpsLabel.TextColor3 = Theme.AccentBright; fpsLabel.TextSize = 14
    fpsLabel.Font = Enum.Font.SourceSansBold
    fpsLabel.TextXAlignment = Enum.TextXAlignment.Right; fpsLabel.Parent = fpsContainer

    local velocityLabel = Instance.new("TextLabel")
    velocityLabel.Name = "VelocityLabel"; velocityLabel.Size = UDim2.new(0,160,0,20)
    velocityLabel.Position = UDim2.new(0.5,40,0.5,25)
    velocityLabel.BackgroundTransparency = 1; velocityLabel.Text = "0.0 studs/s"
    velocityLabel.TextColor3 = Theme.AccentPink; velocityLabel.TextSize = 13
    velocityLabel.Font = Enum.Font.SourceSansBold
    velocityLabel.TextStrokeTransparency = 0.5; velocityLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    velocityLabel.TextXAlignment = Enum.TextXAlignment.Left
    velocityLabel.Visible = false; velocityLabel.Parent = screenGui

    local lastFpsUpdate = tick(); local frameCount = 0; local currentFps = 0

    local statsConn = RunService.RenderStepped:Connect(function()
        if isUnloading or _G.BinxixUnloaded then return end
        fpsContainer.Visible = Settings.Visuals.ShowFPS
        velocityLabel.Visible = Settings.Visuals.ShowVelocity
        if Settings.Visuals.ShowFPS then
            frameCount = frameCount + 1
            if tick() - lastFpsUpdate >= 1 then
                currentFps = frameCount; frameCount = 0; lastFpsUpdate = tick()
            end
            fpsLabel.Text = "FPS: " .. tostring(currentFps)
        end
        if Settings.Visuals.ShowVelocity then
            local char = player.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local vel = hrp.AssemblyLinearVelocity
                    velocityLabel.Text = string.format("%.1f studs/s", Vector3.new(vel.X,0,vel.Z).Magnitude)
                end
            end
        end
    end)
    table.insert(allConnections, statsConn)

    -- ======================================================
    -- INPUT HANDLING
    -- ======================================================
    local inputBeganConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if isUnloading or _G.BinxixUnloaded then return end
        if gameProcessed then return end
        if waitingForKey or waitingForTPKey then return end

        if input.KeyCode == currentToggleKey then
            mainFrame.Visible = not mainFrame.Visible
        end

        if input.KeyCode == Enum.KeyCode.F then
            if Settings.Movement.Fly then
                if isFlying then stopFly() else startFly() end
            end
        end

        if input.KeyCode == autoTPToggleKey then
            if tabBuilt["General"] then
                autoTPEnabled = not autoTPEnabled
                Settings.Misc.AutoTPLoop = autoTPEnabled
                if autoTPCheckbox then
                    autoTPCheckbox.BackgroundColor3 = autoTPEnabled and Theme.CheckboxEnabled or Theme.CheckboxDisabled
                end
                if autoTPEnabled then
                    startAutoTPLoop()
                    sendNotification("Auto TP", "On - targeting: " .. Settings.Misc.AutoTPTargetName, 2)
                else
                    stopAutoTPLoop()
                    sendNotification("Auto TP", "Off", 2)
                end
            end
        end

        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            if Settings.Aimbot.Enabled then
                if Settings.Aimbot.Toggle then
                    if toggleTrackingActive then toggleTrackingActive = false; stopAimbotTracking()
                    else toggleTrackingActive = true; startAimbotTracking() end
                else
                    startAimbotTracking()
                end
            end
        end
    end)
    table.insert(allConnections, inputBeganConn)

    local inputEndedConn = UserInputService.InputEnded:Connect(function(input)
        if isUnloading or _G.BinxixUnloaded then return end
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            if Settings.Aimbot.Enabled and not Settings.Aimbot.Toggle then
                if not (Settings.Combat.TriggerBot and triggerBotAimlockActive) then
                    stopAimbotTracking()
                end
            end
        end
    end)
    table.insert(allConnections, inputEndedConn)

    return screenGui
end

-- ===========================
-- INITIALIZE
-- ===========================
local gui = createGUI()

local loadedNotif = Instance.new("TextLabel")
loadedNotif.Size = UDim2.new(0,210,0,24)
loadedNotif.Position = UDim2.new(0.5,-105,1,-30)
loadedNotif.BackgroundColor3 = Theme.BackgroundDark
loadedNotif.BorderSizePixel = 1; loadedNotif.BorderColor3 = Theme.Border
loadedNotif.Text = "Binxix Hub V6 Loaded"
loadedNotif.TextColor3 = Theme.AccentPink; loadedNotif.TextSize = 12
loadedNotif.Font = Enum.Font.SourceSans; loadedNotif.Parent = gui

task.spawn(function()
    task.wait(3)
    for i = 0, 1, 0.05 do
        loadedNotif.TextTransparency = i; loadedNotif.BackgroundTransparency = i; task.wait(0.02)
    end
    loadedNotif:Destroy()
end)

print("Binxix Hub V6.5 loaded successfully!")
print("Press RightControl to toggle the GUI")

task.delay(1, function()
    sendNotification("Binxix Hub V6.5", "Loaded | RCtrl = toggle | " .. currentGameData.name, 4)
end)

task.delay(6, function()
    sendNotification("Discord", "discord.gg/S4nPV2Rx7F - join for updates", 5)
end)

-- Auto-load Default profile (deferred slightly so GUI is responsive first)
task.delay(0.4, function()
    -- BlockSpin: force-disable all movement features on load
    if currentGameData.noMovement then
        Settings.Movement.SpeedEnabled   = false
        Settings.Movement.Speed          = 16
        Settings.Movement.SpeedMethod    = "WalkSpeed"
        Settings.Movement.JumpEnabled    = false
        Settings.Movement.JumpPower      = 50
        Settings.Movement.BunnyHop       = false
        Settings.Movement.BunnyHopSpeed  = 30
        Settings.Movement.Fly            = false
        Settings.Misc.AutoTPLoop         = false
        Settings.Misc.AutoTPAntiDeath    = false
        Settings.Misc.AntiAFK            = false
        stopFly()
        stopAutoTPLoop()
        stopAntiDeath()
        pcall(function()
            local char = player.Character
            if char then
                local h = char:FindFirstChild("Humanoid")
                if h then
                    h.WalkSpeed = 16
                    h.JumpPower = 50
                end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local bv = hrp:FindFirstChild("BinxixSpeedVelocity")
                    if bv then bv:Destroy() end
                end
            end
        end)
        sendNotification("BlockSpin", "Movement mods disabled for this game", 4)
        return
    end

    -- Normal games: try to auto-load Default profile
    pcall(function()
        local profilePath = getProfilePath("Default")
        if isfile and isfile(profilePath) then
            local success = loadProfile("Default")
            if success then sendNotification("Profile", "Auto-loaded Default profile", 2) end
        end
    end)
end)

-- Version check (deferred 8s so GUI is fully responsive first)
task.delay(8, function()
    local success, result = pcall(function() return game:HttpGet(VERSION_URL) end)
    if success and result then
        local latestVersion = tonumber(result:match("%d+"))
        if latestVersion and latestVersion > SCRIPT_VERSION then
            sendNotification("Update Available", "v6." .. latestVersion .. " is out. You have v6." .. SCRIPT_VERSION, 8)
            task.wait(1)
            pcall(function()
                local guiRef = player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("BinxixHub_V6")
                if guiRef then
                    local updateBanner = Instance.new("TextButton")
                    updateBanner.Size = UDim2.new(0,280,0,28)
                    updateBanner.Position = UDim2.new(0.5,-140,0,0)
                    updateBanner.BackgroundColor3 = Color3.fromRGB(180,80,40); updateBanner.BorderSizePixel = 0
                    updateBanner.Text = "Update v6." .. latestVersion .. " available - click to copy loadstring"
                    updateBanner.TextColor3 = Color3.fromRGB(255,230,200); updateBanner.TextSize = 11
                    updateBanner.Font = Enum.Font.SourceSansBold; updateBanner.ZIndex = 100; updateBanner.Parent = guiRef
                    Instance.new("UICorner", updateBanner).CornerRadius = UDim.new(0,4)
                    updateBanner.MouseEnter:Connect(function() updateBanner.BackgroundColor3 = Color3.fromRGB(220,100,50) end)
                    updateBanner.MouseLeave:Connect(function() updateBanner.BackgroundColor3 = Color3.fromRGB(180,80,40) end)
                    updateBanner.MouseButton1Click:Connect(function()
                        pcall(function()
                            if setclipboard then
                                setclipboard('loadstring(game:HttpGet("https://raw.githubusercontent.com/binx-ux/airhub-binxix-v6/main/script/aimbot"))()')
                                updateBanner.Text = "Loadstring copied! Re-execute to update"
                                updateBanner.BackgroundColor3 = Color3.fromRGB(40,120,60)
                                task.wait(3); updateBanner:Destroy()
                            end
                        end)
                    end)
                    task.delay(15, function()
                        if updateBanner and updateBanner.Parent then
                            for i = 0, 1, 0.05 do
                                pcall(function() updateBanner.BackgroundTransparency = i; updateBanner.TextTransparency = i end)
                                task.wait(0.02)
                            end
                            pcall(function() updateBanner:Destroy() end)
                        end
                    end)
                end
            end)
        elseif latestVersion and latestVersion == SCRIPT_VERSION then
            sendNotification("Up to Date", "v6." .. SCRIPT_VERSION .. " is the latest version", 3)
        end
    end
end)
