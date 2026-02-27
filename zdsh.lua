-- 核心修改：把多个用户配置放到数组里，每个用户独立配置所有参数
local AutoChatUsers = {
    -- 第一个用户
    {
        enabled = true,                -- 是否开启自动发言
        userName = "weidada9",         -- 可选：用户名
        targetUserId = 859088490,     -- 可选：玩家ID
        intervalSeconds = 180, 
        useTeamChat = false, 
        messages = { 
            "萌萌哒", 
            "嘿呦嘿呦" 
        } 
    },
    -- 第二个用户（你的配置，记得替换 新用户ID 为真实数字）
    {
        enabled = true,                -- 必须保留，控制该用户是否开启
        userName = "daweiqingyi",        
        targetUserId = 123456789,      -- 替换成真实的玩家ID
        intervalSeconds = 60,      
        useTeamChat = false,           -- 补充缺失的参数
        messages = {                  
            "大家好我是你哥",
            "没错我就是你大哥"
        }
    }
}

local Players = game:GetService("Players") 
local ReplicatedStorage = game:GetService("ReplicatedStorage") 
local TextChatService = game:FindService("TextChatService") 
local localPlayer = Players.LocalPlayer 

local Global = (getgenv and getgenv()) or _G 

-- 停止原有运行的脚本
if Global.AutoChatStop and type(Global.AutoChatStop) == "function" then 
    Global.AutoChatStop() 
end 

Global.AutoChatStop = nil 
local running = true 
Global.AutoChatStop = function() 
    running = false 
end 

-- 前置检查：无本地玩家则停止
if not localPlayer then 
    Global.AutoChatStop() 
    return 
end 

-- ===== 核心逻辑：匹配当前玩家的专属配置 =====
local currentUserConfig = nil  -- 存储当前玩家匹配到的配置

-- 遍历所有用户配置，找到匹配的
for _, userConfig in ipairs(AutoChatUsers) do
    -- 该用户配置未开启，跳过
    if not userConfig.enabled then
        continue
    end

    local idMatch = false
    local nameMatch = false

    -- 检查ID匹配
    if userConfig.targetUserId and localPlayer.UserId == userConfig.targetUserId then
        idMatch = true
    end

    -- 检查用户名匹配
    if userConfig.userName and localPlayer.Name == userConfig.userName then
        nameMatch = true
    end

    -- ID或用户名匹配，锁定该用户配置
    if idMatch or nameMatch then
        currentUserConfig = userConfig
        break
    end
end

-- 未找到匹配的用户配置，停止脚本
if not currentUserConfig then
    Global.AutoChatStop()
    return
end
-- ===============================================
 
local function getRandomMessage() 
    -- 读取当前匹配用户的专属消息
    local list = currentUserConfig.messages 
    if not list or #list == 0 then 
        return nil 
    end 
    local index = math.random(1, #list) 
    return list[index] 
end 
 
local function sendChatMessage(message) 
    if not message or message == "" then 
        return 
    end 
 
    local success = false 
 
    local ok1, chatEvents = pcall(function() 
        return ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents", 1) 
    end) 
 
    if ok1 and chatEvents then 
        local sayRemote = chatEvents:FindFirstChild("SayMessageRequest") 
        if sayRemote and sayRemote:IsA("RemoteEvent") then 
            -- 读取当前用户的团队聊天配置
            local channel = currentUserConfig.useTeamChat and "Team" or "All" 
            sayRemote:FireServer(message, channel) 
            success = true 
        end 
    end 
 
    if not success and TextChatService then 
        local channels = TextChatService:FindFirstChild("TextChannels") 
        if channels and channels:FindFirstChild("RBXGeneral") then 
            local general = channels.RBXGeneral 
            local ok2 = pcall(function() 
                general:SendAsync(message) 
            end) 
            if ok2 then 
                success = true 
            end 
        end 
    end 
end 
 
math.randomseed(tick()) 
 
-- 启动自动发言（使用当前用户的间隔配置）
task.spawn(function() 
    while running and currentUserConfig.enabled do 
        local msg = getRandomMessage() 
        if msg then 
            sendChatMessage(msg) 
        end 
        -- 读取当前用户的发言间隔
        local delayTime = currentUserConfig.intervalSeconds or 30 
        if delayTime < 1 then 
            delayTime = 1 
        end 
        task.wait(delayTime) 
    end 
end)
