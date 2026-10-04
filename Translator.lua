-- Vape V4 中文翻译器。

-- ========================================
-- 启动提示音
-- ========================================
pcall(function()
    local SoundService = game:GetService("SoundService")

    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://6026984224"
    sound.Volume = 1
    sound.Parent = SoundService
    sound:Play()

    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end)

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- Rayfield 控制面板：只负责控制翻译器，不替代 Vape 原界面。
local Rayfield = nil
pcall(function()
    Rayfield = loadstring(game:HttpGet(
        "https://sirius.menu/rayfield"
    ))()
end)


local Translator = {
    -- Combat
    ["AimAssist"] = "瞄准辅助",
    ["AutoClicker"] = "自动连点",
    ["Reach"] = "攻击距离延长",
    ["SilentAim"] = "静默瞄准",
    ["TriggerBot"] = "自动触发射击",

    -- Blatant
    ["AntiFall"] = "防坠落伤害",
    ["Fly"] = "飞行",
    ["HighJump"] = "高跳",
    ["HitBoxes"] = "扩大命中盒",
    ["Invisible"] = "隐身",
    ["Jesus"] = "水上行走",
    ["Killaura"] = "杀戮光环",
    ["LongJump"] = "长跳",
    ["MouseTP"] = "鼠标传送",
    ["Phase"] = "相位穿透",
    ["Speed"] = "加速",
    ["Spider"] = "蜘蛛爬墙",
    ["SpinBot"] = "旋转机器人",
    ["Swim"] = "空中游泳",

    -- Render
    ["Arrows"] = "敌人方向箭头",
    ["Chams"] = "透视描边",
    ["ESP"] = "敌人信息透视",
    ["Fullbright"] = "全图高亮",
    ["GamingChair"] = "游戏座椅透视",
    ["Health"] = "血量显示",
    ["NameTags"] = "玩家名字标签",
    ["PlayerModel"] = "玩家模型修改",
    ["Search"] = "物品检索透视",
    ["Tracers"] = "敌人连线",
    ["Waypoints"] = "路径标记点",

    -- Utility
    ["AnimationPlayer"] = "动画播放器",
    ["AntiRagdoll"] = "防布娃娃倒地",
    ["AutoRejoin"] = "自动重连服务器",
    ["Blink"] = "闪现",
    ["ChatSpammer"] = "聊天刷屏",
    ["Disabler"] = "功能禁用器",
    ["HumSpoofer"] = "玩家伪装",
    ["Panic"] = "紧急一键关闭",
    ["Rejoin"] = "重新加入本局",
    ["ServerHop"] = "服务器跳转",
    ["StaffDetector"] = "管理员检测",

    -- World
    ["Anti-AFK"] = "防挂机",
    ["FastProxPrompt"] = "快速交互提示",
    ["Freecam"] = "自由视角",
    ["Gravity"] = "重力修改",
    ["MurderMystery"] = "谋杀之谜",
    ["Parkour"] = "跑酷辅助",
    ["SafeWalk"] = "安全行走",
    ["Wallhop"] = "墙体跳跃",
    ["Xray"] = "X光透视",

    -- MISC
    ["MISC"] = "杂项",
    ["Friends"] = "好友",
    ["Profiles"] = "配置文件",
    ["Targets"] = "目标设置",
    ["default"] = "默认",
    ["Default"] = "默认",

    -- Visual
    ["Text GUI"] = "功能列表显示菜单",
    ["Target Info"] = "攻击目标显示",
    ["Radar"] = "雷达",
    ["Session Info"] = "当前对局信息",
    ["Spotify"] = "音乐插件",

    -- Search mods
    ["Search mods"] = "搜索模块",
    ["Atmosphere"] = "氛围特效",
    ["Breadcrumbs"] = "轨迹残留",
    ["Cape"] = "披风",
    ["China Hat"] = "斗笠",
    ["Clock"] = "时钟",
    ["Disguise"] = "伪装",
    ["FOV"] = "视野角度",
    ["FPS"] = "帧率显示",
    ["Keystrokes"] = "按键显示",
    ["Memory"] = "内存信息",
    ["Ping"] = "延迟显示",
    ["Song Beats"] = "音乐节拍",
    ["Speedmeter"] = "速度计",
    ["Time Changer"] = "时间修改",

    -- Settings
    ["Settings"] = "设置",
    ["General"] = "通用设置",
    ["Modules"] = "模块设置",
    ["GUI"] = "界面设置",
    ["Notifications"] = "通知设置",
    ["GUI Theme"] = "界面主题",
    ["Rebind GUI"] = "重新绑定界面快捷键",

    -- General
    ["Enable Multi-Keybinding"] = "启用多按键绑定",
    ["Allow setting keybinds"] = "允许设置快捷键",
    ["Reset current profile"] = "重置当前配置文件",
    ["Self destruct"] = "自毁",
    ["Reinject"] = "重新注入",

    -- Modules
    ["Teams by server"] = "按服务器区分队伍",
    ["Use team color"] = "使用队伍颜色",

    -- GUI
    ["Blur background"] = "背景模糊",
    ["GUI bind indicator"] = "界面快捷键指示器",
    ["Show tooltips"] = "显示提示信息",
    ["Show legit mode"] = "显示低调模式",
    ["Auto rescale"] = "自动缩放",
    ["Rainbow speed"] = "彩虹动画速度",
    ["Rainbow update rate"] = "彩虹刷新率",
    ["Search bar style"] = "搜索栏样式",
    ["Rainbow Mode - Normal"] = "彩虹模式-普通",
    ["Reset GUI positions"] = "重置界面位置",
    ["Sort GUI"] = "界面自动排序",

    -- Notifications
    ["Toggle alert"] = "开关模块提醒",
    ["Setting toggle alert"] = "修改设置提醒",
}

-- 对照表中出现的分类标题
-- 截图中的 Vape 主页面顶部六个入口也必须翻译。
Translator["Combat"] = "战斗模块"
Translator["Blatant"] = "明显功能模块"
Translator["Render"] = "渲染模块"
Translator["Utility"] = "实用工具模块"
Translator["World"] = "世界模块"
Translator["Inventory"] = "物品栏模块"

-- Vape 主页面的 MISC 区域
Translator["MISC"] = "杂项"
Translator["Friends"] = "好友"
Translator["Profiles"] = "配置文件"
Translator["Targets"] = "目标设置"
Translator["default"] = "默认"
Translator["Default"] = "默认"

-- 常见设置和值
local Extra = {
    ["Target"] = "目标",
    ["Players"] = "玩家",
    ["NPCs"] = "NPC",
    ["Ignore"] = "忽略",
    ["None"] = "无",
    ["Attacks per Second"] = "每秒攻击次数",
    ["Swing range"] = "挥击范围",
    ["Attack range"] = "攻击范围",
    ["Max angle"] = "最大角度",
    ["Max targets"] = "最大目标数",
    ["Require mouse down"] = "需要按住鼠标",
    ["Sword lunge only"] = "仅限剑突刺",
    ["Show target"] = "显示目标",
    ["Target Color"] = "目标颜色",
    ["Enabled"] = "已启用",
    ["Disabled"] = "已禁用",
    ["On"] = "开启",
    ["Off"] = "关闭",
    ["Normal"] = "普通",
    ["None"] = "无",
    ["Random"] = "随机",
    ["Health"] = "血量",
    ["Distance"] = "距离",
    ["Color"] = "颜色",
    ["Range"] = "范围",
    ["Speed"] = "速度",
    ["Delay"] = "延迟",
    ["Mode"] = "模式",
    ["Keybind"] = "快捷键",
    ["Bind"] = "绑定",
    ["Value"] = "数值",
    ["Enabled"] = "已启用",
    ["Disabled"] = "已禁用",
}

for k, v in pairs(Extra) do
    Translator[k] = v
end

-- 按长文本优先，避免短词先替换导致长词无法匹配。
local keys = {}
for k in pairs(Translator) do
    table.insert(keys, k)
end
table.sort(keys, function(a, b)
    return #a > #b
end)

local function escapePattern(s)
    return (s:gsub("([^%w])", "%%%1"))
end

local function translateText(text)
    if type(text) ~= "string" or text == "" then
        return text
    end

    local result = text

    -- 先处理完整文本。
    if Translator[result] then
        return Translator[result]
    end

    -- 再处理包含英文短语的文本。
    for _, english in ipairs(keys) do
        local chinese = Translator[english]
        if result:find(english, 1, true) then
            result = result:gsub(escapePattern(english), chinese)
        end
    end

    -- 单位
    result = result:gsub("(%d+%.?%d*)%s*[Ss]tuds?", "%1 格")
    result = result:gsub("(%d+%.?%d*)%s*[Dd]egrees?", "%1 度")
    result = result:gsub("(%d+%.?%d*)%s*[Ss]econds?", "%1 秒")

    return result
end

-- 只操作常见 GUI 文本对象。
local function translateObject(obj)
    if not obj or not obj:IsA("GuiObject") then
        return false
    end

    local changed = false

    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
        local old = obj.Text
        local new = translateText(old)

        if new ~= old then
            obj.Text = new
            changed = true
        end
    end

    return changed
end

local function scanRoot(root)
    if not root then
        return 0, 0
    end

    local objects = 0
    local changed = 0

    local ok, descendants = pcall(function()
        return root:GetDescendants()
    end)

    if not ok or not descendants then
        return 0, 0
    end

    for _, obj in ipairs(descendants) do
        if obj:IsA("GuiObject") then
            objects = objects + 1
            if translateObject(obj) then
                changed = changed + 1
            end
        end
    end

    return objects, changed
end

-- 尽量覆盖普通 GUI 与执行器隐藏 GUI。
local roots = {}
local seen = {}

local function addRoot(root, name)
    if typeof(root) ~= "Instance" then
        return
    end
    if seen[root] then
        return
    end

    seen[root] = true
    table.insert(roots, {
        instance = root,
        name = name or root.Name
    })
end

addRoot(CoreGui, "CoreGui")

pcall(function()
    addRoot(Players.LocalPlayer:WaitForChild("PlayerGui"), "PlayerGui")
end)

pcall(function()
    if type(gethui) == "function" then
        addRoot(gethui(), "gethui")
    end
end)

pcall(function()
    if type(get_hidden_gui) == "function" then
        addRoot(get_hidden_gui(), "get_hidden_gui")
    end
end)

-- 第一次扫描。
local totalObjects = 0
local totalChanged = 0
local AutoTranslate = true

for _, rootInfo in ipairs(roots) do
    local count, changed = scanRoot(rootInfo.instance)
    totalObjects = totalObjects + count
    totalChanged = totalChanged + changed
end

-- 周期扫描：处理 Vape 动态创建/刷新/改文字的情况。
task.spawn(function()
    while task.wait(1.5) do
        if AutoTranslate then
            for _, rootInfo in ipairs(roots) do
                pcall(function()
                    scanRoot(rootInfo.instance)
                end)
            end
        end
    end
end)

-- 监听 Text 属性变化。
-- 使用弱键表记录已经连接过的对象，不往 Vape 的 UI 实例写入额外 Attribute。
local watchedTextObjects = setmetatable({}, {__mode = "k"})

local function watchTextObject(obj)
    if not obj then
        return
    end

    if not (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then
        return
    end

    if watchedTextObjects[obj] then
        return
    end

    local ok, signal = pcall(function()
        return obj:GetPropertyChangedSignal("Text")
    end)

    if ok and signal then
        watchedTextObjects[obj] = true
        pcall(function()
            signal:Connect(function()
                task.defer(function()
                    if AutoTranslate then
                        translateObject(obj)
                    end
                end)
            end)
        end)
    end
end

for _, rootInfo in ipairs(roots) do
    pcall(function()
        for _, obj in ipairs(rootInfo.instance:GetDescendants()) do
            watchTextObject(obj)
        end
    end)
end

-- Vape 会动态创建/刷新 UI，因此新对象出现时立即翻译并挂监听。
for _, rootInfo in ipairs(roots) do
    pcall(function()
        rootInfo.instance.DescendantAdded:Connect(function(obj)
            task.defer(function()
                if AutoTranslate then
                    translateObject(obj)
                end
                watchTextObject(obj)
            end)
        end)
    end)
end


-- ============================================================
-- Rayfield UI
-- 作者：sevgranddad
-- Q群：1107177693
-- ============================================================

if Rayfield then
    pcall(function()
        local Window = Rayfield:CreateWindow({
            Name = "Vape 中文翻译器(持续更新)",
            Icon = 0,
            LoadingTitle = "Vape 中文翻译器",
            LoadingSubtitle = "by sevgranddad",
            ShowText = "Vape 中文翻译器",
            Theme = "Default",
            ToggleUIKeybind = "K",
            DisableRayfieldPrompts = true,
            DisableBuildWarnings = true,
            ConfigurationSaving = {
                Enabled = false
            }
        })

        local MainTab = Window:CreateTab("翻译", 0)

        MainTab:CreateParagraph({
            Title = "Vape V4 中文翻译器",
            Content = "作者：sevgranddad\nQ群：1107177693\n直接翻译 Vape 原有 GUI，不修改 Vape 功能逻辑。"
        })

        MainTab:CreateToggle({
            Name = "自动翻译",
            CurrentValue = true,
            Flag = "AutoTranslate",
            Callback = function(Value)
                AutoTranslate = Value
            end
        })

        MainTab:CreateButton({
            Name = "立即扫描并翻译",
            Callback = function()
                local count = 0
                local changed = 0

                for _, rootInfo in ipairs(roots) do
                    local a, b = scanRoot(rootInfo.instance)
                    count = count + a
                    changed = changed + b
                end

                Rayfield:Notify({
                    Title = "扫描完成",
                    Content = ("扫描 %d 个 GUI 对象，翻译 %d 个文字对象。"):format(count, changed),
                    Duration = 4
                })
            end
        })

        MainTab:CreateButton({
            Name = "重新扫描 GUI",
            Callback = function()
                roots = {}
                seen = {}

                addRoot(CoreGui, "CoreGui")

                pcall(function()
                    addRoot(Players.LocalPlayer:WaitForChild("PlayerGui"), "PlayerGui")
                end)

                pcall(function()
                    if type(gethui) == "function" then
                        addRoot(gethui(), "gethui")
                    end
                end)

                pcall(function()
                    if type(get_hidden_gui) == "function" then
                        addRoot(get_hidden_gui(), "get_hidden_gui")
                    end
                end)

                for _, rootInfo in ipairs(roots) do
                    pcall(function()
                        for _, obj in ipairs(rootInfo.instance:GetDescendants()) do
                            watchTextObject(obj)
                        end
                    end)
                end

                Rayfield:Notify({
                    Title = "GUI 已重新扫描",
                    Content = "已重新建立 GUI 扫描目标。",
                    Duration = 3
                })
            end
        })

        MainTab:CreateSection("关于")

        MainTab:CreateLabel("作者：sevgranddad")
        MainTab:CreateLabel("Q群：1107177693")
        MainTab:CreateLabel("翻译范围：Vape V4 主界面 / 模块 / 设置 / 视觉模块")

        Rayfield:Notify({
            Title = "Vape 中文翻译器",
            Content = "翻译器已启动 · 作者 sevgranddad · Q群 1107177693",
            Duration = 5
        })
    end)
else
    warn("[VapeCN] Rayfield 加载失败，原地翻译功能仍会继续运行。")
end

-- 输出诊断信息，方便确认脚本是否真的执行。
warn("[VapeCN] Translator started")
warn("[VapeCN] GUI objects scanned:", totalObjects)
warn("[VapeCN] Text objects changed:", totalChanged)

for _, rootInfo in ipairs(roots) do
    warn("[VapeCN] Root:", rootInfo.name, rootInfo.instance:GetFullName())
end

-- 如果执行器支持 getgenv，就暴露手动重扫函数。
pcall(function()
    if type(getgenv) == "function" then
        getgenv().VapeCN_Rescan = function()
            local count = 0
            local changed = 0

            for _, rootInfo in ipairs(roots) do
                local a, b = scanRoot(rootInfo.instance)
                count = count + a
                changed = changed + b
            end

            warn("[VapeCN] Manual rescan:", count, "objects,", changed, "changed")
            return count, changed
        end

        getgenv().VapeCN_TranslateText = translateText
    end
end)
