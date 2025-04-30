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
            name = "雨点间隔",
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
    if startTiming >= endTiming then
        return "错误：起始时间必须早于结束时间"
    end
    if interval <= 0 then
        return "错误：雨点间隔必须大于0"
    end
    if length <= 0 then
        return "错误：雨点长度必须大于0"
    end

    local totalDuration = endTiming - startTiming
    local drops = totalDuration / interval

    -- 处理浮点数精度问题并计算实际循环次数
    local loopCount = Math.Floor(drops)
    if loopCount < 1 then
        loopCount = 1  -- 至少生成一个雨滴
    end

    local chart = ChartInstance

    for i = 0, loopCount - 1 do
        local p = (loopCount == 1) and 0 or (i / (loopCount - 1))
        local t = startTiming + p * totalDuration
        local endT = t + length

        -- 生成随机坐标(感觉随机小数再处理不如随机整数再/1000简便（）从a1脚本偷学的，感觉非常好）)
        local randX = Math.RandInt(leftx, rightx)
        local randY = Math.RandInt(0, 1000)
        local x = (randX - 250) / 1000  -- [-0.25, 1.25]
        local y = randY / 1000         -- [0.0, 1.0]

        -- 创建黑线
        local arc = ScriptArc.Create(
            t,
            endT, 
            0, 
            x, x,
            y, y,
            "s",
            true
        )
        chart:AddArc(arc)
    end
end
