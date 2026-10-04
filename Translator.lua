--[[
    VAPE V4 中文翻译器
    V5 - 从零重构版

    目标：
    1. 不修改 Vape 核心文件
    2. 只修改 GUI 可见文本
    3. 同时扫描 CoreGui / PlayerGui
    4. 支持动态创建 GUI
    5. 支持 Text / PlaceholderText
    6. 支持 RichText，尽量保留 <font> / <b> 等标签
    7. 先精确词条，再结构化设置，再通用词条
    8. 不修改 Instance.Name，避免破坏 Vape
    9. 记住原文，避免“中文 -> 中文”反复处理
]]

--==================================================
-- WindUI
--==================================================

local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

--==================================================
-- 配置
--==================================================

local Config = {
    AutoTranslate = true,
    Debug = false,
    ScanDelay = 0.10,
    FullScanInterval = 1.50,
}

local State = setmetatable({}, {__mode = "k"})
local TextConnections = setmetatable({}, {__mode = "k"})
local RootConnections = {}
local FullScanThread

--==================================================
-- 词库：用户提供的 Vape V4 对照表为第一优先级
--==================================================

local Exact = {
    -- 主分类
    ["Combat"] = "战斗",
    ["Blatant"] = "明显功能",
    ["Render"] = "渲染",
    ["Utility"] = "实用工具",
    ["World"] = "世界",
    ["Inventory"] = "物品栏",

    -- MISC
    ["MISC"] = "杂项",
    ["Misc"] = "杂项",
    ["Friends"] = "好友",
    ["Profiles"] = "配置文件",
    ["Profile"] = "配置文件",
    ["Targets"] = "目标设置",

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
    ["KillAura"] = "杀戮光环",
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
    ["Nametags"] = "玩家名字标签",
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
    ["Murder Mystery"] = "谋杀之谜",
    ["Parkour"] = "跑酷辅助",
    ["SafeWalk"] = "安全行走",
    ["Wallhop"] = "墙体跳跃",
    ["Xray"] = "X光透视",

    -- 底部视觉模块
    ["Text GUI"] = "功能列表显示菜单",
    ["TextGUI"] = "功能列表显示菜单",
    ["TextGui"] = "功能列表显示菜单",
    ["Target Info"] = "攻击目标显示",
    ["TargetInfo"] = "攻击目标显示",
    ["Radar"] = "雷达",
    ["Session Info"] = "当前对局信息",
    ["SessionInfo"] = "当前对局信息",
    ["Spotify"] = "音乐插件",

    -- Search mods / Legit
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
    ["TimeChanger"] = "时间修改",

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
    ["Rainbow Mode - Normal"] = "彩虹模式 - 普通",
    ["Reset GUI positions"] = "重置界面位置",
    ["Sort GUI"] = "界面自动排序",

    -- Notifications
    ["Toggle alert"] = "开关模块提醒",
    ["Setting toggle alert"] = "修改设置提醒",

    -- 常见额外模块（用于不同 Vape 构建）
    ["NoClickDelay"] = "无点击延迟",
    ["Velocity"] = "击退控制",
    ["Sprint"] = "疾跑",
    ["TargetStrafe"] = "围绕目标旋转",
    ["Timer"] = "时间修改",
    ["Scaffold"] = "自动搭路",
    ["NoFall"] = "防坠落",
    ["NoSlowdown"] = "防减速",
    ["InfiniteFly"] = "无限飞行",
    ["Block-In"] = "自动围墙",
    ["AntiFireball"] = "防火球",
    ["InventoryManager"] = "物品栏管理",
    ["ArmorSwitch"] = "切换护甲",
    ["AutoArmor"] = "自动装备护甲",
    ["AutoHeal"] = "自动治疗",
    ["InvCleaner"] = "物品栏清理",
    ["AutoBuy"] = "自动购买",
    ["AutoConsume"] = "自动使用",
    ["AutoHotbar"] = "自动整理快捷栏",
    ["FastConsume"] = "快速使用",
    ["FastDrop"] = "快速丢弃",
    ["DamageIndicator"] = "伤害指示器",
    ["FPSBoost"] = "帧率优化",
    ["HitColor"] = "受击颜色",
    ["HitFix"] = "命中修复",
    ["Interface"] = "界面",
    ["KillEffect"] = "击杀特效",
    ["ReachDisplay"] = "攻击距离显示",
    ["Viewmodel"] = "第一人称模型",
    ["Potion Status"] = "药水状态",
    ["Armor Status"] = "护甲状态",
    ["Compass"] = "指南针",
    ["Coords"] = "坐标",
    ["Inventory Blur"] = "物品栏背景模糊",
    ["Clear Water"] = "水下清晰",
    ["UICleanup"] = "界面清理",
}

--==================================================
-- 设置标签
--==================================================

local Labels = {
    ["Target"] = "目标",
    ["Targets"] = "目标",
    ["Target Color"] = "目标颜色",
    ["Target Part"] = "目标部位",
    ["Target Part"] = "目标部位",

    ["Player"] = "玩家",
    ["Players"] = "玩家",
    ["NPC"] = "NPC",
    ["NPCs"] = "NPC",
    ["Enemy"] = "敌人",
    ["Enemies"] = "敌人",
    ["Friend"] = "好友",
    ["Friends"] = "好友",
    ["Team"] = "队伍",
    ["Teams"] = "队伍",
    ["Team color"] = "队伍颜色",
    ["Use team color"] = "使用队伍颜色",
    ["Teams by server"] = "按服务器区分队伍",

    ["Ignore"] = "忽略",
    ["Ignore friends"] = "忽略好友",
    ["Ignore team"] = "忽略队伍",
    ["Ignored"] = "已忽略",
    ["Whitelist"] = "白名单",
    ["Blacklist"] = "黑名单",

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
    ["Field of View"] = "视野范围",
    ["Max angle"] = "最大角度",
    ["Angle"] = "角度",
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
    ["Player Color"] = "玩家颜色",
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
    ["Value"] = "数值",
    ["Min"] = "最小值",
    ["Max"] = "最大值",
    ["Default"] = "默认",

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
    ["Show"] = "显示",
    ["Hide"] = "隐藏",

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

    -- General
    ["Enable Multi-Keybinding"] = "启用多按键绑定",
    ["Allow setting keybinds"] = "允许设置快捷键",
    ["Reset current profile"] = "重置当前配置文件",
    ["Self destruct"] = "自毁",
    ["Reinject"] = "重新注入",
}

--==================================================
-- 值
--==================================================

local Values = {
    ["None"] = "无",
    ["All"] = "全部",
    ["Any"] = "任意",
    ["Players"] = "玩家",
    ["Player"] = "玩家",
    ["NPCs"] = "NPC",
    ["NPC"] = "NPC",
    ["Friends"] = "好友",
    ["Enemies"] = "敌人",
    ["Enemy"] = "敌人",
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
}

--==================================================
-- Tooltip
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
    ["Draws arrows on screen when entities\nare out of your field of view."] = "当目标离开视野时，在屏幕上显示方向箭头。",
    ["Renders an ESP on players."] = "在玩家身上显示透视信息。",
    ["Renders tracers on players."] = "在玩家身上显示连线。",
    ["Displays your health in the center of your screen."] = "在屏幕中央显示你的生命值。",
}

--==================================================
-- 通用词
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
    ["Visible"] = "可见",
    ["Show"] = "显示",
    ["Hide"] = "隐藏",
    ["Enable"] = "启用",
    ["Disable"] = "禁用",
    ["Enabled"] = "已启用",
    ["Disabled"] = "已禁用",
}

--==================================================
-- 工具函数
--==================================================

local function trim(s)
    return tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function normalize(s)
    s = tostring(s or "")
    s = s:gsub("\r\n", "\n")
    s = s:gsub("[ \t]+", " ")
    s = s:gsub(" *\n *", "\n")
    return trim(s)
end

local function hasChinese(s)
    -- UTF-8 中文字符的字节范围
    return tostring(s):match("[\228-\233]") ~= nil
end

local function escapePattern(s)
    return tostring(s):gsub("([^%w])", "%%%1")
end

local function plainReplace(text, from, to)
    return (string.gsub(text, escapePattern(from), to))
end

local function looksDynamic(token)
    token = trim(token)
    if token == "" then
        return true
    end

    if token:match("^%-?%d+%.?%d*%%?$") then
        return true
    end

    if token:match("^#%x%x%x%x%x%x$") then
        return true
    end

    -- Roblox 按键 / 键位，例如 LEFTSHIFT、F、MB2
    if token:match("^[A-Z][A-Z0-9_]*$") and #token <= 12 then
        return true
    end

    return false
end

local function translateToken(token)
    local t = trim(token)

    if looksDynamic(t) then
        return t
    end

    return Exact[t] or Labels[t] or Values[t] or Generic[t] or t
end

local function translateList(value)
    local parts = {}
    for item in tostring(value):gmatch("[^,;]+") do
        table.insert(parts, translateToken(item))
    end

    if #parts > 1 then
        return table.concat(parts, "、")
    end

    return nil
end

--==================================================
-- RichText：保留标签，只翻译可见文字
--==================================================

local function translateRichText(text)
    local pieces = {}
    local cursor = 1

    while true do
        local a, b = tostring(text):find("<[^>]->", cursor)

        if not a then
            table.insert(pieces, tostring(text):sub(cursor))
            break
        end

        table.insert(pieces, tostring(text):sub(cursor, a - 1))
        table.insert(pieces, tostring(text):sub(a, b))
        cursor = b + 1
    end

    for i = 1, #pieces do
        if not pieces[i]:match("^<[^>]->$") then
            pieces[i] = translatePlainText(pieces[i])
        end
    end

    return table.concat(pieces)
end

--==================================================
-- 结构化设置：
-- Target: Players, NPCs
-- Ignore: None
-- Attacks per Second: 20
--==================================================

function translateStructured(text)
    local label, value = tostring(text):match("^%s*(.-)%s*:%s*(.-)%s*$")

    if not label or not value then
        return nil
    end

    local translatedLabel =
        Exact[label]
        or Labels[label]
        or Generic[label]
        or label

    value = trim(value)

    if looksDynamic(value) then
        return translatedLabel .. "：" .. value
    end

    local list = translateList(value)
    if list then
        return translatedLabel .. "：" .. list
    end

    return translatedLabel .. "：" .. translateToken(value)
end

--==================================================
-- 带单位文本
--==================================================

function translateUnits(text)
    local result = text

    result = result:gsub("(%-?%d+%.?%d*)%s*studs?", "%1 格")
    result = result:gsub("(%-?%d+%.?%d*)%s*degrees?", "%1 度")
    result = result:gsub("(%-?%d+%.?%d*)%s*seconds?", "%1 秒")
    result = result:gsub("(%-?%d+%.?%d*)%s*second", "%1 秒")

    return result
end

--==================================================
-- 长短语：长的必须先处理
--==================================================

local Phrases = {
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
    {"TimeChanger", "时间修改"},
    {"Attack range", "攻击范围"},
    {"Swing range", "挥击范围"},
    {"Max targets", "最大目标数"},
    {"Max Target", "最大目标数"},
    {"Max angle", "最大角度"},
    {"Show target", "显示目标"},
    {"Ignore friends", "忽略好友"},
    {"Hit Chance", "命中概率"},
    {"Headshot Chance", "爆头概率"},
    {"Range Circle", "范围圆"},
    {"Circle Color", "圆圈颜色"},
    {"Circle Filled", "填充圆圈"},
    {"Function hook", "函数钩子"},
    {"Shoot Delay", "射击延迟"},
    {"Auto send", "自动发送"},
    {"Send threshold", "发送阈值"},
    {"Through Walls", "穿墙"},
    {"Search mods", "搜索模块"},
    {"Rainbow Mode - Normal", "彩虹模式 - 普通"},
    {"Murder Mystery", "谋杀之谜"},
    {"FastProxPrompt", "快速交互提示"},
    {"Anti-AFK", "防挂机"},
}

local function translatePlainText(text)
    local result = tostring(text)

    for _, pair in ipairs(Phrases) do
        result = plainReplace(result, pair[1], pair[2])
    end

    result = translateUnits(result)

    -- 单词级替换。
    -- 这里只处理常见设置词，不修改 Instance.Name。
    local words = {
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
        {"Yes", "是"},
        {"No", "否"},
    }

    for _, pair in ipairs(words) do
        result = plainReplace(result, pair[1], pair[2])
    end

    return result
end

--==================================================
-- 主翻译函数
--==================================================

function TranslateText(text)
    if text == nil then
        return text
    end

    local original = tostring(text)

    if original == "" then
        return original
    end

    local normalized = normalize(original)

    -- 完整词条优先
    if Exact[normalized] then
        return Exact[normalized]
    end

    if Labels[normalized] then
        return Labels[normalized]
    end

    if Values[normalized] then
        return Values[normalized]
    end

    if Tooltips[normalized] then
        return Tooltips[normalized]
    end

    -- RichText
    if normalized:find("<") and normalized:find(">") then
        return translateRichText(normalized)
    end

    -- label: value
    local structured = translateStructured(normalized)
    if structured then
        return structured
    end

    local result = translatePlainText(normalized)

    if result == normalized and hasChinese(normalized) then
        return normalized
    end

    return result
end

--==================================================
-- GUI 对象
--==================================================

local function isTextObject(obj)
    return obj
        and (
            obj:IsA("TextLabel")
            or obj:IsA("TextButton")
            or obj:IsA("TextBox")
        )
end

local function saveState(obj, source, translated, propertyName)
    State[obj] = {
        source = source,
        translated = translated,
        property = propertyName,
    }
end

local function translateProperty(obj, propertyName)
    if not obj or not obj.Parent then
        return false
    end

    local current
    local ok = pcall(function()
        current = obj[propertyName]
    end)

    if not ok or type(current) ~= "string" or current == "" then
        return false
    end

    local state = State[obj]

    local source = current

    -- 如果当前内容就是我们上一次写进去的中文，
    -- 恢复 state.source，防止二次翻译。
    if state
        and state.property == propertyName
        and state.translated == current then
        source = state.source
    end

    local translated = TranslateText(source)

    saveState(obj, source, translated, propertyName)

    if translated ~= current then
        local writeOk = pcall(function()
            obj[propertyName] = translated
        end)

        return writeOk and true or false
    end

    return false
end

local function attachWatcher(obj)
    if not isTextObject(obj) then
        return
    end

    if TextConnections[obj] then
        return
    end

    local connections = {}

    local function hook(propertyName)
        local ok, conn = pcall(function()
            return obj:GetPropertyChangedSignal(propertyName):Connect(function()
                if not Config.AutoTranslate then
                    return
                end

                task.defer(function()
                    if obj.Parent then
                        translateProperty(obj, propertyName)
                    end
                end)
            end)
        end)

        if ok and conn then
            table.insert(connections, conn)
        end
    end

    hook("Text")

    if obj:IsA("TextBox") then
        hook("PlaceholderText")
    end

    TextConnections[obj] = connections
end

local function scanObject(obj)
    if not obj then
        return 0
    end

    local count = 0

    if isTextObject(obj) then
        attachWatcher(obj)

        if translateProperty(obj, "Text") then
            count += 1
        end

        if obj:IsA("TextBox") then
            if translateProperty(obj, "PlaceholderText") then
                count += 1
            end
        end
    end

    return count
end

local function scanTree(root)
    if not root then
        return 0
    end

    local count = scanObject(root)

    local descendants = {}
    pcall(function()
        descendants = root:GetDescendants()
    end)

    for _, obj in ipairs(descendants) do
        count += scanObject(obj)
    end

    return count
end

--==================================================
-- 只扫真正可能承载 Vape GUI 的容器
--==================================================

local function getRoots()
    local roots = {}

    local okCore, core = pcall(function()
        return game:GetService("CoreGui")
    end)

    if okCore and core then
        table.insert(roots, core)
    end

    local okPlayers, players = pcall(function()
        return game:GetService("Players")
    end)

    if okPlayers and players and players.LocalPlayer then
        local pg = players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if pg then
            table.insert(roots, pg)
        end
    end

    return roots
end

local function fullScan()
    if not Config.AutoTranslate then
        return 0
    end

    local total = 0

    for _, root in ipairs(getRoots()) do
        total += scanTree(root)
    end

    return total
end

--==================================================
-- 动态监听
--==================================================

local function stopDynamic()
    for _, conn in pairs(RootConnections) do
        pcall(function()
            conn:Disconnect()
        end)
    end

    table.clear(RootConnections)

    if FullScanThread then
        pcall(function()
            task.cancel(FullScanThread)
        end)
        FullScanThread = nil
    end
end

local function startDynamic()
    stopDynamic()

    for _, root in ipairs(getRoots()) do
        local ok, conn = pcall(function()
            return root.DescendantAdded:Connect(function(obj)
                if not Config.AutoTranslate then
                    return
                end

                task.spawn(function()
                    task.wait(Config.ScanDelay)

                    -- Vape 有时先创建 Frame，稍后才写 Text。
                    for _, delayTime in ipairs({0, 0.08, 0.25, 0.75, 1.5}) do
                        if delayTime > 0 then
                            task.wait(delayTime)
                        end

                        if obj and obj.Parent then
                            pcall(function()
                                scanTree(obj)
                            end)
                        end
                    end
                end)
            end)
        end)

        if ok and conn then
            table.insert(RootConnections, conn)
        end
    end

    -- 处理“对象没新增，但 Text 被内部代码改掉”的情况。
    FullScanThread = task.spawn(function()
        while Config.AutoTranslate do
            task.wait(Config.FullScanInterval)
            pcall(fullScan)
        end
    end)
end

--==================================================
-- WindUI 控制面板
--==================================================

local Window = WindUI:CreateWindow({
    Title = "Vape 中文翻译器 V5",
    Author = "Vape GUI Translator",
    Icon = "languages",
    Theme = "Dark",
    ToggleKey = Enum.KeyCode.RightControl,
})

local Tab = Window:Tab({
    Title = "翻译器",
    Icon = "languages",
})

Tab:Paragraph({
    Title = "V5 从零重构",
    Content = "主菜单 + 模块 + 设置 + Text GUI + 动态 GUI",
})

Tab:Toggle({
    Title = "自动翻译",
    Value = true,
    Callback = function(value)
        Config.AutoTranslate = value

        if value then
            local count = fullScan()
            startDynamic()

            WindUI:Notify({
                Title = "自动翻译已开启",
                Content = "重新扫描：" .. tostring(count) .. " 项",
                Duration = 3,
            })
        else
            WindUI:Notify({
                Title = "自动翻译已关闭",
                Content = "停止处理新的 GUI 文本",
                Duration = 3,
            })
        end
    end,
})

Tab:Button({
    Title = "立即扫描并翻译",
    Callback = function()
        local count = fullScan()

        WindUI:Notify({
            Title = "扫描完成",
            Content = "本次修改：" .. tostring(count) .. " 项",
            Duration = 3,
        })
    end,
})

Tab:Button({
    Title = "重启动态监听",
    Callback = function()
        startDynamic()

        WindUI:Notify({
            Title = "监听已重启",
            Content = "CoreGui / PlayerGui 动态监听已重新建立",
            Duration = 3,
        })
    end,
})

Tab:Button({
    Title = "测试截图中的设置",
    Callback = function()
        local tests = {
            "Combat",
            "Blatant",
            "Render",
            "Utility",
            "World",
            "Inventory",
            "MISC",
            "Friends",
            "Profiles",
            "Targets",
            "AimAssist",
            "AutoClicker",
            "Reach",
            "SilentAim",
            "TriggerBot",
            "AntiFall",
            "Fly",
            "HighJump",
            "HitBoxes",
            "Invisible",
            "Jesus",
            "Killaura",
            "LongJump",
            "MouseTP",
            "Phase",
            "Speed",
            "Spider",
            "SpinBot",
            "Swim",
            "Text GUI",
            "Target Info",
            "Radar",
            "Session Info",
            "Search mods",
            "Settings",
            "General",
            "Modules",
            "GUI",
            "Notifications",
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
        }

        local okCount = 0
        local bad = {}

        for _, input in ipairs(tests) do
            local output = TranslateText(input)

            if output ~= input then
                okCount += 1
            else
                table.insert(bad, input)
            end
        end

        WindUI:Notify({
            Title = "翻译器自检",
            Content = "成功处理：" .. tostring(okCount) ..
                " / " .. tostring(#tests) ..
                ( #bad > 0 and "\n仍未变化：" .. table.concat(bad, "、") or "\n全部发生变化"),
            Duration = 8,
        })
    end,
})

Tab:Toggle({
    Title = "调试模式",
    Value = false,
    Callback = function(value)
        Config.Debug = value
    end,
})

--==================================================
-- 启动
--==================================================

task.spawn(function()
    task.wait(0.25)
    fullScan()
    startDynamic()
end)
