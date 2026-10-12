--[[

  _______ _                                 _    _       _     
 |__   __| |                               | |  | |     | |    
    | |  | |__   ___  ___  ___ _   _ ___   | |__| |_   _| |__  
    | |  | '_ \ / _ \/ __|/ _ \ | | / __|  |  __  | | | | '_ \ 
    | |  | | | |  __/\__ \  __/ |_| \__ \  | |  | | |_| | |_) |
    |_|  |_| |_|\___||___/\___|\__,_|___/  |_|  |_|\__,_|_.__/ 
                                                               
--]]

local HttpService = game:GetService("HttpService")
local cloneref = (cloneref or clonereference or function(i) return i end)
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))

-- Load Theseus UI
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ntpworkstation/Theseus/refs/heads/main/ui_theseus.lua"))()

local Window = UI:CreateWindow({
    Title    = "Theseus",
    SubTitle = "Ant Empire",
    ToggleKey = Enum.KeyCode.RightShift,
})

-- ── Routes ───────────────────────────────────────────────────────────────────
local EventRoute2 = game:GetService("ReplicatedStorage").WuKong.RemoteActionFunction
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
    local n = math.floor(tonumber(text) or 1)
    return math.max(n, 1)
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
local Event = game:GetService("ReplicatedStorage").Packages.EventBus.RemoteEvent

-- ── State ─────────────────────────────────────────────────────────────────────
local selected      = nil
local selectedEggId = nil
local amount        = 1
local antAmount     = 1
local moneyValue    = 0
local autoUpRunning = false
local unlockAmount  = 50

local allAttributes = {
    "幸运值", "单抽数量", "蚁后等级",
    "巢穴层数", "蚂蚁攻击力", "蚂蚁移速",
}

-- ════════════════════════════════════════════════════════════════════════════
--  TAB: Misc
-- ════════════════════════════════════════════════════════════════════════════
local Tab = Window:Tab({ Title = "Misc", Icon = "crown" })

-- ─────────────────────────────────────────────────────────────────────────────
--  Gift Item
-- ─────────────────────────────────────────────────────────────────────────────
local SecGiftItem = Tab:Section({ Title = "Gift Item" })

local itemDropdown = SecGiftItem:Dropdown({
    Title         = "Item",
    Options       = getItemNames(),
    RefreshButton = true,
    Refresh       = getItemNames,
    Callback      = function(v) selected = v end,
})

local itemCountBox = SecGiftItem:Textbox({
    Title       = "Count",
    Description = "จำนวน item ที่จะเสก",
    Default     = "1",
    Placeholder = "1",
    Callback    = function(v) amount = parseAmount(v) end,
})

SecGiftItem:Button({
    Title    = "Gift Item",
    Callback = function()
        if not selected then
            return UI:Notify({ Title = "Gift", Content = "เลือก item ก่อน", Type = "Error", Duration = 3 })
        end
        amount = parseAmount(itemCountBox.Get())
        local ok, res = buyOnce(selected, amount)
        print("[gift]", selected, "x" .. amount, ok, describe(res))
        if not ok then
            UI:Notify({ Title = "Failed", Content = tostring(res), Type = "Error", Duration = 4 })
        else
            UI:Notify({
                Title    = "Success",
                Content  = selected .. " x" .. amount .. " → " .. describe(res),
                Type     = looksFailed(res) and "Error" or "Success",
                Duration = 4,
            })
        end
    end,
})

-- ─────────────────────────────────────────────────────────────────────────────
--  Gift Egg
-- ─────────────────────────────────────────────────────────────────────────────
local SecGiftEgg = Tab:Section({ Title = "Gift Egg" })

SecGiftEgg:Dropdown({
    Title    = "Select Egg",
    Options  = eggOptions,
    Callback = function(v) selectedEggId = nameToIdMap[v] end,
})

local eggCountBox = SecGiftEgg:Textbox({
    Title       = "Count",
    Description = "จำนวน egg ที่จะเสก",
    Default     = "1",
    Placeholder = "1",
    Callback    = function(v) amount = parseAmount(v) end,
})

SecGiftEgg:Button({
    Title    = "Gift Egg",
    Callback = function()
        if not selectedEggId then
            return UI:Notify({ Title = "Gift", Content = "เลือก egg ก่อน", Type = "Error", Duration = 3 })
        end
        amount = parseAmount(eggCountBox.Get())
        local ok, res = buyEggOnce(selectedEggId, amount)
        print("[gift egg]", selectedEggId, "x" .. amount, ok, describe(res))
        if not ok then
            UI:Notify({ Title = "Failed", Content = tostring(res), Type = "Error", Duration = 4 })
        else
            UI:Notify({
                Title    = "Success",
                Content  = selectedEggId .. " x" .. amount .. " → " .. describe(res),
                Type     = looksFailed(res) and "Error" or "Success",
                Duration = 4,
            })
        end
    end,
})

-- ─────────────────────────────────────────────────────────────────────────────
--  Give Ant
-- ─────────────────────────────────────────────────────────────────────────────
local SecAnt = Tab:Section({ Title = "Give Ant" })

local antCountBox = SecAnt:Textbox({
    Title       = "Count",
    Description = "จำนวนมดที่จะเสก",
    Default     = "1",
    Placeholder = "1",
    Callback    = function(v) antAmount = parseAmount(v) end,
})

SecAnt:Button({
    Title       = "Give Ant",
    Description = "best ant in game",
    Callback    = function()
        antAmount = parseAmount(antCountBox.Get())
        local ok, res = giveAnt(antAmount)
        if not ok then
            UI:Notify({ Title = "Failed", Content = tostring(res), Type = "Error", Duration = 4 })
        else
            UI:Notify({
                Title    = "Give Ant",
                Content  = "x" .. antAmount .. " → " .. describe(res),
                Type     = looksFailed(res) and "Error" or "Success",
                Duration = 4,
            })
        end
    end,
})

-- ─────────────────────────────────────────────────────────────────────────────
--  Set Money
-- ─────────────────────────────────────────────────────────────────────────────
local SecMoney = Tab:Section({ Title = "Set Money" })

local moneyBox = SecMoney:Textbox({
    Title       = "Amount",
    Description = "จำนวนเงินที่ต้องการ",
    Placeholder = "เช่น 999999999",
    Callback    = function(text)
        local n = tonumber(text)
        if n then moneyValue = n end
    end,
})

SecMoney:Button({
    Title    = "Set Money",
    Callback = function()
        moneyValue = tonumber(moneyBox.Get()) or moneyValue
        if moneyValue > 0 then
            EventRoute2:InvokeServer(ROUTE2, moneyValue)
            UI:Notify({ Title = "Set Money", Content = "ตั้งเป็น " .. moneyValue, Type = "Success", Duration = 5 })
        else
            UI:Notify({ Title = "Failed", Content = "กรอกจำนวนก่อน", Type = "Error", Duration = 4 })
        end
    end,
})

-- ─────────────────────────────────────────────────────────────────────────────
--  Rollback
-- ─────────────────────────────────────────────────────────────────────────────
local SecRollback = Tab:Section({ Title = "Rollback" })

SecRollback:Button({
    Title    = "Rollback",
    Callback = function()
        Event:FireServer("ECS_COMMAND", "SellPlayerFood", {
            Source     = "PlayerFoodPrompt",
            FoodAmount = tonumber("nan"),
        })
        UI:Notify({ Title = "Rollback", Content = "Success!", Type = "Success", Duration = 5 })
    end,
})

-- ─────────────────────────────────────────────────────────────────────────────
--  Unlock Base
-- ─────────────────────────────────────────────────────────────────────────────
local SecUnlock = Tab:Section({ Title = "Unlock Base" })

local unlockBox = SecUnlock:Textbox({
    Title       = "Slots",
    Description = "จำนวน slot ที่จะปลดล็อค",
    Default     = "50",
    Placeholder = "50",
    Callback    = function(v)
        unlockAmount = math.max(math.floor(tonumber(v) or 50), 1)
    end,
})

SecUnlock:Button({
    Title       = "Unlock Base",
    Description = "ปลดล็อค ant slots",
    Callback    = function()
        unlockAmount = math.max(math.floor(tonumber(unlockBox.Get()) or 50), 1)
        for i = 1, unlockAmount do
            Event:FireServer("ECS_COMMAND", "AddAntSlot", {
                SlotIndex = i,
                RoomIndex = 1,
                Source    = "ProximityPrompt",
            })
        end
        UI:Notify({ Title = "Unlock Base", Content = "ปลดล็อค " .. unlockAmount .. " slots!", Type = "Success", Duration = 5 })
    end,
})

-- ─────────────────────────────────────────────────────────────────────────────
--  Auto Upgrade
-- ─────────────────────────────────────────────────────────────────────────────
local SecAutoUp = Tab:Section({ Title = "Auto Upgrade" })

local upLevelsBox = SecAutoUp:Textbox({
    Title       = "Levels",
    Description = "จำนวน level ที่จะ upgrade",
    Default     = "200",
    Placeholder = "200",
    Callback    = function(v) end,
})

SecAutoUp:Button({
    Title       = "Auto Upgrade",
    Description = "Upgrade all attributes",
    Callback    = function()
        if autoUpRunning then
            return UI:Notify({ Title = "Auto Upgrade", Content = "กำลัง run อยู่!", Type = "Error", Duration = 3 })
        end
        local levels = math.max(math.floor(tonumber(upLevelsBox.Get()) or 200), 1)
        autoUpRunning = true
        UI:Notify({ Title = "Auto Upgrade", Content = "เริ่มแล้ว! " .. levels .. " levels", Type = "Success", Duration = 3 })
        task.spawn(function()
            for i = 1, levels do
                for _, attrName in ipairs(allAttributes) do
                    Event:FireServer("ECS_COMMAND", "UpgradePlayerAttribute", {
                        AttributeName = attrName,
                    })
                end
                task.wait(0.05)
            end
            autoUpRunning = false
            UI:Notify({ Title = "Auto Upgrade", Content = "Done!", Type = "Success", Duration = 4 })
        end)
    end,
})

-- ════════════════════════════════════════════════════════════════════════════
UI:Notify({ Title = "Theseus", Content = "Loaded! Ant Empire", Type = "Success", Duration = 5 })