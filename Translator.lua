--// Vape V4 GUI Translator
--// Version 1.0

--==================================================
-- WindUI
--==================================================

local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

--==================================================
-- 翻译词典
--==================================================

local Dictionary = {
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

    -- Misc
    ["MISC"] = "杂项",
    ["Friends"] = "好友",
    ["Profiles"] = "配置文件",
    ["Targets"] = "目标设置",

    -- Visual
    ["Text GUI"] = "功能列表显示菜单",
    ["Target Info"] = "攻击目标显示",
    ["Radar"] = "雷达",
    ["Session Info"] = "当前对局信息",
    ["Spotify"] = "音乐插件",

    -- Search Mods
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

--==================================================
-- 翻译函数
--==================================================

local function TranslateText(text)
    if not text or text == "" then
        return text
    end

    -- 完全匹配
    if Dictionary[text] then
        return Dictionary[text]
    end

    -- 部分匹配
    for english, chinese in pairs(Dictionary) do
        if string.find(text, english, 1, true) then
            return string.gsub(text, english, chinese)
        end
    end

    return text
end

--==================================================
-- GUI 扫描
--==================================================

local TranslatedObjects = {}

local function TranslateObject(object)
    if not object:IsA("TextLabel")
        and not object:IsA("TextButton")
        and not object:IsA("TextBox") then
        return
    end

    local oldText = object.Text

    if not oldText or oldText == "" then
        return
    end

    local newText = TranslateText(oldText)

    if newText ~= oldText then
        if not TranslatedObjects[object] then
            TranslatedObjects[object] = oldText
        end

        object.Text = newText
    end
end

local function ScanGUI()
    local count = 0

    for _, object in ipairs(game:GetDescendants()) do
        if object:IsA("TextLabel")
            or object:IsA("TextButton")
            or object:IsA("TextBox") then

            local before = object.Text

            TranslateObject(object)

            if before ~= object.Text then
                count += 1
            end
        end
    end

    return count
end

--==================================================
-- 自动翻译
--==================================================

local AutoTranslate = true

local function StartAutoTranslator()
    game.DescendantAdded:Connect(function(object)

        if not AutoTranslate then
            return
        end

        task.wait(0.05)

        TranslateObject(object)
    end)
end

--==================================================
-- WindUI 窗口
--==================================================

local Window = WindUI:CreateWindow({
    Title = "Vape Translator",
    Author = "Vape GUI 自动翻译器",
    Icon = "languages",
    Theme = "Dark",
    ToggleKey = Enum.KeyCode.RightControl,
})

local MainTab = Window:Tab({
    Title = "翻译器",
    Icon = "languages",
})

local StatusSection = MainTab:Section({
    Title = "翻译状态",
})

StatusSection:Paragraph({
    Title = "Vape GUI Translator",
    Content = "自动扫描并翻译 Vape V4 界面文字",
})

MainTab:Toggle({
    Title = "自动翻译",
    Value = true,
    Callback = function(value)
        AutoTranslate = value

        if value then
            ScanGUI()
        end
    end
})

MainTab:Button({
    Title = "扫描并翻译当前界面",
    Callback = function()
        local count = ScanGUI()

        WindUI:Notify({
            Title = "翻译完成",
            Content = "本次翻译了 " .. tostring(count) .. " 个界面元素",
            Duration = 3,
        })
    end
})

MainTab:Button({
    Title = "重新扫描",
    Callback = function()
        local count = ScanGUI()

        WindUI:Notify({
            Title = "扫描完成",
            Content = "发现并翻译 " .. tostring(count) .. " 个文本",
            Duration = 3,
        })
    end
})

MainTab:Button({
    Title = "测试翻译器",
    Callback = function()
        WindUI:Notify({
            Title = "测试",
            Content = "AimAssist → " .. TranslateText("AimAssist"),
            Duration = 3,
        })
    end
})

--==================================================
-- 启动
--==================================================

StartAutoTranslator()

task.wait(1)

local count = ScanGUI()

WindUI:Notify({
    Title = "Vape Translator",
    Content = "翻译器已启动，共翻译 " .. tostring(count) .. " 个文本",
    Duration = 5,
})
