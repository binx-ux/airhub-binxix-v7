local SCRIPT_VERSION = 354
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

-- ===== CUSTOM THEME SYSTEM =====
-- Each theme is fully defined; users can also edit CustomColors live
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
        TitleBar = Color3.fromRGB(20, 16, 26), WindowBorder = Color3.fromRGB(160, 80, 200),
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
        TitleBar = Color3.fromRGB(14, 20, 32), WindowBorder = Color3.fromRGB(60, 120, 220),
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
        TitleBar = Color3.fromRGB(22, 14, 14), WindowBorder = Color3.fromRGB(200, 60, 60),
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
        TitleBar = Color3.fromRGB(14, 22, 16), WindowBorder = Color3.fromRGB(50, 180, 80),
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
        TitleBar = Color3.fromRGB(22, 14, 20), WindowBorder = Color3.fromRGB(220, 80, 140),
    },
    Midnight = {
        Background = Color3.fromRGB(10, 10, 14), BackgroundDark = Color3.fromRGB(6, 6, 9), BackgroundLight = Color3.fromRGB(18, 18, 24),
        Accent = Color3.fromRGB(80, 80, 200), AccentDark = Color3.fromRGB(55, 55, 150), AccentBright = Color3.fromRGB(120, 120, 255), AccentPink = Color3.fromRGB(100, 80, 220),
        TextPrimary = Color3.fromRGB(200, 200, 215), TextSecondary = Color3.fromRGB(130, 130, 150), TextDim = Color3.fromRGB(80, 80, 100), TextHeader = Color3.fromRGB(140, 140, 240),
        Border = Color3.fromRGB(30, 30, 45), BorderLight = Color3.fromRGB(50, 50, 70),
        CheckboxEnabled = Color3.fromRGB(255, 255, 255), CheckboxDisabled = Color3.fromRGB(40, 40, 55),
        SliderBackground = Color3.fromRGB(22, 22, 32), SliderFill = Color3.fromRGB(100, 80, 220),
        TabActive = Color3.fromRGB(120, 120, 255), TabInactive = Color3.fromRGB(100, 100, 120),
        ESP_Close = Color3.fromRGB(255, 60, 60), ESP_Medium = Color3.fromRGB(255, 180, 50), ESP_Far = Color3.fromRGB(255, 255, 80), ESP_VeryFar = Color3.fromRGB(80, 255, 80),
        TitleBar = Color3.fromRGB(6, 6, 12), WindowBorder = Color3.fromRGB(80, 80, 200),
    },
    Cyan = {
        Background = Color3.fromRGB(14, 26, 30), BackgroundDark = Color3.fromRGB(9, 18, 22), BackgroundLight = Color3.fromRGB(20, 36, 42),
        Accent = Color3.fromRGB(40, 200, 220), AccentDark = Color3.fromRGB(25, 155, 175), AccentBright = Color3.fromRGB(70, 230, 255), AccentPink = Color3.fromRGB(40, 210, 200),
        TextPrimary = Color3.fromRGB(210, 230, 235), TextSecondary = Color3.fromRGB(130, 160, 170), TextDim = Color3.fromRGB(80, 110, 120), TextHeader = Color3.fromRGB(80, 220, 240),
        Border = Color3.fromRGB(30, 55, 65), BorderLight = Color3.fromRGB(45, 75, 90),
        CheckboxEnabled = Color3.fromRGB(255, 255, 255), CheckboxDisabled = Color3.fromRGB(40, 65, 72),
        SliderBackground = Color3.fromRGB(20, 42, 50), SliderFill = Color3.fromRGB(40, 200, 220),
        TabActive = Color3.fromRGB(70, 230, 255), TabInactive = Color3.fromRGB(100, 130, 140),
        ESP_Close = Color3.fromRGB(255, 60, 60), ESP_Medium = Color3.fromRGB(255, 180, 50), ESP_Far = Color3.fromRGB(255, 255, 80), ESP_VeryFar = Color3.fromRGB(80, 255, 80),
        TitleBar = Color3.fromRGB(9, 20, 26), WindowBorder = Color3.fromRGB(40, 200, 220),
    },
    Custom = nil, -- populated at runtime
}

local currentThemeName = "Purple"
local Theme = {}
for k, v in pairs(ThemePresets.Purple) do Theme[k] = v end

-- Custom color overrides (persisted in profiles)
local CustomThemeColors = {
    Accent        = Color3.fromRGB(170, 100, 200),
    AccentBright  = Color3.fromRGB(200, 130, 230),
    Background    = Color3.fromRGB(25, 25, 30),
    TitleBar      = Color3.fromRGB(20, 16, 26),
    WindowBorder  = Color3.fromRGB(160, 80, 200),
    TextPrimary   = Color3.fromRGB(220, 220, 225),
    SliderFill    = Color3.fromRGB(180, 100, 200),
    TabActive     = Color3.fromRGB(200, 130, 230),
}

local themeUpdateCallbacks = {}

local function applyTheme(themeName)
    if themeName == "Custom" then
        currentThemeName = "Custom"
        -- Start from Purple base then override
        local base = ThemePresets.Purple
        for k, v in pairs(base) do Theme[k] = v end
        -- Apply custom colors
        Theme.Accent        = CustomThemeColors.Accent
        Theme.AccentBright  = CustomThemeColors.AccentBright
        Theme.AccentPink    = CustomThemeColors.Accent
        Theme.AccentDark    = Color3.fromRGB(
            math.floor(CustomThemeColors.Accent.R*255*0.7),
            math.floor(CustomThemeColors.Accent.G*255*0.7),
            math.floor(CustomThemeColors.Accent.B*255*0.7)
        )
        Theme.Background    = CustomThemeColors.Background
        Theme.BackgroundDark = Color3.fromRGB(
            math.max(0, math.floor(CustomThemeColors.Background.R*255 - 7)),
            math.max(0, math.floor(CustomThemeColors.Background.G*255 - 7)),
            math.max(0, math.floor(CustomThemeColors.Background.B*255 - 7))
        )
        Theme.BackgroundLight = Color3.fromRGB(
            math.min(255, math.floor(CustomThemeColors.Background.R*255 + 10)),
            math.min(255, math.floor(CustomThemeColors.Background.G*255 + 10)),
            math.min(255, math.floor(CustomThemeColors.Background.B*255 + 10))
        )
        Theme.TitleBar      = CustomThemeColors.TitleBar
        Theme.WindowBorder  = CustomThemeColors.WindowBorder
        Theme.TextPrimary   = CustomThemeColors.TextPrimary
        Theme.SliderFill    = CustomThemeColors.SliderFill
        Theme.TabActive     = CustomThemeColors.TabActive
        Theme.TabInactive   = Color3.fromRGB(120, 120, 130)
        Theme.TextHeader    = CustomThemeColors.AccentBright
    else
        local preset = ThemePresets[themeName]
        if not preset then return end
        currentThemeName = themeName
        for k, v in pairs(preset) do Theme[k] = v end
    end
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

-- ===== EXTERNAL SCRIPT LOADER =====
if currentGameData.loadScript then
    local choiceMade, loadExternal = false, false
    local choiceGui = Instance.new("ScreenGui")
    choiceGui.Name = "BinxixLoader"; choiceGui.ResetOnSpawn = false
    choiceGui.IgnoreGuiInset = true; choiceGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    choiceGui.Parent = player:WaitForChild("PlayerGui")
    local dimBg = Instance.new("Frame")
    dimBg.Size = UDim2.new(1,0,1,0); dimBg.BackgroundColor3 = Color3.fromRGB(0,0,0)
    dimBg.BackgroundTransparency = 0.5; dimBg.BorderSizePixel = 0; dimBg.ZIndex = 100; dimBg.Parent = choiceGui
    local choiceFrame = Instance.new("Frame")
    choiceFrame.Size = UDim2.new(0,320,0,160); choiceFrame.Position = UDim2.new(0.5,-160,0.5,-80)
    choiceFrame.BackgroundColor3 = Color3.fromRGB(25,25,30); choiceFrame.BorderSizePixel = 0
    choiceFrame.ZIndex = 101; choiceFrame.Parent = choiceGui
    Instance.new("UICorner", choiceFrame).CornerRadius = UDim.new(0,8)
    local cs = Instance.new("UIStroke", choiceFrame)
    cs.Color = Color3.fromRGB(200,100,200); cs.Thickness = 1
    local function mkLabel(parent, text, pos, size, color, textSize, font, zindex)
        local l = Instance.new("TextLabel")
        l.Size = size; l.Position = pos; l.BackgroundTransparency = 1; l.Text = text
        l.TextColor3 = color; l.TextSize = textSize; l.Font = font or Enum.Font.SourceSans
        l.ZIndex = zindex or 102; l.Parent = parent; return l
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
    hubBtn.Text = "Load Binxix Hub"; hubBtn.TextColor3 = Color3.fromRGB(200,150,255)
    hubBtn.TextSize = 13; hubBtn.Font = Enum.Font.SourceSansBold; hubBtn.ZIndex = 102; hubBtn.Parent = choiceFrame
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
        _G.BinxixUnloaded = true; extBtn:Destroy(); hubBtn:Destroy()
        local loadingLabel = Instance.new("TextLabel")
        loadingLabel.Size = UDim2.new(1,0,1,0); loadingLabel.BackgroundColor3 = Color3.fromRGB(25,25,30)
        loadingLabel.Text = "Loading " .. currentGameData.scriptName .. "..."
        loadingLabel.TextColor3 = Color3.fromRGB(200,200,210); loadingLabel.TextSize = 14
        loadingLabel.Font = Enum.Font.SourceSans; loadingLabel.ZIndex = 103; loadingLabel.Parent = choiceFrame
        task.spawn(function()
            task.wait(0.3)
            local success, err = pcall(function() loadstring(game:HttpGet(currentGameData.loadScript))() end)
            loadingLabel.Text = success and (currentGameData.scriptName .. " Loaded!") or ("Failed: " .. tostring(err))
            task.wait(success and 1.5 or 3); choiceGui:Destroy()
        end)
        return
    else
        choiceGui:Destroy(); gameConfig.espEnabled = true
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
        Prediction = true, PredictionAmount = 0.12, MaxDistance = 500,
    },
    Crosshair = {
        Enabled = false,
        Style = "Cross",       -- Cross, Cross+Dot, Dot, Circle, T-Shape, X-Shape, Reticle, Sniper, KV
        Size = 10, Thickness = 2, Gap = 4,
        Color = Color3.fromRGB(255, 255, 255),
        OutlineEnabled = true, OutlineColor = Color3.fromRGB(0, 0, 0), OutlineThickness = 1,
        CenterDot = false, CenterDotSize = 4,
        Opacity = 1.0,
        DynamicSpread = false,
        RainbowColor = false,
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
        FastReload = false, FastFireRate = false, AlwaysAuto = false, NoSpread = false, NoRecoil = false,
    },
    Misc = {
        AntiAFK = false, AutoRejoin = false, AutoTPLoop = false, AutoTPLoopDelay = 0.2,
        AutoTPTargetName = "Nearest Enemy",
        ChatSpammer = false, ChatSpamMessage = "Binxix Hub V6 on top", ChatSpamDelay = 3,
    },
    Theme = {
        Name = "Purple",
        CustomColors = CustomThemeColors,
    },
}

-- ===== PROFILE / CONFIG SYSTEM =====
local PROFILE_DIR = "BinxixHubV6_Configs/"
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

local function serializeColor(c)
    return {_type="Color3", R=math.floor(c.R*255), G=math.floor(c.G*255), B=math.floor(c.B*255)}
end
local function deserializeColor(t)
    return Color3.fromRGB(t.R, t.G, t.B)
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
                    saveData[category][key] = serializeColor(val)
                elseif typeof(val) == "table" and key == "CustomColors" then
                    saveData[category][key] = {}
                    for ck, cv in pairs(val) do
                        saveData[category][key][ck] = typeof(cv) == "Color3" and serializeColor(cv) or cv
                    end
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
        if saveData._meta and saveData._meta.theme then
            applyTheme(saveData._meta.theme)
        end
        for category, values in pairs(saveData) do
            if category ~= "_meta" and Settings[category] then
                for key, val in pairs(values) do
                    if Settings[category][key] ~= nil then
                        if type(val) == "table" and val._type == "Color3" then
                            Settings[category][key] = deserializeColor(val)
                        elseif type(val) == "table" and key == "CustomColors" then
                            for ck, cv in pairs(val) do
                                if type(cv) == "table" and cv._type == "Color3" then
                                    CustomThemeColors[ck] = deserializeColor(cv)
                                end
                            end
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
    if not notifScreenGui then return end
    local notifHolder = notifScreenGui:FindFirstChild("NotifHolder")
    if not notifHolder then
        notifHolder = Instance.new("Frame"); notifHolder.Name = "NotifHolder"
        notifHolder.Size = UDim2.new(0,220,1,0); notifHolder.Position = UDim2.new(1,-230,0,40)
        notifHolder.BackgroundTransparency = 1; notifHolder.Parent = notifScreenGui
    end
    local notifCount = 0
    for _, child in ipairs(notifHolder:GetChildren()) do if child:IsA("Frame") then notifCount = notifCount + 1 end end
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(1,0,0,52); notif.Position = UDim2.new(1,10,0,notifCount*58)
    notif.BackgroundColor3 = Color3.fromRGB(22,22,28); notif.BorderSizePixel = 1
    notif.BorderColor3 = Color3.fromRGB(60,60,75); notif.ClipsDescendants = true; notif.Parent = notifHolder
    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0,3,1,0); accentBar.BackgroundColor3 = Theme.AccentPink
    accentBar.BorderSizePixel = 0; accentBar.Parent = notif
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1,-14,0,18); titleLbl.Position = UDim2.new(0,10,0,4)
    titleLbl.BackgroundTransparency = 1; titleLbl.Text = title; titleLbl.TextColor3 = Theme.AccentBright
    titleLbl.TextSize = 12; titleLbl.Font = Enum.Font.SourceSansBold
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left; titleLbl.TextTruncate = Enum.TextTruncate.AtEnd; titleLbl.Parent = notif
    local msgLbl = Instance.new("TextLabel")
    msgLbl.Size = UDim2.new(1,-14,0,20); msgLbl.Position = UDim2.new(0,10,0,22)
    msgLbl.BackgroundTransparency = 1; msgLbl.Text = message; msgLbl.TextColor3 = Color3.fromRGB(180,180,190)
    msgLbl.TextSize = 11; msgLbl.Font = Enum.Font.SourceSans
    msgLbl.TextXAlignment = Enum.TextXAlignment.Left; msgLbl.TextTruncate = Enum.TextTruncate.AtEnd; msgLbl.Parent = notif
    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(1,0,0,2); progressBar.Position = UDim2.new(0,0,1,-2)
    progressBar.BackgroundColor3 = Theme.AccentPink; progressBar.BorderSizePixel = 0; progressBar.Parent = notif
    task.spawn(function()
        TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0,0,0,notifCount*58)}):Play()
        TweenService:Create(progressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0,0,0,2)}):Play()
        task.wait(duration)
        local tweenOut = TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(1,10,0,notif.Position.Y.Offset)})
        tweenOut:Play(); tweenOut.Completed:Wait(); notif:Destroy()
        if notifHolder and notifHolder.Parent then
            local idx = 0
            for _, child in ipairs(notifHolder:GetChildren()) do
                if child:IsA("Frame") then
                    TweenService:Create(child, TweenInfo.new(0.2), {Position = UDim2.new(child.Position.X.Scale, child.Position.X.Offset, 0, idx*58)}):Play()
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
    local adminChar = admin.Character; local targetChar = target.Character
    if not adminChar or not targetChar then return false end
    local adminHead = adminChar:FindFirstChild("Head"); local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
    if not adminHead or not targetHRP then return false end
    local rp = RaycastParams.new(); rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.FilterDescendantsInstances = {adminChar, targetChar}
    return Workspace:Raycast(adminHead.Position, (targetHRP.Position - adminHead.Position), rp) == nil
end

local function isInFOV(target, fovRadius)
    local camera = Workspace.CurrentCamera; if not camera then return false end
    local targetChar = target.Character; if not targetChar then return false end
    local lockPart = Settings.Aimbot.LockPart
    local targetPart = targetChar:FindFirstChild(lockPart) or targetChar:FindFirstChild("Head") or targetChar:FindFirstChild("HumanoidRootPart")
    if not targetPart then return false end
    local screenPos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
    if not onScreen or screenPos.Z < 0 then return false end
    local screenCenter = camera.ViewportSize / 2
    return (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude <= fovRadius
end

local function getNearestValidTarget()
    local adminChar = player.Character; if not adminChar then return nil end
    local adminHRP = adminChar:FindFirstChild("HumanoidRootPart"); if not adminHRP then return nil end
    local camera = Workspace.CurrentCamera; if not camera then return nil end
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
        local camera = Workspace.CurrentCamera; if not camera then return end
        if not currentTarget or not currentTarget.Character then
            currentTarget = getNearestValidTarget()
        else
            local targetChar = currentTarget.Character
            if targetChar then
                local h = targetChar:FindFirstChild("Humanoid")
                if not h or h.Health <= 0 then currentTarget = getNearestValidTarget()
                elseif not isInFOV(currentTarget, Settings.Aimbot.FOVRadius) then currentTarget = getNearestValidTarget()
                elseif Settings.Aimbot.RequireLOS and not hasLineOfSight(player, currentTarget) then currentTarget = getNearestValidTarget() end
            else currentTarget = getNearestValidTarget() end
        end
        if currentTarget and currentTarget.Character then
            local targetPos = getPredictedPosition(currentTarget.Character)
            if targetPos then
                local camPos = camera.CFrame.Position
                local desiredCF = CFrame.lookAt(camPos, targetPos)
                local pitch = math.asin(math.clamp(desiredCF.LookVector.Y, -1, 1))
                local maxPitch = math.rad(80)
                if math.abs(pitch) < maxPitch then
                    camera.CFrame = camera.CFrame:Lerp(desiredCF, Settings.Aimbot.Smoothness)
                else
                    local clampedPitch = math.clamp(pitch, -maxPitch, maxPitch)
                    local lv = desiredCF.LookVector
                    local yaw = math.atan2(-lv.X, -lv.Z)
                    local clampedCF = CFrame.new(camPos) * CFrame.Angles(0, yaw, 0) * CFrame.Angles(clampedPitch, 0, 0)
                    camera.CFrame = camera.CFrame:Lerp(clampedCF, Settings.Aimbot.Smoothness)
                end
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
    local myChar = player.Character; if not myChar then return end
    local myHRP = myChar:FindFirstChild("HumanoidRootPart"); if not myHRP then return end
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
                        espData.billboard.Adornee = targetHead; espData.billboard.Parent = targetChar; espData.billboard.Enabled = true
                        local distance = (myHRP.Position - targetHRP.Position).Magnitude
                        local espColor = getESPColor(distance)
                        if espData.nameLabel then
                            espData.nameLabel.Visible = Settings.ESP.NameEnabled
                            espData.nameLabel.Text = target.DisplayName
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
                                espData.boxHighlight = Instance.new("Highlight"); espData.boxHighlight.Name = "BinxixBoxESP"
                                espData.boxHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            end
                            if Settings.ESP.ChamsEnabled then
                                espData.boxHighlight.FillTransparency = Settings.ESP.ChamsFillTransparency
                                espData.boxHighlight.FillColor = Settings.ESP.RainbowColor and Color3.fromHSV(tick()%5/5,1,1) or espColor
                            else espData.boxHighlight.FillTransparency = 1 end
                            espData.boxHighlight.OutlineTransparency = Settings.ESP.OutlineEnabled and 0 or 1
                            espData.boxHighlight.Parent = targetChar
                            espData.boxHighlight.OutlineColor = Settings.ESP.RainbowOutline and Color3.fromHSV(tick()%5/5,1,1) or espColor
                            espData.boxHighlight.Enabled = true
                        else if espData.boxHighlight then espData.boxHighlight.Enabled = false end end
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
    if currentTarget and currentTarget.Character and isTracking then
        if not targetHighlight then
            targetHighlight = Instance.new("Highlight"); targetHighlight.Name = "BinxixLockMarker"
            targetHighlight.FillColor = Theme.AccentPink; targetHighlight.FillTransparency = 0.7
            targetHighlight.OutlineColor = Theme.AccentBright; targetHighlight.OutlineTransparency = 0
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
                table.insert(originalFogSettings.Atmospheres, {instance=effect, Density=effect.Density, Offset=effect.Offset, Color=effect.Color, Decay=effect.Decay, Glare=effect.Glare, Haze=effect.Haze})
            end
        end
    end
    Lighting.FogStart = 100000; Lighting.FogEnd = 100000
    for _, effect in ipairs(Lighting:GetChildren()) do
        if effect:IsA("Atmosphere") then effect.Density=0; effect.Offset=0; effect.Haze=0; effect.Glare=0 end
    end
end
local function disableNoFog()
    if originalFogSettings then
        Lighting.FogStart = originalFogSettings.FogStart; Lighting.FogEnd = originalFogSettings.FogEnd; Lighting.FogColor = originalFogSettings.FogColor
        for _, data in ipairs(originalFogSettings.Atmospheres) do
            if data.instance and data.instance.Parent then
                data.instance.Density=data.Density; data.instance.Offset=data.Offset; data.instance.Color=data.Color
                data.instance.Decay=data.Decay; data.instance.Glare=data.Glare; data.instance.Haze=data.Haze
            end
        end
    end
end

-- ===== GUN MODS =====
local gunModOriginalValues = {FireRate={}, ReloadTime={}, EReloadTime={}, Auto={}, Spread={}, Recoil={}}
local weaponValueCache = {}
local weaponCacheBuilt = false

local function applyGunModToValue(v)
    local n = v.Name
    if Settings.Combat.FastReload and (n=="ReloadTime" or n=="EReloadTime") then
        local key = n=="ReloadTime" and "ReloadTime" or "EReloadTime"
        if not gunModOriginalValues[key][v] then gunModOriginalValues[key][v] = v.Value end; v.Value = 0.01
    end
    if Settings.Combat.FastFireRate and (n=="FireRate" or n=="BFireRate") then
        if not gunModOriginalValues.FireRate[v] then gunModOriginalValues.FireRate[v] = v.Value end; v.Value = 0.02
    end
    if Settings.Combat.AlwaysAuto and (n=="Auto" or n=="AutoFire" or n=="Automatic" or n=="AutoShoot" or n=="AutoGun") then
        if not gunModOriginalValues.Auto[v] then gunModOriginalValues.Auto[v] = v.Value end; v.Value = true
    end
    if Settings.Combat.NoSpread and (n=="MaxSpread" or n=="Spread" or n=="SpreadControl") then
        if not gunModOriginalValues.Spread[v] then gunModOriginalValues.Spread[v] = v.Value end; v.Value = 0
    end
    if Settings.Combat.NoRecoil and (n=="RecoilControl" or n=="Recoil") then
        if not gunModOriginalValues.Recoil[v] then gunModOriginalValues.Recoil[v] = v.Value end; v.Value = 0
    end
end

local function buildWeaponCache()
    weaponValueCache = {}
    local weapons = game:GetService("ReplicatedStorage"):FindFirstChild("Weapons"); if not weapons then return end
    for _, v in pairs(weapons:GetDescendants()) do
        if v:IsA("ValueBase") then
            local n = v.Name
            if n=="ReloadTime" or n=="EReloadTime" or n=="FireRate" or n=="BFireRate"
                or n=="Auto" or n=="AutoFire" or n=="Automatic" or n=="AutoShoot" or n=="AutoGun"
                or n=="MaxSpread" or n=="Spread" or n=="SpreadControl" or n=="RecoilControl" or n=="Recoil" then
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
                    or n=="MaxSpread" or n=="Spread" or n=="SpreadControl" or n=="RecoilControl" or n=="Recoil" then
                    table.insert(weaponValueCache, v); applyGunModToValue(v)
                end
            end
        end)
    end
end)

local function applyAllGunMods()
    if not weaponCacheBuilt then buildWeaponCache() end
    for _, v in ipairs(weaponValueCache) do if v and v.Parent then applyGunModToValue(v) end end
end

local function restoreGunMod(category)
    for obj, val in pairs(gunModOriginalValues[category]) do pcall(function() if obj and obj.Parent then obj.Value = val end end) end
    gunModOriginalValues[category] = {}
end

-- ===== FLY SYSTEM =====
local function startFly()
    local char = player.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart"); local humanoid = char:FindFirstChild("Humanoid")
    if not hrp or not humanoid then return end; isFlying = true
    if flyBodyVelocity then flyBodyVelocity:Destroy() end
    flyBodyVelocity = Instance.new("BodyVelocity"); flyBodyVelocity.Name = "BinxixFlyVelocity"
    flyBodyVelocity.MaxForce = Vector3.new(math.huge,math.huge,math.huge); flyBodyVelocity.Velocity = Vector3.new(0,0,0); flyBodyVelocity.Parent = hrp
    if flyBodyGyro then flyBodyGyro:Destroy() end
    flyBodyGyro = Instance.new("BodyGyro"); flyBodyGyro.Name = "BinxixFlyGyro"
    flyBodyGyro.MaxTorque = Vector3.new(math.huge,math.huge,math.huge); flyBodyGyro.P = 9000; flyBodyGyro.D = 500; flyBodyGyro.Parent = hrp
    humanoid.PlatformStand = true
end

local function stopFly()
    isFlying = false
    local char = player.Character
    if char then local h = char:FindFirstChild("Humanoid"); if h then h.PlatformStand = false end end
    if flyBodyVelocity then flyBodyVelocity:Destroy(); flyBodyVelocity = nil end
    if flyBodyGyro then flyBodyGyro:Destroy(); flyBodyGyro = nil end
end

-- ===== AUTO TP =====
local autoTPTarget = nil
local autoTPLoopConn = nil

local function isTargetProtected(target)
    local targetChar = target.Character; if not targetChar then return true end
    local targetHumanoid = targetChar:FindFirstChild("Humanoid"); if not targetHumanoid then return true end
    for _, child in ipairs(targetChar:GetChildren()) do if child:IsA("ForceField") then return true end end
    if targetHumanoid:FindFirstChild("ForceField") then return true end
    if targetHumanoid.MaxHealth >= 999999 then return true end
    return false
end

local function getNextTPTarget()
    local myChar = player.Character; if not myChar then return nil end
    local myHRP = myChar:FindFirstChild("HumanoidRootPart"); if not myHRP then return nil end
    local targetName = Settings.Misc.AutoTPTargetName
    if targetName and targetName ~= "Nearest Enemy" then
        for _, target in ipairs(Players:GetPlayers()) do
            if target ~= player and (target.DisplayName == targetName or target.Name == targetName) then
                local targetChar = target.Character
                if targetChar then
                    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart"); local h = targetChar:FindFirstChild("Humanoid")
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
                local targetHRP = targetChar:FindFirstChild("HumanoidRootPart"); local h = targetChar:FindFirstChild("Humanoid")
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
    autoTPLoopConn = task.spawn(function()
        while Settings.Misc.AutoTPLoop and not isUnloading and not _G.BinxixUnloaded do
            local myChar = player.Character; local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myHRP then
                autoTPTarget = getNextTPTarget()
                if autoTPTarget then
                    local targetChar = autoTPTarget.Character
                    if targetChar then
                        local targetHRP = targetChar:FindFirstChild("HumanoidRootPart"); local h = targetChar:FindFirstChild("Humanoid")
                        if targetHRP and h and h.Health > 0 then
                            local targetPos = targetHRP.Position
                            local MIN_Y, MAX_Y = -50, 2000
                            if targetPos.Y >= MIN_Y and targetPos.Y <= MAX_Y then
                                local targetCF = targetHRP.CFrame
                                local lookAtTarget = CFrame.lookAt(targetCF.Position + targetCF.LookVector*2, targetCF.Position)
                                myHRP.CFrame = lookAtTarget
                                local camera = Workspace.CurrentCamera
                                if camera then camera.CFrame = CFrame.lookAt(myHRP.Position+Vector3.new(0,2,0), targetHRP.Position) end
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
    Settings.Misc.AutoTPLoop = false; autoTPTarget = nil
    if autoTPLoopConn then pcall(function() task.cancel(autoTPLoopConn) end); autoTPLoopConn = nil end
end

-- ====================================================================
-- MAIN GUI
-- ====================================================================
local function createGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BinxixHub_V6"; screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; screenGui.IgnoreGuiInset = true
    screenGui.Parent = player:WaitForChild("PlayerGui")
    notifScreenGui = screenGui

    -- FOV Circle
    local fovCircle = Instance.new("Frame"); fovCircle.Name = "FOVCircle"
    fovCircle.Size = UDim2.new(0,300,0,300); fovCircle.Position = UDim2.new(0.5,0,0.5,0)
    fovCircle.AnchorPoint = Vector2.new(0.5,0.5); fovCircle.BackgroundTransparency = 1
    fovCircle.Visible = false; fovCircle.Parent = screenGui
    Instance.new("UICorner", fovCircle).CornerRadius = UDim.new(1,0)
    local fovStroke = Instance.new("UIStroke", fovCircle)
    fovStroke.Color = Theme.AccentPink; fovStroke.Thickness = 1; fovStroke.Transparency = 0.5
    local fovUpdateConn = RunService.RenderStepped:Connect(function()
        if isUnloading or _G.BinxixUnloaded then return end
        fovCircle.Size = UDim2.new(0,Settings.Aimbot.FOVRadius*2,0,Settings.Aimbot.FOVRadius*2)
        fovCircle.Visible = Settings.Aimbot.Enabled and Settings.Aimbot.ShowFOV
        fovStroke.Transparency = 1 - Settings.Aimbot.FOVOpacity
    end)
    table.insert(allConnections, fovUpdateConn)

    -- Tracer container
    local tracerContainer = Instance.new("Frame"); tracerContainer.Name = "TracerContainer"
    tracerContainer.Size = UDim2.new(1,0,1,0); tracerContainer.BackgroundTransparency = 1; tracerContainer.Parent = screenGui
    local TRACER_POOL_MAX = 30; local tracerLinePool = {}; local tracerPoolIndex = 0
    for i = 1, TRACER_POOL_MAX do
        local line = Instance.new("Frame")
        line.BackgroundColor3 = Color3.new(1,1,1); line.BorderSizePixel = 0
        line.AnchorPoint = Vector2.new(0.5,0.5); line.Visible = false; line.Parent = tracerContainer; tracerLinePool[i] = line
    end
    local function resetTracerPool() for i = 1, tracerPoolIndex do tracerLinePool[i].Visible = false end; tracerPoolIndex = 0 end
    local function getTracerLine()
        tracerPoolIndex = tracerPoolIndex + 1
        if tracerPoolIndex > TRACER_POOL_MAX then tracerPoolIndex = TRACER_POOL_MAX; return nil end
        return tracerLinePool[tracerPoolIndex]
    end
    local function updateTracers()
        resetTracerPool()
        if not Settings.ESP.Enabled or not Settings.ESP.TracerEnabled then return end
        local myChar = player.Character; if not myChar then return end
        local myHRP = myChar:FindFirstChild("HumanoidRootPart"); if not myHRP then return end
        local camera = Workspace.CurrentCamera; if not camera then return end
        local screenSize = camera.ViewportSize
        local startPos
        if Settings.ESP.TracerOrigin == "Bottom" then startPos = Vector2.new(screenSize.X/2,screenSize.Y)
        elseif Settings.ESP.TracerOrigin == "Center" then startPos = Vector2.new(screenSize.X/2,screenSize.Y/2)
        elseif Settings.ESP.TracerOrigin == "Mouse" then local m=player:GetMouse(); startPos=Vector2.new(m.X,m.Y)
        else startPos = Vector2.new(screenSize.X/2,screenSize.Y) end
        for _, target in ipairs(Players:GetPlayers()) do
            if target ~= player and isValidESPTarget(player, target) then
                local targetChar = target.Character
                if targetChar then
                    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
                    if targetHRP then
                        local screenPos, onScreen = camera:WorldToViewportPoint(targetHRP.Position)
                        if onScreen and screenPos.Z > 0 then
                            local line = getTracerLine(); if not line then break end
                            local tsp = Vector2.new(screenPos.X, screenPos.Y)
                            local distance = (myHRP.Position - targetHRP.Position).Magnitude
                            local espColor = Settings.ESP.RainbowColor and Color3.fromHSV(tick()%5/5,1,1) or getESPColor(distance)
                            local thickness = Settings.ESP.TracerThickness or 1
                            local lineDist = (tsp - startPos).Magnitude; local center = (startPos + tsp) / 2
                            local angle = math.atan2(tsp.Y - startPos.Y, tsp.X - startPos.X)
                            line.Size = UDim2.new(0,lineDist,0,thickness); line.Position = UDim2.new(0,center.X,0,center.Y)
                            line.Rotation = math.deg(angle); line.BackgroundColor3 = espColor; line.Visible = true
                        end
                    end
                end
            end
        end
    end

    -- Skeleton
    local skeletonContainer = Instance.new("Frame"); skeletonContainer.Name = "SkeletonContainer"
    skeletonContainer.Size = UDim2.new(1,0,1,0); skeletonContainer.BackgroundTransparency = 1; skeletonContainer.Parent = screenGui
    local SKELETON_POOL_MAX = 200; local skeletonLinePool = {}; local skeletonPoolIndex = 0
    for i = 1, SKELETON_POOL_MAX do
        local line = Instance.new("Frame")
        line.BackgroundColor3 = Color3.new(1,1,1); line.BorderSizePixel = 0
        line.AnchorPoint = Vector2.new(0.5,0.5); line.Visible = false; line.Parent = skeletonContainer; skeletonLinePool[i] = line
    end
    local function resetSkeletonPool() for i = 1, skeletonPoolIndex do skeletonLinePool[i].Visible = false end; skeletonPoolIndex = 0 end
    local function getSkeletonLine()
        skeletonPoolIndex = skeletonPoolIndex + 1
        if skeletonPoolIndex > SKELETON_POOL_MAX then skeletonPoolIndex = SKELETON_POOL_MAX; return nil end
        return skeletonLinePool[skeletonPoolIndex]
    end
    local function updateSkeletonESP()
        resetSkeletonPool()
        if not Settings.ESP.Enabled or not Settings.ESP.SkeletonEnabled then return end
        local myChar = player.Character; if not myChar then return end
        local myHRP = myChar:FindFirstChild("HumanoidRootPart"); if not myHRP then return end
        local camera = Workspace.CurrentCamera; if not camera then return end
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
                            local part1 = targetChar:FindFirstChild(conn[1]); local part2 = targetChar:FindFirstChild(conn[2])
                            if part1 and part2 then
                                local pos1 = camera:WorldToViewportPoint(part1.Position); local pos2 = camera:WorldToViewportPoint(part2.Position)
                                if pos1.Z > 0 and pos2.Z > 0 then
                                    local line = getSkeletonLine(); if not line then break end
                                    local sp1 = Vector2.new(pos1.X, pos1.Y); local sp2 = Vector2.new(pos2.X, pos2.Y)
                                    local ld = (sp2-sp1).Magnitude; local c = (sp1+sp2)/2; local a = math.atan2(sp2.Y-sp1.Y, sp2.X-sp1.X)
                                    line.Size = UDim2.new(0,ld,0,thickness); line.Position = UDim2.new(0,c.X,0,c.Y)
                                    line.Rotation = math.deg(a); line.BackgroundColor3 = espColor; line.Visible = true
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    -- Arrow container
    local arrowContainer = Instance.new("Frame"); arrowContainer.Name = "ArrowContainer"
    arrowContainer.Size = UDim2.new(1,0,1,0); arrowContainer.BackgroundTransparency = 1; arrowContainer.Parent = screenGui
    local offscreenArrows = {}
    local function createArrow(color, size)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(0,size+30,0,size+16); container.BackgroundTransparency = 1
        container.AnchorPoint = Vector2.new(0.5,0.5); container.Parent = arrowContainer
        local arrow = Instance.new("ImageLabel")
        arrow.Size = UDim2.new(0,size,0,size); arrow.Position = UDim2.new(0.5,0,0,4); arrow.AnchorPoint = Vector2.new(0.5,0)
        arrow.BackgroundTransparency = 1; arrow.Image = "rbxassetid://3926305904"
        arrow.ImageRectOffset = Vector2.new(764,764); arrow.ImageRectSize = Vector2.new(36,36)
        arrow.ImageColor3 = color; arrow.Parent = container
        local distLabel = Instance.new("TextLabel")
        distLabel.Size = UDim2.new(1,0,0,12); distLabel.Position = UDim2.new(0,0,1,-12)
        distLabel.BackgroundTransparency = 1; distLabel.Text = ""; distLabel.TextColor3 = color
        distLabel.TextSize = 10; distLabel.Font = Enum.Font.SourceSansBold
        distLabel.TextStrokeTransparency = 0.4; distLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
        distLabel.Parent = container
        return {container=container, arrow=arrow, distLabel=distLabel}
    end
    local function updateOffscreenArrows()
        for _, arrowData in pairs(offscreenArrows) do if arrowData and arrowData.container then arrowData.container:Destroy() end end
        offscreenArrows = {}
        if not Settings.ESP.Enabled or not Settings.ESP.OffscreenArrows then return end
        local myChar = player.Character; if not myChar then return end
        local myHRP = myChar:FindFirstChild("HumanoidRootPart"); if not myHRP then return end
        local camera = Workspace.CurrentCamera; if not camera then return end
        local screenSize = camera.ViewportSize; local screenCenter = Vector2.new(screenSize.X/2, screenSize.Y/2); local padding = 60
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
                                local radiusX = screenSize.X/2 - padding; local radiusY = screenSize.Y/2 - padding
                                local ax = math.clamp(screenCenter.X + math.sin(angle)*radiusX, padding, screenSize.X-padding)
                                local ay = math.clamp(screenCenter.Y - math.cos(angle)*radiusY, padding, screenSize.Y-padding)
                                local arrowData = createArrow(espColor, Settings.ESP.ArrowSize or 20)
                                arrowData.container.Position = UDim2.new(0,ax,0,ay)
                                arrowData.arrow.Rotation = math.deg(angle)
                                arrowData.distLabel.Text = math.floor(distance) .. "m"; arrowData.distLabel.TextColor3 = espColor
                                offscreenArrows[target.UserId] = arrowData
                            end
                        end
                    end
                end
            end
        end
    end

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
    mainFrame.Name = "MainFrame"; mainFrame.Size = UDim2.new(0,500,0,520)
    mainFrame.Position = UDim2.new(0.5,-250,0.5,-260)
    mainFrame.BackgroundColor3 = Theme.BackgroundDark; mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = Theme.WindowBorder or Theme.Accent
    mainFrame.Active = true; mainFrame.Visible = true; mainFrame.Parent = screenGui
    table.insert(themeUpdateCallbacks, function()
        mainFrame.BackgroundColor3 = Theme.BackgroundDark
        mainFrame.BorderColor3 = Theme.WindowBorder or Theme.Accent
    end)

    local titleBar = Instance.new("Frame"); titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1,0,0,26); titleBar.BackgroundColor3 = Theme.TitleBar or Theme.BackgroundDark
    titleBar.BorderSizePixel = 0; titleBar.Active = true; titleBar.Parent = mainFrame
    table.insert(themeUpdateCallbacks, function() titleBar.BackgroundColor3 = Theme.TitleBar or Theme.BackgroundDark end)

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
    titleText.TextColor3 = Theme.TextPrimary; titleText.TextSize = 12; titleText.Font = Enum.Font.SourceSansBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left; titleText.Parent = titleBar
    table.insert(themeUpdateCallbacks, function() titleText.TextColor3 = Theme.TextPrimary end)

    local versionBadge = Instance.new("TextLabel")
    versionBadge.Size = UDim2.new(0,60,0,16); versionBadge.Position = UDim2.new(0,130,0,5)
    versionBadge.BackgroundColor3 = Theme.AccentDark; versionBadge.BorderSizePixel = 0
    versionBadge.Text = "v6." .. SCRIPT_VERSION; versionBadge.TextColor3 = Theme.AccentBright
    versionBadge.TextSize = 10; versionBadge.Font = Enum.Font.SourceSans; versionBadge.Parent = titleBar
    Instance.new("UICorner", versionBadge).CornerRadius = UDim.new(0,3)

    local gameLabel = Instance.new("TextLabel")
    gameLabel.Size = UDim2.new(0,120,0,16); gameLabel.Position = UDim2.new(1,-280,0,5)
    gameLabel.BackgroundTransparency = 1; gameLabel.Text = currentGameData.name
    gameLabel.TextColor3 = Theme.TextDim; gameLabel.TextSize = 10; gameLabel.Font = Enum.Font.SourceSans; gameLabel.Parent = titleBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0,26,0,26); closeBtn.Position = UDim2.new(1,-26,0,0)
    closeBtn.BackgroundColor3 = Theme.TitleBar or Theme.BackgroundDark; closeBtn.BorderSizePixel = 0
    closeBtn.Text = "x"; closeBtn.TextColor3 = Theme.TextSecondary; closeBtn.TextSize = 14; closeBtn.Font = Enum.Font.SourceSansBold; closeBtn.Parent = titleBar
    closeBtn.MouseEnter:Connect(function() closeBtn.BackgroundColor3 = Color3.fromRGB(200,60,60); closeBtn.TextColor3 = Color3.fromRGB(255,255,255) end)
    closeBtn.MouseLeave:Connect(function() closeBtn.BackgroundColor3 = Theme.TitleBar or Theme.BackgroundDark; closeBtn.TextColor3 = Theme.TextSecondary end)
    closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false end)

    local titleLine = Instance.new("Frame"); titleLine.Size = UDim2.new(1,0,0,1); titleLine.Position = UDim2.new(0,0,1,-1)
    titleLine.BackgroundColor3 = Theme.Border; titleLine.BorderSizePixel = 0; titleLine.Parent = titleBar

    local tabContainer = Instance.new("Frame"); tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(1,0,0,26); tabContainer.Position = UDim2.new(0,0,0,26)
    tabContainer.BackgroundColor3 = Theme.TitleBar or Theme.BackgroundDark; tabContainer.BorderSizePixel = 0; tabContainer.Parent = mainFrame
    table.insert(themeUpdateCallbacks, function() tabContainer.BackgroundColor3 = Theme.TitleBar or Theme.BackgroundDark end)

    local tabLine2 = Instance.new("Frame"); tabLine2.Size = UDim2.new(1,0,0,1); tabLine2.Position = UDim2.new(0,0,1,-1)
    tabLine2.BackgroundColor3 = Theme.Border; tabLine2.BorderSizePixel = 0; tabLine2.Parent = tabContainer

    local contentArea = Instance.new("Frame"); contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1,-8,1,-58); contentArea.Position = UDim2.new(0,4,0,54)
    contentArea.BackgroundTransparency = 1; contentArea.BorderSizePixel = 0; contentArea.Parent = mainFrame

    local tabs = {"General","Aimbot","ESP","Crosshair","Report","Settings"}
    local tabButtons = {}; local tabPages = {}; local tabBuilt = {}; local activeTab = "General"

    local tabWidth = 64
    local tabIndicator = Instance.new("Frame"); tabIndicator.Name = "TabIndicator"
    tabIndicator.Size = UDim2.new(0,tabWidth,0,2); tabIndicator.Position = UDim2.new(0,6,1,-2)
    tabIndicator.BackgroundColor3 = Theme.AccentPink; tabIndicator.BorderSizePixel = 0; tabIndicator.ZIndex = 2; tabIndicator.Parent = tabContainer

    for i, tabName in ipairs(tabs) do
        local tabBtn = Instance.new("TextButton"); tabBtn.Name = tabName.."Tab"
        tabBtn.Size = UDim2.new(0,tabWidth,1,0); tabBtn.Position = UDim2.new(0,(i-1)*tabWidth+4,0,0)
        tabBtn.BackgroundTransparency = 1; tabBtn.Text = tabName
        tabBtn.TextColor3 = i==1 and Theme.TabActive or Theme.TabInactive
        tabBtn.TextSize = 11; tabBtn.Font = Enum.Font.SourceSans; tabBtn.Parent = tabContainer
        tabButtons[tabName] = tabBtn; tabBuilt[tabName] = false
        table.insert(themeUpdateCallbacks, function()
            tabBtn.TextColor3 = (activeTab == tabName) and Theme.TabActive or Theme.TabInactive
        end)
    end

    -- ===== UI BUILDER HELPERS =====
    local function createSectionHeader(parent, text, posX, posY)
        local header = Instance.new("TextLabel")
        header.Size = UDim2.new(0,200,0,16); header.Position = UDim2.new(0,posX,0,posY)
        header.BackgroundTransparency = 1; header.Text = text; header.TextColor3 = Theme.TextHeader; header.TextSize = 12
        header.Font = Enum.Font.SourceSansBold; header.TextXAlignment = Enum.TextXAlignment.Left; header.Parent = parent
        local ul = Instance.new("Frame"); ul.Size = UDim2.new(0,math.max(60,#text*6),0,1)
        ul.Position = UDim2.new(0,0,1,0); ul.BackgroundColor3 = Theme.AccentDark; ul.BorderSizePixel = 0; ul.Parent = header
        return header
    end

    local function createCheckbox(parent, text, posX, posY, default, callback)
        local container = Instance.new("Frame"); container.Size = UDim2.new(0,210,0,18)
        container.Position = UDim2.new(0,posX,0,posY); container.BackgroundTransparency = 1; container.Parent = parent
        local checkbox = Instance.new("Frame"); checkbox.Size = UDim2.new(0,12,0,12); checkbox.Position = UDim2.new(0,0,0,3)
        checkbox.BackgroundColor3 = default and Theme.CheckboxEnabled or Theme.CheckboxDisabled
        checkbox.BorderSizePixel = 1; checkbox.BorderColor3 = Theme.BorderLight; checkbox.Parent = container
        local label = Instance.new("TextLabel"); label.Size = UDim2.new(1,-18,1,0); label.Position = UDim2.new(0,18,0,0)
        label.BackgroundTransparency = 1; label.Text = text; label.TextColor3 = Theme.TextPrimary; label.TextSize = 12
        label.Font = Enum.Font.SourceSans; label.TextXAlignment = Enum.TextXAlignment.Left; label.Parent = container
        local isEnabled = default
        local btn = Instance.new("TextButton"); btn.Size = UDim2.new(1,0,1,0); btn.BackgroundTransparency = 1; btn.Text = ""; btn.Parent = container
        btn.MouseButton1Click:Connect(function()
            if isUnloading or _G.BinxixUnloaded then return end
            isEnabled = not isEnabled; checkbox.BackgroundColor3 = isEnabled and Theme.CheckboxEnabled or Theme.CheckboxDisabled
            if callback then callback(isEnabled) end
        end)
        return {container=container, setValue=function(val) isEnabled=val; checkbox.BackgroundColor3=isEnabled and Theme.CheckboxEnabled or Theme.CheckboxDisabled end, getValue=function() return isEnabled end}
    end

    local function createSlider(parent, text, posX, posY, min, max, default, callback)
        local container = Instance.new("Frame"); container.Size = UDim2.new(0,210,0,32)
        container.Position = UDim2.new(0,posX,0,posY); container.BackgroundTransparency = 1; container.Parent = parent
        local label = Instance.new("TextLabel"); label.Size = UDim2.new(0,130,0,14); label.BackgroundTransparency = 1
        label.Text = text; label.TextColor3 = Theme.TextPrimary; label.TextSize = 12; label.Font = Enum.Font.SourceSans
        label.TextXAlignment = Enum.TextXAlignment.Left; label.Parent = container
        local valueLabel = Instance.new("TextLabel"); valueLabel.Size = UDim2.new(0,60,0,14); valueLabel.Position = UDim2.new(1,-60,0,0)
        valueLabel.BackgroundTransparency = 1; valueLabel.Text = tostring(default); valueLabel.TextColor3 = Theme.AccentPink
        valueLabel.TextSize = 12; valueLabel.Font = Enum.Font.SourceSans; valueLabel.TextXAlignment = Enum.TextXAlignment.Right; valueLabel.Parent = container
        local sliderBg = Instance.new("Frame"); sliderBg.Size = UDim2.new(1,0,0,4); sliderBg.Position = UDim2.new(0,0,0,18)
        sliderBg.BackgroundColor3 = Theme.SliderBackground; sliderBg.BorderSizePixel = 0; sliderBg.Parent = container
        local sliderFill = Instance.new("Frame"); sliderFill.Size = UDim2.new((default-min)/(max-min),0,1,0)
        sliderFill.BackgroundColor3 = Theme.SliderFill; sliderFill.BorderSizePixel = 0; sliderFill.Parent = sliderBg
        local currentValue = default; local draggingSlider = false
        local sliderBtn = Instance.new("TextButton"); sliderBtn.Size = UDim2.new(1,0,0,16); sliderBtn.Position = UDim2.new(0,0,0,10)
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
                if max <= 1 then currentValue = math.floor((min + relX*(max-min))*100)/100
                else currentValue = math.floor(min + relX*(max-min) + 0.5) end
                sliderFill.Size = UDim2.new(relX,0,1,0); valueLabel.Text = tostring(currentValue)
                if callback then callback(currentValue) end
            end
        end)
        table.insert(allConnections, updateConn)
        return container
    end

    local function createDropdown(parent, text, posX, posY, options, default, callback)
        local container = Instance.new("Frame"); container.Size = UDim2.new(0,210,0,36)
        container.Position = UDim2.new(0,posX,0,posY); container.BackgroundTransparency = 1; container.Parent = parent
        local label = Instance.new("TextLabel"); label.Size = UDim2.new(0,95,0,16); label.BackgroundTransparency = 1
        label.Text = text; label.TextColor3 = Theme.TextPrimary; label.TextSize = 12; label.Font = Enum.Font.SourceSans
        label.TextXAlignment = Enum.TextXAlignment.Left; label.Parent = container
        local dropBtn = Instance.new("TextButton"); dropBtn.Size = UDim2.new(0,105,0,18); dropBtn.Position = UDim2.new(1,-105,0,16)
        dropBtn.BackgroundColor3 = Theme.SliderBackground; dropBtn.BorderSizePixel = 1; dropBtn.BorderColor3 = Theme.Border
        dropBtn.Text = default .. " v"; dropBtn.TextColor3 = Theme.TextPrimary; dropBtn.TextSize = 11; dropBtn.Font = Enum.Font.SourceSans; dropBtn.Parent = container
        local isOpen = false
        local optionsFrame = Instance.new("Frame")
        optionsFrame.Size = UDim2.new(0,105,0,#options*18); optionsFrame.BackgroundColor3 = Theme.Background
        optionsFrame.BorderSizePixel = 1; optionsFrame.BorderColor3 = Theme.Border; optionsFrame.Visible = false
        optionsFrame.ZIndex = 100; optionsFrame.Parent = screenGui
        for i, opt in ipairs(options) do
            local optBtn = Instance.new("TextButton"); optBtn.Size = UDim2.new(1,0,0,18); optBtn.Position = UDim2.new(0,0,0,(i-1)*18)
            optBtn.BackgroundColor3 = Theme.Background; optBtn.BorderSizePixel = 0; optBtn.Text = opt
            optBtn.TextColor3 = Theme.TextPrimary; optBtn.TextSize = 11; optBtn.Font = Enum.Font.SourceSans
            optBtn.ZIndex = 101; optBtn.Parent = optionsFrame
            optBtn.MouseEnter:Connect(function() optBtn.BackgroundColor3 = Theme.AccentDark end)
            optBtn.MouseLeave:Connect(function() optBtn.BackgroundColor3 = Theme.Background end)
            optBtn.MouseButton1Click:Connect(function()
                dropBtn.Text = opt .. " v"; isOpen = false; optionsFrame.Visible = false
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
        local btn = Instance.new("TextButton"); btn.Size = UDim2.new(0,w or 180,0,h or 24)
        btn.Position = UDim2.new(0,posX,0,posY); btn.BackgroundColor3 = Theme.SliderBackground
        btn.BorderSizePixel = 1; btn.BorderColor3 = Theme.Border; btn.Text = text
        btn.TextColor3 = Theme.TextPrimary; btn.TextSize = 11; btn.Font = Enum.Font.SourceSans; btn.Parent = parent
        btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Theme.AccentDark end)
        btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Theme.SliderBackground end)
        btn.MouseButton1Click:Connect(callback); return btn
    end

    local function createWarningLabel(parent, text, posX, posY)
        local lbl = Instance.new("TextLabel"); lbl.Size = UDim2.new(0,220,0,14); lbl.Position = UDim2.new(0,posX,0,posY)
        lbl.BackgroundTransparency = 1; lbl.Text = "[ Warning ] " .. text; lbl.TextColor3 = Color3.fromRGB(255,110,60)
        lbl.TextSize = 10; lbl.Font = Enum.Font.SourceSansItalic; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = parent
        return lbl
    end

    -- Color picker helper (basic RGB sliders inline)
    local function createColorPicker(parent, label, posX, posY, default, onChange)
        local frame = Instance.new("Frame"); frame.Size = UDim2.new(0,230,0,82)
        frame.Position = UDim2.new(0,posX,0,posY); frame.BackgroundTransparency = 1; frame.Parent = parent

        local titleLbl = Instance.new("TextLabel"); titleLbl.Size = UDim2.new(1,0,0,14)
        titleLbl.BackgroundTransparency = 1; titleLbl.Text = label; titleLbl.TextColor3 = Theme.TextSecondary
        titleLbl.TextSize = 11; titleLbl.Font = Enum.Font.SourceSans
        titleLbl.TextXAlignment = Enum.TextXAlignment.Left; titleLbl.Parent = frame

        local preview = Instance.new("Frame"); preview.Size = UDim2.new(0,16,0,16)
        preview.Position = UDim2.new(1,-20,0,0); preview.BackgroundColor3 = default
        preview.BorderSizePixel = 1; preview.BorderColor3 = Theme.Border; preview.Parent = frame
        Instance.new("UICorner", preview).CornerRadius = UDim.new(0,3)

        local r, g, b = math.floor(default.R*255), math.floor(default.G*255), math.floor(default.B*255)
        local currentColor = default

        local function rebuildColor()
            currentColor = Color3.fromRGB(r, g, b); preview.BackgroundColor3 = currentColor
            if onChange then onChange(currentColor) end
        end

        local channels = {{"R", Color3.fromRGB(255,80,80)}, {"G", Color3.fromRGB(80,255,80)}, {"B", Color3.fromRGB(80,120,255)}}
        local vals = {r, g, b}
        for i, ch in ipairs(channels) do
            local bg = Instance.new("Frame"); bg.Size = UDim2.new(0,170,0,4)
            bg.Position = UDim2.new(0,0,0,18+(i-1)*20); bg.BackgroundColor3 = Theme.SliderBackground; bg.BorderSizePixel = 0; bg.Parent = frame
            local fill = Instance.new("Frame"); fill.Size = UDim2.new(vals[i]/255,0,1,0)
            fill.BackgroundColor3 = ch[2]; fill.BorderSizePixel = 0; fill.Parent = bg
            local lbl2 = Instance.new("TextLabel"); lbl2.Size = UDim2.new(0,20,0,14); lbl2.Position = UDim2.new(0,175,0,14+(i-1)*20)
            lbl2.BackgroundTransparency = 1; lbl2.Text = ch[1]; lbl2.TextColor3 = ch[2]; lbl2.TextSize = 10
            lbl2.Font = Enum.Font.SourceSansBold; lbl2.Parent = frame
            local draggingSlider2 = false
            local sliderBtn2 = Instance.new("TextButton"); sliderBtn2.Size = UDim2.new(0,170,0,14)
            sliderBtn2.Position = UDim2.new(0,0,0,12+(i-1)*20); sliderBtn2.BackgroundTransparency = 1; sliderBtn2.Text = ""; sliderBtn2.Parent = frame
            sliderBtn2.MouseButton1Down:Connect(function() draggingSlider2 = true end)
            local iEndConn = UserInputService.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider2 = false end
            end)
            table.insert(allConnections, iEndConn)
            local upConn = RunService.RenderStepped:Connect(function()
                if isUnloading or _G.BinxixUnloaded then return end
                if draggingSlider2 then
                    local mouse = player:GetMouse()
                    local relX = math.clamp((mouse.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
                    vals[i] = math.floor(relX*255); fill.Size = UDim2.new(relX,0,1,0)
                    r, g, b = vals[1], vals[2], vals[3]; rebuildColor()
                end
            end)
            table.insert(allConnections, upConn)
        end
        return frame
    end

    -- ======================================================
    -- TAB BUILDERS
    -- ======================================================

    local autoTPCheckbox = nil
    local autoTPEnabled = false
    local autoTPToggleKey = Enum.KeyCode.T
    local waitingForTPKey = false
    local tpTargetBtn = nil

    local function buildGeneralTab(page)
        local leftY = 0

        if not currentGameData.noMovement then
            createSectionHeader(page, "Movement", 0, leftY)
            createCheckbox(page, "Speed Boost", 0, leftY+22, false, function(e)
                Settings.Movement.SpeedEnabled = e
                if Settings.Movement.SpeedMethod == "WalkSpeed" then
                    local char = player.Character
                    if char then local h = char:FindFirstChild("Humanoid"); if h then h.WalkSpeed = e and Settings.Movement.Speed or 16 end end
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
                    local char = player.Character; if char then local h = char:FindFirstChild("Humanoid"); if h then h.WalkSpeed = v end end
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
                local char = player.Character; if char then local h = char:FindFirstChild("Humanoid"); if h then h.JumpPower = e and Settings.Movement.JumpPower or 50 end end
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

        -- Right column
        createSectionHeader(page, "Visuals", 240, 0)
        createCheckbox(page, "Fullbright", 240, 22, false, function(e)
            Settings.Visuals.Fullbright = e
            if e then Lighting.Ambient = Color3.fromRGB(255,255,255); Lighting.Brightness = 2; Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
            else Lighting.Ambient = Color3.fromRGB(127,127,127); Lighting.Brightness = 1; Lighting.OutdoorAmbient = Color3.fromRGB(127,127,127) end
        end)
        createCheckbox(page, "No Fog", 240, 44, false, function(e)
            Settings.Visuals.NoFog = e; if e then enableNoFog() else disableNoFog() end
        end)
        createCheckbox(page, "Custom FOV", 240, 66, false, function(e)
            Settings.Visuals.CustomFOV = e
            local camera = Workspace.CurrentCamera; if camera then camera.FieldOfView = e and Settings.Visuals.FOVAmount or 70 end
        end)
        createSlider(page, "FOV Amount", 240, 88, 30, 120, 70, function(v)
            Settings.Visuals.FOVAmount = v
            if Settings.Visuals.CustomFOV then local camera = Workspace.CurrentCamera; if camera then camera.FieldOfView = v end end
        end)
        createCheckbox(page, "Show FPS", 240, 124, false, function(e) Settings.Visuals.ShowFPS = e end)
        createCheckbox(page, "Show Velocity", 240, 146, false, function(e) Settings.Visuals.ShowVelocity = e end)

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

            local autoTPContainer = Instance.new("Frame"); autoTPContainer.Size = UDim2.new(0,220,0,18)
            autoTPContainer.Position = UDim2.new(0,240,0,rightY); autoTPContainer.BackgroundTransparency = 1; autoTPContainer.Parent = page
            autoTPCheckbox = Instance.new("Frame"); autoTPCheckbox.Size = UDim2.new(0,12,0,12); autoTPCheckbox.Position = UDim2.new(0,0,0,3)
            autoTPCheckbox.BackgroundColor3 = Theme.CheckboxDisabled; autoTPCheckbox.BorderSizePixel = 1; autoTPCheckbox.BorderColor3 = Theme.BorderLight; autoTPCheckbox.Parent = autoTPContainer
            local autoTPLabel = Instance.new("TextLabel"); autoTPLabel.Size = UDim2.new(1,-18,1,0); autoTPLabel.Position = UDim2.new(0,18,0,0)
            autoTPLabel.BackgroundTransparency = 1; autoTPLabel.Text = "Auto TP Loop"; autoTPLabel.TextColor3 = Theme.TextPrimary
            autoTPLabel.TextSize = 12; autoTPLabel.Font = Enum.Font.SourceSans; autoTPLabel.TextXAlignment = Enum.TextXAlignment.Left; autoTPLabel.Parent = autoTPContainer

            local toggleAutoTP
            local autoTPBtn = Instance.new("TextButton"); autoTPBtn.Size = UDim2.new(1,0,1,0); autoTPBtn.BackgroundTransparency = 1; autoTPBtn.Text = ""; autoTPBtn.Parent = autoTPContainer
            autoTPBtn.MouseButton1Click:Connect(function() if toggleAutoTP then toggleAutoTP() end end)

            -- Keybind row
            local tpKeybindRow = Instance.new("Frame"); tpKeybindRow.Size = UDim2.new(0,220,0,18)
            tpKeybindRow.Position = UDim2.new(0,240,0,rightY+22); tpKeybindRow.BackgroundTransparency = 1; tpKeybindRow.Parent = page
            local tpKeybindLbl = Instance.new("TextLabel"); tpKeybindLbl.Size = UDim2.new(0,70,1,0); tpKeybindLbl.BackgroundTransparency = 1
            tpKeybindLbl.Text = "TP Keybind:"; tpKeybindLbl.TextColor3 = Theme.TextSecondary; tpKeybindLbl.TextSize = 11
            tpKeybindLbl.Font = Enum.Font.SourceSans; tpKeybindLbl.TextXAlignment = Enum.TextXAlignment.Left; tpKeybindLbl.Parent = tpKeybindRow
            local tpKeybindBtn = Instance.new("TextButton"); tpKeybindBtn.Size = UDim2.new(0,80,0,18); tpKeybindBtn.Position = UDim2.new(0,72,0,0)
            tpKeybindBtn.BackgroundColor3 = Theme.SliderBackground; tpKeybindBtn.BorderSizePixel = 1; tpKeybindBtn.BorderColor3 = Theme.Border
            tpKeybindBtn.Text = "T"; tpKeybindBtn.TextColor3 = Theme.AccentBright; tpKeybindBtn.TextSize = 11; tpKeybindBtn.Font = Enum.Font.SourceSansBold; tpKeybindBtn.Parent = tpKeybindRow
            tpKeybindBtn.MouseEnter:Connect(function() if not waitingForTPKey then tpKeybindBtn.BackgroundColor3 = Theme.AccentDark end end)
            tpKeybindBtn.MouseLeave:Connect(function() if not waitingForTPKey then tpKeybindBtn.BackgroundColor3 = Theme.SliderBackground end end)
            tpKeybindBtn.MouseButton1Click:Connect(function()
                waitingForTPKey = true; tpKeybindBtn.Text = "Press key..."
                tpKeybindBtn.TextColor3 = Color3.fromRGB(255,255,100); tpKeybindBtn.BackgroundColor3 = Color3.fromRGB(60,60,40)
            end)
            local tpKbConn = UserInputService.InputBegan:Connect(function(input, gp)
                if waitingForTPKey and input.UserInputType == Enum.UserInputType.Keyboard then
                    autoTPToggleKey = input.KeyCode; tpKeybindBtn.Text = input.KeyCode.Name
                    tpKeybindBtn.TextColor3 = Theme.AccentBright; tpKeybindBtn.BackgroundColor3 = Theme.SliderBackground; waitingForTPKey = false
                end
            end)
            table.insert(allConnections, tpKbConn)

            -- Target dropdown
            local tpTargetDropFrame = Instance.new("Frame"); tpTargetDropFrame.Size = UDim2.new(0,220,0,38)
            tpTargetDropFrame.Position = UDim2.new(0,240,0,rightY+44); tpTargetDropFrame.BackgroundTransparency = 1; tpTargetDropFrame.Parent = page
            local tpTargetLbl = Instance.new("TextLabel"); tpTargetLbl.Size = UDim2.new(0,70,0,14); tpTargetLbl.BackgroundTransparency = 1
            tpTargetLbl.Text = "TP Target:"; tpTargetLbl.TextColor3 = Theme.TextSecondary; tpTargetLbl.TextSize = 11
            tpTargetLbl.Font = Enum.Font.SourceSans; tpTargetLbl.TextXAlignment = Enum.TextXAlignment.Left; tpTargetLbl.Parent = tpTargetDropFrame
            tpTargetBtn = Instance.new("TextButton"); tpTargetBtn.Size = UDim2.new(0,145,0,18); tpTargetBtn.Position = UDim2.new(0,72,0,0)
            tpTargetBtn.BackgroundColor3 = Theme.SliderBackground; tpTargetBtn.BorderSizePixel = 1; tpTargetBtn.BorderColor3 = Theme.Border
            tpTargetBtn.Text = "Nearest Enemy v"; tpTargetBtn.TextColor3 = Theme.AccentBright; tpTargetBtn.TextSize = 11; tpTargetBtn.Font = Enum.Font.SourceSans
            tpTargetBtn.TextTruncate = Enum.TextTruncate.AtEnd; tpTargetBtn.Parent = tpTargetDropFrame
            local tpDropdownOpen = false; local tpDropdownFrame = nil
            local function closeTpDropdown() if tpDropdownFrame then tpDropdownFrame:Destroy(); tpDropdownFrame = nil end; tpDropdownOpen = false end
            local function openTpDropdown()
                closeTpDropdown(); tpDropdownOpen = true
                local options = {"Nearest Enemy"}
                for _, p in ipairs(Players:GetPlayers()) do if p ~= player then table.insert(options, p.DisplayName) end end
                tpDropdownFrame = Instance.new("ScrollingFrame"); tpDropdownFrame.Size = UDim2.new(0,145,0,math.min(#options*18,108))
                tpDropdownFrame.Position = UDim2.new(0,72,0,19); tpDropdownFrame.BackgroundColor3 = Theme.BackgroundDark
                tpDropdownFrame.BorderSizePixel = 1; tpDropdownFrame.BorderColor3 = Theme.AccentDark; tpDropdownFrame.ScrollBarThickness = 3
                tpDropdownFrame.ScrollBarImageColor3 = Theme.AccentDark; tpDropdownFrame.CanvasSize = UDim2.new(0,0,0,#options*18)
                tpDropdownFrame.ScrollingDirection = Enum.ScrollingDirection.Y; tpDropdownFrame.ZIndex = 50; tpDropdownFrame.Parent = tpTargetDropFrame
                for i, optionName in ipairs(options) do
                    local optBtn = Instance.new("TextButton"); optBtn.Size = UDim2.new(1,0,0,18); optBtn.Position = UDim2.new(0,0,0,(i-1)*18)
                    optBtn.BackgroundColor3 = Theme.BackgroundDark; optBtn.BackgroundTransparency = 0; optBtn.BorderSizePixel = 0; optBtn.Text = optionName
                    optBtn.TextColor3 = optionName == Settings.Misc.AutoTPTargetName and Theme.AccentBright or Theme.TextPrimary
                    optBtn.TextSize = 11; optBtn.Font = Enum.Font.SourceSans; optBtn.TextTruncate = Enum.TextTruncate.AtEnd; optBtn.ZIndex = 51; optBtn.Parent = tpDropdownFrame
                    optBtn.MouseEnter:Connect(function() optBtn.BackgroundColor3 = Theme.AccentDark end)
                    optBtn.MouseLeave:Connect(function() optBtn.BackgroundColor3 = Theme.BackgroundDark end)
                    optBtn.MouseButton1Click:Connect(function()
                        Settings.Misc.AutoTPTargetName = optionName; tpTargetBtn.Text = optionName .. " v"; closeTpDropdown()
                    end)
                end
            end
            tpTargetBtn.MouseEnter:Connect(function() if not tpDropdownOpen then tpTargetBtn.BackgroundColor3 = Theme.AccentDark end end)
            tpTargetBtn.MouseLeave:Connect(function() if not tpDropdownOpen then tpTargetBtn.BackgroundColor3 = Theme.SliderBackground end end)
            tpTargetBtn.MouseButton1Click:Connect(function() if tpDropdownOpen then closeTpDropdown() else openTpDropdown() end end)

            createSlider(page, "TP Delay (s)", 240, rightY+86, 0.05, 2, 0.2, function(v) Settings.Misc.AutoTPLoopDelay = v end)
            rightY = rightY + 118

            createSectionHeader(page, "Chat Spammer", 240, rightY)
            createCheckbox(page, "Chat Spammer", 240, rightY+22, false, function(e) Settings.Misc.ChatSpammer = e; sendNotification("Chat Spammer", e and "On" or "Off", 2) end)
            createSlider(page, "Spam Delay (s)", 240, rightY+44, 0.5, 10, 3, function(v) Settings.Misc.ChatSpamDelay = v end)
            local spamMsgLbl = Instance.new("TextLabel"); spamMsgLbl.Size = UDim2.new(0,200,0,14); spamMsgLbl.Position = UDim2.new(0,240,0,rightY+80)
            spamMsgLbl.BackgroundTransparency = 1; spamMsgLbl.Text = "Spam Message:"; spamMsgLbl.TextColor3 = Theme.TextSecondary; spamMsgLbl.TextSize = 11
            spamMsgLbl.Font = Enum.Font.SourceSans; spamMsgLbl.TextXAlignment = Enum.TextXAlignment.Left; spamMsgLbl.Parent = page
            local spamMsgBox = Instance.new("TextBox"); spamMsgBox.Size = UDim2.new(0,210,0,22); spamMsgBox.Position = UDim2.new(0,240,0,rightY+96)
            spamMsgBox.BackgroundColor3 = Theme.BackgroundDark; spamMsgBox.BorderSizePixel = 1; spamMsgBox.BorderColor3 = Theme.Border
            spamMsgBox.Text = Settings.Misc.ChatSpamMessage; spamMsgBox.PlaceholderText = "Enter spam message..."
            spamMsgBox.PlaceholderColor3 = Theme.TextDim; spamMsgBox.TextColor3 = Theme.TextPrimary; spamMsgBox.TextSize = 11
            spamMsgBox.Font = Enum.Font.SourceSans; spamMsgBox.TextXAlignment = Enum.TextXAlignment.Left
            spamMsgBox.ClearTextOnFocus = false; spamMsgBox.Parent = page
            spamMsgBox.FocusLost:Connect(function() if spamMsgBox.Text ~= "" then Settings.Misc.ChatSpamMessage = spamMsgBox.Text end end)

            page.CanvasSize = UDim2.new(0,0,0,rightY+130)

            toggleAutoTP = function()
                if isUnloading or _G.BinxixUnloaded then return end
                autoTPEnabled = not autoTPEnabled; Settings.Misc.AutoTPLoop = autoTPEnabled
                autoTPCheckbox.BackgroundColor3 = autoTPEnabled and Theme.CheckboxEnabled or Theme.CheckboxDisabled
                if autoTPEnabled then startAutoTPLoop(); sendNotification("Auto TP", "On - targeting: " .. Settings.Misc.AutoTPTargetName, 2)
                else stopAutoTPLoop(); sendNotification("Auto TP", "Off", 2) end
            end
        else
            local noMoveLbl = Instance.new("TextLabel"); noMoveLbl.Size = UDim2.new(0,200,0,28); noMoveLbl.Position = UDim2.new(0,240,0,172)
            noMoveLbl.BackgroundColor3 = Color3.fromRGB(30,20,20); noMoveLbl.BorderSizePixel = 1; noMoveLbl.BorderColor3 = Color3.fromRGB(100,40,40)
            noMoveLbl.Text = "Movement disabled for " .. currentGameData.name; noMoveLbl.TextColor3 = Color3.fromRGB(255,100,100)
            noMoveLbl.TextSize = 11; noMoveLbl.Font = Enum.Font.SourceSansBold; noMoveLbl.TextXAlignment = Enum.TextXAlignment.Center
            noMoveLbl.TextWrapped = true; noMoveLbl.Parent = page
            page.CanvasSize = UDim2.new(0,0,0,220)
        end
    end

    local function buildAimbotTab(page)
        createSectionHeader(page, "Aimbot Settings", 0, 0)
        createCheckbox(page, "Enabled", 0, 22, false, function(e) Settings.Aimbot.Enabled = e; sendNotification("Aimbot", e and "On" or "Off", 2) end)
        createCheckbox(page, "Toggle Mode (RMB)", 0, 44, false, function(e) Settings.Aimbot.Toggle = e end)
        createCheckbox(page, "Require Line of Sight", 0, 66, true, function(e) Settings.Aimbot.RequireLOS = e end)
        createCheckbox(page, "Prediction", 0, 88, true, function(e) Settings.Aimbot.Prediction = e end)
        createSlider(page, "Smoothness", 0, 116, 0.05, 1, 0.15, function(v) Settings.Aimbot.Smoothness = v end)
        createSlider(page, "Prediction Amount", 0, 152, 0.05, 0.3, 0.12, function(v) Settings.Aimbot.PredictionAmount = v end)
        createDropdown(page, "Lock Part", 0, 190, {"Head","HumanoidRootPart","UpperTorso","Torso"}, "Head", function(v) Settings.Aimbot.LockPart = v end)

        createSectionHeader(page, "FOV Settings", 240, 0)
        createCheckbox(page, "Show FOV Circle", 240, 22, true, function(e) Settings.Aimbot.ShowFOV = e end)
        createSlider(page, "FOV Radius", 240, 50, 50, 400, 150, function(v) Settings.Aimbot.FOVRadius = v end)
        createSlider(page, "FOV Opacity", 240, 86, 0, 100, 50, function(v) Settings.Aimbot.FOVOpacity = v/100 end)
        createSlider(page, "Max Distance", 240, 122, 100, 1000, 500, function(v) Settings.Aimbot.MaxDistance = v end)

        page.CanvasSize = UDim2.new(0,0,0,300)
    end

    local function buildESPTab(page)
        if gameConfig.espEnabled then
            createSectionHeader(page, "ESP Properties", 0, 0)
            createCheckbox(page, "Enabled", 0, 22, false, function(e) Settings.ESP.Enabled = e; sendNotification("ESP", e and "On" or "Off", 2) end)
            createDropdown(page, "Filter", 0, 44, {"Enemies","Team","All","All (No Team Check)"}, "Enemies", function(v) Settings.ESP.FilterMode = v; sendNotification("ESP Filter", v, 2) end)
            createCheckbox(page, "Display Distance", 0, 84, true, function(e) Settings.ESP.DistanceEnabled = e end)
            createCheckbox(page, "Display Name", 0, 106, true, function(e) Settings.ESP.NameEnabled = e end)
            createCheckbox(page, "Display Health", 0, 128, true, function(e) Settings.ESP.HealthEnabled = e end)
            createCheckbox(page, "Display Box", 0, 150, true, function(e) Settings.ESP.BoxEnabled = e end)
            createCheckbox(page, "Chams (Wallhack Glow)", 0, 172, false, function(e) Settings.ESP.ChamsEnabled = e; sendNotification("Chams", e and "On" or "Off", 2) end)
            createSlider(page, "Chams Fill", 0, 196, 0, 100, 50, function(v) Settings.ESP.ChamsFillTransparency = v/100 end)
            createCheckbox(page, "Rainbow Outline", 0, 232, false, function(e) Settings.ESP.RainbowOutline = e end)
            createCheckbox(page, "Rainbow Color", 0, 254, false, function(e) Settings.ESP.RainbowColor = e end)
            createCheckbox(page, "Outline", 0, 276, true, function(e) Settings.ESP.OutlineEnabled = e end)
            createSlider(page, "Font Size", 0, 300, 10, 24, 13, function(v) Settings.ESP.FontSize = v end)

            createSectionHeader(page, "Tracer", 240, 0)
            createCheckbox(page, "Tracer Enabled", 240, 22, true, function(e) Settings.ESP.TracerEnabled = e end)
            createCheckbox(page, "Rainbow Color", 240, 44, false, function(e) Settings.ESP.TracerRainbowColor = e end)
            createDropdown(page, "Position", 240, 70, {"Bottom","Center","Mouse"}, "Bottom", function(v) Settings.ESP.TracerOrigin = v end)
            createSlider(page, "Thickness", 240, 110, 1, 5, 1, function(v) Settings.ESP.TracerThickness = v end)
            createSectionHeader(page, "Skeleton ESP", 240, 150)
            createCheckbox(page, "Skeleton Enabled", 240, 172, false, function(e) Settings.ESP.SkeletonEnabled = e end)
            createSlider(page, "Skeleton Thickness", 240, 194, 1, 5, 1, function(v) Settings.ESP.SkeletonThickness = v end)
            createSectionHeader(page, "Offscreen Arrows", 240, 234)
            createCheckbox(page, "Arrows Enabled", 240, 256, false, function(e) Settings.ESP.OffscreenArrows = e end)
            createSlider(page, "Arrow Size", 240, 278, 10, 40, 20, function(v) Settings.ESP.ArrowSize = v end)
            createSlider(page, "Arrow Distance", 240, 314, 100, 1000, 500, function(v) Settings.ESP.ArrowDistance = v end)

            page.CanvasSize = UDim2.new(0,0,0,370)
        else
            -- override mode same as before
            local warnBox = Instance.new("Frame"); warnBox.Size = UDim2.new(1,-16,0,100); warnBox.Position = UDim2.new(0,8,0,10)
            warnBox.BackgroundColor3 = Theme.BackgroundLight; warnBox.BorderSizePixel = 1; warnBox.BorderColor3 = Theme.Border; warnBox.Parent = page
            local warnTitle = Instance.new("TextLabel"); warnTitle.Size = UDim2.new(1,-20,0,18); warnTitle.Position = UDim2.new(0,10,0,10)
            warnTitle.BackgroundTransparency = 1; warnTitle.Text = "[ Warning ] ESP not officially supported for " .. currentGameData.name
            warnTitle.TextColor3 = Color3.fromRGB(255,180,50); warnTitle.TextSize = 12; warnTitle.Font = Enum.Font.SourceSansBold
            warnTitle.TextXAlignment = Enum.TextXAlignment.Left; warnTitle.Parent = warnBox
            local overrideBox = Instance.new("Frame"); overrideBox.Size = UDim2.new(0,14,0,14); overrideBox.Position = UDim2.new(0,10,0,55)
            overrideBox.BackgroundColor3 = Theme.CheckboxDisabled; overrideBox.BorderSizePixel = 1; overrideBox.BorderColor3 = Theme.BorderLight; overrideBox.Parent = warnBox
            local overrideLbl = Instance.new("TextLabel"); overrideLbl.Size = UDim2.new(0,280,0,16); overrideLbl.Position = UDim2.new(0,30,0,55)
            overrideLbl.BackgroundTransparency = 1; overrideLbl.Text = "Enable ESP anyway (use at your own risk)"
            overrideLbl.TextColor3 = Theme.TextPrimary; overrideLbl.TextSize = 12; overrideLbl.Font = Enum.Font.SourceSans
            overrideLbl.TextXAlignment = Enum.TextXAlignment.Left; overrideLbl.Parent = warnBox
            local overrideBtn = Instance.new("TextButton"); overrideBtn.Size = UDim2.new(1,0,0,40); overrideBtn.Position = UDim2.new(0,0,0,48)
            overrideBtn.BackgroundTransparency = 1; overrideBtn.Text = ""; overrideBtn.Parent = warnBox
            local espOverrideEnabled = false
            overrideBtn.MouseButton1Click:Connect(function()
                espOverrideEnabled = not espOverrideEnabled
                overrideBox.BackgroundColor3 = espOverrideEnabled and Theme.CheckboxEnabled or Theme.CheckboxDisabled
                gameConfig.espEnabled = espOverrideEnabled
                if espOverrideEnabled then sendNotification("ESP Override", "Force-enabled", 3)
                else Settings.ESP.Enabled = false; sendNotification("ESP Override", "Disabled", 2) end
            end)
            page.CanvasSize = UDim2.new(0,0,0,200)
        end
    end

    -- ===== CROSSHAIR TAB - expanded =====
    local function buildCrosshairTab(page)
        createSectionHeader(page, "Crosshair Settings", 0, 0)
        createCheckbox(page, "Enabled", 0, 22, false, function(e) Settings.Crosshair.Enabled = e end)
        createCheckbox(page, "Rainbow Color", 0, 44, false, function(e) Settings.Crosshair.RainbowColor = e end)
        createCheckbox(page, "Outline", 0, 66, true, function(e) Settings.Crosshair.OutlineEnabled = e end)
        createCheckbox(page, "Center Dot", 0, 88, false, function(e) Settings.Crosshair.CenterDot = e end)
        createCheckbox(page, "Dynamic Spread", 0, 110, false, function(e) Settings.Crosshair.DynamicSpread = e end)
        createSlider(page, "Size", 0, 138, 2, 50, 10, function(v) Settings.Crosshair.Size = v end)
        createSlider(page, "Thickness", 0, 174, 1, 8, 2, function(v) Settings.Crosshair.Thickness = v end)
        createSlider(page, "Gap", 0, 210, 0, 30, 4, function(v) Settings.Crosshair.Gap = v end)
        createSlider(page, "Center Dot Size", 0, 246, 1, 12, 4, function(v) Settings.Crosshair.CenterDotSize = v end)
        createSlider(page, "Outline Thickness", 0, 282, 1, 4, 1, function(v) Settings.Crosshair.OutlineThickness = v end)
        createSlider(page, "Opacity %", 0, 318, 0, 100, 100, function(v) Settings.Crosshair.Opacity = v/100 end)

        createDropdown(page, "Style", 0, 358,
            {"Cross","Cross+Dot","Dot","Circle","T-Shape","X-Shape","Reticle","Sniper","KV"},
            "Cross", function(v) Settings.Crosshair.Style = v end)

        -- Color pickers (right col)
        createSectionHeader(page, "Colors", 240, 0)
        local colorY = 20
        createColorPicker(page, "Crosshair Color", 240, colorY, Settings.Crosshair.Color, function(c) Settings.Crosshair.Color = c end)
        colorY = colorY + 90
        createColorPicker(page, "Outline Color", 240, colorY, Settings.Crosshair.OutlineColor, function(c) Settings.Crosshair.OutlineColor = c end)

        -- Preview label
        local hintLbl = Instance.new("TextLabel"); hintLbl.Size = UDim2.new(1,-8,0,14); hintLbl.Position = UDim2.new(0,240,0,220)
        hintLbl.BackgroundTransparency = 1; hintLbl.Text = "Preview visible in-game when Enabled."
        hintLbl.TextColor3 = Theme.TextDim; hintLbl.TextSize = 10; hintLbl.Font = Enum.Font.SourceSans
        hintLbl.TextXAlignment = Enum.TextXAlignment.Left; hintLbl.Parent = page
    end

    local chatSpyEnabled = false
    local chatSpyLog = {}
    local MAX_CHAT_LOG = 100

    local function buildReportTab(page)
        createSectionHeader(page, "Chat Spy", 0, 0)
        createCheckbox(page, "Enable Chat Spy", 0, 22, false, function(e) chatSpyEnabled = e; sendNotification("Chat Spy", e and "Listening" or "Disabled", 2) end)
        local chatSpyInfoLbl = Instance.new("TextLabel"); chatSpyInfoLbl.Size = UDim2.new(1,-8,0,14); chatSpyInfoLbl.Position = UDim2.new(0,0,0,44)
        chatSpyInfoLbl.BackgroundTransparency = 1; chatSpyInfoLbl.Text = "Logs all chat messages to console (F9)."
        chatSpyInfoLbl.TextColor3 = Theme.TextDim; chatSpyInfoLbl.TextSize = 10; chatSpyInfoLbl.Font = Enum.Font.SourceSans
        chatSpyInfoLbl.TextXAlignment = Enum.TextXAlignment.Left; chatSpyInfoLbl.Parent = page

        createSectionHeader(page, "Suggestions", 0, 68)
        local suggestInputBox = Instance.new("TextBox"); suggestInputBox.Size = UDim2.new(1,-8,0,60); suggestInputBox.Position = UDim2.new(0,0,0,88)
        suggestInputBox.BackgroundColor3 = Theme.BackgroundDark; suggestInputBox.BorderSizePixel = 1; suggestInputBox.BorderColor3 = Theme.Border
        suggestInputBox.Text = ""; suggestInputBox.PlaceholderText = "Type your suggestion here..."
        suggestInputBox.PlaceholderColor3 = Theme.TextDim; suggestInputBox.TextColor3 = Theme.TextPrimary
        suggestInputBox.TextSize = 11; suggestInputBox.Font = Enum.Font.SourceSans
        suggestInputBox.TextXAlignment = Enum.TextXAlignment.Left; suggestInputBox.TextYAlignment = Enum.TextYAlignment.Top
        suggestInputBox.TextWrapped = true; suggestInputBox.MultiLine = true; suggestInputBox.ClearTextOnFocus = false; suggestInputBox.Parent = page
        local sendSuggestBtn = Instance.new("TextButton"); sendSuggestBtn.Size = UDim2.new(0,130,0,24); sendSuggestBtn.Position = UDim2.new(0,0,0,154)
        sendSuggestBtn.BackgroundColor3 = Color3.fromRGB(40,100,60); sendSuggestBtn.BorderSizePixel = 1; sendSuggestBtn.BorderColor3 = Theme.Border
        sendSuggestBtn.Text = "Send Suggestion"; sendSuggestBtn.TextColor3 = Color3.fromRGB(120,255,160)
        sendSuggestBtn.TextSize = 12; sendSuggestBtn.Font = Enum.Font.SourceSansBold; sendSuggestBtn.Parent = page
        sendSuggestBtn.MouseEnter:Connect(function() sendSuggestBtn.BackgroundColor3 = Color3.fromRGB(50,130,75) end)
        sendSuggestBtn.MouseLeave:Connect(function() sendSuggestBtn.BackgroundColor3 = Color3.fromRGB(40,100,60) end)
        local function getExecutorName()
            local name = "Unknown"
            pcall(function() if identifyexecutor then name = identifyexecutor() elseif getexecutorname then name = getexecutorname() end end)
            return name
        end
        local suggestCooldown = false
        sendSuggestBtn.MouseButton1Click:Connect(function()
            if suggestCooldown then sendNotification("Suggestion", "Please wait", 2); return end
            local suggestion = suggestInputBox.Text
            if suggestion == "" or #suggestion < 5 then sendNotification("Suggestion", "Write at least 5 characters", 2); return end
            suggestCooldown = true; sendSuggestBtn.Text = "Sending..."; sendSuggestBtn.TextColor3 = Color3.fromRGB(255,200,80)
            local payload = {embeds = {{title="Suggestion - Binxix Hub V6", color=3066993,
                fields={{name="Suggestion",value=suggestion,inline=false},{name="Game",value=currentGameData.name.." ("..tostring(currentPlaceId)..")",inline=true},{name="Executor",value=getExecutorName(),inline=true}},
                footer={text="Binxix Hub V6 Suggestion Box"}, timestamp=os.date("!%Y-%m-%dT%H:%M:%SZ")}}}
            local success = pcall(function()
                local httpRequest = (syn and syn.request) or (http and http.request) or http_request or request or fluxus and fluxus.request
                if httpRequest then
                    httpRequest({Url="https://discord.com/api/webhooks/1469598356975124531/2gW0s_svmwzMFNPidKhyOztLVKPVPI3V2g1OT0VN3ownM6Fpzu1UZ1qFl33ojmnfNGbr",Method="POST",Headers={["Content-Type"]="application/json"},Body=HttpService:JSONEncode(payload)})
                else error("No HTTP function") end
            end)
            if success then sendSuggestBtn.Text = "Sent!"; sendSuggestBtn.TextColor3 = Color3.fromRGB(80,255,120); suggestInputBox.Text = ""; sendNotification("Suggestion", "Sent - thank you!", 3)
            else sendSuggestBtn.Text = "Failed"; sendSuggestBtn.TextColor3 = Color3.fromRGB(255,80,80); sendNotification("Suggestion", "Could not send", 3) end
            task.delay(5, function()
                suggestCooldown = false
                if sendSuggestBtn and sendSuggestBtn.Parent then sendSuggestBtn.Text = "Send Suggestion"; sendSuggestBtn.TextColor3 = Color3.fromRGB(120,255,160) end
            end)
        end)

        createSectionHeader(page, "Bug Report", 0, 192)
        local bugInputBox = Instance.new("TextBox"); bugInputBox.Size = UDim2.new(1,-8,0,60); bugInputBox.Position = UDim2.new(0,0,0,212)
        bugInputBox.BackgroundColor3 = Theme.BackgroundDark; bugInputBox.BorderSizePixel = 1; bugInputBox.BorderColor3 = Theme.Border
        bugInputBox.Text = ""; bugInputBox.PlaceholderText = "Describe the bug..."; bugInputBox.PlaceholderColor3 = Theme.TextDim
        bugInputBox.TextColor3 = Theme.TextPrimary; bugInputBox.TextSize = 11; bugInputBox.Font = Enum.Font.SourceSans
        bugInputBox.TextXAlignment = Enum.TextXAlignment.Left; bugInputBox.TextYAlignment = Enum.TextYAlignment.Top
        bugInputBox.TextWrapped = true; bugInputBox.MultiLine = true; bugInputBox.ClearTextOnFocus = false; bugInputBox.Parent = page
        local sendReportBtn = Instance.new("TextButton"); sendReportBtn.Size = UDim2.new(0,120,0,24); sendReportBtn.Position = UDim2.new(0,0,0,278)
        sendReportBtn.BackgroundColor3 = Theme.AccentDark; sendReportBtn.BorderSizePixel = 1; sendReportBtn.BorderColor3 = Theme.Border
        sendReportBtn.Text = "Send Report"; sendReportBtn.TextColor3 = Theme.TextPrimary; sendReportBtn.TextSize = 12; sendReportBtn.Font = Enum.Font.SourceSansBold; sendReportBtn.Parent = page
        sendReportBtn.MouseEnter:Connect(function() sendReportBtn.BackgroundColor3 = Theme.AccentBright end)
        sendReportBtn.MouseLeave:Connect(function() sendReportBtn.BackgroundColor3 = Theme.AccentDark end)
        local reportCooldown = false
        sendReportBtn.MouseButton1Click:Connect(function()
            if reportCooldown then sendNotification("Report", "Please wait", 2); return end
            local description = bugInputBox.Text
            if description == "" or #description < 5 then sendNotification("Report", "Describe the bug (5+ chars)", 2); return end
            reportCooldown = true; sendReportBtn.Text = "Sending..."; sendReportBtn.TextColor3 = Color3.fromRGB(255,200,80)
            local payload = {embeds = {{title="Bug Report - Binxix Hub V6", color=11163135,
                fields={{name="Executor",value=getExecutorName(),inline=true},{name="Game",value=currentGameData.name.." ("..tostring(currentPlaceId)..")",inline=true},{name="Description",value=description,inline=false}},
                footer={text="Binxix Hub V6 Bug Report"}, timestamp=os.date("!%Y-%m-%dT%H:%M:%SZ")}}}
            local success = pcall(function()
                local httpRequest = (syn and syn.request) or (http and http.request) or http_request or request or fluxus and fluxus.request
                if httpRequest then
                    httpRequest({Url="https://discord.com/api/webhooks/1466757772145070080/-3-YwfjgH-yEl8yeS_AmuW4E3jDL2aF4GrQdnl0woOtRd_mTF6J4BezIMNlTvvnieSaP",Method="POST",Headers={["Content-Type"]="application/json"},Body=HttpService:JSONEncode(payload)})
                else error("No HTTP function") end
            end)
            if success then sendReportBtn.Text = "Sent!"; sendReportBtn.TextColor3 = Color3.fromRGB(80,255,120); bugInputBox.Text = ""; sendNotification("Report", "Bug report sent!", 3)
            else sendReportBtn.Text = "Failed"; sendReportBtn.TextColor3 = Color3.fromRGB(255,80,80); sendNotification("Report", "Could not send", 3) end
            task.delay(5, function()
                reportCooldown = false
                if sendReportBtn and sendReportBtn.Parent then sendReportBtn.Text = "Send Report"; sendReportBtn.TextColor3 = Theme.TextPrimary end
            end)
        end)

        createSectionHeader(page, "Community", 0, 316)
        local discordBtn = Instance.new("TextButton"); discordBtn.Size = UDim2.new(0,160,0,26); discordBtn.Position = UDim2.new(0,0,0,336)
        discordBtn.BackgroundColor3 = Color3.fromRGB(88,101,242); discordBtn.BorderSizePixel = 1; discordBtn.BorderColor3 = Color3.fromRGB(70,80,200)
        discordBtn.Text = "Join Discord Server"; discordBtn.TextColor3 = Color3.fromRGB(255,255,255); discordBtn.TextSize = 12; discordBtn.Font = Enum.Font.SourceSansBold; discordBtn.Parent = page
        discordBtn.MouseEnter:Connect(function() discordBtn.BackgroundColor3 = Color3.fromRGB(110,120,255) end)
        discordBtn.MouseLeave:Connect(function() discordBtn.BackgroundColor3 = Color3.fromRGB(88,101,242) end)
        discordBtn.MouseButton1Click:Connect(function()
            pcall(function() if setclipboard then setclipboard("https://discord.gg/S4nPV2Rx7F"); sendNotification("Discord", "Invite copied to clipboard", 3) end end)
        end)
        page.CanvasSize = UDim2.new(0,0,0,380)
    end

    local currentToggleKey = Enum.KeyCode.RightControl
    local waitingForKey = false

    -- ===== SETTINGS TAB - includes full theme customization & profiles =====
    local function buildSettingsTab(page)
        -- Theme base presets
        createSectionHeader(page, "Theme Preset", 0, 0)
        createDropdown(page, "Base Theme", 0, 22, {"Purple","Blue","Red","Green","Rose","Midnight","Cyan","Custom"}, "Purple", function(v)
            applyTheme(v); sendNotification("Theme", "Switched to " .. v, 2)
        end)

        -- Custom theme color pickers
        createSectionHeader(page, "Custom Theme Colors", 0, 68)
        local cpY = 88
        local colorFields = {
            {"Accent Color",    "Accent"},
            {"Accent Bright",   "AccentBright"},
            {"Background",      "Background"},
            {"Title Bar",       "TitleBar"},
            {"Window Border",   "WindowBorder"},
            {"Text Primary",    "TextPrimary"},
            {"Slider Fill",     "SliderFill"},
            {"Tab Active",      "TabActive"},
        }
        for _, cf in ipairs(colorFields) do
            createColorPicker(page, cf[1], 0, cpY, CustomThemeColors[cf[2]] or Theme.Accent, function(c)
                CustomThemeColors[cf[2]] = c
                if currentThemeName == "Custom" then applyTheme("Custom") end
            end)
            cpY = cpY + 90
        end
        local applyCustomBtn = createButton(page, "Apply Custom Theme", 0, cpY, 200, 26, function()
            applyTheme("Custom"); sendNotification("Theme", "Custom theme applied", 2)
        end)
        cpY = cpY + 36

        -- GUI keybind
        createSectionHeader(page, "GUI Keybind", 240, 0)
        local keybindLbl = Instance.new("TextLabel"); keybindLbl.Size = UDim2.new(0,100,0,20); keybindLbl.Position = UDim2.new(0,240,0,22)
        keybindLbl.BackgroundTransparency = 1; keybindLbl.Text = "Toggle Key:"; keybindLbl.TextColor3 = Theme.TextSecondary; keybindLbl.TextSize = 11
        keybindLbl.Font = Enum.Font.SourceSans; keybindLbl.TextXAlignment = Enum.TextXAlignment.Left; keybindLbl.Parent = page
        local keybindBtn = Instance.new("TextButton"); keybindBtn.Size = UDim2.new(0,120,0,22); keybindBtn.Position = UDim2.new(0,344,0,22)
        keybindBtn.BackgroundColor3 = Theme.SliderBackground; keybindBtn.BorderSizePixel = 1; keybindBtn.BorderColor3 = Theme.Border
        keybindBtn.Text = "RightControl"; keybindBtn.TextColor3 = Theme.AccentBright; keybindBtn.TextSize = 11; keybindBtn.Font = Enum.Font.SourceSansBold; keybindBtn.Parent = page
        keybindBtn.MouseEnter:Connect(function() if not waitingForKey then keybindBtn.BackgroundColor3 = Theme.AccentDark end end)
        keybindBtn.MouseLeave:Connect(function() if not waitingForKey then keybindBtn.BackgroundColor3 = Theme.SliderBackground end end)
        keybindBtn.MouseButton1Click:Connect(function()
            waitingForKey = true; keybindBtn.Text = "Press a key..."; keybindBtn.TextColor3 = Color3.fromRGB(255,255,100); keybindBtn.BackgroundColor3 = Color3.fromRGB(60,60,40)
        end)
        local kbConn = UserInputService.InputBegan:Connect(function(input, gp)
            if waitingForKey and input.UserInputType == Enum.UserInputType.Keyboard then
                currentToggleKey = input.KeyCode; keybindBtn.Text = input.KeyCode.Name
                keybindBtn.TextColor3 = Theme.AccentBright; keybindBtn.BackgroundColor3 = Theme.SliderBackground; waitingForKey = false
            end
        end)
        table.insert(allConnections, kbConn)

        -- ===== CONFIG SYSTEM (easy save/load) =====
        createSectionHeader(page, "Config / Profiles", 240, 58)

        -- Profile name box
        local profileLbl = Instance.new("TextLabel"); profileLbl.Size = UDim2.new(0,80,0,16); profileLbl.Position = UDim2.new(0,240,0,80)
        profileLbl.BackgroundTransparency = 1; profileLbl.Text = "Config Name:"; profileLbl.TextColor3 = Theme.TextSecondary; profileLbl.TextSize = 11
        profileLbl.Font = Enum.Font.SourceSans; profileLbl.TextXAlignment = Enum.TextXAlignment.Left; profileLbl.Parent = page
        local profileNameBox = Instance.new("TextBox"); profileNameBox.Size = UDim2.new(0,100,0,18); profileNameBox.Position = UDim2.new(0,325,0,79)
        profileNameBox.BackgroundColor3 = Theme.SliderBackground; profileNameBox.BorderSizePixel = 1; profileNameBox.BorderColor3 = Theme.Border
        profileNameBox.Text = "Default"; profileNameBox.TextColor3 = Theme.AccentBright; profileNameBox.TextSize = 11; profileNameBox.Font = Enum.Font.SourceSansBold
        profileNameBox.ClearTextOnFocus = false; profileNameBox.Parent = page

        local activeLbl = Instance.new("TextLabel"); activeLbl.Size = UDim2.new(0,220,0,14); activeLbl.Position = UDim2.new(0,240,0,100)
        activeLbl.BackgroundTransparency = 1; activeLbl.Text = "Active: " .. currentProfileName; activeLbl.TextColor3 = Theme.TextDim; activeLbl.TextSize = 10
        activeLbl.Font = Enum.Font.SourceSans; activeLbl.TextXAlignment = Enum.TextXAlignment.Left; activeLbl.Parent = page

        -- Quick-save / load / delete row
        local saveBtn = Instance.new("TextButton"); saveBtn.Size = UDim2.new(0,58,0,22); saveBtn.Position = UDim2.new(0,240,0,118)
        saveBtn.BackgroundColor3 = Theme.SliderBackground; saveBtn.BorderSizePixel = 1; saveBtn.BorderColor3 = Theme.Border
        saveBtn.Text = "Save"; saveBtn.TextColor3 = Color3.fromRGB(80,255,120); saveBtn.TextSize = 11; saveBtn.Font = Enum.Font.SourceSansBold; saveBtn.Parent = page
        saveBtn.MouseEnter:Connect(function() saveBtn.BackgroundColor3 = Theme.AccentDark end)
        saveBtn.MouseLeave:Connect(function() saveBtn.BackgroundColor3 = Theme.SliderBackground end)
        saveBtn.MouseButton1Click:Connect(function()
            local name = profileNameBox.Text == "" and "Default" or profileNameBox.Text
            local success = saveProfile(name)
            if success then currentProfileName = name; activeLbl.Text = "Active: " .. name; sendNotification("Config", "Saved: " .. name, 2)
            else sendNotification("Config", "Save failed", 3) end
        end)

        local loadBtn = Instance.new("TextButton"); loadBtn.Size = UDim2.new(0,58,0,22); loadBtn.Position = UDim2.new(0,302,0,118)
        loadBtn.BackgroundColor3 = Theme.SliderBackground; loadBtn.BorderSizePixel = 1; loadBtn.BorderColor3 = Theme.Border
        loadBtn.Text = "Load"; loadBtn.TextColor3 = Theme.AccentBright; loadBtn.TextSize = 11; loadBtn.Font = Enum.Font.SourceSansBold; loadBtn.Parent = page
        loadBtn.MouseEnter:Connect(function() loadBtn.BackgroundColor3 = Theme.AccentDark end)
        loadBtn.MouseLeave:Connect(function() loadBtn.BackgroundColor3 = Theme.SliderBackground end)
        loadBtn.MouseButton1Click:Connect(function()
            local name = profileNameBox.Text == "" and "Default" or profileNameBox.Text
            local success = loadProfile(name)
            if success then activeLbl.Text = "Active: " .. name; sendNotification("Config", "Loaded: " .. name, 3)
            else sendNotification("Config", "Load failed / not found", 3) end
        end)

        local delBtn = Instance.new("TextButton"); delBtn.Size = UDim2.new(0,58,0,22); delBtn.Position = UDim2.new(0,364,0,118)
        delBtn.BackgroundColor3 = Theme.SliderBackground; delBtn.BorderSizePixel = 1; delBtn.BorderColor3 = Theme.Border
        delBtn.Text = "Delete"; delBtn.TextColor3 = Color3.fromRGB(255,80,80); delBtn.TextSize = 11; delBtn.Font = Enum.Font.SourceSansBold; delBtn.Parent = page
        delBtn.MouseEnter:Connect(function() delBtn.BackgroundColor3 = Color3.fromRGB(100,30,30) end)
        delBtn.MouseLeave:Connect(function() delBtn.BackgroundColor3 = Theme.SliderBackground end)
        delBtn.MouseButton1Click:Connect(function()
            local name = profileNameBox.Text == "" and "Default" or profileNameBox.Text
            deleteProfile(name); sendNotification("Config", "Deleted: " .. name, 2)
        end)

        -- Saved configs list (scrollable dropdown)
        local savedLbl = Instance.new("TextLabel"); savedLbl.Size = UDim2.new(0,220,0,14); savedLbl.Position = UDim2.new(0,240,0,145)
        savedLbl.BackgroundTransparency = 1; savedLbl.Text = "Saved: " .. table.concat(listProfiles(),", ")
        savedLbl.TextColor3 = Theme.TextDim; savedLbl.TextSize = 10; savedLbl.Font = Enum.Font.SourceSans
        savedLbl.TextXAlignment = Enum.TextXAlignment.Left; savedLbl.TextTruncate = Enum.TextTruncate.AtEnd; savedLbl.Parent = page

        local refreshBtn = Instance.new("TextButton"); refreshBtn.Size = UDim2.new(0,55,0,16); refreshBtn.Position = UDim2.new(0,240,0,162)
        refreshBtn.BackgroundColor3 = Theme.SliderBackground; refreshBtn.BorderSizePixel = 1; refreshBtn.BorderColor3 = Theme.Border
        refreshBtn.Text = "Refresh"; refreshBtn.TextColor3 = Theme.TextSecondary; refreshBtn.TextSize = 10; refreshBtn.Font = Enum.Font.SourceSans; refreshBtn.Parent = page
        refreshBtn.MouseButton1Click:Connect(function() savedLbl.Text = "Saved: " .. table.concat(listProfiles(),", ") end)

        -- Quick-load existing config by clicking from list
        local quickLoadLbl = Instance.new("TextLabel"); quickLoadLbl.Size = UDim2.new(0,180,0,14); quickLoadLbl.Position = UDim2.new(0,240,0,185)
        quickLoadLbl.BackgroundTransparency = 1; quickLoadLbl.Text = "Quick Load:"; quickLoadLbl.TextColor3 = Theme.TextSecondary; quickLoadLbl.TextSize = 11
        quickLoadLbl.Font = Enum.Font.SourceSans; quickLoadLbl.TextXAlignment = Enum.TextXAlignment.Left; quickLoadLbl.Parent = page

        local quickLoadScroll = Instance.new("ScrollingFrame"); quickLoadScroll.Size = UDim2.new(0,220,0,90); quickLoadScroll.Position = UDim2.new(0,240,0,202)
        quickLoadScroll.BackgroundColor3 = Theme.BackgroundDark; quickLoadScroll.BorderSizePixel = 1; quickLoadScroll.BorderColor3 = Theme.Border
        quickLoadScroll.ScrollBarThickness = 3; quickLoadScroll.ScrollBarImageColor3 = Theme.AccentDark
        quickLoadScroll.CanvasSize = UDim2.new(0,0,0,0); quickLoadScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        quickLoadScroll.ScrollingDirection = Enum.ScrollingDirection.Y; quickLoadScroll.Parent = page

        local qlLayout = Instance.new("UIListLayout"); qlLayout.SortOrder = Enum.SortOrder.LayoutOrder; qlLayout.Padding = UDim.new(0,1); qlLayout.Parent = quickLoadScroll

        local function refreshQuickLoad()
            for _, child in ipairs(quickLoadScroll:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
            for _, pname in ipairs(listProfiles()) do
                local qlBtn = Instance.new("TextButton"); qlBtn.Size = UDim2.new(1,0,0,20)
                qlBtn.BackgroundColor3 = Theme.BackgroundLight; qlBtn.BorderSizePixel = 0
                qlBtn.Text = "  " .. pname; qlBtn.TextColor3 = pname == currentProfileName and Theme.AccentBright or Theme.TextPrimary
                qlBtn.TextSize = 11; qlBtn.Font = Enum.Font.SourceSans; qlBtn.TextXAlignment = Enum.TextXAlignment.Left
                qlBtn.Parent = quickLoadScroll
                qlBtn.MouseEnter:Connect(function() qlBtn.BackgroundColor3 = Theme.AccentDark end)
                qlBtn.MouseLeave:Connect(function() qlBtn.BackgroundColor3 = Theme.BackgroundLight end)
                qlBtn.MouseButton1Click:Connect(function()
                    profileNameBox.Text = pname
                    local success = loadProfile(pname)
                    if success then activeLbl.Text = "Active: " .. pname; sendNotification("Config", "Loaded: " .. pname, 2); refreshQuickLoad()
                    else sendNotification("Config", "Load failed", 3) end
                end)
            end
        end
        refreshQuickLoad()
        refreshBtn.MouseButton1Click:Connect(function() savedLbl.Text = "Saved: " .. table.concat(listProfiles(),", "); refreshQuickLoad() end)

        -- Script info + unload
        createSectionHeader(page, "Script Info", 240, 305)
        local infoLbl = Instance.new("TextLabel"); infoLbl.Size = UDim2.new(0,220,0,60); infoLbl.Position = UDim2.new(0,240,0,325)
        infoLbl.BackgroundTransparency = 1
        infoLbl.Text = "Binxix Hub V6.5\nGame: " .. currentGameData.name .. "\nPlace ID: " .. tostring(currentPlaceId)
        infoLbl.TextColor3 = Theme.TextSecondary; infoLbl.TextSize = 11; infoLbl.Font = Enum.Font.SourceSans
        infoLbl.TextXAlignment = Enum.TextXAlignment.Left; infoLbl.TextYAlignment = Enum.TextYAlignment.Top; infoLbl.Parent = page

        local unloadBtn = Instance.new("TextButton"); unloadBtn.Size = UDim2.new(0,120,0,26); unloadBtn.Position = UDim2.new(0,240,0,395)
        unloadBtn.BackgroundColor3 = Color3.fromRGB(180,50,50); unloadBtn.BorderSizePixel = 1; unloadBtn.BorderColor3 = Theme.Border
        unloadBtn.Text = "Unload Script"; unloadBtn.TextColor3 = Theme.TextPrimary; unloadBtn.TextSize = 12; unloadBtn.Font = Enum.Font.SourceSans; unloadBtn.Parent = page
        unloadBtn.MouseButton1Click:Connect(function()
            isUnloading = true; _G.BinxixUnloaded = true
            Settings.Combat.FastReload = false; Settings.Combat.FastFireRate = false
            Settings.Combat.AlwaysAuto = false; Settings.Combat.NoSpread = false; Settings.Combat.NoRecoil = false
            pcall(function()
                if gunModOriginalValues then
                    for _, entries in pairs(gunModOriginalValues) do
                        for obj, originalVal in pairs(entries) do pcall(function() obj.Value = originalVal end) end
                    end
                end
            end)
            pcall(function()
                local char = player.Character
                if char then local h = char:FindFirstChild("Humanoid"); if h then h.WalkSpeed = 16 end end
            end)
            stopAutoTPLoop()
            for _, conn in ipairs(allConnections) do pcall(function() conn:Disconnect() end) end
            screenGui:Destroy()
        end)

        -- Other scripts
        createSectionHeader(page, "Other Scripts", 240, 430)
        local function createScriptButton(text, posY, url)
            local btn; btn = createButton(page, text, 240, posY, 200, 22, function()
                if btn then btn.Text = "Loading..." end
                task.spawn(function()
                    local ok, err = pcall(function()
                        local src = game:HttpGet(url, true); local fn, loadErr = loadstring(src)
                        if not fn then error(loadErr or "loadstring failed") end; fn()
                    end)
                    if btn and btn.Parent then
                        btn.Text = ok and "Loaded!" or "Failed"
                        if not ok then warn("[BinxixHub] Script load error: " .. tostring(err)) end
                        task.wait(3); if btn and btn.Parent then btn.Text = text end
                    end
                end)
            end)
        end
        createScriptButton("Infinite Yield", 450, "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
        createScriptButton("Nameless Admin", 476, "https://raw.githubusercontent.com/ltseverydayyou/Nameless-Admin/main/Source.lua")

        page.CanvasSize = UDim2.new(0,0,0,math.max(cpY + 30, 510))
    end

    -- ======================================================
    -- CREATE PAGES
    -- ======================================================
    local tabBuilders = {
        General = buildGeneralTab, Aimbot = buildAimbotTab, ESP = buildESPTab,
        Crosshair = buildCrosshairTab, Report = buildReportTab, Settings = buildSettingsTab,
    }

    for _, tabName in ipairs(tabs) do
        local page = Instance.new("ScrollingFrame")
        page.ScrollBarThickness = 4; page.ScrollBarImageColor3 = Theme.AccentDark
        page.CanvasSize = UDim2.new(0,0,0,400); page.ScrollingDirection = Enum.ScrollingDirection.Y
        page.Name = tabName .. "Page"; page.Size = UDim2.new(1,0,1,0)
        page.BackgroundTransparency = 1; page.Visible = tabName == "General"; page.BorderSizePixel = 0; page.Parent = contentArea
        tabPages[tabName] = page
    end

    buildGeneralTab(tabPages["General"]); tabBuilt["General"] = true

    local function switchTab(tabName)
        if isUnloading or _G.BinxixUnloaded then return end
        activeTab = tabName
        if not tabBuilt[tabName] and tabBuilders[tabName] then
            tabBuilders[tabName](tabPages[tabName]); tabBuilt[tabName] = true
        end
        for name, btn in pairs(tabButtons) do btn.TextColor3 = name == tabName and Theme.TabActive or Theme.TabInactive end
        local tabIndex = table.find(tabs, tabName)
        if tabIndex then TweenService:Create(tabIndicator, TweenInfo.new(0.15), {Position = UDim2.new(0,(tabIndex-1)*tabWidth+4,1,-2)}):Play() end
        for name, page in pairs(tabPages) do page.Visible = name == tabName end
    end

    for _, tabName in ipairs(tabs) do
        tabButtons[tabName].MouseButton1Click:Connect(function() switchTab(tabName) end)
    end

    -- ======================================================
    -- CROSSHAIR RENDERING - expanded styles
    -- ======================================================
    local crosshairFrame = Instance.new("Frame"); crosshairFrame.Name = "Crosshair"
    crosshairFrame.Size = UDim2.new(0,100,0,100); crosshairFrame.Position = UDim2.new(0.5,0,0.5,0)
    crosshairFrame.AnchorPoint = Vector2.new(0.5,0.5); crosshairFrame.BackgroundTransparency = 1; crosshairFrame.Visible = false; crosshairFrame.Parent = screenGui

    -- Pre-allocate line pool for crosshair
    local chLines = {}
    for i = 1, 12 do
        local l = Instance.new("Frame"); l.BackgroundColor3 = Color3.new(1,1,1); l.BorderSizePixel = 0
        l.AnchorPoint = Vector2.new(0.5,0.5); l.Visible = false; l.Parent = crosshairFrame; chLines[i] = l
    end
    -- Outline line pool
    local chOutlines = {}
    for i = 1, 12 do
        local l = Instance.new("Frame"); l.BackgroundColor3 = Color3.new(0,0,0); l.BorderSizePixel = 0
        l.AnchorPoint = Vector2.new(0.5,0.5); l.Visible = false; l.ZIndex = 0; l.Parent = crosshairFrame; chOutlines[i] = l
    end
    local chDot = Instance.new("Frame"); chDot.BackgroundColor3 = Color3.new(1,1,1); chDot.BorderSizePixel = 0
    chDot.AnchorPoint = Vector2.new(0.5,0.5); chDot.Position = UDim2.new(0.5,0,0.5,0); chDot.Visible = false; chDot.Parent = crosshairFrame
    Instance.new("UICorner", chDot).CornerRadius = UDim.new(1,0)
    local chOutlineDot = Instance.new("Frame"); chOutlineDot.BackgroundColor3 = Color3.new(0,0,0); chOutlineDot.BorderSizePixel = 0
    chOutlineDot.AnchorPoint = Vector2.new(0.5,0.5); chOutlineDot.Position = UDim2.new(0.5,0,0.5,0); chOutlineDot.Visible = false; chOutlineDot.ZIndex = 0; chOutlineDot.Parent = crosshairFrame
    Instance.new("UICorner", chOutlineDot).CornerRadius = UDim.new(1,0)
    -- Circle crosshair
    local chCircle = Instance.new("Frame"); chCircle.BackgroundTransparency = 1; chCircle.BorderSizePixel = 0
    chCircle.AnchorPoint = Vector2.new(0.5,0.5); chCircle.Position = UDim2.new(0.5,0,0.5,0); chCircle.Visible = false; chCircle.Parent = crosshairFrame
    Instance.new("UICorner", chCircle).CornerRadius = UDim.new(1,0)
    local chCircleStroke = Instance.new("UIStroke", chCircle); chCircleStroke.Color = Color3.new(1,1,1); chCircleStroke.Thickness = 2

    local function setLine(idx, cx, cy, w, h, color, opacity)
        local l = chLines[idx]; if not l then return end
        l.Size = UDim2.new(0,w,0,h); l.Position = UDim2.new(0,cx,0,cy)
        l.BackgroundColor3 = color; l.BackgroundTransparency = 1 - opacity; l.Visible = true
    end
    local function setOutline(idx, cx, cy, w, h, color, thickness, opacity)
        local l = chOutlines[idx]; if not l then return end
        l.Size = UDim2.new(0,w+thickness*2,0,h+thickness*2); l.Position = UDim2.new(0,cx,0,cy)
        l.BackgroundColor3 = color; l.BackgroundTransparency = 1 - opacity; l.Visible = true
    end

    local function updateCrosshair()
        local s = Settings.Crosshair
        crosshairFrame.Visible = s.Enabled
        if not s.Enabled then return end

        -- Reset
        for i = 1, 12 do chLines[i].Visible = false; chOutlines[i].Visible = false end
        chDot.Visible = false; chOutlineDot.Visible = false; chCircle.Visible = false

        local color = s.RainbowColor and Color3.fromHSV(tick()%3/3, 1, 1) or s.Color
        local outlineColor = s.OutlineColor
        local opacity = s.Opacity
        local outlineOpacity = opacity
        local t, sz, gap, thick = s.Thickness, s.Size, s.Gap, s.OutlineThickness

        -- Dynamic spread: expand gap based on velocity
        local dynamicGap = gap
        if s.DynamicSpread then
            local char = player.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local vel = Vector3.new(hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z).Magnitude
                    dynamicGap = gap + math.floor(vel * 0.15)
                end
            end
        end

        local cx, cy = crosshairFrame.AbsoluteSize.X/2, crosshairFrame.AbsoluteSize.Y/2

        if s.Style == "Cross" or s.Style == "Cross+Dot" or s.Style == "T-Shape" then
            -- Top
            if s.Style ~= "T-Shape" then
                if s.OutlineEnabled then setOutline(1, cx, cy-(dynamicGap+sz/2+t/2), t, sz, outlineColor, thick, outlineOpacity) end
                setLine(1, cx, cy-(dynamicGap+sz/2+t/2), t, sz, color, opacity)
            end
            -- Bottom
            if s.OutlineEnabled then setOutline(2, cx, cy+(dynamicGap+sz/2+t/2), t, sz, outlineColor, thick, outlineOpacity) end
            setLine(2, cx, cy+(dynamicGap+sz/2+t/2), t, sz, color, opacity)
            -- Left
            if s.OutlineEnabled then setOutline(3, cx-(dynamicGap+sz/2+t/2), cy, sz, t, outlineColor, thick, outlineOpacity) end
            setLine(3, cx-(dynamicGap+sz/2+t/2), cy, sz, t, color, opacity)
            -- Right
            if s.OutlineEnabled then setOutline(4, cx+(dynamicGap+sz/2+t/2), cy, sz, t, outlineColor, thick, outlineOpacity) end
            setLine(4, cx+(dynamicGap+sz/2+t/2), cy, sz, t, color, opacity)
            if s.Style == "Cross+Dot" or s.CenterDot then
                local ds = s.CenterDotSize
                if s.OutlineEnabled then chOutlineDot.Size = UDim2.new(0,ds+thick*2,0,ds+thick*2); chOutlineDot.BackgroundColor3 = outlineColor; chOutlineDot.BackgroundTransparency = 1-outlineOpacity; chOutlineDot.Visible = true end
                chDot.Size = UDim2.new(0,ds,0,ds); chDot.BackgroundColor3 = color; chDot.BackgroundTransparency = 1-opacity; chDot.Visible = true
            end

        elseif s.Style == "X-Shape" then
            -- diagonal lines simulated via rotation frames
            for i, rot in ipairs({45, -45}) do
                local li = chLines[i]; local oi = chOutlines[i]
                if s.OutlineEnabled then
                    oi.Size = UDim2.new(0,t+thick*2, 0, sz*2+dynamicGap*2+thick*2)
                    oi.Position = UDim2.new(0,cx,0,cy); oi.Rotation = rot
                    oi.BackgroundColor3 = outlineColor; oi.BackgroundTransparency = 1-outlineOpacity; oi.Visible = true
                end
                li.Size = UDim2.new(0,t,0,sz*2+dynamicGap*2); li.Position = UDim2.new(0,cx,0,cy); li.Rotation = rot
                li.BackgroundColor3 = color; li.BackgroundTransparency = 1-opacity; li.Visible = true
            end

        elseif s.Style == "Dot" then
            local ds = s.Size
            if s.OutlineEnabled then chOutlineDot.Size = UDim2.new(0,ds+thick*2,0,ds+thick*2); chOutlineDot.BackgroundColor3 = outlineColor; chOutlineDot.BackgroundTransparency = 1-outlineOpacity; chOutlineDot.Visible = true end
            chDot.Size = UDim2.new(0,ds,0,ds); chDot.BackgroundColor3 = color; chDot.BackgroundTransparency = 1-opacity; chDot.Visible = true

        elseif s.Style == "Circle" then
            chCircle.Size = UDim2.new(0,sz*2,0,sz*2); chCircle.Position = UDim2.new(0,cx-sz,0,cy-sz)
            chCircleStroke.Color = color; chCircleStroke.Thickness = t; chCircle.BackgroundTransparency = 1
            chCircle.Visible = true
            if s.CenterDot then
                local ds = s.CenterDotSize
                chDot.Size = UDim2.new(0,ds,0,ds); chDot.BackgroundColor3 = color; chDot.BackgroundTransparency = 1-opacity; chDot.Visible = true
            end

        elseif s.Style == "Reticle" then
            -- Circle + cross gap
            chCircle.Size = UDim2.new(0,sz*2,0,sz*2); chCircle.Position = UDim2.new(0,cx-sz,0,cy-sz)
            chCircleStroke.Color = color; chCircleStroke.Thickness = t; chCircle.BackgroundTransparency = 1; chCircle.Visible = true
            if s.OutlineEnabled then setOutline(1, cx, cy-(dynamicGap+sz/2+t/2), t, sz/2, outlineColor, thick, outlineOpacity) end
            setLine(1, cx, cy-(dynamicGap+sz/2+t/2), t, sz/2, color, opacity)
            if s.OutlineEnabled then setOutline(2, cx, cy+(dynamicGap+sz/2+t/2), t, sz/2, outlineColor, thick, outlineOpacity) end
            setLine(2, cx, cy+(dynamicGap+sz/2+t/2), t, sz/2, color, opacity)

        elseif s.Style == "Sniper" then
            -- Full-screen cross lines (thin) + center gap + dot
            local screen = screenGui and screenGui.AbsoluteSize or Vector2.new(800,600)
            local halfW = screen.X/2; local halfH = screen.Y/2
            if s.OutlineEnabled then setOutline(1, cx, cy, t, halfH*2, outlineColor, thick, outlineOpacity) end
            setLine(1, cx, cy, t, halfH*2, color, opacity * 0.6)
            if s.OutlineEnabled then setOutline(2, cx, cy, halfW*2, t, outlineColor, thick, outlineOpacity) end
            setLine(2, cx, cy, halfW*2, t, color, opacity * 0.6)
            -- center gap (black box to cut out center)
            local gapBox = Instance.new("Frame"); gapBox.Size = UDim2.new(0,dynamicGap*2+t*2,0,dynamicGap*2+t*2)
            gapBox.Position = UDim2.new(0,cx-(dynamicGap+t),0,cy-(dynamicGap+t))
            gapBox.BackgroundColor3 = Color3.fromRGB(0,0,0); gapBox.BackgroundTransparency = 0; gapBox.BorderSizePixel = 0; gapBox.Parent = crosshairFrame
            task.defer(function() if gapBox and gapBox.Parent then gapBox:Destroy() end end)
            -- dot
            local ds = s.CenterDotSize
            chDot.Size = UDim2.new(0,ds,0,ds); chDot.BackgroundColor3 = color; chDot.BackgroundTransparency = 1-opacity; chDot.Visible = true

        elseif s.Style == "KV" then
            -- Unique "knife-to-V" style: two diagonal arms going downward forming a V shape
            for i, ang in ipairs({-35, 35}) do
                local arm = chLines[i]; local aOut = chOutlines[i]
                if s.OutlineEnabled then
                    aOut.Size = UDim2.new(0,t+thick*2,0,sz+thick*2); aOut.Position = UDim2.new(0,cx,0,cy)
                    aOut.Rotation = ang; aOut.BackgroundColor3 = outlineColor; aOut.BackgroundTransparency = 1-outlineOpacity; aOut.AnchorPoint = Vector2.new(0.5,0); aOut.Visible = true
                end
                arm.Size = UDim2.new(0,t,0,sz); arm.Position = UDim2.new(0,cx,0,cy)
                arm.Rotation = ang; arm.BackgroundColor3 = color; arm.BackgroundTransparency = 1-opacity; arm.AnchorPoint = Vector2.new(0.5,0); arm.Visible = true
            end
            -- horizontal top bar
            if s.OutlineEnabled then setOutline(3, cx, cy, sz*2, t, outlineColor, thick, outlineOpacity) end
            setLine(3, cx, cy, sz*2, t, color, opacity)
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
            if speedVelocity then pcall(function() speedVelocity:Destroy() end); speedVelocity = nil end; return
        end
        local method = Settings.Movement.SpeedMethod
        if method == "WalkSpeed" then if speedVelocity then pcall(function() speedVelocity:Destroy() end); speedVelocity = nil end; return end
        local char = player.Character; if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart"); local humanoid = char:FindFirstChild("Humanoid")
        if not hrp or not humanoid then return end; humanoid.WalkSpeed = 16
        local moveDir = humanoid.MoveDirection
        if moveDir.Magnitude < 0.1 then if speedVelocity then pcall(function() speedVelocity:Destroy() end); speedVelocity = nil end; return end
        local speed = Settings.Movement.Speed
        if method == "CFrame" then
            if speedVelocity then pcall(function() speedVelocity:Destroy() end); speedVelocity = nil end
            local worldMove = moveDir * speed * dt; hrp.CFrame = hrp.CFrame + Vector3.new(worldMove.X,0,worldMove.Z)
        elseif method == "Velocity" then
            if not speedVelocity or speedVelocity.Parent ~= hrp then
                if speedVelocity then pcall(function() speedVelocity:Destroy() end) end
                speedVelocity = Instance.new("BodyVelocity"); speedVelocity.Name = "BinxixSpeedVelocity"
                speedVelocity.MaxForce = Vector3.new(100000,0,100000); speedVelocity.P = 10000; speedVelocity.Parent = hrp
            end
            speedVelocity.Velocity = moveDir * speed
        end
    end)
    table.insert(allConnections, speedMethodConn)

    -- ======================================================
    -- BUNNY HOP
    -- ======================================================
    local bhopVelocity = nil; local lastJumpTime = 0; local currentBhopSpeed = 0
    local bunnyHopConn = RunService.RenderStepped:Connect(function(deltaTime)
        if isUnloading or _G.BinxixUnloaded then return end
        if not Settings.Movement.BunnyHop then
            if bhopVelocity then bhopVelocity:Destroy(); bhopVelocity = nil end; currentBhopSpeed = 0; return
        end
        local char = player.Character; if not char then return end
        local humanoid = char:FindFirstChild("Humanoid"); local hrp = char:FindFirstChild("HumanoidRootPart")
        if not humanoid or not hrp then return end
        local isHoldingSpace = UserInputService:IsKeyDown(Enum.KeyCode.Space)
        local isGrounded = humanoid:GetState() ~= Enum.HumanoidStateType.Jumping and humanoid:GetState() ~= Enum.HumanoidStateType.Freefall
        local targetBhopSpeed = 16 + (Settings.Movement.BunnyHopSpeed/100)*64
        if isHoldingSpace then
            if isGrounded then humanoid:ChangeState(Enum.HumanoidStateType.Jumping); lastJumpTime = tick() end
            if not isGrounded then
                local camera = Workspace.CurrentCamera
                if camera then
                    local lookVector = camera.CFrame.LookVector; local forwardDir = Vector3.new(lookVector.X,0,lookVector.Z).Unit
                    currentBhopSpeed = currentBhopSpeed + (targetBhopSpeed - currentBhopSpeed) * math.min(deltaTime*5,1)
                    if not bhopVelocity or bhopVelocity.Parent ~= hrp then
                        if bhopVelocity then bhopVelocity:Destroy() end
                        bhopVelocity = Instance.new("BodyVelocity"); bhopVelocity.Name = "BinxixBhopVelocity"
                        bhopVelocity.MaxForce = Vector3.new(8000,0,8000); bhopVelocity.P = 1000; bhopVelocity.Parent = hrp
                    end
                    bhopVelocity.Velocity = forwardDir * currentBhopSpeed
                end
            else
                if bhopVelocity and (tick()-lastJumpTime) > 0.08 then bhopVelocity:Destroy(); bhopVelocity = nil end
                currentBhopSpeed = currentBhopSpeed * 0.85
            end
        else
            if bhopVelocity then bhopVelocity:Destroy(); bhopVelocity = nil end; currentBhopSpeed = 0
        end
    end)
    table.insert(allConnections, bunnyHopConn)

    -- FOV maintenance
    local fovMaintainConn = RunService.RenderStepped:Connect(function()
        if isUnloading or _G.BinxixUnloaded then return end
        if Settings.Visuals.CustomFOV then
            local camera = Workspace.CurrentCamera
            if camera and camera.FieldOfView ~= Settings.Visuals.FOVAmount then camera.FieldOfView = Settings.Visuals.FOVAmount end
        end
    end)
    table.insert(allConnections, fovMaintainConn)

    -- Fly loop
    local flyConn = RunService.RenderStepped:Connect(function()
        if isUnloading or _G.BinxixUnloaded then return end
        if Settings.Movement.Fly and isFlying then
            local char = player.Character; if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp or not flyBodyVelocity or not flyBodyGyro then return end
            local camera = Workspace.CurrentCamera; local flySpeed = Settings.Movement.FlySpeed
            local moveDirection = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDirection = moveDirection - Vector3.new(0,1,0) end
            if moveDirection.Magnitude > 0 then moveDirection = moveDirection.Unit end
            flyBodyVelocity.Velocity = moveDirection * flySpeed; flyBodyGyro.CFrame = camera.CFrame
        elseif not Settings.Movement.Fly and isFlying then stopFly() end
    end)
    table.insert(allConnections, flyConn)

    -- Anti-AFK
    local virtualUser = game:GetService("VirtualUser")
    local antiAfkConn = player.Idled:Connect(function()
        if Settings.Misc.AntiAFK then virtualUser:CaptureController(); virtualUser:ClickButton2(Vector2.new()) end
    end)
    table.insert(allConnections, antiAfkConn)

    -- Gun mod maintenance
    local lastGunModCheck = 0
    local gunModConn = RunService.Heartbeat:Connect(function()
        if isUnloading or _G.BinxixUnloaded then return end
        local now = tick(); if now - lastGunModCheck < 2 then return end; lastGunModCheck = now
        local anyEnabled = Settings.Combat.FastReload or Settings.Combat.FastFireRate or Settings.Combat.AlwaysAuto or Settings.Combat.NoSpread or Settings.Combat.NoRecoil
        if not anyEnabled then return end
        if not weaponCacheBuilt then buildWeaponCache() end
        for _, v in ipairs(weaponValueCache) do
            if v and v.Parent then
                local n = v.Name
                if Settings.Combat.FastReload and (n=="ReloadTime" or n=="EReloadTime") and v.Value ~= 0.01 then v.Value = 0.01
                elseif Settings.Combat.FastFireRate and (n=="FireRate" or n=="BFireRate") and v.Value ~= 0.02 then v.Value = 0.02
                elseif Settings.Combat.AlwaysAuto and (n=="Auto" or n=="AutoFire" or n=="Automatic" or n=="AutoShoot" or n=="AutoGun") and v.Value ~= true then v.Value = true
                elseif Settings.Combat.NoSpread and (n=="MaxSpread" or n=="Spread" or n=="SpreadControl") and v.Value ~= 0 then v.Value = 0
                elseif Settings.Combat.NoRecoil and (n=="RecoilControl" or n=="Recoil") and v.Value ~= 0 then v.Value = 0 end
            end
        end
    end)
    table.insert(allConnections, gunModConn)

    -- Chat spammer
    local lastChatSpam = 0
    local chatSpamConn = RunService.Heartbeat:Connect(function()
        if isUnloading or _G.BinxixUnloaded then return end
        if not Settings.Misc.ChatSpammer then return end
        local now = tick(); if now - lastChatSpam < Settings.Misc.ChatSpamDelay then return end
        local message = Settings.Misc.ChatSpamMessage; if message == "" then return end; lastChatSpam = now
        pcall(function()
            local textChatService = game:GetService("TextChatService"); local channels = textChatService:FindFirstChild("TextChannels")
            if channels then local rbxGeneral = channels:FindFirstChild("RBXGeneral"); if rbxGeneral then rbxGeneral:SendAsync(message) end end
        end)
        pcall(function() local remote = game:GetService("ReplicatedStorage"):FindFirstChild("SayMessageRequest", true); if remote then local sm = remote:FindFirstChild("SayMessageRequest"); if sm then sm:FireServer(message, "All") end end end)
    end)
    table.insert(allConnections, chatSpamConn)

    -- Chat spy
    local function addChatLog(playerName, message, channel)
        local entry = {time=os.date("%H:%M:%S"), player=playerName, msg=message, channel=channel or "All"}
        table.insert(chatSpyLog, 1, entry); if #chatSpyLog > MAX_CHAT_LOG then table.remove(chatSpyLog) end
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
                        local sender = msgObj.TextSource; if not sender then return end
                        local senderPlayer = Players:GetPlayerByUserId(sender.UserId); if not senderPlayer then return end
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
        if plr ~= player then pcall(function() plr.Chatted:Connect(function(msg) if not chatSpyEnabled then return end; addChatLog(plr.DisplayName.." (@"..plr.Name..")", msg, "All") end) end) end
    end
    local chatSpyPlayerConn = Players.PlayerAdded:Connect(function(plr)
        pcall(function() plr.Chatted:Connect(function(msg) if not chatSpyEnabled then return end; addChatLog(plr.DisplayName.." (@"..plr.Name..")", msg, "All") end) end)
    end)
    table.insert(allConnections, chatSpyPlayerConn)

    -- FPS + Velocity display
    local fpsContainer = Instance.new("Frame"); fpsContainer.Name = "FPSContainer"
    fpsContainer.Size = UDim2.new(0,100,0,26); fpsContainer.Position = UDim2.new(1,-110,0,10)
    fpsContainer.BackgroundColor3 = Color3.fromRGB(20,20,25); fpsContainer.BackgroundTransparency = 0.3
    fpsContainer.BorderSizePixel = 1; fpsContainer.BorderColor3 = Theme.Border; fpsContainer.Visible = false; fpsContainer.Parent = screenGui
    local fpsLabel = Instance.new("TextLabel"); fpsLabel.Size = UDim2.new(1,-10,1,0); fpsLabel.Position = UDim2.new(0,5,0,0)
    fpsLabel.BackgroundTransparency = 1; fpsLabel.Text = "FPS: 0"; fpsLabel.TextColor3 = Theme.AccentBright
    fpsLabel.TextSize = 14; fpsLabel.Font = Enum.Font.SourceSansBold; fpsLabel.TextXAlignment = Enum.TextXAlignment.Right; fpsLabel.Parent = fpsContainer
    local velocityLabel = Instance.new("TextLabel"); velocityLabel.Name = "VelocityLabel"
    velocityLabel.Size = UDim2.new(0,160,0,20); velocityLabel.Position = UDim2.new(0.5,40,0.5,25)
    velocityLabel.BackgroundTransparency = 1; velocityLabel.Text = "0.0 studs/s"; velocityLabel.TextColor3 = Theme.AccentPink
    velocityLabel.TextSize = 13; velocityLabel.Font = Enum.Font.SourceSansBold
    velocityLabel.TextStrokeTransparency = 0.5; velocityLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    velocityLabel.TextXAlignment = Enum.TextXAlignment.Left; velocityLabel.Visible = false; velocityLabel.Parent = screenGui
    local lastFpsUpdate = tick(); local frameCount = 0; local currentFps = 0
    local statsConn = RunService.RenderStepped:Connect(function()
        if isUnloading or _G.BinxixUnloaded then return end
        fpsContainer.Visible = Settings.Visuals.ShowFPS; velocityLabel.Visible = Settings.Visuals.ShowVelocity
        if Settings.Visuals.ShowFPS then
            frameCount = frameCount + 1
            if tick() - lastFpsUpdate >= 1 then currentFps = frameCount; frameCount = 0; lastFpsUpdate = tick() end
            fpsLabel.Text = "FPS: " .. tostring(currentFps)
        end
        if Settings.Visuals.ShowVelocity then
            local char = player.Character
            if char then local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then local vel = hrp.AssemblyLinearVelocity; velocityLabel.Text = string.format("%.1f studs/s", Vector3.new(vel.X,0,vel.Z).Magnitude) end
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
        if input.KeyCode == currentToggleKey then mainFrame.Visible = not mainFrame.Visible end
        if input.KeyCode == Enum.KeyCode.F then
            if Settings.Movement.Fly then if isFlying then stopFly() else startFly() end end
        end
        if input.KeyCode == autoTPToggleKey then
            if tabBuilt["General"] then
                autoTPEnabled = not autoTPEnabled; Settings.Misc.AutoTPLoop = autoTPEnabled
                if autoTPCheckbox then autoTPCheckbox.BackgroundColor3 = autoTPEnabled and Theme.CheckboxEnabled or Theme.CheckboxDisabled end
                if autoTPEnabled then startAutoTPLoop(); sendNotification("Auto TP", "On - targeting: " .. Settings.Misc.AutoTPTargetName, 2)
                else stopAutoTPLoop(); sendNotification("Auto TP", "Off", 2) end
            end
        end
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            if Settings.Aimbot.Enabled then
                if Settings.Aimbot.Toggle then
                    if toggleTrackingActive then toggleTrackingActive = false; stopAimbotTracking()
                    else toggleTrackingActive = true; startAimbotTracking() end
                else startAimbotTracking() end
            end
        end
    end)
    table.insert(allConnections, inputBeganConn)

    local inputEndedConn = UserInputService.InputEnded:Connect(function(input)
        if isUnloading or _G.BinxixUnloaded then return end
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            if Settings.Aimbot.Enabled and not Settings.Aimbot.Toggle then stopAimbotTracking() end
        end
    end)
    table.insert(allConnections, inputEndedConn)

    return screenGui
end

-- ===========================
-- INITIALIZE
-- ===========================
local gui = createGUI()

local loadedNotif = Instance.new("TextLabel"); loadedNotif.Size = UDim2.new(0,230,0,24)
loadedNotif.Position = UDim2.new(0.5,-115,1,-30); loadedNotif.BackgroundColor3 = Theme.BackgroundDark
loadedNotif.BorderSizePixel = 1; loadedNotif.BorderColor3 = Theme.Border
loadedNotif.Text = "Binxix Hub V6 Loaded"; loadedNotif.TextColor3 = Theme.AccentPink
loadedNotif.TextSize = 12; loadedNotif.Font = Enum.Font.SourceSans; loadedNotif.Parent = gui
task.spawn(function()
    task.wait(3)
    for i = 0, 1, 0.05 do loadedNotif.TextTransparency = i; loadedNotif.BackgroundTransparency = i; task.wait(0.02) end
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

-- Auto-load Default config on startup
task.delay(0.4, function()
    if currentGameData.noMovement then
        Settings.Movement.SpeedEnabled = false; Settings.Movement.Speed = 16; Settings.Movement.SpeedMethod = "WalkSpeed"
        Settings.Movement.JumpEnabled = false; Settings.Movement.JumpPower = 50; Settings.Movement.BunnyHop = false
        Settings.Movement.Fly = false; Settings.Misc.AutoTPLoop = false; Settings.Misc.AntiAFK = false
        stopFly(); stopAutoTPLoop()
        pcall(function()
            local char = player.Character
            if char then local h = char:FindFirstChild("Humanoid"); if h then h.WalkSpeed = 16; h.JumpPower = 50 end end
        end)
        sendNotification("BlockSpin", "Movement mods disabled for this game", 4)
        return
    end

    -- Auto-load Default profile if it exists
    pcall(function()
        if isfile then
            local defaultPath = "BinxixHubV6_Configs/Default.json"
            if isfile(defaultPath) then
                local success = loadProfile("Default")
                if success then sendNotification("Config", "Auto-loaded Default config", 2) end
            end
        end
    end)
end)

-- Version check
task.delay(8, function()
    local success, result = pcall(function() return game:HttpGet(VERSION_URL) end)
    if success and result then
        local latestVersion = tonumber(result:match("%d+"))
        if latestVersion and latestVersion > SCRIPT_VERSION then
            sendNotification("Update Available", "v6." .. latestVersion .. " is out. You have v6." .. SCRIPT_VERSION, 8)
        elseif latestVersion and latestVersion == SCRIPT_VERSION then
            sendNotification("Up to Date", "v6." .. SCRIPT_VERSION .. " is the latest", 3)
        end
    end
end)
