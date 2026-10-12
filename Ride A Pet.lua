if not game:IsLoaded() then game.Loaded:Wait() end
if game.GameId ~= 10035204815 then game:GetService("Players").LocalPlayer:Kick("Theseus: this script is for Ride A Pet only") return end

do
    local ok, env = pcall(getgenv)
    if ok and type(env) == "table" and type(env.RideAPetUnload) == "function" then
        pcall(env.RideAPetUnload)
    end
end

if not LPH_OBFUSCATED then
    local function Passthrough(fn) return fn end
    LPH_JIT, LPH_JIT_MAX, LPH_NO_VIRTUALIZE = Passthrough, Passthrough, Passthrough
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Library

local Theseus = setmetatable({}, {
    __newindex = function(self, key, value)
        rawset(self, key, type(value) == "function" and LPH_JIT(value) or value)
    end,
})

Theseus.Config = {
    GameId = 10035204815, PlaceId = 124216119978534,
    Tag = "[RideAPet]",

    Discord = "Theseus25495",
    UiSource = "https://raw.githubusercontent.com/ntpworkstation/Theseus/refs/heads/main/ui_theseus.lua",
    LoadTimeout = 10, GameLibDeadline = 8,
    AlertTries = 8, AlertGap = 1.5, WarnGap = 5,

    PickupReach = 84,
    PickupLimit = 90,
    PickupRetryStep = 0.04,
    PickupReplyTimeout = 0.6,
    PickupAckWait = 0.12,
    PickupTotalTimeout = 1.5,
    TpSettle = 0.1, VolcanoSettle = 0.3, DismountTimeout = 10, DismountToolWindow = 2,
    DropOutside = 4,
    DropSettle = 0.2,
    DropSettleMax = 0.35,
    DropEndsSlack = 0.03,
    DropAppearTimeout = 1.0,
    DropLandMax = 8,
    StaleDropDistance = 20,
    DepositTimeout = 1.5,
    RunBudget = 4.0,
    DirectFactor = 2.5,
    DirectFactorAfterFail = 2.0,
    ReturnBackoff = { 2.0, 1.5 }, ReturnStopCount = 3, ReturnWindow = 300, ReturnDedupe = 3,
    UnmountedDirect = 90, WeightPenalty = 0.01, CherubWeightPenalty = 0.0125, WeightPenaltyMax = 0.8,
    ContainsSlack = 2, EdgeInset = 1, StandLift = 3,
    TripCost = { Plot = 0.35, Direct = 0.62, Drop = 1.25 },
    ContestWeight = 1.5, ContestWeightMax = 3, ContestHorizon = 6, UnmountedPlayerSpeed = 36,
    CycleLength = 420, CycleOffset = 418.5, WaveSurge = 12, WaveWakeEarly = 2,
    GoneBlacklistSec = 2,
    MountTimeout = 1.5, MountTries = 3, MountGap = 0.35,
    CarryDeferCap = 3,
    ReturnHopMax = 400,
    EggTick = 0.05, SlowTick = 1, EspTick = 0.25, EspTickMobile = 0.5,
    EspRange = 4000, EspRangeMobile = 1500,
    FailLimit = 5, FailWindow = 10,
    PlantSpacing = 6, PlantCapDefault = 10, HatchGap = 0.3,
    CollectMinPending = 60, SellRange = 9, SellBatch = 50, ConfirmWindow = 2,
    ShopBuyGap = 0.15, AfkRejoinSec = 1100,
    HunterHopsPerCycle = 5, HunterMinLeft = 90,
    VolcanoCenter = Vector3.new(-5103, 41406, -3489), VolcanoResultTimeout = 20, VolcanoMinBreakLeft = 3,
    PumpTick = 0.5, PlotRetry = 1, MobileViewport = 900,
    UnloadCarryTimeout = 2,
    JobTick = {
        Volcano = 0.25, Halloween = 0.1, Junk = 0.25, Hatch = 1, Plant = 2, Pets = 2,
        Feed = 1, Sell = 10, Fusion = 2, Economy = 3, Shop = 5, Rewards = 30, Boosts = 5, Server = 5,
        Webhook = 1, Settle = 1, Kaitun = 2,
    },
    JobBackoff = 40,

    HalloweenSettle = 0.55,
    CandyPickupSettle = 0.15,
    CandyCooldown = 2.1,
    CandyPrepAhead = 0.8,
    CandyPickupReach = 28,
    CandyPickupLimit = 32,
    CandyDirectFactor = 2,
    CandyDirectMax = 400,
    CandyDepositReach = 18,
    CandyRangeDefault = 1500,
    CandyCarryGoal = 6,
    CandySpoilAt = 12,
    CandyCollectTimeout = 2.5,
    CandyDepositTimeout = 2.5,
    CandySkipSec = 16,
    CandyStateCache = 3,
    CandyReturnFactor = 1,
    CandyDepositReserve = 2,
    TravelStepMax = 0.1,
    TravelStopDistance = 2,
    CandyPadLift = 3,
    CandyPadPos = Vector3.new(-45839.9, 40368.5, -20118.0),
    PortalPos = Vector3.new(-46800, 40390, -20000),
    DoorCooldown = 180,
    DoorStateCache = 3,
    DoorStand = 6,
    PumpkinCooldown = 40,
    PumpkinStateCache = 3,
    HalloweenPrio = 70,
    HalloweenPhaseBudget = 12,
    HalloweenManualTimeout = 180,
    HalloweenEggGap = 3,
    HalloweenPurchaseTimeout = 4,
    HalloweenShopRange = 20,
    HalloweenShopRetry = 8,
    HalloweenZoneTries = 5,
    HalloweenZoneGap = 2,
    RitualRetry = 20,
    RitualPrompts = 4,
    RitualPromptGap = 0.4,
    RitualStand = 8,
    EventStreamDist = 512,
    EventStreamTimeout = 5,
    GroundRayUp = 30,
    GroundRayDown = 60,

    VolcanoStreamTimeout = 5,
    VolcanoTouchEvery = 0.25,
    VolcanoStepWait = 5,
    VolcanoStandLift = 3,
    VolcanoRetry = 30,
    VolcanoDipSettle = 0.7,
    VolcanoRefire = 0.3,
    VolcanoTailEggs = 1,
    VolcanoClaimSec = 2,

    PlantReplyTimeout = 1.5,
    PlantTries = 3,
    EquipSettle = 0.1,
    HatchPending = 5,
    PlotEggsRefresh = 60, PlotFullRecheck = 10,
    PlantStandLift = 3,
    PlantLongGrow = 3600,
    PlantLongShare = 0.5,

    JunkEquipSettle = 0.1,
    JunkSpacing = 0.2,
    JunkSpacingMin = 0.1,
    JunkSpacingMax = 1,
    JunkSpacingUp = 0.05,
    JunkSpacingDown = 0.02,
    JunkSpacingEase = 20,
    JunkPlantTimeout = 0.9,
    JunkPlantFails = 8,
    JunkHatchRetry = 0.8,
    JunkHatchSlack = 0.02,
    JunkHatchSlackMax = 0.3,
    JunkHatchGapMax = 0.3,
    JunkHatchGapStep = 0.02,
    JunkSellEvery = 60,
    JunkQueueTtl = 30,
    JunkIdleCheck = 5,
    JunkResyncIdle = 8,
    JunkFullPause = 0.6,
    JunkAutoShare = 0.2,
    JunkShareSample = 200,
    JunkSessionMax = 45,
    JunkYieldGap = 3,
    JunkBackoff = 10,
    JunkRateWindow = 60,
    JunkReportGap = 0.5,
    JunkAnchorNear = 4,
    JunkPlotShare = 0.5,
    JunkYieldTo = {
        "AutoEquipBest", "AutoCollectCash", "AutoFeed", "AutoFusion", "AutoPlaceEggs",
    },

    PetReplyTimeout = 1.5,
    PetSwapGain = 1.01,
    PetSpread = 0.35,
    PetStandLift = 3,
    PetBaseKg = 10,
    PetMaxAge = 100,
    CollectGap = 0.15,
    FeedGap = 0.36, FeedBurst = 8, FeedMissLimit = 3, FeedReplyTimeout = 1,
    TopCacheSec = 1,
    AutoCollectPass = { "AutoCollect", "1940707069" },
    PetAgeRefresh = 30,
    PetWatchedAttrs = {
        PetKey = true, PetName = true, Weight = true, BaseWeight = true, Mutation = true,
        SpawnMutation = true, Age = true, BirthTime = true, Favorited = true,
    },

    SellReplyTimeout = 8,
    SellRetry = 0.45,
    SellTries = 5,
    SellNear = 3,
    SellPriceMult = 600,
    SellStand = 5,
    IncomeSettle = 1.5,
    SellSettle = 0.6,
    FuseSlots = 4,
    FuseStand = 3,
    FuseLift = 3,
    FuseSettle = 0.15,
    FuseReplyTimeout = 2,
    FuseGap = 0.3,
    FusePlaceSettle = 1,
    FuseResultTimeout = 5,
    WeekSec = 604800,
    SellKeepTopRarities = 3,

    UpgradePayback = 300,
    UpgradeBatch = 25,
    UpgradeGap = 0.1,
    UpgradeVerify = 1.5,
    UpgradeBackoff = 30,
    UpgradeMaxBuy = 1000,
    RebirthSaveWindow = 1800,
    RebirthVerify = 3,
    RebirthBackoff = 60,
    ShopReplyTimeout = 3,
    ShopRecheck = 300,
    ClaimVerify = 2,
    PromptRetry = 3600,
    GroupRewardCooldown = 86400,
    BoostAttributes = {
        "HatchLuckEventMultiplier", "HatchLuckEventUntil", "HatchMutationEventMultiplier",
        "HatchMutationEventUntil", "HatchSpeedBoostAmount", "HatchSpeedBoostUntil", "GlobalCashBoostUntil",
    },

    KaitunToggles = {
        "AutoEggs", "EggHunter", "AutoPlaceEggs", "AutoHatch", "AutoEquipBest",
        "AutoCollectCash", "AutoUpgrade", "AutoClaim", "SmartSpend",
    },
    KaitunHuntRarity = "Mythic",
    KaitunSteerEvery = 60,

    UpdateLog = {
        { "2026-10-12", "Improved Auto Candy targeting and smoother returns\nAdded Instant E and return speed controls up to 600% (default 350%)\nEvent farming now retries at a lower speed after movement rejection\nImproved Halloween egg buying and purchased egg hatching\nFixed egg delivery, hatch order, fusion claims and Kaitun target handling" },
        { "2026-10-11", "Updated Halloween candy, doors, pumpkins, event ESP and teleports\nImproved fusion eligibility and ground placement" },
    },
}

Theseus.State = {
    Alive = true, Connections = {}, Halted = {}, Errors = {},
    Tune = { DropSettle = 0.2, ContestWeight = 1.5, DirectFactor = 2.5 },
    Status = {},
    PendingSet = {},
    PendingToggleOff = {},
    PendingNotify = {},
    LastFail = nil,
    Stats = { delivered = 0, lost = 0, returned = 0, plot = 0, direct = 0, drop = 0, staleDrops = 0, window = {} },
    PlotEggs = {}, PlantCap = 10, Weather = {},
    WarnedAt = {},
}

Theseus.Options = {}

local Config, State = Theseus.Config, Theseus.State

Config.JobTick.Eggs, Config.JobTick.Hunter = Config.EggTick, Config.EggTick

State.Tune.DropSettle = Config.DropSettle
State.Tune.ContestWeight = Config.ContestWeight
State.Tune.DirectFactor = Config.DirectFactor
State.PlantCap = Config.PlantCapDefault

Theseus.Util = {}

---@return boolean, any  ok, fn result or the error
function Theseus.Util.Try(label, fn, ...)
    local ok, err = pcall(fn, ...)
    if ok then return true, err end

    local now = os.clock()
    if now - (State.WarnedAt[label] or -math.huge) >= Config.WarnGap then
        State.WarnedAt[label] = now
        warn(Config.Tag .. " " .. label .. ":", err)
    end
    return false, err
end

---@return string|nil, string|nil  body, or nil and why every transport failed
function Theseus.Util.HttpGet(url)
    local ok, body = pcall(game.HttpGet, game, url)
    if ok and type(body) == "string" then return body end

    local requester = (syn and syn.request) or (http and http.request) or http_request or request
    if not requester then return nil, "no http function" end

    local sent, response = pcall(requester, { Url = url, Method = "GET" })
    if not sent or type(response) ~= "table" then return nil, tostring(response) end
    if response.StatusCode ~= 200 or type(response.Body) ~= "string" then
        return nil, "HTTP " .. tostring(response.StatusCode)
    end
    return response.Body
end

---@param detail any  console only
function Theseus.Util.Alert(text, detail)
    warn(Config.Tag, text, detail or "")
    task.spawn(function()
        for _ = 1, Config.AlertTries do
            local shown = pcall(StarterGui.SetCore, StarterGui, "SendNotification", { Title = "Theseus", Text = text, Duration = 10 })
            if shown then return end
            task.wait(Config.AlertGap)
        end
    end)
end

---@return table|nil  UI library, nil after an on-screen alert
function Theseus.Util.LoadLibrary(url)
    local source, why = Theseus.Util.HttpGet(url)
    if not source or not source:sub(-64):find("return%s+Library%s*$") then
        Theseus.Util.Alert("Could not download the menu. Check your connection and run it again.", why or "truncated download")
        return nil
    end

    local chunk, compileErr = loadstring(source)
    if type(chunk) ~= "function" then
        Theseus.Util.Alert("The menu failed to load on this executor.", compileErr)
        return nil
    end

    local ok, lib = pcall(chunk)
    if not ok or type(lib) ~= "table" then
        Theseus.Util.Alert("The menu failed to load on this executor.", lib)
        return nil
    end
    return lib
end

function Theseus.Util.Copy(text)
    local copier = setclipboard or toclipboard
    if not copier then return false end
    return (pcall(copier, text))
end

---@return boolean  queued for the next server
function Theseus.Util.Queue(src)
    if not (Library and Library.Compat and Library.Compat.Caps.Queue) then return false end
    local queue = queue_on_teleport or queueonteleport
    if not queue then return false end
    return (pcall(queue, src))
end

function Theseus.Util.ServerNow()
    return Workspace:GetServerTimeNow()
end

---@return number  XZ distance
function Theseus.Util.Flat(a, b)
    local dx, dz = a.X - b.X, a.Z - b.Z
    return math.sqrt(dx * dx + dz * dz)
end

function Theseus.Util.Format(n)
    n = tonumber(n) or 0
    if n ~= n or n == math.huge then return "-" end

    local suffixes = { "", "K", "M", "B", "T", "Qa", "Qi", "Sx" }
    local step = 1
    repeat
        if math.abs(n) < 1000 then break end
        n /= 1000
        step += 1
    until step == #suffixes
    if step == 1 then return tostring(math.floor(n)) end
    return string.format("%.2f%s", n, suffixes[step])
end

---@return any  option value; the UI mirror first, then the live option
function Theseus.Util.Opt(idx)
    local mirrored = Theseus.Options[idx]
    if mirrored ~= nil then return mirrored end
    local option = Library and Library.Options and Library.Options[idx]
    return option and option.Value
end

---@param seconds number|nil
function Theseus.Util.Notify(title, text, seconds)
    table.insert(State.PendingNotify, { title, text, seconds or 5 })
end

do
    local camera = Workspace.CurrentCamera
    local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
    local touch = UserInputService.TouchEnabled
    local noKeys = not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled

    Theseus.Platform = {
        Touch = touch,
        Mobile = touch and (noKeys or viewport.X < Config.MobileViewport),
        Console = GuiService:IsTenFootInterface(),
        Viewport = viewport,
    }
end

---@return boolean  false when the executor has no working fps cap
function Theseus.Util.SetFpsCap(fps)
    local ok = pcall(function() setfpscap(fps) end)
    return ok
end

function Theseus:Connect(signal, handler)
    local conn = signal:Connect(handler)
    table.insert(self.State.Connections, conn)
    return conn
end

Theseus.StopOrder = {
    "Kaitun", "Guard", "Eggs", "Hunter", "Volcano", "Halloween", "Prompts", "Junk", "Hatch", "Pets", "Sell", "Fusion",
    "Economy", "Shop", "Rewards", "Boosts", "Troll", "Server", "Webhook", "Visual",
}

function Theseus:Unload()
    if not State.Alive or State.Unloading then return end
    State.Unloading = true
    local try = Theseus.Util.Try

    try("unload carry", function() Theseus.Eggs.FinishCarry(Config.UnloadCarryTimeout) end)
    State.Alive = false
    try("unload tasks", function() Theseus.Tasks.ReleaseAll("unload") end)
    for _, name in ipairs(Theseus.StopOrder) do
        local module = rawget(Theseus, name)
        if module and module.Stop then try("unload " .. name, module.Stop) end
    end
    try("unload character", function() Theseus.Player:Release() end)
    try("unload inventory", function() Theseus.Eggs.QuietInventory(false, true) end)
    State.TeardownPending = true
    if not State.TeardownConn then Theseus.Teardown() end
end

function Theseus.Teardown()
    State.TeardownPending = false
    if State.TeardownConn then
        State.TeardownConn:Disconnect()
        State.TeardownConn = nil
    end
    local try = Theseus.Util.Try

    try("unload move", function() Theseus.Move.Restore() end)
    try("unload esp", function() Theseus.Esp.Clear() end)
    try("unload hooks", function() Library.Compat.RestoreAll() end)

    try("unload player", function() Theseus.Player:Unbind() end)
    for _, conn in ipairs(State.Connections) do
        if type(conn) == "function" then conn() else conn:Disconnect() end
    end
    table.clear(State.Connections)

    try("unload ui", function() Library:Unload() end)
end

---@param signal RBXScriptSignal  fired on a thread that never calls game code
function Theseus.BindTeardown(signal)
    State.TeardownConn = signal:Connect(function()
        if State.TeardownPending then Theseus.Teardown() end
    end)
end

do
    local ok, env = pcall(getgenv)
    if ok and type(env) == "table" then
        env.RideAPetUnload = function() Theseus:Unload() end
    end
end

Theseus.GameLib = {
    Data = {}, Svc = {}, Missing = {},
    Cache = {}, NetSearched = false,
    EggInfo = {}, PetInfo = {}, RarityOrder = {}, RarityRank = {}, FuseQuality = {},
    Foods = {}, FoodOrder = {}, ShopItems = {}, Rebirths = { Cap = 0, Costs = {} }, RebirthReq = {},
    IndexStages = {}, Mutations = {},
}

local GameLib = Theseus.GameLib

GameLib.ServiceModules = { "General", "EggCycle", "DayNight", "EggDeliveryRules", "SellValue", "PetAging", "HalloweenEvent" }

GameLib.Denied = {
    Restock = true, SetOpenShop = true, RegisterSkipTarget = true, RegisterSkipAllTarget = true,
    UpdatePlayerToGift = true, CanGiftGamepass = true, CmdrFunction = true, PetMove = true,
    EggTimerPause = true, EggArrivalClaim = true,
    ["Reusable.Ban"] = true, ["Reusable.GetPlayerData"] = true, ["Reusable.InitiatePlot"] = true,
    ["Reusable.ClaimGroupReward"] = true, ["Reusable.ClaimEventReward"] = true, ["Reusable.Teleporting"] = true,
}
GameLib.DeniedPrefix = { "SkipGrowth" }
GameLib.ListenOnly = { Restock = true }

GameLib.Needs = {
    AutoEggs = { "EggPickup", "BasketDrop", "Mounting", "GameMessage", "ActiveEggs" },
    EggHunter = { "EggPickup", "BasketDrop", "ActiveEggs" },
    VolcanoDip = { "EggPickup", "BasketDrop", "VolcanoDip", "VolcanoDipResult" },
    VolcanoObby = { "EggPickup", "BasketDrop", "ActiveEggs" },
    AutoPlaceEggs = { "EggPlaced" },
    AutoHatch = { "Hatch" },
    ClearJunk = { "EggPlaced", "Hatch", "SellItems", "ConfirmRequest" },
    AutoEquipBest = { "PlacePet", "PickupPet" },
    AutoCollectCash = { "PetCollect" },
    AutoFeed = { "FeedPet" },
    AutoSell = { "SellItems", "ConfirmRequest" },
    AutoFusion = { "FusionPetPlace", "FusionAction" },
    AutoUpgrade = { "Plot.Upgrades" },
    AutoRebirth = { "Rebirth" },
    AutoShop = { "ShopStock", "BuyWithCash" },
    AutoClaim = { "ClaimIndexReward", "OfflineEarnings" },
    AutoCandy = { "CollectCandy", "GetCandyState" },
    AutoTrickOrTreat = { "KnockDoor", "GetDoorState" },
    AutoPumpkin = { "SearchPumpkin", "GetPumpkinState" },
    AutoHalloweenEgg = { "BuyHalloweenEgg" },
    Kaitun = { "EggPickup", "BasketDrop", "ActiveEggs" },
}

---@return boolean, any  ok, module or error; retried from an identity-2 thread
function GameLib.RequireAsGame(module)
    local done, ok, loaded = false, false, nil
    task.spawn(function()
        local switched = pcall(setthreadidentity, 2)
        if switched then ok, loaded = pcall(require, module) end
        done = true
    end)

    local deadline = os.clock() + Theseus.Config.LoadTimeout
    repeat
        if done then break end
        task.wait()
    until os.clock() > deadline
    return ok, loaded
end

---@return table|nil
function GameLib.Require(module)
    if typeof(module) ~= "Instance" or not module:IsA("ModuleScript") then return nil end

    local ok, loaded
    if Library and Library.Compat then
        ok, loaded = Library.Compat.Require(module)
    else
        ok, loaded = pcall(require, module)
        if not ok and tostring(loaded):find("non-RobloxScript", 1, true) then
            ok, loaded = GameLib.RequireAsGame(module)
        end
    end

    if ok and type(loaded) == "table" then return loaded end
    warn(Theseus.Config.Tag, "require " .. module.Name .. ":", loaded)
    return nil
end

---@return boolean, ...  ok, then the game function's results or the error
function GameLib.Call(fn, ...)
    if type(fn) ~= "function" then return false, "not a function" end
    if Library and Library.Compat then
        return pcall(Library.Compat.Call, fn, ...)
    end
    return pcall(fn, ...)
end

---@return boolean
function GameLib.IsDenied(name)
    if GameLib.Denied[name] then return true end
    for _, prefix in ipairs(GameLib.DeniedPrefix) do
        if name:sub(1, #prefix) == prefix then return true end
    end
    return false
end

---@return Instance|nil  the packages Net folder, found once whatever the _Index version
function GameLib.NetFolder()
    if GameLib.NetSearched then return GameLib.NetFolderRef end
    GameLib.NetSearched = true

    local packages = ReplicatedStorage:FindFirstChild("packages")
    if not packages then return nil end
    local direct = packages:FindFirstChild("Net")
    if direct then
        GameLib.NetFolderRef = direct
        return direct
    end

    for _, node in ipairs(packages:GetDescendants()) do
        if node.Name ~= "Net" then continue end
        for _, child in ipairs(node:GetChildren()) do
            if child.Name:sub(1, 3) == "RE/" then
                GameLib.NetFolderRef = node
                return node
            end
        end
    end
    return nil
end

---@param name string  "EggPickup", "Plot.Upgrades" or a packages Net name without "RE/"
---@return Instance|nil
function GameLib.Remote(name)
    if GameLib.IsDenied(name) then return nil end
    local cached = GameLib.Cache[name]
    if cached and cached.Parent then return cached end

    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local gameFolder = remotes and remotes:FindFirstChild("Game")
    local reusable = remotes and remotes:FindFirstChild("Reusable")
    local found

    local folder, leaf = name:match("^(%w+)%.(.+)$")
    if folder then
        local parent = gameFolder and gameFolder:FindFirstChild(folder)
        found = parent and parent:FindFirstChild(leaf)
    else
        found = gameFolder and gameFolder:FindFirstChild(name)
        if not found and reusable and not GameLib.IsDenied("Reusable." .. name) then
            found = reusable:FindFirstChild(name)
        end
        if not found then
            local net = GameLib.NetFolder()
            found = net and net:FindFirstChild("RE/" .. name)
        end
    end

    GameLib.Cache[name] = found
    return found
end

---@return Instance|nil  a denied remote that is only ever listened to, never fired
function GameLib.Listen(name)
    if not GameLib.ListenOnly[name] then return GameLib.Remote(name) end
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local gameFolder = remotes and remotes:FindFirstChild("Game")
    return gameFolder and gameFolder:FindFirstChild(name)
end

Theseus.Net = setmetatable({}, {
    __index = function(self, name)
        local remote = GameLib.Remote(name)
        if remote then rawset(self, name, remote) end
        return remote
    end,
})

---@return Instance|nil
function GameLib.ActiveEggs()
    local serverData = ReplicatedStorage:FindFirstChild("ServerData")
    return serverData and serverData:FindFirstChild("ActiveEggs")
end

---@return Model|nil
function GameLib.Plot()
    local general = GameLib.Svc.General
    if general and general.GetPlot then
        local ok, plot = GameLib.Call(general.GetPlot, general, LocalPlayer)
        if ok and typeof(plot) == "Instance" then return plot end
    end

    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return nil end
    for _, plot in ipairs(plots:GetChildren()) do
        local data = plot:FindFirstChild("Data")
        local owner = data and data:FindFirstChild("Owner")
        if owner and owner.Value == LocalPlayer then return plot end
    end
    return nil
end

---@return boolean  same rule as the game's delivery check, Y ignored
function GameLib.Contains(bp, pos)
    local rel = bp.CFrame:PointToObjectSpace(pos)
    local slack = Theseus.Config.ContainsSlack
    return math.abs(rel.X) <= bp.Size.X / 2 + slack and math.abs(rel.Z) <= bp.Size.Z / 2 + slack
end

function GameLib.CycleIndex()
    local cycle = GameLib.Svc.EggCycle
    if cycle then
        local ok, index = GameLib.Call(cycle.Index)
        if ok and type(index) == "number" then return index end
    end
    return math.floor((Theseus.Util.ServerNow() - Theseus.Config.CycleOffset) / Theseus.Config.CycleLength)
end

---@return number  seconds until the next egg wave
function GameLib.CycleLeft()
    local cycle = GameLib.Svc.EggCycle
    if cycle then
        local ok, left = GameLib.Call(cycle.SecondsRemaining)
        if ok and type(left) == "number" then return left end
    end
    local length = Theseus.Config.CycleLength
    return length - (Theseus.Util.ServerNow() - Theseus.Config.CycleOffset) % length
end

---@param mult number  hatch luck multiplier, event included
---@return table|nil   { {pet, chance} }
function GameLib.Odds(egg, mult)
    local hatchLuck, eggs = GameLib.Data.HatchLuck, GameLib.Data.Eggs
    local info = GameLib.EggInfo[egg]
    if not (hatchLuck and hatchLuck.GetOdds and eggs and eggs[egg] and info) then return nil end

    local ok, odds = GameLib.Call(hatchLuck.GetOdds, info.luck * (mult or 1), eggs[egg])
    if not ok or type(odds) ~= "table" then return nil end

    local out = {}
    for _, row in ipairs(odds) do
        if type(row) == "table" and row.PetName then
            out[#out + 1] = { row.PetName, tonumber(row.Chance) or 0 }
        end
    end
    return out
end

---@return number|nil  growth seconds an egg of this weight needs, nil when the game module is missing
function GameLib.GrowthSeconds(base, weight)
    local general = GameLib.Data.General
    if not (general and general.GrowthTimeFor) then return nil end

    local ok, total = GameLib.Call(general.GrowthTimeFor, base, weight)
    return ok and tonumber(total) or nil
end

---@return number|nil  growth seconds still needed, nil when the game modules are missing
function GameLib.GrowthLeft(placeTime, base, weight)
    local dayNight = GameLib.Svc.DayNight
    local total = GameLib.GrowthSeconds(base, weight)
    if not (total and dayNight and dayNight.GrowthElapsed) then return nil end

    local ok, elapsed = GameLib.Call(dayNight.GrowthElapsed, placeTime)
    if not ok then return nil end
    return total - (tonumber(elapsed) or 0)
end

---@return number|nil  real seconds until a placed egg is grown, night counts faster; nil when unknown
function GameLib.GrowthRealLeft(placeTime, base, weight)
    local dayNight = GameLib.Svc.DayNight
    local total = GameLib.GrowthSeconds(base, weight)
    if not (total and dayNight and dayNight.GrowthRealRemaining) then return nil end

    local ok, left = GameLib.Call(dayNight.GrowthRealRemaining, placeTime, total)
    return ok and tonumber(left) or nil
end

---@param into   table   GameLib.Data or GameLib.Svc
---@param stopAt number  shared deadline for every require
function GameLib.LoadFolder(folder, names, into, label, stopAt)
    for _, name in ipairs(names) do
        local module = folder and folder:FindFirstChild(name)
        if module and os.clock() < stopAt then into[name] = GameLib.Require(module) end
        if not into[name] then GameLib.Missing[label .. "." .. name] = module and "load timeout" or "module not found" end
    end
end

---@param folder  Instance  GameData or a folder nested inside it
---@param prefix  string    "" or a path like "Halloween."
function GameLib.LoadDataTree(folder, prefix, stopAt)
    for _, child in ipairs(folder:GetChildren()) do
        if os.clock() >= stopAt then return end
        local key = prefix .. child.Name
        if child:IsA("ModuleScript") then
            if GameLib.Data[key] == nil then
                GameLib.Data[key] = GameLib.Require(child)
                if not GameLib.Data[key] then GameLib.Missing["GameData." .. key] = "require failed" end
            end
        elseif child:IsA("Folder") then
            GameLib.LoadDataTree(child, key .. ".", stopAt)
        end
    end
end

function GameLib.LoadModules()
    local deadline = Theseus.Config.GameLibDeadline
    local dataFolder = ReplicatedStorage:WaitForChild("GameData", deadline)
    local svcFolder = ReplicatedStorage:FindFirstChild("GameServices") or ReplicatedStorage:WaitForChild("GameServices", 1)
    local stopAt = os.clock() + deadline

    if dataFolder then
        GameLib.LoadDataTree(dataFolder, "", stopAt)
        local halloween = dataFolder:FindFirstChild("Halloween")
        local debuffs = halloween and halloween:FindFirstChild("Debuffs")
        if debuffs and GameLib.Data["Halloween.Debuffs"] == nil then
            GameLib.Data["Halloween.Debuffs"] = GameLib.Require(debuffs)
        end
    end
    GameLib.LoadFolder(svcFolder, GameLib.ServiceModules, GameLib.Svc, "GameServices", stopAt)
end

local function BuildRarities()
    local order, rank = GameLib.RarityOrder, GameLib.RarityRank
    table.clear(order)
    table.clear(rank)

    local general = GameLib.Data.General or {}
    local levels = general.RarityLevelRequirementMultiplier or {}
    local weight = {}
    for rarity, level in pairs(levels) do
        weight[rarity] = tonumber(level) or 0
    end

    local floor = {}
    for _, pet in pairs(GameLib.PetInfo) do
        floor[pet.rarity] = math.min(floor[pet.rarity] or math.huge, pet.income)
    end
    for _, egg in pairs(GameLib.EggInfo) do
        floor[egg.rarity] = floor[egg.rarity] or math.huge
    end
    for rarity, income in pairs(floor) do
        if not weight[rarity] then weight[rarity] = 1e9 + math.min(income, 1e12) end
    end

    for rarity in pairs(weight) do
        order[#order + 1] = rarity
    end
    table.sort(order, function(a, b) return weight[a] < weight[b] end)
    for index, rarity in ipairs(order) do
        rank[rarity] = index
    end
end

local function BuildEggsAndPets()
    table.clear(GameLib.EggInfo)
    table.clear(GameLib.PetInfo)
    local breakTimer = (GameLib.Data.General or {}).EggBreakTimer or {}

    for name, egg in pairs(GameLib.Data.Eggs or {}) do
        if type(egg) ~= "table" then continue end
        local rarity = egg.Rarity or "Common"
        GameLib.EggInfo[name] = {
            rarity = rarity,
            luck = tonumber(egg.Luck) or 0,
            growth = tonumber(egg.GrowthTime) or 0,
            breakSec = tonumber(breakTimer[rarity]) or 0,
            ethereal = rarity == "Ethereal",
            volcanic = egg.RequiresVolcano == true,
        }
    end

    for name, pet in pairs(GameLib.Data.Pets or {}) do
        if type(pet) ~= "table" or not pet.Rarity then continue end
        GameLib.PetInfo[name] = {
            rarity = pet.Rarity,
            speed = tonumber(pet.Speed) or 0,
            income = tonumber(pet.Income) or 0,
            fusionOnly = pet.FusionOnly == true,
            moveSpeed = tonumber(pet.MovementSpeed) or 0,
        }
    end
end

local function BuildEconomy()
    local data = GameLib.Data

    table.clear(GameLib.Foods)
    table.clear(GameLib.FoodOrder)
    for name, food in pairs(data.Foods or {}) do
        if type(food) ~= "table" then continue end
        GameLib.Foods[name] = { cost = tonumber(food.Cost) or 0, xp = tonumber(food.XP) or 0, rarity = food.Rarity, noFeedAll = food.NoFeedAll == true }
        table.insert(GameLib.FoodOrder, name)
    end
    table.sort(GameLib.FoodOrder, function(a, b) return GameLib.Foods[a].cost < GameLib.Foods[b].cost end)

    table.clear(GameLib.ShopItems)
    local categories = data.Shop and data.Shop.Categories or {}
    for category, items in pairs(categories) do
        for item, entry in pairs(items) do
            if type(entry) ~= "table" or entry.Source == "Lanterns" then continue end
            local price = tonumber(entry.Price) or (GameLib.Foods[item] and GameLib.Foods[item].cost) or 0
            GameLib.ShopItems[#GameLib.ShopItems + 1] = { cat = category, item = item, price = price, rarity = entry.Rarity }
        end
    end
    table.sort(GameLib.ShopItems, function(a, b) return a.price < b.price end)

    local rebirths = data.Rebirths
    GameLib.Rebirths.Cap = rebirths and tonumber(rebirths.Cap) or 0
    table.clear(GameLib.Rebirths.Costs)
    for n = 1, GameLib.Rebirths.Cap do
        local ok, cost = GameLib.Call(rebirths.GetCost, n - 1)
        GameLib.Rebirths.Costs[n] = ok and tonumber(cost) or math.huge
    end

    table.clear(GameLib.RebirthReq)
    for index, pet in ipairs((data.General or {}).RebirthRequirements or {}) do
        GameLib.RebirthReq[index] = pet
    end

    table.clear(GameLib.IndexStages)
    for _, stage in ipairs(data.IndexRewards and data.IndexRewards.Stages or {}) do
        table.insert(GameLib.IndexStages, { goal = tonumber(stage.Goal) or 0, reward = tonumber(stage.Reward) or 0 })
    end

    table.clear(GameLib.Mutations)
    for name, mutation in pairs(data.Mutations or {}) do
        if type(mutation) == "table" and mutation.StatMultiplier then
            GameLib.Mutations[name] = 1 + (tonumber(mutation.StatMultiplier) or 0) / 100
        end
    end
end

local function BuildFuseQuality()
    table.clear(GameLib.FuseQuality)
    local raw = GameLib.Data.WeightedFuseData
    if type(raw) ~= "table" then return end

    local holders = { raw.Pets, raw.Inputs, raw }
    for _, holder in ipairs(holders) do
        if type(holder) == "table" then
            for key, value in pairs(holder) do
                local name = key
                local quality = value
                if type(value) == "table" then
                    name = value.Name or value.PetName or value.Pet
                    quality = value.Quality or value.Value or value.Score
                end
                if type(name) == "string" and tonumber(quality) and GameLib.PetInfo[name] then
                    GameLib.FuseQuality[name] = tonumber(quality)
                end
            end
        end
        if next(GameLib.FuseQuality) then return end
    end
end

function GameLib.Build()
    BuildEggsAndPets()
    BuildRarities()
    BuildEconomy()
    BuildFuseQuality()
end

---@return number  pet sell price multiplier straight from the game's SellValue module
function GameLib.SellMultiplier()
    local sellValue = GameLib.Svc.SellValue
    local mult = type(sellValue) == "table" and tonumber(sellValue.SellIncomeMultiplier)
    return mult or Theseus.Config.SellPriceMult
end

---@return number  the game's income multiplier for a rebirth count
function GameLib.RebirthMultiplier(done)
    local rebirths = GameLib.Data.Rebirths
    if type(rebirths) == "table" and type(rebirths.GetMultiplier) == "function" then
        local ok, mult = GameLib.Call(rebirths.GetMultiplier, done)
        if ok and tonumber(mult) then return tonumber(mult) end
    end
    return 1 + done
end

---@return number  hatch luck multiplier: bought upgrades times the live event multiplier
function GameLib.LuckMult()
    local saved = LocalPlayer:FindFirstChild("SavedData")
    local upgrades = saved and saved:FindFirstChild("HatchUpgrades")
    local bought = upgrades and tonumber(upgrades.Value) or 0
    local event = tonumber(ReplicatedStorage:GetAttribute("HatchLuckEventMultiplier")) or 1
    return (1 + bought + 4 * math.floor(bought / 5)) * event
end

---@return string|nil  why the option cannot run
function GameLib.Blocked(idx)
    for _, name in ipairs(GameLib.Needs[idx] or {}) do
        local reason = GameLib.Missing[name]
        if reason then return reason end
    end
    return nil
end

function GameLib.Check()
    local started = os.clock()
    local deadline = Theseus.Config.GameLibDeadline
    local seen = {}

    for _, names in pairs(GameLib.Needs) do
        for _, name in ipairs(names) do
            if seen[name] then continue end
            seen[name] = true
            if os.clock() - started > deadline then
                GameLib.Missing[name] = "check timed out"
                continue
            end

            local found
            if name == "ActiveEggs" then
                found = GameLib.ActiveEggs()
            else
                found = GameLib.Remote(name)
            end
            if not found then GameLib.Missing[name] = "not found after a game update" end
        end
    end

    if not GameLib.Data.Eggs or not GameLib.Data.Pets then
        GameLib.Missing.ActiveEggs = GameLib.Missing.ActiveEggs or "egg data not readable"
    end
end

Theseus.Player = {
    Client = LocalPlayer,
    Char = nil, Humanoid = nil, Root = nil,
    Epoch = 0,
    BindVersion = 0,
    CharConns = {},
    PlotModel = nil, Baseplate = nil, PlotConn = nil, PlotRetryAt = 0,
}

function Theseus.Player:Lose(char)
    if self.Char ~= char then return end
    if self.LostChar == char then return end
    self.LostChar = char
    self.BindVersion += 1
    self.Humanoid, self.Root = nil, nil
    self.Epoch += 1
    Theseus.Util.Try("abort on death", function() Theseus.Tasks.Abort("death") end)
    Theseus.Util.Try("forget mount", function() Theseus.Mount.Forget() end)
end

function Theseus.Player:Unbind()
    self.BindVersion += 1
    self.Epoch += 1
    self.Char, self.Humanoid, self.Root = nil, nil, nil
    for _, conn in ipairs(self.CharConns) do
        conn:Disconnect()
    end
    table.clear(self.CharConns)
    if self.PlotConn then
        self.PlotConn:Disconnect()
        self.PlotConn = nil
    end
end

function Theseus.Player:Bind(char)
    if not State.Alive or State.Unloading then return end
    if self.Char and self.Char ~= char then self:Lose(self.Char) end
    self.BindVersion += 1
    local version = self.BindVersion
    for _, conn in ipairs(self.CharConns) do
        conn:Disconnect()
    end
    table.clear(self.CharConns)
    self.Char, self.Humanoid, self.Root = char, nil, nil

    task.spawn(function()
        local hum = char:WaitForChild("Humanoid", Config.LoadTimeout)
        local hrp = char:WaitForChild("HumanoidRootPart", Config.LoadTimeout)
        if not State.Alive or State.Unloading or self.Char ~= char or self.BindVersion ~= version then return end
        if not hum or not hrp then
            warn(Config.Tag, "character parts missing after", Config.LoadTimeout, "s")
            return
        end

        self.Humanoid, self.Root = hum, hrp
        table.insert(self.CharConns, hum.Died:Connect(function() self:Lose(char) end))
    end)
end

function Theseus.Player:IsAlive()
    local hum, hrp = self.Humanoid, self.Root
    return hum ~= nil and hum.Health > 0 and hrp ~= nil and hrp.Parent ~= nil
end

---@return Model|nil, BasePart|nil  plot and its baseplate
function Theseus.Player:Plot()
    local plot, bp = self.PlotModel, self.Baseplate
    if plot and bp and plot.Parent and bp.Parent then return plot, bp end

    local now = os.clock()
    if now < self.PlotRetryAt then return nil, nil end
    self.PlotRetryAt = now + Config.PlotRetry

    plot = Theseus.GameLib.Plot()
    bp = plot and plot:FindFirstChild("Baseplate")
    if not bp then return nil, nil end
    self.PlotModel, self.Baseplate = plot, bp

    if self.PlotConn then self.PlotConn:Disconnect() end
    local owner = plot:FindFirstChild("Data") and plot.Data:FindFirstChild("Owner")
    if owner then
        self.PlotConn = owner.Changed:Connect(function()
            self.PlotModel, self.Baseplate, self.PlotRetryAt = nil, nil, 0
        end)
    end
    return plot, bp
end

---@return Instance[]
function Theseus.Player:BasketItems()
    local basket = LocalPlayer:FindFirstChild("Basket")
    return basket and basket:GetChildren() or {}
end

function Theseus.Player:BasketCount()
    local basket = LocalPlayer:FindFirstChild("Basket")
    return basket and #basket:GetChildren() or 0
end

function Theseus.Player:Riding()
    return LocalPlayer:GetAttribute("IsRiding") == true
end

---@async
---@return boolean  off the mount with empty hands, yields until the landing tool is put away
function Theseus.Player:Release()
    local hum = self.Humanoid
    local remote = self:Riding() and Theseus.GameLib.Remote("PetDismount")
    if remote and hum and hum.Parent then
        local landed = false
        local conn = hum.Parent.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then landed = true end
        end)
        remote:FireServer()

        local deadline = os.clock() + Config.DismountTimeout
        while self:Riding() and os.clock() < deadline do task.wait() end
        local toolBy = os.clock() + Config.DismountToolWindow
        while not landed and os.clock() < toolBy and hum.Parent do task.wait() end
        conn:Disconnect()
    end

    if self:BasketCount() > 0 or not hum then return not self:Riding() end
    hum:UnequipTools()
    return not self:Riding()
end

---@return number  server delivery-failure counter
function Theseus.Player:Flags()
    return tonumber(LocalPlayer:GetAttribute("TeleportFlags")) or 0
end

Theseus.Geo = {}

---@return number  root clearance for the current character and mount
function Theseus.Geo.Lift(minimum)
    local hum, root = Theseus.Player.Humanoid, Theseus.Player.Root
    return math.max(minimum or Config.StandLift, (hum and hum.HipHeight or 0) + (root and root.Size.Y / 2 or 0))
end

---@return Vector3  nearest point inside the baseplate edge, standing height
function Theseus.Geo.EdgeInside(bp, target)
    local rel = bp.CFrame:PointToObjectSpace(target)
    local hx, hz = bp.Size.X / 2 - Config.EdgeInset, bp.Size.Z / 2 - Config.EdgeInset
    local clamped = Vector3.new(math.clamp(rel.X, -hx, hx), bp.Size.Y / 2 + Theseus.Geo.Lift(), math.clamp(rel.Z, -hz, hz))
    return bp.CFrame:PointToWorldSpace(clamped)
end

---@param dist number  studs past the edge
---@return Vector3     point outside the baseplate on the side facing target
function Theseus.Geo.Outside(bp, target, dist)
    local rel = bp.CFrame:PointToObjectSpace(target)
    local hx, hz = bp.Size.X / 2, bp.Size.Z / 2
    local cx, cz = math.clamp(rel.X, -hx, hx), math.clamp(rel.Z, -hz, hz)
    local dx, dz = rel.X - cx, rel.Z - cz
    local len = math.sqrt(dx * dx + dz * dz)
    if len < 1e-3 then dx, dz, len = 1, 0, 1 end

    return bp.CFrame:PointToWorldSpace(Vector3.new(cx + dx / len * dist, bp.Size.Y / 2 + Theseus.Geo.Lift(), cz + dz / len * dist))
end

---@return Vector3  pickup spot on the egg-to-plot line, within reach of the egg
function Theseus.Geo.StandPoint(bp, eggPos)
    local edge = Theseus.Geo.EdgeInside(bp, eggPos)
    local dir = (edge - eggPos) * Vector3.new(1, 0, 1)
    local span = dir.Magnitude
    if span < 1e-3 then return Vector3.new(eggPos.X, eggPos.Y + Theseus.Geo.Lift(), eggPos.Z) end

    local spot = eggPos + dir.Unit * math.min(Config.PickupReach, span)
    return Vector3.new(spot.X, eggPos.Y + Theseus.Geo.Lift(), spot.Z)
end

---@return number  spatial distance to the plot entry, including elevated spawns
function Theseus.Geo.Trip(bp, from)
    return (from - Theseus.Geo.EdgeInside(bp, from)).Magnitude
end

function Theseus.Geo.InPlot(pos)
    local _, bp = Theseus.Player:Plot()
    return bp ~= nil and Theseus.GameLib.Contains(bp, pos)
end

if LocalPlayer.Character then Theseus.Player:Bind(LocalPlayer.Character) end
Theseus:Connect(LocalPlayer.CharacterAdded, function(char) Theseus.Player:Bind(char) end)
Theseus:Connect(LocalPlayer.CharacterRemoving, function(char) Theseus.Player:Lose(char) end)

Theseus.Tasks = { Current = nil, Prio = { Recover = 100, Volcano = 80, Hunter = 70, Mount = 65, Eggs = 60, Plot = 40, Travel = 30, Manual = 20 } }

function Theseus.Tasks.Carrying()
    if Theseus.Player:BasketCount() > 0 then return true end
    return Theseus.Halloween ~= nil and Theseus.Halloween.Carried() > 0
end

function Theseus.Tasks.EggsBusy()
    local eggs = Theseus.Eggs
    if not eggs or not eggs.Waiting then return false end
    return not eggs.Waiting()
end

---@return table|nil  token { owner, prio, epoch, dead, preempt }
function Theseus.Tasks.Request(owner, prio)
    if not Theseus.State.Alive then return nil end
    if Theseus.State.Unloading and owner ~= "Recover" then return nil end
    if not Theseus.Player:IsAlive() then return nil end

    if prio <= Theseus.Tasks.Prio.Manual and Theseus.Tasks.Carrying() then
        table.insert(Theseus.State.PendingNotify, { "Theseus", "Finish the egg delivery first" })
        return nil
    end
    if prio <= Theseus.Tasks.Prio.Plot and prio > Theseus.Tasks.Prio.Manual and Theseus.Tasks.EggsBusy() then return nil end

    local cur = Theseus.Tasks.Current
    if cur and (cur.dead or cur.epoch ~= Theseus.Player.Epoch) then
        cur.dead = true
        cur = nil
        Theseus.Tasks.Current = nil
    end

    if cur then
        if prio > cur.prio then cur.preempt = true end
        return nil
    end

    local token = { owner = owner, prio = prio, epoch = Theseus.Player.Epoch, thread = coroutine.running(), dead = false, preempt = false }
    local hrp = Theseus.Player.Root
    if prio <= Theseus.Tasks.Prio.Plot and hrp then token.home = hrp.CFrame end
    Theseus.Tasks.Current = token
    return token
end

function Theseus.Tasks.Release(token)
    if not token or token.dead then return end
    token.dead = true
    if Theseus.Tasks.Current ~= token then return end
    Theseus.Tasks.Current = nil

    local opts = Theseus.Options
    local back = opts and opts.ReturnAfter
    if not token.home or not back or not Theseus.State.Alive or Theseus.State.Unloading or Theseus.Tasks.Carrying() then return end
    local hrp = Theseus.Player.Root
    if hrp and Theseus.Player:IsAlive() and token.epoch == Theseus.Player.Epoch then
        hrp.CFrame = token.home
        hrp.AssemblyLinearVelocity = Vector3.zero
    end
end

---@return boolean  false after preempt, death or unload
function Theseus.Tasks.Holds(token)
    if not token or token.dead or not Theseus.State.Alive then return false end
    if Theseus.Tasks.Current ~= token or token.epoch ~= Theseus.Player.Epoch then return false end
    if not token.preempt or token.critical then return true end
    local delivering = token.owner == "Eggs" or token.owner == "Hunter" or token.owner == "Recover" or token.owner == "Volcano" or token.owner == "Halloween"
    if delivering and ((Theseus.Eggs and Theseus.Eggs.CarryCritical) or Theseus.Tasks.Carrying()) then return true end

    Theseus.Tasks.Release(token)
    return false
end

---@param cond     function|nil  nil waits the full timeout
---@return boolean, string        "ok"|"timeout"|"preempted"|"death"|"unload"
function Theseus.Tasks.Await(token, cond, timeout)
    local deadline = os.clock() + timeout
    repeat
        if not Theseus.State.Alive then return false, "unload" end
        if not token or token.epoch ~= Theseus.Player.Epoch then return false, "death" end
        if not Theseus.Tasks.Holds(token) then return false, "preempted" end
        if cond and cond() then return true, "ok" end
        task.wait()
    until os.clock() >= deadline
    return false, "timeout"
end

---@return boolean  refuses dead tokens
function Theseus.Tasks.Teleport(token, cf)
    if not Theseus.Tasks.Holds(token) then return false end
    if token.epoch ~= Theseus.Player.Epoch or not Theseus.Player:IsAlive() then return false end
    local hrp = Theseus.Player.Root
    if not hrp then return false end

    hrp.CFrame = cf
    hrp.AssemblyLinearVelocity = Vector3.zero
    return true
end

function Theseus.Tasks.Abort(why)
    local cur = Theseus.Tasks.Current
    if not cur then return end
    cur.dead, cur.why = true, why
    Theseus.Tasks.Current = nil
end

---@async
---@return boolean  reached the destination with bounded movement per frame
function Theseus.Tasks.Travel(token, cf, speed, timeout, opts)
    local deadline = os.clock() + timeout
    local collisions, originalCollisions, clipConnections = {}, {}, {}
    local root = Theseus.Player.Root
    local rotation = root and root.CFrame.Rotation
    local hum = Theseus.Player.Humanoid
    local autoRotate = hum and hum.AutoRotate
    local ok, reached = pcall(function()
        if hum then hum.AutoRotate = false end
        if opts and opts.noClip and Theseus.Player.Char then
            local function addPart(part)
                if not part:IsA("BasePart") or originalCollisions[part] ~= nil then return end
                originalCollisions[part] = part.CanCollide
                collisions[#collisions + 1] = part
                part.CanCollide = false
            end
            local function addModel(model)
                for _, part in ipairs(model:GetDescendants()) do addPart(part) end
                if model.DescendantAdded then
                    clipConnections[#clipConnections + 1] = model.DescendantAdded:Connect(function(part)
                        if Theseus.Tasks.Holds(token) then addPart(part) end
                    end)
                end
            end
            addModel(Theseus.Player.Char)
            local joint = root and root.FindFirstChild and root:FindFirstChild("PetMountJoint")
            local mount = joint and joint.Part1 and joint.Part1:FindFirstAncestorOfClass("Model")
            if mount and mount ~= Theseus.Player.Char then addModel(mount) end
            clipConnections[#clipConnections + 1] = RunService.Stepped:Connect(function()
                if not Theseus.Tasks.Holds(token) then return end
                for _, part in ipairs(collisions) do
                    if part.Parent and part.CanCollide then part.CanCollide = false end
                end
            end)
        end
        while Theseus.Tasks.Holds(token) and os.clock() < deadline do
            if opts and opts.maxFlags ~= nil and Theseus.Player:Flags() > opts.maxFlags then return false end
            if opts and opts.done and opts.done() then return true end
            local hrp = Theseus.Player.Root
            if not hrp or not Theseus.Player:IsAlive() then return false end
            local delta = cf.Position - hrp.Position
            local reach = opts and opts.reach or Config.TravelStopDistance
            if delta.Magnitude <= reach then return true end
            if hum then hum:Move(Vector3.zero) end
            local elapsed = task.wait()
            if not Theseus.Tasks.Holds(token) then return false end
            if opts and opts.maxFlags ~= nil and Theseus.Player:Flags() > opts.maxFlags then return false end
            if opts and opts.done and opts.done() then return true end
            for _, part in ipairs(collisions) do
                if part.Parent and part.CanCollide then part.CanCollide = false end
            end
            delta = cf.Position - hrp.Position
            if delta.Magnitude <= reach then return true end
            local currentSpeed = type(speed) == "function" and speed() or speed
            if type(currentSpeed) ~= "number" or currentSpeed ~= currentSpeed or currentSpeed <= 0 or currentSpeed == math.huge then return false end
            local step = math.min(delta.Magnitude, currentSpeed * math.min(elapsed, Config.TravelStepMax))
            local pos = hrp.Position + delta.Unit * step
            local nextCF = CFrame.new(pos) * rotation
            if not Theseus.Tasks.Teleport(token, nextCF) then return false end
        end
        return false
    end)

    for _, connection in ipairs(clipConnections) do connection:Disconnect() end
    for _, part in ipairs(collisions) do
        if part.Parent then part.CanCollide = originalCollisions[part] end
    end
    if hum and hum.Parent then hum.AutoRotate = autoRotate end
    if not ok then error(reached, 0) end
    return reached
end

function Theseus.Tasks.ReleaseAll(why)
    Theseus.Tasks.Abort(why or "release")
end

function Theseus.Tasks.Owner()
    local cur = Theseus.Tasks.Current
    return cur and not cur.dead and cur.owner or nil
end

Theseus.Scheduler = { Jobs = {}, Order = {}, Booted = false }

Theseus.Scheduler.Defaults = {
    { "Eggs", "Eggs", "Step", { "AutoEggs" } },
    { "Hunter", "Hunter", "Step", { "EggHunter" } },
    { "Volcano", "Volcano", "Step", { "VolcanoDip", "VolcanoObby" } },
    { "Halloween", "Halloween", "Step", { "AutoCandy", "AutoTrickOrTreat", "AutoPumpkin", "AutoHalloweenEgg", "AutoRitual" }, function() return Theseus.Halloween.AnyActive() end },
    { "Junk", "Junk", "Step", { "ClearJunk" } },
    { "Hatch", "Hatch", "Step", { "AutoHatch" }, function()
        return Theseus.Util.Opt("AutoHatch") == true or (Theseus.Util.Opt("HalloweenAutoHatch") ~= false and next(Theseus.Hatch.Purchased) ~= nil)
    end },
    { "Plant", "Hatch", "PlantStep", { "AutoPlaceEggs" } },
    { "Pets", "Pets", "Step", { "AutoEquipBest", "AutoCollectCash" } },
    { "Feed", "Pets", "FeedStep", { "AutoFeed" } },
    { "Sell", "Sell", "Step", { "AutoSell" } },
    { "Fusion", "Fusion", "Step", { "AutoFusion" } },
    { "Economy", "Economy", "Step", { "AutoUpgrade", "AutoRebirth", "SmartSpend" } },
    { "Shop", "Shop", "Step", { "AutoShop" } },
    { "Rewards", "Rewards", "Step", { "AutoClaim" } },
    { "Boosts", "Boosts", "Step", nil },
    { "Server", "Server", "Step", nil },
    { "Esp", "Esp", "Step", { "EggEsp" } },
    { "HalloweenEsp", "Halloween", "EspStep", { "HalloweenEsp" } },
    { "Webhook", "Webhook", "Step", nil },
    { "Settle", "Eggs", "SettleStep", nil },
    { "Kaitun", "Kaitun", "Step", { "Kaitun" } },
}

---@param enabledFn function|nil  nil = any of toggles is on, or always when toggles is nil too
---@param toggles string[]|nil    switched off when the job halts
function Theseus.Scheduler.Add(name, interval, fn, enabledFn, toggles)
    local job = Theseus.Scheduler.Jobs[name]
    if not job then
        job = { name = name, due = 0, busy = false }
        job.runner = function()
            job.thread = coroutine.running()
            local ok, err = pcall(function()
                if not State.Alive or State.Unloading then return end
                job.fn()
            end)
            job.busy = false
            if not ok then Theseus.Scheduler.Fail(job, err) end
            job.thread = nil
        end
        Theseus.Scheduler.Jobs[name] = job
        table.insert(Theseus.Scheduler.Order, job)
    end
    job.interval, job.fn, job.enabledFn, job.toggles = interval, fn, enabledFn, toggles or {}
    return job
end

---@return boolean
function Theseus.Scheduler.Enabled(job)
    if State.Halted[job.name] then return false end
    if job.enabledFn then return job.enabledFn() == true end
    if #job.toggles == 0 then return true end

    for _, idx in ipairs(job.toggles) do
        if Theseus.Util.Opt(idx) == true then return true end
    end
    return false
end

function Theseus.Scheduler.Fail(job, err)
    local token = Theseus.Tasks.Current
    if token and job.thread and token.thread == job.thread then Theseus.Tasks.Abort("job error: " .. job.name) end
    local now = os.clock()
    local log = State.Errors[job.name] or {}
    State.Errors[job.name] = log

    local kept = {}
    for _, at in ipairs(log) do
        if now - at <= Config.FailWindow then kept[#kept + 1] = at end
    end
    kept[#kept + 1] = now
    State.Errors[job.name] = kept

    if #kept == 1 then warn(Config.Tag, job.name .. " failing:", err) end
    if #kept < Config.FailLimit then return end

    if #job.toggles == 0 then
        State.Errors[job.name] = nil
        job.due = now + Config.JobBackoff
        warn(Config.Tag, job.name .. " backing off:", err)
        return
    end

    State.Halted[job.name] = true
    for _, idx in ipairs(job.toggles) do
        table.insert(State.PendingToggleOff, idx)
    end
    local line = tostring(err):match("^[^\n]*") or "unknown error"
    Theseus.Util.Notify("Theseus", job.name .. " stopped: " .. line, 8)
end

function Theseus.Scheduler.Run(job)
    if job.busy or not State.Alive or State.Unloading then return end
    job.busy = true
    task.spawn(job.runner)
end

function Theseus.Scheduler.Tick()
    if not State.Alive or State.Unloading then return end
    local now = os.clock()
    for _, job in ipairs(Theseus.Scheduler.Order) do
        if job.busy or now < job.due then continue end
        job.due = now + job.interval
        local ok, enabled = pcall(Theseus.Scheduler.Enabled, job)
        if not ok then
            Theseus.Scheduler.Fail(job, enabled)
            continue
        end
        if not enabled then continue end
        Theseus.Scheduler.Run(job)
    end
end

---@param key string  job name or toggle idx
function Theseus.Scheduler.Resume(key)
    for name, job in pairs(Theseus.Scheduler.Jobs) do
        if name == key or table.find(job.toggles, key) then
            State.Halted[name] = nil
            State.Errors[name] = nil
            job.due = 0
        end
    end
end

function Theseus.Scheduler.Pump()
    if not Library then return end
    if #State.PendingToggleOff == 0 and #State.PendingNotify == 0 then return end

    local offList = State.PendingToggleOff
    State.PendingToggleOff = {}
    for _, idx in ipairs(offList) do
        local option = Library.Options and Library.Options[idx]
        if option and option.Value then option:SetValue(false) end
        Theseus.Options[idx] = false
    end

    local notes = State.PendingNotify
    State.PendingNotify = {}
    for _, note in ipairs(notes) do
        Library:Notify(note[1], note[2], note[3] or 5)
    end
end

function Theseus.Scheduler.AddDefaults()
    local espTick = Theseus.Platform.Mobile and Config.EspTickMobile or Config.EspTick
    for _, row in ipairs(Theseus.Scheduler.Defaults) do
	local name, owner, method, toggles, enabledFn = row[1], row[2], row[3], row[4], row[5]
	local interval = Config.JobTick[name] or espTick
	if Theseus.Scheduler.Jobs[name] then continue end

	local module = rawget(Theseus, owner)
	local fn = module and module[method]
	if type(fn) ~= "function" then
		warn(Config.Tag, "no job function " .. owner .. "." .. method)
		continue
	end
	Theseus.Scheduler.Add(name, interval, fn, enabledFn, toggles)
end
end

function Theseus.Scheduler.Boot()
    if Theseus.Scheduler.Booted then return end
    Theseus.Scheduler.Booted = true

    Theseus.Scheduler.AddDefaults()
    Theseus:Connect(RunService.Heartbeat, Theseus.Scheduler.Tick)
end

Theseus.Signal = {}
Theseus.Signal.__index = Theseus.Signal

function Theseus.Signal.new()
    return setmetatable({ handlers = {} }, Theseus.Signal)
end

---@return function  call to disconnect
function Theseus.Signal:Connect(fn)
    local handlers = self.handlers
    handlers[#handlers + 1] = fn
    return function()
        local at = table.find(handlers, fn)
        if at then table.remove(handlers, at) end
    end
end

function Theseus.Signal:Fire(...)
    for _, fn in ipairs(table.clone(self.handlers)) do
        Theseus.Util.Try("signal", fn, ...)
    end
end

Theseus.EggIndex = {
    Entries = {}, Conns = {}, Waiters = {},
    Claimed = {}, LocalClaims = {}, Blacklist = {}, Failed = {}, FailCap = 2,
    Memo = {}, Mult = nil, Median = nil, ValueEpoch = 0,
    Cycle = nil, RolledAt = 0, Started = false,
    OnAdded = Theseus.Signal.new(),
    OnRemoved = Theseus.Signal.new(),
    OnReply = Theseus.Signal.new(),
    OnRoll = Theseus.Signal.new(),
}

---@return number  hatch luck multiplier: upgrades x live event
function Theseus.EggIndex.LuckMult()
    return GameLib.LuckMult()
end

---@return number  expected income of one hatch, luck-based fallback when odds are unreadable
function Theseus.EggIndex.Expected(egg, mult)
    local key = egg .. "|" .. mult
    local memo = Theseus.EggIndex.Memo
    if memo[key] then return memo[key] end

    local total = 0
    for _, pair in ipairs(GameLib.Odds(egg, mult) or {}) do
        local pet = GameLib.PetInfo[pair[1]]
        total += (tonumber(pair[2]) or 0) * (pet and pet.income or 0)
    end
    if total <= 0 then
        local info = GameLib.EggInfo[egg]
        total = (info and info.luck or 0) * mult
    end

    memo[key] = total
    return total
end

function Theseus.EggIndex.Value(entry)
    if not entry.egg then return 0 end
    local index = Theseus.EggIndex
    index.Mult = index.Mult or index.LuckMult()
    local factor = entry.mutation and GameLib.Mutations[entry.mutation] or 1
    return index.Expected(entry.egg, index.Mult) * (entry.weight or 1) * factor
end

function Theseus.EggIndex.Revalue()
    local index = Theseus.EggIndex
    table.clear(index.Memo)
    index.Mult = nil
    for _, entry in pairs(index.Entries) do
        entry.value = index.Value(entry)
    end
    index.Median = nil
    index.ValueEpoch += 1
end

---@param entry table?  refreshed in place when given
function Theseus.EggIndex.Read(inst, entry)
    entry = entry or { guid = inst.Name, inst = inst }
    entry.egg = inst:GetAttribute("Egg")
    entry.pos = inst:GetAttribute("Position")
    entry.weight = tonumber(inst:GetAttribute("Weight")) or 1
    entry.mutation = inst:GetAttribute("Mutation")
    entry.cycle = tonumber(inst:GetAttribute("Cycle"))
    entry.privateTo = inst:GetAttribute("PrivateTo")
    entry.area = inst:GetAttribute("Area") == true
    entry.dropEndsAt = tonumber(inst:GetAttribute("DropEndsAt"))
    entry.origin = inst:GetAttribute("OriginPosition")
    entry.value = Theseus.EggIndex.Value(entry)
    return entry
end

function Theseus.EggIndex.Add(inst)
    local index = Theseus.EggIndex
    if index.Entries[inst.Name] then return end
    local entry = index.Read(inst)
    index.Entries[inst.Name] = entry
    index.Median = nil

    index.Conns[inst.Name] = inst.AttributeChanged:Connect(function(attr)
        if attr ~= "Position" and attr ~= "DropEndsAt" and attr ~= "PrivateTo" then return end
        local wasDropped = entry.dropEndsAt ~= nil
        index.Read(inst, entry)
        if attr == "DropEndsAt" and not wasDropped and entry.dropEndsAt then index.OnAdded:Fire(entry) end
    end)

    index.OnAdded:Fire(entry)
end

function Theseus.EggIndex.Remove(inst)
    local index = Theseus.EggIndex
    local entry = index.Entries[inst.Name]
    if not entry then return end
    index.Entries[inst.Name] = nil
    entry.removed = true

    local conn = index.Conns[inst.Name]
    if conn then conn:Disconnect() end
    index.Conns[inst.Name] = nil
    index.Median = nil
    index.OnRemoved:Fire(entry)
end

---@param key string  egg guid, or "*carry" for Deposited/BasketFull
function Theseus.EggIndex.Expect(key)
    local waiter = {}
    Theseus.EggIndex.Waiters[key] = waiter
    return waiter
end

function Theseus.EggIndex.Deliver(key, kind, text)
    local waiter = key and Theseus.EggIndex.Waiters[key]
    if not waiter or waiter.kind then return end
    waiter.kind, waiter.text = kind, text
end

---@return string, string?  PickedUp|Refused|Gone|BasketFull|Deposited|Timeout, server text
function Theseus.EggIndex.WaitReply(key, timeout)
    local index = Theseus.EggIndex
    local waiter = index.Waiters[key] or index.Expect(key)
    local deadline = os.clock() + timeout
    while not waiter.kind and os.clock() < deadline and State.Alive do
        task.wait()
    end
    if index.Waiters[key] == waiter then index.Waiters[key] = nil end
    if not waiter.kind then return "Timeout" end
    return waiter.kind, waiter.text
end

function Theseus.EggIndex.Route(kind, first, second)
    local index = Theseus.EggIndex
    if kind == "PickedUp" then
        index.Deliver(second, "PickedUp", first)
        index.OnReply:Fire("PickedUp", second, first)
    elseif kind == "Refused" then
        local text = tostring(first)
        local verdict = text:find("already gone", 1, true) and "Gone" or "Refused"
        if verdict == "Gone" and second then index.Blacklist[second] = os.clock() + Config.GoneBlacklistSec end
        index.Deliver(second, verdict, text)
        index.OnReply:Fire(verdict, second, text)
    elseif kind == "Deposited" then
        index.Deliver("*carry", "Deposited", tostring(first))
        index.OnReply:Fire("Deposited", nil, first)
    elseif kind == "BasketFull" then
        for key in pairs(index.Waiters) do index.Deliver(key, "BasketFull") end
        index.OnReply:Fire("BasketFull")
    end
end

function Theseus.EggIndex.OnMessage(text)
    if type(text) ~= "string" then return end
    if text:find("Egg Delivery Failed", 1, true) or text:find("Was Returned", 1, true) then
        Theseus.Guard.Trip("message")
    end
end

function Theseus.EggIndex.ReadClaims()
    local index = Theseus.EggIndex
    local raw = LocalPlayer:GetAttribute("CollectedEggCycles")
    if type(raw) ~= "string" or raw == "" then return end

    local http = game:GetService("HttpService")
    local ok, decoded = pcall(http.JSONDecode, http, raw)
    if not ok or type(decoded) ~= "table" then
        index.ClaimsBroken = true
        return
    end

    table.clear(index.Claimed)
    for egg, cycle in pairs(decoded) do
        index.Claimed[egg] = tonumber(cycle)
    end
    index.ClaimsBroken = false
end

---@return number  last cycle this egg was claimed in, -1 if never
function Theseus.EggIndex.ClaimedCycle(egg)
    local index = Theseus.EggIndex
    return math.max(index.Claimed[egg] or -1, index.LocalClaims[egg] or -1)
end

function Theseus.EggIndex.MarkClaimed(egg, cycle)
    if not egg or not cycle then return end
    local claims = Theseus.EggIndex.LocalClaims
    claims[egg] = math.max(claims[egg] or -1, cycle)
end

function Theseus.EggIndex.MarkGone(guid)
    if guid then Theseus.EggIndex.Blacklist[guid] = os.clock() + Config.GoneBlacklistSec end
end

function Theseus.EggIndex.Fail(guid)
    local failed = Theseus.EggIndex.Failed
    failed[guid] = (failed[guid] or 0) + 1
end

---@return boolean  true on the tick the egg cycle rolled over
function Theseus.EggIndex.CheckRoll()
    local index = Theseus.EggIndex
    local cycle = GameLib.CycleIndex()
    if cycle == index.Cycle then return false end

    local rolled = index.Cycle ~= nil
    index.Cycle = cycle
    if not rolled then return false end

    table.clear(index.Blacklist)
    table.clear(index.Failed)
    index.RolledAt = os.clock()
    index.OnRoll:Fire(cycle)
    return true
end

---@return number  median value of the eggs on the map now
function Theseus.EggIndex.MedianValue()
    local index = Theseus.EggIndex
    if index.Median then return index.Median end

    local values = {}
    for _, entry in pairs(index.Entries) do
        local info = entry.egg and GameLib.EggInfo[entry.egg]
        if info and not info.volcanic then values[#values + 1] = entry.value or 0 end
    end
    table.sort(values)

    index.Median = values[math.max(1, math.ceil(#values / 2))] or 0
    return index.Median
end

---@return string?  reason the egg cannot be taken right now
function Theseus.EggIndex.Blocked(entry, info)
    local index = Theseus.EggIndex
    if entry.privateTo and entry.privateTo ~= LocalPlayer.UserId then return "private" end
    if info.volcanic then return "volcanic" end
    if entry.dropEndsAt and Theseus.Util.ServerNow() < entry.dropEndsAt then return "falling" end
    if info.ethereal and entry.cycle and entry.cycle <= index.ClaimedCycle(entry.egg) then return "claimed" end
    if (index.Blacklist[entry.guid] or 0) > os.clock() then return "taken" end
    if (index.Failed[entry.guid] or 0) >= index.FailCap then return "failed" end
    return nil
end

---@return boolean  passes the user's egg filters
function Theseus.EggIndex.Allowed(entry, info)
    local opts = Theseus.Options
    local rarities, names = opts.EggRarities, opts.EggNames
    local floor = GameLib.RarityRank[opts.MinEggRarity or ""]
    if floor and (GameLib.RarityRank[info.rarity] or 0) < floor then return false end
    if type(rarities) == "table" and next(rarities) and not rarities[info.rarity] then return false end
    if type(names) == "table" and next(names) and not names[entry.egg] then return false end
    if (info.luck or 0) < (tonumber(opts.MinLuck) or 0) then return false end
    return entry.weight >= (tonumber(opts.MinWeight) or 0)
end

---@param ignoreFilters boolean?  hunter-only mode skips the user filters
---@return boolean, string?       wanted, reason when not
function Theseus.EggIndex.Wanted(entry, ignoreFilters)
    if entry.removed or not entry.pos or not entry.egg then return false, "gone" end
    local info = GameLib.EggInfo[entry.egg]
    if not info then return false, "unknown" end

    local reason = Theseus.EggIndex.Blocked(entry, info)
    if reason then return false, reason end
    if ignoreFilters then return true end

    if not Theseus.EggIndex.Allowed(entry, info) then return false, "filtered" end
    if Theseus.Options.SmartEggs and (entry.value or 0) < Theseus.EggIndex.MedianValue() then return false, "low value" end
    return true
end

function Theseus.EggIndex.WatchValues()
    local saved = LocalPlayer:FindFirstChild("SavedData")
    local upgrades = saved and saved:FindFirstChild("HatchUpgrades")
    if upgrades then Theseus:Connect(upgrades.Changed, Theseus.EggIndex.Revalue) end
    Theseus:Connect(ReplicatedStorage:GetAttributeChangedSignal("HatchLuckEventMultiplier"), Theseus.EggIndex.Revalue)
    Theseus:Connect(LocalPlayer:GetAttributeChangedSignal("CollectedEggCycles"), Theseus.EggIndex.ReadClaims)
end

---@return boolean  index is live
function Theseus.EggIndex.Start()
    local index = Theseus.EggIndex
    if index.Started then return true end
    local serverData = ReplicatedStorage:FindFirstChild("ServerData")
    local folder = serverData and serverData:FindFirstChild("ActiveEggs")
    if not folder then return false end
    index.Started = true

    Theseus:Connect(folder.ChildAdded, Theseus.EggIndex.Add)
    Theseus:Connect(folder.ChildRemoved, Theseus.EggIndex.Remove)
    for _, inst in ipairs(folder:GetChildren()) do
        index.Add(inst)
    end

    local pickup = GameLib.Remote("EggPickup")
    if pickup then Theseus:Connect(pickup.OnClientEvent, Theseus.EggIndex.Route) end
    local message = GameLib.Remote("GameMessage")
    if message then Theseus:Connect(message.OnClientEvent, Theseus.EggIndex.OnMessage) end

    index.WatchValues()
    index.ReadClaims()
    index.Cycle = GameLib.CycleIndex()
    return true
end

function Theseus.EggIndex.Stop()
    local index = Theseus.EggIndex
    for guid, conn in pairs(index.Conns) do
        conn:Disconnect()
        index.Conns[guid] = nil
    end
    table.clear(index.Waiters)
end

local CollectionService = game:GetService("CollectionService")

Theseus.Halloween = {
    Enabled = false,
    Phase = "Idle",
    PhaseAt = 0,
    Note = nil,
    Token = nil,
    Target = nil,
    CarriedBefore = 0,
    CarriedWas = 0,
    FirstPickAt = 0,
    NextCollectAt = 0,
    LastCollectAt = 0,
    GroundRay = nil,
    ManualCandy = false,
    ManualPass = nil,
    ManualUntil = nil,
    BuyOnce = false,
    BuyTravel = false,
    Purchase = nil,
    LastBuyAt = 0,
    PriceSeen = nil,
    PriceFound = nil,
    EggsBought = 0,
    TokensEarned = 0,
    Cycles = 0,
    Spoiled = 0,
    StartedAt = 0,
    Bound = false,
    AwaitCarried = false,
    Conns = {},
    Boards = {},
    DoorAt = {},
    PumpkinAt = {},
    SkipUntil = {},
    CandyState = nil,
    CandyStateAt = 0,
    DoorState = nil,
    DoorStateAt = 0,
    PumpkinState = nil,
    PumpkinStateAt = 0,
    RitualAt = 0,
    RitualSeenOpen = false,
    ZoneTries = 0,
    ZoneRetryAt = 0,
    PadCache = nil,
    DepositCarried = 0,
    DepositBankBefore = 0,
    DepositRetried = false,
    Busy = false,
    FlagsBaseline = nil,
    Finishing = false,
    Stats = { candy = 0, knocks = 0, treats = 0 },
}

function Theseus.Halloween.SetPhase(phase, note)
    local halloween = Theseus.Halloween
    halloween.Phase, halloween.PhaseAt, halloween.Note = phase, os.clock(), note
    Theseus.Halloween.UpdateStatus()
end

function Theseus.Halloween.UpdateStatus()
    local halloween = Theseus.Halloween
    if not halloween.Enabled and not halloween.ManualCandy and not halloween.ManualPass then
        State.Status.Halloween = "Off"
        return
    end

    local mins = halloween.StartedAt > 0 and math.floor((os.clock() - halloween.StartedAt) / 60) or 0
    local note = halloween.Note and (halloween.Note .. " | ") or ""
    State.Status.Halloween = string.format("%s%s | Carried %d | Bank %s | %dm",
        note, halloween.Phase, Theseus.Halloween.Carried(), Theseus.Util.Format(Theseus.Halloween.Tokens()), mins)
end

---@return number  candy held while walking, from the player's replicated data
function Theseus.Halloween.Carried()
    local noSave = LocalPlayer:FindFirstChild("NoSaveData")
    local node = noSave and noSave:FindFirstChild("CarriedCandy")
    return node and tonumber(node.Value) or 0
end

---@return number  event tokens banked
function Theseus.Halloween.Tokens()
    local saved = LocalPlayer:FindFirstChild("SavedData")
    local node = saved and saved:FindFirstChild("HalloweenCandy")
    return node and tonumber(node.Value) or 0
end

---@return boolean|nil  false when the game says we are off the event island
function Theseus.Halloween.InZone()
    local value = LocalPlayer:GetAttribute("InHalloweenZone")
    if value == nil then
        local char = Theseus.Player.Char
        value = char and char:GetAttribute("InHalloweenZone")
    end
    if value == nil then
        value = Workspace:GetAttribute("InHalloweenZone")
    end
    return value
end

---@return boolean  the event island is in this server
function Theseus.Halloween.EventLive()
    if #CollectionService:GetTagged("HalloweenCandyDeposit") > 0 then return true end
    if #CollectionService:GetTagged("HalloweenCandySpawn") > 0 then return true end
    return Workspace:FindFirstChild("HeadlessRitual") ~= nil
end

---@return Vector3  a world point for a tagged spawn, prompt or model
function Theseus.Halloween.PointOf(inst)
    if inst:IsA("BasePart") then return inst.Position end
    if inst:IsA("Model") then return inst:GetPivot().Position end
    if inst:IsA("Attachment") then return inst.WorldPosition end

    local holder = inst:FindFirstAncestorOfClass("BasePart") or inst:FindFirstAncestorOfClass("Model")
    if holder then
        return holder:IsA("BasePart") and holder.Position or holder:GetPivot().Position
    end
    return nil
end

---@return Vector3  candy pad position, tag first then the measured fallback
function Theseus.Halloween.PadPos()
    local halloween = Theseus.Halloween
    if halloween.PadCache and halloween.PadCache.Parent then
        return halloween.PadCache.Position
    end

    for _, inst in ipairs(CollectionService:GetTagged("HalloweenCandyDeposit")) do
        local pos = Theseus.Halloween.PointOf(inst)
        if pos then
            halloween.PadCache = inst
            return pos
        end
    end
    return Config.CandyPadPos
end

---@return CFrame  standing spot on the candy pad
function Theseus.Halloween.PadCF()
    return CFrame.new(Theseus.Halloween.PadPos() + Vector3.new(0, Theseus.Halloween.StandLift(), 0))
end

---@return number  root height for the current character and mount
function Theseus.Halloween.StandLift()
    local hum, hrp = Theseus.Player.Humanoid, Theseus.Player.Root
    return math.max(Config.CandyPadLift, (hum and hum.HipHeight or 0) + (hrp and hrp.Size.Y / 2 or 0))
end

---@return CFrame  ground-relative pickup position on the pad-facing side
function Theseus.Halloween.PickupCF(pos, inst)
    local lift = Theseus.Halloween.StandLift()
    local pad = Theseus.Halloween.PadPos()
    local dir = (pad - pos) * Vector3.new(1, 0, 1)
    local reach = math.sqrt(math.max(0, Config.CandyPickupReach * Config.CandyPickupReach - lift * lift))
    local spot = pos
    if dir.Magnitude > Config.TravelStopDistance then spot += dir.Unit * math.min(reach, dir.Magnitude) end

    local ray = Theseus.Halloween.GroundRay
    if not ray then
        ray = RaycastParams.new()
        ray.FilterType = Enum.RaycastFilterType.Exclude
        ray.RespectCanCollide = true
        Theseus.Halloween.GroundRay = ray
    end
    ray.FilterDescendantsInstances = { Theseus.Player.Char or Workspace, inst }
    local hit = Workspace:Raycast(spot + Vector3.new(0, Config.GroundRayUp, 0), Vector3.new(0, -(Config.GroundRayUp + Config.GroundRayDown), 0), ray)
    local stand = (hit and hit.Position or spot) + Vector3.new(0, lift, 0)
    local facing = Vector3.new(pad.X, stand.Y, pad.Z)
    return (facing - stand).Magnitude > Config.TravelStopDistance and CFrame.lookAt(stand, facing) or CFrame.new(stand)
end

---@return number  a single verified short-hop budget, not repeated teleports
function Theseus.Halloween.DirectLimit(ignoreStyle)
    if not ignoreStyle and Theseus.Halloween.ReturnHopDisabled then return 0 end
    if not ignoreStyle and Theseus.Util.Opt("CandyReturnStyle") == "Smooth ride" then return 0 end
    local speed = Theseus.Mount.Speed()
    return math.min(Config.CandyDirectMax, speed > 0 and speed * Config.CandyDirectFactor or Config.UnmountedDirect)
end

---@return CFrame  the event portal entrance
function Theseus.Halloween.PortalCF()
    local map = Workspace:FindFirstChild("Map")
    local portal = map and map:FindFirstChild("Portal")
    local outer = portal and portal:FindFirstChild("Model")
    local inner = outer and outer:FindFirstChild("Model")
    local part = inner and inner:FindFirstChild("Part")
    if part and part:IsA("BasePart") then
        return CFrame.new(part.Position + Vector3.new(0, Config.StandLift, 0))
    end
    if portal and portal:IsA("Model") then
        return CFrame.new(portal:GetPivot().Position + Vector3.new(0, Config.StandLift, 0))
    end
    return CFrame.new(Config.PortalPos)
end

---@return Instance[]  tagged trick-or-treat houses
function Theseus.Halloween.Houses()
    return CollectionService:GetTagged("TrickOrTreatHouseModel")
end

---@return string  door id the remotes use for this house
function Theseus.Halloween.DoorId(house, pivot)
    local attr = house:GetAttribute("Id") or house:GetAttribute("DoorId")
    if attr then return attr end
    return "Door_" .. math.round(pivot.Position.X) .. "_" .. math.round(pivot.Position.Z)
end

---@return table|nil  cached GetCandyState answer
function Theseus.Halloween.AskCandy()
    local halloween = Theseus.Halloween
    local now = os.clock()
    if halloween.CandyStateAt > 0 and now - halloween.CandyStateAt < Config.CandyStateCache then
        return halloween.CandyState
    end

    local remote = Theseus.Net.GetCandyState
    if not remote then return halloween.CandyState end
    local ok, state = GameLib.Call(remote.InvokeServer, remote)
    halloween.CandyStateAt = now
    if ok and type(state) == "table" then halloween.CandyState = state end
    return halloween.CandyState
end

---@return table  id -> { respawnAt, amount, respawning }
function Theseus.Halloween.SpawnState()
    local parsed = {}
    local state = Theseus.Halloween.AskCandy()
    if type(state) ~= "table" then return parsed end

    local raw = state
    for _, key in ipairs({ "Spawns", "Candy", "CandySpawns" }) do
        if type(state[key]) == "table" then
            raw = state[key]
            break
        end
    end
    if raw == state and type(state.RespawnAt) == "table" then
        local now = workspace:GetServerTimeNow()
        for id, at in pairs(state.RespawnAt) do
            if type(id) == "string" and tonumber(at) and at > now then
                parsed[id] = { respawnAt = tonumber(at), amount = 0, respawning = true }
            end
        end
        for id, amount in pairs(state.Amounts or {}) do
            if type(id) == "string" then
                local at = tonumber(state.RespawnAt[id])
                parsed[id] = {
                    respawnAt = at and at > now and at or nil,
                    amount = tonumber(amount) or 0,
                    tier = tonumber(state.Types and state.Types[id]),
                    respawning = at ~= nil and (at > now),
                }
            end
        end
        return parsed
    end
    for id, entry in pairs(raw) do
        if type(id) == "string" and type(entry) == "table" then
            parsed[id] = {
                respawnAt = tonumber(entry.RespawnAt),
                amount = tonumber(entry.Amounts) or tonumber(entry.Amount),
                tier = tonumber(entry.Tier) or tonumber(entry.Type),
                respawning = entry.Respawning == true,
            }
        end
    end
    return parsed
end

---@return table|nil  the game's shared Halloween config module
function Theseus.Halloween.CandyLib()
    return GameLib.Data.Halloween
end

---@param entry { amount, tier }  parsed spawn state
---@param dist number  distance from the candy pad
---@return number  bankable pieces per pickup cycle; unreachable spawns score zero
function Theseus.Halloween.CandyValue(entry, dist)
    local count = tonumber(entry.amount) or 1
    if count ~= count or count <= 0 or count == math.huge then return 0 end
    local returning = math.max(0, dist - Config.CandyPickupReach - Config.CandyDepositReach)
    local direct = Theseus.Halloween.DirectLimit()
    local mode = Theseus.Util.Opt("CandyMode") or "Most pieces"
    if mode == "Fast returns" and returning > Theseus.Halloween.DirectLimit(true) then return 0 end
    local speed = Theseus.Halloween.ReturnSpeed() / Theseus.Halloween.ReturnFactor()
    local types = Theseus.Halloween.CandyLib()
    local kind = types and types.CandyTypes and types.CandyTypes[tonumber(entry.tier)]
    local debuffs = GameLib.Data["Halloween.Debuffs"]
    local heavy = debuffs and debuffs.HeavyGravity
    if Theseus.Util.Opt("CandyAvoidSpoil") ~= false and kind and debuffs and debuffs.Enabled
        and debuffs.AffectedModels and debuffs.AffectedModels[kind.Model] and heavy and heavy.Enabled then
        speed /= math.max(tonumber(heavy.SpeedDivisor) or 1, 1)
    end
    local seconds = math.max(0, returning - direct) / math.max(speed, 1)
    if seconds + Config.CandyDepositReserve >= Config.CandySpoilAt then return 0 end
    if mode == "Most pieces" then return count end
    return count / math.max(Config.CandyCooldown, seconds + Config.CandyDepositReserve)
end

---@return number  movement budget from the active mount and actual humanoid speed
function Theseus.Halloween.ReturnFactor()
    local percent = tonumber(Theseus.Util.Opt("CandyReturnSpeed"))
    local factor = percent and percent / 100 or Config.CandyReturnFactor
    if type(factor) ~= "number" or factor ~= factor then return 1 end
    factor = math.clamp(factor, 1, 6)
    local cap = Theseus.Halloween.ReturnCapPercent
    return cap and math.min(factor, cap / 100) or factor
end

---@return number  selected return speed, following the current humanoid slowdown
function Theseus.Halloween.ReturnSpeed()
    local hum = Theseus.Player.Humanoid
    local speed = Theseus.Mount.TravelSpeed()
    if speed <= 0 then speed = Config.UnmountedPlayerSpeed end
    return math.min(speed, hum and hum.WalkSpeed or 0) * Theseus.Halloween.ReturnFactor()
end

---@return boolean  the spawn is on its respawn timer
function Theseus.Halloween.Respawning(inst, entry)
    if entry and entry.respawning then return true end
    local at = tonumber(inst:GetAttribute("RespawnAt")) or entry and entry.respawnAt
    if not at then return false end
    if at > 1e6 then return Theseus.Util.ServerNow() < at end
    return os.clock() < at
end

---@param dropsOnly boolean?  only door and pumpkin drops
---@return table|nil  { id, pos, value } the highest value spawn
function Theseus.Halloween.NextCandy(dropsOnly)
    local halloween = Theseus.Halloween
    if os.clock() + Config.CandyPrepAhead < halloween.NextCollectAt then return nil end

    local pad = Theseus.Halloween.PadPos()
    local states = Theseus.Halloween.SpawnState()
    local known = next(states) ~= nil
    local now = os.clock()

    local best, bestScore, bestDistance = nil, 0, math.huge
    for _, inst in ipairs(CollectionService:GetTagged("HalloweenCandySpawn")) do
        local id = inst:GetAttribute("Id") or inst.Name
        local pos = Theseus.Halloween.PointOf(inst)
        if not (id and pos) then continue end
        if dropsOnly and not (id:sub(1, 9) == "DoorCandy" or id:sub(1, 11) == "PumpkinDrop") then continue end
        if (halloween.SkipUntil[id] or 0) > now then continue end

        local entry = states[id]
        if Theseus.Halloween.Respawning(inst, entry) then continue end
        if known and not entry then continue end
        if entry and (entry.amount or 0) <= 0 then continue end
        if (entry and entry.amount or 1) < (tonumber(Theseus.Util.Opt("CandyMinAmount")) or 1) then continue end

        local dist = (pos - pad).Magnitude
        if dist > (tonumber(Theseus.Util.Opt("CandyMaxRange")) or Config.CandyRangeDefault) then continue end
        local score = Theseus.Halloween.CandyValue(entry or {}, dist)
        if score > bestScore or (score > 0 and score == bestScore and dist < bestDistance) then
            bestScore = score
            bestDistance = dist
            best = { id = id, pos = pos, value = score, instance = inst }
        end
    end
    if best then best.cf = Theseus.Halloween.PickupCF(best.pos, best.instance) end
    return best
end

---@return number|nil  seconds until the next candy respawn, nil when unknown
function Theseus.Halloween.NextRespawnIn()
    local states = Theseus.Halloween.SpawnState()
    local soonest = nil
    for _, entry in pairs(states) do
        if entry.respawning and entry.respawnAt then
            local left = entry.respawnAt - workspace:GetServerTimeNow()
            if left > 0 and (not soonest or left < soonest) then
                soonest = left
            end
        end
    end
    return soonest
end

---@return table|nil  cached GetDoorState answer
function Theseus.Halloween.AskDoors()
    local halloween = Theseus.Halloween
    local now = os.clock()
    if halloween.DoorStateAt > 0 and now - halloween.DoorStateAt < Config.DoorStateCache then
        return halloween.DoorState
    end

    local remote = Theseus.Net.GetDoorState
    if not remote then return halloween.DoorState end
    local ok, state = GameLib.Call(remote.InvokeServer, remote)
    halloween.DoorStateAt = now
    if ok and type(state) == "table" then halloween.DoorState = state end
    return halloween.DoorState
end

---@return boolean|nil  lit state of a door, nil when unknown
function Theseus.Halloween.DoorLit(id)
    local state = Theseus.Halloween.AskDoors()
    if type(state) ~= "table" then return nil end

    local raw = type(state.Doors) == "table" and state.Doors or state
    local entry = raw[id]
    if type(entry) == "table" then return entry.Lit == true end
    if type(entry) == "boolean" then return entry end
    return nil
end

---@return table|nil  { id, cf } a lit door that is off cooldown
function Theseus.Halloween.NextDoor()
    local halloween = Theseus.Halloween
    local now = os.clock()
    for _, house in ipairs(Theseus.Halloween.Houses()) do
        if not house:IsA("Model") then continue end
        local pivot = house:GetPivot()
        local id = Theseus.Halloween.DoorId(house, pivot)
        if (halloween.DoorAt[id] or 0) > now then continue end
        if Theseus.Halloween.DoorLit(id) ~= true then continue end

        return {
            id = id,
            cf = CFrame.new(pivot.Position + Vector3.new(Config.DoorStand, Config.StandLift, Config.DoorStand)),
        }
    end
    return nil
end

---@return boolean  this pumpkin was searched recently
function Theseus.Halloween.PumpkinLooted(state, id)
    if type(state) ~= "table" then return false end
    local raw = state.Pumpkins or state
    local entry = raw[id]
    if type(entry) ~= "table" then return false end

    local searched = tonumber(entry.SearchedAt)
    if not searched then return entry.Looted == true end
    local age = searched > 1e6 and (Theseus.Util.ServerNow() - searched) or (os.clock() - searched)
    return entry.Looted == true or age < Config.PumpkinCooldown
end

---@return table|nil  { id, pos } a pumpkin that can be searched
function Theseus.Halloween.NextPumpkin()
    local halloween = Theseus.Halloween
    local remote = Theseus.Net.GetPumpkinState
    local now = os.clock()
    if remote and now - halloween.PumpkinStateAt >= Config.PumpkinStateCache then
        local ok, state = GameLib.Call(remote.InvokeServer, remote)
        halloween.PumpkinStateAt = now
        if ok and type(state) == "table" then halloween.PumpkinState = state end
    end

    for _, inst in ipairs(CollectionService:GetTagged("PumpkinPrompt")) do
        local id = inst:GetAttribute("Id") or (inst.Parent and inst.Parent:GetAttribute("Id")) or inst.Name
        local pos = Theseus.Halloween.PointOf(inst)
        if not (id and pos) then continue end
        if (halloween.PumpkinAt[id] or 0) > now then continue end
        if Theseus.Halloween.PumpkinLooted(halloween.PumpkinState, id) then continue end
        return { id = id, pos = pos }
    end
    return nil
end

---@return table|nil  { model, phase, open }
function Theseus.Halloween.RitualInfo()
    local ritual = Workspace:FindFirstChild("HeadlessRitual")
    if not ritual then return nil end

    local phase = ritual:GetAttribute("Phase")
    local cooldownUntil = tonumber(ritual:GetAttribute("CooldownUntil")) or 0
    return {
        model = ritual,
        phase = phase,
        open = phase == "Open" and Theseus.Util.ServerNow() >= cooldownUntil,
    }
end

---@return CFrame|nil  altar stand point while the ritual is open
function Theseus.Halloween.RitualReady()
    local halloween = Theseus.Halloween
    local info = Theseus.Halloween.RitualInfo()
    if not info then
        State.Status.Ritual = "Ritual not found"
        return nil
    end
    if not info.open then
        State.Status.Ritual = "Ritual: " .. tostring(info.phase)
        halloween.RitualSeenOpen = false
        return nil
    end

    if not halloween.RitualSeenOpen then
        halloween.RitualSeenOpen = true
        Theseus.Util.Notify("Halloween", "The ritual is open", 8)
    end
    if os.clock() < halloween.RitualAt then return nil end

    local pivot = info.model:GetPivot()
    return CFrame.new(pivot.Position + pivot.LookVector * Config.RitualStand + Vector3.new(0, Config.StandLift, 0))
end

---@return integer  prompts triggered at the altar
function Theseus.Halloween.RitualInteract()
    local info = Theseus.Halloween.RitualInfo()
    if not info then return 0 end

    local fired = 0
    for _, node in ipairs(info.model:GetDescendants()) do
        if fired >= Config.RitualPrompts then break end
        if not (node:IsA("ProximityPrompt") and node.Enabled) then continue end
        if Theseus.Rewards.TriggerPrompt(node) then fired += 1 end
        task.wait(Config.RitualPromptGap)
    end
    return fired
end

---@return boolean  any event feature wants the character right now
function Theseus.Halloween.WantsMove()
	local opt = Theseus.Util.Opt
	return Theseus.Halloween.Finishing or Theseus.Halloween.BuyTravel or Theseus.Halloween.Purchase ~= nil or opt("AutoCandy") == true or opt("AutoTrickOrTreat") == true or opt("AutoPumpkin") == true
		or opt("AutoRitual") == true or Theseus.Halloween.ManualCandy == true or Theseus.Halloween.ManualPass ~= nil
end

---@return boolean  the scheduler job should run (toggles or a manual pass)
function Theseus.Halloween.AnyActive()
	local opt = Theseus.Util.Opt
	return Theseus.Halloween.WantsMove() or opt("AutoHalloweenEgg") == true or Theseus.Halloween.BuyOnce == true
end

---@return boolean  we hold the character token
function Theseus.Halloween.Claim()
    local halloween = Theseus.Halloween
    if halloween.Token and Theseus.Tasks.Holds(halloween.Token) then return true end
    halloween.Token = Theseus.Tasks.Request("Halloween", Config.HalloweenPrio)
    return halloween.Token ~= nil
end

function Theseus.Halloween.Release()
    local halloween = Theseus.Halloween
    local token = halloween.Token
    halloween.Token = nil
    if token then Theseus.Tasks.Release(token) end
end

function Theseus.Halloween.Reset(note)
    local halloween = Theseus.Halloween
    halloween.Target = nil
    halloween.DepositRetried = false
    if halloween.CollectBankBefore ~= nil and Theseus.Halloween.Carried() == 0 then halloween.CollectBankBefore = nil end
    Theseus.Halloween.Release()
    Theseus.Halloween.SetPhase("Idle", note)
end

function Theseus.Halloween.BeginDeposit()
    local halloween = Theseus.Halloween
    halloween.DepositCarried = Theseus.Halloween.Carried()
    halloween.DepositBankBefore = halloween.CollectBankBefore or Theseus.Halloween.Tokens()
    halloween.Target = { kind = "deposit", cf = Theseus.Halloween.PadCF() }
    Theseus.Halloween.SetPhase("Travel")
end

---@param kind string  "candy" | "door" | "pumpkin" | "ritual"
---@param id string
---@param cf CFrame
function Theseus.Halloween.BeginTarget(kind, id, cf, source)
    Theseus.Halloween.Target = { kind = kind, id = id, cf = cf, source = source }
    Theseus.Halloween.SetPhase("Travel")
end

function Theseus.Halloween.StepTravel()
    local halloween = Theseus.Halloween
    local target = halloween.Target
    if not target or not target.cf then return Theseus.Halloween.Reset() end
    if not Theseus.Halloween.Claim() then return end

    if target.kind == "deposit" and Theseus.Halloween.Carried() > 0 then
        halloween.Token.critical = true
        local hrp = Theseus.Player.Root
        local delta = target.cf.Position - hrp.Position
        local hop = math.min(Theseus.Halloween.DirectLimit(), delta.Magnitude)
        if hop > 0 and not target.hopped then
            target.hopped = true
            if not Theseus.Tasks.Teleport(halloween.Token, hrp.CFrame + delta.Unit * hop) then
                return Theseus.Halloween.Reset("Candy return interrupted")
            end
        end
        local expires = tonumber(LocalPlayer:GetAttribute("CandyExpiresAt"))
        local remaining = expires and expires == expires and expires < math.huge
            and expires - Theseus.Util.ServerNow() or Config.CandySpoilAt - (os.clock() - halloween.FirstPickAt)
        local reached = Theseus.Tasks.Travel(halloween.Token, target.cf, Theseus.Halloween.ReturnSpeed, math.max(0, remaining), {
            noClip = true,
            maxFlags = halloween.FlagsBaseline or Theseus.Player:Flags(),
            reach = Config.CandyDepositReach,
            done = function() return Theseus.Halloween.Carried() == 0 end,
        })
        if not reached then return Theseus.Halloween.Reset("Candy return interrupted") end
        return Theseus.Halloween.SetPhase("Deposit")
    end

    local hrp = Theseus.Player.Root
    local loaded = target.source and target.source.instance and target.source.instance.Parent
    if not loaded and hrp and (hrp.Position - target.cf.Position).Magnitude > Config.EventStreamDist then
        pcall(LocalPlayer.RequestStreamAroundAsync, LocalPlayer, target.cf.Position, Config.EventStreamTimeout)
    end
    if not Theseus.Tasks.Teleport(halloween.Token, target.cf) then
        return Theseus.Halloween.Reset("Could not move")
    end
    Theseus.Halloween.SetPhase("Settle")
end

function Theseus.Halloween.StepSettle()
    local halloween = Theseus.Halloween
    local target = halloween.Target
    if not target then return Theseus.Halloween.Reset() end
    local settle = target.kind == "candy" and Config.CandyPickupSettle or Config.HalloweenSettle
    if os.clock() - halloween.PhaseAt < settle then return end
    if not Theseus.Halloween.Claim() then return end

    if target.kind == "candy" then
        if os.clock() < halloween.NextCollectAt then return end
        local source = target.source
        if source and source.instance and not source.instance.Parent then
            return Theseus.Halloween.Reset("Candy disappeared; selecting another spawn")
        end
        halloween.CandyStateAt = 0
        local entry = Theseus.Halloween.SpawnState()[target.id]
        if entry and ((entry.amount or 0) <= 0 or entry.respawning) then
            return Theseus.Halloween.Reset("Candy is respawning; selecting another spawn")
        end
        if not Theseus.Tasks.Holds(halloween.Token) then return Theseus.Halloween.Reset("Waiting for a turn") end
        local hrp = Theseus.Player.Root
        if source and hrp and (hrp.Position - source.pos).Magnitude > Config.CandyPickupLimit then
            if target.repositioned then return Theseus.Halloween.Reset("Could not reach the candy") end
            target.repositioned = true
            target.cf = CFrame.new(source.pos + Vector3.new(0, Theseus.Halloween.StandLift(), 0))
            return Theseus.Halloween.SetPhase("Travel")
        end
        local remote = Theseus.Net.CollectCandy
        if not remote then return Theseus.Halloween.Reset("Candy collecting is unavailable") end
        halloween.CarriedBefore = Theseus.Halloween.Carried()
        halloween.CollectBankBefore = Theseus.Halloween.Tokens()
        halloween.LastCollectAt = os.clock()
        remote:FireServer(target.id)
        return Theseus.Halloween.SetPhase("Collect")
    end

    if target.kind == "door" then
        local remote = Theseus.Net.KnockDoor
        if remote then
            remote:FireServer(target.id)
            halloween.DoorAt[target.id] = os.clock() + Config.DoorCooldown
            halloween.Stats.knocks += 1
        end
        return Theseus.Halloween.Reset("Knocked")
    end

    if target.kind == "pumpkin" then
        local remote = Theseus.Net.SearchPumpkin
        if remote then
            remote:FireServer(target.id)
            halloween.PumpkinAt[target.id] = os.clock() + Config.PumpkinCooldown
        end
        return Theseus.Halloween.Reset("Searched")
    end

    if target.kind == "ritual" then
        local fired = Theseus.Halloween.RitualInteract()
        halloween.RitualAt = os.clock() + Config.RitualRetry
        return Theseus.Halloween.Reset(fired > 0 and "Ritual visited" or "Ritual is not ready")
    end

    if target.kind == "deposit" then
        return Theseus.Halloween.SetPhase("Deposit")
    end

    if target.kind == "shop" then return Theseus.Halloween.BuyAtShop() end

    if target.kind == "portal" then
        Theseus.Halloween.PortalTries = (Theseus.Halloween.PortalTries or 0) + 1
        task.spawn(function()
            local tries = Theseus.Halloween.PortalTries
            local epoch = Theseus.Player.Epoch
            for attempt = 1, 6 do
                if not State.Alive or State.Unloading or epoch ~= Theseus.Player.Epoch then return end
                if not Theseus.Halloween.WantsMove() then return end
                local portal = Workspace:FindFirstChild("Map")
                portal = portal and portal:FindFirstChild("Portal")
                if not (portal and Theseus.Player:IsAlive()) then break end
                if Theseus.Halloween.PortalTries ~= tries then return end

                local fired = false
                for _, prompt in ipairs(portal:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") then
                        fired = pcall(fireproximityprompt, prompt) or fired
                    end
                end
                if LocalPlayer:GetAttribute("InHalloweenZone") == true then return end
                task.wait(0.4)
            end
        end)
        return Theseus.Halloween.Reset("Entering the event")
    end

    Theseus.Halloween.Reset("Entering the event")
end

function Theseus.Halloween.StepCollect()
    local halloween = Theseus.Halloween
    local target = halloween.Target
    if not target then return Theseus.Halloween.Reset() end

    local carried = Theseus.Halloween.Carried()
    local banked = halloween.CollectBankBefore and Theseus.Halloween.Tokens() - halloween.CollectBankBefore or 0
    if carried == 0 and banked > 0 then
        halloween.Stats.candy += banked
        halloween.NextCollectAt = halloween.LastCollectAt + Config.CandyCooldown
        halloween.CandyStateAt = 0
        halloween.DepositBankBefore = halloween.CollectBankBefore
        return Theseus.Halloween.SetPhase("Deposit")
    end
    if carried > halloween.CarriedBefore then
        if halloween.FirstPickAt == 0 then halloween.FirstPickAt = os.clock() end
        halloween.Stats.candy += carried - halloween.CarriedBefore
        halloween.NextCollectAt = halloween.LastCollectAt + Config.CandyCooldown
        halloween.CandyStateAt = 0
        return Theseus.Halloween.BeginDeposit()
    end

    if halloween.FirstPickAt > 0 and carried > 0 and os.clock() - halloween.FirstPickAt >= Config.CandySpoilAt then
        return Theseus.Halloween.BeginDeposit()
    end

    if os.clock() - halloween.PhaseAt > Config.CandyCollectTimeout then
        halloween.SkipUntil[target.id] = os.clock() + Config.CandySkipSec
        halloween.CandyStateAt = 0
        return Theseus.Halloween.Reset("Candy did not answer")
    end
end

function Theseus.Halloween.StepDeposit()
    local halloween = Theseus.Halloween

    if Theseus.Halloween.Carried() == 0 then
        local banked = Theseus.Halloween.Tokens() - halloween.DepositBankBefore
        if banked <= 0 then
            if os.clock() - halloween.PhaseAt < Config.CandyDepositTimeout then return end
            halloween.Spoiled += 1
            halloween.FirstPickAt = 0
            return Theseus.Halloween.Reset("Candy cleared without a confirmed deposit")
        end
        halloween.TokensEarned += banked
        halloween.Cycles += 1
        halloween.FirstPickAt = 0
        halloween.DepositDoneAt = os.clock()
        if halloween.ManualCandy then halloween.ManualCandy = false end
        return Theseus.Halloween.Reset("Cashed in " .. banked)
    end

    if os.clock() - halloween.PhaseAt <= Config.CandyDepositTimeout then return end
    if not halloween.DepositRetried then
        halloween.DepositRetried = true
        if Theseus.Halloween.Claim() and Theseus.Tasks.Teleport(halloween.Token, Theseus.Halloween.PadCF()) then
            return Theseus.Halloween.SetPhase("Deposit")
        end
    end
    Theseus.Halloween.Reset("Could not reach the candy pad")
end

function Theseus.Halloween.StepIdle()
    local halloween = Theseus.Halloween
    local opt = Theseus.Util.Opt
    local carried = Theseus.Halloween.Carried()

    local spoiling = carried > 0 and halloween.FirstPickAt > 0 and os.clock() - halloween.FirstPickAt >= Config.CandySpoilAt
    if carried > 0 and (carried >= Config.CandyCarryGoal or spoiling) then
        return Theseus.Halloween.BeginDeposit()
    end

    local fullCandy = opt("AutoCandy") == true or halloween.ManualCandy
    local dropsOnly = not fullCandy and (opt("AutoTrickOrTreat") == true or opt("AutoPumpkin") == true or halloween.ManualPass ~= nil)
    if fullCandy or dropsOnly then
        if os.clock() + Config.CandyPrepAhead >= halloween.NextCollectAt then
            if not Theseus.Halloween.Claim() then return end
            if Theseus.Util.Opt("CandyAutoMount") ~= false then Theseus.Mount.Ensure(halloween.Token) end
        end
        local candy = Theseus.Halloween.NextCandy(dropsOnly)
        if candy then
            return Theseus.Halloween.BeginTarget("candy", candy.id,
                candy.cf, candy)
        end
        if carried > 0 then
            local waitLeft = Theseus.Halloween.NextRespawnIn()
            local spoilLeft = halloween.FirstPickAt > 0 and Config.CandySpoilAt - (os.clock() - halloween.FirstPickAt) or Config.CandySpoilAt
            if not (waitLeft and waitLeft < spoilLeft - 2) then
                return Theseus.Halloween.BeginDeposit()
            end
        end
        if halloween.ManualCandy then
            if carried == 0 then
                halloween.ManualCandy = false
            else
                return Theseus.Halloween.BeginDeposit()
            end
        end
    end

    if opt("AutoTrickOrTreat") == true or halloween.ManualPass == "doors" then
        local door = Theseus.Halloween.NextDoor()
        if door then return Theseus.Halloween.BeginTarget("door", door.id, door.cf) end
    end

    if opt("AutoPumpkin") == true or halloween.ManualPass == "pumpkins" then
        local pumpkin = Theseus.Halloween.NextPumpkin()
        if pumpkin then
            return Theseus.Halloween.BeginTarget("pumpkin", pumpkin.id,
                CFrame.new(pumpkin.pos + Vector3.new(0, Config.StandLift, 0)))
        end
    end

    if opt("AutoRitual") == true then
        local altar = Theseus.Halloween.RitualReady()
        if altar then return Theseus.Halloween.BeginTarget("ritual", "ritual", altar) end
    end

    if halloween.ManualPass then halloween.ManualPass = nil end
    Theseus.Halloween.Release()
    local cooldownLeft = halloween.NextCollectAt - os.clock()
    if cooldownLeft > 0 then
        return Theseus.Halloween.SetPhase("Idle", string.format("Pickup cooldown %.0fs", cooldownLeft))
    end
    Theseus.Halloween.SetPhase("Idle", "Waiting for candy to respawn")
end

function Theseus.Halloween.StepZone()
    local halloween = Theseus.Halloween
    local now = os.clock()
    if now < halloween.ZoneRetryAt then return end

    halloween.ZoneTries += 1
    if halloween.ZoneTries > Config.HalloweenZoneTries then
        return Theseus.Halloween.LeaveZone()
    end

    halloween.ZoneRetryAt = now + Config.HalloweenZoneGap
    halloween.Target = { kind = "portal", cf = Theseus.Halloween.PortalCF() }
    Theseus.Halloween.SetPhase("Travel")
end

function Theseus.Halloween.LeaveZone()
    Theseus.Halloween.StopMovement("Left the event island, event farming stopped")
end

function Theseus.Halloween.StopMovement(note)
    local halloween = Theseus.Halloween
    halloween.ManualCandy, halloween.ManualPass, halloween.ManualUntil = false, nil, nil
    Theseus.Halloween.Reset(note)

    for _, idx in ipairs({ "AutoCandy", "AutoTrickOrTreat", "AutoPumpkin", "AutoRitual" }) do
        table.insert(State.PendingToggleOff, idx)
    end
    table.insert(State.PendingNotify, { "Halloween", note })
end

function Theseus.Halloween.RecoverMovement()
    local halloween = Theseus.Halloween
    local percent = Theseus.Halloween.ReturnFactor() * 100
    halloween.ReturnCapPercent = math.max(100, math.min(200, percent * 0.75))
    halloween.ReturnHopDisabled = true
    halloween.FlagsBaseline = Theseus.Player:Flags()
    halloween.RecoveryUntil = os.clock() + (Theseus.Halloween.Carried() > 0 and 0.15 or 1)
    halloween.CandyStateAt = 0
    Theseus.Halloween.Reset("Retrying at " .. math.floor(halloween.ReturnCapPercent) .. "%")
    if Theseus.Halloween.Carried() > 0 then Theseus.Halloween.BeginDeposit() end
end

---@return number|nil  egg token price read from the game data, nil when not found
function Theseus.Halloween.KnownPrice()
    local halloween = Theseus.Halloween
    if halloween.PriceSeen then return halloween.PriceSeen end
    local lib = Theseus.Halloween.CandyLib()
    local eggs = lib and lib.Eggs
    local egg = eggs and eggs["Halloween Egg"]
    halloween.PriceFound = egg and tonumber(egg.Price) or nil
    return halloween.PriceFound
end

---@return Instance|nil, Vector3|nil  a real shop anchor from the game's own tags
function Theseus.Halloween.ShopAnchor()
    for _, tag in ipairs({ "HalloweenShopGuy", "HalloweenShopPrompt" }) do
        for _, inst in ipairs(CollectionService:GetTagged(tag)) do
            local pos = Theseus.Halloween.PointOf(inst)
            if pos then return inst, pos end
        end
    end
    return nil, nil
end

function Theseus.Halloween.BuyBlocked(reason)
    Theseus.Halloween.BuyOnce, Theseus.Halloween.BuyTravel = false, false
    State.Status.HalloweenEgg = reason
end

---@return boolean  enough unreserved tokens, a known price and an active event
function Theseus.Halloween.CanBuy()
    local price = Theseus.Halloween.KnownPrice()
    if not price or price <= 0 then
        Theseus.Halloween.BuyBlocked("Egg price is unavailable")
        return false
    end
    local keep = math.max(0, tonumber(Theseus.Util.Opt("HalloweenKeepTokens")) or 0)
    local tokens = Theseus.Halloween.Tokens()
    if tokens < price + keep then
        Theseus.Halloween.BuyBlocked("Saving " .. Theseus.Util.Format(tokens) .. " / " .. Theseus.Util.Format(price + keep) .. " tokens")
        return false
    end
    local event = GameLib.Svc and GameLib.Svc.HalloweenEvent
    if event and type(event.IsLive) == "function" then
        local ok, live = GameLib.Call(event.IsLive)
        if not ok or live ~= true then
            Theseus.Halloween.BuyBlocked("Halloween egg shop is closed")
            return false
        end
    end
    local limit = tonumber(Theseus.Util.Opt("HalloweenBuyLimit")) or 0
    if not Theseus.Halloween.BuyOnce and limit > 0 and Theseus.Halloween.EggsBought >= limit then
        Theseus.Halloween.BuyBlocked("Egg purchase limit reached")
        return false
    end
    return true
end

function Theseus.Halloween.BuyStep()
    local halloween = Theseus.Halloween
    local opt = Theseus.Util.Opt
    if not (opt("AutoHalloweenEgg") == true or halloween.BuyOnce) then return end
    if halloween.Purchase or halloween.Phase ~= "Idle" or Theseus.Tasks.Carrying() then return end
    if os.clock() - halloween.LastBuyAt < Config.HalloweenEggGap then return end

    local remote = Theseus.Net.BuyHalloweenEgg
    if not remote then
        State.Status.HalloweenEgg = "Egg shop is unavailable"
        return
    end

    if not Theseus.Halloween.CanBuy() then return end
    halloween.BuyTravel = true
    if Theseus.Halloween.InZone() ~= true then return end
    local inst, pos = Theseus.Halloween.ShopAnchor()
    if not pos or not Theseus.Halloween.Claim() then return end
    local hrp = Theseus.Player.Root
    halloween.ShopHome = { hrp.CFrame, Theseus.Player.Epoch }
    State.Status.HalloweenEgg = "Going to the egg shop"
    local cf = Theseus.Halloween.PickupCF(pos, inst)
    Theseus.Halloween.BeginTarget("shop", nil, cf, { instance = inst, pos = pos })
end

function Theseus.Halloween.BuyAtShop()
    local halloween = Theseus.Halloween
    if not Theseus.Halloween.CanBuy() then return Theseus.Halloween.FinishShop() end
    local target = halloween.Target
    local hrp = Theseus.Player.Root
    if not target or not target.source or not hrp then return Theseus.Halloween.FinishShop("Could not reach the egg shop") end
    local distance = Theseus.Util.Flat(hrp.Position, target.source.pos)
    if distance > Config.HalloweenShopRange then
        target.cf = CFrame.new(target.source.pos + Vector3.new(0, Theseus.Halloween.StandLift(), 0))
        return Theseus.Halloween.SetPhase("Travel")
    end
    local before = {}
    for _, row in ipairs(Theseus.Hatch.EggTools()) do before[row[1]] = true end
    local tokens = Theseus.Halloween.Tokens()
    local price = Theseus.Halloween.KnownPrice()
    local remote = Theseus.Net.BuyHalloweenEgg
    halloween.LastBuyAt = os.clock()
    local ok, bought = GameLib.Call(remote.InvokeServer, remote, "Halloween Egg")
    halloween.BuyOnce = false
    if not ok or bought ~= true then
        halloween.LastBuyAt = os.clock() + Config.HalloweenShopRetry
        return Theseus.Halloween.FinishShop(ok and "Egg shop refused the purchase; retrying later" or "Egg shop did not answer")
    end
    halloween.Purchase = { before = before, tokens = tokens, price = price, at = os.clock(), epoch = Theseus.Player.Epoch }
    State.Status.HalloweenEgg = "Confirming the egg purchase"
    Theseus.Halloween.SetPhase("Purchase")
end

function Theseus.Halloween.StepPurchase()
    local halloween = Theseus.Halloween
    local purchase = halloween.Purchase
    if not purchase then return Theseus.Halloween.FinishShop() end
    local tool
    for _, row in ipairs(Theseus.Hatch.EggTools()) do
        if row[2] == "Halloween Egg" and not purchase.before[row[1]] then tool = row[1]; break end
    end
    local spent = purchase.tokens - Theseus.Halloween.Tokens()
    if spent < purchase.price or not tool then
        if os.clock() - purchase.at < Config.HalloweenPurchaseTimeout then return end
        return Theseus.Halloween.FinishShop("Purchase not confirmed; check the egg inventory")
    end
    halloween.EggsBought += 1
    local note = "Bought " .. halloween.EggsBought .. " eggs"
    if Theseus.Util.Opt("HalloweenAutoHatch") ~= false and purchase.epoch == Theseus.Player.Epoch and Theseus.Halloween.Claim() then
        halloween.Token.critical = true
        local key = Theseus.Hatch.PlantTool(halloween.Token, tool)
        if key then
            Theseus.Hatch.Purchased[key] = true
            local hatched = Theseus.Tasks.Await(halloween.Token, function()
                if Theseus.Hatch.Confirmed[key] then return true end
                local egg = State.PlotEggs[key]
                local left = egg and Theseus.Hatch.Left(egg)
                if left and left <= 0 then Theseus.Hatch.HatchNow(key) end
                return false
            end, Config.HalloweenPurchaseTimeout)
            note = hatched and "Bought and hatched the Halloween egg" or "Egg placed; waiting to hatch"
        else
            note = "Bought egg; no free plot space, kept in inventory"
        end
    end
    Theseus.Halloween.FinishShop(note)
end

function Theseus.Halloween.FinishShop(note)
    local halloween = Theseus.Halloween
    local home, token = halloween.ShopHome, halloween.Token
    if home and token and home[2] == Theseus.Player.Epoch and not Theseus.Tasks.Carrying() then
        Theseus.Tasks.Teleport(token, home[1])
    end
    halloween.ShopHome, halloween.Purchase, halloween.BuyTravel = nil, nil, false
    if note then State.Status.HalloweenEgg = note end
    Theseus.Halloween.Reset()
end

function Theseus.Halloween.StepOnce()
    local halloween = Theseus.Halloween
    Theseus.Halloween.Bind()
    if halloween.FlagsBaseline and Theseus.Player:Flags() > halloween.FlagsBaseline then
        return Theseus.Halloween.RecoverMovement()
    end
    if os.clock() < (halloween.RecoveryUntil or 0) then return end
    if not Theseus.Player:IsAlive() then return Theseus.Halloween.Reset("Waiting for respawn") end
    if halloween.Finishing and halloween.Phase == "Idle" and Theseus.Halloween.Carried() == 0 then
        return Theseus.Halloween.Stop()
    end
    if halloween.Token and not Theseus.Tasks.Holds(halloween.Token) then
        return Theseus.Halloween.Reset("Waiting for a turn")
    end

    Theseus.Halloween.BuyStep()

    if halloween.ManualUntil and os.clock() > halloween.ManualUntil then
        halloween.ManualCandy, halloween.ManualPass, halloween.ManualUntil = false, nil, nil
    end
    if not Theseus.Halloween.WantsMove() then
        if halloween.Phase ~= "Idle" then Theseus.Halloween.Reset() end
        return
    end

    if halloween.Phase ~= "Idle" and os.clock() - halloween.PhaseAt > Config.HalloweenPhaseBudget then
        Theseus.Halloween.Reset("Restarting")
    end

    local phase = halloween.Phase
    if phase == "Purchase" then return Theseus.Halloween.StepPurchase() end
    if phase == "Travel" then return Theseus.Halloween.StepTravel() end
    if phase == "Settle" then return Theseus.Halloween.StepSettle() end
    if phase == "Collect" then return Theseus.Halloween.StepCollect() end
    if phase == "Deposit" then return Theseus.Halloween.StepDeposit() end

    if Theseus.Halloween.InZone() ~= true then return Theseus.Halloween.StepZone() end
    halloween.ZoneTries = 0
    return Theseus.Halloween.StepIdle()
end

function Theseus.Halloween.Step()
    local halloween = Theseus.Halloween
    if halloween.Busy then return end
    halloween.Busy = true
    local ok, err = pcall(Theseus.Halloween.StepOnce)
    halloween.Busy = false
    if not ok then
        Theseus.Halloween.Reset("Restarting after an error")
        error(err, 0)
    end
end

function Theseus.Halloween.OnCarried(value)
    local halloween = Theseus.Halloween
    if value > 0 and halloween.CarriedWas == 0 then
        halloween.FirstPickAt = os.clock()
    elseif value == 0 and halloween.CarriedWas > 0 and not (halloween.Target and halloween.Target.kind == "deposit") then
        if os.clock() - (halloween.DepositDoneAt or 0) > 2 then
            halloween.FirstPickAt = 0
            halloween.Spoiled += 1
        end
    end
    halloween.CarriedWas = value
    Theseus.Halloween.UpdateStatus()
end

function Theseus.Halloween.Bind()
    local halloween = Theseus.Halloween
    if halloween.Bound or halloween.AwaitCarried then return end
    local noSave = LocalPlayer:FindFirstChild("NoSaveData")
    if not noSave then return end

    local carried = noSave:FindFirstChild("CarriedCandy")
    if not carried then
        halloween.AwaitCarried = true
        table.insert(halloween.Conns, noSave.ChildAdded:Connect(function(child)
            if child.Name == "CarriedCandy" then
                halloween.Bound, halloween.AwaitCarried = false, false
            end
        end))
        return
    end

    halloween.Bound = true
    halloween.CarriedWas = tonumber(carried.Value) or 0
    table.insert(halloween.Conns, carried.Changed:Connect(Theseus.Halloween.OnCarried))

    local reply = GameLib.Remote("DoorKnocked")
    if reply then
        table.insert(halloween.Conns, reply.OnClientEvent:Connect(function(id, isTreat, amount)
            if isTreat then
                halloween.Stats.treats += 1
                table.insert(State.PendingNotify, { "Trick-or-Treat", "Treat: " .. tostring(amount) .. " candy dropped" })
            end
        end))
    end

    local ritual = Workspace:FindFirstChild("HeadlessRitual")
    if ritual then
        table.insert(halloween.Conns, ritual:GetAttributeChangedSignal("Phase"):Connect(function()
            if ritual:GetAttribute("Phase") ~= "Open" then halloween.RitualSeenOpen = false end
        end))
    end
end

function Theseus.Halloween.CandyNow()
    Theseus.Halloween.Start()
    Theseus.Halloween.ManualCandy = true
    Theseus.Halloween.ManualUntil = os.clock() + Config.HalloweenManualTimeout
end

function Theseus.Halloween.KnockNow()
    Theseus.Halloween.Start()
    Theseus.Halloween.ManualPass = "doors"
    Theseus.Halloween.ManualUntil = os.clock() + Config.HalloweenManualTimeout
end

function Theseus.Halloween.SearchNow()
    Theseus.Halloween.Start()
    Theseus.Halloween.ManualPass = "pumpkins"
    Theseus.Halloween.ManualUntil = os.clock() + Config.HalloweenManualTimeout
end

function Theseus.Halloween.BuyNow()
    Theseus.Halloween.Start()
    Theseus.Halloween.BuyOnce = true
end

function Theseus.Halloween.ExitNow()
    local halloween = Theseus.Halloween
    halloween.ManualCandy, halloween.ManualPass, halloween.ManualUntil, halloween.BuyOnce = false, nil, nil, false
    Theseus.Halloween.Reset("Stopped")
end

---@return string, Color3  short label and colour for a candy spawn id
function Theseus.Halloween.TierOf(id)
    if id:sub(1, 9) == "DoorCandy" then return "Door Candy", Config.RarityColors.Legendary end
    if id:sub(1, 11) == "PumpkinDrop" then return "Pumpkin Drop", Config.RarityColors.Legendary end
    local tier = id:match("^Candy(%d)_")
    if tier == "1" then return "Candy", Config.RarityColors.Common end
    if tier == "2" then return "Rare Candy", Config.RarityColors.Rare end
    if tier == "3" then return "Epic Candy", Config.RarityColors.Epic end
    return "Candy", Color3.new(1, 1, 1)
end

function Theseus.Halloween.EspStep()
    if not State.Alive or not Theseus.Util.Opt("HalloweenEsp") then return end
    Theseus.Halloween.Bind()

    local halloween = Theseus.Halloween
    local esp = Theseus.Esp
    local hrp = Theseus.Player.Root
    local range = Theseus.Platform.Mobile and Config.EspRangeMobile or Config.EspRange
    local kinds = Theseus.Util.Opt("HalloweenEspTypes")
    if type(kinds) ~= "table" or not next(kinds) then
        kinds = { Candy = true, Doors = true, Pumpkins = true, Altar = true }
    end

    local seen = {}
    local function Show(key, pos, text, color)
        local dist = hrp and (pos - hrp.Position).Magnitude or 0
        if dist > range then return end
        seen[key] = true

        local slot = halloween.Boards[key]
        if not slot or not slot.board.Parent then
            slot = esp.Take()
            halloween.Boards[key] = slot
        end
        slot.anchor.WorldPosition = pos
        slot.board.MaxDistance = range
        slot.board.Enabled = true
        slot.label.TextColor3 = color
        slot.label.Text = type(text) == "function" and text(math.floor(dist)) or text
    end

    if kinds.Candy then
        local states = Theseus.Halloween.SpawnState()
        for _, inst in ipairs(CollectionService:GetTagged("HalloweenCandySpawn")) do
            local id = inst:GetAttribute("Id") or inst.Name
            local pos = Theseus.Halloween.PointOf(inst)
            if id and pos and not Theseus.Halloween.Respawning(inst, states[id]) then
                local label, color = Theseus.Halloween.TierOf(id)
                local amount = states[id] and states[id].amount
                Show("candy:" .. id, pos, function(dist)
                    return string.format("%s%s | %dm", label, amount and (" " .. amount) or "", dist)
                end, color)
            end
        end
    end

    if kinds.Doors then
        for _, house in ipairs(Theseus.Halloween.Houses()) do
            if not house:IsA("Model") then continue end
            local pivot = house:GetPivot()
            local id = Theseus.Halloween.DoorId(house, pivot)
            local lit = Theseus.Halloween.DoorLit(id)
            Show("door:" .. id, pivot.Position,
                lit == true and "Door Lit" or lit == false and "Door Dark" or "Door",
                lit == true and Color3.fromRGB(120, 255, 120) or Color3.fromRGB(170, 170, 170))
        end
    end

    if kinds.Pumpkins then
        for _, inst in ipairs(CollectionService:GetTagged("PumpkinPrompt")) do
            local pos = Theseus.Halloween.PointOf(inst)
            if pos then Show("pumpkin:" .. tostring(inst), pos, "Pumpkin", Color3.fromRGB(255, 140, 40)) end
        end
    end

    if kinds.Altar then
        local info = Theseus.Halloween.RitualInfo()
        if info then
            Show("altar", info.model:GetPivot().Position,
                "Ritual Altar" .. (info.phase and (" (" .. tostring(info.phase) .. ")") or ""),
                Color3.fromRGB(190, 80, 255))
        end
        Show("pad", Theseus.Halloween.PadPos(), "Candy Pad", Config.RarityColors.Legendary)
    end

    for key in pairs(halloween.Boards) do
        if not seen[key] then esp.Disown(halloween.Boards, key) end
    end
end

function Theseus.Halloween.ClearEsp()
    local halloween = Theseus.Halloween
    for key in pairs(halloween.Boards) do
        Theseus.Esp.Disown(halloween.Boards, key)
    end
end

---@return table<string, function>  label -> CFrame getter for the teleport tab
function Theseus.Halloween.Places()
    local places = {}
    if not Theseus.Halloween.EventLive() then return places end

    places["Event: Candy Pad"] = function()
        return CFrame.new(Theseus.Halloween.PadPos() + Vector3.new(0, Config.CandyPadLift, 0))
    end
    places["Event: Portal"] = Theseus.Halloween.PortalCF

    for index, house in ipairs(Theseus.Halloween.Houses()) do
        if house:IsA("Model") then
            local pivot = house:GetPivot()
            places["Event: House " .. index] = function()
                return CFrame.new(pivot.Position + Vector3.new(Config.DoorStand, Config.StandLift, Config.DoorStand))
            end
        end
    end

    local ritual = Workspace:FindFirstChild("HeadlessRitual")
    if ritual then
        places["Event: Ritual Altar"] = function()
            local pivot = ritual:GetPivot()
            return CFrame.new(pivot.Position + Vector3.new(0, Config.StandLift, 0))
        end
    end
    return places
end

function Theseus.Halloween.Start()
    local halloween = Theseus.Halloween
    halloween.Finishing = false
    if halloween.Enabled then return end
    halloween.FlagsBaseline = Theseus.Player:Flags()
    halloween.Enabled = true
    halloween.ZoneTries = 0
    halloween.ZoneRetryAt = 0
    if halloween.StartedAt == 0 then halloween.StartedAt = os.clock() end
    Theseus.Halloween.Bind()
    Theseus.Halloween.SetPhase("Idle")
end

function Theseus.Halloween.Stop()
    local halloween = Theseus.Halloween
    halloween.Enabled = false
    halloween.ManualCandy, halloween.ManualPass, halloween.ManualUntil, halloween.BuyOnce = false, nil, nil, false
    if State.Alive and not State.Unloading and halloween.Purchase then return end
    halloween.Purchase, halloween.BuyTravel, halloween.ShopHome = nil, false, nil
    if State.Alive and not State.Unloading and Theseus.Halloween.Carried() > 0 then
        halloween.Finishing = true
        if not (halloween.Target and halloween.Target.kind == "deposit") then Theseus.Halloween.BeginDeposit() end
        return
    end
    halloween.Finishing = false
    Theseus.Halloween.Reset("Off")

    for _, conn in ipairs(halloween.Conns) do
        conn:Disconnect()
    end
    table.clear(halloween.Conns)
    halloween.Bound = false
    halloween.AwaitCarried = false
end

Theseus.Delivery = {}

---@return "Plot"|"Direct"|"Drop", number  mode, trip studs
function Theseus.Delivery.Mode(entry)
    local _, bp = Theseus.Player:Plot()
    if not bp or not entry or not entry.pos then return "Drop", math.huge end

    local inside = Theseus.Geo.EdgeInside(bp, entry.pos)
    if (inside - entry.pos).Magnitude <= Theseus.Config.PickupReach then return "Plot", 0 end

    local trip = Theseus.Geo.Trip(bp, Theseus.Geo.StandPoint(bp, entry.pos))
    local opts = Theseus.Options
    if opts and opts.DeliveryMode == "Safe" then return "Drop", trip end

    if Theseus.Delivery.Fits(trip, entry.weight, entry.egg) then return "Direct", trip end
    return "Drop", trip
end

---@return number  carry speed left after the egg weight slowdown
function Theseus.Delivery.WeightFactor(weight, eggName)
    local cfg = Theseus.Config
    local over = math.max(0, (tonumber(weight) or 1) - 1)
    local per = eggName == "Cherub" and cfg.CherubWeightPenalty or cfg.WeightPenalty
    return 1 - math.min(cfg.WeightPenaltyMax, over * 10 * per)
end

---@param weight number|nil  carried egg weight, nil = light
---@return boolean           straight trip home passes with the pet ridden right now
function Theseus.Delivery.Fits(trip, weight, eggName)
    local factor = Theseus.Delivery.WeightFactor(weight, eggName)
    local speed = Theseus.Mount.Speed()
    if speed > 0 then return trip <= Theseus.State.Tune.DirectFactor * speed * factor end
    return trip <= Theseus.Config.UnmountedDirect * factor
end

---@return boolean  true when the full time passed
function Theseus.Delivery.Sleep(token, sec)
    if sec <= 0 then return true end
    local _, why = Theseus.Tasks.Await(token, nil, sec)
    return why == "timeout"
end

---@return boolean, string
function Theseus.Delivery.Pickup(token, guid, standPos)
    local cfg = Theseus.Config
    local remote = Theseus.GameLib.Remote("EggPickup")
    local hrp = Theseus.Player.Root
    if not remote or not hrp then return false, "missing" end
    local flags = Theseus.Player:Flags()

    if (hrp.Position - standPos).Magnitude > 1 then
        if not Theseus.Tasks.Teleport(token, CFrame.new(standPos)) then return false, "aborted" end
        if not Theseus.Delivery.Sleep(token, cfg.TpSettle) then return false, "aborted" end
    end

    local deadline = os.clock() + cfg.PickupTotalTimeout
    local retried = false
    repeat
        if not Theseus.Tasks.Holds(token) or Theseus.Guard.Tripped or Theseus.Player:Flags() > flags then return false, "aborted" end
        Theseus.EggIndex.Expect(guid)
        remote:FireServer(guid)
        local kind, text = Theseus.EggIndex.WaitReply(guid, cfg.PickupReplyTimeout)

        if kind == "PickedUp" then return true, "ok" end
        if Theseus.Player:BasketCount() > 0 then return true, "ok" end
        if kind == "BasketFull" then return false, "full" end
        if kind == "Gone" then
            Theseus.EggIndex.MarkGone(guid)
            return false, "gone"
        end
        if kind == "Refused" then
            local distanceLag = tostring(text or ""):find("studs", 1, true) ~= nil
            if retried or not distanceLag or Theseus.Player:Flags() > flags then return false, "refused" end
            retried = true
            if not Theseus.Delivery.Sleep(token, cfg.PickupAckWait) then return false, "aborted" end
        end
    until os.clock() >= deadline
    return false, "timeout"
end

---@return boolean  only true on the server's Deposited reply
function Theseus.Delivery.AwaitDeposit(token, timeout)
    local kind = Theseus.EggIndex.WaitReply("*carry", timeout)
    return kind == "Deposited" and not Theseus.Guard.Tripped
end

function Theseus.Delivery.StepHome(token, bp)
    local hrp = Theseus.Player.Root
    if not hrp then return false end
    Theseus.EggIndex.Expect("*carry")
    return Theseus.Tasks.Teleport(token, CFrame.new(Theseus.Geo.EdgeInside(bp, hrp.Position)))
end

---@return table|nil  newest dropped entry for the carried egg
---@param before table  guids that existed before our drop
function Theseus.Delivery.FindDrop(eggName, origin, since, before)
    local hrp = Theseus.Player.Root
    local here = hrp and hrp.Position
    local byOrigin, nearest, nearestDist = nil, nil, math.huge

    for _, entry in pairs(Theseus.EggIndex.Entries) do
        if not entry.dropEndsAt or entry.dropEndsAt < since then continue end
        if before[entry.guid or ""] then continue end
        if origin and entry.origin and Theseus.Util.Flat(entry.origin, origin) < 1 then
            byOrigin = entry
            break
        end
        if entry.egg == eggName and here then
            local dist = Theseus.Util.Flat(entry.pos, here)
            if dist < nearestDist then nearest, nearestDist = entry, dist end
        end
    end
    return byOrigin or nearest
end

---@return table|nil
function Theseus.Delivery.Drop(token, eggName, origin)
    local cfg = Theseus.Config
    local remote = Theseus.GameLib.Remote("BasketDrop")
    if not remote then return nil end

    local before = {}
    for _, entry in pairs(Theseus.EggIndex.Entries) do
        if entry.guid then before[entry.guid] = true end
    end
    local since = Theseus.Util.ServerNow() - 0.5
    remote:FireServer()

    local drop
    Theseus.Tasks.Await(token, function()
        drop = Theseus.Delivery.FindDrop(eggName, origin, since, before)
        return drop ~= nil
    end, cfg.DropAppearTimeout)
    return drop
end

function Theseus.Delivery.WaitLanded(token, drop)
    local landAt = drop.dropEndsAt + Theseus.Config.DropEndsSlack
    local remaining = landAt - Theseus.Util.ServerNow()
    if remaining ~= remaining or remaining > Theseus.Config.DropLandMax then return false end
    local timeout = math.max(Theseus.Config.DropAppearTimeout, remaining + 0.5)
    local ok = Theseus.Tasks.Await(token, function() return Theseus.Util.ServerNow() >= landAt end, timeout)
    return ok
end

function Theseus.Delivery.RaiseSettle()
    local tune = Theseus.State.Tune
    tune.DropSettle = math.min(tune.DropSettle + 0.05, Theseus.Config.DropSettleMax)
    Theseus.State.Stats.staleDrops += 1
end

function Theseus.Delivery.LowerSettle()
    local tune = Theseus.State.Tune
    local floor = math.max(Theseus.Config.DropSettle, tonumber(Theseus.Util.Opt("DropSettle")) or 0)
    tune.DropSettle = math.max(floor, tune.DropSettle - 0.01)
end

---@return number|nil  replicated break timer for the carried egg
function Theseus.Delivery.BreakLeft()
    local left
    for _, egg in ipairs(Theseus.Player:BasketItems()) do
        if egg:GetAttribute("Delivering") then continue end
        local at = tonumber(egg:GetAttribute("BreakAt"))
        if at then left = math.min(left or math.huge, at - Theseus.Util.ServerNow()) end
    end
    return left
end

---@return boolean  one bounded hop followed by movement at the actual ride speed
function Theseus.Delivery.TravelCarry(token, cf, eggName)
    local cfg = Theseus.Config
    local root, speed = Theseus.Player.Root, Theseus.Mount.TravelSpeed()
    if not root or speed <= 0 or Theseus.Player:BasketCount() == 0 then return false end
    if not token.returnHop then
        token.returnHop = true
        local delta = cf.Position - root.Position
        local hopLimit = math.min(cfg.ReturnHopMax, math.max(Theseus.Mount.Speed(), cfg.UnmountedPlayerSpeed) * State.Tune.DirectFactor)
        local hop = math.min(hopLimit, math.max(0, delta.Magnitude - cfg.TravelStopDistance))
        if hop > 0 then
            if not Theseus.Tasks.Teleport(token, CFrame.new(root.Position + delta.Unit * hop) * root.CFrame.Rotation) then return false end
            if not Theseus.Delivery.Sleep(token, cfg.TpSettle) then return false end
        end
    end
    local timeout = (cf.Position - root.Position).Magnitude / speed + cfg.RunBudget
    token.budget = math.max(token.budget or 0, os.clock() + timeout)
    local expired = false
    local reached = Theseus.Tasks.Travel(token, cf, Theseus.Mount.TravelSpeed, timeout, {
        noClip = true, reach = cfg.TravelStopDistance,
        done = function()
            local left = Theseus.Delivery.BreakLeft()
            expired = left ~= nil and left <= 0
            return expired or Theseus.Player:BasketCount() == 0
        end,
    })
    return reached and not expired and Theseus.Player:BasketCount() > 0
end

---@return "Deposited"|"Gone"|"Refused"|"Aborted"
function Theseus.Delivery.DropCycle(token, bp, eggName, origin)
    local cfg = Theseus.Config

    for _ = 0, 2 do
        local hrp = Theseus.Player.Root
        if not hrp or os.clock() > token.budget then return "Aborted" end

        local out = Theseus.Geo.Outside(bp, hrp.Position, cfg.DropOutside)
        if not Theseus.Delivery.Fits(Theseus.Geo.Trip(bp, hrp.Position), nil, eggName) then
            if not Theseus.Delivery.TravelCarry(token, CFrame.new(out), eggName) then return "Aborted" end
        elseif not Theseus.Tasks.Teleport(token, CFrame.new(out)) then
            return "Aborted"
        end
        if not Theseus.Delivery.Sleep(token, Theseus.State.Tune.DropSettle) then return "Aborted" end

        local drop = Theseus.Delivery.Drop(token, eggName, origin)
        if not drop then return Theseus.Player:BasketCount() == 0 and "Gone" or "Aborted" end
        origin = drop.origin or origin

        local fresh = Theseus.Util.Flat(drop.pos, out) <= cfg.StaleDropDistance
        local stand = fresh and out or drop.pos + Vector3.new(0, Theseus.Geo.Lift(), 0)
        if fresh then Theseus.Delivery.LowerSettle() end
        if not fresh then
            Theseus.Delivery.RaiseSettle()
            if not Theseus.Tasks.Teleport(token, CFrame.new(stand)) then return "Aborted" end
        end
        if not Theseus.Delivery.WaitLanded(token, drop) then return "Aborted" end

        local got, why = Theseus.Delivery.Pickup(token, drop.guid, stand)
        if not got then return why == "gone" and "Gone" or "Aborted" end

        if fresh or Theseus.Delivery.Fits(Theseus.Geo.Trip(bp, stand), drop.weight, eggName) then
            if not Theseus.Delivery.StepHome(token, bp) then return "Aborted" end
            return Theseus.Delivery.AwaitDeposit(token, cfg.DepositTimeout) and "Deposited" or "Aborted"
        end
    end
    return "Aborted"
end

---@return "Deposited"|"Aborted"
function Theseus.Delivery.DirectHome(token, bp)
    local cfg = Theseus.Config
    if not Theseus.Delivery.StepHome(token, bp) then return "Aborted" end
    if Theseus.Delivery.AwaitDeposit(token, cfg.DepositTimeout) then return "Deposited" end
    if Theseus.Player:BasketCount() > 0 and Theseus.Player:Flags() <= token.flags0 then
        if Theseus.Delivery.AwaitDeposit(token, cfg.DepositTimeout) then return "Deposited" end
    end
    return "Aborted"
end

---@return "Deposited"|"Gone"|"Refused"|"Aborted", number  outcome, seconds
function Theseus.Delivery.Run(token, entry)
    local _, bp = Theseus.Player:Plot()
    if not bp or not entry then return "Aborted", 0 end

    local t0 = os.clock()
    token.flags0 = Theseus.Player:Flags()
    token.budget = t0 + Theseus.Config.RunBudget

    local mode, trip = Theseus.Delivery.Mode(entry)
    Theseus.Delivery.LastPlan = { mode = mode, trip = math.floor(trip), speed = Theseus.Mount.Speed(), settle = Theseus.State.Tune.DirectFactor }
    local stand = mode == "Plot" and Theseus.Geo.EdgeInside(bp, entry.pos) or Theseus.Geo.StandPoint(bp, entry.pos)

    Theseus.EggIndex.Expect("*carry")
    local got, why = Theseus.Delivery.Pickup(token, entry.guid, stand)
    if not got then
        if why == "full" then Theseus.Delivery.Recover(token) end
        return why == "gone" and "Gone" or (why == "refused" and "Refused" or "Aborted"), os.clock() - t0
    end

    Theseus.Eggs.CarryCritical = true
    local outcome
    if mode == "Plot" then
        outcome = Theseus.Delivery.AwaitDeposit(token, Theseus.Config.DepositTimeout) and "Deposited" or "Aborted"
    elseif mode == "Direct" then
        outcome = Theseus.Delivery.DirectHome(token, bp)
    else
        outcome = Theseus.Delivery.DropCycle(token, bp, entry.egg, entry.origin or entry.pos)
    end

    if outcome ~= "Deposited" and Theseus.Player:BasketCount() > 0 then Theseus.Delivery.Recover(token) end
    Theseus.Eggs.CarryCritical = false
    Theseus.Guard.Check(token.flags0)

    local seconds = os.clock() - t0
    local stats = Theseus.State.Stats
    if outcome == "Deposited" then
        local key = string.lower(mode)
        stats[key] = (stats[key] or 0) + 1
    end
    stats.lastRun, stats.lastMode = seconds, mode
    return outcome, seconds
end

---@return string|nil, string|nil  egg name, "Delivering"|"Carry"|"Unknown"
function Theseus.Delivery.Carried()
    local items = Theseus.Player:BasketItems()
    local first = items[1]
    if not first then return nil, nil end
    if first:GetAttribute("Delivering") == true then return first:GetAttribute("Egg"), "Delivering" end
    if first:GetAttribute("BreakAt") then return first:GetAttribute("Egg"), "Carry" end
    return first:GetAttribute("Egg"), "Unknown"
end

---@return boolean  deposited after stepping out of the plot and back in
function Theseus.Delivery.Reenter(token, bp, hrp)
    local cfg = Theseus.Config
    local out = Theseus.Geo.Outside(bp, hrp.Position, cfg.DropOutside)
    if not Theseus.Tasks.Teleport(token, CFrame.new(out)) then return false end
    if not Theseus.Delivery.Sleep(token, cfg.TpSettle) then return false end
    if not Theseus.Delivery.StepHome(token, bp) then return false end
    return Theseus.Delivery.AwaitDeposit(token, cfg.DepositTimeout)
end

---@return boolean  basket empty afterwards
function Theseus.Delivery.Recover(token)
    local eggName, phase = Theseus.Delivery.Carried()
    if not phase then return true, "Empty" end

    local cfg = Theseus.Config
    token.flags0 = token.flags0 or Theseus.Player:Flags()
    token.budget = math.max(token.budget or 0, os.clock() + cfg.RunBudget)

    if phase ~= "Carry" then
        Theseus.Tasks.Await(token, function() return Theseus.Player:BasketCount() == 0 end, cfg.DepositTimeout)
        return Theseus.Player:BasketCount() == 0, "Settled"
    end

    local _, bp = Theseus.Player:Plot()
    local hrp = Theseus.Player.Root
    if not bp or not hrp then return false end

    local wasCritical = Theseus.Eggs.CarryCritical
    Theseus.Eggs.CarryCritical = true
    local outcome = "Deposited"
    if not (Theseus.Geo.InPlot(hrp.Position) and Theseus.Delivery.Reenter(token, bp, hrp)) then
        outcome = Theseus.Delivery.DropCycle(token, bp, eggName, nil)
    end
    Theseus.Eggs.CarryCritical = wasCritical
    return Theseus.Player:BasketCount() == 0, outcome
end

Theseus.Mount = { Name = nil, Dirty = true, AutoLabel = "Auto (fastest)" }

function Theseus.Mount.PetName(inst)
    local name = inst:GetAttribute("PetName") or inst.Name
    if Theseus.GameLib.PetInfo[name] then return name end
    return nil
end

function Theseus.Mount.Moving(name)
    local pets = Theseus.GameLib.Data and Theseus.GameLib.Data.Pets
    local row = pets and pets[name]
    return type(row) == "table" and tonumber(row.MovementSpeed) or 0
end

---@return table  pet name -> Tool, Backpack and hand
function Theseus.Mount.Tools()
    return Theseus.Pets.ToolsByName()
end

---@return string|nil  ridden pet name from the mount joint
function Theseus.Mount.Detect()
    local hrp = Theseus.Player.Root
    local joint = hrp and hrp:FindFirstChild("PetMountJoint")
    local part = joint and joint.Part1
    local model = part and part:FindFirstAncestorOfClass("Model")
    if not model then return nil end
    return Theseus.Mount.PetName(model)
end

function Theseus.Mount.Choice()
    local opts = Theseus.Options
    local pick = opts and opts.RidePet
    if type(pick) ~= "string" or pick == "" or pick == Theseus.Mount.AutoLabel then return nil end
    return pick
end

---@return string|nil, number  name, ride speed
function Theseus.Mount.Best()
    local info = Theseus.GameLib.PetInfo
    local forced = Theseus.Mount.Choice()
    if forced then return forced, info[forced] and info[forced].speed or 0 end

    local names = {}
    for name in pairs(Theseus.Mount.Tools()) do names[#names + 1] = name end
    if Theseus.Player:Riding() and Theseus.Mount.Name then table.insert(names, Theseus.Mount.Name) end

    local best, bestSpeed, bestMove = nil, 0, 0
    for _, name in ipairs(names) do
        local speed = info[name] and info[name].speed or 0
        local move = Theseus.Mount.Moving(name)
        if speed > bestSpeed or (speed == bestSpeed and speed > 0 and move > bestMove) then
            best, bestSpeed, bestMove = name, speed, move
        end
    end
    return best, bestSpeed
end

function Theseus.Mount.Speed()
    if not Theseus.Player:Riding() then return 0 end
    local name = Theseus.Mount.Name or Theseus.Mount.Detect()
    if not name then return 0 end
    Theseus.Mount.Name = name
    local info = Theseus.GameLib.PetInfo[name]
    return info and info.speed or 0
end

---@return number  actual aged/mutated ride speed, capped by current slowdown
function Theseus.Mount.TravelSpeed()
    local hum = Theseus.Player.Humanoid
    local cap = Theseus.Config.UnmountedPlayerSpeed
    if Theseus.Player:Riding() then
        cap = Theseus.Mount.Speed()
        local root = Theseus.Player.Root
        local joint = root and root:FindFirstChild("PetMountJoint")
        local model = joint and joint.Part1 and joint.Part1:FindFirstAncestorOfClass("Model")
        local aging = Theseus.GameLib.Svc.PetAging
        if model and aging and type(aging.RealSpeedFor) == "function" then
            local mutations = Theseus.GameLib.Mutations
            local factor = (mutations[model:GetAttribute("Mutation") or ""] or 1) * (mutations[model:GetAttribute("SpawnMutation") or ""] or 1)
            local ok, actual = Theseus.GameLib.Call(aging.RealSpeedFor, cap, model:GetAttribute("Weight"), factor)
            if ok and type(actual) == "number" and actual > 0 and actual < math.huge then cap = actual end
        end
    end
    return math.min(cap, hum and hum.WalkSpeed or 0)
end

function Theseus.Mount.Forget()
    Theseus.Mount.Name = nil
    Theseus.Mount.Dirty = true
end

---@return Tool|nil  tool of a pet placed on the plot, only when the user named it
function Theseus.Mount.Unplace(token, name)
    local remote = Theseus.GameLib.Remote("PickupPet")
    if not remote then return nil end
    for _, pet in ipairs(Theseus.Pets.Owned()) do
        if pet.name == name and pet.placed then
            remote:FireServer(pet.key)
            break
        end
    end

    local tool
    Theseus.Tasks.Await(token, function()
        tool = Theseus.Pets.ToolNamed(name)
        return tool ~= nil
    end, Theseus.Config.MountTimeout)
    return tool
end

function Theseus.Mount.Dismount(token)
    local remote = Theseus.GameLib.Remote("PetDismount")
    if not remote then return false end
    remote:FireServer()
    Theseus.Mount.Name = nil
    return (Theseus.Tasks.Await(token, function() return not Theseus.Player:Riding() end, Theseus.Config.MountTimeout))
end

---@return boolean  riding the chosen pet
function Theseus.Mount.Ensure(token)
    local cfg = Theseus.Config
    if Theseus.Player:BasketCount() > 0 or not Theseus.Player:IsAlive() then return false end

    local name = Theseus.Mount.Best()
    if not name then return false end
    if Theseus.Player:Riding() then
        if (Theseus.Mount.Name or Theseus.Mount.Detect()) == name then
            Theseus.Mount.Name, Theseus.Mount.Dirty = name, false
            return true
        end
        if not Theseus.Mount.Dismount(token) then return false end
    end

    local tool = Theseus.Pets.ToolNamed(name)
    if not tool and Theseus.Mount.Choice() == name then tool = Theseus.Mount.Unplace(token, name) end
    local remote = Theseus.GameLib.Remote("Mounting")
    local hum = Theseus.Player.Humanoid
    if not tool or not remote or not hum then return false end

    hum:EquipTool(tool)
    for _ = 1, cfg.MountTries do
        remote:FireServer()
        local ok, why = Theseus.Tasks.Await(token, function() return Theseus.Player:Riding() end, cfg.MountGap)
        if ok then break end
        if why ~= "timeout" then return false end
    end
    Theseus.Tasks.Await(token, function() return Theseus.Player:Riding() end, cfg.MountTimeout)

    if not Theseus.Player:Riding() then return false end
    Theseus.Mount.Name, Theseus.Mount.Dirty = name, false
    return true
end

function Theseus.Mount.Watch(backpack)
    if not backpack then return end
    Theseus:Connect(backpack.ChildAdded, function(child)
        if child:IsA("Tool") and Theseus.Mount.PetName(child) then Theseus.Mount.Dirty = true end
    end)
end

task.spawn(function()
    Theseus.Mount.Watch(LocalPlayer:WaitForChild("Backpack", Theseus.Config.LoadTimeout))
end)
Theseus:Connect(LocalPlayer.CharacterAdded, function()
    task.defer(function()
        Theseus.Mount.Watch(LocalPlayer:WaitForChild("Backpack", Theseus.Config.LoadTimeout))
    end)
end)

Theseus.Planner = {
    Ranked = {}, Contested = {},
    Dirty = true, BuiltAt = 0, Epoch = -1, MountName = nil,
    RebuildGap = 0.5, MaxAge = 2, ContestStep = 0.25,
    Started = false,
}

---@return number  studs per second this player can close on an egg
function Theseus.Planner.PlayerSpeed(player, char)
    if player:GetAttribute("IsRiding") ~= true then return Config.UnmountedPlayerSpeed end
    for _, child in ipairs(char:GetChildren()) do
        local pet = GameLib.PetInfo[child.Name]
        if pet and pet.speed then return pet.speed end
    end
    return Config.UnmountedPlayerSpeed
end

---@return table  { {pos, speed} } of every other player with a body
function Theseus.Planner.Riders()
    local riders = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        riders[#riders + 1] = { hrp.Position, Theseus.Planner.PlayerSpeed(player, char) }
    end
    return riders
end

---@param riders table?  from Planner.Riders, built when nil
---@return number        0..1, 1 = someone is on it now
function Theseus.Planner.Contest(entry, riders)
    if not entry.pos then return 0 end
    local best = 0
    for _, rider in ipairs(riders or Theseus.Planner.Riders()) do
        local eta = Theseus.Util.Flat(rider[1], entry.pos) / math.max(rider[2], 1)
        best = math.max(best, math.clamp(1 - eta / Config.ContestHorizon, 0, 1))
    end
    return best
end

---@return number, string, number  score, delivery mode, contest
function Theseus.Planner.Score(entry, riders)
    local mode, trip = Theseus.Delivery.Mode(entry)
    local contest = Theseus.Planner.Contest(entry, riders)
    local cost = Config.TripCost[mode] or Config.TripCost.Drop
    if mode == "Drop" then
        local hum = Theseus.Player.Humanoid
        local speed = math.min(math.max(Theseus.Mount.Speed(), Config.UnmountedPlayerSpeed), hum and hum.WalkSpeed or 0) * 0.9
        cost += trip / math.max(speed, 1)
    end
    local score = (entry.value or 0) * (1 + contest * State.Tune.ContestWeight) / cost
    return score, mode, contest
end

function Theseus.Planner.Rebuild()
    local planner = Theseus.Planner
    local riders = planner.Riders()
    local ranked = planner.Ranked
    table.clear(ranked)

    for _, entry in pairs(Theseus.EggIndex.Entries) do
        if not entry.pos or not entry.egg then continue end
        if entry.privateTo and entry.privateTo ~= LocalPlayer.UserId then continue end
        local score, mode, contest = planner.Score(entry, riders)
        table.insert(ranked, { entry, mode, contest, score })
    end
    table.sort(ranked, function(a, b) return a[4] > b[4] end)

    planner.Dirty, planner.BuiltAt = false, os.clock()
    planner.Epoch = Theseus.EggIndex.ValueEpoch
    planner.MountName = Theseus.Mount.Name
end

---@return boolean  ranking is stale
function Theseus.Planner.Stale()
    local planner = Theseus.Planner
    local age = os.clock() - planner.BuiltAt
    if planner.Epoch ~= Theseus.EggIndex.ValueEpoch or planner.MountName ~= Theseus.Mount.Name then return true end
    if age > planner.MaxAge then return true end
    if not planner.Dirty then return false end

    local surging = os.clock() - Theseus.EggIndex.RolledAt <= Config.WaveSurge
    return surging or age >= planner.RebuildGap
end

---@param minRank number?  hunter-only: rarity rank floor, user filters skipped
---@return table?, string?  entry, planned mode
function Theseus.Planner.Next(minRank)
    local planner = Theseus.Planner
    if planner.Stale() then planner.Rebuild() end

    for _, pick in ipairs(planner.Ranked) do
        local entry = pick[1]
        if not minRank and Theseus.Util.Opt("EggRoute") == "Fast nearby" and pick[2] == "Drop" then continue end
        if minRank then
            local info = GameLib.EggInfo[entry.egg]
            if not info or (GameLib.RarityRank[info.rarity] or 0) < minRank then continue end
        end
        if Theseus.EggIndex.Wanted(entry, minRank ~= nil) then
            planner.Contested[entry.guid] = pick[3]
            return entry, pick[2]
        end
    end
    return nil
end

function Theseus.Planner.OnReply(kind, guid)
    local planner = Theseus.Planner
    if kind ~= "Gone" or not guid then return end
    local contest = planner.Contested[guid]
    planner.Contested[guid] = nil
    if not contest or contest <= 0 then return end

    local tune = State.Tune
    local before = tune.ContestWeight
    tune.ContestWeight = math.min(Config.ContestWeightMax, before + planner.ContestStep)
    if tune.ContestWeight == before then return end

    State.TuneLog = State.TuneLog or {}
    table.insert(State.TuneLog, { "ContestWeight", before, tune.ContestWeight, os.time() })
end

function Theseus.Planner.MarkDirty()
    Theseus.Planner.Dirty = true
end

function Theseus.Planner.Start()
    local planner = Theseus.Planner
    if planner.Started then return end
    planner.Started = true

    local index = Theseus.EggIndex
    index.OnAdded:Connect(Theseus.Planner.MarkDirty)
    index.OnRemoved:Connect(Theseus.Planner.MarkDirty)
    index.OnRoll:Connect(function()
        table.clear(planner.Contested)
        planner.Dirty = true
    end)
    index.OnReply:Connect(Theseus.Planner.OnReply)
end

Theseus.Eggs = {
    Enabled = false, Manual = false, Phase = "Idle", Note = nil,
    Token = nil, CarryCritical = false,
    MountRetryAt = 0, RecoverAt = 0,
    Prio = { Eggs = 60, Hunter = 70, Recover = 100 },
    RateWindow = 60,
}

Theseus.Hunter = { Enabled = false, Hops = 0, HopCycle = nil, HopAt = 0, Seen = {}, Started = false }

Theseus.Guard = {
    Baseline = nil, Tripped = false, Watching = false,
    Toggles = { "AutoEggs", "EggHunter", "VolcanoDip", "VolcanoObby" },
}

---@return number  eggs delivered in the last minute
function Theseus.Eggs.PerMinute()
    local window = State.Stats.window
    local cutoff = os.clock() - Theseus.Eggs.RateWindow
    while window[1] and window[1] < cutoff do
        table.remove(window, 1)
    end
    return #window
end

function Theseus.Eggs.Status()
    local eggs = Theseus.Eggs
    if not eggs.Enabled and not eggs.Manual and not Theseus.Hunter.Enabled then return "Egg farm is off" end
    return eggs.Note or eggs.Phase or "Idle"
end

---@return boolean  always false, so callers can return it
function Theseus.Eggs.SetPhase(phase, note)
    local eggs = Theseus.Eggs
    eggs.Phase, eggs.Note = phase, note
    State.Status.Eggs = eggs.Status()
    if not eggs.Enabled and not eggs.Manual and not Theseus.Hunter.Enabled then
        State.Status.EggRate, State.Status.WaveAt = nil, nil
        return false
    end
    State.Status.EggRate = eggs.PerMinute() .. "/min"
    State.Status.WaveAt = os.clock() + GameLib.CycleLeft()
    return false
end

---@return boolean  Plot and Travel tasks may use the character now
function Theseus.Eggs.Waiting()
    local eggs = Theseus.Eggs
    local active = eggs.Enabled or eggs.Manual or Theseus.Hunter.Enabled
    return not active or eggs.Phase == "WaveWait"
end

function Theseus.Eggs.ReleaseToken()
    local eggs = Theseus.Eggs
    if not eggs.Token then return end
    Theseus.Tasks.Release(eggs.Token)
    eggs.Token = nil
end

---@return boolean  we hold a token at this priority
function Theseus.Eggs.Claim(prio)
    local eggs = Theseus.Eggs
    local token = eggs.Token
    if token and token.prio == prio and Theseus.Tasks.Holds(token) then return true end

    eggs.ReleaseToken()
    local owner = prio >= eggs.Prio.Hunter and "Hunter" or "Eggs"
    eggs.Token = Theseus.Tasks.Request(owner, prio)
    return eggs.Token ~= nil
end

function Theseus.Eggs.EnsureMount()
    local eggs, mount = Theseus.Eggs, Theseus.Mount
    if os.clock() < eggs.MountRetryAt then return end
    if Theseus.Player:Riding() and not mount.Dirty and mount.Best() == mount.Name then return end

    eggs.SetPhase("Mount", "Mounting")
    local ok, mounted = Theseus.Util.Try("Mount.Ensure", mount.Ensure, eggs.Token)
    if ok and mounted then
        mount.Dirty = false
        return
    end
    eggs.MountRetryAt = os.clock() + Config.FailWindow
end

---@return boolean  basket is empty afterwards
function Theseus.Eggs.Recover()
    local eggs = Theseus.Eggs
    if eggs.CarryCritical or os.clock() < eggs.RecoverAt then return false end
    eggs.RecoverAt = os.clock() + Config.SlowTick
    eggs.ReleaseToken()

    local token = Theseus.Tasks.Request("Recover", eggs.Prio.Recover)
    if not token then return eggs.SetPhase("Recover", "Waiting to finish the egg") end

    eggs.SetPhase("Recover", "Finishing the egg")
    Theseus.Util.Try("Delivery.Recover", Theseus.Delivery.Recover, token)
    Theseus.Tasks.Release(token)
    return Theseus.Player:BasketCount() == 0
end

function Theseus.Eggs.Park()
    if not Theseus.Options.ReturnAfter then return end
    local _, bp = Theseus.Player:Plot()
    local hrp = Theseus.Player.Root
    if not bp or not hrp or Theseus.Geo.InPlot(hrp.Position) then return end

    local token = Theseus.Tasks.Request("Eggs", Theseus.Eggs.Prio.Eggs)
    if not token then return end
    Theseus.Tasks.Teleport(token, CFrame.new(Theseus.Geo.EdgeInside(bp, hrp.Position)))
    Theseus.Tasks.Release(token)
end

function Theseus.Eggs.WaveWait()
    local eggs = Theseus.Eggs
    if eggs.Phase ~= "WaveWait" then
        eggs.ReleaseToken()
        eggs.Park()
    end
    local left = GameLib.CycleLeft()
    return eggs.SetPhase("WaveWait", left <= Config.WaveWakeEarly and "New wave" or nil)
end

function Theseus.Eggs.Record(entry, outcome)
    local stats = State.Stats
    if outcome == "Gone" then
        stats.lost += 1
        return
    end
    if outcome == "Refused" then
        Theseus.EggIndex.Fail(entry.guid)
        return
    end
    if outcome ~= "Deposited" then return end

    stats.delivered += 1
    table.insert(stats.window, os.clock())

    local info = GameLib.EggInfo[entry.egg]
    if info and info.ethereal then Theseus.EggIndex.MarkClaimed(entry.egg, entry.cycle) end
end

---@return boolean  the egg reached the plot
function Theseus.Eggs.Trip(entry)
    local eggs = Theseus.Eggs
    eggs.SetPhase("Run", entry.egg)
    local ok, outcome = Theseus.Util.Try("Delivery.Run", Theseus.Delivery.Run, eggs.Token, entry)
    eggs.CarryCritical = false
    if not ok then outcome = "Aborted" end

    eggs.Record(entry, outcome)
    Theseus.Planner.Dirty = true
    eggs.SetPhase("Settle")
    task.wait(Config.EggTick)
    return outcome == "Deposited"
end

---@param minRank number?  hunter-only: rarity floor, user filters skipped
---@return boolean          an egg was delivered
function Theseus.Eggs.Tick(minRank)
    local eggs = Theseus.Eggs
    if eggs.Ticking then return end
    eggs.Ticking = true
    local ok, err = pcall(eggs.TickOnce, minRank)
    eggs.Ticking = false
    if not ok then
        eggs.CarryCritical = false
        eggs.ReleaseToken()
        error(err, 0)
    end
end

function Theseus.Eggs.TickOnce(minRank)
    local eggs = Theseus.Eggs
    if Theseus.Halloween.InZone() == true then
        eggs.ReleaseToken()
        return eggs.SetPhase("Idle", "Leave the Halloween island to farm world eggs")
    end
    Theseus.EggIndex.CheckRoll()

    local _, bp = Theseus.Player:Plot()
    if not bp then return eggs.SetPhase("Idle", "Waiting for plot") end
    if not Theseus.Player:IsAlive() then return eggs.SetPhase("Idle", "Waiting for respawn") end
    if Theseus.Player:BasketCount() > 0 then return eggs.Recover() end
    if eggs.Token and not Theseus.Tasks.Holds(eggs.Token) then eggs.ReleaseToken() end
    if Theseus.Volcano.Pending() then
        eggs.ReleaseToken()
        return eggs.SetPhase("Pick", "Volcano dip")
    end

    local entry = Theseus.Planner.Next(minRank)
    if not entry then return eggs.WaveWait() end
    if not eggs.Claim(Theseus.Hunter.Priority(entry)) then return eggs.SetPhase("Pick", "Waiting for a turn") end

    eggs.EnsureMount()
    return eggs.Trip(entry)
end

function Theseus.Eggs.Step()
    if not Theseus.Eggs.Enabled or Theseus.Guard.Tripped then return end
    Theseus.Eggs.Tick(nil)
end

---@return boolean  index is live
function Theseus.Eggs.Prepare()
    Theseus.Guard.Arm()
    Theseus.Planner.Start()
    return Theseus.EggIndex.Start()
end

---@param quiet boolean  pause the game's inventory bar while farming; the game rebuilds it once when it comes back
---@param force boolean? restore even while a farming toggle is on
function Theseus.Eggs.QuietInventory(quiet, force)
    local eggs = Theseus.Eggs
    if quiet then
        if eggs.InventoryPaused then return end
        eggs.InventoryPaused = true
        eggs.InventoryWas = LocalPlayer:GetAttribute("SatchelEnabled")
        LocalPlayer:SetAttribute("SatchelEnabled", false)
        return
    end
    if not eggs.InventoryPaused then return end
    if not force and (eggs.Enabled or Theseus.Hunter.Enabled or Theseus.Util.Opt("ClearJunk")) then return end
    eggs.InventoryPaused = false
    LocalPlayer:SetAttribute("SatchelEnabled", eggs.InventoryWas)
end

function Theseus.Eggs.Start()
    local eggs = Theseus.Eggs
    eggs.QuietInventory(true)
    if State.LastFail then State.Tune.DirectFactor = math.min(State.Tune.DirectFactor, Config.DirectFactorAfterFail) end
    eggs.Prepare()
    eggs.Enabled, eggs.MountRetryAt = true, 0
    eggs.SetPhase("Idle")
end

function Theseus.Eggs.Stop()
    local eggs = Theseus.Eggs
    eggs.Enabled = false
    if Theseus.Hunter.Enabled then return end
    if eggs.InFlight() then
        task.spawn(Theseus.Eggs.FinishCarry, Config.RunBudget * 2)
        return
    end
    eggs.ReleaseToken()
    eggs.SetPhase("Idle")
    task.spawn(Theseus.Eggs.Settle)
end

---@async
---@return boolean  dismounted and the inventory bar is back
function Theseus.Eggs.Settle()
    local eggs = Theseus.Eggs
    eggs.SettlePending = true
    if not eggs.LetGo() then return false end
    eggs.SettlePending = false
    eggs.QuietInventory(false)
    return true
end

function Theseus.Eggs.SettleStep()
    local eggs = Theseus.Eggs
    if not eggs.SettlePending then return end
    if eggs.Enabled or eggs.Manual or Theseus.Hunter.Enabled or Theseus.Util.Opt("ClearJunk") then
        eggs.SettlePending = false
        return
    end
    eggs.Settle()
end

---@return boolean  a trip is running or an egg is carried
function Theseus.Eggs.InFlight()
    local eggs = Theseus.Eggs
    return eggs.Phase == "Run" or eggs.CarryCritical or Theseus.Player:BasketCount() > 0
end

---@param timeout number  seconds to wait for a running delivery
---@return boolean        basket is empty
function Theseus.Eggs.FinishCarry(timeout)
    local eggs = Theseus.Eggs
    local deadline = os.clock() + (timeout or Config.RunBudget)
    while (eggs.CarryCritical or eggs.Phase == "Run") and os.clock() < deadline do
        task.wait(Config.EggTick)
    end

    if Theseus.Player:BasketCount() > 0 then
        eggs.RecoverAt = 0
        eggs.Recover()
    end
    eggs.ReleaseToken()
    if not eggs.Enabled and not Theseus.Hunter.Enabled then eggs.Settle() end
    return Theseus.Player:BasketCount() == 0
end

---@async
---@return boolean  off the mount with empty hands; false while a task or a carried egg still needs the mount
function Theseus.Eggs.LetGo()
    if Theseus.Tasks.Owner() or Theseus.Player:BasketCount() > 0 then return false end
    return Theseus.Player:Release()
end

function Theseus.Eggs.ExitNow()
    local eggs = Theseus.Eggs
    eggs.Enabled = false
    table.insert(State.PendingToggleOff, "AutoEggs")
    eggs.FinishCarry(Config.RunBudget)
    eggs.SetPhase("Idle", "Stopped")
end

---@async
---@return integer  eggs delivered in this pass, yields until the pass ends
function Theseus.Eggs.CollectNow()
    local eggs = Theseus.Eggs
    if eggs.Enabled or eggs.Manual or Theseus.Hunter.Enabled then return 0 end
    if not eggs.Prepare() then return 0 end

    eggs.Manual = true
    local before = State.Stats.delivered
    local limit = 0
    for _ in pairs(Theseus.EggIndex.Entries) do limit += 1 end

    for _ = 1, limit do
        if Theseus.Guard.Tripped or not State.Alive then break end
        eggs.Tick(nil)
        if eggs.Phase == "WaveWait" or eggs.Phase == "Idle" or eggs.Phase == "Pick" then break end
    end

    eggs.ReleaseToken()
    eggs.Manual = false
    eggs.Settle()
    local got = State.Stats.delivered - before
    table.insert(State.PendingNotify, { "Collect Eggs", "Delivered " .. got .. " eggs" })
    return got
end

---@return number  rarity rank the hunter cares about, huge when unset
function Theseus.Hunter.MinRank()
    return GameLib.RarityRank[Theseus.Options.HuntMinRarity] or math.huge
end

---@return number  task priority for this egg
function Theseus.Hunter.Priority(entry)
    local prio = Theseus.Eggs.Prio
    if not Theseus.Hunter.Enabled then return prio.Eggs end
    local info = GameLib.EggInfo[entry.egg]
    local rank = info and GameLib.RarityRank[info.rarity] or 0
    return rank >= Theseus.Hunter.MinRank() and prio.Hunter or prio.Eggs
end

function Theseus.Hunter.Spotted(entry)
    local hunter = Theseus.Hunter
    if not hunter.Enabled or not entry.egg or hunter.Seen[entry.guid] then return end
    if entry.privateTo and entry.privateTo ~= LocalPlayer.UserId then return end
    local info = GameLib.EggInfo[entry.egg]
    if not info or info.volcanic then return end
    if (GameLib.RarityRank[info.rarity] or 0) < hunter.MinRank() then return end

    hunter.Seen[entry.guid] = true
    table.insert(State.PendingNotify, { "Rare Egg", entry.egg .. " (" .. tostring(info.rarity) .. ") spawned" })
    local webhook = Theseus.Webhook
    if webhook and webhook.EggSpawned and entry.inst then task.defer(webhook.EggSpawned, entry.inst) end
end

function Theseus.Hunter.TryHop()
    local hunter = Theseus.Hunter
    if not Theseus.Options.HunterHop or os.clock() < hunter.HopAt then return end
    if GameLib.CycleLeft() <= Config.HunterMinLeft or Theseus.Player:BasketCount() > 0 then return end

    local cycle = GameLib.CycleIndex()
    if hunter.HopCycle ~= cycle then hunter.HopCycle, hunter.Hops = cycle, 0 end
    if hunter.Hops >= Config.HunterHopsPerCycle then return end
    if Theseus.Planner.Next(hunter.MinRank()) then return end

    hunter.Hops += 1
    hunter.HopAt = os.clock() + Config.LoadTimeout
    Theseus.Util.Try("Server.Hop", Theseus.Server.Hop)
end

function Theseus.Hunter.Step()
    local hunter, eggs = Theseus.Hunter, Theseus.Eggs
    if not hunter.Enabled or eggs.Manual or Theseus.Guard.Tripped then return end
    if not eggs.Enabled then eggs.Tick(hunter.MinRank()) end
    if eggs.Phase == "WaveWait" then hunter.TryHop() end
end

function Theseus.Hunter.Start()
    local hunter = Theseus.Hunter
    if State.LastFail then State.Tune.DirectFactor = math.min(State.Tune.DirectFactor, Config.DirectFactorAfterFail) end
    Theseus.Eggs.Prepare()
    Theseus.Eggs.QuietInventory(true)
    hunter.Enabled = true
    if hunter.Started then return end

    hunter.Started = true
    Theseus.EggIndex.OnAdded:Connect(Theseus.Hunter.Spotted)
    Theseus.EggIndex.OnRoll:Connect(function() table.clear(hunter.Seen) end)
end

function Theseus.Hunter.Stop()
    Theseus.Hunter.Enabled = false
    if Theseus.Eggs.Enabled then return end
    if Theseus.Eggs.InFlight() then
        task.spawn(Theseus.Eggs.FinishCarry, Config.RunBudget * 2)
        return
    end
    Theseus.Eggs.ReleaseToken()
    Theseus.Eggs.SetPhase("Idle")
    task.spawn(Theseus.Eggs.Settle)
end

function Theseus.Guard.Arm()
    local guard = Theseus.Guard
    guard.Tripped = false
    guard.Baseline = Theseus.Player:Flags()
    if guard.Watching then return end
    guard.Watching = true
    Theseus:Connect(LocalPlayer:GetAttributeChangedSignal("TeleportFlags"), Theseus.Guard.OnFlags)
end

function Theseus.Guard.OnFlags()
    local guard = Theseus.Guard
    local flags = Theseus.Player:Flags()
    if guard.Baseline and flags > guard.Baseline then guard.Trip("flags") end
    guard.Baseline = flags
end

function Theseus.Guard.Check(flags0)
    if Theseus.Player:Flags() > (flags0 or 0) then Theseus.Guard.Trip("flags") end
end

---@return table  State.LastFail
function Theseus.Guard.Snapshot(why)
    local plan = type(Theseus.Delivery.LastPlan) == "table" and Theseus.Delivery.LastPlan or {}
    return {
        why = why, at = os.time(),
        mode = plan.mode, trip = plan.trip, speed = plan.speed, settle = plan.settle, timings = plan.timings,
        flagsBefore = Theseus.Guard.Baseline, flagsAfter = Theseus.Player:Flags(),
    }
end

---@return boolean  true when the farm keeps going on a slower delivery pace
function Theseus.Guard.Soften()
    local guard = Theseus.Guard
    local now = os.clock()
    guard.Recent = guard.Recent or {}
    while guard.Recent[1] and now - guard.Recent[1] > Config.ReturnWindow do
        table.remove(guard.Recent, 1)
    end
    guard.Recent[#guard.Recent + 1] = now
    if #guard.Recent >= Config.ReturnStopCount then return false end

    local pace = Config.ReturnBackoff[#guard.Recent] or Config.ReturnBackoff[#Config.ReturnBackoff]
    State.Tune.DirectFactor = math.min(State.Tune.DirectFactor, pace)
    table.insert(State.PendingNotify, { "Egg Farm", "An egg was returned. Delivering slower and carrying on." })
    return true
end

function Theseus.Guard.Trip(why)
    local guard = Theseus.Guard
    if guard.Tripped or os.clock() - (guard.LastTrip or -math.huge) < Config.ReturnDedupe then return end
    guard.LastTrip = os.clock()
    State.Stats.returned += 1

    State.LastFail = guard.Snapshot(why)
    local webhook = Theseus.Webhook
    if webhook and webhook.DeliveryFailed then task.defer(webhook.DeliveryFailed, State.LastFail) end
    if guard.Soften() then return end

    guard.Tripped = true
    Theseus.Eggs.Enabled = false
    Theseus.Hunter.Enabled = false
    local volcano = Theseus.Volcano
    if volcano and volcano.Stop then Theseus.Util.Try("Volcano.Stop", volcano.Stop) end
    for _, idx in ipairs(guard.Toggles) do
        table.insert(State.PendingToggleOff, idx)
    end
    table.insert(State.PendingNotify, { "Egg Farm", "Eggs keep getting returned. Egg farming stopped, switch Delivery to Safe and turn it back on." })
end

Theseus.Volcano = {
    Token = nil,
    Reply = nil,
    Bound = false,
    Skip = {},
    ObbyAfter = 0,
    Dipped = 0,
    Magma = 0,
}

local function Never() return false end

function Theseus.Volcano.Options()
    return Theseus.Options or {}
end

function Theseus.Volcano.SetStatus(text)
    Theseus.State.Status.Volcano = text
end

---@return boolean  false when the token died while waiting
function Theseus.Volcano.Sleep(token, sec)
    local _, why = Theseus.Tasks.Await(token, Never, sec)
    return why == "timeout"
end

local function IsOurs(owner)
    return owner == LocalPlayer or owner == LocalPlayer.UserId
end

function Theseus.Volcano.Bind()
    if Theseus.Volcano.Bound then return end
    Theseus.Volcano.Bound = true

    local result = Theseus.GameLib.Remote("VolcanoDipResult")
    if result then
        Theseus:Connect(result.OnClientEvent, function(reply)
            if type(reply) ~= "table" or not IsOurs(reply.Owner) then return end
            Theseus.Volcano.Reply = reply
        end)
    end

    local cancelled = Theseus.GameLib.Remote("VolcanoDipCancelled")
    if cancelled then
        Theseus:Connect(cancelled.OnClientEvent, function(reply)
            if type(reply) == "table" and not IsOurs(reply.Owner) then return end
            Theseus.Volcano.Reply = { Cancelled = true }
        end)
    end
end

---@return boolean  VolcanoTop is streamed in, not just the empty Volcano shell
function Theseus.Volcano.Stream(token)
    if Theseus.Volcano.Part("VolcanoTop") then return true end
    local ok, err = pcall(LocalPlayer.RequestStreamAroundAsync, LocalPlayer, Theseus.Config.VolcanoCenter, Theseus.Config.VolcanoStreamTimeout)
    if not ok then warn("[RideAPet] volcano stream:", err) end
    return Theseus.Tasks.Await(token, function() return Theseus.Volcano.Part("VolcanoTop") ~= nil end, Theseus.Config.VolcanoStreamTimeout) == true
end

---@return BasePart?
function Theseus.Volcano.Part(name)
    local volcano = workspace:FindFirstChild("Volcano")
    local part = volcano and volcano:FindFirstChild(name, true)
    if part and part:IsA("BasePart") then return part end

    for _, tagged in ipairs(game:GetService("CollectionService"):GetTagged(name)) do
        if tagged:IsA("BasePart") then return tagged end
    end
    return nil
end

---@return boolean  same footprint rule the game uses before it lets a dip fire
function Theseus.Volcano.IsOver(top)
    local hrp = Theseus.Player.Root
    local info = Theseus.GameLib.Data.Volcano
    if not hrp or not top or not info then return false end

    local slack = tonumber(info.ServerRangeSlack) or 0
    local localPos = top.CFrame:PointToObjectSpace(hrp.Position)
    if localPos.Y < 0 then return false end
    return math.abs(localPos.X) <= top.Size.X / 2 + slack and math.abs(localPos.Z) <= top.Size.Z / 2 + slack
end

---@return boolean  ethereal, volcanic or already magma/eternal
local function SkipsDip(entry, info)
    if not info or info.ethereal or info.volcanic then return true end
    return entry.mutation == "Magma" or entry.mutation == "Eternal"
end

---@return number  minimum remaining break time for the dip and trip back
function Theseus.Volcano.MinimumBreak()
    local speed = Theseus.Mount.TravelSpeed()
    if speed <= 0 then local _, bestSpeed = Theseus.Mount.Best(); speed = bestSpeed end
    speed = math.max(speed, Theseus.Config.UnmountedPlayerSpeed)
    local _, bp = Theseus.Player:Plot()
    local returning = bp and math.max(0, (Theseus.Config.VolcanoCenter - bp.Position).Magnitude - Theseus.Config.ReturnHopMax) / speed or math.huge
    return returning + Theseus.Config.VolcanoMinBreakLeft
end

---@return boolean  egg run is idle or waiting, or the wave is down to its last free eggs
function Theseus.Volcano.WaveTail()
    if Theseus.Eggs.Waiting() then return true end
    local free = 0
    for _, entry in pairs(Theseus.EggIndex.Entries) do
        if Theseus.EggIndex.Wanted(entry) and Theseus.Planner.Contest(entry) == 0 then free += 1 end
        if free > Theseus.Config.VolcanoTailEggs then return false end
    end
    return true
end

---@return table?  index entry worth a dip, best score first
function Theseus.Volcano.PickDip()
    local rarities = Theseus.Volcano.Options().DipRarities or {}
    local minBreak = Theseus.Volcano.MinimumBreak()
    local best, bestScore = nil, -math.huge

    for guid, entry in pairs(Theseus.EggIndex.Entries) do
        local egg = Theseus.GameLib.EggInfo[entry.egg]
        if SkipsDip(entry, egg) or (Theseus.Volcano.Skip[guid] or 0) > os.clock() then continue end
        if next(rarities) and not rarities[egg.rarity] then continue end
        if (egg.breakSec or 0) <= minBreak or not Theseus.EggIndex.Wanted(entry) then continue end
        if Theseus.Delivery.Mode(entry) == "Plot" then continue end

        local score = Theseus.Planner.Score(entry)
        if score > bestScore then best, bestScore = entry, score end
    end
    return best
end

---@return Instance?  carried egg that can still be dipped
function Theseus.Volcano.Carried()
    local now = Theseus.Util.ServerNow()
    local minBreak = (tonumber(Theseus.GameLib.Data.Volcano.BonusSeconds) or math.huge) + Theseus.Config.VolcanoMinBreakLeft
    for _, egg in ipairs(Theseus.Player:BasketItems()) do
        if egg:GetAttribute("VolcanoDipped") or egg:GetAttribute("Delivering") then continue end
        if (tonumber(egg:GetAttribute("VolcanoUntil")) or 0) > now then continue end
        local breakAt = tonumber(egg:GetAttribute("BreakAt"))
        if breakAt and breakAt - now > minBreak then return egg end
    end
    return nil
end

---@return table?  dip reply, re-fired while the server position still lags the teleport
function Theseus.Volcano.FireUntilReply(token, remote)
    Theseus.Volcano.Reply = nil
    local deadline = os.clock() + Theseus.Config.VolcanoResultTimeout
    repeat
        remote:FireServer()
        if Theseus.Tasks.Await(token, function() return Theseus.Volcano.Reply ~= nil end, Theseus.Config.VolcanoRefire) then
            return Theseus.Volcano.Reply
        end
        if not Theseus.Tasks.Holds(token) then return nil end
    until os.clock() >= deadline
    return nil
end

---@return boolean  the dip reply came back and the egg is home in the basket again
function Theseus.Volcano.Dip(token)
    local remote = Theseus.GameLib.Remote("VolcanoDip")
    local info = Theseus.GameLib.Data.Volcano
    if not remote or not info or not Theseus.Volcano.Carried() then return false end
    if not Theseus.Volcano.Stream(token) then return false end

    local top = Theseus.Volcano.Part("VolcanoTop")
    if not top then return false end
    Theseus.Tasks.Teleport(token, CFrame.new(top.Position + Vector3.yAxis * (tonumber(info.HoverHeight) or 0)))
    if not Theseus.Volcano.Sleep(token, Theseus.Config.VolcanoDipSettle) then return false end
    if not Theseus.Volcano.IsOver(top) then return false end

    Theseus.Volcano.SetStatus("Dipping egg")
    local reply = Theseus.Volcano.FireUntilReply(token, remote)
    if not reply or reply.Cancelled then return false end

    local landAt = tonumber(reply.ArriveAt) or 0
    local arrived = Theseus.Tasks.Await(token, function()
        return (Theseus.Volcano.Reply and Theseus.Volcano.Reply.Cancelled) or Theseus.Util.ServerNow() >= landAt
    end, Theseus.Config.VolcanoResultTimeout)
    if not arrived or (Theseus.Volcano.Reply and Theseus.Volcano.Reply.Cancelled) then return false end
    Theseus.Volcano.Dipped += 1
    if reply.Success then Theseus.Volcano.Magma += 1 end
    return true
end

---@return string  short outcome for the status line
function Theseus.Volcano.DipRun(token, entry)
    local _, bp = Theseus.Player:Plot()
    if not bp then return "no plot" end
    if not Theseus.Mount.Ensure(token) then return "A fast ride pet is needed for the return" end

    local ok, why = Theseus.Delivery.Pickup(token, entry.guid, Theseus.Geo.StandPoint(bp, entry.pos))
    if not ok then
        Theseus.Volcano.Skip[entry.guid] = os.clock() + Theseus.Config.GoneBlacklistSec
        return "pickup " .. tostring(why)
    end

    Theseus.Eggs.CarryCritical = true
    local dipped = Theseus.Volcano.Dip(token)
    Theseus.Volcano.SetStatus("Returning the dipped egg")
    local _, outcome = Theseus.Delivery.Recover(token)
    Theseus.Eggs.CarryCritical = false
    if outcome ~= "Deposited" then return "Dip finished; egg delivery not confirmed" end
    return dipped and "dipped and delivered" or "dip skipped; egg delivered"
end

---@param canTouch boolean  executor touch works
function Theseus.Volcano.Hold(token, part, canTouch)
    local hrp = Theseus.Player.Root
    if not hrp or not part.Parent then return end
    hrp.AssemblyLinearVelocity = Vector3.zero
    if (hrp.Position - part.Position).Magnitude > part.Size.Magnitude / 2 then Theseus.Tasks.Teleport(token, part.CFrame) end
    if not canTouch or os.clock() < (Theseus.Volcano.TouchAt or 0) then return end
    Theseus.Volcano.TouchAt = os.clock() + Theseus.Config.VolcanoTouchEvery
    firetouchinterest(hrp, part, 0)
    task.defer(firetouchinterest, hrp, part, 1)
end

function Theseus.Volcano.Climb(token)
    if Theseus.Volcano.Done() then return true end
    if not Theseus.Volcano.Stream(token) then return false end
    local canTouch = Library and Library.Compat and Library.Compat.Caps.Touch == true

    for _, step in ipairs({ { "VolcanoEntrance" }, { "VolcanoValidate", "InVolcano" }, { "VolcanoTop", "VolcanoValidated" } }) do
        local part = Theseus.Volcano.Part(step[1])
        if not part or not Theseus.Tasks.Teleport(token, part.CFrame) then return false end
        if not Theseus.Volcano.Sleep(token, Theseus.Config.VolcanoSettle) then return false end

        Theseus.Volcano.Hold(token, part, canTouch)
        local attr = step[2]
        if attr and not Theseus.Tasks.Await(token, function()
            if LocalPlayer:GetAttribute(attr) == true then return true end
            Theseus.Volcano.Hold(token, part, canTouch)
            return false
        end, Theseus.Config.VolcanoStepWait) then
            return false
        end
    end
    return Theseus.Volcano.Done()
end

function Theseus.Volcano.Done()
    return LocalPlayer:GetAttribute("VolcanoValidated") == true
end

---@return table?  Volcanic egg in the index we may pick up
function Theseus.Volcano.VolcanicEgg()
    for guid, entry in pairs(Theseus.EggIndex.Entries) do
        local info = Theseus.GameLib.EggInfo[entry.egg]
        if not info or not info.volcanic then continue end
        if entry.privateTo and not IsOurs(entry.privateTo) then continue end
        if (Theseus.Volcano.Skip[guid] or 0) > os.clock() then continue end
        return entry
    end
    return nil
end

---@return string
function Theseus.Volcano.ObbyRun(token, entry)
    if not Theseus.Volcano.Climb(token) then
        Theseus.Volcano.ObbyAfter = os.clock() + Theseus.Config.VolcanoRetry
        return "climb failed"
    end

    if not Theseus.Mount.Ensure(token) then return "A fast ride pet is needed for the return" end

    local stand = entry.pos + Vector3.yAxis * Theseus.Geo.Lift(Theseus.Config.VolcanoStandLift)
    local ok, why = Theseus.Delivery.Pickup(token, entry.guid, stand)
    if not ok then
        Theseus.Volcano.Skip[entry.guid] = os.clock() + Theseus.Config.GoneBlacklistSec
        return "pickup " .. tostring(why)
    end

    Theseus.Eggs.CarryCritical = true
    Theseus.Volcano.SetStatus("Returning the volcanic egg")
    local _, outcome = Theseus.Delivery.Recover(token)
    Theseus.Eggs.CarryCritical = false
    return outcome == "Deposited" and "volcanic egg delivered" or "Volcanic egg delivery not confirmed"
end

---@return table?, function?  target and runner for this tick
function Theseus.Volcano.Plan()
    local opts = Theseus.Volcano.Options()
    if opts.VolcanoObby and os.clock() >= Theseus.Volcano.ObbyAfter then
        local egg = Theseus.Volcano.VolcanicEgg()
        if egg then return egg, Theseus.Volcano.ObbyRun end
    end
    if opts.VolcanoDip and Theseus.GameLib.Data.Volcano and Theseus.Volcano.WaveTail() then
        local egg = Theseus.Volcano.PickDip()
        if egg then return egg, Theseus.Volcano.DipRun end
    end
    return nil
end

---@return boolean  the egg run must leave the character to the volcano for now
function Theseus.Volcano.Pending()
    local hold = Theseus.Volcano.Claimed
    if not hold then return false end
    if os.clock() < hold[2] and Theseus.EggIndex.Entries[hold[1]] then return true end
    Theseus.Volcano.Claimed = nil
    return false
end

---@return boolean  an egg nobody delivers is still in the basket
local function Orphaned()
    local eggs = Theseus.Eggs
    if Theseus.Player:BasketCount() == 0 or eggs.CarryCritical then return false end
    return not (eggs.Enabled or eggs.Manual or Theseus.Hunter.Enabled)
end

function Theseus.Volcano.Step()
    if not Theseus.State.Alive or not Theseus.Player:IsAlive() or Theseus.Guard.Tripped then return end
    if Theseus.Halloween.InZone() == true then
        Theseus.Volcano.SetStatus("Leave the Halloween island to farm the volcano")
        return
    end
    if Orphaned() then
        Theseus.Volcano.SetStatus("Finishing the egg")
        Theseus.Eggs.Recover()
        return
    end
    if not Theseus.Player:Riding() then
        local mountToken = Theseus.Tasks.Request("Volcano", Theseus.Tasks.Prio.Volcano)
        if not mountToken then return end
        Theseus.Volcano.Token = mountToken
        local mounted = Theseus.Mount.Ensure(mountToken)
        Theseus.Volcano.Token = nil
        Theseus.Tasks.Release(mountToken)
        if not mounted then
            Theseus.Volcano.SetStatus("A fast ride pet is needed for the return")
            return
        end
    end
    Theseus.Volcano.Bind()

    local entry, runner = Theseus.Volcano.Plan()
    if not entry then
        Theseus.Volcano.Claimed = nil
        Theseus.Volcano.SetStatus("Waiting")
        return
    end

    Theseus.Volcano.Claimed = { entry.guid, os.clock() + Theseus.Config.VolcanoClaimSec }
    if Theseus.Player:BasketCount() > 0 then return end
    local token = Theseus.Tasks.Request("Volcano", Theseus.Tasks.Prio.Volcano)
    if not token then return end
    Theseus.Volcano.Claimed = nil
    Theseus.Volcano.Token = token

    local flags0 = Theseus.Player:Flags()
    local ok, outcome = Theseus.Util.Try("volcano", runner, token, entry)
    Theseus.Eggs.CarryCritical = false
    Theseus.Guard.Check(flags0)

    Theseus.Volcano.Token = nil
    Theseus.Tasks.Release(token)
    Theseus.Volcano.SetStatus(ok and outcome or "error")
end

function Theseus.Volcano.Start()
    Theseus.Eggs.Prepare()
    Theseus.Volcano.Bind()
    Theseus.Volcano.ObbyAfter = 0
end

function Theseus.Volcano.Stop()
    Theseus.Volcano.Claimed = nil
    local token = Theseus.Volcano.Token
    if token and Theseus.Player:BasketCount() == 0 then
        Theseus.Volcano.Token = nil
        Theseus.Tasks.Release(token)
    end
end

function Theseus.Volcano.Status()
    return Theseus.State.Status.Volcano or "Off"
end

Theseus.Hatch = {
    Bound = false,
    Pending = {},
    LastPlaced = 0,
    LastRequest = 0,
    CapHit = false,
    Hatched = 0,
    Purchased = {},
    Confirmed = {},
    Planted = 0,
    GrowCache = {},
    Signal = Theseus.Signal.new(),
}

local function IsOurs(owner)
    return owner == nil or owner == LocalPlayer or owner == LocalPlayer.UserId
end

function Theseus.Hatch.Options()
    return Theseus.Options or {}
end

function Theseus.Hatch.SetStatus(text)
    Theseus.State.Status.Hatch = text
end

function Theseus.Hatch.Store(placement)
    if type(placement) ~= "table" or type(placement.EggKey) ~= "string" then return end
    Theseus.State.PlotEggs[placement.EggKey] = {
        key = placement.EggKey,
        egg = placement.EggName,
        placeTime = tonumber(placement.PlaceTime),
        weight = tonumber(placement.Weight) or 1,
        pos = typeof(placement.UpCFrame) == "CFrame" and placement.UpCFrame.Position or placement.Coordinate,
    }
    Theseus.Hatch.LastPlaced = os.clock()
end

---@param msg table  EggPlaced reply, snapshot or one placement
function Theseus.Hatch.OnPlaced(msg)
    if type(msg) ~= "table" or not IsOurs(msg.Owner) then return end
    if not msg.Snapshot then
        Theseus.Hatch.Store(msg)
        return
    end

    table.clear(Theseus.State.PlotEggs)
    for _, placement in pairs(type(msg.Placements) == "table" and msg.Placements or {}) do
        Theseus.Hatch.Store(placement)
    end
end

function Theseus.Hatch.OnHatched(msg)
    if type(msg) ~= "table" or not IsOurs(msg.Owner) or not msg.EggKey then return end
    Theseus.State.PlotEggs[msg.EggKey] = nil
    Theseus.Hatch.Pending[msg.EggKey] = nil
    Theseus.Hatch.Hatched += 1
    Theseus.Hatch.Confirmed[msg.EggKey] = os.clock()
    Theseus.Hatch.Purchased[msg.EggKey] = nil
    Theseus.Hatch.Signal:Fire(msg)
end

function Theseus.Hatch.OnMessage(text)
    if type(text) ~= "string" then return end
    local used, cap = text:match("Max (%d+)/(%d+)")
    if not cap then return end
    Theseus.State.PlantCap = math.max(tonumber(used), tonumber(cap))
    Theseus.Hatch.CapHit = true
    Theseus.Hatch.RequestSnapshot()
end

function Theseus.Hatch.Bind()
    if Theseus.Hatch.Bound then return end
    Theseus.Hatch.Bound = true

    local placed = Theseus.GameLib.Remote("EggPlaced")
    if placed then Theseus:Connect(placed.OnClientEvent, Theseus.Hatch.OnPlaced) end

    local hatch = Theseus.GameLib.Remote("Hatch")
    if hatch then Theseus:Connect(hatch.OnClientEvent, Theseus.Hatch.OnHatched) end

    local message = Theseus.GameLib.Remote("GameMessage")
    if message then Theseus:Connect(message.OnClientEvent, Theseus.Hatch.OnMessage) end

    Theseus.Hatch.RequestSnapshot()
end

function Theseus.Hatch.RequestSnapshot()
    local remote = Theseus.GameLib.Remote("RequestPlotEggs")
    if not remote then return end
    Theseus.Hatch.LastRequest = os.clock()
    remote:FireServer(true)
end

---@return boolean  a hatch luck event is running
function Theseus.Hatch.BoostActive()
    local rs = game:GetService("ReplicatedStorage")
    local mult = tonumber(rs:GetAttribute("HatchLuckEventMultiplier")) or 1
    local untilAt = tonumber(rs:GetAttribute("HatchLuckEventUntil"))
    if untilAt and untilAt <= Theseus.Util.ServerNow() then return false end
    return mult > 1
end

---@return number?  seconds of growth left, nil when unknown
function Theseus.Hatch.Left(plotEgg)
    local info = Theseus.GameLib.EggInfo[plotEgg.egg or ""]
    if not info or not plotEgg.placeTime then return nil end
    return Theseus.GameLib.GrowthLeft(plotEgg.placeTime, info.growth, plotEgg.weight)
end

---@return number|nil  os.clock() moment the egg is grown, night growth included; nil when unknown
function Theseus.Hatch.ReadyAt(plotEgg)
    if plotEgg.readyAt then return plotEgg.readyAt end
    local info = Theseus.GameLib.EggInfo[plotEgg.egg or ""]
    if not info or not plotEgg.placeTime then return nil end

    local left = Theseus.GameLib.GrowthRealLeft(plotEgg.placeTime, info.growth, plotEgg.weight)
    if not left then return nil end
    plotEgg.readyAt = os.clock() + left
    return plotEgg.readyAt
end

---@return integer  hatch fires sent this pass
function Theseus.Hatch.HatchNow(onlyKey)
    local remote = Theseus.GameLib.Remote("Hatch")
    if not remote then return 0 end
    Theseus.Hatch.Bind()

    local fired, now = 0, os.clock()
    for key, plotEgg in pairs(Theseus.State.PlotEggs) do
        if onlyKey and key ~= onlyKey then continue end
        if (Theseus.Hatch.Pending[key] or 0) > now then continue end
        local left = Theseus.Hatch.Left(plotEgg)
        if not left or left > 0 then continue end

        if fired > 0 then task.wait(Theseus.Config.HatchGap) end
        Theseus.Hatch.Pending[key] = os.clock() + Theseus.Config.HatchPending
        remote:FireServer({ EggKey = key })
        fired += 1
    end
    return fired
end

function Theseus.Hatch.Step()
    local opts = Theseus.Hatch.Options()
    local purchased = opts.HalloweenAutoHatch ~= false and next(Theseus.Hatch.Purchased) ~= nil
    if not opts.AutoHatch and not purchased then return end
    Theseus.Hatch.Bind()

    if os.clock() - Theseus.Hatch.LastRequest > Theseus.Config.PlotEggsRefresh then
        Theseus.Hatch.RequestSnapshot()
    end
    if opts.HoldHatchBoost and not Theseus.Hatch.BoostActive() then
        Theseus.Hatch.SetStatus("Holding for luck boost")
        return
    end

    if not opts.AutoHatch then
        for key in pairs(Theseus.Hatch.Purchased) do
            Theseus.Hatch.HatchNow(key)
        end
        return
    end

    local fired = Theseus.Hatch.HatchNow()
    if fired > 0 then Theseus.Hatch.SetStatus("Hatching " .. fired) end
end

---@return string?  egg name the tool plants
function Theseus.Hatch.ToolEgg(tool)
    local name = tool:GetAttribute("Egg") or tool.Name:match("^(.-Egg)")
    return Theseus.GameLib.EggInfo[name or ""] and name or nil
end

---@return { {Tool, string, number, string?} }  egg tools with name, weight and mutation
function Theseus.Hatch.EggTools()
    local tools = {}
    for _, holder in ipairs({ LocalPlayer:FindFirstChild("Backpack"), Theseus.Player.Char }) do
        if not holder then continue end
        for _, tool in ipairs(holder:GetChildren()) do
            if not tool:IsA("Tool") or not tool:GetAttribute("EggInventoryId") then continue end
            local name = Theseus.Hatch.ToolEgg(tool)
            if not name then continue end
            table.insert(tools, { tool, name, tonumber(tool:GetAttribute("Weight")) or 1, tool:GetAttribute("Mutation") })
        end
    end
    return tools
end

---@return number  higher plants first
function Theseus.Hatch.Rank(name, weight, order, mutation)
    local info = Theseus.GameLib.EggInfo[name]
    local key = name .. "|" .. tostring(weight)
    local growth = Theseus.Hatch.GrowCache[key]
    if growth == nil then
        growth = Theseus.GameLib.GrowthSeconds(info.growth or 1, weight) or info.growth or 1
        Theseus.Hatch.GrowCache[key] = growth
    end
    growth = math.max(growth, 0.001)
    if order == "Fastest growth" then return -growth end
    local value = Theseus.EggIndex.Value({ egg = name, weight = weight, mutation = mutation })
    if order == "Value per hour" then return value / growth end
    return value
end

---@return { {Tool, string, number} }  tools to plant in order, PlantKeep per egg name held back
function Theseus.Hatch.Queue()
    local opts = Theseus.Hatch.Options()
    local order = opts.PlantOrder or "Best value"
    local tools = Theseus.Hatch.EggTools()
    for _, entry in ipairs(tools) do
        entry[5] = Theseus.Hatch.Rank(entry[2], entry[3], order, entry[4])
    end
    local function Better(a, b) return a[5] > b[5] end
    table.sort(tools, Better)

    local keep = tonumber(opts.PlantKeep) or 0
    if keep <= 0 then return tools end
    local seen, queue = {}, {}
    for i = #tools, 1, -1 do
        local name = tools[i][2]
        seen[name] = (seen[name] or 0) + 1
        if seen[name] > keep then queue[#queue + 1] = tools[i] end
    end
    table.sort(queue, Better)
    return queue
end

function Theseus.Hatch.Count()
    local count = 0
    for _ in pairs(Theseus.State.PlotEggs) do count += 1 end
    return count
end

function Theseus.Hatch.Room()
    return math.max(0, (Theseus.State.PlantCap or Theseus.Config.PlantCapDefault) - Theseus.Hatch.Count())
end

---@return integer  plot slots Auto Place Eggs owns while Clear Junk shares the plot
function Theseus.Hatch.ValueCap()
    local cap = Theseus.State.PlantCap or Theseus.Config.PlantCapDefault
    return math.floor(cap * (1 - Theseus.Config.JunkPlotShare))
end

---@return integer  slots the value planter may fill, Clear Junk keeps its share free
function Theseus.Hatch.ValueRoom()
    local room = Theseus.Hatch.Room()
    if not Theseus.Util.Opt("ClearJunk") then return room end
    local held = Theseus.Hatch.Count() - Theseus.Junk.PlotJunk()
    return math.max(0, math.min(room, Theseus.Hatch.ValueCap() - held))
end

---@return integer  slots Clear Junk may fill, the value share stays free while Auto Place Eggs runs
function Theseus.Hatch.JunkRoom()
    local room = Theseus.Hatch.Room()
    if not Theseus.Util.Opt("AutoPlaceEggs") then return room end
    local held = Theseus.Hatch.Count() - Theseus.Junk.PlotJunk()
    return math.max(0, room - math.max(0, Theseus.Hatch.ValueCap() - held))
end

---@return Vector3[]  free grid points on the baseplate top, PlantSpacing apart from planted eggs
function Theseus.Hatch.Spots(bp, count)
    local spacing = Theseus.Config.PlantSpacing
    local taken = {}
    for _, plotEgg in pairs(Theseus.State.PlotEggs) do
        if typeof(plotEgg.pos) == "Vector3" then taken[#taken + 1] = plotEgg.pos end
    end

    local top = bp.Size.Y / 2
    local halfX = bp.Size.X / 2 - Theseus.Config.EdgeInset - spacing / 2
    local halfZ = bp.Size.Z / 2 - Theseus.Config.EdgeInset - spacing / 2
    local spots = {}
    for x = -halfX, halfX, spacing do
        for z = -halfZ, halfZ, spacing do
            local pos = (bp.CFrame * CFrame.new(x, top, z)).Position
            local clear = true
            for _, other in ipairs(taken) do
                if Theseus.Util.Flat(other, pos) < spacing then
                    clear = false
                    break
                end
            end
            if not clear then continue end
            spots[#spots + 1] = pos
            taken[#taken + 1] = pos
            if #spots >= count then return spots end
        end
    end
    return spots
end

---@return { string }  nest ids that are unlocked and empty
function Theseus.Hatch.FreeNests(plot)
    local nests = plot:FindFirstChild("Nests")
    local free = {}
    for _, nest in ipairs(nests and nests:GetChildren() or {}) do
        if nest:GetAttribute("Unlocked") and not nest:GetAttribute("Occupied") then table.insert(free, nest.Name) end
    end
    return free
end

---@return boolean  the server answered with a new placement
function Theseus.Hatch.PlantOne(token, tool, args)
    local hum = Theseus.Player.Humanoid
    if not hum or tool.Parent == nil then return false end
    hum:EquipTool(tool)
    local _, why = Theseus.Tasks.Await(token, function() return false end, Theseus.Config.EquipSettle)
    if why ~= "timeout" then return false end

    local before = Theseus.Hatch.LastPlaced
    Theseus.Hatch.CapHit = false
    local replied = function() return Theseus.Hatch.LastPlaced ~= before or Theseus.Hatch.CapHit end
    for _ = 1, Theseus.Config.PlantTries do
        if tool.Parent ~= hum.Parent then hum:EquipTool(tool) end
        Theseus.GameLib.Remote("EggPlaced"):FireServer(args)
        local ok, why = Theseus.Tasks.Await(token, replied, Theseus.Config.PlantReplyTimeout)
        if ok then return not Theseus.Hatch.CapHit end
        if why ~= "timeout" or tool.Parent == nil then return false end
    end
    return false
end

---@return string|nil  the new placement key for this one tool
function Theseus.Hatch.PlantTool(token, tool)
    Theseus.Hatch.Bind()
    local plot, bp = Theseus.Player:Plot()
    if not plot or not bp or Theseus.Hatch.Room() <= 0 then return nil end
    local egg = Theseus.Hatch.ToolEgg(tool)
    if not egg then return nil end
    local noNest = LocalPlayer:GetAttribute("NoNest") == true
    local slots = noNest and Theseus.Hatch.Spots(bp, 1) or Theseus.Hatch.FreeNests(plot)
    if not slots[1] then return nil end

    local before = {}
    for key in pairs(Theseus.State.PlotEggs) do before[key] = true end
    local stand = CFrame.new(bp.Position + Vector3.yAxis * (bp.Size.Y / 2 + Theseus.Geo.Lift(Config.PlantStandLift)))
    if not Theseus.Tasks.Teleport(token, stand) then return nil end
    local args = noNest and { PlantPosition = slots[1] } or { NestId = slots[1] }
    if not Theseus.Hatch.PlantOne(token, tool, args) then return nil end
    for key, placement in pairs(Theseus.State.PlotEggs) do
        if not before[key] and placement.egg == egg then return key end
    end
    return nil
end

---@return boolean  takes longer than PlantLongGrow seconds to grow
function Theseus.Hatch.IsLong(name, weight)
    local cache = Theseus.Hatch.GrowCache
    local key = name .. "|" .. weight
    if cache[key] == nil then
        local info = Theseus.GameLib.EggInfo[name]
        local total = info and (Theseus.GameLib.GrowthSeconds(info.growth, weight) or info.growth) or 0
        cache[key] = total > Theseus.Config.PlantLongGrow
    end
    return cache[key]
end

---@return integer  slow growers we may still plant so the rest of the plot keeps hatching
function Theseus.Hatch.LongRoom()
    local cap = Theseus.State.PlantCap or Theseus.Config.PlantCapDefault
    local held = 0
    for _, plotEgg in pairs(Theseus.State.PlotEggs) do
        local left = Theseus.Hatch.Left(plotEgg)
        if left and left > Theseus.Config.PlantLongGrow then held += 1 end
    end
    return math.max(0, math.floor(cap * Theseus.Config.PlantLongShare) - held)
end

---@return { {Tool, string, number} }  Queue trimmed to room, slow growers capped by LongRoom
function Theseus.Hatch.Pick(room)
    local longRoom = Theseus.Hatch.LongRoom()
    local picked, spare = {}, {}
    for _, entry in ipairs(Theseus.Hatch.Queue()) do
        if #picked >= room then break end
        if Theseus.Hatch.IsLong(entry[2], entry[3]) then
            if longRoom <= 0 then
                spare[#spare + 1] = entry
                continue
            end
            longRoom -= 1
        end
        picked[#picked + 1] = entry
    end
    for _, entry in ipairs(spare) do
        if #picked >= room then break end
        picked[#picked + 1] = entry
    end
    return picked
end

---@return integer  eggs planted
function Theseus.Hatch.Plant(token, plot, bp)
    local noNest = LocalPlayer:GetAttribute("NoNest") == true
    local room = Theseus.Hatch.ValueRoom()
    local queue = Theseus.Hatch.Pick(room)
    local slots = noNest and Theseus.Hatch.Spots(bp, math.min(room, #queue)) or Theseus.Hatch.FreeNests(plot)
    if #slots == 0 or #queue == 0 or room == 0 then return 0 end

    Theseus.Tasks.Teleport(token, CFrame.new(bp.Position + Vector3.yAxis * (bp.Size.Y / 2 + Theseus.Geo.Lift(Config.PlantStandLift))))
    local planted = 0
    for i, slot in ipairs(slots) do
        local entry = queue[i]
        if i > room or not entry or not Theseus.Tasks.Holds(token) then break end
        Theseus.Hatch.SetStatus("Placing " .. entry[2])
        local args = noNest and { PlantPosition = slot } or { NestId = slot }
        if not Theseus.Hatch.PlantOne(token, entry[1], args) then break end
        planted += 1
    end

    return planted
end

---@return boolean  planting may take the character now
function Theseus.Hatch.CanPlant()
    if Theseus.Player:BasketCount() > 0 or not Theseus.Player:IsAlive() then return false end
    if not Theseus.GameLib.Remote("EggPlaced") or Theseus.Junk.Running then return false end
    return not Theseus.Hatch.Options().AutoEggs or Theseus.Eggs.Phase == "WaveWait"
end

---@return integer  eggs planted
function Theseus.Hatch.PlaceNow()
    Theseus.Hatch.Bind()
    if not Theseus.Hatch.CanPlant() then return 0 end
    local plot, bp = Theseus.Player:Plot()
    if not plot or not bp then return 0 end
    if Theseus.Hatch.ValueRoom() == 0 then
        if os.clock() - Theseus.Hatch.LastRequest > Theseus.Config.PlotFullRecheck then Theseus.Hatch.RequestSnapshot() end
        Theseus.Hatch.SetStatus(string.format("Plot full (%d/%d)", Theseus.Hatch.Count(), Theseus.State.PlantCap or Theseus.Config.PlantCapDefault))
        return 0
    end

    local token = Theseus.Tasks.Request("Plant", 40)
    if not token then return 0 end
    local ok, planted = Theseus.Util.Try("plant", Theseus.Hatch.Plant, token, plot, bp)
    local hum = Theseus.Player.Humanoid
    if hum and Theseus.Player:BasketCount() == 0 then hum:UnequipTools() end
    Theseus.Tasks.Release(token)

    planted = ok and planted or 0
    Theseus.Hatch.Planted += planted
    Theseus.Hatch.SetStatus(planted > 0 and ("Placed " .. planted .. " eggs") or (#Theseus.Hatch.EggTools() == 0 and "No eggs to place" or string.format("Plot %d/%d", Theseus.Hatch.Count(), Theseus.State.PlantCap or Theseus.Config.PlantCapDefault)))
    return planted
end

function Theseus.Hatch.PlantStep()
    local opts = Theseus.Hatch.Options()
    if not opts.AutoPlaceEggs then return end
    Theseus.Hatch.PlaceNow()
end

function Theseus.Hatch.Start()
    Theseus.Hatch.Bind()
end

function Theseus.Hatch.Stop()
    table.clear(Theseus.Hatch.Pending)
end

function Theseus.Hatch.Status()
    return Theseus.State.Status.Hatch or "Idle"
end

Theseus.Junk = {
    Bound = false,
    Running = false,
    Queue = {},
    Cursor = 1,
    BuiltAt = -math.huge,
    EmptyUntil = 0,
    Growth = {},
    Share = {},
    Held = nil,
    EquippedAt = 0,
    Spacing = Theseus.Config.JunkSpacing,
    LastFire = -math.huge,
    Calm = 0,
    Slack = Theseus.Config.JunkHatchSlack,
    HatchGap = 0,
    Retries = 0,
    Anchor = "seller",
    PlantFails = 0,
    FullUntil = 0,
    BackoffUntil = 0,
    YieldUntil = 0,
    ActiveAt = 0,
    ReportAt = 0,
    Fresh = 0,
    Selling = false,
    Planted = 0,
    Hatched = 0,
    Sold = 0,
    Window = {},
}

function Theseus.Junk.SetStatus(text)
    Theseus.State.Status.Junk = text
end

---@return integer  hatches in the last JunkRateWindow seconds
function Theseus.Junk.PerMinute()
    local window = Theseus.Junk.Window
    local cutoff = os.clock() - Theseus.Config.JunkRateWindow
    while window[1] and window[1] < cutoff do
        table.remove(window, 1)
    end
    return #window
end

function Theseus.Junk.Report(note)
    local junk = Theseus.Junk
    junk.ReportAt = os.clock()
    local line = string.format("Hatched %d | Sold %d | %d/min", junk.Hatched, junk.Sold, junk.PerMinute())
    junk.SetStatus(note and (line .. " | " .. note) or line)
end

---@return table  { [rarity] = true } egg rarities to clear, Common and Rare when none are picked
function Theseus.Junk.Set()
    local picked = Theseus.Util.Opt("JunkRarities")
    if type(picked) == "table" and next(picked) then return picked end
    return { Common = true, Rare = true }
end

---@return number  seconds this egg takes to grow, huge when the game does not say
function Theseus.Junk.GrowthOf(name, weight)
    local cache = Theseus.Junk.Growth
    local key = name .. "|" .. string.format("%.2f", weight)
    local known = cache[key]
    if known then return known end

    local info = Theseus.GameLib.EggInfo[name]
    known = info and Theseus.GameLib.GrowthSeconds(info.growth, weight) or math.huge
    cache[key] = known
    return known
end

---@return integer  eggs queued, fastest growing first
function Theseus.Junk.Build()
    local junk = Theseus.Junk
    local set, queue = junk.Set(), {}
    for _, entry in ipairs(Theseus.Hatch.EggTools()) do
        local info = Theseus.GameLib.EggInfo[entry[2]]
        if info and set[info.rarity] then
            queue[#queue + 1] = { entry[1], entry[2], entry[3], junk.GrowthOf(entry[2], entry[3]), info.luck }
        end
    end
    table.sort(queue, function(a, b)
        if a[4] ~= b[4] then return a[4] < b[4] end
        return a[5] < b[5]
    end)

    junk.Queue, junk.Cursor, junk.BuiltAt = queue, 1, os.clock()
    junk.EmptyUntil = #queue == 0 and os.clock() + Theseus.Config.JunkIdleCheck or 0
    if #queue > 0 then junk.Share = junk.Measure(queue) end
    return #queue
end

---@return Tool|nil  next egg tool still in the bag
function Theseus.Junk.NextTool()
    local junk = Theseus.Junk
    local stale = os.clock() - junk.BuiltAt > Theseus.Config.JunkQueueTtl
    if junk.Cursor > #junk.Queue or stale then
        if os.clock() < junk.EmptyUntil then return nil end
        junk.Build()
    end

    while junk.Cursor <= #junk.Queue do
        local tool = junk.Queue[junk.Cursor][1]
        junk.Cursor += 1
        if tool.Parent ~= nil and tool ~= junk.Held then return tool end
    end
    return nil
end

---@return table<string, number>  share of hatches per pet rarity from the eggs at the head of the queue
function Theseus.Junk.Measure(queue)
    local counts, total = {}, math.min(#queue, Theseus.Config.JunkShareSample)
    for index = 1, total do
        local name = queue[index][2]
        counts[name] = (counts[name] or 0) + 1
    end

    local mult, share = Theseus.EggIndex.LuckMult(), {}
    for name, count in pairs(counts) do
        for _, pair in ipairs(Theseus.GameLib.Odds(name, mult) or {}) do
            local pet = Theseus.GameLib.PetInfo[pair[1]]
            if pet then share[pet.rarity] = (share[pet.rarity] or 0) + pair[2] * count / total end
        end
    end
    return share
end

---@return table<string, number>  last measured share per pet rarity, built on first use
function Theseus.Junk.Distribution()
    local junk = Theseus.Junk
    if junk.BuiltAt == -math.huge then junk.Build() end
    return junk.Share
end

---@return table  { [rarity] = true } pet rarities Clear Junk Eggs sells
function Theseus.Junk.SellSet()
    local picked = Theseus.Util.Opt("JunkSellPets")
    if type(picked) == "table" and next(picked) then return picked end

    local rank, ceiling = Theseus.GameLib.RarityRank, 0
    for rarity, share in pairs(Theseus.Junk.Distribution()) do
        if share >= Theseus.Config.JunkAutoShare then ceiling = math.max(ceiling, rank[rarity] or 0) end
    end
    if ceiling == 0 then return Theseus.Junk.Set() end

    local set = {}
    for _, rarity in ipairs(Theseus.GameLib.RarityOrder) do
        if (rank[rarity] or math.huge) <= ceiling then set[rarity] = true end
    end
    return set
end

function Theseus.Junk.WarnMismatch()
    local picked = Theseus.Util.Opt("JunkSellPets")
    if type(picked) ~= "table" or not next(picked) then return end

    local share = Theseus.Junk.Distribution()
    if not next(share) then return end
    for rarity, chance in pairs(share) do
        if picked[rarity] and chance >= 0.01 then return end
    end
    Theseus.Util.Notify("Clear Junk Eggs", "Your junk eggs do not give the pet rarities you picked to sell", 8)
end

---@return integer  junk eggs growing on the plot
function Theseus.Junk.PlotJunk()
    local set, count = Theseus.Junk.Set(), 0
    for _, plotEgg in pairs(Theseus.State.PlotEggs) do
        local info = Theseus.GameLib.EggInfo[plotEgg.egg or ""]
        if info and set[info.rarity] then count += 1 end
    end
    return count
end

---@return boolean  a junk hatch was sent and its answer has not come back
function Theseus.Junk.HatchInFlight()
    local now = os.clock()
    for key in pairs(Theseus.State.PlotEggs) do
        if (Theseus.Hatch.Pending[key] or 0) > now then return true end
    end
    return false
end

---@return boolean  there is something to plant, hatch or sell
function Theseus.Junk.HasWork()
    local junk = Theseus.Junk
    if junk.PlotJunk() > 0 or junk.Fresh >= Theseus.Config.JunkSellEvery then return true end
    if Theseus.Hatch.JunkRoom() == 0 then return false end
    if junk.Cursor <= #junk.Queue then return true end
    if os.clock() < junk.EmptyUntil then return false end
    return junk.Build() > 0
end

---@return boolean  value eggs may hatch now, unless the player holds them for a luck boost
local function ValueHatchOpen()
    if not Theseus.Util.Opt("HoldHatchBoost") then return true end
    return Theseus.Hatch.BoostActive()
end

---@return boolean  growth has finished on a junk egg, or on any egg while value hatching is open
function Theseus.Junk.Due(key, plotEgg, set, now)
    local junk = Theseus.Junk
    local info = Theseus.GameLib.EggInfo[plotEgg.egg or ""]
    if not info then return false end
    if not set[info.rarity] and not ValueHatchOpen() then return false end
    if (Theseus.Hatch.Pending[key] or 0) > now then return false end

    local readyAt = Theseus.Hatch.ReadyAt(plotEgg)
    return readyAt ~= nil and now >= readyAt + junk.Slack
end

function Theseus.Junk.Fire(remote, key, now)
    local junk, plotEgg = Theseus.Junk, Theseus.State.PlotEggs[key]
    if not plotEgg then return end

    if plotEgg.fired then
        junk.Retries += 1
        junk.Slack = math.min(junk.Slack + 0.01, Theseus.Config.JunkHatchSlackMax)
        junk.HatchGap = math.min(junk.HatchGap * 2 + Theseus.Config.JunkHatchGapStep, Theseus.Config.JunkHatchGapMax)
    end
    plotEgg.fired = true
    Theseus.Hatch.Pending[key] = now + Theseus.Config.JunkHatchRetry
    remote:FireServer({ EggKey = key })
end

---@return integer  hatch fires sent
function Theseus.Junk.HatchReady()
    local junk, remote = Theseus.Junk, Theseus.GameLib.Remote("Hatch")
    if not remote then return 0 end

    local set, now, keys = junk.Set(), os.clock(), {}
    for key, plotEgg in pairs(Theseus.State.PlotEggs) do
        if junk.Due(key, plotEgg, set, now) then keys[#keys + 1] = key end
    end
    for index, key in ipairs(keys) do
        if index > 1 and junk.HatchGap > 0 then task.wait(junk.HatchGap) end
        junk.Fire(remote, key, os.clock())
    end
    return #keys
end

function Theseus.Junk.OnHatched()
    local junk = Theseus.Junk
    junk.Hatched += 1
    junk.Fresh += 1
    table.insert(junk.Window, os.clock())
end

---@return Tool|nil  egg tool now in hand
function Theseus.Junk.Prime()
    local junk, hum = Theseus.Junk, Theseus.Player.Humanoid
    local tool = junk.NextTool()
    if not tool or not hum then return nil end

    hum:EquipTool(tool)
    junk.Held, junk.EquippedAt = tool, os.clock()
    return tool
end

---@return boolean  the egg is the only tool in hand
function Theseus.Junk.HandHolds(tool)
    local char = Theseus.Player.Char
    if not char or tool.Parent ~= char then return false end
    for _, child in ipairs(char:GetChildren()) do
        if child ~= tool and child:IsA("Tool") then return false end
    end
    return true
end

---@return Tool|nil  egg tool in hand and settled; a pet that landed in the hand is swapped back out
function Theseus.Junk.Ready(token)
    local junk, hum = Theseus.Junk, Theseus.Player.Humanoid
    local held = junk.Held
    if held and held.Parent == nil then
        held = nil
        junk.Held = nil
    end
    if held and hum and not junk.HandHolds(held) then
        hum:UnequipTools()
        hum:EquipTool(held)
        junk.EquippedAt = os.clock()
    end
    held = held or junk.Prime()
    if not held then return nil end

    local fireAt = math.max(junk.EquippedAt + Theseus.Config.JunkEquipSettle, junk.LastFire + junk.Spacing)
    return junk.Pause(token, fireAt, held) and held or nil
end

---@return boolean  reached the moment with a clean hand, the token, and no hatch sent
function Theseus.Junk.Pause(token, untilAt, held)
    local junk = Theseus.Junk
    while os.clock() < untilAt do
        if junk.HatchReady() > 0 or not junk.HandHolds(held) then return false end
        if not junk.Frame(token) then return false end
    end
    return junk.HandHolds(held)
end

function Theseus.Junk.Ease()
    local junk, cfg = Theseus.Junk, Theseus.Config
    junk.Calm += 1
    if junk.Calm < cfg.JunkSpacingEase then return end
    junk.Calm = 0
    junk.Spacing = math.max(cfg.JunkSpacingMin, junk.Spacing - cfg.JunkSpacingDown)
end

function Theseus.Junk.Harden()
    local junk, cfg = Theseus.Junk, Theseus.Config
    junk.Calm = 0
    junk.PlantFails += 1
    junk.Spacing = math.min(cfg.JunkSpacingMax, junk.Spacing + cfg.JunkSpacingUp)
end

function Theseus.Junk.OnFull()
    local junk, hatch = Theseus.Junk, Theseus.Hatch
    junk.FullUntil = os.clock() + Theseus.Config.JunkFullPause
    hatch.RequestSnapshot()
end

---@return boolean  the server placed the egg
function Theseus.Junk.Settled(replied, before, tool)
    local junk, hatch = Theseus.Junk, Theseus.Hatch
    if replied and hatch.LastPlaced ~= before then
        junk.PlantFails = 0
        junk.Planted += 1
        junk.ActiveAt = os.clock()
        junk.Ease()
        junk.Held = nil
        junk.Prime()
        return true
    end
    if replied then
        junk.OnFull()
        return false
    end
    if tool.Parent == nil then
        hatch.RequestSnapshot()
    elseif not junk.HandHolds(tool) then
        junk.Held = tool
    else
        junk.Harden()
    end
    return false
end

---@return boolean  the server placed an egg
function Theseus.Junk.PlantOne(token, bp)
    local junk, hatch = Theseus.Junk, Theseus.Hatch
    local tool, remote = junk.Ready(token), Theseus.GameLib.Remote("EggPlaced")
    local spot = hatch.Spots(bp, 1)[1]
    if not tool or not remote or not spot then return false end
    if not junk.HandHolds(tool) then return false end

    local before = hatch.LastPlaced
    hatch.CapHit = false
    junk.LastFire = os.clock()
    remote:FireServer({ PlantPosition = spot })
    local replied = function() return hatch.LastPlaced ~= before or hatch.CapHit end
    local ok = Theseus.Tasks.Await(token, replied, Theseus.Config.JunkPlantTimeout)
    return junk.Settled(ok, before, tool)
end

---@return boolean  token still held after one frame
function Theseus.Junk.Frame(token)
    local _, why = Theseus.Tasks.Await(token, nil, 0)
    return why == "timeout"
end

---@return boolean  the run may go on
function Theseus.Junk.Alive(token)
    if not Theseus.Util.Opt("ClearJunk") then return false end
    if Theseus.Tasks.Carrying() or not Theseus.Player:IsAlive() then return false end
    return Theseus.Tasks.Holds(token)
end

---@return integer  eggs planted this pass
function Theseus.Junk.PlantFree(token, bp)
    local junk, planted = Theseus.Junk, 0
    while Theseus.Hatch.JunkRoom() > 0 and os.clock() >= junk.FullUntil and not junk.HatchInFlight() and junk.Alive(token) do
        if not junk.PlantOne(token, bp) then break end
        planted += 1
    end
    return planted
end

---@return boolean  standing at the anchor
function Theseus.Junk.Goto(token, where)
    local junk, hrp = Theseus.Junk, Theseus.Player.Root
    local stand
    if where == "seller" then
        stand = Theseus.Sell.Stand()
    else
        stand = Theseus.Pets.PlotStand()
    end
    if not stand or not hrp then return false end
    if (hrp.Position - stand.Position).Magnitude <= Theseus.Config.JunkAnchorNear then return true end
    if not Theseus.Tasks.Teleport(token, stand) then return false end

    local _, why = Theseus.Tasks.Await(token, nil, Theseus.Config.SellSettle)
    return why == "timeout"
end

---@return boolean  ready to plant
function Theseus.Junk.Enter(token)
    local junk = Theseus.Junk
    junk.Spacing = Theseus.Config.JunkSpacing
    Theseus.Eggs.QuietInventory(true)
    if Theseus.Player:Riding() then
        Theseus.Player:Release()
        Theseus.Tasks.Await(token, function() return not Theseus.Player:Riding() end, Theseus.Config.MountTimeout)
    end
    if junk.Anchor == "seller" and not Theseus.Sell.Stand() then junk.Anchor = "plot" end

    if not junk.Goto(token, junk.Anchor) then return false end
    junk.ActiveAt = os.clock()
    junk.WarnMismatch()
    return true
end

---@return integer  pets sold
function Theseus.Junk.Sell(token)
    local junk = Theseus.Junk
    junk.Selling, junk.Fresh = true, 0
    local ok, sold = pcall(Theseus.Sell.Run, token, true)
    junk.Selling = false
    if not ok then error(sold, 0) end

    junk.Sold += sold
    return sold
end

function Theseus.Junk.Dispatch(token)
    local junk = Theseus.Junk
    if junk.Anchor == "seller" then
        task.spawn(Theseus.Util.Try, "junk sell", junk.Sell, token)
        return
    end
    Theseus.Util.Try("junk sell", junk.Sell, token)
    junk.Goto(token, "plot")
end

function Theseus.Junk.Resync()
    local junk = Theseus.Junk
    if os.clock() - junk.ActiveAt < Theseus.Config.JunkResyncIdle then return end
    junk.ActiveAt = os.clock()
    Theseus.Hatch.RequestSnapshot()
end

function Theseus.Junk.Progress(token)
    local junk = Theseus.Junk
    if not junk.Selling and junk.Fresh >= Theseus.Config.JunkSellEvery then junk.Dispatch(token) end
    junk.Resync()
    if os.clock() - junk.ReportAt >= Theseus.Config.JunkReportGap then junk.Report() end
end

---@return boolean  planting keeps failing and the run should end
function Theseus.Junk.Stuck(token)
    local junk = Theseus.Junk
    if junk.PlantFails < Theseus.Config.JunkPlantFails then return false end
    junk.PlantFails = 0
    if junk.Anchor == "seller" then
        junk.Anchor = "plot"
        return not junk.Goto(token, "plot")
    end
    junk.BackoffUntil = os.clock() + Theseus.Config.JunkBackoff
    junk.Report("Server is not taking eggs, retrying soon")
    return true
end

---@return boolean  other jobs are waiting for the character
function Theseus.Junk.Yielding()
    for _, idx in ipairs(Theseus.Config.JunkYieldTo) do
        if Theseus.Util.Opt(idx) == true then return true end
    end
    return false
end

---@return boolean  the run should end
function Theseus.Junk.Finished(token, started)
    local junk, now = Theseus.Junk, os.clock()
    if junk.Stuck(token) then return true end
    if now - started > Theseus.Config.JunkSessionMax and junk.Yielding() then
        junk.YieldUntil = now + Theseus.Config.JunkYieldGap
        return true
    end
    return not junk.HasWork()
end

---@return boolean  something was hatched or planted
function Theseus.Junk.Pulse(token, bp)
    local junk = Theseus.Junk
    local hatched = junk.HatchReady()
    local planted = junk.PlantFree(token, bp)
    if hatched + planted > 0 then junk.ActiveAt = os.clock() end
    junk.Progress(token)
    return hatched + planted > 0
end

function Theseus.Junk.Leave(token)
    local junk, hum = Theseus.Junk, Theseus.Player.Humanoid
    Theseus.Tasks.Await(token, function() return not junk.Selling end, Theseus.Config.SellReplyTimeout)
    if junk.Alive(token) and junk.Fresh > 0 and not junk.HasWork() then
        Theseus.Util.Try("junk sell", junk.Sell, token)
    end

    junk.Held = nil
    if hum and hum.Parent and Theseus.Player:BasketCount() == 0 then hum:UnequipTools() end
    Theseus.Mount.Dirty = true
    junk.Report()
end

function Theseus.Junk.Run(token)
    local junk = Theseus.Junk
    local _, bp = Theseus.Player:Plot()
    if not bp or not junk.Enter(token) then return end

    local started = os.clock()
    while junk.Alive(token) do
        junk.Pulse(token, bp)
        if junk.Finished(token, started) or not junk.Frame(token) then break end
    end
    junk.Leave(token)
end

function Theseus.Junk.Bind()
    local junk = Theseus.Junk
    if junk.Bound then return end
    junk.Bound = true
    Theseus.Hatch.Bind()
    Theseus.Sell.Bind()
    Theseus.Hatch.Signal:Connect(junk.OnHatched)
end

---@return boolean  a run may start now
function Theseus.Junk.CanRun()
    local junk, now = Theseus.Junk, os.clock()
    if now < junk.BackoffUntil or now < junk.YieldUntil then return false end
    if Theseus.Tasks.Carrying() or not Theseus.Player:IsAlive() then return false end
    return junk.HasWork()
end

function Theseus.Junk.Step()
    if not Theseus.Util.Opt("ClearJunk") then return end
    local junk = Theseus.Junk
    junk.Bind()
    junk.HatchReady()
    if not junk.CanRun() then
        if junk.PlotJunk() > 0 then return end
        junk.Report(Theseus.Hatch.Room() == 0 and "Plot is full" or "Nothing to clear right now")
        return
    end

    local token = Theseus.Tasks.Request("Junk", Theseus.Tasks.Prio.Plot)
    if not token then
        junk.Report("Waiting for the egg run")
        return
    end

    junk.Running = true
    local ok, err = pcall(junk.Run, token)
    junk.Running = false
    Theseus.Tasks.Release(token)
    if not ok then error(err, 0) end
end

function Theseus.Junk.SellNow()
    Theseus.Junk.Bind()
    local sold = Theseus.Pets.WithToken("Sell", Theseus.Tasks.Prio.Travel, function(token)
        return Theseus.Sell.Run(token, true)
    end) or 0
    Theseus.Util.Notify("Clear Junk Eggs", sold > 0 and ("Sold " .. sold .. " pets") or "No junk pets to sell", 4)
    return sold
end

function Theseus.Junk.Start()
    Theseus.Junk.Bind()
end

function Theseus.Junk.Stop()
    local junk = Theseus.Junk
    junk.Report("Off")
end

function Theseus.Junk.Status()
    return Theseus.State.Status.Junk or "Off"
end

Theseus.Pets = {
    Bound = false,
    Index = {},
    Holders = {},
    Placed = {},
    Top = {},
    TopAt = 0,
    Collected = 0,
    Swaps = 0,
    Fed = 0,
    Kept = {},
}

function Theseus.Pets.IsOurs(owner)
    return owner == nil or owner == LocalPlayer or owner == LocalPlayer.UserId or owner == LocalPlayer.Name
end

function Theseus.Pets.SetStatus(text)
    Theseus.State.Status.Pets = text
end

---@return any  SavedData value, nil when missing
function Theseus.Pets.Saved(name)
    local saved = LocalPlayer:FindFirstChild("SavedData")
    local value = saved and saved:FindFirstChild(name)
    return value and value.Value
end

---@return number  leaderstats Income/s
function Theseus.Pets.IncomeRate()
    local stats = LocalPlayer:FindFirstChild("leaderstats")
    local value = stats and stats:FindFirstChild("Income/s")
    return value and tonumber(value.Value) or 0
end

function Theseus.Pets.MaxSlots()
    local fromAttr = tonumber(LocalPlayer:GetAttribute("MaxPets"))
    return fromAttr or tonumber(Theseus.Pets.Saved("MaxPets")) or 5
end

---@return number  weight after the game's age bonus
function Theseus.Pets.AgedWeight(kg, age)
    local aging = Theseus.GameLib.Svc.PetAging
    if not age or type(aging) ~= "table" then return kg end
    local ok, aged = Theseus.GameLib.Call(aging.WeightFor, kg, age)
    return ok and tonumber(aged) or kg
end

---@param row table  PetName, BaseWeight, Weight, BirthTime
---@return number|nil  age the game shows for this BirthTime
function Theseus.Pets.AgeFrom(row)
    local aging = Theseus.GameLib.Svc.PetAging
    if not tonumber(row.BirthTime) or type(aging) ~= "table" then return nil end
    local ok, age = Theseus.GameLib.Call(aging.StateFrom, row.BirthTime, Theseus.Util.ServerNow(), row)
    return ok and tonumber(age) or nil
end

---@return number  display income per second, before rebirth and friend bonus
function Theseus.Pets.Income(pet)
    local info = Theseus.GameLib.PetInfo[pet.name or ""]
    if not info then return 0 end

    local mutations = Theseus.GameLib.Mutations
    local factor = (mutations[pet.mutation or ""] or 1) * (mutations[pet.spawnMutation or ""] or 1)
    local kg = pet.baseWeight and pet.age and Theseus.Pets.AgedWeight(pet.baseWeight, pet.age)
        or Theseus.Pets.AgedWeight(pet.weight or Theseus.Config.PetBaseKg, pet.age)
    return math.floor(math.floor((info.income or 0) * kg / 10) * factor)
end

---@param src  Instance|table  pet Tool or a PlacePet reply
---@return table  pet record
function Theseus.Pets.Record(src, placed)
    local isTool = typeof(src) == "Instance"
    local attrs = isTool and src:GetAttributes() or src

    local name = attrs.PetName or (isTool and src.Name) or nil
    local pet = {
        key = attrs.PetKey,
        name = name,
        weight = tonumber(attrs.Weight) or tonumber(attrs.BaseWeight),
        mutation = attrs.Mutation,
        spawnMutation = attrs.SpawnMutation,
        baseWeight = tonumber(attrs.BaseWeight),
        birthTime = tonumber(attrs.BirthTime),
        age = tonumber(attrs.Age),
        favorite = attrs.Favorited == true,
        placed = placed,
        tool = isTool and src or nil,
        pos = placed and attrs.Position or nil,
        collectTime = tonumber(attrs.CollectTime),
        at = os.clock(),
    }
    if not pet.age and pet.birthTime then
        pet.age = Theseus.Pets.AgeFrom({ PetName = name, BaseWeight = pet.baseWeight, Weight = pet.weight, BirthTime = pet.birthTime })
    end
    pet.ageKnown = pet.age ~= nil
    pet.mutated = (pet.mutation ~= nil and pet.mutation ~= "") or (pet.spawnMutation ~= nil and pet.spawnMutation ~= "")
    pet.income = Theseus.Pets.Income(pet)
    local info = Theseus.GameLib.PetInfo[name or ""]
    pet.speed = info and info.speed or 0
    pet.rarity = info and info.rarity
    return pet
end

---@param reply table  PlacePet.OnClientEvent payload
function Theseus.Pets.OnPlace(reply)
    if type(reply) ~= "table" or not Theseus.Pets.IsOurs(reply.Owner) then return end
    if reply.Action == "Remove" then
        if type(reply.PetKey) == "string" then
            Theseus.Pets.Placed[reply.PetKey] = nil
        else
            table.clear(Theseus.Pets.Placed)
        end
    elseif reply.Action == "Place" and reply.PetKey then
        Theseus.Pets.Placed[reply.PetKey] = Theseus.Pets.Record(reply, true)
    end
    Theseus.Pets.TopAt = 0
end

function Theseus.Pets.OnCollect(reply)
    if type(reply) ~= "table" or not Theseus.Pets.IsOurs(reply.Owner) then return end
    local keys = type(reply.PetKeys) == "table" and reply.PetKeys or { reply.PetKey }
    for _, key in pairs(keys) do
        local pet = Theseus.Pets.Placed[key]
        if pet then pet.collectTime = tonumber(reply.CollectTime) or Theseus.Util.ServerNow() end
    end
end

function Theseus.Pets.OnFed(reply)
    if type(reply) ~= "table" or not Theseus.Pets.IsOurs(reply.Owner) then return end
    Theseus.Pets.FedAt = os.clock()
    local pet = Theseus.Pets.Placed[reply.PetKey or ""]
    if not pet then return end
    pet.weight = tonumber(reply.Weight) or pet.weight
    if tonumber(reply.BirthTime) then
        pet.birthTime = tonumber(reply.BirthTime)
        pet.age = Theseus.Pets.AgeFrom({ PetName = pet.name, BaseWeight = pet.baseWeight, Weight = pet.weight, BirthTime = pet.birthTime }) or pet.age
    end
    pet.income = Theseus.Pets.Income(pet)
end

function Theseus.Pets.SeedFromRenderer()
    local scripts = LocalPlayer:FindFirstChild("PlayerScripts")
    local module = scripts and scripts:FindFirstChild("PetRenderer", true)
    local renderer = module and Theseus.GameLib.Require(module)
    if type(renderer) ~= "table" or type(renderer.GetAll) ~= "function" then return end

    local ok, all = Theseus.GameLib.Call(renderer.GetAll)
    if not ok or type(all) ~= "table" then return end
    for _, entry in pairs(all) do
        if type(entry) ~= "table" or not entry.PetKey then continue end
        if entry.OwnerUserId ~= LocalPlayer.UserId then continue end

        local model = typeof(entry.Model) == "Instance" and entry.Model or nil
        local pos = entry.Position
        if typeof(pos) ~= "Vector3" and model and model:IsA("Model") then pos = model:GetPivot().Position end
        local row = setmetatable({ PetName = entry.PetName or (model and model.Name), Position = pos }, {
            __index = function(_, key)
                local value = entry[key]
                if value == nil and model then value = model:GetAttribute(key) end
                return value
            end,
        })
        Theseus.Pets.Placed[entry.PetKey] = Theseus.Pets.Record(row, true)
    end
end

function Theseus.Pets.Bind()
    if Theseus.Pets.Bound then return end
    Theseus.Pets.Bound = true

    local place = Theseus.GameLib.Remote("PlacePet")
    if place then Theseus:Connect(place.OnClientEvent, Theseus.Pets.OnPlace) end
    local collect = Theseus.GameLib.Remote("PetCollect")
    if collect then Theseus:Connect(collect.OnClientEvent, Theseus.Pets.OnCollect) end
    local fed = Theseus.GameLib.Remote("PetFed")
    if fed then Theseus:Connect(fed.OnClientEvent, Theseus.Pets.OnFed) end

    Theseus.Util.Try("pets seed", Theseus.Pets.SeedFromRenderer)
    table.insert(Theseus.State.Connections, Theseus.Pets.Unbind)
    Theseus.Pets.WatchHolders(LocalPlayer.Character)
    Theseus:Connect(LocalPlayer.CharacterAdded, function(char)
        task.defer(Theseus.Util.Try, "pets rebind", Theseus.Pets.WatchHolders, char)
    end)
end

function Theseus.Pets.Unbind()
    for _, entry in pairs(Theseus.Pets.Index) do entry.conn:Disconnect() end
    table.clear(Theseus.Pets.Index)
    table.clear(Theseus.Pets.Holders)
end

function Theseus.Pets.Held(inst)
    local parent = inst.Parent
    return parent ~= nil and Theseus.Pets.Holders[parent] ~= nil
end

function Theseus.Pets.Track(tool)
    local index = Theseus.Pets.Index
    if index[tool] or not tool:IsA("Tool") or not tool:GetAttribute("PetKey") then return end

    local entry = { name = tool:GetAttribute("PetName") or tool.Name }
    entry.conn = tool.AttributeChanged:Connect(function(attr)
        if Theseus.Config.PetWatchedAttrs[attr] then entry.rec = nil end
    end)
    index[tool] = entry
end

function Theseus.Pets.Untrack(tool)
    local entry = Theseus.Pets.Index[tool]
    if not entry or Theseus.Pets.Held(tool) then return end
    entry.conn:Disconnect()
    Theseus.Pets.Index[tool] = nil
end

function Theseus.Pets.Watch(holder)
    if not holder or Theseus.Pets.Holders[holder] then return end
    Theseus.Pets.Holders[holder] = {
        Theseus:Connect(holder.ChildAdded, Theseus.Pets.Track),
        Theseus:Connect(holder.ChildRemoved, function(child) task.defer(Theseus.Pets.Untrack, child) end),
    }
    for _, child in ipairs(holder:GetChildren()) do Theseus.Pets.Track(child) end
end

---@param char Model|nil  current character; the old character and Backpack stop being watched
function Theseus.Pets.WatchHolders(char)
    local bag = LocalPlayer:FindFirstChildOfClass("Backpack") or LocalPlayer:WaitForChild("Backpack", Theseus.Config.LoadTimeout)
    for holder, conns in pairs(Theseus.Pets.Holders) do
        if holder == bag or holder == char then continue end
        for _, conn in ipairs(conns) do conn:Disconnect() end
        Theseus.Pets.Holders[holder] = nil
    end

    Theseus.Pets.Watch(bag)
    Theseus.Pets.Watch(char)
    for tool in pairs(Theseus.Pets.Index) do Theseus.Pets.Untrack(tool) end
end

---@return table  cached record, rebuilt after a watched attribute changed or the age went stale
function Theseus.Pets.ToolRecord(tool, entry)
    local rec = entry.rec
    if rec and not (rec.birthTime and os.clock() - rec.at > Theseus.Config.PetAgeRefresh) then return rec end
    rec = Theseus.Pets.Record(tool, false)
    entry.rec = rec
    return rec
end

---@return table<string, Tool>  pet name -> one held tool of that pet
function Theseus.Pets.ToolsByName()
    Theseus.Pets.Bind()
    local found = {}
    for tool, entry in pairs(Theseus.Pets.Index) do
        local name = entry.name
        if name and not found[name] and Theseus.GameLib.PetInfo[name] then found[name] = tool end
    end
    return found
end

---@return Tool|nil  one held tool of that pet
function Theseus.Pets.ToolNamed(name)
    Theseus.Pets.Bind()
    for tool, entry in pairs(Theseus.Pets.Index) do
        if entry.name == name then return tool end
    end
    return nil
end

---@return table[]  fresh list, safe to sort; records are shared, do not edit them
function Theseus.Pets.Owned()
    Theseus.Pets.Bind()
    local list = {}
    for tool, entry in pairs(Theseus.Pets.Index) do
        list[#list + 1] = Theseus.Pets.ToolRecord(tool, entry)
    end
    for _, pet in pairs(Theseus.Pets.Placed) do
        table.insert(list, pet)
    end
    return list
end

---@return string|nil  key of the pet we ride right now
function Theseus.Pets.RideKey()
    if not Theseus.Player:Riding() then return nil end
    local char = Theseus.Player.Char
    local tool = char and char:FindFirstChildOfClass("Tool")
    return tool and tool:GetAttribute("PetKey") or nil
end

function Theseus.Pets.IsRide(pet)
    if pet.tool and pet.tool.Parent == Theseus.Player.Char and Theseus.Player:Riding() then return true end
    local rideKey = Theseus.Pets.RideKey()
    return rideKey ~= nil and rideKey == pet.key
end

---@return table<string, true>  pet names some unfinished rebirth still needs
function Theseus.Pets.RebirthNeeds()
    local done = tonumber(Theseus.Pets.Saved("Rebirths")) or 0
    local needs = {}
    for step, req in pairs(Theseus.GameLib.RebirthReq or {}) do
        local index = tonumber(step)
        if type(step) == "string" and not index then
            if (tonumber(req) or math.huge) > done then needs[step] = true end
            continue
        end
        if not index or index <= done then continue end
        if type(req) == "string" then needs[req] = true end
        if type(req) == "table" then
            for _, name in pairs(req) do
                if type(name) == "string" then needs[name] = true end
            end
        end
    end
    return needs
end

---@return table<string, true>  keys of the placed pets that earn the most
function Theseus.Pets.TopPlaced()
    local now = os.clock()
    if now - Theseus.Pets.TopAt < Theseus.Config.TopCacheSec then return Theseus.Pets.Top end

    local placed = {}
    for _, pet in pairs(Theseus.Pets.Placed) do placed[#placed + 1] = pet end
    table.sort(placed, function(a, b) return a.income > b.income end)

    local top = {}
    for i = 1, math.min(#placed, Theseus.Pets.MaxSlots()) do top[placed[i].key] = true end
    Theseus.Pets.Top, Theseus.Pets.TopAt = top, now
    return top
end

---@return boolean, string|nil  protected, why
function Theseus.Pets.Protected(pet, needs)
    if pet.favorite then return true, "favorite" end

    local list = Theseus.Util.Opt("ProtectList")
    if type(list) == "table" and (list[pet.name or ""] or list[pet.key or ""]) then return true, "protect list" end

    needs = needs or Theseus.Pets.RebirthNeeds()
    if needs[pet.name or ""] then return true, "rebirth" end
    if Theseus.Pets.IsRide(pet) then return true, "ride pet" end
    if pet.name and (Theseus.Mount.Choice() == pet.name or Theseus.Mount.Name == pet.name) then return true, "ride pet" end

    local fusion = Theseus.Fusion
    if fusion and fusion.Inputs and fusion.Inputs[pet.key or ""] then return true, "fusion" end
    if pet.placed and Theseus.Pets.TopPlaced()[pet.key or ""] then return true, "placed" end
    return false
end

---@return CFrame|nil, BasePart|nil  a point on our baseplate, the baseplate
function Theseus.Pets.PlotStand()
    local _, bp = Theseus.Player:Plot()
    if not bp then return nil end
    return CFrame.new(bp.Position + Vector3.new(0, bp.Size.Y / 2 + Theseus.Geo.Lift(Config.PetStandLift), 0)), bp
end

---@return Vector3  random spot on the baseplate surface
function Theseus.Pets.Spot(bp)
    local spread = Theseus.Config.PetSpread
    local offset = Vector3.new((math.random() * 2 - 1) * bp.Size.X * spread, bp.Size.Y / 2 + 1, (math.random() * 2 - 1) * bp.Size.Z * spread)
    return (bp.CFrame * CFrame.new(offset)).Position
end

---@param fn fun(token: table): any
---@return any  fn result, nil when no token was granted
function Theseus.Pets.WithToken(owner, prio, fn)
    local token = Theseus.Tasks.Request(owner, prio)
    if not token then return nil end
    local ok, out = pcall(fn, token)
    Theseus.Tasks.Release(token)
    if not ok then error(out, 0) end
    return out
end

---@return table[], table[]  unplaced candidates best first, placed pets worst first
function Theseus.Pets.SwapPlan()
    local unplaced, placed = {}, {}
    local mount = Theseus.Mount.Best()
    local rideKept = false
    for _, pet in ipairs(Theseus.Pets.Owned()) do
        if pet.placed then
            if pet.ageKnown then placed[#placed + 1] = pet end
        elseif Theseus.Pets.IsRide(pet) then
            rideKept = true
        elseif pet.key and pet.income > 0 then
            table.insert(unplaced, pet)
        elseif pet.name == mount then
            rideKept = true
        end
    end
    table.sort(unplaced, function(a, b) return a.income > b.income end)
    table.sort(placed, function(a, b) return a.income < b.income end)

    if mount and not rideKept then
        for i = #unplaced, 1, -1 do
            if unplaced[i].name == mount then
                table.remove(unplaced, i)
                break
            end
        end
    end
    return unplaced, placed
end

---@return boolean  the server confirmed the change
function Theseus.Pets.AwaitPlaced(token, key, present)
    return (Theseus.Tasks.Await(token, function()
        return (Theseus.Pets.Placed[key] ~= nil) == present
    end, Theseus.Config.PetReplyTimeout))
end

---@param worst table|nil  placed pet to pick up first
---@return boolean  pet is placed; a failed place puts worst back
function Theseus.Pets.Swap(token, pet, worst, bp)
    local placeRemote, pickRemote = Theseus.GameLib.Remote("PlacePet"), Theseus.GameLib.Remote("PickupPet")
    token.critical = true

    if worst then
        pickRemote:FireServer(worst.key)
        if not Theseus.Pets.AwaitPlaced(token, worst.key, false) then
            token.critical = false
            return false
        end
    end

    placeRemote:FireServer(pet.key, Theseus.Pets.Spot(bp))
    local ok = Theseus.Pets.AwaitPlaced(token, pet.key, true)
    if not ok and worst then
        placeRemote:FireServer(worst.key, worst.pos or Theseus.Pets.Spot(bp))
        Theseus.Pets.AwaitPlaced(token, worst.key, true)
    end
    token.critical = false
    return ok
end

---@return integer  pets placed or swapped
function Theseus.Pets.PlaceBest(token)
    local placeRemote, pickRemote = Theseus.GameLib.Remote("PlacePet"), Theseus.GameLib.Remote("PickupPet")
    local stand, bp = Theseus.Pets.PlotStand()
    if not placeRemote or not pickRemote or not stand then return 0 end

    local unplaced, placed = Theseus.Pets.SwapPlan()
    local free = Theseus.Pets.MaxSlots() - #placed
    for i = #placed, 1, -1 do
        if Theseus.Pets.Kept[placed[i].key or ""] then table.remove(placed, i) end
    end
    if not unplaced[1] then return 0 end
    if free <= 0 and (not placed[1] or unplaced[1].income <= placed[1].income * Theseus.Config.PetSwapGain) then return 0 end
    if not Theseus.Tasks.Teleport(token, stand) then return 0 end

    local changed, swapped = 0, {}
    local before = Theseus.Pets.IncomeRate()
    for _, pet in ipairs(unplaced) do
        if not Theseus.Tasks.Holds(token) then break end
        local worst
        if free <= 0 then
            worst = placed[1]
            if not worst or pet.income <= worst.income * Theseus.Config.PetSwapGain then break end
        end
        local ok = Theseus.Pets.Swap(token, pet, worst, bp)
        if not ok then break end
        if worst then
            table.remove(placed, 1)
            table.insert(swapped, { pet, worst })
        else
            free -= 1
        end
        changed += 1
    end
    if #swapped > 0 then changed -= Theseus.Pets.GuardIncome(token, before, swapped, bp) end

    Theseus.Pets.Swaps += changed
    if changed > 0 then Theseus.Mount.Dirty = true end
    return changed
end

---@param swapped table[]  { placed, pickedUp } pairs, undone newest first
---@return integer           swaps undone because Income/s went down
function Theseus.Pets.GuardIncome(token, before, swapped, bp)
    Theseus.Tasks.Await(token, nil, Theseus.Config.IncomeSettle)
    local after = Theseus.Pets.IncomeRate()
    if after >= before then return 0 end

    local undone = 0
    for i = #swapped, 1, -1 do
        local pair = swapped[i]
        Theseus.Pets.Kept[pair[2].key] = true
        if not Theseus.Tasks.Holds(token) then break end
        if Theseus.Pets.Swap(token, pair[2], Theseus.Pets.Placed[pair[1].key] or pair[1], bp) then undone += 1 end
    end
    warn(Theseus.Config.Tag, "place best: income " .. before .. " -> " .. after .. ", undid " .. undone)
    return undone
end

---@return boolean  the game collects on its own (pass owned)
function Theseus.Pets.GameCollects()
    if LocalPlayer:GetAttribute("AutoCollectCash") == true then return true end
    local passes = tostring(Theseus.Pets.Saved("OwnedPasses") or "")
    for _, mark in ipairs(Theseus.Config.AutoCollectPass) do
        if passes:find(mark, 1, true) then return true end
    end
    return false
end

---@return number  seconds of income waiting on this pet
function Theseus.Pets.PendingSec(pet)
    if not pet.collectTime then return math.huge end
    return Theseus.Util.ServerNow() - pet.collectTime
end

---@param force boolean  ignore the pending threshold
---@return integer  collect fires sent
function Theseus.Pets.Collect(token, force)
    local remote = Theseus.GameLib.Remote("PetCollect")
    if not remote then return 0 end

    local fired = 0
    for key, pet in pairs(Theseus.Pets.Placed) do
        if not Theseus.Tasks.Holds(token) then break end
        if not force and Theseus.Pets.PendingSec(pet) < Theseus.Config.CollectMinPending then continue end
        if typeof(pet.pos) ~= "Vector3" then continue end
        if not Theseus.Tasks.Teleport(token, CFrame.new(pet.pos + Vector3.new(0, Theseus.Config.PetStandLift, 0))) then break end

        local ok, why = Theseus.Tasks.Await(token, nil, Theseus.Config.CollectGap)
        if not ok and why ~= "timeout" then break end
        remote:FireServer(key)
        fired += 1
    end

    Theseus.Pets.Collected += fired
    if fired > 0 then
        local stand = Theseus.Pets.PlotStand()
        if stand then Theseus.Tasks.Teleport(token, stand) end
    end
    return fired
end

---@return Tool[]  food tools the user allows, cheapest first
function Theseus.Pets.FoodTools()
    local allowed = Theseus.Util.Opt("FoodTypes")
    local foods = Theseus.GameLib.Foods or {}
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    local tools = {}
    for _, tool in ipairs(backpack and backpack:GetChildren() or {}) do
        local row = tool:IsA("Tool") and foods[tool.Name]
        if not row then continue end
        if type(allowed) == "table" and next(allowed) and not allowed[tool.Name] then continue end
        tools[#tools + 1] = { tool, type(row) == "table" and tonumber(row.Price or row.Cost) or 0 }
    end
    table.sort(tools, function(a, b) return a[2] < b[2] end)
    for i, pair in ipairs(tools) do tools[i] = pair[1] end
    return tools
end

---@return table[]  { key, ridden } pets to feed for the current FeedTarget
function Theseus.Pets.FeedTargets()
    local mode = Theseus.Util.Opt("FeedTarget") or "Placed"
    local targets = {}
    if mode ~= "Ride pet" then
        for key, pet in pairs(Theseus.Pets.Placed) do
            if (pet.age or 0) < Theseus.Config.PetMaxAge then targets[#targets + 1] = { key, false } end
        end
    end

    local rideKey = mode ~= "Placed" and Theseus.Pets.RideKey()
    if rideKey then
        local tool = Theseus.Player.Char and Theseus.Player.Char:FindFirstChildOfClass("Tool")
        local age = tool and tonumber(tool:GetAttribute("Age")) or 0
        if age < Theseus.Config.PetMaxAge then table.insert(targets, { rideKey, true }) end
    end
    return targets
end

---@return boolean  standing on our plot
function Theseus.Pets.GoHome(token)
    local hrp = Theseus.Player.Root
    if hrp and Theseus.Geo.InPlot(hrp.Position) then return true end
    local stand = Theseus.Pets.PlotStand()
    return stand ~= nil and Theseus.Tasks.Teleport(token, stand)
end

---@return integer  foods used
function Theseus.Pets.Feed()
    local remote = Theseus.GameLib.Remote("FeedPet")
    if not remote then return 0 end
    Theseus.Pets.Bind()
    if not Theseus.Pets.FoodTools()[1] or not Theseus.Pets.FeedTargets()[1] then
        Theseus.State.Status.Feed = "No food or nothing to feed"
        return 0
    end
    return Theseus.Pets.WithToken("Feed", Theseus.Tasks.Prio.Plot, function(token)
        if not Theseus.Pets.GoHome(token) then
            Theseus.State.Status.Feed = "Could not reach the ranch"
            return 0
        end
        return Theseus.Pets.FeedAll(remote, token)
    end) or 0
end

---@return integer  food left in a stacked food tool
local function FoodLeft(tool)
    local data = tool and tool.Parent and tool:FindFirstChild("Data")
    local amount = data and data:FindFirstChild("Amount")
    return amount and tonumber(amount.Value) or 1
end

---@return integer  feeds the server took, one at a time at its own pace, until food, pets or the burst run out
function Theseus.Pets.FeedAll(remote, token)
    local cfg = Theseus.Config
    local used, misses, turn = 0, 0, 0
    local deadline = os.clock() + cfg.FeedBurst
    while os.clock() < deadline and misses < cfg.FeedMissLimit and Theseus.Tasks.Holds(token) do
        local targets = Theseus.Pets.FeedTargets()
        local food
        for _, tool in ipairs(Theseus.Pets.FoodTools()) do
            if FoodLeft(tool) > 0 then
                food = tool
                break
            end
        end
        if not food or #targets == 0 then break end

        turn = turn % #targets + 1
        local target = targets[turn]
        local before, firedAt = Theseus.Pets.FedAt, os.clock()
        remote:FireServer(target[1], food.Name, target[2] or nil)
        local ok = Theseus.Tasks.Await(token, function() return Theseus.Pets.FedAt ~= before end, cfg.FeedReplyTimeout)
        if ok then
            used += 1
            misses = 0
        else
            misses += 1
        end
        local wait = firedAt + cfg.FeedGap - os.clock()
        if wait > 0 then Theseus.Tasks.Await(token, function() return false end, wait) end
    end

    Theseus.Pets.Fed += used
    Theseus.State.Status.Feed = used > 0 and ("Fed " .. Theseus.Pets.Fed .. " times") or "No food or nothing to feed"
    return used
end

function Theseus.Pets.PlaceNow()
    return Theseus.Pets.WithToken("Pets", Theseus.Tasks.Prio.Plot, function(token)
        Theseus.Pets.Bind()
        local changed = Theseus.Pets.PlaceBest(token)
        Theseus.Pets.SetStatus(changed > 0 and ("Placed " .. changed .. " pets") or "Best pets placed")
        return changed
    end) or 0
end

function Theseus.Pets.CollectNow()
    return Theseus.Pets.WithToken("Pets", Theseus.Tasks.Prio.Plot, function(token)
        Theseus.Pets.Bind()
        return Theseus.Pets.Collect(token, true)
    end) or 0
end

function Theseus.Pets.Step()
    local equip, collect = Theseus.Util.Opt("AutoEquipBest"), Theseus.Util.Opt("AutoCollectCash")
    if not equip and not collect then return end
    Theseus.Pets.Bind()

    local gameCollects = collect and Theseus.Pets.GameCollects()
    Theseus.Pets.WithToken("Pets", Theseus.Tasks.Prio.Plot, function(token)
        if equip then Theseus.Pets.PlaceBest(token) end
        if collect and not gameCollects then Theseus.Pets.Collect(token, false) end
    end)
    Theseus.Pets.SetStatus(Theseus.Pets.Status())
end

function Theseus.Pets.FeedStep()
    if not Theseus.Util.Opt("AutoFeed") then return end
    Theseus.Pets.Feed()
end

function Theseus.Pets.Status()
    return string.format("Placed %d/%d | Swaps %d | Collects %d", #Theseus.Pets.PlacedList(), Theseus.Pets.MaxSlots(), Theseus.Pets.Swaps, Theseus.Pets.Collected)
end

function Theseus.Pets.PlacedList()
    local list = {}
    for _, pet in pairs(Theseus.Pets.Placed) do list[#list + 1] = pet end
    return list
end

function Theseus.Pets.Start()
    Theseus.Pets.Bind()
end

function Theseus.Pets.Stop()
    local hum = Theseus.Player.Humanoid
    if hum and not Theseus.Player:Riding() then hum:UnequipTools() end
end

Theseus.Sell = {
    Bound = false,
    ConfirmUntil = 0,
    Reply = nil,
    Sold = 0,
    Earned = 0,
}

function Theseus.Sell.SetStatus(text)
    Theseus.State.Status.Sell = text
end

function Theseus.Sell.OnConfirm(id, question)
    if os.clock() > Theseus.Sell.ConfirmUntil then return end
    if not tostring(question or ""):lower():find("sell", 1, true) then return end
    Theseus.Sell.ConfirmUntil = 0
    local remote = Theseus.GameLib.Remote("ConfirmRequest")
    if remote then remote:FireServer(id, true) end
end

function Theseus.Sell.Bind()
    if Theseus.Sell.Bound then return end
    Theseus.Sell.Bound = true

    local sell = Theseus.GameLib.Remote("SellItems")
    if sell then
        Theseus:Connect(sell.OnClientEvent, function(reply) Theseus.Sell.Reply = reply end)
    end
    local confirm = Theseus.GameLib.Remote("ConfirmRequest")
    if confirm then Theseus:Connect(confirm.OnClientEvent, Theseus.Sell.OnConfirm) end
end

---@return boolean  this pet passes the sell filters
function Theseus.Sell.Allowed(pet, keep, under)
    if pet.placed or not pet.key or not pet.rarity then return false end
    if keep[pet.rarity] then return false end
    if pet.mutated and Theseus.Util.Opt("SellKeepMutated") then return false end
    if under > 0 and pet.income >= under then return false end
    return true
end

---@return table  { [rarity] = true } for the top rarities when the player picked none
function Theseus.Sell.DefaultKeep()
    local order = Theseus.GameLib.RarityOrder
    local keep = {}
    for i = math.max(1, #order - Theseus.Config.SellKeepTopRarities + 1), #order do
        keep[order[i]] = true
    end
    return keep
end

---@return table  { [rarity] = true } every rarity except the junk pets Clear Junk Eggs sells
function Theseus.Sell.JunkKeep()
    local sell = Theseus.Junk.SellSet()
    local keep = {}
    for _, rarity in ipairs(Theseus.GameLib.RarityOrder) do
        if not sell[rarity] then keep[rarity] = true end
    end
    return keep
end

---@param junkOnly boolean?  sell only the Clear Junk Eggs pet rarities, never the best pets that fill the plot
---@return table[], number    pets to sell, cash expected
function Theseus.Sell.Plan(junkOnly)
    local keep = Theseus.Util.Opt("SellRarities")
    if type(keep) ~= "table" or next(keep) == nil then keep = Theseus.Sell.DefaultKeep() end
    if junkOnly then keep = Theseus.Sell.JunkKeep() end

    local under = not junkOnly and tonumber(Theseus.Util.Opt("SellUnderIncome")) or 0
    local keepBest = junkOnly and Theseus.Pets.MaxSlots() or tonumber(Theseus.Util.Opt("SellKeepBest")) or 0
    local owned = Theseus.Pets.Owned()
    table.sort(owned, function(a, b) return a.income > b.income end)

    local needs = Theseus.Pets.RebirthNeeds()
    local plan, cash = {}, 0
    for rank, pet in ipairs(owned) do
        if rank <= keepBest then continue end
        if not Theseus.Sell.Allowed(pet, keep, under) then continue end
        if Theseus.Pets.Protected(pet, needs) then continue end
        plan[#plan + 1] = pet
        cash += pet.income * GameLib.SellMultiplier()
    end
    return plan, cash
end

function Theseus.Sell.Preview()
    local plan, cash = Theseus.Sell.Plan()
    local text = "Will sell " .. #plan .. " for $" .. Theseus.Util.Format(cash)
    Theseus.State.Status.SellPreview = text
    return text
end

---@return CFrame|nil  a spot next to the seller
function Theseus.Sell.Stand()
    local stalls = Workspace:FindFirstChild("Stalls")
    local stall = stalls and stalls:FindFirstChild("Sell")
    local richie = stall and stall:FindFirstChild("Richie")
    if not richie then return nil end

    local pivot = richie:IsA("Model") and richie:GetPivot() or (richie:IsA("BasePart") and richie.CFrame)
    if not pivot then return nil end
    return CFrame.new(pivot.Position + pivot.LookVector * Theseus.Config.SellStand)
end

---@return number|nil  pets sold in this batch, nil when the seller refused
---@return string|nil  refusal reason
function Theseus.Sell.Batch(token, remote, keys)
    Theseus.Sell.Reply = nil
    Theseus.Sell.ConfirmUntil = os.clock() + Theseus.Config.ConfirmWindow
    remote:FireServer({ Pets = keys, Eggs = {} })

    Theseus.Tasks.Await(token, function() return Theseus.Sell.Reply ~= nil end, Theseus.Config.SellReplyTimeout)
    local reply = Theseus.Sell.Reply
    if type(reply) ~= "table" then return nil end
    if reply.Reason and reply.Reason ~= "Sold" then return nil, reply.Reason end
    return tonumber(reply.Sold) or 0
end

---@return number|nil  pets sold, nil when the seller refused for good
function Theseus.Sell.Send(token, remote, keys)
    local cfg = Theseus.Config
    for _ = 1, cfg.SellTries do
        local got, why = Theseus.Sell.Batch(token, remote, keys)
        if got then return got end
        if why ~= "TooFar" and why ~= "Busy" then
            Theseus.Sell.SetStatus("Seller says: " .. tostring(why or "no answer"))
            return nil
        end

        local _, waited = Theseus.Tasks.Await(token, nil, why == "Busy" and cfg.SellRetry or cfg.SellSettle)
        if waited ~= "timeout" then return nil end
    end
    Theseus.Sell.SetStatus("Seller is busy")
    return nil
end

---@param toggle string  switched off when income drops after the sale
function Theseus.Sell.GuardIncome(before, toggle)
    task.wait(Theseus.Config.IncomeSettle)
    local after = Theseus.Pets.IncomeRate()
    if after >= before then return end

    table.insert(Theseus.State.PendingToggleOff, toggle)
    Theseus.Util.Notify("Theseus", "Income went down after selling, the sale option was stopped", 8)
    warn(Theseus.Config.Tag .. " sell: income " .. before .. " -> " .. after)
end

---@return boolean  next to the seller and settled
function Theseus.Sell.Arrive(token, stand)
    local hrp = Theseus.Player.Root
    if hrp and (hrp.Position - stand.Position).Magnitude <= Theseus.Config.SellNear then return true end
    if not Theseus.Tasks.Teleport(token, stand) then return false end

    local _, settled = Theseus.Tasks.Await(token, nil, Theseus.Config.SellSettle)
    return settled == "timeout"
end

---@param junkOnly boolean?  sell only the Clear Junk Eggs pet rarities
---@return integer            pets sold
function Theseus.Sell.Run(token, junkOnly)
    local remote = Theseus.GameLib.Remote("SellItems")
    local stand = Theseus.Sell.Stand()
    if not remote or not Theseus.GameLib.Remote("ConfirmRequest") or not stand then
        Theseus.Sell.SetStatus("Seller not found")
        return 0
    end

    local plan, cash = Theseus.Sell.Plan(junkOnly)
    if #plan == 0 then
        Theseus.Sell.SetStatus("Nothing to sell")
        return 0
    end
    if not Theseus.Sell.Arrive(token, stand) then return 0 end

    local before, sold = Theseus.Pets.IncomeRate(), 0
    for first = 1, #plan, Theseus.Config.SellBatch do
        local keys = {}
        for i = first, math.min(first + Theseus.Config.SellBatch - 1, #plan) do
            table.insert(keys, plan[i].key)
        end
        local got = Theseus.Sell.Send(token, remote, keys)
        if not got then break end
        sold += got
    end

    Theseus.Sell.Sold += sold
    if sold > 0 then Theseus.Sell.Earned += cash * sold / #plan end
    Theseus.Sell.SetStatus("Sold " .. sold .. " pets")
    Theseus.Sell.GuardIncome(before, junkOnly and "ClearJunk" or "AutoSell")
    return sold
end

function Theseus.Sell.Now()
    Theseus.Sell.Bind()
    return Theseus.Pets.WithToken("Sell", Theseus.Tasks.Prio.Travel, Theseus.Sell.Run) or 0
end

function Theseus.Sell.Step()
    Theseus.Sell.Preview()
    if Theseus.Util.Opt("AutoSell") then Theseus.Sell.Now() end
end

function Theseus.Sell.Status()
    return Theseus.State.Status.Sell or ""
end

function Theseus.Sell.Start()
    Theseus.Sell.Bind()
end

function Theseus.Sell.Stop()
    Theseus.Sell.ConfirmUntil = 0
end

Theseus.Fusion = {
    Inputs = {},
    Fused = 0,
    FiredAt = 0,
}

---@return string[]  rarities the machine takes, lowest first
function Theseus.Fusion.Rarities()
    local rank = Theseus.GameLib.RarityRank
    local list, seen = {}, {}

    if next(Theseus.GameLib.FuseQuality) then
        for name in pairs(Theseus.GameLib.FuseQuality) do
            local info = Theseus.GameLib.PetInfo[name]
            if info and not seen[info.rarity] then
                seen[info.rarity] = true
                list[#list + 1] = info.rarity
            end
        end
    else
        local cfg = Theseus.GameLib.Data.Fusion
        local floor = type(cfg) == "table" and rank[cfg.MinimumInputRarity] or 0
        for _, rarity in ipairs(Theseus.GameLib.RarityOrder) do
            if (rank[rarity] or 0) >= floor then list[#list + 1] = rarity end
        end
        return list
    end

    table.sort(list, function(a, b) return (rank[a] or 0) < (rank[b] or 0) end)
    return list
end

---@return boolean  waited out the server request cooldown
function Theseus.Fusion.Pace(token)
    local cfg = Theseus.GameLib.Data.Fusion
    local gap = type(cfg) == "table" and tonumber(cfg.RequestCooldown) or Theseus.Config.FuseGap
    local readyAt = Theseus.Fusion.FiredAt + gap
    if os.clock() >= readyAt then return true end
    return (Theseus.Tasks.Await(token, function() return os.clock() >= readyAt end, gap))
end

function Theseus.Fusion.SetStatus(text)
    Theseus.State.Status.Fusion = text
end

---@return boolean  the fusion event is running now
function Theseus.Fusion.Active()
    local cfg = Theseus.GameLib.Data and Theseus.GameLib.Data.Fusion
    if type(cfg) ~= "table" then return false end

    local start = tonumber(cfg.StartTime)
    local on, off = tonumber(cfg.ActiveWeeks), tonumber(cfg.InactiveWeeks)
    if not (start and on and off) then return Theseus.Fusion.Machine() ~= nil end

    local now = Theseus.Util.ServerNow()
    if now < start then return false end
    local period = (on + off) * Theseus.Config.WeekSec
    return (now - start) % period < on * Theseus.Config.WeekSec
end

---@return Vector3|nil, table<number, Attachment>  console stand point, slot attachments
function Theseus.Fusion.Machine()
    local functionals = Workspace:FindFirstChild("Functionals")
    local machine = functionals and functionals:FindFirstChild("Fusion")
    if not machine then return nil, {} end

    local slots, console = {}, nil
    for _, node in ipairs(machine:GetDescendants()) do
        local slot = node:IsA("Attachment") and tonumber(node:GetAttribute("FusionSlot"))
        if slot then slots[slot] = node end
        if node:IsA("ProximityPrompt") and node.Name == "OpenConsole" and node.Parent:IsA("Attachment") then
            console = node.Parent.WorldPosition
        end
    end
    return console, slots
end

---@return CFrame  stand point next to a world position
function Theseus.Fusion.Near(pos)
    return CFrame.new(pos + Vector3.new(0, Theseus.Config.FuseLift, Theseus.Config.FuseStand))
end

---@return table[]  lowest income eligible backpack pets, up to count
function Theseus.Fusion.Candidates(count)
    local allowed = Theseus.Util.Opt("FuseRarities")
    if type(allowed) ~= "table" or not next(allowed) then return {} end

    local floor = Theseus.GameLib.RarityRank[(Theseus.Fusion.Rarities())[1] or ""] or 0
    local owned = Theseus.Pets.Owned()
    table.sort(owned, function(a, b) return a.income > b.income end)
    local keepBest = tonumber(Theseus.Util.Opt("FuseKeepBest")) or 0
    local needs = Theseus.Pets.RebirthNeeds()

    local picked = {}
    for rank = #owned, keepBest + 1, -1 do
        if #picked >= count then break end
        local pet = owned[rank]
        if pet.placed or not pet.tool or not allowed[pet.rarity or ""] then continue end
        if (Theseus.GameLib.RarityRank[pet.rarity] or 0) < floor then continue end
        if next(Theseus.GameLib.FuseQuality) and not Theseus.GameLib.FuseQuality[pet.name or ""] then continue end
        if pet.mutated and Theseus.Util.Opt("FuseKeepMutated") then continue end
        if Theseus.Pets.Protected(pet, needs) then continue end
        picked[#picked + 1] = pet
    end
    return picked
end

---@return number|nil  cash the next fuse costs, nil when the preview does not say
function Theseus.Fusion.Cost(state)
    local raw = state:GetAttribute("FusionPreviewJSON")
    if type(raw) ~= "string" or raw == "" then return nil end
    local ok, preview = pcall(HttpService.JSONDecode, HttpService, raw)
    if not ok or type(preview) ~= "table" then return nil end
    return tonumber(preview.FuseCost or preview.Cost or preview.Price)
end

---@return boolean  fired and the slot filled
function Theseus.Fusion.PlaceOne(token, state, slot, attach, pet)
    local remote = Theseus.GameLib.Remote("FusionPetPlace")
    local hum = Theseus.Player.Humanoid
    if not remote or not hum or not pet.tool.Parent then return false end
    if not Theseus.Tasks.Teleport(token, Theseus.Fusion.Near(attach.WorldPosition)) then return false end

    hum:EquipTool(pet.tool)
    Theseus.Mount.Dirty = true
    local equipped = Theseus.Tasks.Await(token, function() return pet.tool.Parent == Theseus.Player.Char end, Theseus.Config.FuseSettle * 4)
    if not equipped then return false end
    Theseus.Tasks.Await(token, nil, Theseus.Config.FusePlaceSettle)
    if not Theseus.Tasks.Holds(token) or not Theseus.Fusion.Pace(token) then return false end
    Theseus.Fusion.Inputs[pet.key] = true
    Theseus.Fusion.FiredAt = os.clock()
    remote:FireServer(slot)

    local filled = Theseus.Tasks.Await(token, function()
        return state:FindFirstChild(tostring(slot)) ~= nil
    end, Theseus.Config.FuseReplyTimeout)
    if not filled then Theseus.Fusion.Inputs[pet.key] = nil end
    return filled
end

---@return boolean  all slots filled
function Theseus.Fusion.Fill(token, state, slots)
    local missing = {}
    for index = 1, Theseus.Config.FuseSlots do
        if slots[index] and not state:FindFirstChild(tostring(index)) then missing[#missing + 1] = index end
    end
    if #missing == 0 then return true end

    local allowed = Theseus.Util.Opt("FuseRarities")
    if type(allowed) ~= "table" or not next(allowed) then
        Theseus.Fusion.SetStatus("Pick which rarities to fuse")
        return false
    end
    local pets = Theseus.Fusion.Candidates(#missing)
    if #pets < #missing then
        Theseus.Fusion.SetStatus("Need " .. (#missing - #pets) .. " more pets to fuse")
        return false
    end

    local done = true
    for i, slot in ipairs(missing) do
        Theseus.Fusion.SetStatus("Filling slot " .. slot .. " of " .. Theseus.Config.FuseSlots)
        if not Theseus.Fusion.PlaceOne(token, state, slot, slots[slot], pets[i]) then
            done = false
            break
        end
    end
    local hum = Theseus.Player.Humanoid
    if hum then hum:UnequipTools() end
    return done
end

function Theseus.Fusion.AtConsole(token, console, ...)
    local remote = Theseus.GameLib.Remote("FusionAction")
    if not remote or select(1, ...) == "SkipPurchase" then return false end
    if not Theseus.Tasks.Teleport(token, Theseus.Fusion.Near(console)) then return false end
    Theseus.Tasks.Await(token, nil, Theseus.Config.FuseSettle)
    if not Theseus.Fusion.Pace(token) then return false end
    Theseus.Fusion.FiredAt = os.clock()
    remote:FireServer(...)
    return true
end

---@return string|nil  key the Claim call wants
function Theseus.Fusion.ResultKey(state)
    if state:GetAttribute("FusionFailed") == true then return state:GetAttribute("FusionResultKey") end
    local result = LocalPlayer:FindFirstChild("FusionResult")
    local pet = result and result:FindFirstChild("Pet")
    return pet and pet:GetAttribute("PetKey") or state:GetAttribute("FusionResultKey")
end

function Theseus.Fusion.Waiting(token, state, console)
    local left = (tonumber(state:GetAttribute("EndsAt")) or math.huge) - Theseus.Util.ServerNow()
    if left > 0 then
        Theseus.Fusion.SetStatus("Fusing, " .. math.ceil(left) .. "s left")
        return
    end
    if Theseus.Fusion.AtConsole(token, console, "Fuse") then Theseus.Fusion.SetStatus("Fusion finished, claiming next") end
end

function Theseus.Fusion.Claim(token, state, console)
    local fusion = Theseus.Fusion
    local key = fusion.ResultKey(state)
    if not key or key == fusion.ClaimedKey then return end
    if not fusion.AtConsole(token, console, "Claim", key) then return end

    local claimed = Theseus.Tasks.Await(token, function() return state:GetAttribute("FusionStatus") ~= "Result" end, Theseus.Config.FuseResultTimeout)
    if not claimed then
        fusion.SetStatus("Claim not confirmed; retrying")
        return
    end
    fusion.ClaimedKey = key
    fusion.Fused += 1
    table.clear(fusion.Inputs)
    fusion.SetStatus("Claimed fusion result")
    fusion.PutAway(token)
end

---@return boolean  the result pet that lands in hand after a claim is back in the bag
function Theseus.Fusion.PutAway(token)
    local hum, char = Theseus.Player.Humanoid, Theseus.Player.Char
    if not hum or not char or Theseus.Player:Riding() then return false end
    Theseus.Tasks.Await(token, function() return char:FindFirstChildOfClass("Tool") ~= nil end, Theseus.Config.DismountToolWindow)
    hum:UnequipTools()
    return char:FindFirstChildOfClass("Tool") == nil
end

function Theseus.Fusion.StartFuse(token, state, console)
    local cost = Theseus.Fusion.Cost(state)
    local economy = Theseus.Economy
    if cost and economy and economy.Reserve then
        economy.Reserve("Fusion", cost)
        if economy.Budget("Fusion") < cost then
            Theseus.Fusion.SetStatus("Saving $" .. Theseus.Util.Format(cost) .. " to fuse")
            return
        end
    end
    local started = Theseus.Fusion.AtConsole(token, console, "Start")
    if economy and economy.Reserve then economy.Reserve("Fusion", nil) end
    if started then Theseus.Fusion.SetStatus("Fusion started") end
end

function Theseus.Fusion.Run(token)
    local state = LocalPlayer:FindFirstChild("FusionSlots")
    local console, slots = Theseus.Fusion.Machine()
    if not state or not console then
        Theseus.Fusion.SetStatus("Fusion machine not found")
        return
    end

    local status = state:GetAttribute("FusionStatus")
    if status == "Waiting" then
        Theseus.Fusion.Waiting(token, state, console)
        return
    end
    if status == "Result" then
        Theseus.Fusion.Claim(token, state, console)
        return
    end

    if not Theseus.Fusion.Fill(token, state, slots) then return end
    if state:GetAttribute("Ready") == false then return Theseus.Fusion.SetStatus("Machine is not ready yet") end
    Theseus.Fusion.StartFuse(token, state, console)
end

---@return boolean, string|nil  allowed, why not
function Theseus.Fusion.Ready()
    if (tonumber(Theseus.Pets.Saved("Rebirths")) or 0) < 1 then return false, "Needs one rebirth" end
    if not Theseus.Fusion.Active() then return false, "Fusion event is closed" end
    return true
end

function Theseus.Fusion.Now()
    local ok, why = Theseus.Fusion.Ready()
    if not ok then
        Theseus.Fusion.SetStatus(why)
        return
    end
    Theseus.Fusion.SetStatus("")
    local ran = Theseus.Pets.WithToken("Fusion", Theseus.Tasks.Prio.Plot, function(token)
        Theseus.Fusion.Run(token)
        if Theseus.Tasks.Holds(token) then Theseus.Pets.GoHome(token) end
        return true
    end)
    if not ran then
        Theseus.Fusion.SetStatus("Waiting for a turn")
    elseif Theseus.State.Status.Fusion == "" then
        Theseus.Fusion.SetStatus("Nothing to fuse")
    end
end

function Theseus.Fusion.Step()
    if not Theseus.Util.Opt("AutoFusion") then return end
    Theseus.Fusion.Now()
end

function Theseus.Fusion.Status()
    return Theseus.State.Status.Fusion or ""
end

function Theseus.Fusion.Start() end

function Theseus.Fusion.Stop()
    local hum = Theseus.Player.Humanoid
    if hum and not Theseus.Player:Riding() then hum:UnequipTools() end
end

Theseus.Economy = {
    Reserves = {},
    Plan = "",
    PendingUpgrade = nil,
    PendingRebirth = nil,
    UpgradeBlockedUntil = 0,
    RebirthBlockedUntil = 0,
}

---@return any  SavedData value, nil when not replicated yet
function Theseus.Economy.Saved(name)
    local saved = LocalPlayer:FindFirstChild("SavedData")
    local node = saved and saved:FindFirstChild(name)
    return node and node.Value
end

function Theseus.Economy.Cash()
    return tonumber(Theseus.Economy.Saved("Cash")) or 0
end

---@return number  cash per second, as the leaderboard shows it
function Theseus.Economy.Income()
    local stats = LocalPlayer:FindFirstChild("leaderstats")
    local node = stats and stats:FindFirstChild("Income/s")
    return node and tonumber(node.Value) or 0
end

function Theseus.Economy.Rebirths()
    return tonumber(Theseus.Economy.Saved("Rebirths")) or 0
end

function Theseus.Economy.HatchUpgrades()
    return tonumber(Theseus.Economy.Saved("HatchUpgrades")) or 0
end

---@return integer  free luck packs not spent yet
function Theseus.Economy.FreePacks()
    local free = tonumber(Theseus.Economy.Saved("FreeHatchUpgrades")) or 0
    local used = tonumber(Theseus.Economy.Saved("UsedFreeHatchUpgrades")) or 0
    return math.max(free - used, 0)
end

---@param n integer  upgrades already owned
---@return number    price of the next one
function Theseus.Economy.UpgradePrice(n)
    local tier = math.floor(n / 5)
    return 5 + 10 * n + 50 * (5 * tier * (tier - 1) / 2 + tier * (n - 5 * tier + 1))
end

---@return number  hatch luck multiplier with the live event bonus
function Theseus.Economy.LuckMult()
    return GameLib.LuckMult()
end

---@param amount number|nil  nil or 0 clears the hold
function Theseus.Economy.Reserve(owner, amount)
    if not amount or amount <= 0 then
        Theseus.Economy.Reserves[owner] = nil
        return
    end
    Theseus.Economy.Reserves[owner] = amount
end

---@return number  cash this owner may spend: keep floor and the other owners' holds removed
function Theseus.Economy.Budget(owner)
    local budget = Theseus.Economy.Cash() - (tonumber(Theseus.Util.Opt("ShopKeepCash")) or 0)
    if not Theseus.Util.Opt("SmartSpend") then return budget end

    for holder, amount in pairs(Theseus.Economy.Reserves) do
        if holder ~= owner then budget -= amount end
    end
    return budget
end

---@return string|nil  name of the pet the next rebirth asks for, nil when every rebirth is done
function Theseus.Economy.NextRequirement()
    local done = Theseus.Economy.Rebirths()
    if done >= (Theseus.GameLib.Rebirths.Cap or 0) then return nil end
    return Theseus.GameLib.RebirthReq[done + 1]
end

---@return table|nil  first owned pet entry with that name
function Theseus.Economy.OwnedPet(name)
    if not name then return nil end
    for _, pet in ipairs(Theseus.Pets.Owned()) do
        if pet.name == name then return pet end
    end
    return nil
end

---@return table  { cost, pet, owned, ready, payback, reason }
function Theseus.Economy.RebirthPlan()
    local done = Theseus.Economy.Rebirths()
    local target = tonumber(Theseus.Util.Opt("RebirthTarget")) or Theseus.GameLib.Rebirths.Cap or 0
    local plan = { cost = math.huge, payback = math.huge }

    if done >= math.min(target, Theseus.GameLib.Rebirths.Cap or 0) then
        plan.reason = "target reached"
        return plan
    end

    plan.cost = Theseus.GameLib.Rebirths.Costs[done + 1] or math.huge
    plan.pet = Theseus.Economy.NextRequirement()
    local owned = Theseus.Economy.OwnedPet(plan.pet)
    plan.owned = owned ~= nil and Theseus.Pets.Protected(owned) == true

    local gain = Theseus.Economy.Income() / GameLib.RebirthMultiplier(done)
    if gain > 0 then plan.payback = plan.cost / gain end

    if not plan.owned then
        plan.reason = "need " .. tostring(plan.pet)
    elseif Theseus.Economy.Cash() < plan.cost then
        plan.reason = "saving"
    else
        plan.ready = true
    end
    return plan
end

---@return integer  levels to buy now, 0 when the next one is not worth it
function Theseus.Economy.UpgradeCount(budget, income)
    local n = Theseus.Economy.HatchUpgrades()
    local cap = income * Theseus.Config.UpgradePayback
    local count, spent = 0, 0

    repeat
        local price = Theseus.Economy.UpgradePrice(n + count)
        if price >= cap or spent + price > budget then break end
        spent += price
        count += 1
    until count >= Theseus.Config.UpgradeMaxBuy
    return count
end

---@return boolean  true when every level cash could buy also passes the payback rule
function Theseus.Economy.MaxIsSafe(count)
    if Theseus.Util.Opt("SmartSpend") and next(Theseus.Economy.Reserves) then return false end
    if (tonumber(Theseus.Util.Opt("ShopKeepCash")) or 0) > 0 then return false end
    local n = Theseus.Economy.HatchUpgrades() + count
    return Theseus.Economy.UpgradePrice(n) > Theseus.Economy.Cash()
end

---@return integer  levels asked for
function Theseus.Economy.Upgrade()
    local remote = Theseus.Net["Plot.Upgrades"]
    if not remote then return 0 end
    if LocalPlayer:GetAttribute("Setting_LuckMultiplier") == false then
        Theseus.State.Status.Upgrade = "Luck upgrades are turned off in game settings"
        return 0
    end

    local before = Theseus.Economy.HatchUpgrades()
    if Theseus.Economy.FreePacks() > 0 then remote:FireServer("MaxFree") end

    local count = Theseus.Economy.UpgradeCount(Theseus.Economy.Budget("Upgrade"), Theseus.Economy.Income())
    if count == 0 then return 0 end

    if Theseus.Economy.MaxIsSafe(count) then
        remote:FireServer("Max")
    else
        for i = 1, math.min(count, Theseus.Config.UpgradeBatch) do
            remote:FireServer()
            if i < count then task.wait(Theseus.Config.UpgradeGap) end
        end
    end
    Theseus.Economy.PendingUpgrade = { before, os.clock() + Theseus.Config.UpgradeVerify }
    return count
end

---@return boolean  false while a check is still waiting or the last buy was refused
function Theseus.Economy.VerifyUpgrade()
    local pending = Theseus.Economy.PendingUpgrade
    if not pending then return true end
    if os.clock() < pending[2] then return false end

    Theseus.Economy.PendingUpgrade = nil
    if Theseus.Economy.HatchUpgrades() > pending[1] then return true end
    Theseus.Economy.UpgradeBlockedUntil = os.clock() + Theseus.Config.UpgradeBackoff
    return false
end

function Theseus.Economy.UpgradeNow()
    local count = Theseus.Economy.Upgrade()
    Theseus.Util.Notify("Upgrades", count > 0 and ("Buying " .. count .. " luck levels") or "Nothing worth buying now")
end

---@return boolean  fired
function Theseus.Economy.Rebirth(plan)
    local remote = Theseus.Net.Rebirth
    if not (remote and plan.ready) then return false end
    if os.clock() < Theseus.Economy.RebirthBlockedUntil or Theseus.Economy.PendingRebirth then return false end
    if Theseus.Eggs and Theseus.Eggs.CarryCritical then return false end

    Theseus.Economy.PendingRebirth = { Theseus.Economy.Rebirths(), os.clock() + Theseus.Config.RebirthVerify }
    remote:FireServer()
    return true
end

function Theseus.Economy.VerifyRebirth()
    local pending = Theseus.Economy.PendingRebirth
    if not pending or os.clock() < pending[2] then return end
    Theseus.Economy.PendingRebirth = nil

    if Theseus.Economy.Rebirths() > pending[1] then
        Theseus.Economy.Reserve("Rebirth", nil)
        Theseus.Util.Notify("Rebirth", "Rebirth " .. Theseus.Economy.Rebirths() .. " done")
        return
    end
    Theseus.Economy.RebirthBlockedUntil = os.clock() + Theseus.Config.RebirthBackoff
    Theseus.State.Status.Economy = "Rebirth refused, retry in 1 min"
end

function Theseus.Economy.RebirthNow()
    local plan = Theseus.Economy.RebirthPlan()
    if not Theseus.Economy.Rebirth(plan) then
        Theseus.Util.Notify("Rebirth", "Not ready: " .. tostring(plan.reason or "busy"))
    end
end

---@return boolean  true while cash is being saved for a rebirth that resets luck upgrades
function Theseus.Economy.SaveForRebirth(plan)
    if not (Theseus.Util.Opt("AutoRebirth") and Theseus.Util.Opt("SmartSpend")) then
        Theseus.Economy.Reserve("Rebirth", nil)
        return false
    end
    if not plan.owned or plan.cost == math.huge then
        Theseus.Economy.Reserve("Rebirth", nil)
        return false
    end

    local income = math.max(Theseus.Economy.Income(), 1)
    local wait = (plan.cost - Theseus.Economy.Cash()) / income
    if wait > Theseus.Config.RebirthSaveWindow then
        Theseus.Economy.Reserve("Rebirth", nil)
        return false
    end
    Theseus.Economy.Reserve("Rebirth", plan.cost)
    return true
end

function Theseus.Economy.Step()
    Theseus.Economy.VerifyRebirth()
    local plan = Theseus.Economy.RebirthPlan()
    local saving = Theseus.Economy.SaveForRebirth(plan)

    if Theseus.Util.Opt("AutoRebirth") and plan.ready then
        Theseus.Economy.Rebirth(plan)
        Theseus.Economy.Plan = "Rebirthing"
    elseif saving then
        Theseus.Economy.Plan = "Saving for rebirth (" .. Theseus.Util.Format(plan.cost) .. ")"
    else
        Theseus.Economy.Plan = plan.reason and ("Rebirth: " .. plan.reason) or ""
    end

    local upgradeOk = Theseus.Economy.VerifyUpgrade() and os.clock() >= Theseus.Economy.UpgradeBlockedUntil
    if Theseus.Util.Opt("AutoUpgrade") and upgradeOk and not saving and not Theseus.Economy.PendingRebirth then
        Theseus.Economy.Upgrade()
    end
    Theseus.State.Status.Economy = Theseus.Economy.Status()
end

function Theseus.Economy.Status()
    local luck = "Luck x" .. Theseus.Util.Format(Theseus.Economy.LuckMult())
    if Theseus.Economy.Plan == "" then return luck end
    return luck .. " | " .. Theseus.Economy.Plan
end

function Theseus.Economy.Stop()
    table.clear(Theseus.Economy.Reserves)
    Theseus.Economy.PendingUpgrade = nil
    Theseus.Economy.PendingRebirth = nil
end

Theseus.Shop = {
    Stock = nil,
    StockAt = 0,
    Signature = nil,
    LastCheck = 0,
    Conn = nil,
    Bought = 0,
}

---@return string[]  "Category/Item" labels for the picker, cheapest first
function Theseus.Shop.Labels()
    local labels = {}
    for _, entry in ipairs(Theseus.GameLib.ShopItems) do
        labels[#labels + 1] = entry.cat .. "/" .. entry.item
    end
    return labels
end

---@return number  price from game data, math.huge when unknown
function Theseus.Shop.Price(category, item)
    for _, entry in ipairs(Theseus.GameLib.ShopItems) do
        if entry.cat == category and entry.item == item then return entry.price end
    end
    return math.huge
end

function Theseus.Shop.Bind()
    if Theseus.Shop.Conn then return end
    local restock = Theseus.GameLib.Listen("Restock")
    if not restock then return end
    Theseus.Shop.Conn = Theseus:Connect(restock.OnClientEvent, function(stock)
        if type(stock) ~= "table" then return end
        Theseus.Shop.Stock = stock
        Theseus.Shop.StockAt = os.clock()
    end)
end

---@return string  restock timestamps joined; changes when the shop restocks
function Theseus.Shop.RestockSignature()
    local serverData = ReplicatedStorage:FindFirstChild("ServerData")
    if not serverData then return "" end

    local parts = {}
    for name, value in pairs(serverData:GetAttributes()) do
        if name:find("LastRestockTime", 1, true) then table.insert(parts, name .. "=" .. tostring(value)) end
    end
    for _, child in ipairs(serverData:GetChildren()) do
        if child.Name:find("LastRestockTime", 1, true) and child:IsA("ValueBase") then
            table.insert(parts, child.Name .. "=" .. tostring(child.Value))
        end
    end
    table.sort(parts)
    return table.concat(parts, ";")
end

---@return table|nil  stock[cat][item] = { Amount }, nil when the server did not answer
function Theseus.Shop.ReadStock()
    local request = Theseus.Net.ShopStock
    if not request then return nil end
    Theseus.Shop.Bind()

    local asked = os.clock()
    request:FireServer()
    local deadline = asked + Theseus.Config.ShopReplyTimeout
    repeat
        if Theseus.Shop.StockAt >= asked then return Theseus.Shop.Stock end
        task.wait(0.05)
    until os.clock() > deadline
    return nil
end

---@return integer  units fired
function Theseus.Shop.Buy()
    local wanted = Theseus.Util.Opt("ShopItems")
    local buy = Theseus.Net.BuyWithCash
    if type(wanted) ~= "table" or not next(wanted) or not buy then return 0 end

    local stock = Theseus.Shop.ReadStock()
    if not stock then return 0 end

    local budget, fired = Theseus.Economy.Budget("Shop"), 0
    for label, on in pairs(wanted) do
        if not on then continue end
        local category, item = label:match("^(.-)/(.+)$")
        local slot = category and type(stock[category]) == "table" and stock[category][item]
        local amount = type(slot) == "table" and tonumber(slot.Amount) or 0
        local price = Theseus.Shop.Price(category, item)

        for _ = 1, amount do
            if budget < price then break end
            buy:FireServer(category, item)
            budget -= price
            fired += 1
            task.wait(Theseus.Config.ShopBuyGap)
        end
    end
    Theseus.Shop.Bought += fired
    return fired
end

function Theseus.Shop.BuyNow()
    local fired = Theseus.Shop.Buy()
    Theseus.Util.Notify("Shop", fired > 0 and ("Bought " .. fired .. " items") or "Nothing to buy in stock")
end

function Theseus.Shop.Step()
    if not Theseus.Util.Opt("AutoShop") then return end
    local signature = Theseus.Shop.RestockSignature()
    local stale = os.clock() - Theseus.Shop.LastCheck >= Theseus.Config.ShopRecheck
    if signature == Theseus.Shop.Signature and not stale then return end

    Theseus.Shop.Signature = signature
    Theseus.Shop.LastCheck = os.clock()
    Theseus.Shop.Buy()
    Theseus.State.Status.Shop = "Bought " .. Theseus.Shop.Bought .. " this session"
end

function Theseus.Shop.Stop()
    Theseus.Shop.Signature = nil
    Theseus.Shop.LastCheck = 0
end

Theseus.Rewards = {
    OfflineDone = false,
    PromptAt = {},
    PendingIndex = nil,
    IndexBlockedUntil = 0,
}

---@return integer  game pets found in OwnedPets, counted the way the index does
function Theseus.Rewards.IndexCount()
    local owned = tostring(Theseus.Economy.Saved("OwnedPets") or "")
    if owned == "" then return 0 end

    local count = 0
    for name in pairs(Theseus.GameLib.PetInfo) do
        if owned:find(name .. ",", 1, true) then count += 1 end
    end
    return count
end

---@return table|nil  next unclaimed stage { goal, reward } when its goal is met
function Theseus.Rewards.IndexReady()
    local stage = tonumber(Theseus.Economy.Saved("IndexRewardStage")) or 0
    local nextStage = Theseus.GameLib.IndexStages[stage + 1]
    if not nextStage then return nil end
    if Theseus.Rewards.IndexCount() < nextStage.goal then return nil end
    return nextStage
end

---@return boolean  fired
function Theseus.Rewards.ClaimIndex()
    local remote = Theseus.Net.ClaimIndexReward
    if not remote or os.clock() < Theseus.Rewards.IndexBlockedUntil then return false end
    if not Theseus.Rewards.IndexReady() then return false end

    local stage = tonumber(Theseus.Economy.Saved("IndexRewardStage")) or 0
    remote:FireServer()
    task.delay(Theseus.Config.ClaimVerify, function()
        local now = tonumber(Theseus.Economy.Saved("IndexRewardStage")) or 0
        if now <= stage then Theseus.Rewards.IndexBlockedUntil = os.clock() + Theseus.Config.PromptRetry end
    end)
    return true
end

---@return boolean  fired
function Theseus.Rewards.ClaimOffline()
    local remote = Theseus.Net.OfflineEarnings
    if not remote or Theseus.Rewards.OfflineDone then return false end
    if (tonumber(LocalPlayer:GetAttribute("OfflineSeconds")) or 0) <= 0 then return false end

    Theseus.Rewards.OfflineDone = true
    remote:FireServer()
    return true
end

---@return ProximityPrompt|nil
function Theseus.Rewards.FindPrompt(holder)
    local functionals = Workspace:FindFirstChild("Functionals")
    local model = functionals and functionals:FindFirstChild(holder)
    local handle = model and model:FindFirstChild("Handle")
    local prompt = handle and handle:FindFirstChild("Claim")
    if prompt and prompt:IsA("ProximityPrompt") and prompt.Enabled then return prompt end
    return nil
end

---@return boolean  triggered, through the executor or a hold while in range
function Theseus.Rewards.TriggerPrompt(prompt)
    if Library and Library.Compat and Library.Compat.Caps.Prompt then
        return (pcall(fireproximityprompt, prompt))
    end

    local root = Theseus.Player.Root
    local part = prompt.Parent
    if not (root and part and part:IsA("BasePart")) then return false end
    if (root.Position - part.Position).Magnitude > prompt.MaxActivationDistance then return false end

    prompt:InputHoldBegin()
    task.wait(prompt.HoldDuration + 0.05)
    prompt:InputHoldEnd()
    return true
end

---@return boolean  group reward cooldown is over (or never claimed)
function Theseus.Rewards.GroupReady()
    local last = tonumber(LocalPlayer:GetAttribute("GroupRewardClaimTime"))
    if not last then return true end
    return os.time() - last >= Theseus.Config.GroupRewardCooldown
end

---@return integer  prompts triggered
function Theseus.Rewards.ClaimPrompts(force)
    local fired = 0
    local list = {
        { "EventBoost", true },
        { "Meat", Theseus.Rewards.GroupReady() },
    }

    for _, pair in ipairs(list) do
        local holder, ready = pair[1], pair[2]
        local due = force or os.clock() - (Theseus.Rewards.PromptAt[holder] or -math.huge) >= Theseus.Config.PromptRetry
        if not (ready and due) then continue end

        local prompt = Theseus.Rewards.FindPrompt(holder)
        if not prompt then continue end
        Theseus.Rewards.PromptAt[holder] = os.clock()
        if Theseus.Rewards.TriggerPrompt(prompt) then fired += 1 end
    end
    return fired
end

---@return integer  claims fired
function Theseus.Rewards.Claim(force)
    local fired = 0
    if Theseus.Rewards.ClaimIndex() then fired += 1 end
    if Theseus.Rewards.ClaimOffline() then fired += 1 end
    fired += Theseus.Rewards.ClaimPrompts(force)
    return fired
end

function Theseus.Rewards.ClaimNow()
    local fired = Theseus.Rewards.Claim(true)
    Theseus.Util.Notify("Rewards", fired > 0 and ("Claimed " .. fired .. " rewards") or "Nothing to claim right now")
end

function Theseus.Rewards.Step()
    if not Theseus.Util.Opt("AutoClaim") then return end
    Theseus.Rewards.Claim(false)

    local nextStage = Theseus.GameLib.IndexStages[(tonumber(Theseus.Economy.Saved("IndexRewardStage")) or 0) + 1]
    if nextStage then
        Theseus.State.Status.Rewards = "Index " .. Theseus.Rewards.IndexCount() .. "/" .. nextStage.goal
    else
        Theseus.State.Status.Rewards = "Index complete"
    end
end

function Theseus.Rewards.Stop()
    table.clear(Theseus.Rewards.PromptAt)
end

Theseus.Boosts = {
    Last = {},
    Lines = {},
    Primed = false,
}

---@return string|nil  readable line, nil when the boost is not running
function Theseus.Boosts.Describe(name, value)
    if value == nil then return nil end
    local now = Theseus.Util.ServerNow()

    if name:sub(-5) == "Until" then
        local left = (tonumber(value) or 0) - now
        if left <= 0 then return nil end
        return name:gsub("Until$", "") .. ": " .. math.floor(left / 60) .. "m left"
    end

    local amount = tonumber(value)
    if not amount or amount <= 1 then return nil end
    return name .. ": x" .. amount
end

---@return table  { name = line } of running boosts
function Theseus.Boosts.Read()
    local running = {}
    for _, name in ipairs(Theseus.Config.BoostAttributes) do
        running[name] = Theseus.Boosts.Describe(name, ReplicatedStorage:GetAttribute(name))
    end
    running.EventBoostUntil = Theseus.Boosts.Describe("EventBoostUntil", LocalPlayer:GetAttribute("EventBoostUntil"))

    local serverData = ReplicatedStorage:FindFirstChild("ServerData")
    local weather = serverData and serverData:GetAttribute("ActiveWeathers")
    local names = Theseus.Boosts.WeatherNames(weather)
    if names then running.Weather = "Weather: " .. names end
    return running
end

---@param raw any     ServerData ActiveWeathers JSON
---@return string|nil  "Storm, Rain", nil when clear or unreadable
function Theseus.Boosts.WeatherNames(raw)
    if type(raw) ~= "string" or raw == "" then return nil end
    local ok, list = pcall(HttpService.JSONDecode, HttpService, raw)
    if not ok then
        warn(Theseus.Config.Tag, "weather decode:", list)
        return nil
    end
    if type(list) ~= "table" then return nil end

    local names = {}
    for _, entry in pairs(list) do
        local kind = type(entry) == "table" and entry.Type or entry
        local variant = type(entry) == "table" and entry.Variant
        if type(variant) == "string" and variant ~= "" then kind = tostring(kind) .. " (" .. variant .. ")" end
        if type(kind) == "string" and not table.find(names, kind) then names[#names + 1] = kind end
    end
    return #names > 0 and table.concat(names, ", ") or nil
end

function Theseus.Boosts.Announce(name, line)
    Theseus.Util.Notify("Boost", line, 8)
    local webhook = rawget(Theseus, "Webhook")
    if not (webhook and webhook.Push) then return end
    Theseus.Util.Try("boost webhook", webhook.Push, { Kind = "Boost", Title = name, Lines = { line } })
end

function Theseus.Boosts.Step()
    local running = Theseus.Boosts.Read()
    local lines = {}

    for name, line in pairs(running) do
        table.insert(lines, line)
        if Theseus.Boosts.Primed and not Theseus.Boosts.Last[name] then Theseus.Boosts.Announce(name, line) end
    end
    table.sort(lines)

    Theseus.Boosts.Last = running
    Theseus.Boosts.Primed = true
    Theseus.Boosts.Lines = lines
    Theseus.State.Weather = running.Weather and { running.Weather } or {}
    Theseus.State.Status.Boosts = #lines > 0 and table.concat(lines, "\n") or "No boosts running"
end

function Theseus.Boosts.Stop()
    table.clear(Theseus.Boosts.Last)
    Theseus.Boosts.Primed = false
end

Theseus.Prompts = { Active = false, Saved = setmetatable({}, { __mode = "k" }), Connections = {} }

function Theseus.Prompts.Apply(prompt)
    local prompts = Theseus.Prompts
    if not prompts.Active or not Theseus.State.Alive or not prompt.Parent or not prompt:IsA("ProximityPrompt") then return end
    if prompts.Saved[prompt] == nil then prompts.Saved[prompt] = prompt.HoldDuration end
    if prompt.HoldDuration ~= 0 then prompt.HoldDuration = 0 end
end

function Theseus.Prompts.Start()
    local prompts = Theseus.Prompts
    if prompts.Active then return end
    prompts.Active = true
    local service = game:GetService("ProximityPromptService")
    for _, signal in ipairs({ service.PromptShown, service.PromptButtonHoldBegan, Workspace.DescendantAdded }) do
        prompts.Connections[#prompts.Connections + 1] = signal:Connect(prompts.Apply)
    end
    for _, instance in ipairs(Workspace:GetDescendants()) do prompts.Apply(instance) end
end

function Theseus.Prompts.Stop()
    local prompts = Theseus.Prompts
    prompts.Active = false
    for _, connection in ipairs(prompts.Connections) do connection:Disconnect() end
    table.clear(prompts.Connections)
    for prompt, duration in pairs(prompts.Saved) do
        if prompt.Parent then prompt.HoldDuration = duration end
    end
    table.clear(prompts.Saved)
end

do
    local defaults = {
        WalkSpeed = 60, JumpPower = 80, FlySpeed = 120,
        FlingSpin = 2000, FlingForce = 9e4, StickOffset = 2,
        StandLift = 3, StreamTimeout = 5,
        EspLift = 4, EspPool = 48,
        FloatSize = 52, FloatGap = 8,
        ReconnectDelay = 5, ReconnectRetry = 10, ReconnectTries = 6, ReconnectMax = 3, ReconnectWindow = 600,
        ReconnectFile = "Theseus_RideAPet_reconnect.txt",
        HopPick = 15, ServerListUrl = "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100",
        ReloadSource = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/"))()',
        RarityColors = {
            Common = Color3.fromRGB(200, 200, 200), Rare = Color3.fromRGB(90, 170, 255), Epic = Color3.fromRGB(190, 110, 255),
            Legendary = Color3.fromRGB(255, 200, 60), Mythic = Color3.fromRGB(255, 90, 90), Divine = Color3.fromRGB(120, 255, 220),
            Ethereal = Color3.fromRGB(255, 130, 230),
        },
    }
    for key, value in pairs(defaults) do
        if Config[key] == nil then Config[key] = value end
    end
end

Theseus.World = { Conn = nil, Gui = nil }

---@return Instance  hidden gui root, CoreGui or PlayerGui when gethui is missing
function Theseus.World.GuiRoot()
    local caps = Library and Library.Compat and Library.Compat.Caps
    if caps and caps.Hui then
        local ok, hui = pcall(gethui)
        if ok and typeof(hui) == "Instance" then return hui end
    end
    local ok, core = pcall(function() return game:GetService("CoreGui") end)
    if ok and core and pcall(function() return core.Name end) then return core end
    return LocalPlayer:WaitForChild("PlayerGui", Config.LoadTimeout)
end

function Theseus.World.Screen()
    local gui = Theseus.World.Gui
    if gui and gui.Parent then return gui end

    gui = Instance.new("ScreenGui")
    gui.Name = "Theseus"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    local ok = pcall(function() gui.Parent = Theseus.World.GuiRoot() end)
    if not ok then gui.Parent = LocalPlayer:FindFirstChildOfClass("PlayerGui") end
    Theseus.World.Gui = gui
    return gui
end

---@return boolean  any per-frame movement or troll option is on
function Theseus.World.NeedsFrame()
    local opt = Theseus.Util.Opt
    return opt("SpeedOn") or opt("JumpOn") or opt("Fly") or opt("NoClip") or opt("Fling") or opt("Stick") or false
end

function Theseus.World.Sync()
    local world = Theseus.World
    if world.NeedsFrame() then
        if world.Conn then return end
        world.Conn = Theseus:Connect(RunService.Heartbeat, function(dt)
            Theseus.Util.Try("Move.Frame", Theseus.Move.Frame, dt)
            Theseus.Util.Try("Troll.Frame", Theseus.Troll.Frame)
        end)
        return
    end
    if world.Conn then
        world.Conn:Disconnect()
        world.Conn = nil
    end
end

function Theseus.World.Carrying()
    return Theseus.Tasks.Carrying()
end

Theseus.Teleport = {}

local GroundRay = RaycastParams.new()
GroundRay.FilterType = Enum.RaycastFilterType.Exclude
GroundRay.RespectCanCollide = true
local GroundRayOf = nil

---@return CFrame  stand height over the real surface at pos, raycast first
local function GroundCF(pos)
    local char = Theseus.Player.Char
    if GroundRayOf ~= char then
        GroundRayOf = char
        GroundRay.FilterDescendantsInstances = { char or Workspace }
    end

    local origin = pos + Vector3.new(0, Config.GroundRayUp, 0)
    local hit = Workspace:Raycast(origin, Vector3.new(0, -(Config.GroundRayUp + Config.GroundRayDown), 0), GroundRay)
    if hit then
        return CFrame.new(hit.Position + Vector3.new(0, Config.StandLift, 0))
    end
    return CFrame.new(pos)
end

---@return CFrame  a standing spot on top of a part
local function Above(part)
    return GroundCF(part.Position + Vector3.new(0, part.Size.Y / 2 + Config.StandLift, 0))
end

---@return table<string, function>  label -> CFrame getter
function Theseus.Teleport.Places()
    local places = {}
    places["My Plot"] = function()
        local _, bp = Theseus.Player:Plot()
        return bp and Above(bp)
    end

    local spawns = Workspace:FindFirstChild("EggSpawns")
    local seen = {}
    for _, pad in ipairs(spawns and spawns:GetChildren() or {}) do
        if not pad:IsA("BasePart") then continue end
        local rarity = pad.Name:gsub("%-+$", "")
        seen[rarity] = (seen[rarity] or 0) + 1
        places["Eggs: " .. rarity .. " #" .. seen[rarity]] = function() return Above(pad) end
    end

    for _, folderName in ipairs({ "Stalls", "Functionals" }) do
        local folder = Workspace:FindFirstChild(folderName)
        for _, spot in ipairs(folder and folder:GetChildren() or {}) do
            if not (spot:IsA("Model") or spot:IsA("BasePart")) then continue end
            if spot.Name:find("^AlwaysStream") then continue end
            places[folderName .. ": " .. spot.Name] = function()
                return GroundCF(spot:GetPivot().Position + Vector3.new(0, Config.StandLift, 0))
            end
        end
    end

    local plots = Workspace:FindFirstChild("Plots")
    for _, plot in ipairs(plots and plots:GetChildren() or {}) do
        local owner = plot:FindFirstChild("Data") and plot.Data:FindFirstChild("Owner")
        local player = owner and owner.Value
        local bp = plot:FindFirstChild("Baseplate")
        if not bp or not player or player == LocalPlayer then continue end
        places["Plot: " .. player.Name] = function() return Above(bp) end
    end

    places["Volcano"] = Theseus.Teleport.VolcanoSpot

    local halloween = rawget(Theseus, "Halloween")
    if halloween and halloween.Places then
        for label, getter in pairs(halloween.Places()) do
            places[label] = getter
        end
    end
    return places
end

---@return CFrame|nil  top of the volcano once it streams in, else its centre
function Theseus.Teleport.VolcanoSpot()
    local center = Config.VolcanoCenter
    pcall(LocalPlayer.RequestStreamAroundAsync, LocalPlayer, center, Config.StreamTimeout)

    local tagged = game:GetService("CollectionService"):GetTagged("VolcanoTop")
    for _, part in ipairs(tagged) do
        if part:IsA("BasePart") then return Above(part) end
    end
    return CFrame.new(center)
end

---@return string[]  sorted; egg pads by rarity order
function Theseus.Teleport.PlaceNames()
    local rank = GameLib.RarityRank
    local names = {}
    for name in pairs(Theseus.Teleport.Places()) do
        names[#names + 1] = name
    end

    table.sort(names, function(a, b)
        local ra = rank[a:match("^Eggs: (.-) #") or ""] or 0
        local rb = rank[b:match("^Eggs: (.-) #") or ""] or 0
        if ra ~= rb then return ra < rb end
        return a < b
    end)
    return names
end

---@return boolean  moved; refused while an egg is carried or another task drives
function Theseus.Teleport.Go(cf)
    if not cf then return false end
    if Theseus.World.Carrying() then
        Theseus.Util.Notify("Teleport", "Finish the egg delivery first")
        return false
    end

    local token = Theseus.Tasks.Request("Manual", Theseus.Tasks.Prio.Manual)
    if not token then
        Theseus.Util.Notify("Teleport", "Busy with farming, try again in a moment")
        return false
    end
    token.home = nil
    local moved = Theseus.Tasks.Teleport(token, cf)
    Theseus.Tasks.Release(token)
    return moved
end

function Theseus.Teleport.To(name)
    local getter = Theseus.Teleport.Places()[name or ""]
    if not getter then return false end
    return Theseus.Teleport.Go(getter())
end

function Theseus.Teleport.ToPlayer(name)
    local target = Players:FindFirstChild(name or "")
    if not target or target == LocalPlayer then return false end
    local hrp = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        Theseus.Util.Notify("Teleport", target.Name .. " is too far to see right now")
        return false
    end
    return Theseus.Teleport.Go(hrp.CFrame + Vector3.new(0, Config.StandLift, 0))
end

function Theseus.Teleport.Home()
    return Theseus.Teleport.To("My Plot")
end

Theseus.Move = { Saved = {}, Patched = {}, Parts = {}, PartsOf = nil, Conns = {}, Floats = {}, FlyWarned = false }

---@param idx string   option id
---@param on  boolean
function Theseus.Move.Set(idx, on)
    Theseus.Options[idx] = on
    local move = Theseus.Move
    local hum = Theseus.Player.Humanoid

    if on and hum then
        if idx == "SpeedOn" and move.Saved.WalkSpeed == nil then move.Saved.WalkSpeed = hum.WalkSpeed end
        if idx == "JumpOn" and move.Saved.JumpPower == nil then
            move.Saved.JumpPower, move.Saved.UseJumpPower = hum.JumpPower, hum.UseJumpPower
        end
    end
    if idx == "InfJump" then move.BindJump(on) end
    if idx == "AntiAfk" then move.BindIdle(on) end
    if not on then move.Restore(idx) end
    Theseus.World.Sync()
end

function Theseus.Move.BindJump(on)
    local move = Theseus.Move
    if move.Conns.Jump then
        move.Conns.Jump:Disconnect()
        move.Conns.Jump = nil
    end
    if not on then return end

    move.Conns.Jump = Theseus:Connect(UserInputService.JumpRequest, function()
        local hum = Theseus.Player.Humanoid
        if hum and hum.Health > 0 then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)
end

function Theseus.Move.BindIdle(on)
    local move = Theseus.Move
    if move.Conns.Idle then
        move.Conns.Idle:Disconnect()
        move.Conns.Idle = nil
    end
    if not on then return end

    move.Conns.Idle = Theseus:Connect(LocalPlayer.Idled, function()
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end)
end

---@return BasePart[]  character parts, rebuilt only when the character changes
function Theseus.Move.CharParts()
    local move, char = Theseus.Move, Theseus.Player.Char
    if move.PartsOf == char then return move.Parts end

    table.clear(move.Parts)
    move.PartsOf = char
    for _, part in ipairs(char and char:GetDescendants() or {}) do
        if part:IsA("BasePart") then move.Parts[#move.Parts + 1] = part end
    end
    return move.Parts
end

function Theseus.Move.NoClip(on)
    local patched = Theseus.Move.Patched
    if not on then
        for part in pairs(patched) do
            if part.Parent then part.CanCollide = true end
        end
        table.clear(patched)
        return
    end

    for _, part in ipairs(Theseus.Move.CharParts()) do
        if part.Parent and part.CanCollide then
            patched[part] = true
            part.CanCollide = false
        end
    end
end

---@return Vector3  wanted direction from keys or the touch stick
function Theseus.Move.FlyDirection(hum, cam)
    local look = cam.CFrame.LookVector
    local dir = hum.MoveDirection
    if dir.Magnitude > 0 then
        local flat = Vector3.new(look.X, 0, look.Z)
        local forward = flat.Magnitude > 0 and dir:Dot(flat.Unit) or 0
        dir += Vector3.new(0, look.Y * forward, 0)
    end

    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.yAxis end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= Vector3.yAxis end
    return dir
end

function Theseus.Move.FlyStep(dt)
    local hrp, hum = Theseus.Player.Root, Theseus.Player.Humanoid
    local cam = Workspace.CurrentCamera
    if not hrp or not hum or not cam then return end

    if Theseus.World.Carrying() or Theseus.Tasks.Owner() then
        if not Theseus.Move.FlyWarned and Theseus.World.Carrying() then
            Theseus.Move.FlyWarned = true
            Theseus.Util.Notify("Fly", "Fly pauses while you carry an egg")
        end
        return
    end
    Theseus.Move.FlyWarned = false

    hrp.AssemblyLinearVelocity = Vector3.zero
    local dir = Theseus.Move.FlyDirection(hum, cam)
    if dir.Magnitude == 0 then return end
    hrp.CFrame += dir.Unit * (tonumber(Theseus.Util.Opt("FlySpeed")) or Config.FlySpeed) * dt
end

function Theseus.Move.Frame(dt)
    local opt = Theseus.Util.Opt
    local hum = Theseus.Player.Humanoid

    if opt("NoClip") or opt("Fly") or opt("Fling") then Theseus.Move.NoClip(true) end
    if opt("Fly") then Theseus.Move.FlyStep(dt) end
    if not hum then return end

    if opt("SpeedOn") then hum.WalkSpeed = tonumber(opt("WalkSpeed")) or Config.WalkSpeed end
    if opt("JumpOn") then
        hum.UseJumpPower = true
        hum.JumpPower = tonumber(opt("JumpPower")) or Config.JumpPower
    end
end

---@param idx string|nil  option that turned off; nil restores everything
function Theseus.Move.Restore(idx)
    local move, opt = Theseus.Move, Theseus.Util.Opt
    local hum, hrp = Theseus.Player.Humanoid, Theseus.Player.Root

    if hum and (idx == nil or idx == "SpeedOn") and move.Saved.WalkSpeed then
        hum.WalkSpeed = move.Saved.WalkSpeed
        move.Saved.WalkSpeed = nil
    end
    if hum and (idx == nil or idx == "JumpOn") and move.Saved.JumpPower then
        hum.JumpPower = move.Saved.JumpPower
        hum.UseJumpPower = move.Saved.UseJumpPower
        move.Saved.JumpPower, move.Saved.UseJumpPower = nil, nil
    end

    if idx == nil or not (opt("NoClip") or opt("Fly") or opt("Fling")) then move.NoClip(false) end
    if (idx == nil or idx == "Fly") and hrp then hrp.AssemblyLinearVelocity = Vector3.zero end

    if idx == nil then
        move.BindJump(false)
        move.BindIdle(false)
        move.ClearFloats()
        Theseus.Esp.Clear()
        if Theseus.World.Gui then
            Theseus.World.Gui:Destroy()
            Theseus.World.Gui = nil
        end
        if Theseus.World.Conn then
            Theseus.World.Conn:Disconnect()
            Theseus.World.Conn = nil
        end
    end
end

---@param list table  { {idx, text}, ... } toggles that get a draggable touch button
function Theseus.Move.BuildFloats(list)
    if not Theseus.Platform.Touch then return end
    local move = Theseus.Move
    move.ClearFloats()

    local screen = Theseus.World.Screen()
    local size, gap = Config.FloatSize, Config.FloatGap
    for i, row in ipairs(list) do
        local button = move.FloatButton(screen, row[1], row[2])
        button.Position = UDim2.new(1, -(size + gap) * 2, 0.3, (i - 1) * (size + gap))
        table.insert(move.Floats, button)
    end
end

---@return TextButton
function Theseus.Move.FloatButton(screen, idx, text)
    local button = Instance.new("TextButton")
    button.Name = "Float_" .. idx
    button.Size = UDim2.fromOffset(Config.FloatSize, Config.FloatSize)
    button.BackgroundColor3 = Color3.fromRGB(27, 21, 18)
    button.BackgroundTransparency = 0.25
    button.TextColor3 = Color3.fromRGB(232, 160, 76)
    button.Font = Enum.Font.GothamBold
    button.TextScaled = true
    button.Text = text
    button.Active = true
    button.Draggable = true
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 12)
    button.Parent = screen

    local pressedAt
    button.MouseButton1Down:Connect(function() pressedAt = button.AbsolutePosition end)
    button.MouseButton1Up:Connect(function()
        if pressedAt and (button.AbsolutePosition - pressedAt).Magnitude > 6 then return end
        local option = Library and Library.Options and Library.Options[idx]
        if option then option:SetValue(not option.Value) end
    end)
    return button
end

function Theseus.Move.ClearFloats()
    for _, button in ipairs(Theseus.Move.Floats) do
        button:Destroy()
    end
    table.clear(Theseus.Move.Floats)
end

Theseus.Troll = { Token = nil, Home = nil }

function Theseus.Troll.TargetRoot()
    local target = Players:FindFirstChild(Theseus.Util.Opt("TrollTarget") or "")
    if not target or target == LocalPlayer then return nil end
    return target.Character and target.Character:FindFirstChild("HumanoidRootPart")
end

---@param idx string  "Fling" | "Stick"
function Theseus.Troll.Set(idx, on)
    Theseus.Options[idx] = on
    if on and Theseus.World.Carrying() then
        Theseus.Util.Notify("Troll", "Finish the egg delivery first")
        table.insert(State.PendingToggleOff, idx)
        Theseus.Options[idx] = false
        return
    end
    if not on then Theseus.Troll.Stop(idx) end
    Theseus.World.Sync()
end

---@return table|nil  manual task token, nil while farming drives the character
function Theseus.Troll.Hold()
    local troll = Theseus.Troll
    if troll.Token and Theseus.Tasks.Holds(troll.Token) then return troll.Token end
    troll.Token = nil
    if Theseus.World.Carrying() then return nil end

    local token = Theseus.Tasks.Request("Troll", Theseus.Tasks.Prio.Manual)
    if not token then return nil end
    token.home = nil
    troll.Token = token
    return token
end

function Theseus.Troll.Frame()
    local opt = Theseus.Util.Opt
    if not opt("Fling") and not opt("Stick") then return end
    local target, hrp = Theseus.Troll.TargetRoot(), Theseus.Player.Root
    if not target or not hrp then return end
    if not Theseus.Troll.Hold() then return end

    Theseus.Troll.Home = Theseus.Troll.Home or hrp.CFrame
    if opt("Fling") then
        local spin = math.rad(os.clock() * Config.FlingSpin % 360)
        hrp.CFrame = target.CFrame * CFrame.Angles(0, spin, 0)
        hrp.AssemblyLinearVelocity = Vector3.new(0, Config.FlingForce, 0)
        hrp.AssemblyAngularVelocity = Vector3.new(0, Config.FlingForce, 0)
        return
    end
    hrp.CFrame = target.CFrame * CFrame.new(0, 0, Config.StickOffset)
end

---@param idx string|nil  toggle that turned off; nil on unload
function Theseus.Troll.Stop(idx)
    local troll, hrp = Theseus.Troll, Theseus.Player.Root
    if hrp then
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end
    if idx then Theseus.Move.Restore(idx) end
    local opt = Theseus.Util.Opt
    if idx and (opt("Fling") or opt("Stick")) then return end

    local token = troll.Token
    troll.Token = nil
    if token and Theseus.Tasks.Holds(token) then
        if troll.Home then Theseus.Tasks.Teleport(token, troll.Home) end
        Theseus.Tasks.Release(token)
    end
    troll.Home = nil
    if idx == nil then Theseus.Troll.Spectate(nil) end
end

---@param name string|nil  nil returns the camera to us
function Theseus.Troll.Spectate(name)
    local cam = Workspace.CurrentCamera
    if not cam then return end
    local target = name and Players:FindFirstChild(name)
    local hum = target and target.Character and target.Character:FindFirstChildOfClass("Humanoid")
    cam.CameraSubject = hum or Theseus.Player.Humanoid

    local troll = Theseus.Troll
    if troll.LeaveConn then
        troll.LeaveConn:Disconnect()
        troll.LeaveConn = nil
    end
    if not hum then return end
    troll.LeaveConn = Theseus:Connect(Players.PlayerRemoving, function(player)
        if player == target then Theseus.Troll.Spectate(nil) end
    end)
end

Theseus.Server = { Hopping = false }

function Theseus.Server.QueueReload()
    return Theseus.Util.Queue(Config.ReloadSource)
end

---@return boolean  teleport started
function Theseus.Server.Rejoin()
    if Theseus.World.Carrying() then
        Theseus.Util.Notify("Server", "Finish the egg delivery first")
        return false
    end
    Theseus.Server.QueueReload()
    local ok, err = pcall(TeleportService.TeleportToPlaceInstance, TeleportService, game.PlaceId, game.JobId, LocalPlayer)
    if not ok then warn(Config.Tag, "rejoin:", err) end
    return ok
end

---@return string[]  open public server ids other than ours
function Theseus.Server.OpenServers()
    local body = Theseus.Util.HttpGet(Config.ServerListUrl:format(game.PlaceId))
    local ok, decoded = pcall(HttpService.JSONDecode, HttpService, body or "")
    local open = {}
    if not ok or type(decoded) ~= "table" then return open end

    for _, server in ipairs(decoded.data or {}) do
        local playing, cap = tonumber(server.playing) or 0, tonumber(server.maxPlayers) or 0
        if server.id ~= game.JobId and playing < cap then table.insert(open, server.id) end
    end
    return open
end

---@return boolean  teleport started
function Theseus.Server.Hop()
    local server = Theseus.Server
    if server.Hopping then return false end
    if Theseus.World.Carrying() then
        Theseus.Util.Notify("Server", "Finish the egg delivery first")
        return false
    end

    server.Hopping = true
    task.delay(Config.LoadTimeout, function() server.Hopping = false end)
    server.QueueReload()

    local open = server.OpenServers()
    local ok, err
    if #open > 0 then
        local pick = open[math.random(1, math.min(#open, Config.HopPick))]
        ok, err = pcall(TeleportService.TeleportToPlaceInstance, TeleportService, game.PlaceId, pick, LocalPlayer)
    else
        ok, err = pcall(TeleportService.Teleport, TeleportService, game.PlaceId, LocalPlayer)
    end
    if not ok then warn(Config.Tag, "hop:", err) end
    return ok
end

Theseus.Server.IdleKeepers = { "AntiAfk", "AutoEggs", "EggHunter", "Kaitun" }

---@return boolean  under the cap, so a kick loop cannot rejoin forever
function Theseus.Server.ReconnectBudget()
    if not (Library and Library.Compat and Library.Compat.Caps.FileSystem) then return true end
    local now, recent = os.time(), {}
    local ok, raw = pcall(readfile, Config.ReconnectFile)
    for stamp in (ok and tostring(raw) or ""):gmatch("%d+") do
        if now - tonumber(stamp) < Config.ReconnectWindow then recent[#recent + 1] = stamp end
    end
    if #recent >= Config.ReconnectMax then return false end
    recent[#recent + 1] = tostring(now)
    local wrote, err = pcall(writefile, Config.ReconnectFile, table.concat(recent, ","))
    if not wrote then warn(Config.Tag, "reconnect log:", err) end
    return true
end

function Theseus.Server.OnError()
    local server = Theseus.Server
    local message = GuiService:GetErrorMessage()
    if server.Reconnecting or message == "" or not Theseus.Util.Opt("AutoReconnect") then return end
    if message:lower():find("ban") then return end
    server.Reconnecting = true

    task.delay(Config.ReconnectDelay, function()
        if not server.ReconnectBudget() then
            warn(Config.Tag, "reconnect: too many disconnects, staying out")
            return
        end
        server.QueueReload()
        for _ = 1, Config.ReconnectTries do
            local ok, err = pcall(TeleportService.Teleport, TeleportService, game.PlaceId, LocalPlayer)
            if not ok then warn(Config.Tag, "reconnect:", err) end
            task.wait(Config.ReconnectRetry)
        end
    end)
end

function Theseus.Server.Step()
    local server = Theseus.Server
    if not server.ErrorConn and Theseus.Util.Opt("AutoReconnect") then
        server.ErrorConn = Theseus:Connect(GuiService.ErrorMessageChanged, server.OnError)
    end

    local want = false
    for _, idx in ipairs(Theseus.Server.IdleKeepers) do
        if Theseus.Util.Opt(idx) then want = true break end
    end
    if want ~= (Theseus.Move.Conns.Idle ~= nil) then Theseus.Move.BindIdle(want) end
end

function Theseus.Server.Stop()
    Theseus.Server.Hopping = false
end

Theseus.Esp = { Boards = {}, Pool = {}, Anchors = {}, Made = {} }

---@return Color3  preset, or a hue by rank for rarities the game adds later
function Theseus.Esp.Color(rarity)
    local preset = Config.RarityColors[rarity]
    if preset then return preset end
    local rank = GameLib.RarityRank[rarity]
    if not rank then return Color3.new(1, 1, 1) end
    return Color3.fromHSV(rank / math.max(#GameLib.RarityOrder, 1) * 0.85, 0.55, 1)
end

---@return table  { board, label, anchor } from the pool
function Theseus.Esp.Take()
    local spare = table.remove(Theseus.Esp.Pool)
    if spare then return spare end

    local anchor = Instance.new("Attachment")
    anchor.Name = "TheseusEspAnchor"
    anchor.Parent = Workspace.Terrain

    local board = Instance.new("BillboardGui")
    board.Name = "TheseusEsp"
    board.AlwaysOnTop = true
    board.Size = UDim2.fromOffset(Theseus.Platform.Mobile and 150 or 200, Theseus.Platform.Mobile and 30 or 40)
    board.StudsOffset = Vector3.new(0, Config.EspLift, 0)
    board.Adornee = anchor

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.fromScale(1, 1)
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true
    label.TextStrokeTransparency = 0.3
    label.Parent = board
    board.Parent = Theseus.World.Screen()
    local slot = { board = board, label = label, anchor = anchor }
    Theseus.Esp.Made[slot] = true
    return slot
end

function Theseus.Esp.Give(guid)
    local esp = Theseus.Esp
    local slot = esp.Boards[guid]
    if not slot then return end
    esp.Boards[guid] = nil

    if #esp.Pool >= Config.EspPool then
        esp.Drop(slot)
        return
    end
    slot.board.Enabled = false
    table.insert(esp.Pool, slot)
end

---@param boards table  another module's board map
---@param key    string key in that map
function Theseus.Esp.Disown(boards, key)
    local esp = Theseus.Esp
    local slot = boards[key]
    if not slot then return end
    boards[key] = nil

    if #esp.Pool >= Config.EspPool then
        esp.Drop(slot)
        return
    end
    slot.board.Enabled = false
    table.insert(esp.Pool, slot)
end

---@return boolean  entry passes the rarity floor and is visible to us
function Theseus.Esp.Shows(entry, minRank)
    if entry.removed or not entry.egg or typeof(entry.pos) ~= "Vector3" then return false end
    if entry.privateTo and entry.privateTo ~= LocalPlayer.UserId then return false end
    local info = GameLib.EggInfo[entry.egg]
    return info ~= nil and (GameLib.RarityRank[info.rarity] or 1) >= minRank
end

function Theseus.Esp.Drop(slot)
    Theseus.Esp.Made[slot] = nil
    slot.board:Destroy()
    slot.anchor:Destroy()
end

function Theseus.Esp.Step()
    if not Theseus.State.Alive or not Theseus.Util.Opt("EggEsp") then return end
    if not Theseus.EggIndex.Start() then return end
    local esp = Theseus.Esp
    local hrp = Theseus.Player.Root
    local range = Theseus.Platform.Mobile and Config.EspRangeMobile or Config.EspRange
    local minRank = GameLib.RarityRank[Theseus.Util.Opt("EspMinRarity") or ""] or 1
    local seen = {}

    for guid, entry in pairs(Theseus.EggIndex.Entries) do
        if not esp.Shows(entry, minRank) then continue end
        local dist = hrp and (entry.pos - hrp.Position).Magnitude or 0
        if dist > range then continue end

        seen[guid] = true
        local slot = esp.Boards[guid]
        if not slot then
            slot = esp.Take()
            esp.Boards[guid] = slot
        end
        local info = GameLib.EggInfo[entry.egg]
        local mutation = entry.mutation and entry.mutation ~= "" and (" " .. entry.mutation) or ""
        slot.anchor.WorldPosition = entry.pos
        slot.board.MaxDistance = range
        slot.board.Enabled = true
        slot.label.TextColor3 = esp.Color(info.rarity)
        slot.label.Text = string.format("%s [%s]%s\n%.2fkg | %dm", entry.egg, info.rarity, mutation, entry.weight or 1, math.floor(dist))
    end

    for guid in pairs(esp.Boards) do
        if not seen[guid] then esp.Give(guid) end
    end
end

function Theseus.Esp.Clear()
    local esp = Theseus.Esp
    for slot in pairs(esp.Made) do
        esp.Drop(slot)
    end
    table.clear(esp.Boards)
    table.clear(esp.Pool)
end

function Theseus.Esp.Stop()
    Theseus.Esp.Clear()
end

do
    local defaults = {
        OwnPetReach = 25, BoostBatch = 400, FpsCapDefault = 240, FpsCapRestore = 60,
        BoostClasses = { ParticleEmitter = true, Trail = true, Beam = true, Smoke = true, Fire = true, Sparkles = true },
    }
    for key, value in pairs(defaults) do
        if Config[key] == nil then Config[key] = value end
    end
end

Theseus.Visual = {
    Holder = Instance.new("Folder"),
    Conns = { Pets = {}, Eggs = {}, Boost = {} },
    Hidden = { Pets = {}, Eggs = {} },
    Disabled = {}, Props = {},
    BoostToken = 0,
    PetSetting = nil,
    CapOn = false,
}

function Theseus.Visual.Drop(kind)
    local list = Theseus.Visual.Conns[kind]
    for _, conn in ipairs(list) do conn:Disconnect() end
    table.clear(list)
end

function Theseus.Visual.Watch(kind, signal, handler)
    table.insert(Theseus.Visual.Conns[kind], Theseus:Connect(signal, handler))
end

---@param kind string  "Pets" or "Eggs"
function Theseus.Visual.Hide(kind, model)
    local hidden = Theseus.Visual.Hidden[kind]
    if hidden[model] or not model.Parent then return end
    hidden[model] = model.Parent
    model.Parent = Theseus.Visual.Holder
end

function Theseus.Visual.Show(kind, model)
    local hidden = Theseus.Visual.Hidden[kind]
    local home = hidden[model]
    if not home then return end
    hidden[model] = nil
    if model.Parent ~= Theseus.Visual.Holder or not home.Parent then return end
    pcall(function() model.Parent = home end)
end

function Theseus.Visual.ShowAll(kind)
    local models = {}
    for model in pairs(Theseus.Visual.Hidden[kind]) do models[#models + 1] = model end
    for _, model in ipairs(models) do Theseus.Visual.Show(kind, model) end
end

---@return boolean  true when the ridden pet belongs to someone else
function Theseus.Visual.ForeignPet(model)
    if not model:IsA("Model") or model:GetAttribute("Ridden") ~= true then return false end
    local ownerId = model:GetAttribute("OwnerUserId")
    if ownerId ~= nil then return ownerId ~= LocalPlayer.UserId end
    local owner = model:GetAttribute("Owner")
    if owner ~= nil then return owner ~= LocalPlayer.UserId and owner ~= LocalPlayer.Name end

    local char = LocalPlayer.Character
    if char and model:IsDescendantOf(char) then return false end
    if LocalPlayer:GetAttribute("IsRiding") ~= true then return true end
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    return (model:GetPivot().Position - hrp.Position).Magnitude > Config.OwnPetReach
end

function Theseus.Visual.TrackPet(model)
    if not model:IsA("Model") then return end
    Theseus.Visual.Watch("Pets", model:GetAttributeChangedSignal("Ridden"), function()
        if model:GetAttribute("Ridden") == true then
            if Theseus.Visual.ForeignPet(model) then Theseus.Visual.Hide("Pets", model) end
        else
            Theseus.Visual.Show("Pets", model)
        end
    end)
    if Theseus.Visual.ForeignPet(model) then Theseus.Visual.Hide("Pets", model) end
end

function Theseus.Visual.HidePets(on)
    Theseus.Visual.Drop("Pets")
    local remote = Theseus.GameLib.Remote("UpdateSetting")

    if not on then
        Theseus.Visual.ShowAll("Pets")
        if remote and Theseus.Visual.PetSetting ~= nil then remote:FireServer("ViewOtherPets", Theseus.Visual.PetSetting) end
        Theseus.Visual.PetSetting = nil
        return
    end

    if remote and Theseus.Visual.PetSetting == nil then
        Theseus.Visual.PetSetting = LocalPlayer:GetAttribute("Setting_ViewOtherPets") ~= false
        remote:FireServer("ViewOtherPets", false)
    end

    local objects = Workspace:FindFirstChild("GameObjects")
    if not objects then return end
    for _, model in ipairs(objects:GetChildren()) do Theseus.Visual.TrackPet(model) end
    Theseus.Visual.Watch("Pets", objects.ChildAdded, Theseus.Visual.TrackPet)
end

function Theseus.Visual.HideEggs(on)
    Theseus.Visual.Drop("Eggs")
    if not on then return Theseus.Visual.ShowAll("Eggs") end

    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return end
    for _, plot in ipairs(plots:GetChildren()) do
        local owner = plot:FindFirstChild("Data") and plot.Data:FindFirstChild("Owner")
        local eggs = plot:FindFirstChild("Eggs")
        if not owner or not eggs or owner.Value == LocalPlayer then continue end

        for _, egg in ipairs(eggs:GetChildren()) do
            if egg:IsA("Model") then Theseus.Visual.Hide("Eggs", egg) end
        end
        Theseus.Visual.Watch("Eggs", eggs.ChildAdded, function(egg)
            if egg:IsA("Model") and owner.Value ~= LocalPlayer then Theseus.Visual.Hide("Eggs", egg) end
        end)
    end
end

---@param target Instance  property owner, original value saved once
function Theseus.Visual.SetProp(target, prop, value)
    local key = target:GetFullName() .. "." .. prop
    local props = Theseus.Visual.Props
    local ok, old = pcall(function() return target[prop] end)
    if not ok then return end
    if not props[key] then props[key] = { target, prop, old } end
    pcall(function() target[prop] = value end)
end

function Theseus.Visual.Mute(inst)
    if not Config.BoostClasses[inst.ClassName] or Theseus.Visual.Disabled[inst] ~= nil then return end
    local char = LocalPlayer.Character
    if char and inst:IsDescendantOf(char) then return end
    if not inst.Enabled then return end
    Theseus.Visual.Disabled[inst] = true
    inst.Enabled = false
end

function Theseus.Visual.Sweep(token)
    local list = Workspace:GetDescendants()
    for i, inst in ipairs(list) do
        if Theseus.Visual.BoostToken ~= token then return end
        Theseus.Visual.Mute(inst)
        if i % Config.BoostBatch == 0 then task.wait() end
    end
end

function Theseus.Visual.Boost(on)
    Theseus.Visual.Drop("Boost")
    Theseus.Visual.BoostToken += 1

    if not on then
        for inst in pairs(Theseus.Visual.Disabled) do
            if inst.Parent then pcall(function() inst.Enabled = true end) end
        end
        table.clear(Theseus.Visual.Disabled)
        for _, row in pairs(Theseus.Visual.Props) do
            pcall(function() row[1][row[2]] = row[3] end)
        end
        table.clear(Theseus.Visual.Props)
        return
    end

    local lighting = game:GetService("Lighting")
    local terrain = Workspace:FindFirstChildOfClass("Terrain")
    Theseus.Visual.SetProp(lighting, "GlobalShadows", false)
    for _, holder in ipairs({ lighting, Workspace.CurrentCamera }) do
        for _, effect in ipairs(holder and holder:GetChildren() or {}) do
            if effect:IsA("PostEffect") then Theseus.Visual.SetProp(effect, "Enabled", false) end
        end
    end
    if terrain then
        Theseus.Visual.SetProp(terrain, "Decoration", false)
        Theseus.Visual.SetProp(terrain, "WaterWaveSize", 0)
        Theseus.Visual.SetProp(terrain, "WaterReflectance", 0)
    end
    pcall(function() Theseus.Visual.SetProp(settings().Rendering, "QualityLevel", Enum.QualityLevel.Level01) end)

    Theseus.Visual.Watch("Boost", Workspace.DescendantAdded, Theseus.Visual.Mute)
    task.spawn(Theseus.Visual.Sweep, Theseus.Visual.BoostToken)
end

---@return boolean  false when the executor cannot cap fps
---@return boolean  the cap was applied; turning it off puts back the cap the player had before
function Theseus.Visual.Cap(on)
    local visual = Theseus.Visual
    if on and not visual.CapOn then
        local ok, before = pcall(function() return getfpscap() end)
        visual.CapBefore = ok and tonumber(before) or nil
    end
    visual.CapOn = on
    local fps = on and (tonumber(Theseus.Options.FpsCap) or Config.FpsCapDefault) or (visual.CapBefore or Config.FpsCapRestore)
    return Theseus.Util.SetFpsCap(fps)
end

function Theseus.Visual.Render(on)
    RunService:Set3dRenderingEnabled(not on)
end

function Theseus.Visual.Stop()
    local try = Theseus.Util.Try
    try("visual pets", Theseus.Visual.HidePets, false)
    try("visual eggs", Theseus.Visual.HideEggs, false)
    try("visual boost", Theseus.Visual.Boost, false)
    if Theseus.Visual.CapOn then try("visual cap", Theseus.Visual.Cap, false) end
    try("visual render", Theseus.Visual.Render, false)
end

do
    local defaults = {
        WebhookPattern = "^https://[%w%.]*discord[app]*%.com/api/webhooks/%d+/[%w_%-]+$",
        WebhookGap = 1.2, WebhookQueueMax = 20,
        WebhookLogo = "https://raw.githubusercontent.com/Theseus/blob/main/logo.png",
        WebhookAvatarApi = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=%d&size=150x150&format=Png",
        WebhookIcons = { Egg = "🥚", Server = "📡", Magma = "🌋", Pet = "🐾", Rebirth = "♻️", Kick = "⚠️", Report = "📊", Test = "✅", Fail = "🛑" },
        WebhookColors = { Egg = 0xE8A04C, Pet = 0x7DD87D, Magma = 0xFF5A2A, Server = 0xFF82E6, Rebirth = 0x5AB4FF, Kick = 0xE04848, Report = 0x9AA4B0, Test = 0xE8A04C, Fail = 0xE04848 },
    }
    for key, value in pairs(defaults) do
        if Config[key] == nil then Config[key] = value end
    end
end

Theseus.Webhook = {
    Events = { "Rare Egg Picked", "Rare Egg In Server", "Magma Dip", "Pet Hatched", "Rebirth", "Egg Returned", "Kicked", "Status Report" },
    Queue = {}, Sending = false, Booted = false,
    SeenPets = {}, SeenEggs = {},
    LastReport = os.clock(), StartedAt = os.clock(),
    Avatar = nil, Baseline = nil, Conns = {},
    Counts = { Eggs = 0, Rare = 0, Dips = 0, Magma = 0, Pets = 0 },
}

---@return boolean  looks like a Discord webhook url
function Theseus.Webhook.Valid(url)
    return type(url) == "string" and url:match(Config.WebhookPattern) ~= nil
end

function Theseus.Webhook.Wants(event)
    local opt = Theseus.Util.Opt
    if opt("Webhook") == false then return false end
    if not Theseus.Webhook.Valid(opt("WebhookUrl")) then return false end
    local events = opt("WebhookEvents")
    return type(events) == "table" and events[event] == true
end

---@return number  embed colour, the event colour when the rarity has no preset
function Theseus.Webhook.Color(rarity, kind)
    local color = rarity and Config.RarityColors and Config.RarityColors[rarity]
    if not color then return Config.WebhookColors[kind] or Config.WebhookColors.Report end
    return math.floor(color.R * 255) * 65536 + math.floor(color.G * 255) * 256 + math.floor(color.B * 255)
end

function Theseus.Webhook.Duration(seconds)
    seconds = math.max(0, math.floor(seconds))
    local hours, minutes = math.floor(seconds / 3600), math.floor(seconds % 3600 / 60)
    if hours > 0 then return string.format("%dh %02dm", hours, minutes) end
    return string.format("%dm %02ds", minutes, seconds % 60)
end

---@return string|nil  headshot url, fetched once
function Theseus.Webhook.AvatarUrl()
    local hook = Theseus.Webhook
    if hook.Avatar ~= nil then return hook.Avatar or nil end
    hook.Avatar = false

    local body = Theseus.Util.HttpGet(Config.WebhookAvatarApi:format(LocalPlayer.UserId))
    local ok, decoded = pcall(HttpService.JSONDecode, HttpService, body or "")
    local row = ok and type(decoded) == "table" and type(decoded.data) == "table" and decoded.data[1]
    if row and type(row.imageUrl) == "string" then hook.Avatar = row.imageUrl end
    return hook.Avatar or nil
end

---@return number
local function SavedNumber(name)
    local saved = LocalPlayer:FindFirstChild("SavedData")
    local value = saved and saved:FindFirstChild(name)
    return value and tonumber(value.Value) or 0
end

function Theseus.Webhook.Income()
    local stats = LocalPlayer:FindFirstChild("leaderstats")
    local income = stats and stats:FindFirstChild("Income/s")
    return income and tonumber(income.Value) or 0
end

---@return table  account and session lines shared by every alert
function Theseus.Webhook.AccountFields()
    local hook = Theseus.Webhook
    local counts, stats = hook.Counts, State.Stats
    local format = Theseus.Util.Format
    return {
        { "💵 Cash", format(SavedNumber("Cash")) },
        { "📈 Income", format(hook.Income()) .. "/s" },
        { "♻️ Rebirths", SavedNumber("Rebirths") },
        { "🥚 Eggs (session)", stats.delivered .. " delivered, " .. counts.Rare .. " rare" },
        { "🌋 Magma (session)", counts.Magma .. " / " .. counts.Dips .. " dips" },
        { "⏱️ Session", hook.Duration(os.clock() - hook.StartedAt) .. " | " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers .. " players" },
    }
end

---@param event table  { Kind, Title, Lines?, Fields?, Rarity?, Ping?, Account?, Thumbnail? }
---@return string      json body
function Theseus.Webhook.Build(event)
    local fields = {}
    for _, field in ipairs(event.Fields or {}) do
        fields[#fields + 1] = { name = field[1], value = tostring(field[2]), inline = field[3] ~= false }
    end
    if event.Account ~= false then
        table.insert(fields, { name = "\u{200B}", value = "**Account**", inline = false })
        for _, field in ipairs(Theseus.Webhook.AccountFields()) do
            fields[#fields + 1] = { name = field[1], value = tostring(field[2]), inline = true }
        end
    end

    return HttpService:JSONEncode({
        username = "Theseus",
        avatar_url = Config.WebhookLogo,
        content = event.Ping and Theseus.Util.Opt("WebhookPing") and "@everyone" or nil,
        embeds = { {
            author = { name = LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")", icon_url = Theseus.Webhook.AvatarUrl() },
            title = (Config.WebhookIcons[event.Kind] or "") .. " " .. event.Title,
            description = event.Lines and table.concat(event.Lines, "\n") or nil,
            color = Theseus.Webhook.Color(event.Rarity, event.Kind),
            fields = fields,
            thumbnail = event.Thumbnail and { url = event.Thumbnail } or nil,
            footer = { text = "Theseus • Ride A Pet", icon_url = Config.WebhookLogo },
            timestamp = DateTime.now():ToIsoDate(),
        } },
    })
end

---@return boolean, string|nil  sent, or false and why
function Theseus.Webhook.Post(url, json)
    local requester = (syn and syn.request) or (http and http.request) or http_request or request
    if not requester then return false, "no http function" end

    local ok, response = pcall(requester, { Url = url, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = json })
    if not ok or type(response) ~= "table" then return false, tostring(response) end
    local code = tonumber(response.StatusCode) or 0
    if code < 200 or code >= 300 then return false, "HTTP " .. code .. " " .. tostring(response.Body):sub(1, 120) end
    return true
end

function Theseus.Webhook.Push(event)
    local queue = Theseus.Webhook.Queue
    if #queue >= Config.WebhookQueueMax then table.remove(queue, 1) end
    queue[#queue + 1] = event
    Theseus.Webhook.Flush()
end

function Theseus.Webhook.Flush()
    local hook = Theseus.Webhook
    if hook.Sending then return end
    hook.Sending = true

    task.spawn(function()
        local queue = hook.Queue
        for _ = 1, Config.WebhookQueueMax do
            if #queue == 0 or not State.Alive then break end
            local url = Theseus.Util.Opt("WebhookUrl")
            if not hook.Valid(url) then
                table.clear(queue)
                break
            end

            local built, json = pcall(hook.Build, table.remove(queue, 1))
            local sent, why = false, json
            if built then sent, why = hook.Post(url, json) end
            if not sent then warn(Config.Tag, "webhook:", why) end
            task.wait(Config.WebhookGap)
        end
        hook.Sending = false
        if #queue > 0 and State.Alive then hook.Flush() end
    end)
end

---@return table|nil  GameLib.EggInfo row when it reaches the rarity floor picked in the menu
function Theseus.Webhook.RareEgg(eggName)
    local info = GameLib.EggInfo[eggName or ""]
    if not info then return nil end
    local floor = GameLib.RarityRank[Theseus.Util.Opt("WebhookEggRarity") or ""] or 1
    if (GameLib.RarityRank[info.rarity] or 0) < floor then return nil end
    return info
end

---@param entry table|nil  EggIndex entry
---@return table           fields for an egg embed
function Theseus.Webhook.EggFields(eggName, entry)
    local info = GameLib.EggInfo[eggName] or {}
    local fields = {
        { "✨ Rarity", tostring(info.rarity or "?") },
        { "🍀 Luck", "1 in " .. Theseus.Util.Format(info.luck or 0) },
    }
    if entry and entry.weight then fields[#fields + 1] = { "⚖️ Weight", string.format("%.2f", entry.weight) } end
    if entry and entry.mutation and entry.mutation ~= "" then fields[#fields + 1] = { "🧬 Mutation", entry.mutation } end
    if (info.growth or 0) > 0 then fields[#fields + 1] = { "⏳ Grow time", Theseus.Webhook.Duration(info.growth) } end
    if info.volcanic then fields[#fields + 1] = { "🌋 Spawn", "Inside the volcano" } end
    return fields
end

---@param guid string|nil
---@param text any         server reply text, used when the guid is not indexed
function Theseus.Webhook.EggPicked(guid, text)
    local hook = Theseus.Webhook
    local entry = guid and Theseus.EggIndex.Entries[guid]
    local eggName = entry and entry.egg or (type(text) == "string" and text) or nil
    hook.Counts.Eggs += 1

    local info = hook.RareEgg(eggName)
    if not info then return end
    hook.Counts.Rare += 1
    if not hook.Wants("Rare Egg Picked") then return end

    hook.Push({
        Kind = "Egg",
        Title = "Picked up " .. eggName,
        Lines = { "On the way home." },
        Fields = hook.EggFields(eggName, entry),
        Rarity = info.rarity,
        Ping = GameLib.RarityRank[info.rarity] == #GameLib.RarityOrder,
    })
end

---@param egg Instance|table  ActiveEggs child or EggIndex entry
function Theseus.Webhook.EggSpawned(egg)
    local hook = Theseus.Webhook
    local entry = type(egg) == "table" and egg or (typeof(egg) == "Instance" and Theseus.EggIndex.Entries[egg.Name])
    if not entry or not entry.guid or hook.SeenEggs[entry.guid] then return end
    if entry.dropEndsAt then return end
    if entry.privateTo and entry.privateTo ~= LocalPlayer.UserId then return end
    if not hook.Wants("Rare Egg In Server") then return end

    local info = hook.RareEgg(entry.egg)
    if not info then return end
    hook.SeenEggs[entry.guid] = true

    local fields = hook.EggFields(entry.egg, entry)
    fields[#fields + 1] = { "🆔 Server", "`" .. game.JobId .. "`", false }
    hook.Push({
        Kind = "Server",
        Title = entry.egg .. " spawned",
        Lines = { "A " .. info.rarity .. " egg is on the map in your server." },
        Fields = fields,
        Rarity = info.rarity,
        Ping = true,
    })
end

---@param reply table  VolcanoDipResult payload, already ours
function Theseus.Webhook.Dipped(reply)
    local hook = Theseus.Webhook
    local counts = hook.Counts
    counts.Dips += 1
    if reply.Success then counts.Magma += 1 end
    if not reply.Success or not hook.Wants("Magma Dip") then return end

    local eggName = tostring(reply.Egg)
    local info = GameLib.EggInfo[eggName] or {}
    hook.Push({
        Kind = "Magma",
        Title = eggName .. " became " .. tostring(reply.Mutation),
        Lines = { "The volcano dip worked." },
        Fields = {
            { "✨ Rarity", tostring(info.rarity or "?") },
            { "⚖️ Weight", string.format("%.2f", tonumber(reply.Weight) or 0) },
            { "🎲 Hit rate", string.format("%d / %d (%.0f%%)", counts.Magma, counts.Dips, counts.Magma / counts.Dips * 100) },
        },
        Rarity = info.rarity,
    })
end

function Theseus.Webhook.PetAdded(tool)
    local hook = Theseus.Webhook
    if not tool:IsA("Tool") then return end
    local key = tool:GetAttribute("PetKey")
    if not key or hook.SeenPets[key] then return end
    hook.SeenPets[key] = true
    hook.Counts.Pets += 1
    if not hook.Wants("Pet Hatched") then return end

    local petName = tool:GetAttribute("PetName") or tool.Name
    local info = GameLib.PetInfo[petName]
    local rarity = info and info.rarity or "?"
    local floor = GameLib.RarityRank[Theseus.Util.Opt("WebhookPetRarity") or ""] or 1
    if (GameLib.RarityRank[rarity] or 0) < floor then return end

    local fields = {
        { "✨ Rarity", rarity },
        { "💰 Income", Theseus.Util.Format(info and info.income or 0) .. "/s" },
    }
    local weight = tonumber(tool:GetAttribute("Weight") or tool:GetAttribute("BaseWeight"))
    if weight then table.insert(fields, { "⚖️ Weight", string.format("%.2f", weight) }) end
    for _, attr in ipairs({ "Mutation", "SpawnMutation" }) do
        local mutation = tool:GetAttribute(attr)
        if mutation and mutation ~= "" then fields[#fields + 1] = { "🧬 " .. (attr == "Mutation" and "Mutation" or "Spawn Mutation"), mutation } end
    end
    fields[#fields + 1] = { "🐾 New pets (session)", hook.Counts.Pets }

    hook.Push({
        Kind = "Pet",
        Title = "New pet: " .. petName,
        Fields = fields,
        Rarity = rarity,
        Ping = GameLib.RarityRank[rarity] == #GameLib.RarityOrder,
    })
end

---@param _plan table|nil  State.LastFail from Guard; mechanics stay out of Discord
function Theseus.Webhook.DeliveryFailed(_plan)
    if not Theseus.Webhook.Wants("Egg Returned") then return end
    Theseus.Webhook.Push({
        Kind = "Fail",
        Title = "Egg farming stopped",
        Lines = { "An egg was returned, so egg farming switched itself off. Turn it back on in the menu to continue." },
        Fields = {
            { "📦 Delivered", State.Stats.delivered },
            { "❌ Lost", State.Stats.lost },
        },
        Ping = true,
    })
end

function Theseus.Webhook.Snapshot()
    local counts = Theseus.Webhook.Counts
    return { Cash = SavedNumber("Cash"), Eggs = State.Stats.delivered, Magma = counts.Magma, Pets = counts.Pets, At = os.clock() }
end

function Theseus.Webhook.Report()
    local hook = Theseus.Webhook
    local minutes = tonumber(Theseus.Util.Opt("WebhookReportMins")) or 0
    if minutes <= 0 or os.clock() - hook.LastReport < minutes * 60 then return end
    if not hook.Wants("Status Report") then return end
    hook.LastReport = os.clock()

    local now = hook.Snapshot()
    local before = hook.Baseline or now
    hook.Baseline = now
    local span = math.max(now.At - before.At, 1)
    local gained = now.Cash - before.Cash
    local format = Theseus.Util.Format

    hook.Push({
        Kind = "Report",
        Title = "Status report",
        Lines = { "**Doing:** " .. tostring(State.Status.Eggs or "Idle") },
        Fields = {
            { "💵 Cash gained", (gained >= 0 and "+" or "") .. format(gained) },
            { "⚡ Cash / hour", format(gained / span * 3600) },
            { "🥚 Eggs", "+" .. (now.Eggs - before.Eggs) },
            { "🌋 Magma", "+" .. (now.Magma - before.Magma) },
            { "🐾 New pets", "+" .. (now.Pets - before.Pets) },
            { "🕒 Window", hook.Duration(span) },
        },
    })
end

---@param message string  disconnect text; posted at once, the queue dies with the session
function Theseus.Webhook.Kicked(message)
    if not Theseus.Webhook.Wants("Kicked") then return end
    local built, json = pcall(Theseus.Webhook.Build, {
        Kind = "Kick",
        Title = "Disconnected",
        Lines = { "```" .. tostring(message):sub(1, 500) .. "```" },
        Ping = true,
    })
    if built then Theseus.Webhook.Post(Theseus.Util.Opt("WebhookUrl"), json) end
end

---@return boolean  false when the url is not a Discord webhook
---@return boolean, string|nil  Discord accepted it, or false and why
function Theseus.Webhook.Test()
    local url = Theseus.Util.Opt("WebhookUrl")
    if not Theseus.Webhook.Valid(url) then return false, "Paste a Discord webhook URL first" end

    local built, json = pcall(Theseus.Webhook.Build, { Kind = "Test", Title = "Webhook connected", Lines = { "Alerts from Theseus will show up here." } })
    if not built then return false, tostring(json) end
    local sent, why = Theseus.Webhook.Post(url, json)
    if sent then return true end
    if tostring(why):find("HTTP 404", 1, true) then return false, "Discord says this webhook does not exist" end
    return false, why
end

---@param signal RBXScriptSignal|table  Roblox signal or an Theseus.Signal
function Theseus.Webhook.Listen(signal, fn)
    if getmetatable(signal) == Theseus.Signal then
        local off = signal:Connect(fn)
        table.insert(Theseus.Webhook.Conns, { Disconnect = off })
        return
    end
    local conn = Theseus:Connect(signal, fn)
    table.insert(Theseus.Webhook.Conns, conn)
end

function Theseus.Webhook.MarkPets(container)
    for _, tool in ipairs(container and container:GetChildren() or {}) do
        local key = tool:GetAttribute("PetKey")
        if key then Theseus.Webhook.SeenPets[key] = true end
    end
end

function Theseus.Webhook.WatchBackpack(backpack)
    Theseus.Webhook.MarkPets(backpack)
    Theseus.Webhook.Listen(backpack.ChildAdded, Theseus.Webhook.PetAdded)
end

function Theseus.Webhook.WatchGame()
    local hook, index = Theseus.Webhook, Theseus.EggIndex
    hook.Listen(index.OnReply, function(kind, guid, text)
        if kind == "PickedUp" then hook.EggPicked(guid, text) end
    end)
    hook.Listen(index.OnAdded, function(entry) task.defer(hook.EggSpawned, entry) end)

    local dip = GameLib.Remote("VolcanoDipResult")
    if dip then
        hook.Listen(dip.OnClientEvent, function(reply)
            if type(reply) ~= "table" then return end
            if reply.Owner ~= LocalPlayer.UserId and reply.Owner ~= LocalPlayer then return end
            hook.Dipped(reply)
        end)
    end

    local saved = LocalPlayer:FindFirstChild("SavedData")
    local rebirths = saved and saved:FindFirstChild("Rebirths")
    if rebirths then
        hook.Listen(rebirths.Changed, function(value)
            if not hook.Wants("Rebirth") then return end
            hook.Push({ Kind = "Rebirth", Title = "Rebirth " .. tostring(value) .. " done", Lines = { "Cash and luck reset, +1 pet slot." } })
        end)
    end

    hook.Listen(GuiService.ErrorMessageChanged, function()
        local message = GuiService:GetErrorMessage()
        if message ~= "" then task.spawn(hook.Kicked, message) end
    end)
end

function Theseus.Webhook.Boot()
    local hook = Theseus.Webhook
    if hook.Booted then return end
    hook.Booted = true

    hook.MarkPets(Theseus.Player.Char)
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    if backpack then hook.WatchBackpack(backpack) end
    hook.Listen(LocalPlayer.ChildAdded, function(child)
        if child:IsA("Backpack") then hook.WatchBackpack(child) end
    end)

    hook.WatchGame()
    hook.Baseline = hook.Snapshot()
    task.spawn(hook.AvatarUrl)
end

function Theseus.Webhook.Step()
    local hook = Theseus.Webhook
    if not hook.Booted then hook.Boot() end
    hook.Report()
end

function Theseus.Webhook.Stop()
    local hook = Theseus.Webhook
    for _, conn in ipairs(hook.Conns) do
        conn:Disconnect()
    end
    table.clear(hook.Conns)
    table.clear(hook.Queue)
    hook.Booted = false
end

Theseus.Kaitun = {
    Running = false,
    Saved = {},
    Steered = nil,
    SteerKey = nil,
    SteerAt = 0,
}

---@param value any
function Theseus.Kaitun.Set(idx, value)
    Theseus.Options[idx] = value
    table.insert(Theseus.State.PendingSet, { idx, value })
end

---@return any  a copy safe to store, tables shallow copied
function Theseus.Kaitun.Snapshot(value)
    if type(value) ~= "table" then return value end
    local copy = {}
    for key, entry in pairs(value) do
        copy[key] = entry
    end
    return copy
end

function Theseus.Kaitun.Start()
    if Theseus.Kaitun.Running then return end
    Theseus.Kaitun.Running = true
    table.clear(Theseus.Kaitun.Saved)

    local remember = { "HuntMinRarity", "EggRarities", "MinEggRarity" }
    for _, idx in ipairs(Theseus.Config.KaitunToggles) do
        table.insert(remember, idx)
    end
    for _, idx in ipairs(remember) do
        Theseus.Kaitun.Saved[idx] = { Theseus.Kaitun.Snapshot(Theseus.Util.Opt(idx)) }
    end

    Theseus.Kaitun.Set("HuntMinRarity", Theseus.Config.KaitunHuntRarity)
    Theseus.Kaitun.Set("MinEggRarity", Theseus.GameLib.RarityOrder[1])
    for _, idx in ipairs(Theseus.Config.KaitunToggles) do
        if not Theseus.GameLib.Blocked(idx) then Theseus.Kaitun.Set(idx, true) end
    end
    Theseus.Kaitun.SteerAt = 0
end

function Theseus.Kaitun.Stop()
    if not Theseus.Kaitun.Running then return end
    Theseus.Kaitun.Running = false

    for idx, boxed in pairs(Theseus.Kaitun.Saved) do
        Theseus.Kaitun.Set(idx, boxed[1] == nil and false or boxed[1])
    end
    table.clear(Theseus.Kaitun.Saved)
    Theseus.Kaitun.Steered = nil
    Theseus.Kaitun.SteerKey = nil
    Theseus.State.Status.Kaitun = "Off"
end

---@return table|nil  { [rarity] = true } of eggs that can hatch this pet, nil when none can
function Theseus.Kaitun.RaritiesFor(pet)
    local mult = Theseus.Economy.LuckMult()
    local wanted, any = {}, false

    for egg, info in pairs(Theseus.GameLib.EggInfo) do
        if info.volcanic then continue end
        local odds = Theseus.GameLib.Odds(egg, mult)
        for _, row in ipairs(odds or {}) do
            if row[1] == pet and row[2] > 0 then
                wanted[info.rarity] = true
                any = true
                break
            end
        end
    end
    return any and wanted or nil
end

---@return string  what the steer is chasing, for the status line
function Theseus.Kaitun.Steer()
    local reached = Theseus.Economy.RebirthPlan().reason == "target reached"
    if reached and Theseus.Util.Opt("EggHunter") then Theseus.Kaitun.Set("EggHunter", false) end
    local pet = not reached and Theseus.Economy.NextRequirement() or nil
    local missing = pet and not Theseus.Economy.OwnedPet(pet)
    local key = missing and (pet .. "@" .. math.floor(Theseus.Economy.LuckMult())) or "none"

    local due = os.clock() - Theseus.Kaitun.SteerAt >= Theseus.Config.KaitunSteerEvery
    if key == Theseus.Kaitun.SteerKey and not due then
        return missing and ("Hunting " .. pet) or "Farming"
    end
    Theseus.Kaitun.SteerKey = key
    Theseus.Kaitun.SteerAt = os.clock()

    local rarities = missing and Theseus.Kaitun.RaritiesFor(pet)
    if rarities then
        Theseus.Kaitun.Steered = rarities
        Theseus.Kaitun.Set("EggRarities", rarities)
        return "Hunting " .. pet
    end

    if Theseus.Kaitun.Steered then
        local saved = Theseus.Kaitun.Saved.EggRarities
        Theseus.Kaitun.Set("EggRarities", saved and Theseus.Kaitun.Snapshot(saved[1]) or {})
        Theseus.Kaitun.Steered = nil
    end
    return "Farming"
end

function Theseus.Kaitun.Step()
    if not Theseus.Kaitun.Running then return end
    local doing = Theseus.Kaitun.Steer()

    local plan = Theseus.Economy.Plan
    local rebirths = Theseus.Economy.Rebirths() .. "/" .. (Theseus.GameLib.Rebirths.Cap or 0)
    Theseus.State.Status.Kaitun = doing .. " | Rebirth " .. rebirths .. (plan ~= "" and (" | " .. plan) or "")
end

function Theseus.Kaitun.Status()
    return Theseus.State.Status.Kaitun or "Off"
end

local function T(en, th)
    return Library:T(en, th)
end

Theseus.UI = { Labels = {}, Shown = {} }

Theseus.UI.WebhookEvents = {
    "Rare Egg Picked", "Rare Egg In Server", "Egg Returned", "Magma Dip", "Pet Hatched",
    "Rebirth", "Boost Started", "Kicked", "Status Report",
}

Theseus.UI.Floats = { { "Fly", "Fly" }, { "NoClip", "Clip" }, { "SpeedOn", "Run" }, { "EggEsp", "ESP" } }

---@param module string    root module name
---@param group  string[]  toggles sharing that module; Stop runs when all are off
---@return function
function Theseus.UI.Shared(module, group)
    return function(on)
        local mod = rawget(Theseus, module)
        if not mod then return end
        if on then
            if mod.Start then mod.Start() end
            return
        end
        for _, idx in ipairs(group) do
            if Theseus.Options[idx] then return end
        end
        if mod.Stop then mod.Stop() end
    end
end

---@return function
function Theseus.UI.Switch(module)
    return function(on)
        local mod = Theseus[module]
        if on then mod.Start() else mod.Stop() end
    end
end

---@return function
function Theseus.UI.MoveHook(idx)
    return function(on) Theseus.Move.Set(idx, on) end
end

---@return function
function Theseus.UI.TrollHook(idx)
    return function(on) Theseus.Troll.Set(idx, on) end
end

do
    local ui, shared = Theseus.UI, Theseus.UI.Shared
    local volcano = { "VolcanoDip", "VolcanoObby" }
    local hatch = { "AutoPlaceEggs", "AutoHatch" }
    local pets = { "AutoEquipBest", "AutoCollectCash", "AutoFeed" }
    local economy = { "AutoUpgrade", "AutoRebirth", "SmartSpend" }
    local halloween = { "AutoCandy", "AutoTrickOrTreat", "AutoPumpkin", "AutoHalloweenEgg", "AutoRitual" }

    ui.Hooks = {
        InstantPrompt = ui.Switch("Prompts"),
        AutoEggs = ui.Switch("Eggs"),
        EggHunter = ui.Switch("Hunter"),
        VolcanoDip = shared("Volcano", volcano),
        VolcanoObby = shared("Volcano", volcano),
        AutoCandy = shared("Halloween", halloween),
        AutoTrickOrTreat = shared("Halloween", halloween),
        AutoPumpkin = shared("Halloween", halloween),
        AutoHalloweenEgg = shared("Halloween", halloween),
        AutoRitual = shared("Halloween", halloween),
        HalloweenEsp = function(on)
            if not on then Theseus.Halloween.ClearEsp() end
        end,
        AutoPlaceEggs = shared("Hatch", hatch),
        AutoHatch = shared("Hatch", hatch),
        ClearJunk = function(on)
            if on then
                Theseus.Eggs.QuietInventory(true)
                Theseus.Junk.Start()
                return
            end
            Theseus.Junk.Stop()
            task.spawn(Theseus.Eggs.Settle)
        end,
        AutoEquipBest = shared("Pets", pets),
        AutoCollectCash = shared("Pets", pets),
        AutoFeed = shared("Pets", pets),
        AutoSell = ui.Switch("Sell"),
        AutoFusion = ui.Switch("Fusion"),
        AutoShop = shared("Shop", { "AutoShop" }),
        AutoUpgrade = shared("Economy", economy),
        AutoRebirth = shared("Economy", economy),
        SmartSpend = shared("Economy", economy),
        AutoClaim = shared("Rewards", { "AutoClaim" }),
        Kaitun = ui.Switch("Kaitun"),
        EggEsp = function(on) if not on then Theseus.Esp.Clear() end end,
        Fling = ui.TrollHook("Fling"),
        Stick = ui.TrollHook("Stick"),
        HideOtherPets = Theseus.Visual.HidePets,
        HideOtherEggs = Theseus.Visual.HideEggs,
        BoostFps = Theseus.Visual.Boost,
        Render3D = Theseus.Visual.Render,
        UnlockFps = function(on)
            if Theseus.Visual.Cap(on) or not on then return end
            Library.Compat.Block("UnlockFps", T("Not supported on this executor", "executor นี้ไม่รองรับ"))
        end,
        FpsCap = function()
            if Theseus.Options.UnlockFps then Theseus.Visual.Cap(true) end
        end,
    }
    for _, idx in ipairs({ "SpeedOn", "JumpOn", "Fly", "NoClip", "InfJump", "AntiAfk" }) do
        ui.Hooks[idx] = ui.MoveHook(idx)
    end
end

---@return function  runs fn on its own thread so game calls never taint the UI thread
function Theseus.UI.Detach(label, fn)
    return function(...)
        local args = table.pack(...)
        task.spawn(function()
            Theseus.Util.Try("ui " .. label, fn, table.unpack(args, 1, args.n))
        end)
    end
end

---@return table  the option, mirrored into Theseus.Options
function Theseus.UI.Bind(idx, option)
    Theseus.Options[idx] = option.Value
    option:OnChanged(function(value)
        Theseus.Options[idx] = value
        if value == true then Theseus.Scheduler.Resume(idx) end

        local hook = Theseus.UI.Hooks[idx]
        if hook then task.spawn(Theseus.Util.Try, "toggle " .. idx, hook, value == true) end
    end)
    return option
end

function Theseus.UI.Toggle(group, idx, info)
    info.Default = false
    return Theseus.UI.Bind(idx, group:AddToggle(idx, info))
end

---@return table  toggle; the key picker is saved as "<idx>Key"
function Theseus.UI.KeyToggle(group, idx, info)
    local toggle = Theseus.UI.Toggle(group, idx, info)
    toggle:AddKeyPicker(idx .. "Key", { Default = "None", Mode = "Toggle" })
    return toggle
end

function Theseus.UI.CarryGuard(option)
    if type(option.AddGuard) ~= "function" then return end
    option:AddGuard(function(value)
        if value ~= true or Theseus.Player:BasketCount() == 0 then return true end
        Library:Notify("Theseus", T("Finish the egg delivery first", "ส่งไข่ให้เสร็จก่อน"), 4, "Warning")
        task.defer(option.SetValue, option, false)
        return false
    end)
end

function Theseus.UI.Status(group, key, fallback)
    local label = group:AddLabel(fallback)
    table.insert(Theseus.UI.Labels, { label, key, fallback })
    return label
end

---@return table  list from a builder, empty when it errors
function Theseus.UI.Values(source)
    local ok, list = pcall(source)
    return ok and type(list) == "table" and list or {}
end

---@return string[]
function Theseus.UI.Rarities()
    return table.clone(Theseus.GameLib.RarityOrder)
end

---@return string  "Mythic" when the game has it, else the rarest one
function Theseus.UI.HuntDefault()
    local order = Theseus.GameLib.RarityOrder
    if Theseus.GameLib.RarityRank.Mythic then return "Mythic" end
    return order[#order]
end

---@return string[]  sorted keys of a GameLib table
function Theseus.UI.Names(source)
    local names = {}
    for name in pairs(source) do
        names[#names + 1] = name
    end
    table.sort(names)
    return names
end

---@return string[]  "Auto (fastest)" then every ridable pet tool we hold
function Theseus.UI.RideNames()
    local names = Theseus.UI.Names(Theseus.Mount.Tools())
    table.insert(names, 1, Theseus.Mount.AutoLabel)
    return names
end

function Theseus.UI.Pump()
    local sets = State.PendingSet
    if sets and #sets > 0 then
        State.PendingSet = {}
        for _, row in ipairs(sets) do
            local option = Library.Options[row[1]]
            if option then option:SetValue(row[2]) end
        end
    end
    Theseus.Scheduler.Pump()

    local shown = Theseus.UI.Shown
    for _, row in ipairs(Theseus.UI.Labels) do
        local text = State.Status[row[2]] or row[3]
        if shown[row[1]] == text then continue end
        shown[row[1]] = text
        row[1]:SetText(text)
    end

    local stats = State.Stats
    local line = string.format("Delivered %d | Lost %d", stats.delivered, stats.lost)
    if State.Status.WaveAt then
        local left = math.max(0, math.floor(State.Status.WaveAt - os.clock()))
        line ..= string.format(" | Wave in %d:%02d | %s", math.floor(left / 60), left % 60, State.Status.EggRate or "0/min")
    end
    if shown.Rate ~= line and Theseus.UI.RateLabel then
        shown.Rate = line
        Theseus.UI.RateLabel:SetText(line)
    end
end

function Theseus.UI.Gate()
    local blocked = 0
    for idx in pairs(Theseus.GameLib.Needs) do
        local reason = Theseus.GameLib.Blocked(idx)
        if not reason or not Library.Options[idx] then continue end
        blocked += 1
        warn(Config.Tag, idx .. " blocked:", reason)
        Library.Compat.Block(idx, T("The game changed, waiting for a script update", "เกมอัปเดต รอสคริปต์อัปเดต"))
    end
    if blocked == 0 then return end
    Library:Notify("Theseus", T(blocked .. " features are off until the next update", "ปิดไว้ " .. blocked .. " ฟีเจอร์ จนกว่าจะอัปเดต"), 8, "Warning")
end

function Theseus.UI.Home(window)
    local tab = window:AddTab(T("Home", "หน้าแรก"), "mushroom", T("Status and full auto", "สถานะและโหมดอัตโนมัติ"))

    local status = tab:AddLeftGroupbox(T("Status", "สถานะ"), "info")
    Theseus.UI.Status(status, "Eggs", "Egg farm is off")
    Theseus.UI.RateLabel = status:AddLabel("Delivered 0 | Lost 0 | Wave in 0:00 | 0/min")
    Theseus.UI.Status(status, "Economy", "Cash: waiting")

    local quick = tab:AddLeftGroupbox(T("Quick", "ด่วน"), "bomb")
    quick:AddButton({ Text = T("Collect Eggs Now", "เก็บไข่เดี๋ยวนี้"), Style = "Primary", Func = Theseus.UI.Detach("collect now", Theseus.Eggs.CollectNow) })
    quick:AddButton({ Text = T("Return Home", "กลับบ้าน"), Func = Theseus.UI.Detach("return home", Theseus.Teleport.Home) })

    local kaitun = tab:AddLeftGroupbox(T("Kaitun", "ไก่ตัน"), "star")
    Theseus.UI.Toggle(kaitun, "Kaitun", {
        Text = T("Kaitun", "ไก่ตัน"),
        Description = T("Plays the account for you, from eggs to rebirth", "เล่นแทนทั้งบัญชี ตั้งแต่ไข่จนถึงรีเบิร์ธ"),
    })
    Theseus.UI.Status(kaitun, "Kaitun", "Off")

    Theseus.UI.Webhook(tab:AddLeftGroupbox(T("Discord Webhook", "แจ้งเตือนดิสคอร์ด"), "bell"))

    local discord = tab:AddRightGroupbox(T("Discord", "ดิสคอร์ด"), "link")
    discord:AddLabel(Config.Discord)
    discord:AddButton({ Text = T("Copy Discord Link", "คัดลอกลิงก์ดิสคอร์ด"), Func = function()
        if Theseus.Util.Copy(Config.Discord) then
            Library:Notify("Discord", T("Link copied", "คัดลอกลิงก์แล้ว"), 3, "Success")
        else
            Library:Notify("Discord", Config.Discord, 6, "Info")
        end
    end })

    local updates = tab:AddRightGroupbox(T("Update Log", "อัปเดตล่าสุด"), "bell")
    for i = 1, math.min(2, #Config.UpdateLog) do
        local entry = Config.UpdateLog[i]
        updates:AddParagraph({ Title = entry[1], Content = entry[2] })
    end

end

function Theseus.UI.Webhook(hook)
    local rarities = Theseus.UI.Rarities()
    Theseus.UI.Toggle(hook, "Webhook", { Text = T("Webhook Alerts", "แจ้งเตือนผ่าน Webhook"), Description = T("Sends what you got to your Discord channel", "ส่งของที่ได้เข้าห้องดิสคอร์ดของคุณ") })
    Theseus.UI.Bind("WebhookUrl", hook:AddInput("WebhookUrl", { Text = T("Webhook URL", "ลิงก์ Webhook"), Default = "", Placeholder = T("Paste your webhook link", "วางลิงก์ webhook"), Finished = true }))
    Theseus.UI.Bind("WebhookEvents", hook:AddDropdown("WebhookEvents", { Text = T("Alerts", "แจ้งเตือนเรื่อง"), Values = Theseus.UI.WebhookEvents, Multi = true, Default = {} }))
    Theseus.UI.Bind("WebhookEggRarity", hook:AddDropdown("WebhookEggRarity", { Text = T("Egg Rarity At Least", "ไข่ความหายากตั้งแต่"), Values = rarities, Default = Theseus.UI.HuntDefault() }))
    Theseus.UI.Bind("WebhookPetRarity", hook:AddDropdown("WebhookPetRarity", { Text = T("Pet Rarity At Least", "สัตว์ความหายากตั้งแต่"), Values = rarities, Default = Theseus.UI.HuntDefault() }))
    Theseus.UI.Bind("WebhookReportMins", hook:AddSlider("WebhookReportMins", { Text = T("Status Report Every", "รายงานสถานะทุก"), Min = 5, Max = 120, Default = 30, Rounding = 0, Suffix = " min" }))
    Theseus.UI.Bind("WebhookPing", hook:AddCheckbox("WebhookPing", { Text = T("Ping @everyone On Top Finds", "แท็ก @everyone เมื่อได้ของสุดยอด"), Default = false }))
    hook:AddButton({ Text = T("Send Test", "ส่งทดสอบ"), Func = Theseus.UI.Detach("webhook test", function()
        local sent, why = Theseus.Webhook.Test()
        Theseus.Util.Notify("Webhook", sent and "Test delivered" or ("Test failed: " .. tostring(why)), 6)
    end) })
end

function Theseus.UI.EggFarm(window)
    local tab = window:AddTab(T("Egg Farm", "ฟาร์มไข่"), "coin", T("Wild egg collecting", "เก็บไข่ป่า"))
    local rarities = Theseus.UI.Rarities()

    local farm = tab:AddLeftGroupbox(T("Collect Eggs", "เก็บไข่"), "zap")
    Theseus.UI.Toggle(farm, "AutoEggs", { Text = T("Auto Collect Eggs", "เก็บไข่อัตโนมัติ"), Description = T("Brings every wanted egg on the map home", "เก็บไข่ที่เลือกทั่วแมพแล้วพากลับบ้าน") })
    farm:AddButton({ Text = T("Collect Now", "เก็บเดี๋ยวนี้"), Style = "Primary", Func = Theseus.UI.Detach("collect now", Theseus.Eggs.CollectNow) })
        :AddButton({ Text = T("Exit Now", "ออกทันที"), Style = "Warning", Func = Theseus.UI.Detach("exit now", Theseus.Eggs.ExitNow) })
    Theseus.UI.Toggle(farm, "ReturnAfter", { Text = T("Wait At Home", "รอที่บ้าน"), Description = T("Waits at your plot between waves", "รอที่พล็อตระหว่างรอบไข่") })
    Theseus.UI.Bind("DeliveryMode", farm:AddDropdown("DeliveryMode", { Text = T("Delivery", "การส่งไข่"), Values = { "Auto", "Safe" }, Default = "Auto" }))

    local ride = Theseus.UI.Bind("RidePet", farm:AddDropdown("RidePet", { Text = T("Ride Pet", "สัตว์ที่ขี่"), Values = Theseus.UI.RideNames(), Default = Theseus.Mount.AutoLabel, Searchable = true }))
    farm:AddButton({ Text = T("Refresh Ride Pets", "รีเฟรชสัตว์ที่ขี่"), Func = function()
        ride:SetValues(Theseus.UI.RideNames())
        Theseus.Mount.Dirty = true
    end })

    Theseus.UI.Bind("EggRoute", farm:AddDropdown("EggRoute", {
        Text = T("Collection Route", "เส้นทางเก็บไข่"), Values = { "Fast nearby", "Best yield" }, Default = "Fast nearby",
        Description = T("Fast nearby uses short returns; Best yield includes far eggs. Hunter follows rarity.", "เก็บเร็วเลือกจุดใกล้; คุ้มค่าสุดรวมจุดไกล โหมดล่าใช้เป้าหมายความหายาก"),
    }))
    local settle = Theseus.UI.Bind("DropSettle", farm:AddSlider("DropSettle", { Text = T("Delivery Safety", "ความปลอดภัยการส่ง"), Min = 0.2, Max = 0.45, Default = 0.2, Rounding = 2, Suffix = "s" }))
    settle:OnChanged(function(value)
        State.Tune.DropSettle = math.clamp(tonumber(value) or Config.DropSettle, Config.DropSettle, 0.45)
    end)
    local contest = Theseus.UI.Bind("ContestWeight", farm:AddSlider("ContestWeight", { Text = T("Beat Other Players", "แย่งไข่ก่อนคนอื่น"), Min = 0, Max = Config.ContestWeightMax, Default = Config.ContestWeight, Rounding = 1 }))
    contest:OnChanged(function(value)
        State.Tune.ContestWeight = math.clamp(tonumber(value) or Config.ContestWeight, 0, Config.ContestWeightMax)
    end)

    local volcano = tab:AddLeftGroupbox(T("Volcano (beta)", "ภูเขาไฟ (ทดลอง)"), "flower")
    Theseus.UI.Toggle(volcano, "VolcanoDip", { Text = T("Volcano Dip", "จุ่มไข่ในภูเขาไฟ"), Description = T("Dips eggs in the volcano for a chance at Magma", "จุ่มไข่ในภูเขาไฟ ลุ้นได้ Magma"), Risky = true })
    Theseus.UI.Bind("DipRarities", volcano:AddDropdown("DipRarities", { Text = T("Dip Rarities (empty = all)", "ความหายากที่จะจุ่ม (ว่าง = ทั้งหมด)"), Values = rarities, Multi = true, Default = {} }))
    Theseus.UI.Toggle(volcano, "VolcanoObby", { Text = T("Auto Volcano Egg", "เก็บไข่ภูเขาไฟอัตโนมัติ"), Description = T("Clears the climb and brings the Volcanic Egg home", "ผ่านด่านแล้วพาไข่ Volcanic กลับบ้าน"), Risky = true })
    Theseus.UI.Status(volcano, "Volcano", "Off")

    local filters = tab:AddRightGroupbox(T("Egg Filters", "ตัวกรองไข่"), "target")
    local minDrop = Theseus.UI.Bind("MinEggRarity", filters:AddDropdown("MinEggRarity", { Text = T("Minimum Egg Rarity", "ความหายากไข่ขั้นต่ำ"), Values = rarities, Default = rarities[1], Description = T("Skips eggs below this rarity", "ข้ามไข่ที่หายากต่ำกว่านี้") }))
    local rarityDrop = Theseus.UI.Bind("EggRarities", filters:AddDropdown("EggRarities", { Text = T("Rarities (empty = all)", "ความหายาก (ว่าง = ทั้งหมด)"), Values = rarities, Multi = true, Default = {} }))
    local nameDrop = Theseus.UI.Bind("EggNames", filters:AddDropdown("EggNames", { Text = T("Eggs (empty = all)", "ไข่ (ว่าง = ทั้งหมด)"), Values = Theseus.UI.Names(Theseus.GameLib.EggInfo), Multi = true, Searchable = true, Default = {} }))
    Theseus.UI.Bind("MinLuck", filters:AddSlider("MinLuck", { Text = T("Minimum Luck (1 in X)", "โชคขั้นต่ำ (1 ใน X)"), Min = 0, Max = 1000000, Default = 0, Rounding = 0 }))
    Theseus.UI.Bind("MinWeight", filters:AddSlider("MinWeight", { Text = T("Minimum Weight", "น้ำหนักขั้นต่ำ"), Min = 1, Max = 3, Default = 1, Rounding = 1, Suffix = "x" }))
    Theseus.UI.Toggle(filters, "SmartEggs", { Text = T("Top Eggs Of The Wave", "เฉพาะไข่ดีของรอบ"), Description = T("Skips eggs worth less than the wave average", "ข้ามไข่ที่ค่าน้อยกว่าค่ากลางของรอบ") })
    filters:AddButton({ Text = T("Refresh Egg List", "รีเฟรชรายการไข่"), Func = function()
        Theseus.GameLib.Build()
        minDrop:SetValues(Theseus.UI.Rarities())
        rarityDrop:SetValues(Theseus.UI.Rarities())
        nameDrop:SetValues(Theseus.UI.Names(Theseus.GameLib.EggInfo))
    end })

    local hunter = tab:AddRightGroupbox(T("Rare Egg Hunter", "ล่าไข่หายาก"), "star")
    Theseus.UI.Toggle(hunter, "EggHunter", { Text = T("Rare Egg Hunter", "ล่าไข่หายาก"), Description = T("Goes for rare eggs first and alerts you when one spawns", "รีบไปเก็บไข่หายากก่อน และแจ้งเตือนเมื่อเกิด") })
    Theseus.UI.Bind("HuntMinRarity", hunter:AddDropdown("HuntMinRarity", { Text = T("Minimum Rarity", "ความหายากขั้นต่ำ"), Values = rarities, Default = Theseus.UI.HuntDefault() }))
    local hop = Theseus.UI.Toggle(hunter, "HunterHop", { Text = T("Hop Servers (beta)", "ย้ายเซิร์ฟหา (ทดลอง)"), Description = T("Moves to another server when none are around", "ย้ายเซิร์ฟเมื่อไม่มีไข่หายาก"), Risky = true })
    Library.Compat.NeedCap(hop, "Queue")
end

function Theseus.UI.Hatching(window)
    local tab = window:AddTab(T("Hatch", "ฟักไข่"), "flower", T("Placing and hatching", "วางและฟักไข่"))

    local place = tab:AddLeftGroupbox(T("Place Eggs", "วางไข่"), "flower")
    Theseus.UI.Toggle(place, "AutoPlaceEggs", { Text = T("Auto Place Eggs", "วางไข่อัตโนมัติ"), Description = T("Fills your plot up to the limit", "วางไข่ลงพล็อตจนเต็มลิมิต") })
    place:AddButton({ Text = T("Place Now", "วางเดี๋ยวนี้"), Style = "Primary", Func = Theseus.UI.Detach("place now", Theseus.Hatch.PlaceNow) })
    Theseus.UI.Bind("PlantOrder", place:AddDropdown("PlantOrder", { Text = T("Place First", "วางก่อน"), Values = { "Best value", "Fastest growth", "Value per hour" }, Default = "Best value" }))
    Theseus.UI.Bind("PlantKeep", place:AddSlider("PlantKeep", { Text = T("Keep Per Egg", "เก็บไว้ต่อชนิด"), Min = 0, Max = 20, Default = 0, Rounding = 0 }))
    Theseus.UI.Status(place, "Hatch", "Idle")

    local hatch = tab:AddLeftGroupbox(T("Hatching", "ฟักไข่"), "star")
    Theseus.UI.Toggle(hatch, "AutoHatch", { Text = T("Auto Hatch", "ฟักอัตโนมัติ"), Description = T("Hatches eggs from anywhere once they are grown", "ฟักไข่จากที่ไหนก็ได้เมื่อโตเต็มที่") })
    hatch:AddButton({ Text = T("Hatch Now", "ฟักเดี๋ยวนี้"), Style = "Primary", Func = Theseus.UI.Detach("hatch now", Theseus.Hatch.HatchNow) })
    Theseus.UI.Toggle(hatch, "HoldHatchBoost", { Text = T("Wait For Luck Boost", "รอบูสต์โชค"), Description = T("Holds grown eggs until a luck boost is running", "เก็บไข่ที่โตแล้วไว้ฟักตอนมีบูสต์โชค") })

    local junk = tab:AddRightGroupbox(T("Clear Junk Eggs", "ล้างไข่ขยะ"), "bomb")
    local rarities = Theseus.UI.Rarities()
    Theseus.UI.Toggle(junk, "ClearJunk", { Text = T("Clear Junk Eggs", "ล้างไข่ขยะ"), Description = T("Hatches your cheap eggs and sells the pets that come out", "ฟักไข่ถูกๆ แล้วขายสัตว์ที่ได้") })
    junk:AddButton({ Text = T("Sell Junk Pets Now", "ขายสัตว์ขยะเดี๋ยวนี้"), Style = "Warning", Func = Theseus.UI.Detach("sell junk now", Theseus.Junk.SellNow) })
    Theseus.UI.Bind("JunkRarities", junk:AddDropdown("JunkRarities", { Text = T("Eggs To Clear", "ไข่ที่จะล้าง"), Values = rarities, Multi = true, Default = { "Common", "Rare" } }))
    Theseus.UI.Bind("JunkSellPets", junk:AddDropdown("JunkSellPets", { Text = T("Pets To Sell (empty = auto)", "สัตว์ที่จะขาย (ว่าง = อัตโนมัติ)"), Values = rarities, Multi = true, Default = {}, Description = T("Auto sells what your junk eggs usually give", "อัตโนมัติ = ขายระดับที่ไข่ขยะมักให้") }))
    Theseus.UI.Status(junk, "Junk", "Off")
end

function Theseus.UI.Halloween(window)
    local tab = window:AddTab(T("Halloween", "ฮาโลวีน"), "star", T("Halloween event farm", "ฟาร์มอีเวนต์ฮาโลวีน"))

    local candy = tab:AddLeftGroupbox(T("Candy", "ลูกกวาด"), "zap", "OP")
    Theseus.UI.Toggle(candy, "AutoCandy", {
        Text = T("Auto Candy", "เก็บลูกกวาดอัตโนมัติ"),
        Description = T("Gathers candy and cashes it in at the pad", "เก็บลูกกวาดรอบเกาะแล้วเอาไปแลกที่แท่น"),
    })
    Theseus.UI.Bind("CandyMode", candy:AddDropdown("CandyMode", {
        Text = T("Farm Mode", "โหมดฟาร์ม"),
        Values = { "Most pieces", "Fast returns", "Best yield" }, Default = "Most pieces",
    }))
    Theseus.UI.Bind("CandyReturnStyle", candy:AddDropdown("CandyReturnStyle", {
        Text = T("Return Style", "วิธีกลับไปฝาก"),
        Values = { "Quick hops", "Smooth ride" }, Default = "Quick hops",
    }))
    Theseus.UI.Bind("CandyReturnSpeed", candy:AddSlider("CandyReturnSpeed", {
        Text = T("Return Speed (%)", "ความเร็วกลับ (%)"), Min = 100, Max = 600, Default = 350, Rounding = 0,
    }))
    Theseus.UI.Bind("CandyAutoMount", candy:AddCheckbox("CandyAutoMount", {
        Text = T("Use Fastest Ride Pet", "ใช้สัตว์ขี่ที่เร็วที่สุด"), Default = true,
    }))
    Theseus.UI.Bind("CandyAvoidSpoil", candy:AddCheckbox("CandyAvoidSpoil", {
        Text = T("Allow For Candy Slowdown", "เผื่อเวลาตอนลูกกวาดทำให้ช้าลง"), Default = true,
        Description = T("Skip cursed candy too far to bank at reduced speed", "ข้ามกองที่ไกลจนฝากไม่ทันเมื่อโดนลดความเร็ว"),
    }))
    Theseus.UI.Bind("CandyMinAmount", candy:AddSlider("CandyMinAmount", {
        Text = T("Minimum Pieces", "จำนวนชิ้นขั้นต่ำ"), Min = 1, Max = 15, Default = 1, Rounding = 0,
    }))
    Theseus.UI.Bind("CandyMaxRange", candy:AddSlider("CandyMaxRange", {
        Text = T("Maximum Range", "ระยะไกลสุด"), Min = 100, Max = 3000, Default = Config.CandyRangeDefault, Rounding = 0,
    }))
    candy:AddButton({ Text = T("Collect Now", "เก็บเดี๋ยวนี้"), Style = "Primary", Func = Theseus.UI.Detach("candy now", Theseus.Halloween.CandyNow) })
        :AddButton({ Text = T("Exit Now", "ออกทันที"), Style = "Warning", Func = Theseus.UI.Detach("halloween exit", Theseus.Halloween.ExitNow) })
    Theseus.UI.Status(candy, "Halloween", "Off")

    local doors = tab:AddLeftGroupbox(T("Trick-or-Treat", "กวนประตูบ้าน"), "house")
    Theseus.UI.Toggle(doors, "AutoTrickOrTreat", {
        Text = T("Auto Trick-or-Treat", "กวนประตูบ้านอัตโนมัติ"),
        Description = T("Knocks lit doors and picks up the candy they drop", "เคาะประตูที่สว่างแล้วเก็บลูกกวาดที่ตก"),
    })
    doors:AddButton({ Text = T("Knock Now", "เคาะเดี๋ยวนี้"), Func = Theseus.UI.Detach("knock now", Theseus.Halloween.KnockNow) })

    local pumpkins = tab:AddLeftGroupbox(T("Pumpkins", "ฟักทอง"), "flower")
    Theseus.UI.Toggle(pumpkins, "AutoPumpkin", {
        Text = T("Auto Search Pumpkins", "ค้นฟักทองอัตโนมัติ"),
        Description = T("Searches pumpkins for candy", "ค้นฟักทองเอาลูกกวาด"),
    })
    pumpkins:AddButton({ Text = T("Search Now", "ค้นเดี๋ยวนี้"), Func = Theseus.UI.Detach("search now", Theseus.Halloween.SearchNow) })

    local egg = tab:AddRightGroupbox(T("Halloween Egg", "ไข่ฮาโลวีน"), "star", "OP")
    Theseus.UI.Toggle(egg, "AutoHalloweenEgg", {
        Text = T("Auto Buy Halloween Egg", "ซื้อไข่ฮาโลวีนอัตโนมัติ"),
        Description = T("Spends event tokens on the event egg, then places and hatches it", "ใช้โทเกนอีเวนต์ซื้อไข่ แล้ววางกับฟักให้เอง"),
    })
    Theseus.UI.Bind("HalloweenKeepTokens", egg:AddSlider("HalloweenKeepTokens", {
        Text = T("Keep Tokens", "เก็บโทเกนไว้"), Min = 0, Max = 3500, Default = 0, Rounding = 0,
    }))
    Theseus.UI.Bind("HalloweenBuyLimit", egg:AddSlider("HalloweenBuyLimit", {
        Text = T("Purchase Limit (0 = unlimited)", "จำกัดการซื้อ (0 = ไม่จำกัด)"), Min = 0, Max = 100, Default = 0, Rounding = 0,
    }))
    Theseus.UI.Bind("HalloweenAutoHatch", egg:AddCheckbox("HalloweenAutoHatch", {
        Text = T("Place and Hatch Purchased Eggs", "วางและฟักไข่ที่เพิ่งซื้อ"), Default = true,
    }))
    egg:AddButton({ Text = T("Buy Egg Now", "ซื้อไข่เดี๋ยวนี้"), Style = "Primary", Func = Theseus.UI.Detach("buy egg now", Theseus.Halloween.BuyNow) })
    Theseus.UI.Status(egg, "HalloweenEgg", "Off")

    local ritual = tab:AddRightGroupbox(T("Ritual (beta)", "พิธีกรรม (ทดลอง)"), "bomb")
    Theseus.UI.Toggle(ritual, "AutoRitual", {
        Text = T("Auto Ritual", "พิธีกรรมอัตโนมัติ"),
        Description = T("Joins the Headless ritual while it is open", "เข้าร่วมพิธีกรรม Headless ช่วงที่เปิด"),
        Risky = true,
    })
    Theseus.UI.Status(ritual, "Ritual", "Ritual is closed")

    local esp = tab:AddRightGroupbox(T("Event ESP", "มองเห็นอีเวนต์"), "eye")
    Theseus.UI.KeyToggle(esp, "HalloweenEsp", {
        Text = T("Event ESP", "มองเห็นอีเวนต์"),
        Description = T("Shows candy, doors, pumpkins and the altar through walls", "แสดงลูกกวาด ประตู ฟักทอง และแท่นพิธีทะลุกำแพง"),
    })
    Theseus.UI.Bind("HalloweenEspTypes", esp:AddDropdown("HalloweenEspTypes", {
        Text = T("Show (empty = all)", "แสดง (ว่าง = ทั้งหมด)"),
        Values = { "Candy", "Doors", "Pumpkins", "Altar" },
        Multi = true,
        Default = {},
    }))
end

function Theseus.UI.Ranch(tab)
    local ranch = tab:AddLeftGroupbox(T("Ranch", "ฟาร์ม"), "house")
    Theseus.UI.Toggle(ranch, "AutoEquipBest", { Text = T("Auto Place Best Pets", "วางสัตว์ตัวดีสุดอัตโนมัติ"), Description = T("Keeps the highest income pets on your plot", "ใส่สัตว์ที่ทำเงินได้มากสุดลงพล็อตเสมอ") })
    Theseus.UI.Toggle(ranch, "AutoCollectCash", { Text = T("Auto Collect Cash", "เก็บเงินอัตโนมัติ") })
    ranch:AddButton({ Text = T("Place Best Now", "วางตัวดีสุดเดี๋ยวนี้"), Style = "Primary", Func = Theseus.UI.Detach("place pets", Theseus.Pets.PlaceNow) })
        :AddButton({ Text = T("Collect Now", "เก็บเดี๋ยวนี้"), Func = Theseus.UI.Detach("collect cash", Theseus.Pets.CollectNow) })
    Theseus.UI.Status(ranch, "Pets", "Idle")

    local sell = tab:AddLeftGroupbox(T("Sell Pets", "ขายสัตว์เลี้ยง"), "coin")
    local rarities = Theseus.UI.Rarities()
    Theseus.UI.Toggle(sell, "AutoSell", { Text = T("Auto Sell Pets", "ขายสัตว์อัตโนมัติ"), Description = T("Sells bag pets outside the rarities you keep", "ขายสัตว์ในกระเป๋าที่ไม่อยู่ในความหายากที่เก็บไว้"), Risky = true })
    sell:AddButton({ Text = T("Sell Now", "ขายเดี๋ยวนี้"), Style = "Warning", DoubleClick = true, Func = Theseus.UI.Detach("sell now", function()
        local sold = Theseus.Sell.Now()
        Theseus.Util.Notify("Sell", (sold or 0) > 0 and ("Sold " .. sold .. " pets") or "Nothing to sell with these options", 4)
    end) })
    Theseus.UI.Bind("SellRarities", sell:AddDropdown("SellRarities", { Text = T("Rarities To Keep", "ความหายากที่เก็บไว้"), Values = rarities, Multi = true, Default = {} }))
    Theseus.UI.Bind("SellKeepBest", sell:AddSlider("SellKeepBest", { Text = T("Keep Best Pets", "เก็บตัวดีสุดไว้"), Min = 0, Max = 100, Default = 10, Rounding = 0 }))
    Theseus.UI.Bind("SellUnderIncome", sell:AddInput("SellUnderIncome", { Text = T("Only Below Income /s", "ขายเฉพาะรายได้ต่ำกว่า /วิ"), Default = "0", Numeric = true, Finished = true }))
    Theseus.UI.Bind("SellKeepMutated", sell:AddCheckbox("SellKeepMutated", { Text = T("Keep Mutated Pets", "ไม่ขายตัวมิวเทชัน"), Default = true }))
    Theseus.UI.Status(sell, "SellPreview", "Will sell 0")
end

function Theseus.UI.Care(tab)
    local feed = tab:AddRightGroupbox(T("Feeding", "ให้อาหาร"), "heart")
    Theseus.UI.Toggle(feed, "AutoFeed", { Text = T("Auto Feed", "ให้อาหารอัตโนมัติ") })
    feed:AddButton({ Text = T("Feed Now", "ให้อาหารเดี๋ยวนี้"), Func = Theseus.UI.Detach("feed now", Theseus.Pets.Feed) })
    Theseus.UI.Bind("FoodTypes", feed:AddDropdown("FoodTypes", { Text = T("Foods (empty = all)", "อาหาร (ว่าง = ทั้งหมด)"), Values = table.clone(Theseus.GameLib.FoodOrder), Multi = true, Default = {} }))
    Theseus.UI.Bind("FeedTarget", feed:AddDropdown("FeedTarget", { Text = T("Feed", "ให้อาหาร"), Values = { "Placed", "Ride pet", "All" }, Default = "Placed" }))
    Theseus.UI.Status(feed, "Feed", "Idle")

    local protect = tab:AddRightGroupbox(T("Protect", "ป้องกัน"), "shield")
    local list = Theseus.UI.Bind("ProtectList", protect:AddDropdown("ProtectList", { Text = T("Never Sell Or Fuse", "ห้ามขายหรือหลอม"), Values = Theseus.UI.Names(Theseus.GameLib.PetInfo), Multi = true, Searchable = true, Default = {} }))
    protect:AddButton({ Text = T("Refresh Pets", "รีเฟรชสัตว์"), Func = function()
        list:SetValues(Theseus.UI.Names(Theseus.GameLib.PetInfo))
    end })

    local fuse = tab:AddRightGroupbox(T("Fusion", "หลอมสัตว์"), "bomb")
    local rarities = Theseus.Fusion.Rarities()
    Theseus.UI.Toggle(fuse, "AutoFusion", { Text = T("Auto Fusion", "หลอมสัตว์อัตโนมัติ"), Description = T("Fuses four matching pets and claims the result", "หลอมสัตว์ 4 ตัวที่ตรงเงื่อนไขแล้วรับผล"), Risky = true })
    fuse:AddButton({ Text = T("Fuse Now", "หลอมเดี๋ยวนี้"), Func = Theseus.UI.Detach("fuse now", Theseus.Fusion.Now) })
    Theseus.UI.Bind("FuseRarities", fuse:AddDropdown("FuseRarities", { Text = T("Rarities To Fuse", "ความหายากที่จะหลอม"), Values = rarities, Multi = true, Default = {} }))
    Theseus.UI.Bind("FuseKeepBest", fuse:AddSlider("FuseKeepBest", { Text = T("Keep Best Pets", "เก็บตัวดีสุดไว้"), Min = 0, Max = 100, Default = 10, Rounding = 0 }))
    Theseus.UI.Bind("FuseKeepMutated", fuse:AddCheckbox("FuseKeepMutated", { Text = T("Keep Mutated Pets", "ไม่ใช้ตัวมิวเทชัน"), Default = true }))
    Theseus.UI.Status(fuse, "Fusion", "Idle")
end

function Theseus.UI.PetsTab(window)
    local tab = window:AddTab(T("Pets", "สัตว์เลี้ยง"), "shell", T("Ranch, selling and fusion", "ฟาร์ม ขาย และหลอม"))
    Theseus.UI.Ranch(tab)
    Theseus.UI.Care(tab)
end

function Theseus.UI.Upgrades(window)
    local tab = window:AddTab(T("Upgrades", "อัปเกรด"), "oneup", T("Luck, rebirth, shop, rewards", "โชค รีเบิร์ธ ร้าน รางวัล"))
    local cap = math.max(1, Theseus.GameLib.Rebirths.Cap or 1)

    local up = tab:AddLeftGroupbox(T("Upgrades", "อัปเกรด"), "oneup")
    Theseus.UI.Toggle(up, "AutoUpgrade", { Text = T("Auto Upgrade Hatch Luck", "อัปโชคฟักอัตโนมัติ"), Description = T("Buys luck upgrades that pay back fast", "ซื้ออัปโชคที่คืนทุนเร็ว") })
    up:AddButton({ Text = T("Upgrade Now", "อัปเดี๋ยวนี้"), Style = "Primary", Func = Theseus.UI.Detach("upgrade now", Theseus.Economy.UpgradeNow) })
    Theseus.UI.Toggle(up, "SmartSpend", { Text = T("Spend By Payback", "ใช้เงินตามความคุ้ม"), Description = T("Spends on what pays back first and saves for rebirth", "ใช้เงินกับสิ่งที่คืนทุนก่อน และเก็บไว้รีเบิร์ธ") })
    Theseus.UI.Toggle(up, "AutoRebirth", { Text = T("Auto Rebirth", "รีเบิร์ธอัตโนมัติ"), Description = T("Rebirths when cash and the needed pet are ready", "รีเบิร์ธเมื่อเงินและสัตว์ที่ต้องใช้พร้อม"), Risky = true })
    up:AddButton({ Text = T("Rebirth Now", "รีเบิร์ธเดี๋ยวนี้"), Style = "Warning", DoubleClick = true, Func = Theseus.UI.Detach("rebirth now", Theseus.Economy.RebirthNow) })
    Theseus.UI.Bind("RebirthTarget", up:AddSlider("RebirthTarget", { Text = T("Stop At Rebirth", "หยุดที่รีเบิร์ธ"), Min = 1, Max = cap, Default = cap, Rounding = 0 }))
    Theseus.UI.Status(up, "Upgrade", "Idle")

    local shop = tab:AddRightGroupbox(T("Stock Shop", "ร้านสต็อก"), "shop")
    Theseus.UI.Toggle(shop, "AutoShop", { Text = T("Auto Buy Stock", "ซื้อของในร้านอัตโนมัติ"), Description = T("Buys the picked items when they restock", "ซื้อของที่เลือกเมื่อร้านเติมของ") })
    shop:AddButton({ Text = T("Buy Now", "ซื้อเดี๋ยวนี้"), Func = Theseus.UI.Detach("buy now", Theseus.Shop.BuyNow) })
    Theseus.UI.Bind("ShopItems", shop:AddDropdown("ShopItems", { Text = T("Items To Buy", "ของที่จะซื้อ"), Values = Theseus.UI.Values(Theseus.Shop.Labels), Multi = true, Searchable = true, Default = {} }))
    Theseus.UI.Bind("ShopKeepCash", shop:AddInput("ShopKeepCash", { Text = T("Keep Cash", "กันเงินไว้"), Default = "0", Numeric = true, Finished = true }))
    Theseus.UI.Status(shop, "Shop", "Idle")

    local rewards = tab:AddRightGroupbox(T("Rewards", "รางวัล"), "key")
    Theseus.UI.Toggle(rewards, "AutoClaim", { Text = T("Auto Claim Rewards", "รับรางวัลอัตโนมัติ"), Description = T("Index, offline and event rewards", "รางวัลสมุดสะสม ออฟไลน์ และอีเวนต์") })
    rewards:AddButton({ Text = T("Claim All Now", "รับทั้งหมดเดี๋ยวนี้"), Func = Theseus.UI.Detach("claim now", Theseus.Rewards.ClaimNow) })
    Theseus.UI.Status(rewards, "Rewards", "Idle")

    local boosts = tab:AddRightGroupbox(T("Boosts", "บูสต์"), "zap")
    Theseus.UI.Status(boosts, "Boosts", "No boosts running")
end

function Theseus.UI.TeleportTab(window)
    local tab = window:AddTab(T("Teleport", "วาร์ป"), "pipe", T("Places and players", "สถานที่และผู้เล่น"))

    local places = tab:AddLeftGroupbox(T("Places", "สถานที่"), "map")
    local placeDrop = Theseus.UI.Bind("TeleportPlace", places:AddDropdown("TeleportPlace", { Text = T("Place", "สถานที่"), Values = Theseus.UI.Values(Theseus.Teleport.PlaceNames), Searchable = true }))
    places:AddButton({ Text = T("Teleport", "วาร์ป"), Style = "Primary", Func = Theseus.UI.Detach("teleport", function() Theseus.Teleport.To(placeDrop.Value) end) })
        :AddButton({ Text = T("Refresh", "รีเฟรช"), Func = function() placeDrop:SetValues(Theseus.UI.Values(Theseus.Teleport.PlaceNames)) end })

    local players = tab:AddRightGroupbox(T("Players", "ผู้เล่น"), "user")
    local playerDrop = Theseus.UI.Bind("TeleportPlayer", players:AddDropdown("TeleportPlayer", { Text = T("Player", "ผู้เล่น"), SpecialType = "Player", Searchable = true }))
    players:AddButton({ Text = T("Teleport To Player", "วาร์ปไปหาผู้เล่น"), Func = Theseus.UI.Detach("teleport player", function() Theseus.Teleport.ToPlayer(playerDrop.Value) end) })
end

function Theseus.UI.PlayerTab(window)
    local tab = window:AddTab(T("Player", "ผู้เล่น"), "user", T("Movement and utility", "การเคลื่อนที่และอรรถประโยชน์"))

    local move = tab:AddLeftGroupbox(T("Movement", "การเคลื่อนที่"), "zap")
    Theseus.UI.KeyToggle(move, "SpeedOn", { Text = T("Speed", "วิ่งเร็ว") })
    Theseus.UI.Bind("WalkSpeed", move:AddSlider("WalkSpeed", { Text = T("Walk Speed", "ความเร็ว"), Min = 16, Max = 300, Default = Config.WalkSpeed, Rounding = 0 }))
    Theseus.UI.KeyToggle(move, "JumpOn", { Text = T("Jump Power", "กระโดดสูง") })
    Theseus.UI.Bind("JumpPower", move:AddSlider("JumpPower", { Text = T("Jump Power", "แรงกระโดด"), Min = 50, Max = 300, Default = Config.JumpPower, Rounding = 0 }))
    Theseus.UI.KeyToggle(move, "InfJump", { Text = T("Infinite Jump", "กระโดดไม่จำกัด") })

    local troll = tab:AddLeftGroupbox(T("Troll", "ป่วน"), "troll")
    Theseus.UI.Bind("TrollTarget", troll:AddDropdown("TrollTarget", { Text = T("Target", "เป้าหมาย"), SpecialType = "Player", Searchable = true }))
    Theseus.UI.Toggle(troll, "Fling", { Text = T("Fling", "เหวี่ยงกระเด็น"), Description = T("Pauses egg farming while on", "หยุดฟาร์มไข่ชั่วคราวระหว่างเปิด"), Risky = true })
    Theseus.UI.Toggle(troll, "Stick", { Text = T("Stick To Player", "เกาะติดผู้เล่น"), Description = T("Pauses egg farming while on", "หยุดฟาร์มไข่ชั่วคราวระหว่างเปิด"), Risky = true })
    troll:AddButton({ Text = T("Spectate", "ส่องดู"), Func = function() Theseus.Troll.Spectate(Theseus.Options.TrollTarget) end })
        :AddButton({ Text = T("Stop", "เลิกส่อง"), Func = function() Theseus.Troll.Spectate(nil) end })

    local fly = tab:AddRightGroupbox(T("Fly and Noclip", "บินและเดินทะลุ"), "pipe")
    local flyToggle = Theseus.UI.KeyToggle(fly, "Fly", { Text = T("Fly", "บิน") })
    Theseus.UI.Bind("FlySpeed", fly:AddSlider("FlySpeed", { Text = T("Fly Speed", "ความเร็วบิน"), Min = 20, Max = 500, Default = Config.FlySpeed, Rounding = 0 }))
    Theseus.UI.KeyToggle(fly, "NoClip", { Text = T("Noclip", "เดินทะลุ") })
    Theseus.UI.CarryGuard(flyToggle)

    local misc = tab:AddRightGroupbox(T("Utility", "อรรถประโยชน์"), "gear")
    Theseus.UI.Toggle(misc, "InstantPrompt", {
        Text = T("Instant E", "กด E ทันที"),
        Description = T("Press to interact without holding the key", "กดเก็บหรือโต้ตอบได้เลย ไม่ต้องค้างปุ่ม"),
    })
    Theseus.UI.Toggle(misc, "AntiAfk", { Text = T("Anti AFK", "กันหลุด AFK") })
    Theseus.UI.Toggle(misc, "AutoReconnect", { Text = T("Auto Reconnect", "เข้าเกมใหม่อัตโนมัติ"), Description = T("Joins back and reloads the hub after a disconnect", "หลุดแล้วเข้าเกมใหม่และโหลดสคริปต์ให้เอง") })
    misc:AddButton({ Text = T("Rejoin", "เข้าเซิร์ฟใหม่"), Func = Theseus.UI.Detach("rejoin", Theseus.Server.Rejoin) })
        :AddButton({ Text = T("Server Hop", "ย้ายเซิร์ฟ"), Func = Theseus.UI.Detach("hop", Theseus.Server.Hop) })

    local esp = tab:AddRightGroupbox(T("Egg ESP", "มองเห็นไข่"), "eye")
    Theseus.UI.KeyToggle(esp, "EggEsp", { Text = T("Egg ESP", "มองเห็นไข่"), Description = T("Shows eggs through walls with rarity and distance", "แสดงไข่ทะลุกำแพง พร้อมความหายากและระยะ") })
    Theseus.UI.Bind("EspMinRarity", esp:AddDropdown("EspMinRarity", { Text = T("Minimum Rarity", "ความหายากขั้นต่ำ"), Values = Theseus.UI.Rarities(), Default = Theseus.GameLib.RarityOrder[1] }))

    local perf = tab:AddRightGroupbox(T("Performance", "ประสิทธิภาพ"), "zap")
    Theseus.UI.Toggle(perf, "HideOtherPets", { Text = T("Hide Other Pets", "ซ่อนสัตว์คนอื่น"), Description = T("Only your own pets stay visible", "เห็นแค่สัตว์ของเรา") })
    Theseus.UI.Toggle(perf, "HideOtherEggs", { Text = T("Hide Other Eggs", "ซ่อนไข่คนอื่น"), Description = T("Hides eggs on other players' bases", "ซ่อนไข่ในฐานคนอื่น") })
    Theseus.UI.Toggle(perf, "BoostFps", { Text = T("Boost FPS", "เพิ่ม FPS"), Description = T("Lower graphics for smoother play", "ลดกราฟิกให้ลื่นขึ้น") })
    Theseus.UI.Toggle(perf, "UnlockFps", { Text = T("FPS Cap", "จำกัด FPS") })
    Theseus.UI.Bind("FpsCap", perf:AddSlider("FpsCap", { Text = T("Max FPS", "FPS สูงสุด"), Min = 30, Max = 240, Default = Config.FpsCapDefault, Rounding = 0 }))
    Theseus.UI.Toggle(perf, "Render3D", { Text = T("Disable 3D Rendering", "ปิดการเรนเดอร์ 3D"), Description = T("Black screen to save power while farming AFK", "จอดำ ประหยัดเครื่องตอนฟาร์ม AFK") })
end

local function BuildTabs()
    local window = Library.Window
    local try = Theseus.Util.Try

    window:AddTabSection(T("Main", "หลัก"))
    try("ui home", Theseus.UI.Home, window)

    window:AddTabSection(T("Farming", "ฟาร์ม"))
    try("ui eggs", Theseus.UI.EggFarm, window)
    try("ui hatch", Theseus.UI.Hatching, window)
    try("ui halloween", Theseus.UI.Halloween, window)

    window:AddTabSection(T("Progression", "พัฒนา"))
    try("ui pets", Theseus.UI.PetsTab, window)
    try("ui upgrades", Theseus.UI.Upgrades, window)

    window:AddTabSection(T("Misc", "อื่นๆ"))
    try("ui teleport", Theseus.UI.TeleportTab, window)
    try("ui player", Theseus.UI.PlayerTab, window)
    try("ui settings", window.AddSettingsTab, window)

    try("ui floats", Theseus.Move.BuildFloats, Theseus.UI.Floats)
    Library:Every(Config.PumpTick, function() try("ui pump", Theseus.UI.Pump) end)
end

---@return boolean  menu is up
function Theseus.Boot()
    Library = Theseus.Util.LoadLibrary(Config.UiSource)
    if not Library then return false end

    Library:CreateWindow({
        Title = "Theseus",
        SubTitle = "Ride A Pet by Theseus",
        MenuKey = Enum.KeyCode.LeftControl,
        ConfigFolder = "Ride A Pet",
        Language = "Auto",
        Theme = "Overworld",
        OnUnlocked = function()
            Theseus.Util.Try("gamelib load", Theseus.GameLib.LoadModules)
            Theseus.Util.Try("gamelib build", Theseus.GameLib.Build)
            Theseus.Util.Try("ui build", BuildTabs)
            Theseus.Util.Try("scheduler", Theseus.Scheduler.Boot)
            Theseus.Util.Try("autoload config", Library.LoadAutoloadConfig, Library)
            task.spawn(function()
                Theseus.Util.Try("gamelib check", Theseus.GameLib.Check)
                Theseus.Util.Try("ui gate", Theseus.UI.Gate)
            end)
        end,
    })
    Theseus.BindTeardown(RunService.Heartbeat)
    Library:OnUnload(function() Theseus:Unload() end)
    return true
end

Theseus.Util.Try("boot", Theseus.Boot)