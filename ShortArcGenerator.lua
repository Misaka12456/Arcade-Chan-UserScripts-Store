ScriptInfo = {
	id = "anonymous.adechan.script.ShortArcGenerator",
	title = "短蛇段生成器",
	desc = "生成一段短蛇(音弧/Arc)。样式请参考短蛇段生成器.xlsx。",
	author = "Anonymous",
	version = "0.0.1",
	compatibility = "Arcade-Chan>=3.3.3",
	arguments = {
		{
			type = "number",
			name = "开始时间",
			required = true
		},
		{
			type = "number",
			name = "结束时间",
			required = true
		},
		{
			type = "number",
			name = "x初始位置",
			required = true
		},
		{
			type = "number",
			name = "y初始位置",
			required = true
		},
		{
			type = "number",
			name = "x结束位置",
			required = true
		},
		{
			type = "number",
			name = "y结束位置",
			required = true
		},
		{
			type = "string",
			name = "x形状 (s, b, si, so)",
			required = true
		},
		{
			type = "string",
			name = "y形状 (s, b, si, so)",
			required = true
		},
		{
			type = "number",
			name = "细分数量",
			required = false,
            default = 16
		},
		{
			type = "number",
			name = "颜色",
			required = true
		},
		{
			type = "boolean",
			name = "黑线",
			required = false,
            default = false
		},
		{
			type = "number",
			name = "样式 (1-7)",
			required = false,
            default = 1
		}
	}
}

local function interpolation(startC, endC, percent, type)
	local pi2 = 1.57079632679489661923132169163975144209858469968755291048747229615390

	if type == "s" then
		return startC + percent * (endC - startC)
	end

	if type == "b" then
		return startC + (endC - startC) * percent * percent * (3 - 2 * percent)
	end

	if type == "si" then
		return startC + (endC - startC) * Math.Sin(percent * pi2)
	end

	if type == "so" then
		return startC + (endC - startC) * (1 - Math.Cos(percent * pi2))
	end

	return 0
end

function ScriptMain(...)
	local args = {...}
    local startTime = args[1]
    local endTime = args[2]
    local startX = args[3]
    local startY = args[4]
    local endX = args[5]
    local endY = args[6]
    local typeX = args[7]
    local typeY = args[8]
    local count = args[9] or 16
    local color = args[10]
    local skyline = args[11] or false
    local style = args[12] or 1
    
	local chart = ChartInstance

	if startTime > endTime then
		return "起始时间比结束时间晚"
	end

    if typeX ~= "s" and typeX ~= "b" and typeX ~= "si" and typeX ~= "so" then
		return "x形状不是 s, b, si, so 之一"
	end

    if typeY ~= "s" and typeY ~= "b" and typeY ~= "si" and typeY ~= "so" then
		return "y形状不是 s, b, si, so 之一"
	end

    if count <= 0 then
        return "细分数量必须为正"
	elseif count > 64 then
		return "细分数量过大，最大允许 64 段"
	end

	if color ~= 0 and color ~= 1 and color ~= 2 and color ~= 3 then
		return "颜色不是 0, 1, 2, 3 之一"
	end

	if style ~= 1 and style ~= 2 and style ~= 3 and style ~= 4 and style ~= 5 and style ~= 6 and style ~= 7 then
		return "样式不是 1, 2, 3, 4, 5, 6, 7 之一"
	end

	if skyline then
		skyline = "true"
	else
		skyline = "false"
	end

	if style == 1 then
		for i=0,count-1 do
			local sp = (i + 0.0) / count
			local tp = (i + 1.0) / count
			local arc = ScriptArc.Create(
				Math.Round(interpolation(startTime, endTime, sp, "s")),
				Math.Round(interpolation(startTime, endTime, tp, "s")),
				color,
				interpolation(startX, endX, sp, typeX),
				interpolation(startX, endX, tp, typeX),
				interpolation(startY, endY, sp, typeY),
				interpolation(startY, endY, tp, typeY),
				"s",
				skyline
			)
			chart:AddArc(arc)
		end
	elseif style == 2 then
		for i=0,count-1 do
			if endTime - startTime < count then
				return "时长过短，不能生成此样式"
			end
			local sp = (i + 0.0) / count
			local tp = (i + 1.0) / count
			local arc = ScriptArc.Create(
				Math.Round(interpolation(startTime, endTime, sp, "s")),
				Math.Round(interpolation(startTime, endTime, tp, "s")) - 1,
				color,
				interpolation(startX, endX, sp, typeX),
				interpolation(startX, endX, tp, typeX),
				interpolation(startY, endY, sp, typeY),
				interpolation(startY, endY, tp, typeY),
				"s",
				skyline
			)
			chart:AddArc(arc)
		end
	elseif style == 3 then
		for i=0,count-1 do
			local sp = (i + 0.0) / count
			local tp = (i + 1.0) / count
			if i % 2 == 0 then
				local arc = ScriptArc.Create(
					Math.Round(interpolation(startTime, endTime, sp, "s")),
					Math.Round(interpolation(startTime, endTime, tp, "s")),
					color,
					interpolation(startX, endX, sp, typeX),
					interpolation(startX, endX, tp, typeX),
					interpolation(startY, endY, sp, typeY),
					interpolation(startY, endY, tp, typeY),
					"s",
					skyline
				)
				chart:AddArc(arc)
			else
				local arc = ScriptArc.Create(
					Math.Round(interpolation(startTime, endTime, sp, "s")),
					Math.Round(interpolation(startTime, endTime, tp, "s")),
					color,
					interpolation(startX, endX, sp, typeX),
					interpolation(startX, endX, tp, typeX),
					interpolation(startY, endY, sp, typeY),
					interpolation(startY, endY, tp, typeY),
					"s",
					"true"
				)
				chart:AddArc(arc)
			end
		end
	elseif style == 4 then
		for i=0,count-1 do
			local sp = (i + 0.0) / count
			local tp = (i + 1.0) / count
			local arc = ScriptArc.Create(
				Math.Round(interpolation(startTime, endTime, sp, "s")),
				Math.Round(interpolation(startTime, endTime, tp, "s")),
				color,
				interpolation(startX, endX, sp, typeX),
				interpolation(startX, endX, sp, typeX),
				interpolation(startY, endY, sp, typeY),
				interpolation(startY, endY, sp, typeY),
				"s",
				skyline
			)
			chart:AddArc(arc)
		end
	elseif style == 5 then
		for i=0,count-1 do
			local sp = (i + 0.0) / count
			local tp = (i + 1.0) / count
			local arc = ScriptArc.Create(
				Math.Round(interpolation(startTime, endTime, sp, "s")),
				Math.Round(interpolation(startTime, endTime, tp, "s")),
				color,
				interpolation(startX, endX, sp, typeX),
				interpolation(startX, endX, tp, typeX),
				interpolation(startY, endY, sp, typeY),
				interpolation(startY, endY, sp, typeY),
				"s",
				skyline
			)
			chart:AddArc(arc)
		end
	elseif style == 6 then
		for i=0,count-1 do
			local sp = (i + 0.0) / count
			local tp = (i + 1.0) / count
			local arc = ScriptArc.Create(
				Math.Round(interpolation(startTime, endTime, sp, "s")),
				Math.Round(interpolation(startTime, endTime, tp, "s")),
				color,
				interpolation(startX, endX, sp, typeX),
				interpolation(startX, endX, sp, typeX),
				interpolation(startY, endY, sp, typeY),
				interpolation(startY, endY, tp, typeY),
				"s",
				skyline
			)
			chart:AddArc(arc)
		end
	elseif style == 7 then
		for i=0,count-1 do
			local sp = (i + 0.0) / count
			local tp = (i + 1.0) / count
			local arc = ScriptArc.Create(
				Math.Round(interpolation(startTime, endTime, sp, "s")),
				Math.Round(interpolation(startTime, endTime, tp, "s")),
				color,
				interpolation(startX, endX, sp, typeX),
				interpolation(startX, endX, sp, typeX),
				interpolation(startY, endY, sp, typeY),
				interpolation(startY, endY, sp, typeY),
				"s",
				skyline
			)
			chart:AddArc(arc)
			if i ~= count - 1 then
				arc = ScriptArc.Create(
					Math.Round(interpolation(startTime, endTime, tp, "s")),
					Math.Round(interpolation(startTime, endTime, tp, "s")),
					color,
					interpolation(startX, endX, sp, typeX),
					interpolation(startX, endX, tp, typeX),
					interpolation(startY, endY, sp, typeY),
					interpolation(startY, endY, tp, typeY),
					"s",
					skyline
				)
				chart:AddArc(arc)
			end
		end
	end
    return "成功"
end