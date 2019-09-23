
local MAX_QUEUE = 1000000

local InfoList
local ValueInfo
local ValueCount

local getupvalue = debug.getupvalue
local getinfo = debug.getinfo
local getlocal = debug.getlocal
local pairs = pairs
local type = type

local function CheckValue(key, value, parent)
	local typ = type(value)
	if (typ~="table" and typ~="function" and typ~="thread") or ValueInfo[value] or ValueCount>=MAX_QUEUE then
		return
	end
	ValueCount = ValueCount + 1
	local info = {
		index = ValueCount,
		parent = parent,
		key = key,
		value = value,
	}
	ValueInfo[value] = info
	InfoList[ValueCount] = info
end

local function CheckAll()
	InfoList = {}
	ValueInfo = {}
	ValueCount = 0
	ValueInfo[InfoList] = true
	ValueInfo[ValueInfo] = true
	CheckValue("_G", _G, nil)

	local i = 1
	while i<=ValueCount do
		local info = InfoList[i]
		local value = info.value
		local typ = type(value)
		i = i + 1
		local count = 1
		if typ=="table" then
			for k, v in pairs(value) do
				count = count + 1
				CheckValue(k, k, info)
				CheckValue(k, v, info)
			end
		elseif typ=="function" then
			for j = 1, 100 do
				local k, v = getupvalue(value, j)
				if not k then
					break
				end
				count = count + 1
				CheckValue(k, v, info)
			end
		else	-- thread
			for n = 1, 100 do
				local f = getinfo(value, n, "n")
				if f then
					count = count + 1
					for m = 1, 100 do
						local k, v = getlocal(value, n, m)
						if not k then
							break
						end
						count = count + 1
						CheckValue((f.name or "function").. "():" .. k, v, info)
					end
				end
			end
		end
		info.count = count
		local parent = info.parent
		while parent do
			parent.count = parent.count + count
			parent = parent.parent
		end
	end
end

local function ChildList(info)
	local value = info.value
	local typ = type(value)
	local list = {}
	local function append(v)
		local inf = ValueInfo[v]
		if inf and inf.parent==info then
			table.insert(list, inf)
		end
	end
	if typ=="table" then
		for k, v in pairs(value) do
			append(k)
			append(v)
		end
	elseif typ=="function" then
		for j = 1, 100 do
			local k, v = getupvalue(value, j)
			if not k then
				break
			end
			append(v)
		end
	else	-- thread
		for n = 1, 100 do
			local f = getinfo(value, n, "n")
			if f then
				for m = 1, 100 do
					local k, v = getlocal(value, n, m)
					if not k then
						break
					end
					append(v)
				end
			end
		end
	end
	table.sort(list, function(a, b) return a.count > b.count end)
	return list
end

local MaxLevel
local MinCount
local RestCount
local TotalCount

local function PCT(c, t)
	return string.format("%.1f%%", c * 100 / t)
end

local function DoShow(info, level)
	for i, inf in ipairs(ChildList(info)) do
		if inf.count<=MinCount then
			break
		end
		print(inf.index, string.format("%-30s", string.rep(".", level - 1) .. inf.key),
			inf.count, PCT(inf.count, info.count), PCT(inf.count, TotalCount), tostring(inf.value))
		RestCount = RestCount - 1
		if RestCount<=0 then
			print("...")
			return false
		end
		if level<MaxLevel then
			DoShow(inf, level + 1)
			if RestCount<=0 then
				break
			end
		end
	end
end

local M ={}

function M.List(index, level, percent, count)
	if not TotalCount then
		CheckAll()
		if ValueCount>=MAX_QUEUE then
			print("more then MAX_QUEUE!", MAX_QUEUE)
		end
		TotalCount = InfoList[1].count
	end
	
	local info = assert(InfoList[index or 1])
	local path = tostring(info.key)
	local parent = info.parent
	while parent do
		path = tostring(parent.key) .. "." .. path
		parent = parent.parent
	end
	print("path:", path)
	print("index:", info.index)
	print("PCT.T:", PCT(info.count, TotalCount))
	print("value:", tostring(info.value))
	print()
	print("index", string.format("%-30s", "key"), "count", "PCT.P", "PCT.T", "value")
	MaxLevel = level or 3
	MinCount = percent and (percent * TotalCount // 100) or 0
	RestCount = count or 100
	DoShow(info, 1)
	
	print()
end

function M.Clear()
	InfoList = nil
	ValueInfo = nil
	ValueCount = nil
	TotalCount = nil
end

return M
