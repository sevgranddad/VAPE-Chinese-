--[[
    Vape V4 Chinese Translator
    Version 4.0
    Independent GUI translator - does NOT modify Vape core files.

    V4 goals:
    1. Module names
    2. Setting names
    3. Setting values
    4. Structured text such as "Target: Players, NPCs"
    5. Dynamic values/numbers/player names/keybinds/colors
    6. Tooltips/descriptions
    7. Dynamically-created Vape GUI elements
    8. Safe re-translation without Chinese -> Chinese -> Chinese corruption
]]

--==================================================
-- WindUI
--==================================================

local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

--==================================================
-- Configuration
--==================================================

local AutoTranslate = true
local DebugMode = false
local ScanInterval = 0.50
local TranslatedObjects = setmetatable({}, {__mode = "k"})
local Connections = {}
local LastScanCount = 0

--==================================================
-- 1. Vape module/category dictionary
--==================================================

local Exact = {
    -- Categories
    ["Combat"] = "战斗",
    ["Blatant"] = "明显功能",
    ["Render"] = "渲染",
    ["Utility"] = "实用工具",
    ["World"] = "世界",
    ["Inventory"] = "物品栏",
    ["Misc"] = "杂项",
    ["MISC"] = "杂项",

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

    -- Misc / visual
    ["Friends"] = "好友",
    ["Profiles"] = "配置文件",
    ["Targets"] = "目标设置",
    ["Text GUI"] = "功能列表显示菜单",
    ["Target Info"] = "攻击目标显示",
    ["Radar"] = "雷达",
    ["Session Info"] = "当前对局信息",
    ["Spotify"] = "音乐插件",

    -- Search mods / HUD
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
    ["default"] = "默认",
    ["Default"] = "默认",
    ["Visual"] = "视觉",
    ["TextGUI"] = "功能列表显示菜单",
    ["TextGui"] = "功能列表显示菜单",
    ["TargetInfo"] = "攻击目标显示",
    ["SessionInfo"] = "当前对局信息",
    ["Speedmeter"] = "速度计",
    ["Anti-AFK"] = "防挂机",
    ["Murder Mystery"] = "谋杀之谜",
    ["NoClickDelay"] = "无点击延迟",
    ["Velocity"] = "击退控制",
    ["Sprint"] = "疾跑",
    ["WTap"] = "WTap",
    ["SilentAura"] = "静默光环",
    ["AutoArmor"] = "自动穿甲",
    ["AutoHeal"] = "自动治疗",
    ["InvCleaner"] = "物品栏清理",
}

--==================================================
-- 2. Setting names / labels
--==================================================

local Labels = {
    ["Target"] = "目标",
    ["Targets"] = "目标",
    ["Target Info"] = "攻击目标显示",
    ["Target Color"] = "目标颜色",
    ["Target Part"] = "目标部位",

    ["Player"] = "玩家",
    ["Players"] = "玩家",
    ["NPC"] = "NPC",
    ["NPCs"] = "NPC",
    ["Enemy"] = "敌人",
    ["Enemies"] = "敌人",
    ["Friends"] = "好友",
    ["Teams"] = "队伍",
    ["Team"] = "队伍",
    ["Team color"] = "队伍颜色",
    ["Use team color"] = "使用队伍颜色",
    ["Teams by server"] = "按服务器区分队伍",

    ["Ignore"] = "忽略",
    ["Ignore friends"] = "忽略好友",
    ["Ignore team"] = "忽略队伍",
    ["Ignored"] = "已忽略",
    ["Blacklist"] = "黑名单",
    ["Whitelist"] = "白名单",

    ["Mode"] = "模式",
    ["Type"] = "类型",
    ["Method"] = "方法",
    ["Part"] = "部位",
    ["Body Part"] = "身体部位",
    ["Priority"] = "优先级",
    ["Sort"] = "排序",

    ["Range"] = "范围",
    ["Attack range"] = "攻击范围",
    ["Swing range"] = "挥击范围",
    ["Reach"] = "攻击距离",
    ["Max range"] = "最大范围",
    ["Min range"] = "最小范围",

    ["FOV"] = "视野范围",
    ["Max angle"] = "最大角度",
    ["Angle"] = "角度",
    ["Field of View"] = "视野范围",
    ["Range Circle"] = "范围圆",
    ["Circle Color"] = "圆圈颜色",
    ["Circle Filled"] = "填充圆圈",

    ["Speed"] = "速度",
    ["WalkSpeed"] = "移动速度",
    ["JumpPower"] = "跳跃力度",
    ["Gravity"] = "重力",

    ["Attacks per Second"] = "每秒攻击次数",
    ["Max targets"] = "最大目标数",
    ["Max Target"] = "最大目标数",
    ["Target Count"] = "目标数量",
    ["Hit Chance"] = "命中概率",
    ["Headshot Chance"] = "爆头概率",
    ["Chance"] = "概率",

    ["Require mouse down"] = "需要按住鼠标",
    ["Require right click"] = "需要按住右键",
    ["Sword lunge only"] = "仅剑类攻击",
    ["Show target"] = "显示目标",
    ["Show target info"] = "显示目标信息",

    ["Color"] = "颜色",
    ["Outline Color"] = "轮廓颜色",
    ["Fill Color"] = "填充颜色",
    ["Transparency"] = "透明度",
    ["Opacity"] = "不透明度",
    ["Thickness"] = "厚度",
    ["Size"] = "大小",
    ["Width"] = "宽度",
    ["Height"] = "高度",

    ["Health"] = "生命值",
    ["Armor"] = "护甲",
    ["Distance"] = "距离",
    ["Name"] = "名称",
    ["Display Name"] = "显示名称",

    ["Enabled"] = "已启用",
    ["Disabled"] = "已禁用",
    ["Enable"] = "启用",
    ["Disable"] = "禁用",
    ["Default"] = "默认",
    ["Value"] = "数值",
    ["Min"] = "最小值",
    ["Max"] = "最大值",

    ["Delay"] = "延迟",
    ["Next Shot Delay"] = "下一次射击延迟",
    ["Shoot Delay"] = "射击延迟",
    ["Messages delay"] = "消息间隔",
    ["Update rate"] = "刷新率",
    ["Rainbow update rate"] = "彩虹刷新率",
    ["Rainbow speed"] = "彩虹动画速度",

    ["Origin"] = "起点",
    ["Offset"] = "偏移",
    ["Position"] = "位置",
    ["Rotation"] = "旋转",
    ["Method"] = "方法",
    ["Raycast Type"] = "射线检测类型",
    ["Raycast"] = "射线检测",
    ["Ignored Scripts"] = "忽略脚本",
    ["Function hook"] = "函数钩子",
    ["Oth hook"] = "备用钩子",
    ["Wallbang"] = "穿墙攻击",

    ["Search"] = "搜索",
    ["Search bar style"] = "搜索栏样式",
    ["Message"] = "消息",
    ["Keybind"] = "快捷键",
    ["Bind"] = "按键",
    ["Key"] = "按键",
    ["Tooltip"] = "提示",
    ["Description"] = "说明",
    ["Visible"] = "可见",

    ["Tool"] = "工具",
    ["Click"] = "左键",
    ["RightClick"] = "右键",
    ["Mouse"] = "鼠标",
    ["Camera"] = "摄像机",

    -- GUI
    ["Blur background"] = "背景模糊",
    ["GUI bind indicator"] = "界面快捷键指示器",
    ["Show tooltips"] = "显示提示信息",
    ["Show legit mode"] = "显示低调模式",
    ["Auto rescale"] = "自动缩放",
    ["Reset GUI positions"] = "重置界面位置",
    ["Sort GUI"] = "界面自动排序",
    ["Rainbow Mode - Normal"] = "彩虹模式 - 普通",

    -- Notifications
    ["Notifications"] = "通知总开关",
    ["Toggle alert"] = "开关模块提醒",
    ["Setting toggle alert"] = "修改设置提醒",

    -- General
    ["Enable Multi-Keybinding"] = "启用多按键绑定",
    ["Allow setting keybinds"] = "允许设置快捷键",
    ["Reset current profile"] = "重置当前配置文件",
    ["Self destruct"] = "自毁",
    ["Reinject"] = "重新注入",
}

--==================================================
-- 3. Common values
--==================================================

local Values = {
    ["None"] = "无",
    ["All"] = "全部",
    ["Any"] = "任意",
    ["Players"] = "玩家",
    ["NPCs"] = "NPC",
    ["Player"] = "玩家",
    ["NPC"] = "NPC",
    ["Friends"] = "好友",
    ["Enemies"] = "敌人",
    ["Teams"] = "队伍",
    ["Team"] = "队伍",

    ["On"] = "开启",
    ["Off"] = "关闭",
    ["Enabled"] = "已启用",
    ["Disabled"] = "已禁用",
    ["True"] = "是",
    ["False"] = "否",
    ["Yes"] = "是",
    ["No"] = "否",

    ["Normal"] = "普通",
    ["Silent"] = "静默",
    ["Legit"] = "低调",
    ["Basic"] = "基础",
    ["Advanced"] = "高级",
    ["Default"] = "默认",
    ["Random"] = "随机",

    ["Include"] = "包含",
    ["Exclude"] = "排除",
    ["Whitelist"] = "白名单",
    ["Blacklist"] = "黑名单",

    ["Head"] = "头部",
    ["Torso"] = "躯干",
    ["RootPart"] = "根部",
    ["HumanoidRootPart"] = "角色根部",
    ["Body"] = "身体",

    ["Camera"] = "摄像机",
    ["Mouse"] = "鼠标",
    ["Position"] = "位置",
    ["Raycast"] = "射线检测",
    ["Ray"] = "射线",
    ["Outline"] = "轮廓",
    ["Box"] = "方框",
    ["Both"] = "两者",

    ["Second"] = "秒",
    ["Seconds"] = "秒",
    ["second"] = "秒",
    ["seconds"] = "秒",
    ["stud"] = "格",
    ["studs"] = "格",
    ["degree"] = "度",
    ["degrees"] = "度",
}

--==================================================
-- 4. Tooltips / descriptions
--==================================================

local Tooltips = {
    ["Smoothly aims to closest valid target"] = "平滑地瞄准最近的有效目标",
    ["Automatically clicks for you"] = "自动帮你点击",
    ["Extends tool attack reach"] = "延长工具的攻击距离",
    ["Silently adjusts your aim towards the enemy"] = "静默地将瞄准方向调整到敌人",
    ["Shoots people that enter your crosshair"] = "自动攻击进入准星的目标",
    ["Panic Disables all currently enabled modules"] = "紧急关闭当前所有已启用的模块",
    ["Delays packets, simulating lag"] = "延迟数据包，模拟网络延迟",
    ["Chokes packets until disabled"] = "持续阻塞数据包，直到关闭功能",
}

--==================================================
-- 5. Generic vocabulary
-- This is deliberately conservative. It is only used
-- after exact phrases and labels.
--==================================================

local Generic = {
    ["Current"] = "当前",
    ["Selected"] = "已选择",
    ["Select"] = "选择",
    ["Settings"] = "设置",
    ["Profile"] = "配置文件",
    ["Profiles"] = "配置文件",
    ["General"] = "通用",
    ["Modules"] = "模块",
    ["GUI"] = "界面",
    ["Theme"] = "主题",
    ["Notifications"] = "通知",
    ["Visual"] = "视觉",
    ["Render"] = "渲染",
    ["World"] = "世界",
    ["Utility"] = "实用工具",
    ["Inventory"] = "物品栏",
    ["Combat"] = "战斗",
    ["Blatant"] = "明显功能",
    ["Misc"] = "杂项",
    ["None"] = "无",
    ["Unknown"] = "未知",
    ["Loading"] = "加载中",
    ["Loaded"] = "已加载",
    ["Failed"] = "失败",
    ["Success"] = "成功",
    ["Error"] = "错误",
    ["Distance"] = "距离",
    ["Health"] = "生命值",
    ["Armor"] = "护甲",
    ["Name"] = "名称",
    ["Color"] = "颜色",
    ["Mode"] = "模式",
    ["Type"] = "类型",
    ["Value"] = "数值",
    ["Delay"] = "延迟",
    ["Speed"] = "速度",
    ["Range"] = "范围",
    ["Target"] = "目标",
    ["Targets"] = "目标",
    ["Player"] = "玩家",
    ["Players"] = "玩家",
    ["Enemy"] = "敌人",
    ["Enemies"] = "敌人",
    ["Ignore"] = "忽略",
    ["Friends"] = "好友",
    ["Team"] = "队伍",
    ["Teams"] = "队伍",
    ["Color"] = "颜色",
    ["Visible"] = "可见",
    ["Show"] = "显示",
    ["Hide"] = "隐藏",
    ["Enable"] = "启用",
    ["Disable"] = "禁用",
    ["Enabled"] = "已启用",
    ["Disabled"] = "已禁用",
}

--==================================================
-- Utilities
--==================================================

local function trim(text)
    return tostring(text):gsub("^%s+", ""):gsub("%s+$", "")
end

local function normalizeText(text)
    text = tostring(text or "")
    text = text:gsub("%s+", " ")
    return trim(text)
end

local function hasChinese(text)
    return tostring(text):match("[\228-\233]") ~= nil
end

local function escapePattern(text)
    return tostring(text):gsub("([^%w])", "%%%1")
end

local function replacePlain(text, from, to)
    return string.gsub(text, escapePattern(from), to)
end

local function isLikelyDynamicToken(token)
    token = trim(token)

    if token == "" then
        return true
    end

    -- Numbers / decimals / percentages
    if token:match("^%-?%d+%.?%d*%%?$") then
        return true
    end

    -- Roblox key names / key combinations
    if token:match("^[A-Z][A-Z0-9_]*$") and #token <= 8 then
        return true
    end

    -- Hex colors
    if token:match("^#%x%x%x%x%x%x$") then
        return true
    end

    return false
end

--==================================================
-- Structured-value translation
--==================================================

local function translateValueToken(token)
    local clean = trim(token)

    if isLikelyDynamicToken(clean) then
        return clean
    end

    if Values[clean] then
        return Values[clean]
    end

    if Labels[clean] then
        return Labels[clean]
    end

    if Generic[clean] then
        return Generic[clean]
    end

    return clean
end

local function translateList(text)
    local parts = {}
    for item in tostring(text):gmatch("[^,;]+") do
        table.insert(parts, translateValueToken(item))
    end

    if #parts > 1 then
        return table.concat(parts, "、")
    end

    return nil
end

--==================================================
-- Label: Value parser
-- Handles:
--   Target: Players, NPCs
--   Ignore: None
--   Attacks per Second: 20
--   Target Color: #ffffff
--==================================================

local function translateColonExpression(text)
    local label, value = tostring(text):match("^%s*(.-)%s*:%s*(.-)%s*$")

    if not label or not value then
        return nil
    end

    local translatedLabel =
        Exact[label]
        or Labels[label]
        or Generic[label]
        or label

    -- A purely numeric/dynamic value stays untouched.
    if isLikelyDynamicToken(value) then
        return translatedLabel .. "：" .. value
    end

    -- Lists such as Players, NPCs / Friends, Enemies
    local list = translateList(value)
    if list then
        return translatedLabel .. "：" .. list
    end

    local translatedValue =
        Values[value]
        or Labels[value]
        or Generic[value]
        or value

    return translatedLabel .. "：" .. translatedValue
end

--==================================================
-- Unit-aware translation
--==================================================

local function translateUnits(text)
    local result = text

    result = result:gsub("(%-?%d+%.?%d*)%s*studs?", "%1 格")
    result = result:gsub("(%-?%d+%.?%d*)%s*degrees?", "%1 度")
    result = result:gsub("(%-?%d+%.?%d*)%s*seconds?", "%1 秒")
    result = result:gsub("(%-?%d+%.?%d*)%s*second", "%1 秒")

    return result
end

--==================================================
-- Phrase replacement
-- Long phrases first.
--==================================================

local Replacements = {
    {"Attacks per Second", "每秒攻击次数"},
    {"Require mouse down", "需要按住鼠标"},
    {"Require right click", "需要按住右键"},
    {"Sword lunge only", "仅剑类攻击"},
    {"Show target info", "显示目标信息"},
    {"Target Color", "目标颜色"},
    {"Next Shot Delay", "下一次射击延迟"},
    {"Raycast Type", "射线检测类型"},
    {"Ignored Scripts", "忽略脚本"},
    {"Teams by server", "按服务器区分队伍"},
    {"Use team color", "使用队伍颜色"},
    {"Setting toggle alert", "修改设置提醒"},
    {"Enable Multi-Keybinding", "启用多按键绑定"},
    {"Allow setting keybinds", "允许设置快捷键"},
    {"Reset current profile", "重置当前配置文件"},
    {"Rebind GUI", "重新绑定界面快捷键"},
    {"Blur background", "背景模糊"},
    {"GUI bind indicator", "界面快捷键指示器"},
    {"Show tooltips", "显示提示信息"},
    {"Show legit mode", "显示低调模式"},
    {"Auto rescale", "自动缩放"},
    {"Rainbow update rate", "彩虹刷新率"},
    {"Rainbow speed", "彩虹动画速度"},
    {"Search bar style", "搜索栏样式"},
    {"Reset GUI positions", "重置界面位置"},
    {"Sort GUI", "界面自动排序"},
    {"Toggle alert", "开关模块提醒"},
    {"Target Info", "攻击目标显示"},
    {"Session Info", "当前对局信息"},
    {"Time Changer", "时间修改"},
    {"Attack range", "攻击范围"},
    {"Swing range", "挥击范围"},
    {"Max targets", "最大目标数"},
    {"Max Target", "最大目标数"},
    {"Max angle", "最大角度"},
    {"Show target", "显示目标"},
    {"Ignore friends", "忽略好友"},
    {"Through Walls", "穿墙"},
    {"Hit Chance", "命中概率"},
    {"Headshot Chance", "爆头概率"},
    {"Range Circle", "范围圆"},
    {"Circle Color", "圆圈颜色"},
    {"Circle Filled", "填充圆圈"},
    {"Function hook", "函数钩子"},
    {"Oth hook", "备用钩子"},
    {"Shoot Delay", "射击延迟"},
    {"AutoFire", "自动开火"},
    {"Wallbang", "穿墙攻击"},
    {"HumanoidRootPart", "角色根部"},
    {"RootPart", "根部"},
    {"Search mods", "搜索模块"},
    {"Rainbow Mode - Normal", "彩虹模式 - 普通"},
    {"Murder Mystery", "谋杀之谜"},
    {"Anti-AFK", "防挂机"},
    {"FastProxPrompt", "快速交互提示"},
}

local function translateCommon(text)
    local result = tostring(text)

    for _, pair in ipairs(Replacements) do
        result = replacePlain(result, pair[1], pair[2])
    end

    result = translateUnits(result)

    -- Conservative standalone replacements.
    -- Do not globally replace short fragments before phrases.
    local standalone = {
        {"NPCs", "NPC"},
        {"Players", "玩家"},
        {"Player", "玩家"},
        {"Enemies", "敌人"},
        {"Enemy", "敌人"},
        {"Friends", "好友"},
        {"None", "无"},
        {"Normal", "普通"},
        {"Default", "默认"},
        {"Enabled", "已启用"},
        {"Disabled", "已禁用"},
        {"Through Walls", "穿墙"},
        {"Walls", "墙体"},
        {"Color", "颜色"},
        {"Speed", "速度"},
        {"Delay", "延迟"},
        {"Range", "范围"},
        {"Target", "目标"},
        {"Targets", "目标"},
        {"Mode", "模式"},
        {"Part", "部位"},
        {"Chance", "概率"},
        {"Value", "数值"},
        {"Min", "最小值"},
        {"Max", "最大值"},
        {"Size", "大小"},
        {"Width", "宽度"},
        {"Height", "高度"},
        {"Health", "生命值"},
        {"Armor", "护甲"},
        {"Position", "位置"},
        {"Offset", "偏移"},
        {"Origin", "起点"},
        {"Method", "方法"},
        {"Search", "搜索"},
        {"Message", "消息"},
        {"Keybind", "快捷键"},
        {"Tooltip", "提示"},
        {"Description", "说明"},
        {"Visible", "可见"},
        {"Show", "显示"},
        {"Hide", "隐藏"},
    }

    for _, pair in ipairs(standalone) do
        result = replacePlain(result, pair[1], pair[2])
    end

    return result
end

--==================================================
-- Main translator
--==================================================

local function TranslateText(text)
    if text == nil then
        return text
    end

    text = normalizeText(text)

    if text == "" then
        return text
    end

    -- Exact phrase has the highest priority.
    if Exact[text] then
        return Exact[text]
    end

    if Labels[text] then
        return Labels[text]
    end

    if Values[text] then
        return Values[text]
    end

    if Tooltips[text] then
        return Tooltips[text]
    end

    -- Structured label/value expressions.
    local structured = translateColonExpression(text)
    if structured then
        return structured
    end

    -- Common phrases + units.
    local result = translateCommon(text)

    -- Keep already-translated Chinese stable.
    -- If the result did not change and it already contains Chinese,
    -- don't attempt increasingly aggressive replacements.
    if result == text and hasChinese(text) then
        return text
    end

    return result
end

--==================================================
-- GUI object helpers
--==================================================

local function isTextObject(object)
    return object:IsA("TextLabel")
        or object:IsA("TextButton")
        or object:IsA("TextBox")
end

local function remember(object, source, translated)
    TranslatedObjects[object] = {
        source = source,
        translated = translated,
        changedAt = os.clock(),
    }
end

local attachTextWatcher

local function TranslateObject(object)
    if not object or not object.Parent or not isTextObject(object) then
        return false
    end

    attachTextWatcher(object)

    local current = object.Text

    if not current or current == "" then
        return false
    end

    local state = TranslatedObjects[object]

    -- If Vape changed the text after our translation, current is new source text.
    -- If current is exactly our previous translation, recover the original source.
    local sourceText = current

    if state and state.translated == current then
        sourceText = state.source
    end

    local translated = TranslateText(sourceText)

    remember(object, sourceText, translated)

    if translated ~= current then
        object.Text = translated
        return true
    end

    return false
end

local function ScanGUI()
    local count = 0

    for _, object in ipairs(game:GetDescendants()) do
        if isTextObject(object) then
            if TranslateObject(object) then
                count += 1
            end
        end
    end

    LastScanCount = count
    return count
end

--==================================================
-- Dynamic GUI watcher
--==================================================

attachTextWatcher = function(object)
    if not object or not isTextObject(object) then
        return
    end

    if Connections[object] then
        return
    end

    local ok, connection = pcall(function()
        return object:GetPropertyChangedSignal("Text"):Connect(function()
            if AutoTranslate and object.Parent then
                task.defer(function()
                    TranslateObject(object)
                end)
            end
        end)
    end)

    if ok and connection then
        Connections[object] = connection
    end
end

local function ScanSubtree(root)
    if not root then
        return 0
    end

    local count = 0

    if isTextObject(root) then
        attachTextWatcher(root)
        if TranslateObject(root) then
            count += 1
        end
    end

    for _, object in ipairs(root:GetDescendants()) do
        if isTextObject(object) then
            attachTextWatcher(object)
            if TranslateObject(object) then
                count += 1
            end
        end
    end

    return count
end

local function ScanGUI()
    local count = 0

    for _, object in ipairs(game:GetDescendants()) do
        if isTextObject(object) then
            attachTextWatcher(object)
            if TranslateObject(object) then
                count += 1
            end
        end
    end

    LastScanCount = count
    return count
end

local function StartAutoTranslator()
    if Connections.DescendantAdded then
        Connections.DescendantAdded:Disconnect()
    end

    Connections.DescendantAdded = game.DescendantAdded:Connect(function(object)
        if not AutoTranslate then
            return
        end

        task.spawn(function()
            -- Vape can construct a parent first and its text children later.
            -- Retry several times so late-created GUI elements are caught.
            for _, delayTime in ipairs({0, 0.08, 0.25, 0.75, 1.5}) do
                if delayTime > 0 then
                    task.wait(delayTime)
                end
                if object and object.Parent then
                    pcall(function()
                        ScanSubtree(object)
                    end)
                end
            end
        end)
    end)

    if Connections.TextWatcherLoop then
        task.cancel(Connections.TextWatcherLoop)
    end

    Connections.TextWatcherLoop = task.spawn(function()
        while true do
            task.wait(1.0)

            if AutoTranslate then
                -- Full rescans are intentional: Vape can mutate existing GUI
                -- objects without firing DescendantAdded.
                pcall(ScanGUI)
            end
        end
    end)
end

--==================================================
-- WindUI control panel
--==================================================

local Window = WindUI:CreateWindow({
    Title = "Vape 中文翻译器 由sevgranddad制作awa",
    Author = "Vape GUI Translator V4",
    Icon = "languages",
    Theme = "Dark",
    ToggleKey = Enum.KeyCode.RightControl,
})

local MainTab = Window:Tab({
    Title = "翻译器",
    Icon = "languages",
})

MainTab:Paragraph({
    Title = "成功加载：Vape 中文翻译器 V4",
    Content = "模块 + 设置 + 设置值 + 动态文本 + Tooltip",
})

MainTab:Toggle({
    Title = "自动翻译",
    Value = true,
    Callback = function(value)
        AutoTranslate = value

        if value then
            local count = ScanGUI()

            WindUI:Notify({
                Title = "自动翻译已开启",
                Content = "重新扫描并翻译了 " .. tostring(count) .. " 个文本",
                Duration = 3,
            })
        else
            WindUI:Notify({
                Title = "自动翻译已关闭",
                Content = "不会继续处理新出现的文本",
                Duration = 3,
            })
        end
    end,
})

MainTab:Button({
    Title = "扫描并翻译当前界面",
    Callback = function()
        local count = ScanGUI()

        WindUI:Notify({
            Title = "扫描完成",
            Content = "本次翻译了 " .. tostring(count) .. " 个文本",
            Duration = 3,
        })
    end,
})

MainTab:Button({
    Title = "测试动态设置翻译",
    Callback = function()
        local tests = {
            "Target: Players, NPCs",
            "Ignore: None",
            "Attacks per Second: 20",
            "Swing range 18 studs",
            "Attack range 21 studs",
            "Max angle 235",
            "Max targets 10",
            "Require mouse down",
            "Require right click",
            "Sword lunge only",
            "Show target",
            "Target Color",
            "Hit Chance: 75%",
            "Players, NPCs",
            "None",
            "18 studs",
            "90 degrees",
        }

        local output = {}

        for _, value in ipairs(tests) do
            table.insert(output, value .. " → " .. TranslateText(value))
        end

        WindUI:Notify({
            Title = "V4 翻译测试",
            Content = table.concat(output, "\n"),
            Duration = 10,
        })
    end,
})

MainTab:Button({
    Title = "重新启动动态监听",
    Callback = function()
        StartAutoTranslator()

        WindUI:Notify({
            Title = "动态监听已重启",
            Content = "现在会继续监听新增和变化的 GUI 文本",
            Duration = 3,
        })
    end,
})

MainTab:Toggle({
    Title = "调试模式",
    Value = false,
    Callback = function(value)
        DebugMode = value
    end,
})

MainTab:Paragraph({
    Title = "V4 处理顺序",
    Content = "精确词条 → 设置/值 → 结构化文本 → 常用术语 → 动态数值/单位",
})

--==================================================
-- Start
--==================================================

StartAutoTranslator()

task.wait(1)

local count = ScanGUI()

WindUI:Notify({
    Title = "Vape 中文翻译器 V4",
    Content = "已启动，首次翻译 " .. tostring(count) .. " 个文本",
    Duration = 5,
})
