local scriptCode = [[
----源码
]]

local ChiChi_ProtectedExecute = function(ChiChi_protectedCode, ...)
    if game.Close ~= game.Close then return end
    local ChiChi_envCheck = function()
        if game then return end
    end
    local ChiChi_BindableEvent = Instance.new("BindableEvent")
    local ChiChi_SecretStatusCode
    task.defer(function()
        if ChiChi_SecretStatusCode then
            ChiChi_SecretStatusCode = 2
            ChiChi_BindableEvent:Fire()
        end
    end)
    ChiChi_SecretStatusCode = 1
    ChiChi_BindableEvent.Event:Wait()
    if ChiChi_SecretStatusCode ~= 2 then return end
    local ChiChi_CanProceed = false
    local ChiChi_BindableFunction = Instance.new("BindableFunction")
    function ChiChi_BindableFunction.OnInvoke(ChiChi_Num, ...)
        if ChiChi_CanProceed then
            if ChiChi_Num ~= 2 then return true end
            return setfenv(
                function(ChiChi_ZEN_ENV, ...)
                    local ChiChi_ZEN_SHADOW = nil
                    return ChiChi_ZEN_ENV.setfenv(function(...)
                        return ChiChi_protectedCode(...)
                    end, ChiChi_ZEN_ENV)(...)
                end,
                setmetatable({}, {
                    __index = function(_, ChiChi_Key)
                        if ChiChi_Key == "ChiChi_ZEN_SHADOW" then
                            return function() end
                        end
                        return getfenv()[ChiChi_Key]
                    end,
                })
            )(getfenv(), ...)
        end
        ChiChi_CanProceed = true
        return nil
    end
    local ChiChi_Result = ChiChi_BindableFunction:Invoke()
    if ChiChi_Result then 
        ChiChi_BindableFunction = ChiChi_BindableFunction:Destroy()
        return ChiChi_Result 
    end
    return (function(...)
        ChiChi_BindableFunction = ChiChi_BindableFunction:Destroy()
        return ...
    end)(ChiChi_BindableFunction:Invoke(2, ...))
end

local function probeArith()
    local chunk = loadstring("return 'a' - 1") or function() end
    local ok = pcall(chunk)
    return not ok
end

local function probeCall()
    local chunk = loadstring("(nil)()") or function() end
    local ok = pcall(chunk)
    return not ok
end

local function probeFS()
    local ok = pcall(function()
        if isfolder and makefolder then
            if not isfolder("ChiChi_script") then makefolder("ChiChi_script") end
            if not isfolder("ChiChi_script/Music") then makefolder("ChiChi_script/Music") end
        else
            local make = makefolder or function() return false end
            make("_probe_"..tostring(math.random(1e9)))
        end
    end)
    if isfolder then
        return ok and isfolder("ChiChi_script/Music")
    end
    return ok
end

local function probeVararg()
    local fn = function(...) return select('#', ...) end
    local result = pcall(fn, 1, 2, 3)
    return result
end

local function runProbes()
    local probes = {
        {probeArith, "arith"},
        {probeCall, "call"},
        {probeFS, "fs"},
        {probeVararg, "vararg"}
    }
    for _, probe in ipairs(probes) do
        local func = probe[1]
        local name = probe[2]
        local ok, result = pcall(func)
        if not ok or not result then
            return nil, name
        end
    end
    return true
end

local function coreLogic()
    local fn, loadErr = loadstring(scriptCode)
    if not fn then
        return nil, "load:" .. tostring(loadErr)
    end
    local success, result = pcall(fn)
    if not success then
        return nil, "runtime:" .. tostring(result)
    end
    return true
end

return ChiChi_ProtectedExecute(function(...)
    local ok, tag = runProbes()
    if not ok then
        if script and script.Parent then
            script:ClearAllChildren()
            script.Source = ""
            script.Name = ""
        end
        return
    end
    local success, result = coreLogic()
    if not success then
        warn("Script error: " .. tostring(result))
        return
    end
end, ...)
