--[[
	module for splitting a string to an array 
]]--

module (..., package.seeall)

-- This code comes from http://lua-users.org/wiki/SplitJoin

-- Split text into a list consisting of the strings in text,
-- separated by strings matching delimiter (which may be a pattern). 
-- example: strsplit(",%s*", "Anna, Bob, Charlie,Dolores")
return function (delimiter, text)
	local list = {}
	local pos = 1
	-- this would result in endless loops
	if string.find("", delimiter, 1) then 
		error("delimiter matches empty string!")
	end
	while 1 do
		local first, last = string.find(text, delimiter, pos)
		if first then -- found?
			table.insert(list, string.sub(text, pos, first-1))
			pos = last+1
		else
			table.insert(list, string.sub(text, pos))
			break
		end
	end
	return list
end

