ScriptInfo = {
    id = "mesilane.adechan.rain",
    title = "下雨黑线生成器",
    desc = "生成下雨般的黑线！",
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
            name = "雨点间隔(ms)",
            required = false,
            default = 200
        },
        {
            type = "number",
            name = "雨点长度 (默认=间隔)",
            required = false
        },
        {
            type = "number",
            name = "雨点左x限制",
            required = false,
            default = -0.25
        },
        {
            type = "number",
            name = "雨点右x限制",
            required = false,
            default = 1.25
        }
    }
}

function ScriptMain(...)
    local args = {...}
    local startTiming = args[1]
    local endTiming = args[2]
    local interval = args[3] or 200
    local length = args[4] or interval

    if args[5] == nil then
        leftx = 0
    else 
        leftx = (args[5] + 0.25) * 1000
    end
    if args[6] == nil then
        rightx = 1500
    else 
        rightx = (args[6] + 0.25) * 1000
    end
	--"为后文整数处理埋下伏笔""哦对没错我变量名是偷a1的脚本的"

    -- 我不知道还有什么别的问题了，大概（
    if startTiming >= endTiming then return "错误：起始时间必须早于结束时间" end
    if interval <= 0 then return "错误：雨点间隔必须大于0" end
    if length <= 0 then return "错误：雨点长度必须大于0" end
    if leftx > rightx then return "错误：左x限制不能大于右x限制" end

    local chart = ChartInstance
    local loopCount = 0

    -- 基于间隔的严格时间递进！这样应该就没有间隔了吧！
    local currentTiming = startTiming
    while currentTiming < endTiming do
        local endT = currentTiming + length
        
        local randX = Math.RandInt(leftx, rightx)
        local randY = Math.RandInt(0, 1000)
        local x = (randX - 250) / 1000
        local y = randY / 1000

        local arc = ScriptArc.Create(
            currentTiming,
            endT,
            0,
            x, x,
            y, y,
            "s",
            true
        )
        chart:AddArc(arc)

        currentTiming = currentTiming + interval
        loopCount = loopCount + 1
    end
end
