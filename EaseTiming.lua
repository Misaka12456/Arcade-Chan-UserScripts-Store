ScriptInfo = {
    id = "mesilane.adechan.easetiming",
    title = "渐变Timing生成器",
    desc = "渐变timing,类型有(In/Out/InOut) + (Sine/Quad/Cubic) ，如InSine，目前仅可使用小写，前面大小是为了我看的方便的x。",
    author = "Mesilane",
    version = "1.0",
    compatibility = "Arcade-Chan>=3.3.3",
    arguments = {
        {
            type = "number",
            name = "起始时间",
            required = true
        },
        {
            type = "number",
            name = "结束时间",
            required = true
        },
        {
            type = "number",
            name = "起始 BPM",
            required = true
        },
        {
            type = "number",
            name = "结束 BPM",
            required = true
        },
        {
            type = "number",
            name = "小节线",
            required = false,
            default = 4
        },
        {
            type = "number",
            name = "时间组",
            required = false,
            default = 0
        },
        {
            type = "string",
            name = "渐变类型(仅小写)",
            required = false,
            default = "linear"
        },
        {
            type = "number",
            name = "分割数",
            required = true
        }
    }
}

local pi =3.1415926535

local function CustomEasing(easeType, startValue, endValue, t)
    t = Math.Clamp01(t)
    local delta = endValue - startValue

    if easeType == "linear" then
        return startValue + delta * t
    elseif easeType == "inquad" then
        return startValue + delta * t * t
    elseif easeType == "outquad" then
        return startValue + delta * t * (2 - t)
    elseif easeType == "inoutquad" then
        if t < 0.5 then
            return startValue + delta * 2 * t * t
        else
            return startValue + delta * (1 - Math.Pow(-2 * t + 2, 2) / 2)
        end
    elseif easeType == "incubic" then
        return startValue + delta * Math.Pow(t, 3)
    elseif easeType == "outcubic" then
        return startValue + delta * (1 - Math.Pow(1 - t, 3))
    elseif easeType == "inoutcubic" then
        if t < 0.5 then
            return startValue + delta * 4 * Math.Pow(t, 3)
        else
            return startValue + delta * (1 - Math.Pow(-2 * t + 2, 3) / 2)
        end
    elseif easeType == "insine" then
        return startValue + delta * (1 - Math.Cos(t * pi / 2))
    elseif easeType == "outsine" then
        return startValue + delta * Math.Sin(t * pi / 2)
    elseif easeType == "inoutsine" then
        return startValue + delta * (1 - Math.Cos(t * pi)) / 2
    else
        return -1
    end
end

function ScriptMain(...)
    local args = {...}
    local baseTiming = args[1]
    local endTiming = args[2]
    local startBpm = args[3]
    local endBpm = args[4]
    local bpl = args[5] or 4
    local tg = args[6] or 0
	local easeType = args[7] or "linear"
    local divide = args[8]

    if CustomEasing(easeType, 0, 0, 0) == -1 then
        return "错误：不支持的缓动类型（可用类型: linear, inquad, outquad, inoutquad, incubic, outcubic, inoutcubic, insine, outsine, inoutsine）"
    end
    if divide < 1 then
        return "错误：分割数必须≥1"
    end

    local chart = ChartInstance
    
    for i = 0, divide - 1 do
        local p = i / (divide - 1)
        
        local timing = ScriptTiming.Create(
            CustomEasing(easeType, baseTiming, endTiming, p),
            CustomEasing(easeType, startBpm, endBpm, p),
            bpl,
			tg
        )
        chart:AddTiming(timing)
    end
end