--[[

  _______ _                                 _    _       _     
 |__   __| |                               | |  | |     | |    
    | |  | |__   ___  ___  ___ _   _ ___   | |__| |_   _| |__  
    | |  | '_ \ / _ \/ __|/ _ \ | | / __|  |  __  | | | | '_ \ 
    | |  | | | |  __/\__ \  __/ |_| \__ \  | |  | | |_| | |_) |
    |_|  |_| |_|\___||___/\___|\__,_|___/  |_|  |_|\__,_|_.__/ 
                                                               
--]]

local HttpService       = game:GetService("HttpService")
local cloneref          = (cloneref or clonereference or function(i) return i end)
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))

local UI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/ntpworkstation/Theseus/refs/heads/main/ui_theseus.lua"
))()

local Window = UI:CreateWindow({
    Title     = "Theseus",
    SubTitle  = "Ant Empire",
    ToggleKey = Enum.KeyCode.RightShift,
    Intro     = false,
})

-- ── Routes ────────────────────────────────────────────────────────────────────
local EventRoute2 = ReplicatedStorage.WuKong.RemoteActionFunction
local ROUTE       = "/\xE8\x83\x8C\xE5\x8C\x85\xE7\xB3\xBB\xE7\xBB\x9F/\xE8\x83\x8C\xE5\x8C\x85\xE6\xB7\xBB\xE5\x8A\xA0\xE9\x81\x93\xE5\x85\xB7?\xE8\xB4\xAD\xE4\xB9\xB0"
local ROUTE2      = "/\xE8\xB4\xA7\xE5\xB8\x81/\xE9\x87\x91\xE5\xB8\x81?\xE5\xB1\x9E\xE6\x80\xA7\xE8\xAE\xBE\xE4\xB8\xBA\xE6\x8C\x87\xE5\xAE\x9A\xE5\x80\xBC?\xE8\xB4\xAD\xE4\xB9\xB0"
local EGG_ROUTE   = "/\xE5\x8A\x9F\xE8\x83\xBD\xE5\x95\x86\xE4\xBA\xBA/\xE8\x8E\xB7\xE5\xBE\x97\xE5\xAE\xA0\xE7\x89\xA9\xE8\x9B\x8B?\xE8\xB4\xAD\xE4\xB9\xB0"
local ANT_ROUTE   = "/\xE8\x83\x8C\xE5\x8C\x85\xE7\xB3\xBB\xE7\xBB\x9F/\xE8\x83\x8C\xE5\x8C\x85\xE6\xB7\xBB\xE5\x8A\xA0\xE7\x89\xA9\xE5\x93\x81?\xE8\xB4\xAD\xE4\xB9\xB0"

-- ── Helpers ───────────────────────────────────────────────────────────────────
local function getRemote()
    local wk = ReplicatedStorage:FindFirstChild("WuKong")
    return wk and wk:FindFirstChild("RemoteActionFunction")
end

local function jsonStr(s)
    return '"' .. tostring(s):gsub('[\\"]', "\\%0") .. '"'
end

local function describe(v)
    if type(v) == "table" then
        local ok, s = pcall(HttpService.JSONEncode, HttpService, v)
        return ok and s or tostring(v)
    end
    return tostring(v)
end

local function looksFailed(res)
    if res == false then return true end
    if type(res) == "table" and (res.success == false or res.Success == false) then return true end
    return false
end

local function parseAmount(text)
    return math.max(math.floor(tonumber(text) or 1), 1)
end

local function getItemNames()
    local names = {}
    local assets = ReplicatedStorage:FindFirstChild("Assets")
    local folder = assets and assets:FindFirstChild("Item")
    if folder then
        for _, c in ipairs(folder:GetChildren()) do
            names[#names + 1] = c.Name
        end
    end
    table.sort(names)
    return names
end

-- ── Remote callers ────────────────────────────────────────────────────────────
local function buyOnce(itemId, count)
    local remote = getRemote()
    if not remote then return false, "RemoteActionFunction not found" end
    local payload = string.format('{"Count":%d,"ItemId":%s}', count, jsonStr(itemId))
    return pcall(function()
        return remote:InvokeServer(ROUTE, "__null__", "__null__", { payload })
    end)
end

local function buyEggOnce(eggId, count)
    local remote = getRemote()
    if not remote then return false, "RemoteActionFunction not found" end
    local payload = string.format('{"Count":%d,"PetEggId":%s}', count, jsonStr(eggId))
    return pcall(function()
        return remote:InvokeServer(EGG_ROUTE, "__null__", "__null__", { payload })
    end)
end

local function giveAnt(count)
    local remote = getRemote()
    if not remote then return false, "RemoteActionFunction not found" end
    local payload = string.format('{"Count":%d,"V":1805824}', count)
    return pcall(function()
        return remote:InvokeServer(ANT_ROUTE, "__null__", "__null__", { payload })
    end)
end

-- ── Egg config ────────────────────────────────────────────────────────────────
local eggConfig   = require(ReplicatedStorage._genConfigs.event_tbpetegg)
local eggOptions  = {}
local nameToIdMap = {}

for _, data in pairs(eggConfig) do
    if type(data) == "table" and data.Disname and data.Id then
        table.insert(eggOptions, data.Disname)
        nameToIdMap[data.Disname] = data.Id
    end
end
table.sort(eggOptions)

-- ── EventBus ──────────────────────────────────────────────────────────────────
local Event = ReplicatedStorage.Packages.EventBus.RemoteEvent

-- ── State ─────────────────────────────────────────────────────────────────────
local selected      = nil
local selectedEggId = nil
local itemCount     = 1
local eggCount      = 1
local antCount      = 1
local moneyValue    = 0
local autoUpRunning = false
local unlockSlots   = 50
local upgradeLevels = 200

local allAttributes = {
    "幸运值", "单抽数量", "蚁后等级",
    "巢穴层数", "蚂蚁攻击力", "蚂蚁移速",
}

-- ════════════════════════════════════════════════════════════════════════════
--  TAB + GROUPBOXES
-- ════════════════════════════════════════════════════════════════════════════
local Tab   = Window:AddTab("Misc", "crown")
local Left  = Tab:AddLeftGroupbox("Actions")
local Right = Tab:AddRightGroupbox("Extras")

-- ── Gift Item ─────────────────────────────────────────────────────────────────
Left:AddDropdown("ItemSelect", {
    Text       = "Gift Item — Select",
    Values     = getItemNames(),
    Default    = nil,
    AllowNull  = true,
    Searchable = true,
    Callback   = function(v) selected = v end,
})
Left:AddInput("ItemCount", {
    Text        = "Gift Item — Count",
    Default     = "1",
    Placeholder = "1",
    Numeric     = true,
    Callback    = function(v) itemCount = parseAmount(v) end,
})
Left:AddButton({ Text = "Gift Item", Func = function()
    if not selected then
        return UI:Notify({ Title = "Gift", Content = "เลือก item ก่อน", Type = "Error", Duration = 3 })
    end
    local ok, res = buyOnce(selected, itemCount)
    UI:Notify({
        Title    = ok and "Gift Item" or "Failed",
        Content  = ok and (selected .. " x" .. itemCount .. " → " .. describe(res)) or tostring(res),
        Type     = (not ok or looksFailed(res)) and "Error" or "Success",
        Duration = 4,
    })
end })

-- ── Gift Egg ──────────────────────────────────────────────────────────────────
Left:AddDropdown("EggSelect", {
    Text       = "Gift Egg — Select",
    Values     = eggOptions,
    Default    = nil,
    AllowNull  = true,
    Searchable = true,
    Callback   = function(v) selectedEggId = nameToIdMap[v] end,
})
Left:AddInput("EggCount", {
    Text        = "Gift Egg — Count",
    Default     = "1",
    Placeholder = "1",
    Numeric     = true,
    Callback    = function(v) eggCount = parseAmount(v) end,
})
Left:AddButton({ Text = "Gift Egg", Func = function()
    if not selectedEggId then
        return UI:Notify({ Title = "Gift", Content = "เลือก egg ก่อน", Type = "Error", Duration = 3 })
    end
    local ok, res = buyEggOnce(selectedEggId, eggCount)
    UI:Notify({
        Title    = ok and "Gift Egg" or "Failed",
        Content  = ok and (selectedEggId .. " x" .. eggCount .. " → " .. describe(res)) or tostring(res),
        Type     = (not ok or looksFailed(res)) and "Error" or "Success",
        Duration = 4,
    })
end })

-- ── Give Ant ──────────────────────────────────────────────────────────────────
Left:AddInput("AntCount", {
    Text        = "Give Ant — Count",
    Default     = "1",
    Placeholder = "1",
    Numeric     = true,
    Callback    = function(v) antCount = parseAmount(v) end,
})
Left:AddButton({ Text = "Give Ant", Func = function()
    local ok, res = giveAnt(antCount)
    UI:Notify({
        Title    = ok and "Give Ant" or "Failed",
        Content  = ok and ("x" .. antCount .. " → " .. describe(res)) or tostring(res),
        Type     = (not ok or looksFailed(res)) and "Error" or "Success",
        Duration = 4,
    })
end })

-- ── Set Money ─────────────────────────────────────────────────────────────────
Left:AddInput("MoneyAmount", {
    Text        = "Set Money — Amount",
    Placeholder = "999999999",
    Numeric     = true,
    Callback    = function(v)
        local n = tonumber(v)
        if n then moneyValue = n end
    end,
})
Left:AddButton({ Text = "Set Money", Func = function()
    if moneyValue > 0 then
        EventRoute2:InvokeServer(ROUTE2, moneyValue)
        UI:Notify({ Title = "Set Money", Content = "ตั้งเป็น " .. moneyValue, Type = "Success", Duration = 5 })
    else
        UI:Notify({ Title = "Failed", Content = "กรอกจำนวนก่อน", Type = "Error", Duration = 4 })
    end
end })

-- ── Rollback ──────────────────────────────────────────────────────────────────
Right:AddButton({ Text = "Rollback", Func = function()
    Event:FireServer("ECS_COMMAND", "SellPlayerFood", {
        Source     = "PlayerFoodPrompt",
        FoodAmount = tonumber("nan"),
    })
    UI:Notify({ Title = "Rollback", Content = "Success!", Type = "Success", Duration = 5 })
end })

-- ── Unlock Base ───────────────────────────────────────────────────────────────
Right:AddInput("UnlockSlots", {
    Text        = "Unlock Base — Slots",
    Default     = "50",
    Placeholder = "50",
    Numeric     = true,
    Callback    = function(v) unlockSlots = math.max(math.floor(tonumber(v) or 50), 1) end,
})
Right:AddButton({ Text = "Unlock Base", Func = function()
    for i = 1, unlockSlots do
        Event:FireServer("ECS_COMMAND", "AddAntSlot", {
            SlotIndex = i, RoomIndex = 1, Source = "ProximityPrompt",
        })
    end
    UI:Notify({ Title = "Unlock Base", Content = "ปลดล็อค " .. unlockSlots .. " slots!", Type = "Success", Duration = 5 })
end })

-- ── Auto Upgrade ──────────────────────────────────────────────────────────────
Right:AddInput("UpgradeLevels", {
    Text        = "Auto Upgrade — Levels",
    Default     = "200",
    Placeholder = "200",
    Numeric     = true,
    Callback    = function(v) upgradeLevels = math.max(math.floor(tonumber(v) or 200), 1) end,
})
Right:AddButton({ Text = "Auto Upgrade", Func = function()
    if autoUpRunning then
        return UI:Notify({ Title = "Auto Upgrade", Content = "กำลัง run อยู่!", Type = "Error", Duration = 3 })
    end
    autoUpRunning = true
    UI:Notify({ Title = "Auto Upgrade", Content = "เริ่มแล้ว! " .. upgradeLevels .. " levels", Type = "Success", Duration = 3 })
    task.spawn(function()
        for i = 1, upgradeLevels do
            for _, attrName in ipairs(allAttributes) do
                Event:FireServer("ECS_COMMAND", "UpgradePlayerAttribute", { AttributeName = attrName })
            end
            task.wait(0.05)
        end
        autoUpRunning = false
        UI:Notify({ Title = "Auto Upgrade", Content = "Done!", Type = "Success", Duration = 4 })
    end)
end })

-- ════════════════════════════════════════════════════════════════════════════
UI:Notify({ Title = "Theseus", Content = "Loaded! Ant Empire", Type = "Success", Duration = 5 })
