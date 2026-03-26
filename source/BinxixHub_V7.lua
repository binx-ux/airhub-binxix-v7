local SCRIPT_VERSION = "005"
local SCRIPT_VERSION_DISPLAY = "7."..SCRIPT_VERSION
local VERSION_URL = "https://raw.githubusercontent.com/binx-ux/binxix-hub-v7/main/VERSION"
local INTEGRITY_HASH = "binxix_v7_official"

if _G.BinxixCleanup then
    pcall(_G.BinxixCleanup)
end
_G.BinxixUnloaded = false

local function getExecutorName()
    local name = "Unknown"
    pcall(function()
        if identifyexecutor then name = identifyexecutor()
        elseif getexecutorname then name = getexecutorname() end
    end)
    return name
end

local STRONG_EXECUTORS = {"synapse","syn","fluxus","arceus","scriptware","oxygen u","wave","delta"}
local function isWeakExecutor()
    local name = getExecutorName():lower()
    for _, s in ipairs(STRONG_EXECUTORS) do if name:find(s) then return false end end
    return name=="unknown" or name:find("krnl") or name:find("evon") or name:find("jjsploit") or name:find("comet")
end

local function checkIntegrity()
    local ok = true
    pcall(function()
        if not getfenv or not syn then return end
        local env = getfenv(0)
        if env._INTEGRITY and env._INTEGRITY ~= INTEGRITY_HASH then ok = false end
    end)
    return ok
end


local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local TeleportService  = game:GetService("TeleportService")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace        = game:GetService("Workspace")
local Lighting         = game:GetService("Lighting")
local HttpService      = game:GetService("HttpService")
local player           = Players.LocalPlayer
local currentPlaceId   = game.PlaceId


do
    local StarterGui = game:GetService("StarterGui")
    local blockedGames = {
        [83728249169833]  = "Quick-Shot",
        [95721658376580]  = "MTC",
        [109397169461300] = "SNIPER DUELS",
    }
    local gameName = blockedGames[currentPlaceId]
    if gameName then
        pcall(function() StarterGui:SetCore("SendNotification",{Title="Binxix Hub V7",Text=gameName.." is not supported.",Duration=8}) end)
        warn("[Binxix Hub V7] Disabled on "..gameName)
        _G.BinxixUnloaded = true
        error("[Binxix Hub V7] Disabled on "..gameName)
    end
end

-- ====================================================================
-- binxix
-- ====================================================================
local UILib = {}

function UILib.newScreenGui(name)
    local sg = Instance.new("ScreenGui")
    sg.Name = name; sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.IgnoreGuiInset = true
    sg.Parent = player:WaitForChild("PlayerGui")
    return sg
end

function UILib.newFrame(parent, props)
    local f = Instance.new("Frame")
    for k,v in pairs(props or {}) do f[k] = v end
    f.Parent = parent; return f
end

function UILib.newLabel(parent, props)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    for k,v in pairs(props or {}) do l[k] = v end
    l.Parent = parent; return l
end

function UILib.newButton(parent, props, callback)
    local b = Instance.new("TextButton")
    for k,v in pairs(props or {}) do b[k] = v end
    b.Parent = parent
    if callback then b.MouseButton1Click:Connect(callback) end
    return b
end

function UILib.newBox(parent, props)
    local b = Instance.new("TextBox")
    for k,v in pairs(props or {}) do b[k] = v end
    b.Parent = parent; return b
end

function UILib.corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 6)
    c.Parent = parent; return c
end

function UILib.stroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color; s.Thickness = thickness or 1
    s.Parent = parent; return s
end

function UILib.tween(obj, time, props, style, dir)
    return TweenService:Create(obj,TweenInfo.new(time or 0.2,style or Enum.EasingStyle.Quart,dir or Enum.EasingDirection.Out),props)
end

-- ====================================================================
-- 3895nfk93
-- ====================================================================
local ThemePresets = {
    Purple = {
        WindowBg=Color3.fromRGB(28,28,33),WindowBorder=Color3.fromRGB(160,80,200),
        SidebarBg=Color3.fromRGB(20,20,24),SidebarBorder=Color3.fromRGB(45,45,55),
        LogoText=Color3.fromRGB(180,100,220),
        TabBg=Color3.fromRGB(28,28,34),TabBgHover=Color3.fromRGB(38,32,48),TabBgActive=Color3.fromRGB(160,70,200),
        TabText=Color3.fromRGB(140,130,155),TabTextActive=Color3.fromRGB(255,255,255),
        TabIcon=Color3.fromRGB(100,90,115),TabIconActive=Color3.fromRGB(255,255,255),
        ContentBg=Color3.fromRGB(22,22,28),
        CardBg=Color3.fromRGB(32,32,40),CardBorder=Color3.fromRGB(50,48,62),CardHeaderBg=Color3.fromRGB(140,65,180),CardHeaderText=Color3.fromRGB(255,255,255),
        ToggleOn=Color3.fromRGB(150,70,200),ToggleOff=Color3.fromRGB(55,55,68),ToggleKnob=Color3.fromRGB(255,255,255),
        SliderTrack=Color3.fromRGB(45,45,58),SliderFill=Color3.fromRGB(160,80,200),SliderKnob=Color3.fromRGB(200,120,240),
        TextPrimary=Color3.fromRGB(215,215,225),TextSecondary=Color3.fromRGB(140,135,155),TextDim=Color3.fromRGB(90,88,102),TextAccent=Color3.fromRGB(185,100,230),
        EnumBg=Color3.fromRGB(42,40,52),EnumBgActive=Color3.fromRGB(140,65,180),EnumText=Color3.fromRGB(180,175,195),EnumTextActive=Color3.fromRGB(255,255,255),
        KeybindBg=Color3.fromRGB(42,40,52),KeybindText=Color3.fromRGB(185,100,230),
        InputBg=Color3.fromRGB(20,20,26),InputBorder=Color3.fromRGB(65,62,80),
        WarnColor=Color3.fromRGB(255,160,50),
        ESP_Close=Color3.fromRGB(255,60,60),ESP_Medium=Color3.fromRGB(255,180,50),ESP_Far=Color3.fromRGB(255,255,80),ESP_VeryFar=Color3.fromRGB(80,255,80),
        RadarBg=Color3.fromRGB(14,12,18),RadarBorder=Color3.fromRGB(120,60,160),
    },
    Blue = {
        WindowBg=Color3.fromRGB(22,26,34),WindowBorder=Color3.fromRGB(60,120,220),
        SidebarBg=Color3.fromRGB(15,18,26),SidebarBorder=Color3.fromRGB(35,45,60),
        LogoText=Color3.fromRGB(80,160,255),
        TabBg=Color3.fromRGB(22,26,34),TabBgHover=Color3.fromRGB(28,36,52),TabBgActive=Color3.fromRGB(50,110,210),
        TabText=Color3.fromRGB(110,125,150),TabTextActive=Color3.fromRGB(255,255,255),
        TabIcon=Color3.fromRGB(80,100,130),TabIconActive=Color3.fromRGB(255,255,255),
        ContentBg=Color3.fromRGB(18,22,30),
        CardBg=Color3.fromRGB(26,32,44),CardBorder=Color3.fromRGB(40,55,75),CardHeaderBg=Color3.fromRGB(45,100,200),CardHeaderText=Color3.fromRGB(255,255,255),
        ToggleOn=Color3.fromRGB(50,120,220),ToggleOff=Color3.fromRGB(40,50,68),ToggleKnob=Color3.fromRGB(255,255,255),
        SliderTrack=Color3.fromRGB(35,45,62),SliderFill=Color3.fromRGB(60,130,220),SliderKnob=Color3.fromRGB(100,170,255),
        TextPrimary=Color3.fromRGB(210,220,235),TextSecondary=Color3.fromRGB(130,145,170),TextDim=Color3.fromRGB(80,95,120),TextAccent=Color3.fromRGB(100,165,255),
        EnumBg=Color3.fromRGB(30,40,58),EnumBgActive=Color3.fromRGB(45,100,200),EnumText=Color3.fromRGB(160,175,200),EnumTextActive=Color3.fromRGB(255,255,255),
        KeybindBg=Color3.fromRGB(30,40,58),KeybindText=Color3.fromRGB(100,165,255),
        InputBg=Color3.fromRGB(15,20,30),InputBorder=Color3.fromRGB(45,60,85),
        WarnColor=Color3.fromRGB(255,160,50),
        ESP_Close=Color3.fromRGB(255,60,60),ESP_Medium=Color3.fromRGB(255,180,50),ESP_Far=Color3.fromRGB(255,255,80),ESP_VeryFar=Color3.fromRGB(80,255,80),
        RadarBg=Color3.fromRGB(10,14,22),RadarBorder=Color3.fromRGB(50,110,210),
    },
    Red = {
        WindowBg=Color3.fromRGB(30,22,22),WindowBorder=Color3.fromRGB(200,60,60),
        SidebarBg=Color3.fromRGB(22,15,15),SidebarBorder=Color3.fromRGB(55,38,38),
        LogoText=Color3.fromRGB(240,100,100),
        TabBg=Color3.fromRGB(30,22,22),TabBgHover=Color3.fromRGB(44,28,28),TabBgActive=Color3.fromRGB(185,50,50),
        TabText=Color3.fromRGB(140,115,115),TabTextActive=Color3.fromRGB(255,255,255),
        TabIcon=Color3.fromRGB(110,80,80),TabIconActive=Color3.fromRGB(255,255,255),
        ContentBg=Color3.fromRGB(24,17,17),
        CardBg=Color3.fromRGB(38,28,28),CardBorder=Color3.fromRGB(62,42,42),CardHeaderBg=Color3.fromRGB(180,50,50),CardHeaderText=Color3.fromRGB(255,255,255),
        ToggleOn=Color3.fromRGB(200,60,60),ToggleOff=Color3.fromRGB(62,45,45),ToggleKnob=Color3.fromRGB(255,255,255),
        SliderTrack=Color3.fromRGB(52,35,35),SliderFill=Color3.fromRGB(210,70,70),SliderKnob=Color3.fromRGB(245,105,105),
        TextPrimary=Color3.fromRGB(225,215,215),TextSecondary=Color3.fromRGB(160,135,135),TextDim=Color3.fromRGB(110,85,85),TextAccent=Color3.fromRGB(240,100,100),
        EnumBg=Color3.fromRGB(48,32,32),EnumBgActive=Color3.fromRGB(180,50,50),EnumText=Color3.fromRGB(185,160,160),EnumTextActive=Color3.fromRGB(255,255,255),
        KeybindBg=Color3.fromRGB(48,32,32),KeybindText=Color3.fromRGB(240,100,100),
        InputBg=Color3.fromRGB(20,14,14),InputBorder=Color3.fromRGB(75,50,50),
        WarnColor=Color3.fromRGB(255,160,50),
        ESP_Close=Color3.fromRGB(255,60,60),ESP_Medium=Color3.fromRGB(255,180,50),ESP_Far=Color3.fromRGB(255,255,80),ESP_VeryFar=Color3.fromRGB(80,255,80),
        RadarBg=Color3.fromRGB(16,10,10),RadarBorder=Color3.fromRGB(190,50,50),
    },
    Green = {
        WindowBg=Color3.fromRGB(20,28,22),WindowBorder=Color3.fromRGB(50,180,80),
        SidebarBg=Color3.fromRGB(14,20,15),SidebarBorder=Color3.fromRGB(35,55,38),
        LogoText=Color3.fromRGB(80,220,120),
        TabBg=Color3.fromRGB(20,28,22),TabBgHover=Color3.fromRGB(26,40,30),TabBgActive=Color3.fromRGB(40,160,70),
        TabText=Color3.fromRGB(110,140,115),TabTextActive=Color3.fromRGB(255,255,255),
        TabIcon=Color3.fromRGB(75,110,80),TabIconActive=Color3.fromRGB(255,255,255),
        ContentBg=Color3.fromRGB(16,24,18),
        CardBg=Color3.fromRGB(24,36,26),CardBorder=Color3.fromRGB(38,62,42),CardHeaderBg=Color3.fromRGB(38,155,65),CardHeaderText=Color3.fromRGB(255,255,255),
        ToggleOn=Color3.fromRGB(50,190,80),ToggleOff=Color3.fromRGB(40,60,44),ToggleKnob=Color3.fromRGB(255,255,255),
        SliderTrack=Color3.fromRGB(30,50,34),SliderFill=Color3.fromRGB(55,195,85),SliderKnob=Color3.fromRGB(85,225,120),
        TextPrimary=Color3.fromRGB(215,228,218),TextSecondary=Color3.fromRGB(135,160,140),TextDim=Color3.fromRGB(85,108,90),TextAccent=Color3.fromRGB(80,222,120),
        EnumBg=Color3.fromRGB(28,48,32),EnumBgActive=Color3.fromRGB(38,155,65),EnumText=Color3.fromRGB(160,185,165),EnumTextActive=Color3.fromRGB(255,255,255),
        KeybindBg=Color3.fromRGB(28,48,32),KeybindText=Color3.fromRGB(80,222,120),
        InputBg=Color3.fromRGB(12,20,14),InputBorder=Color3.fromRGB(42,72,48),
        WarnColor=Color3.fromRGB(255,160,50),
        ESP_Close=Color3.fromRGB(255,60,60),ESP_Medium=Color3.fromRGB(255,180,50),ESP_Far=Color3.fromRGB(255,255,80),ESP_VeryFar=Color3.fromRGB(80,255,80),
        RadarBg=Color3.fromRGB(10,18,12),RadarBorder=Color3.fromRGB(45,170,75),
    },
    Cyan = {
        WindowBg=Color3.fromRGB(14,26,30),WindowBorder=Color3.fromRGB(40,200,220),
        SidebarBg=Color3.fromRGB(9,18,22),SidebarBorder=Color3.fromRGB(28,52,62),
        LogoText=Color3.fromRGB(70,230,255),
        TabBg=Color3.fromRGB(14,26,30),TabBgHover=Color3.fromRGB(18,38,46),TabBgActive=Color3.fromRGB(28,175,200),
        TabText=Color3.fromRGB(100,135,145),TabTextActive=Color3.fromRGB(255,255,255),
        TabIcon=Color3.fromRGB(65,110,125),TabIconActive=Color3.fromRGB(255,255,255),
        ContentBg=Color3.fromRGB(10,20,24),
        CardBg=Color3.fromRGB(18,34,40),CardBorder=Color3.fromRGB(30,58,70),CardHeaderBg=Color3.fromRGB(25,170,195),CardHeaderText=Color3.fromRGB(255,255,255),
        ToggleOn=Color3.fromRGB(35,200,220),ToggleOff=Color3.fromRGB(30,58,68),ToggleKnob=Color3.fromRGB(255,255,255),
        SliderTrack=Color3.fromRGB(18,44,54),SliderFill=Color3.fromRGB(38,200,220),SliderKnob=Color3.fromRGB(70,232,255),
        TextPrimary=Color3.fromRGB(208,230,236),TextSecondary=Color3.fromRGB(125,158,170),TextDim=Color3.fromRGB(75,108,120),TextAccent=Color3.fromRGB(70,232,255),
        EnumBg=Color3.fromRGB(18,40,50),EnumBgActive=Color3.fromRGB(25,170,195),EnumText=Color3.fromRGB(155,185,196),EnumTextActive=Color3.fromRGB(255,255,255),
        KeybindBg=Color3.fromRGB(18,40,50),KeybindText=Color3.fromRGB(70,232,255),
        InputBg=Color3.fromRGB(8,16,20),InputBorder=Color3.fromRGB(32,65,80),
        WarnColor=Color3.fromRGB(255,160,50),
        ESP_Close=Color3.fromRGB(255,60,60),ESP_Medium=Color3.fromRGB(255,180,50),ESP_Far=Color3.fromRGB(255,255,80),ESP_VeryFar=Color3.fromRGB(80,255,80),
        RadarBg=Color3.fromRGB(6,16,20),RadarBorder=Color3.fromRGB(35,190,210),
    },
    Midnight = {
        WindowBg=Color3.fromRGB(10,10,14),WindowBorder=Color3.fromRGB(80,80,200),
        SidebarBg=Color3.fromRGB(6,6,9),SidebarBorder=Color3.fromRGB(28,28,42),
        LogoText=Color3.fromRGB(120,120,255),
        TabBg=Color3.fromRGB(10,10,14),TabBgHover=Color3.fromRGB(16,16,24),TabBgActive=Color3.fromRGB(65,65,185),
        TabText=Color3.fromRGB(100,100,125),TabTextActive=Color3.fromRGB(255,255,255),
        TabIcon=Color3.fromRGB(70,70,100),TabIconActive=Color3.fromRGB(255,255,255),
        ContentBg=Color3.fromRGB(8,8,12),
        CardBg=Color3.fromRGB(14,14,20),CardBorder=Color3.fromRGB(30,30,48),CardHeaderBg=Color3.fromRGB(65,65,185),CardHeaderText=Color3.fromRGB(255,255,255),
        ToggleOn=Color3.fromRGB(80,80,210),ToggleOff=Color3.fromRGB(30,30,48),ToggleKnob=Color3.fromRGB(255,255,255),
        SliderTrack=Color3.fromRGB(20,20,32),SliderFill=Color3.fromRGB(85,85,210),SliderKnob=Color3.fromRGB(125,125,255),
        TextPrimary=Color3.fromRGB(198,198,215),TextSecondary=Color3.fromRGB(125,125,148),TextDim=Color3.fromRGB(75,75,100),TextAccent=Color3.fromRGB(125,125,255),
        EnumBg=Color3.fromRGB(18,18,28),EnumBgActive=Color3.fromRGB(65,65,185),EnumText=Color3.fromRGB(155,155,178),EnumTextActive=Color3.fromRGB(255,255,255),
        KeybindBg=Color3.fromRGB(18,18,28),KeybindText=Color3.fromRGB(125,125,255),
        InputBg=Color3.fromRGB(5,5,8),InputBorder=Color3.fromRGB(35,35,55),
        WarnColor=Color3.fromRGB(255,160,50),
        ESP_Close=Color3.fromRGB(255,60,60),ESP_Medium=Color3.fromRGB(255,180,50),ESP_Far=Color3.fromRGB(255,255,80),ESP_VeryFar=Color3.fromRGB(80,255,80),
        RadarBg=Color3.fromRGB(4,4,10),RadarBorder=Color3.fromRGB(70,70,190),
    },
    Rose = {
        WindowBg=Color3.fromRGB(28,22,26),WindowBorder=Color3.fromRGB(220,80,140),
        SidebarBg=Color3.fromRGB(20,15,18),SidebarBorder=Color3.fromRGB(55,38,48),
        LogoText=Color3.fromRGB(255,110,170),
        TabBg=Color3.fromRGB(28,22,26),TabBgHover=Color3.fromRGB(42,28,36),TabBgActive=Color3.fromRGB(200,60,120),
        TabText=Color3.fromRGB(140,115,128),TabTextActive=Color3.fromRGB(255,255,255),
        TabIcon=Color3.fromRGB(110,80,95),TabIconActive=Color3.fromRGB(255,255,255),
        ContentBg=Color3.fromRGB(22,17,20),
        CardBg=Color3.fromRGB(36,26,32),CardBorder=Color3.fromRGB(60,42,52),CardHeaderBg=Color3.fromRGB(195,55,115),CardHeaderText=Color3.fromRGB(255,255,255),
        ToggleOn=Color3.fromRGB(215,65,130),ToggleOff=Color3.fromRGB(58,40,50),ToggleKnob=Color3.fromRGB(255,255,255),
        SliderTrack=Color3.fromRGB(48,35,42),SliderFill=Color3.fromRGB(218,72,138),SliderKnob=Color3.fromRGB(255,115,175),
        TextPrimary=Color3.fromRGB(225,215,222),TextSecondary=Color3.fromRGB(158,138,148),TextDim=Color3.fromRGB(108,88,98),TextAccent=Color3.fromRGB(255,115,175),
        EnumBg=Color3.fromRGB(46,32,40),EnumBgActive=Color3.fromRGB(195,55,115),EnumText=Color3.fromRGB(185,158,170),EnumTextActive=Color3.fromRGB(255,255,255),
        KeybindBg=Color3.fromRGB(46,32,40),KeybindText=Color3.fromRGB(255,115,175),
        InputBg=Color3.fromRGB(18,12,16),InputBorder=Color3.fromRGB(72,48,60),
        WarnColor=Color3.fromRGB(255,160,50),
        ESP_Close=Color3.fromRGB(255,60,60),ESP_Medium=Color3.fromRGB(255,180,50),ESP_Far=Color3.fromRGB(255,255,80),ESP_VeryFar=Color3.fromRGB(80,255,80),
        RadarBg=Color3.fromRGB(16,10,14),RadarBorder=Color3.fromRGB(210,70,130),
    },
}

local currentThemeName = "Purple"
local Theme = {}
for k,v in pairs(ThemePresets.Purple) do Theme[k] = v end

local function syncLegacyKeys()
    Theme.Background=Theme.ContentBg; Theme.BackgroundDark=Theme.SidebarBg; Theme.BackgroundLight=Theme.CardBg
    Theme.AccentPink=Theme.CardHeaderBg; Theme.AccentBright=Theme.TextAccent; Theme.AccentDark=Theme.TabBgActive
    Theme.Accent=Theme.CardHeaderBg; Theme.Border=Theme.CardBorder; Theme.BorderLight=Theme.EnumBg
    Theme.TabActive=Theme.TabTextActive; Theme.TabInactive=Theme.TabText; Theme.TitleBar=Theme.SidebarBg
    Theme.CheckboxEnabled=Theme.ToggleOn; Theme.CheckboxDisabled=Theme.ToggleOff
    Theme.SliderBackground=Theme.SliderTrack
end

local themeCallbacks = {}
local function applyTheme(name)
    local p = ThemePresets[name]; if not p then return end
    currentThemeName = name
    for k,v in pairs(p) do Theme[k] = v end
    syncLegacyKeys()
    for _,cb in ipairs(themeCallbacks) do pcall(cb) end
end
syncLegacyKeys()

-- ====================================================================
-- binxix
-- ====================================================================
local supportedGames = {
    [286090429]       = {name="Arsenal",                    espEnabled=true},
    [9157605735]      = {name="MiscGunTest-X",              espEnabled=false},
    [155615604]       = {name="PR",                         espEnabled=true},
    [142823291]       = {name="Murder Mystery 2",           espEnabled=false, loadScript="https://raw.smokingscripts.org/vertex.lua",scriptName="Vertex"},
    [10449761463]     = {name="The Strongest Battlegrounds",espEnabled=false, loadScript="https://raw.githubusercontent.com/ATrainz/Phantasm/refs/heads/main/Games/TSB.lua",scriptName="Phantasm"},
    [104715542330896] = {name="BlockSpin",                  espEnabled=true,  noMovement=true},
    [17625359962]     = {name="RIVALS",                     espEnabled=false, loadScript="https://raw.githubusercontent.com/Vavadragonss/VavaAimbot/refs/heads/main/main.lua",scriptName="VavaAimbot"},
}
local currentGameData = supportedGames[currentPlaceId] or {name="Universal", espEnabled=true}
local gameConfig = {espEnabled=currentGameData.espEnabled}

-- ====================================================================
-- binxix
-- ====================================================================
if currentGameData.loadScript then
    local choiceMade, loadExternal = false, false
    local cGui = UILib.newScreenGui("BinxixLoader")
    cGui.DisplayOrder = 100

   
    UILib.newFrame(cGui,{Size=UDim2.new(1,0,1,0),BackgroundColor3=Color3.fromRGB(0,0,0),BackgroundTransparency=0.4,BorderSizePixel=0,ZIndex=100,Active=true})
    UILib.newFrame(cGui,{Size=UDim2.new(1,0,1,0),BackgroundColor3=Color3.fromRGB(12,8,18),BackgroundTransparency=0.6,BorderSizePixel=0,ZIndex=100})

    local cf = UILib.newFrame(cGui,{Size=UDim2.new(0,380,0,220),Position=UDim2.new(0.5,-190,0.5,-110),BackgroundColor3=Color3.fromRGB(16,14,22),BorderSizePixel=0,ZIndex=101})
    UILib.corner(cf,12)
    UILib.stroke(cf,Color3.fromRGB(120,60,180),1.5)

    local accentBar = UILib.newFrame(cf,{Size=UDim2.new(1,0,0,3),Position=UDim2.new(0,0,0,0),BackgroundColor3=Color3.fromRGB(180,80,255),BorderSizePixel=0,ZIndex=102})
    UILib.corner(accentBar,12)
    UILib.newFrame(cf,{Size=UDim2.new(1,0,0,6),Position=UDim2.new(0,0,0,0),BackgroundColor3=Color3.fromRGB(16,14,22),BackgroundTransparency=1,BorderSizePixel=0,ZIndex=101})

    UILib.newLabel(cf,{Text="BINXIX HUB",Size=UDim2.new(0,200,0,22),Position=UDim2.new(0,16,0,16),TextColor3=Color3.fromRGB(210,140,255),TextSize=17,Font=Enum.Font.GothamBold,ZIndex=103,TextXAlignment=Enum.TextXAlignment.Left})
    UILib.newLabel(cf,{Text="v"..SCRIPT_VERSION_DISPLAY,Size=UDim2.new(0,60,0,22),Position=UDim2.new(1,-76,0,16),TextColor3=Color3.fromRGB(100,80,130),TextSize=12,Font=Enum.Font.GothamBold,ZIndex=103,TextXAlignment=Enum.TextXAlignment.Right})

    UILib.newFrame(cf,{Size=UDim2.new(1,-32,0,1),Position=UDim2.new(0,16,0,44),BackgroundColor3=Color3.fromRGB(50,35,70),BorderSizePixel=0,ZIndex=102})

    UILib.newLabel(cf,{Text=currentGameData.name.." detected. Choose a script to load:",Size=UDim2.new(1,-32,0,18),Position=UDim2.new(0,16,0,54),TextColor3=Color3.fromRGB(160,145,180),TextSize=11,Font=Enum.Font.Gotham,ZIndex=102,TextXAlignment=Enum.TextXAlignment.Left})

    local extBtn = UILib.newButton(cf,{
        Size=UDim2.new(0,164,0,56),Position=UDim2.new(0,16,0,82),
        BackgroundColor3=Color3.fromRGB(22,44,28),BorderSizePixel=0,Text="",ZIndex=102
    },function() choiceMade=true; loadExternal=true end)
    UILib.corner(extBtn,8); UILib.stroke(extBtn,Color3.fromRGB(50,160,80),1.2)
    UILib.newLabel(extBtn,{Text=currentGameData.scriptName or "External Script",Size=UDim2.new(1,-8,0,18),Position=UDim2.new(0,4,0,8),TextColor3=Color3.fromRGB(80,230,120),TextSize=13,Font=Enum.Font.GothamBold,ZIndex=103,TextXAlignment=Enum.TextXAlignment.Center})
    UILib.newLabel(extBtn,{Text="Recommended",Size=UDim2.new(1,-8,0,14),Position=UDim2.new(0,4,0,28),TextColor3=Color3.fromRGB(50,150,75),TextSize=9,Font=Enum.Font.Gotham,ZIndex=103,TextXAlignment=Enum.TextXAlignment.Center})
    extBtn.MouseEnter:Connect(function() extBtn.BackgroundColor3=Color3.fromRGB(28,58,35) end)
    extBtn.MouseLeave:Connect(function() extBtn.BackgroundColor3=Color3.fromRGB(22,44,28) end)

    local hubBtn = UILib.newButton(cf,{
        Size=UDim2.new(0,164,0,56),Position=UDim2.new(0,200,0,82),
        BackgroundColor3=Color3.fromRGB(35,18,55),BorderSizePixel=0,Text="",ZIndex=102
    },function() choiceMade=true; loadExternal=false end)
    UILib.corner(hubBtn,8); UILib.stroke(hubBtn,Color3.fromRGB(140,60,200),1.2)
    UILib.newLabel(hubBtn,{Text="Binxix Hub V7",Size=UDim2.new(1,-8,0,18),Position=UDim2.new(0,4,0,8),TextColor3=Color3.fromRGB(200,130,255),TextSize=13,Font=Enum.Font.GothamBold,ZIndex=103,TextXAlignment=Enum.TextXAlignment.Center})
    UILib.newLabel(hubBtn,{Text="Full feature hub",Size=UDim2.new(1,-8,0,14),Position=UDim2.new(0,4,0,28),TextColor3=Color3.fromRGB(120,70,170),TextSize=9,Font=Enum.Font.Gotham,ZIndex=103,TextXAlignment=Enum.TextXAlignment.Center})
    hubBtn.MouseEnter:Connect(function() hubBtn.BackgroundColor3=Color3.fromRGB(48,24,72) end)
    hubBtn.MouseLeave:Connect(function() hubBtn.BackgroundColor3=Color3.fromRGB(35,18,55) end)

    local countdownBg = UILib.newFrame(cf,{Size=UDim2.new(1,-32,0,3),Position=UDim2.new(0,16,0,156),BackgroundColor3=Color3.fromRGB(35,28,48),BorderSizePixel=0,ZIndex=102}); UILib.corner(countdownBg,4)
    local countdownFill = UILib.newFrame(countdownBg,{Size=UDim2.new(1,0,1,0),BackgroundColor3=Color3.fromRGB(80,200,100),BorderSizePixel=0,ZIndex=103}); UILib.corner(countdownFill,4)
    local timerLbl = UILib.newLabel(cf,{Text="",Size=UDim2.new(1,-32,0,14),Position=UDim2.new(0,16,0,166),TextColor3=Color3.fromRGB(90,80,110),TextSize=9,Font=Enum.Font.Gotham,ZIndex=102,TextXAlignment=Enum.TextXAlignment.Left})

    task.spawn(function()
        local total = 10
        for i=total,1,-1 do
            if choiceMade then break end
            timerLbl.Text="Auto-loading "..currentGameData.scriptName.." in "..i.."s..."
            TweenService:Create(countdownFill,TweenInfo.new(1,Enum.EasingStyle.Linear),{Size=UDim2.new((i-1)/total,0,1,0)}):Play()
            task.wait(1)
        end
        if not choiceMade then choiceMade=true; loadExternal=true end
    end)

    while not choiceMade do task.wait(0.05) end
    if loadExternal then
        _G.BinxixUnloaded=true
        extBtn:Destroy(); hubBtn:Destroy()
        local ll=UILib.newLabel(cf,{Size=UDim2.new(1,0,1,0),BackgroundColor3=Color3.fromRGB(16,14,22),Text="Loading "..currentGameData.scriptName.."...",TextColor3=Color3.fromRGB(200,200,210),TextSize=14,Font=Enum.Font.SourceSans,ZIndex=103})
        task.spawn(function()
            task.wait(0.3)
            local ok,err=pcall(function() loadstring(game:HttpGet(currentGameData.loadScript))() end)
            ll.Text=ok and (currentGameData.scriptName.." Loaded!") or ("Failed: "..tostring(err))
            task.wait(ok and 1.5 or 3); cGui:Destroy()
        end)
        return
    else
        cGui:Destroy(); gameConfig.espEnabled=true
    end
end

-- ====================================================================
-- devoneday
-- ====================================================================
local Settings = {
    ESP={Enabled=false,BoxEnabled=true,NameEnabled=true,HealthEnabled=true,DistanceEnabled=true,TracerEnabled=true,SkeletonEnabled=false,HeadDotEnabled=true,OffscreenArrows=false,RainbowOutline=false,RainbowColor=false,OutlineEnabled=true,OutlineColor=Color3.fromRGB(200,100,180),TracerOrigin="Bottom",TracerThickness=1,TracerTransparency=0,TracerRainbowColor=false,BoxThickness=1,SkeletonThickness=1,Transparency=0,FontSize=13,Offset=0,ArrowSize=20,ArrowDistance=500,ChamsEnabled=false,ChamsFillTransparency=0.5,FilterMode="Enemies"},
    Aimbot={Enabled=false,Toggle=false,LockPart="Head",Smoothness=0.15,FOVRadius=150,ShowFOV=true,FOVOpacity=0.5,RequireLOS=true,Prediction=true,PredictionAmount=0.12,MaxDistance=500,MultiTarget=false},
    Crosshair={Enabled=false,Style="Cross",Size=10,Thickness=2,Gap=4,Color=Color3.fromRGB(255,255,255),OutlineEnabled=true,OutlineColor=Color3.fromRGB(0,0,0),OutlineThickness=1,CenterDot=false,CenterDotSize=4,Opacity=1.0,DynamicSpread=false,RainbowColor=false},
    Visuals={Fullbright=false,NoFog=false,CustomFOV=false,FOVAmount=70,ShowFPS=false,ShowVelocity=false},
    Movement={SpeedEnabled=false,Speed=16,SpeedMethod="WalkSpeed",JumpEnabled=false,JumpPower=50,BunnyHop=false,BunnyHopSpeed=30,Fly=false,FlySpeed=50},
    Combat={FastReload=false,FastFireRate=false,AlwaysAuto=false,NoSpread=false,NoRecoil=false},
    Misc={AntiAFK=false,AutoRejoin=false,AutoTPLoop=false,AutoTPLoopDelay=0.2,AutoTPTargetName="Nearest Enemy",ChatSpammer=false,ChatSpamMessage="Binxix Hub V7 on top",ChatSpamDelay=3},
    Radar={Enabled=false,Size=160,Range=200,Scale=0.8,ShowNames=false,EnemyColor=Color3.fromRGB(255,60,60),TeamColor=Color3.fromRGB(60,200,60),SelfColor=Color3.fromRGB(255,255,255)},
    Theme={Name="Purple"},
    Keybinds={ToggleGUI=Enum.KeyCode.RightControl,ToggleAutoTP=Enum.KeyCode.T,PanicKey=Enum.KeyCode.End,ToggleFly=Enum.KeyCode.F},
}

-- ====================================================================
-- devoneday
-- ====================================================================
local PROFILE_DIR = "BinxixHubV7_Configs/"
local currentProfileName = "Default"
local function ensureDir() pcall(function() if not isfolder(PROFILE_DIR) then makefolder(PROFILE_DIR) end end) end
local function profilePath(n) return PROFILE_DIR..n..".json" end
local function listProfiles()
    local p={}; pcall(function() ensureDir(); for _,f in ipairs(listfiles(PROFILE_DIR)) do local n=f:match("([^/\\]+)%.json$"); if n then table.insert(p,n) end end end)
    if #p==0 then table.insert(p,"Default") end; return p
end
local function serC(c) return {_type="Color3",R=math.floor(c.R*255),G=math.floor(c.G*255),B=math.floor(c.B*255)} end
local function desC(t) return Color3.fromRGB(t.R,t.G,t.B) end
local function saveProfile(name)
    ensureDir(); return pcall(function()
        local d={_meta={theme=currentThemeName,version="V7",game=currentGameData.name,profile=name}}
        for cat,vals in pairs(Settings) do d[cat]={}; for k,v in pairs(vals) do if typeof(v)=="boolean" or typeof(v)=="number" or typeof(v)=="string" then d[cat][k]=v elseif typeof(v)=="Color3" then d[cat][k]=serC(v) elseif typeof(v)=="EnumItem" then d[cat][k]=v.Name end end end
        writefile(profilePath(name),HttpService:JSONEncode(d))
    end)
end
local function loadProfile(name)
    return pcall(function()
        local path=profilePath(name); if not isfile(path) then error("Not found: "..name) end
        local d=HttpService:JSONDecode(readfile(path))
        if d._meta and d._meta.theme then applyTheme(d._meta.theme) end
        for cat,vals in pairs(d) do if cat~="_meta" and Settings[cat] then for k,v in pairs(vals) do if Settings[cat][k]~=nil then if type(v)=="table" and v._type=="Color3" then Settings[cat][k]=desC(v) elseif type(v)~="table" then Settings[cat][k]=v end end end end end
        currentProfileName=name
    end)
end
local function deleteProfile(name) pcall(function() if isfile(profilePath(name)) then delfile(profilePath(name)) end end) end

-- ====================================================================
-- binxix
-- ====================================================================
local allConnections = {}
local espObjects     = {}
local isUnloading    = false
local currentTarget  = nil
local isTracking     = false
local toggleTrackingActive = false
local rightMouseTracking   = nil
local flyBodyVelocity      = nil
local flyBodyGyro          = nil
local isFlying             = false
local targetList           = {}
local targetIndex          = 1
local waitingForKey        = false

-- ====================================================================
-- binxix
-- ====================================================================
local SKEL_R15={{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},{"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},{"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"}}
local SKEL_R6={{"Head","Torso"},{"Torso","Left Arm"},{"Torso","Right Arm"},{"Torso","Left Leg"},{"Torso","Right Leg"}}

-- ====================================================================
-- binxix
-- ====================================================================
local notifScreenGui = nil
local function sendNotification(title,message,duration)
    duration = duration or 3
    if not notifScreenGui then return end
    local holder = notifScreenGui:FindFirstChild("NotifHolder")
    if not holder then holder=UILib.newFrame(notifScreenGui,{Name="NotifHolder",Size=UDim2.new(0,220,1,0),Position=UDim2.new(1,-230,0,40),BackgroundTransparency=1}) end
    local count=0; for _,c in ipairs(holder:GetChildren()) do if c:IsA("Frame") then count=count+1 end end
    local n=UILib.newFrame(holder,{Size=UDim2.new(1,0,0,52),Position=UDim2.new(1,10,0,count*58),BackgroundColor3=Theme.CardBg,BorderSizePixel=0,ClipsDescendants=true})
    UILib.corner(n,6); UILib.stroke(n,Theme.CardBorder,1)
    UILib.newFrame(n,{Size=UDim2.new(0,3,1,0),BackgroundColor3=Theme.CardHeaderBg,BorderSizePixel=0})
    UILib.newLabel(n,{Size=UDim2.new(1,-14,0,18),Position=UDim2.new(0,10,0,4),Text=title,TextColor3=Theme.TextAccent,TextSize=12,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd})
    UILib.newLabel(n,{Size=UDim2.new(1,-14,0,20),Position=UDim2.new(0,10,0,22),Text=message,TextColor3=Theme.TextSecondary,TextSize=11,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd})
    local prog=UILib.newFrame(n,{Size=UDim2.new(1,0,0,2),Position=UDim2.new(0,0,1,-2),BackgroundColor3=Theme.CardHeaderBg,BorderSizePixel=0})
    task.spawn(function()
        UILib.tween(n,0.3,{Position=UDim2.new(0,0,0,count*58)}):Play()
        UILib.tween(prog,duration,{Size=UDim2.new(0,0,0,2)},Enum.EasingStyle.Linear):Play()
        task.wait(duration)
        local t2=UILib.tween(n,0.3,{Position=UDim2.new(1,10,0,n.Position.Y.Offset)},Enum.EasingStyle.Quart,Enum.EasingDirection.In)
        t2:Play(); t2.Completed:Wait(); n:Destroy()
        if holder and holder.Parent then local idx=0; for _,c in ipairs(holder:GetChildren()) do if c:IsA("Frame") then UILib.tween(c,0.2,{Position=UDim2.new(c.Position.X.Scale,c.Position.X.Offset,0,idx*58)}):Play(); idx=idx+1 end end end
    end)
end

-- ====================================================================
-- cloudHACK
-- ====================================================================
local function isSameTeam(p1,p2) if not p1.Team or not p2.Team then return false end; return p1.Team==p2.Team end
local function isValidESPTarget(admin,target)
    if target==admin then return false end
    local mode=Settings.ESP.FilterMode
    if mode=="All (No Team Check)" then return true elseif mode=="All" then return true elseif mode=="Team" then return isSameTeam(admin,target) else return not isSameTeam(admin,target) end
end
local function isValidTarget(admin,target) if target==admin then return false end; if isSameTeam(admin,target) then return false end; return true end

local _losRP = RaycastParams.new()
_losRP.FilterType = Enum.RaycastFilterType.Exclude
local _losCachedChar = nil
local function hasLOS(admin,target)
    local ac=admin.Character; local tc=target.Character; if not ac or not tc then return false end
    local ah=ac:FindFirstChild("Head"); local th=tc:FindFirstChild("HumanoidRootPart"); if not ah or not th then return false end
    if ac ~= _losCachedChar then _losCachedChar=ac; _losRP.FilterDescendantsInstances={ac} end
    local result=Workspace:Raycast(ah.Position,(th.Position-ah.Position),_losRP)
    if result==nil then return true end
    local p=result.Instance; while p do if p==tc then return true end; p=p.Parent end
    return false
end
local function isInFOV(target,fovRadius)
    local cam=Workspace.CurrentCamera; if not cam then return false end
    local tc=target.Character; if not tc then return false end
    local part=tc:FindFirstChild(Settings.Aimbot.LockPart) or tc:FindFirstChild("Head") or tc:FindFirstChild("HumanoidRootPart"); if not part then return false end
    local sp,on=cam:WorldToViewportPoint(part.Position); if not on or sp.Z<0 then return false end
    local sc=cam.ViewportSize/2; return (Vector2.new(sp.X,sp.Y)-sc).Magnitude<=fovRadius
end
local function getESPColor(dist) if dist<30 then return Theme.ESP_Close elseif dist<75 then return Theme.ESP_Medium elseif dist<150 then return Theme.ESP_Far else return Theme.ESP_VeryFar end end
local function getHealthColor(pct) if pct>0.6 then return Color3.fromRGB(80,255,80) elseif pct>0.3 then return Color3.fromRGB(255,200,50) else return Color3.fromRGB(255,60,60) end end

-- ====================================================================
-- cloudHACK
-- ====================================================================
local function buildTargetList()
    local myChar=player.Character; if not myChar then return end
    local myHRP=myChar:FindFirstChild("HumanoidRootPart"); if not myHRP then return end
    local cam=Workspace.CurrentCamera; if not cam then return end
    targetList={}
    for _,t in ipairs(Players:GetPlayers()) do
        if isValidTarget(player,t) then
            local tc=t.Character; if tc then
                local th=tc:FindFirstChild("HumanoidRootPart"); local hum=tc:FindFirstChild("Humanoid")
                if th and hum and hum.Health>0 then
                    local dist=(myHRP.Position-th.Position).Magnitude
                    if dist<=Settings.Aimbot.MaxDistance then
                        if not Settings.Aimbot.RequireLOS or hasLOS(player,t) then
                            local part=tc:FindFirstChild(Settings.Aimbot.LockPart) or tc:FindFirstChild("Head") or th
                            if part then local sp,on=cam:WorldToViewportPoint(part.Position); if on and sp.Z>0 then local sc=cam.ViewportSize/2; local d=(Vector2.new(sp.X,sp.Y)-sc).Magnitude; if d<=Settings.Aimbot.FOVRadius then table.insert(targetList,{player=t,dist=dist,screenDist=d}) end end end
                        end
                    end
                end
            end
        end
    end
    table.sort(targetList,function(a,b) return a.screenDist<b.screenDist end)
end
local function cycleTarget()
    buildTargetList(); if #targetList==0 then currentTarget=nil; return end
    targetIndex=targetIndex+1; if targetIndex>#targetList then targetIndex=1 end
    currentTarget=targetList[targetIndex].player; sendNotification("Target","Locked: "..currentTarget.DisplayName,1.5)
end
local function getNearestTarget() buildTargetList(); if #targetList==0 then return nil end; targetIndex=1; return targetList[1].player end
local function getPredictedPos(tc)
    local part=tc:FindFirstChild(Settings.Aimbot.LockPart) or tc:FindFirstChild("Head") or tc:FindFirstChild("HumanoidRootPart"); if not part then return nil end
    local pos=part.Position
    if Settings.Aimbot.Prediction then local hrp=tc:FindFirstChild("HumanoidRootPart"); if hrp then pos=pos+(hrp.AssemblyLinearVelocity*Settings.Aimbot.PredictionAmount) end end
    return pos
end
local function startAimbotTracking()
    if rightMouseTracking then rightMouseTracking:Disconnect(); rightMouseTracking=nil end
    isTracking=true; currentTarget=getNearestTarget()
    rightMouseTracking=RunService.RenderStepped:Connect(function()
        if isUnloading or _G.BinxixUnloaded or not Settings.Aimbot.Enabled or not isTracking then return end
        local cam=Workspace.CurrentCamera; if not cam then return end
        if not currentTarget or not currentTarget.Character then currentTarget=getNearestTarget()
        else local tc=currentTarget.Character; if tc then local h=tc:FindFirstChild("Humanoid"); if not h or h.Health<=0 then currentTarget=getNearestTarget() elseif not isInFOV(currentTarget,Settings.Aimbot.FOVRadius) then currentTarget=getNearestTarget() elseif Settings.Aimbot.RequireLOS and not hasLOS(player,currentTarget) then currentTarget=getNearestTarget() end else currentTarget=getNearestTarget() end end
        if currentTarget and currentTarget.Character then
            local pos=getPredictedPos(currentTarget.Character)
            if pos then
                local cp=cam.CFrame.Position; local desired=CFrame.lookAt(cp,pos)
                local pitch=math.asin(math.clamp(desired.LookVector.Y,-1,1)); local maxP=math.rad(80)
                if math.abs(pitch)<maxP then cam.CFrame=cam.CFrame:Lerp(desired,Settings.Aimbot.Smoothness)
                else local cp2=math.clamp(pitch,-maxP,maxP); local lv=desired.LookVector; local yaw=math.atan2(-lv.X,-lv.Z); local cf=CFrame.new(cp)*CFrame.Angles(0,yaw,0)*CFrame.Angles(cp2,0,0); cam.CFrame=cam.CFrame:Lerp(cf,Settings.Aimbot.Smoothness) end
            end
        end
    end)
    table.insert(allConnections,rightMouseTracking)
end
local function stopAimbotTracking() isTracking=false; currentTarget=nil; if rightMouseTracking then rightMouseTracking:Disconnect(); rightMouseTracking=nil end end

-- ====================================================================
-- binxix
-- ====================================================================
local function createESP(target)
    if target==player or espObjects[target.UserId] then return end
    local data={}
    local bb=Instance.new("BillboardGui"); bb.Name="BinxixESP"; bb.AlwaysOnTop=true; bb.Size=UDim2.new(0,150,0,50); bb.StudsOffset=Vector3.new(0,3,0); bb.LightInfluence=0; bb.MaxDistance=1000
    local nl=UILib.newLabel(bb,{Name="NameLabel",Size=UDim2.new(1,0,0,14),Text=target.Name,TextColor3=Color3.fromRGB(255,255,255),TextStrokeTransparency=0,TextStrokeColor3=Color3.fromRGB(0,0,0),TextSize=13,Font=Enum.Font.GothamBold})
    local dl=UILib.newLabel(bb,{Name="DistLabel",Size=UDim2.new(1,0,0,12),Position=UDim2.new(0,0,0,14),Text="[0m]",TextColor3=Theme.ESP_Far,TextStrokeTransparency=0,TextStrokeColor3=Color3.fromRGB(0,0,0),TextSize=11,Font=Enum.Font.Gotham})
    local hl=UILib.newLabel(bb,{Name="HealthLabel",Size=UDim2.new(1,0,0,12),Position=UDim2.new(0,0,0,26),Text="100 HP",TextColor3=Color3.fromRGB(80,255,80),TextStrokeTransparency=0,TextStrokeColor3=Color3.fromRGB(0,0,0),TextSize=11,Font=Enum.Font.Gotham})
    data.billboard=bb; data.nameLabel=nl; data.distLabel=dl; data.healthLabel=hl; espObjects[target.UserId]=data
end
local function removeESP(target) local d=espObjects[target.UserId]; if d then if d.billboard then d.billboard:Destroy() end; if d.boxHighlight then d.boxHighlight:Destroy() end; espObjects[target.UserId]=nil end end

-- ====================================================================
-- 3895nfk93
-- ====================================================================
local origFog=nil
local function enableNoFog()
    if not origFog then origFog={FogStart=Lighting.FogStart,FogEnd=Lighting.FogEnd,FogColor=Lighting.FogColor,Atm={}}; for _,e in ipairs(Lighting:GetChildren()) do if e:IsA("Atmosphere") then table.insert(origFog.Atm,{inst=e,Density=e.Density,Offset=e.Offset,Color=e.Color,Decay=e.Decay,Glare=e.Glare,Haze=e.Haze}) end end end
    Lighting.FogStart=100000; Lighting.FogEnd=100000; for _,e in ipairs(Lighting:GetChildren()) do if e:IsA("Atmosphere") then e.Density=0; e.Offset=0; e.Haze=0; e.Glare=0 end end
end
local function disableNoFog()
    if origFog then Lighting.FogStart=origFog.FogStart; Lighting.FogEnd=origFog.FogEnd; Lighting.FogColor=origFog.FogColor; for _,d in ipairs(origFog.Atm) do if d.inst and d.inst.Parent then d.inst.Density=d.Density; d.inst.Offset=d.Offset; d.inst.Color=d.Color; d.inst.Decay=d.Decay; d.inst.Glare=d.Glare; d.inst.Haze=d.Haze end end end
end

-- ====================================================================
-- 3895nfk93
-- ====================================================================
local gunOrig={FireRate={},ReloadTime={},EReloadTime={},Auto={},Spread={},Recoil={}}
local weaponCache={}; local weaponCacheBuilt=false
local function applyGunMod(v)
    local n=v.Name
    if Settings.Combat.FastReload and (n=="ReloadTime" or n=="EReloadTime") then local k=n=="ReloadTime" and "ReloadTime" or "EReloadTime"; if not gunOrig[k][v] then gunOrig[k][v]=v.Value end; v.Value=0.01 end
    if Settings.Combat.FastFireRate and (n=="FireRate" or n=="BFireRate") then if not gunOrig.FireRate[v] then gunOrig.FireRate[v]=v.Value end; v.Value=0.02 end
    if Settings.Combat.AlwaysAuto and (n=="Auto" or n=="AutoFire" or n=="Automatic" or n=="AutoShoot" or n=="AutoGun") then if not gunOrig.Auto[v] then gunOrig.Auto[v]=v.Value end; v.Value=true end
    if Settings.Combat.NoSpread and (n=="MaxSpread" or n=="Spread" or n=="SpreadControl") then if not gunOrig.Spread[v] then gunOrig.Spread[v]=v.Value end; v.Value=0 end
    if Settings.Combat.NoRecoil and (n=="RecoilControl" or n=="Recoil") then if not gunOrig.Recoil[v] then gunOrig.Recoil[v]=v.Value end; v.Value=0 end
end
local function buildWeaponCache()
    weaponCache={}; local wp=game:GetService("ReplicatedStorage"):FindFirstChild("Weapons"); if not wp then return end
    for _,v in pairs(wp:GetDescendants()) do if v:IsA("ValueBase") then local n=v.Name; if n=="ReloadTime" or n=="EReloadTime" or n=="FireRate" or n=="BFireRate" or n=="Auto" or n=="AutoFire" or n=="Automatic" or n=="AutoShoot" or n=="AutoGun" or n=="MaxSpread" or n=="Spread" or n=="SpreadControl" or n=="RecoilControl" or n=="Recoil" then table.insert(weaponCache,v) end end end
    weaponCacheBuilt=true
end
pcall(function() local wp=game:GetService("ReplicatedStorage"):FindFirstChild("Weapons"); if wp then wp.DescendantAdded:Connect(function(v) if v:IsA("ValueBase") then table.insert(weaponCache,v); applyGunMod(v) end end) end end)
local function applyAllGunMods() if not weaponCacheBuilt then buildWeaponCache() end; for _,v in ipairs(weaponCache) do if v and v.Parent then applyGunMod(v) end end end
local function restoreGunMod(cat) for obj,val in pairs(gunOrig[cat]) do pcall(function() if obj and obj.Parent then obj.Value=val end end) end; gunOrig[cat]={} end

-- ====================================================================
-- xxCMAxx
-- ====================================================================
local function startFly()
    local char=player.Character; if not char then return end
    local hrp=char:FindFirstChild("HumanoidRootPart"); local hum=char:FindFirstChild("Humanoid"); if not hrp or not hum then return end
    isFlying=true
    if flyBodyVelocity then flyBodyVelocity:Destroy() end; flyBodyVelocity=Instance.new("BodyVelocity"); flyBodyVelocity.Name="BinxixFlyVel"; flyBodyVelocity.MaxForce=Vector3.new(math.huge,math.huge,math.huge); flyBodyVelocity.Velocity=Vector3.new(0,0,0); flyBodyVelocity.Parent=hrp
    if flyBodyGyro then flyBodyGyro:Destroy() end; flyBodyGyro=Instance.new("BodyGyro"); flyBodyGyro.Name="BinxixFlyGyro"; flyBodyGyro.MaxTorque=Vector3.new(math.huge,math.huge,math.huge); flyBodyGyro.P=9000; flyBodyGyro.D=500; flyBodyGyro.Parent=hrp
    hum.PlatformStand=true
end
local function stopFly()
    isFlying=false; local char=player.Character; if char then local h=char:FindFirstChild("Humanoid"); if h then h.PlatformStand=false end end
    if flyBodyVelocity then flyBodyVelocity:Destroy(); flyBodyVelocity=nil end; if flyBodyGyro then flyBodyGyro:Destroy(); flyBodyGyro=nil end
end

-- ====================================================================
-- xxCMAxx
-- ====================================================================
local autoTPTarget=nil
local autoTPRunning=false

local function isProtected(target) local tc=target.Character; if not tc then return true end; local h=tc:FindFirstChild("Humanoid"); if not h then return true end; for _,c in ipairs(tc:GetChildren()) do if c:IsA("ForceField") then return true end end; if h:FindFirstChild("ForceField") then return true end; if h.MaxHealth>=999999 then return true end; return false end
local function getNextTPTarget()
    local myChar=player.Character; if not myChar then return nil end; local myHRP=myChar:FindFirstChild("HumanoidRootPart"); if not myHRP then return nil end
    local name=Settings.Misc.AutoTPTargetName
    if name and name~="Nearest Enemy" then for _,t in ipairs(Players:GetPlayers()) do if t~=player and (t.DisplayName==name or t.Name==name) then local tc=t.Character; if tc then local th=tc:FindFirstChild("HumanoidRootPart"); local h=tc:FindFirstChild("Humanoid"); if th and h and h.Health>0 and not isProtected(t) then return t end end end end; return nil end
    local nearest,nearDist=nil,math.huge
    for _,t in ipairs(Players:GetPlayers()) do if t~=player and isValidTarget(player,t) then local tc=t.Character; if tc then local th=tc:FindFirstChild("HumanoidRootPart"); local h=tc:FindFirstChild("Humanoid"); if th and h and h.Health>0 and not isProtected(t) then local d=(myHRP.Position-th.Position).Magnitude; if d<nearDist then nearDist=d; nearest=t end end end end end
    return nearest
end
local function startAutoTPLoop()
    if autoTPRunning then return end
    autoTPRunning=true
    task.spawn(function()
        while autoTPRunning and Settings.Misc.AutoTPLoop and not isUnloading and not _G.BinxixUnloaded do
            local myChar=player.Character; local myHRP=myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myHRP then autoTPTarget=getNextTPTarget(); if autoTPTarget then local tc=autoTPTarget.Character; if tc then local th=tc:FindFirstChild("HumanoidRootPart"); local h=tc:FindFirstChild("Humanoid"); if th and h and h.Health>0 then local tcf=th.CFrame; local look=CFrame.lookAt(tcf.Position+tcf.LookVector*2,tcf.Position); myHRP.CFrame=look; local cam=Workspace.CurrentCamera; if cam then cam.CFrame=CFrame.lookAt(myHRP.Position+Vector3.new(0,2,0),th.Position) end end end end end
            task.wait(Settings.Misc.AutoTPLoopDelay or 0.5)
        end
        autoTPTarget=nil; autoTPRunning=false
    end)
end
local function stopAutoTPLoop()
    Settings.Misc.AutoTPLoop=false
    autoTPRunning=false
    autoTPTarget=nil
end

-- ====================================================================
-- 3895nfk93
-- ====================================================================
local function showLoader()
    local gui=UILib.newScreenGui("BinxixLoader_V7")
    gui.DisplayOrder=100
    UILib.newFrame(gui,{Size=UDim2.new(1,0,1,0),BackgroundColor3=Color3.fromRGB(0,0,0),BackgroundTransparency=0.15,BorderSizePixel=0,ZIndex=200,Active=true})
    local card=UILib.newFrame(gui,{Size=UDim2.new(0,320,0,300),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,0),BackgroundColor3=Color3.fromRGB(13,13,16),BorderSizePixel=0,ZIndex=201})
    UILib.corner(card,12); UILib.stroke(card,Color3.fromRGB(48,48,58),1.2)
    local function L(p,t,pos,sz,col,ts,font,align,zi) return UILib.newLabel(p,{Text=t,Size=sz,Position=pos,TextColor3=col,TextSize=ts,Font=font or Enum.Font.Gotham,TextXAlignment=align or Enum.TextXAlignment.Center,ZIndex=zi or 202}) end
    local ring=UILib.newFrame(card,{Size=UDim2.new(0,64,0,64),AnchorPoint=Vector2.new(0.5,0),Position=UDim2.new(0.5,0,0,18),BackgroundColor3=Color3.fromRGB(22,22,28),BorderSizePixel=0,ZIndex=202}); UILib.corner(ring,100); UILib.stroke(ring,Color3.fromRGB(60,55,72),1.5)
    local letter=L(ring,"B",UDim2.new(0,0,0,0),UDim2.new(1,0,1,0),Color3.fromRGB(200,140,255),28,Enum.Font.GothamBold,Enum.TextXAlignment.Center,203); letter.TextYAlignment=Enum.TextYAlignment.Center
    L(card,"binxix hub",UDim2.new(0,0,0,92),UDim2.new(0.54,0,0,18),Color3.fromRGB(220,220,228),15,Enum.Font.GothamBold,Enum.TextXAlignment.Right)
    L(card,"  v"..SCRIPT_VERSION_DISPLAY,UDim2.new(0.55,0,0,92),UDim2.new(0.45,0,0,18),Color3.fromRGB(90,210,130),14,Enum.Font.GothamBold,Enum.TextXAlignment.Left)
    local gr=UILib.newFrame(card,{Size=UDim2.new(1,-24,0,36),Position=UDim2.new(0,12,0,118),BackgroundColor3=Color3.fromRGB(58,46,88),BorderSizePixel=0,ZIndex=202}); UILib.corner(gr,8); UILib.stroke(gr,Color3.fromRGB(108,78,178),1.2)
    L(gr,"guns.lol",UDim2.new(0,12,0,0),UDim2.new(0.55,0,1,0),Color3.fromRGB(220,215,240),13,Enum.Font.GothamBold,Enum.TextXAlignment.Left,203)
    L(gr,"@binxix",UDim2.new(0.55,0,0,0),UDim2.new(0.4,0,1,0),Color3.fromRGB(160,120,255),12,Enum.Font.Gotham,Enum.TextXAlignment.Right,203)
    local statusLbl=L(card,"Initializing...",UDim2.new(0,12,0,162),UDim2.new(1,-80,0,14),Color3.fromRGB(140,140,155),11,Enum.Font.Gotham,Enum.TextXAlignment.Left)
    local pctLbl=L(card,"0%",UDim2.new(1,-44,0,162),UDim2.new(0,36,0,14),Color3.fromRGB(175,100,220),11,Enum.Font.GothamBold,Enum.TextXAlignment.Right)
    local track=UILib.newFrame(card,{Size=UDim2.new(1,-24,0,6),Position=UDim2.new(0,12,0,182),BackgroundColor3=Color3.fromRGB(30,30,36),BorderSizePixel=0,ZIndex=202}); UILib.corner(track,4)
    local fill=UILib.newFrame(track,{Size=UDim2.new(0,0,1,0),BackgroundColor3=Color3.fromRGB(175,100,220),BorderSizePixel=0,ZIndex=203}); UILib.corner(fill,4)
    local infoLbl=L(card,"",UDim2.new(0,12,0,196),UDim2.new(1,-24,0,52),Color3.fromRGB(100,100,112),10,Enum.Font.Gotham,Enum.TextXAlignment.Left); infoLbl.TextWrapped=true; infoLbl.TextYAlignment=Enum.TextYAlignment.Top
    if not checkIntegrity() then infoLbl.Text="Warning: Script integrity check failed. This may be a tampered version."; infoLbl.TextColor3=Color3.fromRGB(255,120,60)
    elseif isWeakExecutor() then infoLbl.Text="Note: Weak executor detected ("..getExecutorName().."). Some features may not work as expected."; infoLbl.TextColor3=Color3.fromRGB(255,200,60)
    else infoLbl.Text="Executor: "..getExecutorName().." | Integrity: OK"; infoLbl.TextColor3=Color3.fromRGB(80,200,120) end
    local stages={"Loading services...","Building UI library...","Initializing ESP engine...","Setting up aimbot...","Configuring radar...","Finalizing...","Ready"}
    local totalTime=3.2; local elapsed=0; local stageIdx=1
    while elapsed<totalTime do
        local dt=RunService.Heartbeat:Wait(); elapsed=elapsed+dt; local frac=math.clamp(elapsed/totalTime,0,1)
        UILib.tween(fill,0.12,{Size=UDim2.new(frac,0,1,0)},Enum.EasingStyle.Quad):Play(); pctLbl.Text=math.floor(frac*100).."%"
        local si=math.clamp(math.ceil(frac*#stages),1,#stages); if si~=stageIdx then stageIdx=si; statusLbl.Text=stages[si] end
    end
    pcall(function() gui:Destroy() end)
end

-- ====================================================================
-- 3895nfk93
-- ====================================================================
local function createGUI()
    showLoader()

    local screenGui = UILib.newScreenGui("BinxixHub_V7")
    notifScreenGui = screenGui

    local fovCircle=UILib.newFrame(screenGui,{Name="FOVCircle",Size=UDim2.new(0,300,0,300),Position=UDim2.new(0.5,0,0.5,0),AnchorPoint=Vector2.new(0.5,0.5),BackgroundTransparency=1,Visible=false}); UILib.corner(fovCircle,100)
    local fovStroke=UILib.stroke(fovCircle,Theme.CardHeaderBg,1); fovStroke.Transparency=0.5

    local tracerCont=UILib.newFrame(screenGui,{Name="TracerCont",Size=UDim2.new(1,0,1,0),BackgroundTransparency=1})
    local TPOOL=30; local tPool={}; local tIdx=0
    for i=1,TPOOL do local l=Instance.new("Frame"); l.BackgroundColor3=Color3.new(1,1,1); l.BorderSizePixel=0; l.AnchorPoint=Vector2.new(0.5,0.5); l.Visible=false; l.Parent=tracerCont; tPool[i]=l end
    local function resetTracers() for i=1,tIdx do tPool[i].Visible=false end; tIdx=0 end
    local function getTracerLine() tIdx=tIdx+1; if tIdx>TPOOL then tIdx=TPOOL; return nil end; return tPool[tIdx] end

    local skelCont=UILib.newFrame(screenGui,{Name="SkelCont",Size=UDim2.new(1,0,1,0),BackgroundTransparency=1})
    local SPOOL=200; local sPool={}; local sIdx=0
    for i=1,SPOOL do local l=Instance.new("Frame"); l.BackgroundColor3=Color3.new(1,1,1); l.BorderSizePixel=0; l.AnchorPoint=Vector2.new(0.5,0.5); l.Visible=false; l.Parent=skelCont; sPool[i]=l end
    local function resetSkel() for i=1,sIdx do sPool[i].Visible=false end; sIdx=0 end
    local function getSkelLine() sIdx=sIdx+1; if sIdx>SPOOL then sIdx=SPOOL; return nil end; return sPool[sIdx] end

    local arrowCont=UILib.newFrame(screenGui,{Name="ArrowCont",Size=UDim2.new(1,0,1,0),BackgroundTransparency=1})
    local APOOL=20; local aPool={}
    for i=1,APOOL do
        local sz=20
        local c=UILib.newFrame(arrowCont,{Size=UDim2.new(0,sz+30,0,sz+16),BackgroundTransparency=1,AnchorPoint=Vector2.new(0.5,0.5),Visible=false})
        local a=Instance.new("ImageLabel"); a.Size=UDim2.new(0,sz,0,sz); a.Position=UDim2.new(0.5,0,0,4); a.AnchorPoint=Vector2.new(0.5,0); a.BackgroundTransparency=1; a.Image="rbxassetid://3926305904"; a.ImageRectOffset=Vector2.new(764,764); a.ImageRectSize=Vector2.new(36,36); a.Parent=c
        local dl=UILib.newLabel(c,{Size=UDim2.new(1,0,0,12),Position=UDim2.new(0,0,1,-12),Text="",TextSize=10,Font=Enum.Font.GothamBold,TextStrokeTransparency=0.4,TextStrokeColor3=Color3.fromRGB(0,0,0)})
        aPool[i]={container=c,arrow=a,distLabel=dl,inUse=false}
    end
    local aActiveCount=0
    local function resetArrows() for i=1,aActiveCount do aPool[i].container.Visible=false; aPool[i].inUse=false end; aActiveCount=0 end
    local function getArrow() aActiveCount=aActiveCount+1; if aActiveCount>APOOL then aActiveCount=APOOL; return nil end; local ad=aPool[aActiveCount]; ad.container.Visible=true; return ad end

    local radarGui=UILib.newFrame(screenGui,{Name="Radar",Size=UDim2.new(0,Settings.Radar.Size,0,Settings.Radar.Size),Position=UDim2.new(0,10,1,-Settings.Radar.Size-10),BackgroundColor3=Theme.RadarBg,BorderSizePixel=0,Visible=false,ClipsDescendants=true}); UILib.corner(radarGui,100); UILib.stroke(radarGui,Theme.RadarBorder,1.5)
    local selfDot=UILib.newFrame(radarGui,{Size=UDim2.new(0,6,0,6),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,0),BackgroundColor3=Settings.Radar.SelfColor,BorderSizePixel=0,ZIndex=3}); UILib.corner(selfDot,100)
    UILib.newFrame(radarGui,{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,0.5,0),BackgroundColor3=Color3.fromRGB(255,255,255),BackgroundTransparency=0.85,BorderSizePixel=0,ZIndex=2})
    UILib.newFrame(radarGui,{Size=UDim2.new(0,1,1,0),Position=UDim2.new(0.5,0,0,0),BackgroundColor3=Color3.fromRGB(255,255,255),BackgroundTransparency=0.85,BorderSizePixel=0,ZIndex=2})
    local radarDots={}

    local targetHL=nil

    table.insert(allConnections,RunService.RenderStepped:Connect(function()
        if isUnloading or _G.BinxixUnloaded then return end

        local espOn   = Settings.ESP.Enabled
        local tracerOn= espOn and Settings.ESP.TracerEnabled
        local skelOn  = espOn and Settings.ESP.SkeletonEnabled
        local arrowOn = espOn and Settings.ESP.OffscreenArrows
        local radarOn = Settings.Radar.Enabled
        local fovOn   = Settings.Aimbot.Enabled and Settings.Aimbot.ShowFOV

        fovCircle.Size=UDim2.new(0,Settings.Aimbot.FOVRadius*2,0,Settings.Aimbot.FOVRadius*2)
        fovCircle.Visible=fovOn
        if fovOn then fovStroke.Transparency=1-Settings.Aimbot.FOVOpacity end

        if currentTarget and currentTarget.Character and isTracking then
            if not targetHL then targetHL=Instance.new("Highlight"); targetHL.Name="BinxixLockMarker"; targetHL.FillColor=Theme.CardHeaderBg; targetHL.FillTransparency=0.7; targetHL.OutlineColor=Theme.TextAccent; targetHL.OutlineTransparency=0; targetHL.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop end
            targetHL.Parent=currentTarget.Character
        else if targetHL then targetHL.Parent=nil end end

        if not espOn and not radarOn then return end

        local myChar=player.Character; if not myChar then return end
        local myHRP=myChar:FindFirstChild("HumanoidRootPart"); if not myHRP then return end
        local cam=Workspace.CurrentCamera; if not cam then return end
        local camCF=cam.CFrame
        local ss=cam.ViewportSize
        local myPos=myHRP.Position

        local allPlayers=Players:GetPlayers()

        resetTracers()
        resetSkel()
        resetArrows()

        local tracerSP
        if tracerOn then
            if Settings.ESP.TracerOrigin=="Bottom" then tracerSP=Vector2.new(ss.X/2,ss.Y)
            elseif Settings.ESP.TracerOrigin=="Center" then tracerSP=Vector2.new(ss.X/2,ss.Y/2)
            elseif Settings.ESP.TracerOrigin=="Mouse" then local m=player:GetMouse(); tracerSP=Vector2.new(m.X,m.Y)
            else tracerSP=Vector2.new(ss.X/2,ss.Y) end
        end

        local camYaw,rh,radarScale,radarRange
        if radarOn then
            radarGui.Visible=true
            camYaw=math.atan2(-camCF.LookVector.X,-camCF.LookVector.Z)
            rh=Settings.Radar.Size/2; radarScale=Settings.Radar.Scale; radarRange=Settings.Radar.Range
            local activeIds={}; for _,t in ipairs(allPlayers) do activeIds[t.UserId]=true end
            for uid,dot in pairs(radarDots) do if not activeIds[uid] then dot:Destroy(); radarDots[uid]=nil end end
        else
            radarGui.Visible=false
        end

        local rainbowCol = (espOn and Settings.ESP.RainbowColor) and Color3.fromHSV(tick()%5/5,1,1) or nil

        for _,target in ipairs(allPlayers) do
            if target==player then continue end

            local tc=target.Character; if not tc then continue end
            local th=tc:FindFirstChild("HumanoidRootPart"); if not th then continue end
            local thead=tc:FindFirstChild("Head")
            local thum=tc:FindFirstChild("Humanoid")
            local tPos=th.Position
            local dist=(myPos-tPos).Magnitude
            local col=rainbowCol or getESPColor(dist)

            if radarOn then
                local rel=tPos-myPos
                local flatDist=Vector3.new(rel.X,0,rel.Z).Magnitude
                if flatDist<=radarRange then
                    local ang=math.atan2(rel.X,rel.Z)-camYaw
                    local nx=math.sin(ang)*(flatDist/radarRange)*rh*radarScale
                    local ny=-math.cos(ang)*(flatDist/radarRange)*rh*radarScale
                    local px=math.clamp(rh+nx,4,Settings.Radar.Size-4)
                    local py=math.clamp(rh+ny,4,Settings.Radar.Size-4)
                    if not radarDots[target.UserId] then
                        local dot=UILib.newFrame(radarGui,{Size=UDim2.new(0,5,0,5),AnchorPoint=Vector2.new(0.5,0.5),BorderSizePixel=0,ZIndex=4}); UILib.corner(dot,100); radarDots[target.UserId]=dot
                    end
                    local dot=radarDots[target.UserId]
                    dot.BackgroundColor3=isSameTeam(player,target) and Settings.Radar.TeamColor or Settings.Radar.EnemyColor
                    dot.Position=UDim2.new(0,px,0,py)
                else
                    if radarDots[target.UserId] then radarDots[target.UserId].Position=UDim2.new(0,-99,0,-99) end
                end
            end

            if not espOn then continue end
            local isESPTarget=isValidESPTarget(player,target)
            if not isESPTarget then
                if espObjects[target.UserId] then removeESP(target) end
                continue
            end

            local hrpSP,hrpOn=cam:WorldToViewportPoint(tPos)
            local hrpV2=hrpOn and hrpSP.Z>0 and Vector2.new(hrpSP.X,hrpSP.Y) or nil

            if thead and thum then
                if not espObjects[target.UserId] then createESP(target) end
                local d=espObjects[target.UserId]
                if d and d.billboard then
                    if thead and thead.Parent then
                        d.billboard.Adornee=thead; d.billboard.Parent=tc; d.billboard.Enabled=true
                    end
                    if d.nameLabel then d.nameLabel.Visible=Settings.ESP.NameEnabled; d.nameLabel.Text=target.DisplayName; d.nameLabel.TextColor3=col end
                    if d.distLabel then d.distLabel.Visible=Settings.ESP.DistanceEnabled; d.distLabel.Text=string.format("[%dm]",math.floor(dist)); d.distLabel.TextColor3=col end
                    if d.healthLabel then d.healthLabel.Visible=Settings.ESP.HealthEnabled; d.healthLabel.Text=string.format("%d HP",math.floor(thum.Health)); d.healthLabel.TextColor3=getHealthColor(thum.Health/thum.MaxHealth) end
                    if Settings.ESP.BoxEnabled then
                        if not d.boxHighlight then d.boxHighlight=Instance.new("Highlight"); d.boxHighlight.Name="BinxixBoxESP"; d.boxHighlight.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop end
                        d.boxHighlight.FillTransparency=Settings.ESP.ChamsEnabled and Settings.ESP.ChamsFillTransparency or 1
                        if Settings.ESP.ChamsEnabled then d.boxHighlight.FillColor=col end
                        d.boxHighlight.OutlineTransparency=Settings.ESP.OutlineEnabled and 0 or 1
                        d.boxHighlight.OutlineColor=(Settings.ESP.RainbowOutline and Color3.fromHSV(tick()%5/5,1,1)) or col
                        d.boxHighlight.Parent=tc; d.boxHighlight.Enabled=true
                    else if d.boxHighlight then d.boxHighlight.Enabled=false end end
                end
            end

            if tracerOn and hrpV2 then
                local line=getTracerLine()
                if line then
                    local thick=Settings.ESP.TracerThickness
                    local ld=(hrpV2-tracerSP).Magnitude
                    local center=(tracerSP+hrpV2)/2
                    local angle=math.atan2(hrpV2.Y-tracerSP.Y,hrpV2.X-tracerSP.X)
                    line.Size=UDim2.new(0,ld,0,thick); line.Position=UDim2.new(0,center.X,0,center.Y)
                    line.Rotation=math.deg(angle); line.BackgroundColor3=col; line.Visible=true
                end
            end

            if arrowOn and dist<=(Settings.ESP.ArrowDistance) then
                if not hrpOn or hrpSP.Z<0 then
                    local ad=getArrow()
                    if ad then
                        local sz=Settings.ESP.ArrowSize
                        local pad=60; local rx=ss.X/2-pad; local ry=ss.Y/2-pad
                        local sc2=Vector2.new(ss.X/2,ss.Y/2)
                        local dir=tPos-camCF.Position
                        local fd=Vector3.new(dir.X,0,dir.Z).Unit
                        local cl=Vector3.new(camCF.LookVector.X,0,camCF.LookVector.Z).Unit
                        local cr=Vector3.new(camCF.RightVector.X,0,camCF.RightVector.Z).Unit
                        local ang=math.atan2(fd:Dot(cr),fd:Dot(cl))
                        local ax=math.clamp(sc2.X+math.sin(ang)*rx,pad,ss.X-pad)
                        local ay=math.clamp(sc2.Y-math.cos(ang)*ry,pad,ss.Y-pad)
                        ad.container.Size=UDim2.new(0,sz+30,0,sz+16)
                        ad.container.Position=UDim2.new(0,ax,0,ay)
                        ad.arrow.Size=UDim2.new(0,sz,0,sz)
                        ad.arrow.Rotation=math.deg(ang); ad.arrow.ImageColor3=col
                        ad.distLabel.Text=math.floor(dist).."m"; ad.distLabel.TextColor3=col
                    end
                end
            end

            if skelOn and dist<=500 then
                local skelCol=rainbowCol or getESPColor(dist)
                local conns=tc:FindFirstChild("UpperTorso") and SKEL_R15 or SKEL_R6
                local thick=Settings.ESP.SkeletonThickness
                for _,c in ipairs(conns) do
                    local p1=tc:FindFirstChild(c[1]); local p2=tc:FindFirstChild(c[2])
                    if p1 and p2 then
                        local s1=cam:WorldToViewportPoint(p1.Position)
                        local s2=cam:WorldToViewportPoint(p2.Position)
                        if s1.Z>0 and s2.Z>0 then
                            local line=getSkelLine(); if not line then break end
                            local a=Vector2.new(s1.X,s1.Y); local b=Vector2.new(s2.X,s2.Y)
                            local ld=(b-a).Magnitude; local ctr=(a+b)/2
                            local ang=math.atan2(b.Y-a.Y,b.X-a.X)
                            line.Size=UDim2.new(0,ld,0,thick); line.Position=UDim2.new(0,ctr.X,0,ctr.Y)
                            line.Rotation=math.deg(ang); line.BackgroundColor3=skelCol; line.Visible=true
                        end
                    end
                end
            end
        end
    end))

    table.insert(allConnections,Players.PlayerRemoving:Connect(function(t)
        if espObjects[t.UserId] then removeESP(t) end
        if radarDots[t.UserId] then radarDots[t.UserId]:Destroy(); radarDots[t.UserId]=nil end
    end))

    -- ====================================================================
-- 3895nfk93
-- ====================================================================
    local WIN_W, WIN_H   = 580, 480
    local SIDEBAR_W      = 110
    local CONTENT_W      = WIN_W - SIDEBAR_W
    local CONTENT_PAD    = 8
    local CARD_W         = math.floor((CONTENT_W - CONTENT_PAD*3) / 2)
    local ROW_H          = 30
    local CARD_HEADER_H  = 24

    local mainFrame = UILib.newFrame(screenGui,{
        Name="MainFrame",Size=UDim2.new(0,WIN_W,0,WIN_H),
        Position=UDim2.new(0.5,-WIN_W/2,0.5,-WIN_H/2),
        BackgroundColor3=Theme.WindowBg,BorderSizePixel=0,Active=true,Visible=true
    })
    UILib.corner(mainFrame,8); UILib.stroke(mainFrame,Theme.WindowBorder,1.5)
    table.insert(themeCallbacks,function() mainFrame.BackgroundColor3=Theme.WindowBg end)

    local dragging,dragStart,startPos2=false,nil,nil
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true; dragStart=input.Position; startPos2=mainFrame.Position; input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging=false end end) end
    end)
    table.insert(allConnections,UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType==Enum.UserInputType.MouseMovement then local d=input.Position-dragStart; mainFrame.Position=UDim2.new(startPos2.X.Scale,startPos2.X.Offset+d.X,startPos2.Y.Scale,startPos2.Y.Offset+d.Y) end
    end))

    local sidebar = UILib.newFrame(mainFrame,{Name="Sidebar",Size=UDim2.new(0,SIDEBAR_W,1,0),BackgroundColor3=Theme.SidebarBg,BorderSizePixel=0,ClipsDescendants=true})
    UILib.corner(sidebar,8)
    UILib.newFrame(sidebar,{Size=UDim2.new(0,8,1,0),Position=UDim2.new(1,-8,0,0),BackgroundColor3=Theme.SidebarBg,BorderSizePixel=0})
    UILib.stroke(sidebar,Theme.SidebarBorder,1)
    local logoArea = UILib.newFrame(sidebar,{Size=UDim2.new(1,0,0,54),BackgroundColor3=Theme.SidebarBg,BorderSizePixel=0})
    UILib.newLabel(logoArea,{Size=UDim2.new(1,-8,0,24),Position=UDim2.new(0,8,0,6),Text="BINXIX",TextColor3=Theme.LogoText,TextSize=18,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Center})
    UILib.newLabel(logoArea,{Size=UDim2.new(1,-8,0,14),Position=UDim2.new(0,8,0,32),Text="v"..SCRIPT_VERSION_DISPLAY.." | "..currentGameData.name,TextColor3=Theme.TextDim,TextSize=9,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left})
    UILib.newFrame(sidebar,{Size=UDim2.new(1,-16,0,1),Position=UDim2.new(0,8,0,54),BackgroundColor3=Theme.SidebarBorder,BorderSizePixel=0})
    local tabList = UILib.newFrame(sidebar,{Size=UDim2.new(1,0,1,-60),Position=UDim2.new(0,0,0,60),BackgroundTransparency=1,BorderSizePixel=0})
    local layout = Instance.new("UIListLayout"); layout.SortOrder=Enum.SortOrder.LayoutOrder; layout.Padding=UDim.new(0,2); layout.Parent=tabList
    local pad2 = Instance.new("UIPadding"); pad2.PaddingLeft=UDim.new(0,6); pad2.PaddingRight=UDim.new(0,6); pad2.PaddingTop=UDim.new(0,4); pad2.Parent=tabList

    local tabs     = {"General","Aimbot","ESP","Crosshair","Radar","Social","Report","Settings"}
    local tabIcons = {General="*",Aimbot="+",ESP="@",Crosshair="x",Radar="O",Social="&",Report="!",Settings="~"}
    local tabBtns  = {}
    local tabPages = {}
    local tabBuilt = {}
    local activeTab= "General"

    local contentArea = UILib.newFrame(mainFrame,{Name="ContentArea",Size=UDim2.new(0,CONTENT_W,1,-2),Position=UDim2.new(0,SIDEBAR_W,0,1),BackgroundColor3=Theme.ContentBg,BorderSizePixel=0,ClipsDescendants=true})
    UILib.corner(contentArea,8)
    UILib.newFrame(contentArea,{Size=UDim2.new(0,8,1,0),Position=UDim2.new(0,0,0,0),BackgroundColor3=Theme.ContentBg,BorderSizePixel=0})
    local closeBtn=UILib.newButton(mainFrame,{Size=UDim2.new(0,22,0,22),Position=UDim2.new(1,-26,0,4),BackgroundColor3=Color3.fromRGB(180,50,50),BorderSizePixel=0,Text="x",TextColor3=Color3.fromRGB(255,255,255),TextSize=13,Font=Enum.Font.GothamBold,ZIndex=10},function() mainFrame.Visible=false end); UILib.corner(closeBtn,5)
    closeBtn.MouseEnter:Connect(function() closeBtn.BackgroundColor3=Color3.fromRGB(220,60,60) end)
    closeBtn.MouseLeave:Connect(function() closeBtn.BackgroundColor3=Color3.fromRGB(180,50,50) end)

    local function makeCard(parent, title, x, y, w, h_body)
        local wrapper = UILib.newFrame(parent,{Size=UDim2.new(0,w,0,CARD_HEADER_H+h_body),Position=UDim2.new(0,x,0,y),BackgroundColor3=Theme.CardBg,BorderSizePixel=0}); UILib.corner(wrapper,6); UILib.stroke(wrapper,Theme.CardBorder,1)
        local header = UILib.newFrame(wrapper,{Size=UDim2.new(1,0,0,CARD_HEADER_H),BackgroundColor3=Theme.CardHeaderBg,BorderSizePixel=0}); UILib.corner(header,6)
        UILib.newFrame(header,{Size=UDim2.new(1,0,0,8),Position=UDim2.new(0,0,1,-8),BackgroundColor3=Theme.CardHeaderBg,BorderSizePixel=0})
        UILib.newLabel(header,{Size=UDim2.new(1,-8,1,0),Position=UDim2.new(0,8,0,0),Text=title,TextColor3=Theme.CardHeaderText,TextSize=12,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left})
        local body = UILib.newFrame(wrapper,{Name="Body",Size=UDim2.new(1,0,0,h_body),Position=UDim2.new(0,0,0,CARD_HEADER_H),BackgroundTransparency=1,BorderSizePixel=0,ClipsDescendants=true})
        local bodyPad=Instance.new("UIPadding"); bodyPad.PaddingLeft=UDim.new(0,8); bodyPad.PaddingRight=UDim.new(0,8); bodyPad.PaddingTop=UDim.new(0,4); bodyPad.Parent=body
        table.insert(themeCallbacks,function() wrapper.BackgroundColor3=Theme.CardBg; header.BackgroundColor3=Theme.CardHeaderBg end)
        return body, wrapper
    end

    local function addToggleRow(body, label, yOff, default, callback)
        local row = UILib.newFrame(body,{Size=UDim2.new(1,0,0,ROW_H),Position=UDim2.new(0,0,0,yOff),BackgroundTransparency=1,BorderSizePixel=0})
        UILib.newLabel(row,{Size=UDim2.new(1,-44,1,0),Text=label,TextColor3=Theme.TextPrimary,TextSize=11,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left})
        local PILL_W,PILL_H = 34,16
        local pill = UILib.newFrame(row,{Size=UDim2.new(0,PILL_W,0,PILL_H),Position=UDim2.new(1,-PILL_W-2,0.5,-PILL_H/2),BackgroundColor3=default and Theme.ToggleOn or Theme.ToggleOff,BorderSizePixel=0}); UILib.corner(pill,100)
        local knob = UILib.newFrame(pill,{Size=UDim2.new(0,PILL_H-4,0,PILL_H-4),Position=default and UDim2.new(1,-(PILL_H-2),0.5,-(PILL_H-4)/2) or UDim2.new(0,2,0.5,-(PILL_H-4)/2),BackgroundColor3=Theme.ToggleKnob,BorderSizePixel=0}); UILib.corner(knob,100)
        local enabled = default
        UILib.newButton(row,{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=2},function()
            if isUnloading or _G.BinxixUnloaded or waitingForKey then return end
            enabled = not enabled
            UILib.tween(pill,0.15,{BackgroundColor3=enabled and Theme.ToggleOn or Theme.ToggleOff}):Play()
            UILib.tween(knob,0.15,{Position=enabled and UDim2.new(1,-(PILL_H-2),0.5,-(PILL_H-4)/2) or UDim2.new(0,2,0.5,-(PILL_H-4)/2)}):Play()
            if callback then callback(enabled) end
        end)
        table.insert(themeCallbacks,function() pill.BackgroundColor3=enabled and Theme.ToggleOn or Theme.ToggleOff end)
        return {
            setValue=function(v) enabled=v; pill.BackgroundColor3=v and Theme.ToggleOn or Theme.ToggleOff; knob.Position=v and UDim2.new(1,-(PILL_H-2),0.5,-(PILL_H-4)/2) or UDim2.new(0,2,0.5,-(PILL_H-4)/2) end,
            getValue=function() return enabled end,
            row=row
        }
    end

    local activeSlider = nil
    table.insert(allConnections,UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 then activeSlider=nil end
    end))
    table.insert(allConnections,UserInputService.InputChanged:Connect(function(inp)
        if not activeSlider or inp.UserInputType~=Enum.UserInputType.MouseMovement then return end
        if isUnloading or _G.BinxixUnloaded then activeSlider=nil; return end
        local s=activeSlider
        local ok=pcall(function()
            if not s.track or not s.track.Parent then activeSlider=nil; return end
            if not s.fill or not s.fill.Parent then activeSlider=nil; return end
            if not s.knob or not s.knob.Parent then activeSlider=nil; return end
            local mx=player:GetMouse().X
            local rx=math.clamp((mx-s.track.AbsolutePosition.X)/math.max(s.track.AbsoluteSize.X,1),0,1)
            local cur
            if s.max<=1 then cur=math.floor((s.min+rx*(s.max-s.min))*100)/100
            else cur=math.floor(s.min+rx*(s.max-s.min)+0.5) end
            s.fill.Size=UDim2.new(rx,0,1,0); s.knob.Position=UDim2.new(rx,0,0.5,0)
            if s.valLbl and s.valLbl.Parent then s.valLbl.Text=tostring(cur) end
            if s.callback then s.callback(cur) end
        end)
        if not ok then activeSlider=nil end
    end))

    local function addSliderRow(body, label, yOff, min, max, default, callback)
        local row = UILib.newFrame(body,{Size=UDim2.new(1,0,0,ROW_H+8),Position=UDim2.new(0,0,0,yOff),BackgroundTransparency=1,BorderSizePixel=0})
        UILib.newLabel(row,{Size=UDim2.new(0.55,0,0,14),Text=label,TextColor3=Theme.TextSecondary,TextSize=10,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left})
        local valLbl=UILib.newLabel(row,{Size=UDim2.new(0.35,0,0,14),Position=UDim2.new(0.6,0,0,0),Text=tostring(default),TextColor3=Theme.TextAccent,TextSize=10,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Right})
        local track=UILib.newFrame(row,{Size=UDim2.new(1,0,0,4),Position=UDim2.new(0,0,0,18),BackgroundColor3=Theme.SliderTrack,BorderSizePixel=0}); UILib.corner(track,4)
        local fill=UILib.newFrame(track,{Size=UDim2.new((default-min)/math.max(max-min,0.0001),0,1,0),BackgroundColor3=Theme.SliderFill,BorderSizePixel=0}); UILib.corner(fill,4)
        local knob=UILib.newFrame(track,{Size=UDim2.new(0,10,0,10),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new((default-min)/math.max(max-min,0.0001),0,0.5,0),BackgroundColor3=Theme.SliderKnob,BorderSizePixel=0}); UILib.corner(knob,100)
        UILib.newButton(row,{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text=""},nil).MouseButton1Down:Connect(function()
            if isUnloading or _G.BinxixUnloaded then return end
            activeSlider={track=track,fill=fill,knob=knob,valLbl=valLbl,min=min,max=max,callback=callback}
        end)
        return row
    end

    local function addEnumRow(body, label, yOff, options, default, callback)
        local ROW2 = ROW_H + 26
        local row = UILib.newFrame(body,{Size=UDim2.new(1,0,0,ROW2),Position=UDim2.new(0,0,0,yOff),BackgroundTransparency=1,BorderSizePixel=0})
        UILib.newLabel(row,{Size=UDim2.new(1,0,0,14),Text=label,TextColor3=Theme.TextSecondary,TextSize=10,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left})
        local btnRowW = CARD_W - 18
        local perBtn = math.floor(btnRowW / math.max(#options,1)) - 1
        local selected = default
        local btns = {}
        local function setSelected(idx)
            selected = options[idx]
            for i,b in ipairs(btns) do
                b.BackgroundColor3 = i==idx and Theme.EnumBgActive or Theme.EnumBg
                b.TextColor3 = i==idx and Theme.EnumTextActive or Theme.EnumText
            end
        end
        for i,opt in ipairs(options) do
            local idx = i
            local eb=UILib.newButton(row,{
                Size=UDim2.new(0,perBtn,0,18),
                Position=UDim2.new(0,(i-1)*(perBtn+2),0,16),
                BackgroundColor3=opt==default and Theme.EnumBgActive or Theme.EnumBg,
                BorderSizePixel=0,Text=opt,
                TextColor3=opt==default and Theme.EnumTextActive or Theme.EnumText,
                TextSize=9,Font=Enum.Font.GothamBold
            },function()
                if isUnloading or _G.BinxixUnloaded or waitingForKey then return end
                setSelected(idx)
                if callback then callback(opt) end
            end)
            UILib.corner(eb,4)
            table.insert(btns,eb)
        end
        for i,opt in ipairs(options) do
            if opt==default then setSelected(i); break end
        end
        table.insert(themeCallbacks,function()
            for i,b in ipairs(btns) do
                b.BackgroundColor3 = options[i]==selected and Theme.EnumBgActive or Theme.EnumBg
                b.TextColor3 = options[i]==selected and Theme.EnumTextActive or Theme.EnumText
            end
        end)
        return row
    end

    local function addKeybindRow(body, label, yOff, default, callback)
        local row = UILib.newFrame(body,{Size=UDim2.new(1,0,0,ROW_H),Position=UDim2.new(0,0,0,yOff),BackgroundTransparency=1,BorderSizePixel=0})
        UILib.newLabel(row,{Size=UDim2.new(1,-60,1,0),Text=label,TextColor3=Theme.TextSecondary,TextSize=10,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left})
        local kbBtn=UILib.newButton(row,{Size=UDim2.new(0,48,0,18),Position=UDim2.new(1,-50,0.5,-9),BackgroundColor3=Theme.KeybindBg,BorderSizePixel=0,Text=default.Name,TextColor3=Theme.KeybindText,TextSize=9,Font=Enum.Font.GothamBold}); UILib.corner(kbBtn,4)
        local cur=default
        kbBtn.MouseButton1Click:Connect(function()
            if waitingForKey then return end
            waitingForKey=true; kbBtn.Text="..."; kbBtn.TextColor3=Color3.fromRGB(255,255,100)
        end)
        table.insert(allConnections,UserInputService.InputBegan:Connect(function(inp,gp)
            if not waitingForKey then return end
            if inp.UserInputType~=Enum.UserInputType.Keyboard then return end
            cur=inp.KeyCode
            kbBtn.Text=inp.KeyCode.Name; kbBtn.TextColor3=Theme.KeybindText
            waitingForKey=false
            task.defer(function()
                if callback then callback(cur) end
            end)
        end))
        return row
    end

    local function addButtonRow(body, text, yOff, callback, color)
        local btn=UILib.newButton(body,{Size=UDim2.new(1,0,0,22),Position=UDim2.new(0,0,0,yOff),BackgroundColor3=color or Theme.CardHeaderBg,BorderSizePixel=0,Text=text,TextColor3=Color3.fromRGB(255,255,255),TextSize=11,Font=Enum.Font.GothamBold},callback); UILib.corner(btn,5)
        btn.MouseEnter:Connect(function() UILib.tween(btn,0.1,{BackgroundTransparency=0.25}):Play() end)
        btn.MouseLeave:Connect(function() UILib.tween(btn,0.1,{BackgroundTransparency=0}):Play() end)
        return btn
    end

    local function addInfoRow(body, text, yOff, color)
        return UILib.newLabel(body,{Size=UDim2.new(1,0,0,16),Position=UDim2.new(0,0,0,yOff),Text=text,TextColor3=color or Theme.TextDim,TextSize=9,Font=Enum.Font.SourceSansItalic,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true})
    end

    local function addInputRow(body, placeholder, yOff, default, callback)
        local box=UILib.newBox(body,{Size=UDim2.new(1,0,0,22),Position=UDim2.new(0,0,0,yOff),BackgroundColor3=Theme.InputBg,BorderSizePixel=1,BorderColor3=Theme.InputBorder,Text=default or "",PlaceholderText=placeholder,PlaceholderColor3=Theme.TextDim,TextColor3=Theme.TextPrimary,TextSize=10,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,ClearTextOnFocus=false}); UILib.corner(box,4)
        local pad=Instance.new("UIPadding"); pad.PaddingLeft=UDim.new(0,6); pad.Parent=box
        if callback then box.FocusLost:Connect(function() if box.Text~="" then callback(box.Text) end end) end
        return box
    end

    local function addDivider(body, yOff)
        UILib.newFrame(body,{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,0,yOff),BackgroundColor3=Theme.CardBorder,BorderSizePixel=0})
    end

    local function makePage(name)
        local pg = Instance.new("ScrollingFrame")
        pg.Name=name.."Page"; pg.Size=UDim2.new(1,0,1,0)
        pg.BackgroundTransparency=1; pg.BorderSizePixel=0
        pg.ScrollBarThickness=3; pg.ScrollBarImageColor3=Theme.CardHeaderBg
        pg.CanvasSize=UDim2.new(0,0,0,900); pg.ScrollingDirection=Enum.ScrollingDirection.Y
        pg.Visible=false; pg.Parent=contentArea
        return pg
    end

    local COL1_X = CONTENT_PAD
    local COL2_X = CONTENT_PAD + CARD_W + CONTENT_PAD

    local function col1Y(page)
        local n = page:FindFirstChild("_col1Y"); if not n then n=Instance.new("NumberValue"); n.Name="_col1Y"; n.Value=CONTENT_PAD; n.Parent=page end; return n
    end
    local function col2Y(page)
        local n = page:FindFirstChild("_col2Y"); if not n then n=Instance.new("NumberValue"); n.Name="_col2Y"; n.Value=CONTENT_PAD; n.Parent=page end; return n
    end

    local function addCard(page, col, title, rows)
        local h = 6
        for _,r in ipairs(rows) do
            if r[1]=="toggle"  then h=h+ROW_H+2
            elseif r[1]=="slider"  then h=h+ROW_H+10
            elseif r[1]=="enum"    then h=h+ROW_H+28
            elseif r[1]=="keybind" then h=h+ROW_H+2
            elseif r[1]=="button"  then h=h+26
            elseif r[1]=="info"    then h=h+18
            elseif r[1]=="divider" then h=h+6
            elseif r[1]=="input"   then h=h+26
            end
        end
        h = h + 4
        local x = col==1 and COL1_X or COL2_X
        local yVal = col==1 and col1Y(page) or col2Y(page)
        local body, wrapper = makeCard(page, title, x, yVal.Value, CARD_W, h)
        yVal.Value = yVal.Value + CARD_HEADER_H + h + CONTENT_PAD

        local ry = 0
        for _,r in ipairs(rows) do
            local rtype = r[1]
            if rtype=="toggle" then addToggleRow(body,r[2],ry,r[3],r[4]); ry=ry+ROW_H+2
            elseif rtype=="slider" then addSliderRow(body,r[2],ry,r[3],r[4],r[5],r[6]); ry=ry+ROW_H+10
            elseif rtype=="enum" then addEnumRow(body,r[2],ry,r[3],r[4],r[5]); ry=ry+ROW_H+28
            elseif rtype=="keybind" then addKeybindRow(body,r[2],ry,r[3],r[4]); ry=ry+ROW_H+2
            elseif rtype=="button" then addButtonRow(body,r[2],ry,r[3],r[4]); ry=ry+26
            elseif rtype=="info" then addInfoRow(body,r[2],ry,r[3]); ry=ry+18
            elseif rtype=="divider" then addDivider(body,ry+2); ry=ry+6
            elseif rtype=="input" then addInputRow(body,r[2],ry,r[3],r[4]); ry=ry+26
            end
        end
        local maxY = math.max(col1Y(page).Value, col2Y(page).Value)
        page.CanvasSize = UDim2.new(0,0,0,maxY+CONTENT_PAD)
        return body, wrapper
    end

    local tabBuilders = {}

    local function makeTabBtn(name, icon, index)
        local btn=UILib.newButton(tabList,{Name=name.."Tab",Size=UDim2.new(1,0,0,34),BackgroundColor3=index==1 and Theme.TabBgActive or Theme.TabBg,BorderSizePixel=0,Text="",LayoutOrder=index}); UILib.corner(btn,6)
        local iconLbl=UILib.newLabel(btn,{Size=UDim2.new(0,20,1,0),Position=UDim2.new(0,8,0,0),Text=icon,TextColor3=index==1 and Theme.TabIconActive or Theme.TabIcon,TextSize=14,Font=Enum.Font.GothamBold})
        local nameLbl=UILib.newLabel(btn,{Size=UDim2.new(1,-32,1,0),Position=UDim2.new(0,30,0,0),Text=name,TextColor3=index==1 and Theme.TabTextActive or Theme.TabText,TextSize=11,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left})
        btn.MouseEnter:Connect(function() if activeTab~=name then btn.BackgroundColor3=Theme.TabBgHover end end)
        btn.MouseLeave:Connect(function() if activeTab~=name then btn.BackgroundColor3=Theme.TabBg end end)
        table.insert(themeCallbacks,function()
            if activeTab==name then btn.BackgroundColor3=Theme.TabBgActive; iconLbl.TextColor3=Theme.TabIconActive; nameLbl.TextColor3=Theme.TabTextActive
            else btn.BackgroundColor3=Theme.TabBg; iconLbl.TextColor3=Theme.TabIcon; nameLbl.TextColor3=Theme.TabText end
        end)
        tabBtns[name]={btn=btn,icon=iconLbl,label=nameLbl}; tabBuilt[name]=false
        return btn
    end

    local function switchTab(name)
        if isUnloading or _G.BinxixUnloaded then return end
        local prev=activeTab; activeTab=name
        if tabBtns[prev] then tabBtns[prev].btn.BackgroundColor3=Theme.TabBg; tabBtns[prev].icon.TextColor3=Theme.TabIcon; tabBtns[prev].label.TextColor3=Theme.TabText end
        if tabBtns[name] then tabBtns[name].btn.BackgroundColor3=Theme.TabBgActive; tabBtns[name].icon.TextColor3=Theme.TabIconActive; tabBtns[name].label.TextColor3=Theme.TabTextActive end
        if not tabBuilt[name] and tabBuilders[name] then tabBuilders[name](tabPages[name]); tabBuilt[name]=true end
        for n,pg in pairs(tabPages) do pg.Visible=n==name end
    end

    for i,name in ipairs(tabs) do
        local btn=makeTabBtn(name,tabIcons[name],i)
        btn.MouseButton1Click:Connect(function() switchTab(name) end)
        tabPages[name]=makePage(name)
    end

    local speedVel = nil

    tabBuilders["General"] = function(page)
        if not currentGameData.noMovement then
            addCard(page,1,"Speed",{
                {"toggle","Speed Boost",Settings.Movement.SpeedEnabled,function(e)
                    Settings.Movement.SpeedEnabled=e
                    if not e then
                        if speedVel then pcall(function() speedVel:Destroy() end); speedVel=nil end
                        local c=player.Character; if c then local h=c:FindFirstChild("Humanoid"); if h then h.WalkSpeed=16 end end
                    end
                end},
                {"slider","Speed",1,300,Settings.Movement.Speed,function(v)
                    Settings.Movement.Speed=v
                    if Settings.Movement.SpeedEnabled and Settings.Movement.SpeedMethod=="WalkSpeed" then
                        local c=player.Character; if c then local h=c:FindFirstChild("Humanoid"); if h then h.WalkSpeed=v end end
                    end
                end},
                {"enum","Method",{"Walk","CFrame","Vel"},"Walk",function(v)
                    local m={Walk="WalkSpeed",CFrame="CFrame",Vel="Velocity"}
                    if speedVel then pcall(function() speedVel:Destroy() end); speedVel=nil end
                    local c=player.Character; if c then local h=c:FindFirstChild("Humanoid"); if h then h.WalkSpeed=16 end end
                    Settings.Movement.SpeedMethod=m[v] or "WalkSpeed"
                end},
            })
            addCard(page,1,"Jump & Bhop",{
                {"toggle","High Jump",Settings.Movement.JumpEnabled,function(e)
                    Settings.Movement.JumpEnabled=e
                    local c=player.Character; if c then local h=c:FindFirstChild("Humanoid"); if h then h.JumpPower=e and Settings.Movement.JumpPower or 50 end end
                end},
                {"slider","Jump Power",50,300,Settings.Movement.JumpPower,function(v)
                    Settings.Movement.JumpPower=v
                    if Settings.Movement.JumpEnabled then local c=player.Character; if c then local h=c:FindFirstChild("Humanoid"); if h then h.JumpPower=v end end end
                end},
                {"toggle","Bunny Hop",Settings.Movement.BunnyHop,function(e) Settings.Movement.BunnyHop=e end},
                {"slider","Bhop Speed",1,100,Settings.Movement.BunnyHopSpeed,function(v) Settings.Movement.BunnyHopSpeed=v end},
            })
            addCard(page,1,"Fly",{
                {"toggle","Enable Fly",Settings.Movement.Fly,function(e)
                    Settings.Movement.Fly=e
                    if e then startFly(); sendNotification("Fly","On - F to toggle",2)
                    else stopFly(); sendNotification("Fly","Off",2) end
                end},
                {"slider","Fly Speed",10,200,Settings.Movement.FlySpeed,function(v) Settings.Movement.FlySpeed=v end},
                {"info","F key = toggle fly while enabled",Theme.TextDim},
            })
            addCard(page,1,"Auto TP",{
                {"info","Risky - may cause ban",Theme.WarnColor},
                {"toggle","Auto TP Loop",Settings.Misc.AutoTPLoop,function(e)
                    Settings.Misc.AutoTPLoop=e
                    if e then startAutoTPLoop(); sendNotification("Auto TP","On - "..Settings.Misc.AutoTPTargetName,2)
                    else stopAutoTPLoop(); sendNotification("Auto TP","Off",2) end
                end},
                {"slider","TP Delay (s)",0.05,2,Settings.Misc.AutoTPLoopDelay,function(v) Settings.Misc.AutoTPLoopDelay=v end},
                {"keybind","TP Keybind",Settings.Keybinds.ToggleAutoTP,function(v) Settings.Keybinds.ToggleAutoTP=v end},
            })
        else
            local b,_=makeCard(page,"Movement Disabled",COL1_X,CONTENT_PAD,CARD_W,40)
            addInfoRow(b,"Movement mods disabled for "..currentGameData.name,0,Color3.fromRGB(255,100,100))
            col1Y(page).Value=col1Y(page).Value+CARD_HEADER_H+44+CONTENT_PAD
        end

        addCard(page,2,"Visuals",{
            {"toggle","Fullbright",Settings.Visuals.Fullbright,function(e)
                Settings.Visuals.Fullbright=e
                if e then Lighting.Ambient=Color3.fromRGB(255,255,255); Lighting.Brightness=2; Lighting.OutdoorAmbient=Color3.fromRGB(255,255,255)
                else Lighting.Ambient=Color3.fromRGB(127,127,127); Lighting.Brightness=1; Lighting.OutdoorAmbient=Color3.fromRGB(127,127,127) end
            end},
            {"toggle","No Fog",Settings.Visuals.NoFog,function(e) Settings.Visuals.NoFog=e; if e then enableNoFog() else disableNoFog() end end},
            {"toggle","Custom FOV",Settings.Visuals.CustomFOV,function(e)
                Settings.Visuals.CustomFOV=e
                local cam=Workspace.CurrentCamera; if cam then cam.FieldOfView=e and Settings.Visuals.FOVAmount or 70 end
            end},
            {"slider","FOV Amount",30,120,Settings.Visuals.FOVAmount,function(v)
                Settings.Visuals.FOVAmount=v
                if Settings.Visuals.CustomFOV then local cam=Workspace.CurrentCamera; if cam then cam.FieldOfView=v end end
            end},
            {"toggle","Show FPS",Settings.Visuals.ShowFPS,function(e) Settings.Visuals.ShowFPS=e end},
            {"toggle","Show Velocity",Settings.Visuals.ShowVelocity,function(e) Settings.Visuals.ShowVelocity=e end},
        })
        addCard(page,2,"Gun Mods",{
            {"info","May not work on all games",Theme.WarnColor},
            {"toggle","Fast Reload",Settings.Combat.FastReload,function(e) Settings.Combat.FastReload=e; if e then applyAllGunMods() else restoreGunMod("ReloadTime"); restoreGunMod("EReloadTime") end end},
            {"toggle","Fast Fire Rate",Settings.Combat.FastFireRate,function(e) Settings.Combat.FastFireRate=e; if e then applyAllGunMods() else restoreGunMod("FireRate") end end},
            {"toggle","Always Auto",Settings.Combat.AlwaysAuto,function(e) Settings.Combat.AlwaysAuto=e; if e then applyAllGunMods() else restoreGunMod("Auto") end end},
            {"toggle","No Spread",Settings.Combat.NoSpread,function(e) Settings.Combat.NoSpread=e; if e then applyAllGunMods() else restoreGunMod("Spread") end end},
            {"toggle","No Recoil",Settings.Combat.NoRecoil,function(e) Settings.Combat.NoRecoil=e; if e then applyAllGunMods() else restoreGunMod("Recoil") end end},
        })
        addCard(page,2,"Misc",{
            {"toggle","Anti-AFK",Settings.Misc.AntiAFK,function(e) Settings.Misc.AntiAFK=e end},
            {"toggle","Chat Spammer",Settings.Misc.ChatSpammer,function(e) Settings.Misc.ChatSpammer=e end},
            {"slider","Spam Delay (s)",0.5,10,Settings.Misc.ChatSpamDelay,function(v) Settings.Misc.ChatSpamDelay=v end},
        })
        addCard(page,2,"Server",{
            {"button","Rejoin Server",function() pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId,game.JobId,player) end) end},
            {"button","Server Hop",function() pcall(function() TeleportService:Teleport(game.PlaceId,player) end) end},
        })
    end

    tabBuilders["Aimbot"] = function(page)
        addCard(page,1,"Aimbot",{
            {"toggle","Enabled",Settings.Aimbot.Enabled,function(e) Settings.Aimbot.Enabled=e; sendNotification("Aimbot",e and "On" or "Off",2) end},
            {"toggle","Toggle Mode (RMB)",Settings.Aimbot.Toggle,function(e) Settings.Aimbot.Toggle=e end},
            {"toggle","Require LOS",Settings.Aimbot.RequireLOS,function(e) Settings.Aimbot.RequireLOS=e end},
            {"toggle","Prediction",Settings.Aimbot.Prediction,function(e) Settings.Aimbot.Prediction=e end},
            {"toggle","Multi-Target Cycle",Settings.Aimbot.MultiTarget,function(e) Settings.Aimbot.MultiTarget=e end},
            {"info","Tab = cycle targets when Multi-Target on",Theme.TextDim},
        })
        addCard(page,1,"Aim Config",{
            {"slider","Smoothness",1,100,math.floor(Settings.Aimbot.Smoothness*100),function(v) Settings.Aimbot.Smoothness=v/100 end},
            {"slider","Prediction Amt",1,30,math.floor(Settings.Aimbot.PredictionAmount*100),function(v) Settings.Aimbot.PredictionAmount=v/100 end},
            {"slider","Max Distance",100,1000,Settings.Aimbot.MaxDistance,function(v) Settings.Aimbot.MaxDistance=v end},
            {"enum","Lock Part",{"Head","HRP","UTorso","Torso"},"Head",function(v)
                local m={Head="Head",HRP="HumanoidRootPart",UTorso="UpperTorso",Torso="Torso"}
                Settings.Aimbot.LockPart=m[v] or "Head"
            end},
        })
        addCard(page,2,"FOV",{
            {"toggle","Show FOV Circle",Settings.Aimbot.ShowFOV,function(e) Settings.Aimbot.ShowFOV=e end},
            {"slider","FOV Radius",50,400,Settings.Aimbot.FOVRadius,function(v) Settings.Aimbot.FOVRadius=v end},
            {"slider","FOV Opacity",0,100,math.floor(Settings.Aimbot.FOVOpacity*100),function(v) Settings.Aimbot.FOVOpacity=v/100 end},
        })
    end

    tabBuilders["ESP"] = function(page)
        if gameConfig.espEnabled then
            addCard(page,1,"ESP",{
                {"toggle","Enabled",Settings.ESP.Enabled,function(e) Settings.ESP.Enabled=e; sendNotification("ESP",e and "On" or "Off",2) end},
                {"toggle","Display Name",Settings.ESP.NameEnabled,function(e) Settings.ESP.NameEnabled=e end},
                {"toggle","Display Health",Settings.ESP.HealthEnabled,function(e) Settings.ESP.HealthEnabled=e end},
                {"toggle","Display Distance",Settings.ESP.DistanceEnabled,function(e) Settings.ESP.DistanceEnabled=e end},
                {"toggle","Display Box",Settings.ESP.BoxEnabled,function(e) Settings.ESP.BoxEnabled=e end},
                {"toggle","Chams (Wallhack)",Settings.ESP.ChamsEnabled,function(e) Settings.ESP.ChamsEnabled=e; sendNotification("Chams",e and "On" or "Off",2) end},
                {"toggle","Rainbow Color",Settings.ESP.RainbowColor,function(e) Settings.ESP.RainbowColor=e end},
                {"toggle","Rainbow Outline",Settings.ESP.RainbowOutline,function(e) Settings.ESP.RainbowOutline=e end},
                {"toggle","Outline",Settings.ESP.OutlineEnabled,function(e) Settings.ESP.OutlineEnabled=e end},
                {"enum","Filter",{"Enemy","Team","All"},"Enemy",function(v)
                    local m={Enemy="Enemies",Team="Team",All="All"}
                    Settings.ESP.FilterMode=m[v] or "Enemies"
                end},
            })
            addCard(page,1,"Chams",{
                {"slider","Chams Fill",0,100,math.floor(Settings.ESP.ChamsFillTransparency*100),function(v) Settings.ESP.ChamsFillTransparency=v/100 end},
                {"slider","Font Size",10,24,Settings.ESP.FontSize,function(v) Settings.ESP.FontSize=v end},
            })
            addCard(page,2,"Tracer",{
                {"toggle","Tracer Enabled",Settings.ESP.TracerEnabled,function(e) Settings.ESP.TracerEnabled=e end},
                {"toggle","Rainbow Color",Settings.ESP.TracerRainbowColor,function(e) Settings.ESP.TracerRainbowColor=e end},
                {"slider","Thickness",1,5,Settings.ESP.TracerThickness,function(v) Settings.ESP.TracerThickness=v end},
                {"enum","Origin",{"Bottom","Center","Mouse"},"Bottom",function(v) Settings.ESP.TracerOrigin=v end},
            })
            addCard(page,2,"Skeleton",{
                {"toggle","Skeleton Enabled",Settings.ESP.SkeletonEnabled,function(e) Settings.ESP.SkeletonEnabled=e end},
                {"slider","Thickness",1,5,Settings.ESP.SkeletonThickness,function(v) Settings.ESP.SkeletonThickness=v end},
            })
            addCard(page,2,"Offscreen Arrows",{
                {"toggle","Arrows Enabled",Settings.ESP.OffscreenArrows,function(e) Settings.ESP.OffscreenArrows=e end},
                {"slider","Arrow Size",10,40,Settings.ESP.ArrowSize,function(v) Settings.ESP.ArrowSize=v end},
                {"slider","Arrow Distance",100,1000,Settings.ESP.ArrowDistance,function(v) Settings.ESP.ArrowDistance=v end},
            })
        else
            local b,_=makeCard(page,"ESP Override",COL1_X,CONTENT_PAD,CARD_W*2+CONTENT_PAD,80)
            col1Y(page).Value=col1Y(page).Value+CARD_HEADER_H+84+CONTENT_PAD
            addInfoRow(b,"ESP is not officially supported for "..currentGameData.name..". Use at your own risk.",0,Theme.WarnColor)
            addButtonRow(b,"Force Enable ESP Override",22,function()
                gameConfig.espEnabled=true; sendNotification("ESP Override","Force-enabled",3)
                for _,c in ipairs(page:GetChildren()) do if not c:IsA("NumberValue") then c:Destroy() end end
                tabBuilders["ESP"](page)
            end)
        end
    end

    tabBuilders["Crosshair"] = function(page)
        addCard(page,1,"Crosshair",{
            {"toggle","Enabled",Settings.Crosshair.Enabled,function(e) Settings.Crosshair.Enabled=e end},
            {"toggle","Rainbow Color",Settings.Crosshair.RainbowColor,function(e) Settings.Crosshair.RainbowColor=e end},
            {"toggle","Outline",Settings.Crosshair.OutlineEnabled,function(e) Settings.Crosshair.OutlineEnabled=e end},
            {"toggle","Center Dot",Settings.Crosshair.CenterDot,function(e) Settings.Crosshair.CenterDot=e end},
            {"toggle","Dynamic Spread",Settings.Crosshair.DynamicSpread,function(e) Settings.Crosshair.DynamicSpread=e end},
            {"enum","Style",{"Cross","Dot","Circle","X","KV","Sniper"},"Cross",function(v)
                local m={Cross="Cross",Dot="Dot",Circle="Circle",X="X-Shape",KV="KV",Sniper="Sniper"}
                Settings.Crosshair.Style=m[v] or "Cross"
            end},
        })
        addCard(page,1,"Crosshair Size",{
            {"slider","Size",2,50,Settings.Crosshair.Size,function(v) Settings.Crosshair.Size=v end},
            {"slider","Thickness",1,8,Settings.Crosshair.Thickness,function(v) Settings.Crosshair.Thickness=v end},
            {"slider","Gap",0,30,Settings.Crosshair.Gap,function(v) Settings.Crosshair.Gap=v end},
            {"slider","Center Dot Size",1,12,Settings.Crosshair.CenterDotSize,function(v) Settings.Crosshair.CenterDotSize=v end},
            {"slider","Outline Thick",1,4,Settings.Crosshair.OutlineThickness,function(v) Settings.Crosshair.OutlineThickness=v end},
            {"slider","Opacity %",0,100,math.floor(Settings.Crosshair.Opacity*100),function(v) Settings.Crosshair.Opacity=v/100 end},
        })
        local col2y = col2Y(page)
        local cpY = col2y.Value
        local cbody,_=makeCard(page,"Crosshair Color",COL2_X,cpY,CARD_W,100)
        col2y.Value = cpY + CARD_HEADER_H + 104 + CONTENT_PAD
        local function makeColorSliders(body, getColor, setColor, startY)
            local r = math.floor(getColor().R*255); local g = math.floor(getColor().G*255); local b = math.floor(getColor().B*255)
            local preview = UILib.newFrame(body,{Size=UDim2.new(0,16,0,16),Position=UDim2.new(1,-18,0,startY),BackgroundColor3=getColor(),BorderSizePixel=0}); UILib.corner(preview,3)
            local channels={{Color3.fromRGB(255,80,80),"R"},{Color3.fromRGB(80,220,80),"G"},{Color3.fromRGB(80,120,255),"B"}}
            local vals = {r, g, b}
            local function sampleTrack(track, fill, knob, chanIdx)
                local mx = player:GetMouse().X
                local rx = math.clamp((mx - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
                local v = math.floor(rx * 255 + 0.5)
                fill.Size = UDim2.new(rx, 0, 1, 0)
                knob.Position = UDim2.new(rx, 0, 0.5, 0)
                vals[chanIdx] = v
                local newCol = Color3.fromRGB(vals[1], vals[2], vals[3])
                setColor(newCol); preview.BackgroundColor3 = newCol
            end
            for i, ch in ipairs(channels) do
                local yy = startY + (i-1)*26
                local idx = i
                UILib.newLabel(body,{Size=UDim2.new(0,10,0,12),Position=UDim2.new(0,0,0,yy+6),Text=ch[2],TextColor3=ch[1],TextSize=9,Font=Enum.Font.GothamBold})
                local track=UILib.newFrame(body,{Size=UDim2.new(1,-16,0,4),Position=UDim2.new(0,14,0,yy+10),BackgroundColor3=Theme.SliderTrack,BorderSizePixel=0}); UILib.corner(track,4)
                local fill=UILib.newFrame(track,{Size=UDim2.new(vals[i]/255,0,1,0),BackgroundColor3=ch[1],BorderSizePixel=0}); UILib.corner(fill,4)
                local knob=UILib.newFrame(track,{Size=UDim2.new(0,10,0,10),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(vals[i]/255,0,0.5,0),BackgroundColor3=Theme.ToggleKnob,BorderSizePixel=0}); UILib.corner(knob,100)
                local hitZone = Instance.new("TextButton")
                hitZone.Size = UDim2.new(1, 0, 0, 22)
                hitZone.Position = UDim2.new(0, 0, 0, yy + 2)
                hitZone.BackgroundTransparency = 0.99
                hitZone.BorderSizePixel = 0
                hitZone.Text = ""
                hitZone.ZIndex = 5
                hitZone.Parent = body
                hitZone.MouseButton1Down:Connect(function()
                    if isUnloading or _G.BinxixUnloaded then return end
                    sampleTrack(track, fill, knob, idx)
                    activeSlider = {
                        track = track, fill = fill, knob = knob,
                        valLbl = nil, min = 0, max = 255,
                        callback = function(v)
                            vals[idx] = math.floor(v)
                            local newCol = Color3.fromRGB(vals[1], vals[2], vals[3])
                            setColor(newCol); preview.BackgroundColor3 = newCol
                        end
                    }
                end)
            end
        end
        makeColorSliders(cbody,function() return Settings.Crosshair.Color end,function(c) Settings.Crosshair.Color=c end,0)
        local obody,_=makeCard(page,"Outline Color",COL2_X,col2y.Value,CARD_W,100)
        col2y.Value = col2y.Value + CARD_HEADER_H + 104 + CONTENT_PAD
        makeColorSliders(obody,function() return Settings.Crosshair.OutlineColor end,function(c) Settings.Crosshair.OutlineColor=c end,0)
        addCard(page,2,"Info",{
            {"info","Preview renders in-game when Enabled.",Theme.TextDim},
            {"info","X maps to X-Shape. Sniper = fullscreen lines.",Theme.TextDim},
        })
        page.CanvasSize=UDim2.new(0,0,0,math.max(col1Y(page).Value,col2Y(page).Value)+CONTENT_PAD)
    end

    tabBuilders["Radar"] = function(page)
        addCard(page,1,"Radar",{
            {"toggle","Enable Radar",Settings.Radar.Enabled,function(e) Settings.Radar.Enabled=e; sendNotification("Radar",e and "On" or "Off",2) end},
            {"slider","Radar Size",80,300,Settings.Radar.Size,function(v) Settings.Radar.Size=v; radarGui.Size=UDim2.new(0,v,0,v); radarGui.Position=UDim2.new(0,10,1,-v-10) end},
            {"slider","Range (studs)",50,1000,Settings.Radar.Range,function(v) Settings.Radar.Range=v end},
            {"slider","Dot Scale",0,100,math.floor(Settings.Radar.Scale*100),function(v) Settings.Radar.Scale=v/100 end},
            {"info","Radar appears bottom-left when enabled.",Theme.TextDim},
        })
        addCard(page,2,"Radar Colors",{
            {"info","Enemy dot: red  Team dot: green  Self: white",Theme.TextDim},
            {"info","Color customization in Settings > Custom Theme.",Theme.TextDim},
        })
    end

    local function openURL(url)
        local opened = false
        pcall(function() if openurl then openurl(url); opened=true end end)
        if not opened then pcall(function() if open_url then open_url(url); opened=true end end) end
        if not opened then pcall(function() if OPENURL then OPENURL(url); opened=true end end) end
        if not opened then pcall(function() if syn and syn.openurl then syn.openurl(url); opened=true end end) end
        if not opened then
            pcall(function() if setclipboard then setclipboard(url) end end)
            sendNotification("Link Copied",url,5)
        else
            sendNotification("Browser Opened","Opening in browser...",3)
        end
    end

    tabBuilders["Social"] = function(page)
        local bannerW = CARD_W*2 + CONTENT_PAD
        local bannerH = 70
        local bannerY = col1Y(page).Value
        local bannerBg = UILib.newFrame(page,{
            Size=UDim2.new(0,bannerW,0,bannerH),
            Position=UDim2.new(0,COL1_X,0,bannerY),
            BackgroundColor3=Color3.fromRGB(24,16,36),
            BorderSizePixel=0
        })
        UILib.corner(bannerBg,8); UILib.stroke(bannerBg,Color3.fromRGB(140,60,200),1.5)
        UILib.newFrame(bannerBg,{Size=UDim2.new(0,4,1,0),BackgroundColor3=Color3.fromRGB(180,80,255),BorderSizePixel=0})
        UILib.newLabel(bannerBg,{
            Size=UDim2.new(1,-16,0,28),Position=UDim2.new(0,14,0,8),
            Text="binxix",TextColor3=Color3.fromRGB(210,140,255),
            TextSize=22,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left
        })
        UILib.newLabel(bannerBg,{
            Size=UDim2.new(1,-16,0,18),Position=UDim2.new(0,14,0,38),
            Text="Click any link below to open it in your browser",
            TextColor3=Color3.fromRGB(130,110,155),
            TextSize=10,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left
        })
        local bannerBottom = bannerY + bannerH + CONTENT_PAD
        col1Y(page).Value = bannerBottom
        col2Y(page).Value = bannerBottom

        local function makeLinkCard(col, icon, label, sublabel, url, accentColor)
            local cardH = 54
            local x = col==1 and COL1_X or COL2_X
            local yVal = col==1 and col1Y(page) or col2Y(page)
            local cardBg = UILib.newFrame(page,{
                Size=UDim2.new(0,CARD_W,0,cardH),
                Position=UDim2.new(0,x,0,yVal.Value),
                BackgroundColor3=Color3.fromRGB(26,22,36),
                BorderSizePixel=0,Active=true
            })
            UILib.corner(cardBg,8); UILib.stroke(cardBg,accentColor,1.2)
            UILib.newFrame(cardBg,{Size=UDim2.new(0,3,1,0),BackgroundColor3=accentColor,BorderSizePixel=0})
            local iconCircle = UILib.newFrame(cardBg,{
                Size=UDim2.new(0,32,0,32),Position=UDim2.new(0,14,0.5,-16),
                BackgroundColor3=Color3.fromRGB(36,28,52),BorderSizePixel=0
            }); UILib.corner(iconCircle,100); UILib.stroke(iconCircle,accentColor,1)
            UILib.newLabel(iconCircle,{
                Size=UDim2.new(1,0,1,0),Text=icon,
                TextColor3=accentColor,TextSize=14,Font=Enum.Font.GothamBold,
                TextXAlignment=Enum.TextXAlignment.Center,TextYAlignment=Enum.TextYAlignment.Center
            })
            UILib.newLabel(cardBg,{
                Size=UDim2.new(1,-70,0,18),Position=UDim2.new(0,54,0,8),
                Text=label,TextColor3=Color3.fromRGB(220,215,235),
                TextSize=12,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left
            })
            UILib.newLabel(cardBg,{
                Size=UDim2.new(1,-70,0,14),Position=UDim2.new(0,54,0,28),
                Text=sublabel,TextColor3=Color3.fromRGB(120,110,140),
                TextSize=9,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,
                TextTruncate=Enum.TextTruncate.AtEnd
            })
            UILib.newLabel(cardBg,{
                Size=UDim2.new(0,20,1,0),Position=UDim2.new(1,-24,0,0),
                Text=">",TextColor3=accentColor,TextSize=14,Font=Enum.Font.GothamBold,
                TextXAlignment=Enum.TextXAlignment.Center,TextYAlignment=Enum.TextYAlignment.Center
            })
            local clickBtn = UILib.newButton(cardBg,{
                Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=5
            },function() openURL(url) end)
            clickBtn.MouseEnter:Connect(function()
                UILib.tween(cardBg,0.12,{BackgroundColor3=Color3.fromRGB(36,28,52)}):Play()
            end)
            clickBtn.MouseLeave:Connect(function()
                UILib.tween(cardBg,0.12,{BackgroundColor3=Color3.fromRGB(26,22,36)}):Play()
            end)
            yVal.Value = yVal.Value + cardH + CONTENT_PAD
            page.CanvasSize = UDim2.new(0,0,0,math.max(col1Y(page).Value,col2Y(page).Value)+CONTENT_PAD)
        end

        makeLinkCard(1, "W", "Binxix Hub Website","binxixhub.vercel.app","https://binxixhub.vercel.app/",Color3.fromRGB(160,80,255))
        makeLinkCard(2, "T", "TikTok","@_binxix","https://www.tiktok.com/@_binxix",Color3.fromRGB(255,40,80))
        makeLinkCard(1, "G", "guns.lol Profile","guns.lol/binxix","https://guns.lol/binxix",Color3.fromRGB(255,160,40))
        makeLinkCard(2, "D", "Discord Server","discord.gg/S4nPV2Rx7F","https://discord.gg/S4nPV2Rx7F",Color3.fromRGB(88,101,242))

        local lsY = math.max(col1Y(page).Value, col2Y(page).Value)
        local lsBg = UILib.newFrame(page,{
            Size=UDim2.new(0,bannerW,0,44),
            Position=UDim2.new(0,COL1_X,0,lsY),
            BackgroundColor3=Color3.fromRGB(20,26,20),BorderSizePixel=0
        })
        UILib.corner(lsBg,8); UILib.stroke(lsBg,Color3.fromRGB(50,180,80),1)
        UILib.newLabel(lsBg,{
            Size=UDim2.new(1,-120,1,0),Position=UDim2.new(0,12,0,0),
            Text="Copy Loadstring to Clipboard",
            TextColor3=Color3.fromRGB(100,220,120),TextSize=11,Font=Enum.Font.GothamBold,
            TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Center
        })
        local copyBtn = UILib.newButton(lsBg,{
            Size=UDim2.new(0,90,0,28),Position=UDim2.new(1,-98,0.5,-14),
            BackgroundColor3=Color3.fromRGB(35,80,40),BorderSizePixel=0,
            Text="Copy",TextColor3=Color3.fromRGB(100,220,120),TextSize=11,Font=Enum.Font.GothamBold
        },function()
            local ls='loadstring(game:HttpGet("https://raw.githubusercontent.com/binx-ux/binxix-hub-v7/main/source/main.lua"))()'
            pcall(function() if setclipboard then setclipboard(ls) end end)
            sendNotification("Loadstring","Copied to clipboard!",3)
        end); UILib.corner(copyBtn,6)
        col1Y(page).Value = lsY + 44 + CONTENT_PAD
        col2Y(page).Value = col1Y(page).Value
        page.CanvasSize = UDim2.new(0,0,0,col1Y(page).Value+CONTENT_PAD)
    end

    local chatSpyEnabled = false
    tabBuilders["Report"] = function(page)
        addCard(page,1,"Chat Spy",{
            {"toggle","Enable Chat Spy",false,function(e) chatSpyEnabled=e; sendNotification("Chat Spy",e and "Listening" or "Disabled",2) end},
            {"info","Logs all chat messages to console (F9).",Theme.TextDim},
        })
        addCard(page,2,"Community",{
            {"button","Copy Discord Invite",function() pcall(function() if setclipboard then setclipboard("https://discord.gg/S4nPV2Rx7F"); sendNotification("Discord","Invite copied!",3) end end) end},
        })
        page.CanvasSize=UDim2.new(0,0,0,math.max(col1Y(page).Value,col2Y(page).Value)+CONTENT_PAD)
    end

    local currentToggleKey = Settings.Keybinds.ToggleGUI
    tabBuilders["Settings"] = function(page)
        addCard(page,1,"Theme",{
            {"enum","Base Theme",{"Purple","Blue","Red","Green","Cyan","Midnight","Rose"},"Purple",function(v) applyTheme(v); sendNotification("Theme","Switched to "..v,2) end},
            {"info","Theme applies instantly to all UI.",Theme.TextDim},
        })
        addCard(page,1,"GUI Keybind",{
            {"keybind","Toggle GUI",Settings.Keybinds.ToggleGUI,function(v) currentToggleKey=v; Settings.Keybinds.ToggleGUI=v end},
            {"keybind","Panic Key",Settings.Keybinds.PanicKey,function(v) Settings.Keybinds.PanicKey=v end},
            {"info","Panic key = disable all features instantly.",Theme.TextDim},
        })
        addCard(page,1,"Other Scripts",{
            {"button","Infinite Yield",function()
                task.spawn(function() local ok=pcall(function() local s=game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source",true); loadstring(s)() end); sendNotification("Script",ok and "IY Loaded" or "Failed",3) end)
            end},
            {"button","Nameless Admin",function()
                task.spawn(function() local ok=pcall(function() local s=game:HttpGet("https://raw.githubusercontent.com/ltseverydayyou/Nameless-Admin/main/Source.lua",true); loadstring(s)() end); sendNotification("Script",ok and "Admin Loaded" or "Failed",3) end)
            end},
        })

        local cfgY=col2Y(page).Value
        local cfgBody,_=makeCard(page,"Config / Profiles",COL2_X,cfgY,CARD_W,130)
        col2Y(page).Value=cfgY+CARD_HEADER_H+134+CONTENT_PAD
        addInfoRow(cfgBody,"Profile name:",0,Theme.TextDim)
        local profBox=UILib.newBox(cfgBody,{Size=UDim2.new(1,0,0,22),Position=UDim2.new(0,0,0,16),BackgroundColor3=Theme.InputBg,BorderSizePixel=1,BorderColor3=Theme.InputBorder,Text="Default",TextColor3=Theme.TextAccent,TextSize=10,Font=Enum.Font.GothamBold,ClearTextOnFocus=false}); UILib.corner(profBox,4)
        local profPad=Instance.new("UIPadding"); profPad.PaddingLeft=UDim.new(0,6); profPad.Parent=profBox
        local activeLbl=addInfoRow(cfgBody,"Active: "..currentProfileName,42,Theme.TextDim)
        local btnW3=math.floor((CARD_W-18-4)/3)
        local function miniBtn(label,x,colr,cb)
            local b=UILib.newButton(cfgBody,{Size=UDim2.new(0,btnW3,0,22),Position=UDim2.new(0,x,0,58),BackgroundColor3=colr,BorderSizePixel=0,Text=label,TextColor3=Color3.fromRGB(255,255,255),TextSize=10,Font=Enum.Font.GothamBold},cb); UILib.corner(b,4); return b
        end
        miniBtn("Save",0,Color3.fromRGB(40,130,60),function()
            local n=profBox.Text=="" and "Default" or profBox.Text; local ok=saveProfile(n)
            if ok then currentProfileName=n; activeLbl.Text="Active: "..n; sendNotification("Config","Saved: "..n,2) else sendNotification("Config","Save failed",3) end
        end)
        miniBtn("Load",btnW3+2,Theme.CardHeaderBg,function()
            local n=profBox.Text=="" and "Default" or profBox.Text; local ok=loadProfile(n)
            if ok then activeLbl.Text="Active: "..n; sendNotification("Config","Loaded: "..n,3) else sendNotification("Config","Not found",3) end
        end)
        miniBtn("Delete",btnW3*2+4,Color3.fromRGB(160,40,40),function()
            local n=profBox.Text=="" and "Default" or profBox.Text; deleteProfile(n); sendNotification("Config","Deleted: "..n,2)
        end)
        addInfoRow(cfgBody,"Saved:",84,Theme.TextDim)
        local savedLbl=addInfoRow(cfgBody,table.concat(listProfiles(),", "),94,Theme.TextAccent)
        addButtonRow(cfgBody,"Refresh",112,function() savedLbl.Text=table.concat(listProfiles(),", ") end,Theme.EnumBg)

        addCard(page,2,"Script Info",{
            {"info","Binxix Hub v"..SCRIPT_VERSION_DISPLAY,Theme.TextAccent},
            {"info","Game: "..currentGameData.name,Theme.TextDim},
            {"info","Place ID: "..tostring(currentPlaceId),Theme.TextDim},
            {"info","Executor: "..getExecutorName(),Theme.TextDim},
            {"button","Unload Script",function()
                isUnloading=true; _G.BinxixUnloaded=true
                Settings.Combat.FastReload=false; Settings.Combat.FastFireRate=false; Settings.Combat.AlwaysAuto=false; Settings.Combat.NoSpread=false; Settings.Combat.NoRecoil=false
                pcall(function() for _,e in pairs(gunOrig) do for obj,v in pairs(e) do pcall(function() obj.Value=v end) end end end)
                pcall(function() local c=player.Character; if c then local h=c:FindFirstChild("Humanoid"); if h then h.WalkSpeed=16; h.JumpPower=50 end end end)
                if speedVel then pcall(function() speedVel:Destroy() end); speedVel=nil end
                stopAutoTPLoop(); stopFly()
                for _,conn in ipairs(allConnections) do pcall(function() conn:Disconnect() end) end
                screenGui:Destroy()
            end,Color3.fromRGB(180,50,50)},
        })
        page.CanvasSize=UDim2.new(0,0,0,math.max(col1Y(page).Value,col2Y(page).Value)+CONTENT_PAD)
    end

    tabPages["General"].Visible = true
    task.defer(function()
        tabBuilders["General"](tabPages["General"])
        tabBuilt["General"] = true
    end)

    local chFrame=UILib.newFrame(screenGui,{Name="Crosshair",Size=UDim2.new(1,0,1,0),Position=UDim2.new(0,0,0,0),BackgroundTransparency=1,Visible=false})
    local chL={}; for i=1,12 do local l=Instance.new("Frame"); l.BackgroundColor3=Color3.new(1,1,1); l.BorderSizePixel=0; l.AnchorPoint=Vector2.new(0.5,0.5); l.Visible=false; l.Parent=chFrame; chL[i]=l end
    local chO={}; for i=1,12 do local l=Instance.new("Frame"); l.BackgroundColor3=Color3.new(0,0,0); l.BorderSizePixel=0; l.AnchorPoint=Vector2.new(0.5,0.5); l.Visible=false; l.ZIndex=0; l.Parent=chFrame; chO[i]=l end
    local chDot=UILib.newFrame(chFrame,{BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,0),Visible=false}); UILib.corner(chDot,100)
    local chODot=UILib.newFrame(chFrame,{BackgroundColor3=Color3.new(0,0,0),BorderSizePixel=0,AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,0),Visible=false,ZIndex=0}); UILib.corner(chODot,100)
    local chCirc=UILib.newFrame(chFrame,{BackgroundTransparency=1,BorderSizePixel=0,AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,0),Visible=false}); UILib.corner(chCirc,100)
    local chCS=UILib.stroke(chCirc,Color3.new(1,1,1),2)
    local function setL(i,cx,cy,w,h,col,op) local l=chL[i]; if not l then return end; l.Size=UDim2.new(0,w,0,h); l.Position=UDim2.new(0,cx,0,cy); l.BackgroundColor3=col; l.BackgroundTransparency=1-op; l.Visible=true end
    local function setOL(i,cx,cy,w,h,col,tk,op) local l=chO[i]; if not l then return end; l.Size=UDim2.new(0,w+tk*2,0,h+tk*2); l.Position=UDim2.new(0,cx,0,cy); l.BackgroundColor3=col; l.BackgroundTransparency=1-op; l.Visible=true end
    local function updateCrosshair()
        local s=Settings.Crosshair; chFrame.Visible=s.Enabled; if not s.Enabled then return end
        for i=1,12 do chL[i].Visible=false; chO[i].Visible=false end
        chDot.Visible=false; chODot.Visible=false; chCirc.Visible=false
        local col=s.RainbowColor and Color3.fromHSV(tick()%3/3,1,1) or s.Color
        local oc=s.OutlineColor; local op=s.Opacity
        local t,sz,gap=s.Thickness,s.Size,s.Gap; local tk=s.OutlineThickness
        local dg=gap
        if s.DynamicSpread then local c=player.Character; if c then local hrp=c:FindFirstChild("HumanoidRootPart"); if hrp then local v=Vector3.new(hrp.AssemblyLinearVelocity.X,0,hrp.AssemblyLinearVelocity.Z).Magnitude; dg=gap+math.floor(v*0.15) end end end
        local cam=Workspace.CurrentCamera
        local vs=cam and cam.ViewportSize or Vector2.new(800,600)
        local asx=chFrame.AbsoluteSize.X>0 and chFrame.AbsoluteSize.X or vs.X
        local asy=chFrame.AbsoluteSize.Y>0 and chFrame.AbsoluteSize.Y or vs.Y
        local cx=asx/2; local cy=asy/2
        if s.Style=="Cross" or s.Style=="T-Shape" then
            if s.Style~="T-Shape" then if s.OutlineEnabled then setOL(1,cx,cy-(dg+sz/2),t,sz,oc,tk,op) end; setL(1,cx,cy-(dg+sz/2),t,sz,col,op) end
            if s.OutlineEnabled then setOL(2,cx,cy+(dg+sz/2),t,sz,oc,tk,op) end; setL(2,cx,cy+(dg+sz/2),t,sz,col,op)
            if s.OutlineEnabled then setOL(3,cx-(dg+sz/2),cy,sz,t,oc,tk,op) end; setL(3,cx-(dg+sz/2),cy,sz,t,col,op)
            if s.OutlineEnabled then setOL(4,cx+(dg+sz/2),cy,sz,t,oc,tk,op) end; setL(4,cx+(dg+sz/2),cy,sz,t,col,op)
            if s.CenterDot then local ds=s.CenterDotSize; if s.OutlineEnabled then chODot.Size=UDim2.new(0,ds+tk*2,0,ds+tk*2); chODot.BackgroundColor3=oc; chODot.BackgroundTransparency=1-op; chODot.Visible=true end; chDot.Size=UDim2.new(0,ds,0,ds); chDot.BackgroundColor3=col; chDot.BackgroundTransparency=1-op; chDot.Visible=true end
        elseif s.Style=="X-Shape" then
            for i,rot in ipairs({45,-45}) do local li=chL[i]; local oi=chO[i]; if s.OutlineEnabled then oi.Size=UDim2.new(0,t+tk*2,0,sz*2+dg*2+tk*2); oi.Position=UDim2.new(0,cx,0,cy); oi.Rotation=rot; oi.BackgroundColor3=oc; oi.BackgroundTransparency=1-op; oi.Visible=true end; li.Size=UDim2.new(0,t,0,sz*2+dg*2); li.Position=UDim2.new(0,cx,0,cy); li.Rotation=rot; li.BackgroundColor3=col; li.BackgroundTransparency=1-op; li.Visible=true end
        elseif s.Style=="Dot" then
            local ds=s.Size; if s.OutlineEnabled then chODot.Size=UDim2.new(0,ds+tk*2,0,ds+tk*2); chODot.BackgroundColor3=oc; chODot.BackgroundTransparency=1-op; chODot.Visible=true end; chDot.Size=UDim2.new(0,ds,0,ds); chDot.BackgroundColor3=col; chDot.BackgroundTransparency=1-op; chDot.Visible=true
        elseif s.Style=="Circle" then
            chCirc.Size=UDim2.new(0,sz*2,0,sz*2); chCirc.Position=UDim2.new(0,cx,0,cy); chCS.Color=col; chCS.Thickness=t; chCirc.Visible=true
            if s.CenterDot then local ds=s.CenterDotSize; chDot.Size=UDim2.new(0,ds,0,ds); chDot.BackgroundColor3=col; chDot.BackgroundTransparency=1-op; chDot.Visible=true end
        elseif s.Style=="Sniper" then
            local halfW=vs.X/2; local halfH=vs.Y/2
            if s.OutlineEnabled then setOL(1,cx,cy-(dg/2+halfH/2),t,halfH-dg/2,oc,tk,op*0.7) end; setL(1,cx,cy-(dg/2+halfH/2),t,halfH-dg/2,col,op*0.7)
            if s.OutlineEnabled then setOL(2,cx,cy+(dg/2+halfH/2),t,halfH-dg/2,oc,tk,op*0.7) end; setL(2,cx,cy+(dg/2+halfH/2),t,halfH-dg/2,col,op*0.7)
            if s.OutlineEnabled then setOL(3,cx-(dg/2+halfW/2),cy,halfW-dg/2,t,oc,tk,op*0.7) end; setL(3,cx-(dg/2+halfW/2),cy,halfW-dg/2,t,col,op*0.7)
            if s.OutlineEnabled then setOL(4,cx+(dg/2+halfW/2),cy,halfW-dg/2,t,oc,tk,op*0.7) end; setL(4,cx+(dg/2+halfW/2),cy,halfW-dg/2,t,col,op*0.7)
            local ds=s.CenterDotSize; chDot.Size=UDim2.new(0,ds,0,ds); chDot.BackgroundColor3=col; chDot.BackgroundTransparency=1-op; chDot.Visible=true
        elseif s.Style=="KV" then
            for i,ang in ipairs({-35,35}) do local arm=chL[i]; local aOut=chO[i]; if s.OutlineEnabled then aOut.Size=UDim2.new(0,t+tk*2,0,sz+tk*2); aOut.Position=UDim2.new(0,cx,0,cy); aOut.Rotation=ang; aOut.BackgroundColor3=oc; aOut.BackgroundTransparency=1-op; aOut.AnchorPoint=Vector2.new(0.5,0); aOut.Visible=true end; arm.Size=UDim2.new(0,t,0,sz); arm.Position=UDim2.new(0,cx,0,cy); arm.Rotation=ang; arm.BackgroundColor3=col; arm.BackgroundTransparency=1-op; arm.AnchorPoint=Vector2.new(0.5,0); arm.Visible=true end
            if s.OutlineEnabled then setOL(3,cx,cy,sz*2,t,oc,tk,op) end; setL(3,cx,cy,sz*2,t,col,op)
        end
    end
    table.insert(allConnections,RunService.RenderStepped:Connect(function() if isUnloading or _G.BinxixUnloaded then return end; updateCrosshair() end))

    table.insert(allConnections,RunService.Heartbeat:Connect(function(dt)
        if isUnloading or _G.BinxixUnloaded then
            if speedVel then pcall(function() speedVel:Destroy() end); speedVel=nil end
            return
        end
        if not Settings.Movement.SpeedEnabled then
            if speedVel then pcall(function() speedVel:Destroy() end); speedVel=nil end
            return
        end
        local char=player.Character; if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart"); local hum=char:FindFirstChild("Humanoid")
        if not hrp or not hum then return end

        local method=Settings.Movement.SpeedMethod
        local spd=Settings.Movement.Speed

        if method=="WalkSpeed" then
            if speedVel then pcall(function() speedVel:Destroy() end); speedVel=nil end
            hum.WalkSpeed=spd
            return
        end

        local md=hum.MoveDirection
        if md.Magnitude<0.1 then
            if speedVel then pcall(function() speedVel:Destroy() end); speedVel=nil end
            return
        end

        if method=="CFrame" then
            if speedVel then pcall(function() speedVel:Destroy() end); speedVel=nil end
            hum.WalkSpeed=16
            local wm=md*spd*dt; hrp.CFrame=hrp.CFrame+Vector3.new(wm.X,0,wm.Z)
        elseif method=="Velocity" then
            hum.WalkSpeed=16
            if not speedVel or speedVel.Parent~=hrp then
                if speedVel then pcall(function() speedVel:Destroy() end) end
                speedVel=Instance.new("BodyVelocity"); speedVel.Name="BinxixSpeedVelocity"
                speedVel.MaxForce=Vector3.new(100000,0,100000); speedVel.P=10000; speedVel.Parent=hrp
            end
            speedVel.Velocity=md*spd
        end
    end))

    local bhopVel=nil; local lastJump=0; local curBhop=0
    local fpsFrame=UILib.newFrame(screenGui,{Name="FPSFrame",Size=UDim2.new(0,100,0,22),Position=UDim2.new(1,-110,0,8),BackgroundColor3=Theme.CardBg,BackgroundTransparency=0.2,BorderSizePixel=0,Visible=false}); UILib.corner(fpsFrame,5)
    local fpsLbl=UILib.newLabel(fpsFrame,{Size=UDim2.new(1,-8,1,0),Position=UDim2.new(0,4,0,0),Text="FPS: 0",TextColor3=Theme.TextAccent,TextSize=11,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left})
    local velLbl=UILib.newLabel(screenGui,{Name="VelLabel",Size=UDim2.new(0,160,0,18),Position=UDim2.new(0.5,40,0.5,26),Text="0.0 studs/s",TextColor3=Theme.CardHeaderBg,TextSize=12,Font=Enum.Font.GothamBold,TextStrokeTransparency=0.5,TextStrokeColor3=Color3.fromRGB(0,0,0),Visible=false})
    local lastFpsTick=math.floor(tick()); local fc=0; local cfps=0

    table.insert(allConnections,RunService.RenderStepped:Connect(function(dt)
        if isUnloading or _G.BinxixUnloaded then return end

        if Settings.Visuals.CustomFOV then
            local cam=Workspace.CurrentCamera; if cam and cam.FieldOfView~=Settings.Visuals.FOVAmount then cam.FieldOfView=Settings.Visuals.FOVAmount end
        end

        if Settings.Movement.Fly and isFlying then
            local char=player.Character; if char then
                local hrp=char:FindFirstChild("HumanoidRootPart"); if hrp and flyBodyVelocity and flyBodyGyro then
                    local cam=Workspace.CurrentCamera; local spd=Settings.Movement.FlySpeed; local dir=Vector3.new(0,0,0)
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir=dir+cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir=dir-cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir=dir-cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir=dir+cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir=dir+Vector3.new(0,1,0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir=dir-Vector3.new(0,1,0) end
                    if dir.Magnitude>0 then dir=dir.Unit end
                    flyBodyVelocity.Velocity=dir*spd; flyBodyGyro.CFrame=cam.CFrame
                end
            end
        elseif not Settings.Movement.Fly and isFlying then stopFly() end

        if Settings.Movement.BunnyHop then
            local char=player.Character; if char then
                local hum=char:FindFirstChild("Humanoid"); local hrp=char:FindFirstChild("HumanoidRootPart")
                if hum and hrp then
                    local holdSp=UserInputService:IsKeyDown(Enum.KeyCode.Space)
                    local grounded=hum:GetState()~=Enum.HumanoidStateType.Jumping and hum:GetState()~=Enum.HumanoidStateType.Freefall
                    local tbs=16+(Settings.Movement.BunnyHopSpeed/100)*64
                    if holdSp then
                        if grounded then hum:ChangeState(Enum.HumanoidStateType.Jumping); lastJump=tick() end
                        if not grounded then
                            local cam=Workspace.CurrentCamera; if cam then
                                local fd=Vector3.new(cam.CFrame.LookVector.X,0,cam.CFrame.LookVector.Z).Unit
                                curBhop=curBhop+(tbs-curBhop)*math.min(dt*5,1)
                                if not bhopVel or bhopVel.Parent~=hrp then if bhopVel then bhopVel:Destroy() end; bhopVel=Instance.new("BodyVelocity"); bhopVel.Name="BinxixBhopVelocity"; bhopVel.MaxForce=Vector3.new(8000,0,8000); bhopVel.P=1000; bhopVel.Parent=hrp end
                                bhopVel.Velocity=fd*curBhop
                            end
                        else if bhopVel and (tick()-lastJump)>0.08 then bhopVel:Destroy(); bhopVel=nil end; curBhop=curBhop*0.85 end
                    else if bhopVel then bhopVel:Destroy(); bhopVel=nil end; curBhop=0 end
                end
            end
        else
            if bhopVel then bhopVel:Destroy(); bhopVel=nil end; curBhop=0
        end

        fpsFrame.Visible=Settings.Visuals.ShowFPS; velLbl.Visible=Settings.Visuals.ShowVelocity
        if Settings.Visuals.ShowFPS then
            fc=fc+1
            local curSec=math.floor(tick())
            if curSec~=lastFpsTick then cfps=fc; fc=0; lastFpsTick=curSec end
            fpsLbl.Text="FPS: "..tostring(cfps)
        end
        if Settings.Visuals.ShowVelocity then
            local c=player.Character; if c then local hrp=c:FindFirstChild("HumanoidRootPart"); if hrp then local v=hrp.AssemblyLinearVelocity; velLbl.Text=string.format("%.1f studs/s",Vector3.new(v.X,0,v.Z).Magnitude) end end
        end
    end))

    local vu=game:GetService("VirtualUser")
    table.insert(allConnections,player.Idled:Connect(function() if Settings.Misc.AntiAFK then vu:CaptureController(); vu:ClickButton2(Vector2.new()) end end))

    local lastGunCheck=0; local lastSpam=0
    table.insert(allConnections,RunService.Heartbeat:Connect(function()
        if isUnloading or _G.BinxixUnloaded then return end
        local now=tick()
        if now-lastGunCheck>=2 then lastGunCheck=now
            local any=Settings.Combat.FastReload or Settings.Combat.FastFireRate or Settings.Combat.AlwaysAuto or Settings.Combat.NoSpread or Settings.Combat.NoRecoil
            if any then
                if not weaponCacheBuilt then buildWeaponCache() end
                for _,v in ipairs(weaponCache) do if v and v.Parent then local n=v.Name; if Settings.Combat.FastReload and (n=="ReloadTime" or n=="EReloadTime") and v.Value~=0.01 then v.Value=0.01 elseif Settings.Combat.FastFireRate and (n=="FireRate" or n=="BFireRate") and v.Value~=0.02 then v.Value=0.02 elseif Settings.Combat.AlwaysAuto and (n=="Auto" or n=="AutoFire" or n=="Automatic" or n=="AutoShoot" or n=="AutoGun") and v.Value~=true then v.Value=true elseif Settings.Combat.NoSpread and (n=="MaxSpread" or n=="Spread" or n=="SpreadControl") and v.Value~=0 then v.Value=0 elseif Settings.Combat.NoRecoil and (n=="RecoilControl" or n=="Recoil") and v.Value~=0 then v.Value=0 end end end
            end
        end
        if Settings.Misc.ChatSpammer and now-lastSpam>=Settings.Misc.ChatSpamDelay then lastSpam=now
            local msg=Settings.Misc.ChatSpamMessage; if msg~="" then
                pcall(function() local tcs=game:GetService("TextChatService"); local ch=tcs:FindFirstChild("TextChannels"); if ch then local g=ch:FindFirstChild("RBXGeneral"); if g then g:SendAsync(msg) end end end)
            end
        end
    end))

    pcall(function()
        local tcs=game:GetService("TextChatService"); if tcs then
            local function hook(ch) if ch:IsA("TextChannel") then ch.MessageReceived:Connect(function(mo) if not chatSpyEnabled then return end; local src=mo.TextSource; if not src then return end; local sp=Players:GetPlayerByUserId(src.UserId); if not sp then return end; print("[ChatSpy] "..sp.DisplayName..": "..mo.Text) end) end end
            for _,c in ipairs(tcs:GetDescendants()) do hook(c) end; tcs.DescendantAdded:Connect(hook)
        end
    end)
    for _,p in ipairs(Players:GetPlayers()) do if p~=player then pcall(function() p.Chatted:Connect(function(msg) if chatSpyEnabled then print("[ChatSpy] "..p.DisplayName..": "..msg) end end) end) end end
    table.insert(allConnections,Players.PlayerAdded:Connect(function(p) pcall(function() p.Chatted:Connect(function(msg) if chatSpyEnabled then print("[ChatSpy] "..p.DisplayName..": "..msg) end end) end) end))

    table.insert(allConnections,UserInputService.InputBegan:Connect(function(input,gp)
        if isUnloading or _G.BinxixUnloaded or gp then return end
        if waitingForKey then return end

        if input.KeyCode==Settings.Keybinds.ToggleGUI then mainFrame.Visible=not mainFrame.Visible end
        if input.KeyCode==Settings.Keybinds.ToggleFly then if Settings.Movement.Fly then if isFlying then stopFly() else startFly() end end end
        if input.KeyCode==Settings.Keybinds.ToggleAutoTP then
            Settings.Misc.AutoTPLoop=not Settings.Misc.AutoTPLoop
            if Settings.Misc.AutoTPLoop then startAutoTPLoop(); sendNotification("Auto TP","On",2) else stopAutoTPLoop(); sendNotification("Auto TP","Off",2) end
        end
        if input.KeyCode==Enum.KeyCode.Tab then if Settings.Aimbot.Enabled and Settings.Aimbot.MultiTarget then cycleTarget() end end
        if input.KeyCode==Settings.Keybinds.PanicKey then
            Settings.ESP.Enabled=false; Settings.Aimbot.Enabled=false; Settings.Crosshair.Enabled=false; Settings.Radar.Enabled=false
            Settings.Movement.SpeedEnabled=false; Settings.Movement.Fly=false; stopFly()
            if speedVel then pcall(function() speedVel:Destroy() end); speedVel=nil end
            local c=player.Character; if c then local h=c:FindFirstChild("Humanoid"); if h then h.WalkSpeed=16; h.JumpPower=50 end end
            mainFrame.Visible=false; sendNotification("PANIC","All features disabled",3)
        end
        if input.UserInputType==Enum.UserInputType.MouseButton2 then
            if Settings.Aimbot.Enabled then
                if Settings.Aimbot.Toggle then
                    if toggleTrackingActive then toggleTrackingActive=false; stopAimbotTracking()
                    else toggleTrackingActive=true; startAimbotTracking() end
                else startAimbotTracking() end
            end
        end
    end))

    table.insert(allConnections,UserInputService.InputEnded:Connect(function(input)
        if isUnloading or _G.BinxixUnloaded then return end
        if input.UserInputType==Enum.UserInputType.MouseButton2 then
            if Settings.Aimbot.Enabled and not Settings.Aimbot.Toggle then stopAimbotTracking() end
        end
    end))

    return screenGui
end

-- ====================================================================
-- devoneday
-- ====================================================================
local gui = createGUI()

_G.BinxixCleanup = function()
    isUnloading = true
    _G.BinxixUnloaded = true
    stopAutoTPLoop()
    stopFly()
    pcall(function()
        for _,conn in ipairs(allConnections) do pcall(function() conn:Disconnect() end) end
    end)
    pcall(function() if gui and gui.Parent then gui:Destroy() end end)
    _G.BinxixCleanup = nil
end

print("Binxix Hub V7 loaded | RightControl to toggle")

task.delay(1,function() sendNotification("Binxix Hub V7","Loaded | RCtrl = toggle | "..currentGameData.name,4) end)
task.delay(6,function() sendNotification("Discord","discord.gg/S4nPV2Rx7F",5) end)

if not checkIntegrity() then
    task.delay(2,function() sendNotification("Integrity Warning","Tampered script detected",8) end)
elseif isWeakExecutor() then
    task.delay(2,function() sendNotification("Executor Warning",getExecutorName().." - some features may not work",7) end)
end

task.delay(0.4,function()
    if currentGameData.noMovement then
        Settings.Movement.SpeedEnabled=false; Settings.Movement.JumpEnabled=false; Settings.Movement.BunnyHop=false; Settings.Movement.Fly=false; Settings.Misc.AutoTPLoop=false
        stopFly(); stopAutoTPLoop()
        pcall(function() local c=player.Character; if c then local h=c:FindFirstChild("Humanoid"); if h then h.WalkSpeed=16; h.JumpPower=50 end end end)
        sendNotification(currentGameData.name,"Movement mods disabled",4); return
    end
    pcall(function() if isfile then local dp="BinxixHubV7_Configs/Default.json"; if isfile(dp) then local ok=loadProfile("Default"); if ok then sendNotification("Config","Auto-loaded Default",2) end end end end)
end)

task.delay(8,function()
    local ok,res=pcall(function() return game:HttpGet(VERSION_URL) end)
    if ok and res then
        local remoteRaw = res:match("^%s*(%d+)%s*$")
        local remoteNum = tonumber(remoteRaw)
        local localNum  = tonumber(SCRIPT_VERSION)
        if remoteNum and localNum then
            if remoteNum > localNum then
                local remotePadded = string.format("%03d", remoteNum)
                sendNotification("Update Available","v7."..remotePadded.." is out. You have v"..SCRIPT_VERSION_DISPLAY,8)
            elseif remoteNum == localNum then
                sendNotification("Up to Date","v"..SCRIPT_VERSION_DISPLAY.." is current",3)
            end
        end
    end
end)
