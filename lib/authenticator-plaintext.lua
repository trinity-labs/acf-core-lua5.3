--[[ ACF Logon/Logoff authenticator that uses plaintext files
	Copyright (c) 2007 Nathan Angelacos
	GPL2 license


The password file is in the format:

userid:password:username:role1[,role2...]

]]--

module (..., package.seeall)

local sess = require ("session")

local pvt={}

pvt.parse_authfile = function(filename) 
	local row = {}

	-- open our password file
	local f = io.open (filename)
	if f then
		local m = f:read("*all") .. "\n"
		f:close()
	
		for l in string.gmatch(m, "(%C*)\n") do
			local userid, password, username, roles =
				string.match(l, "([^:]*):([^:]*):([^:]*):(.*)")
			local r = {}
			for x in string.gmatch(roles, "([^,]*),?") do
				table.insert (r, x )
			end
				
			local a = {} 
			a.userid = userid
			a.password = password
			a.username = username
			a.roles = r
			table.insert (row, a)
		end
		return row
	else	
		return false
	end
end

pvt.get_id = function(userid, authstruct)
	if authstruct == nil then return false end
	for x = 1,#authstruct do
		if authstruct[x].userid == userid then
			return authstruct[x]
		end
	end
end

--- public methods
	
-- This function returns true or false, and
-- if false:  the reason for failure
authenticate = function ( userid, password )
	password = password or ""
	userid = userid or ""

	local t = pvt.parse_authfile(conf.confdir .. "/passwd")

	if t == false then
		return false, "password file is missing"
	else
		local id = pvt.get_id (userid, t)
		if id == false then
			return false, "Userid not found"
		end
		if id.password ~= password then
			return false, "Invalid password"
		end
	end
	return true
	end


-- This function returns the username and roles 
-- or false on an error 
userinfo = function ( userid )
	local t = pvt.parse_authfile(conf.confdir .. "/passwd")
	if t == false then 
		return false
	else
		pvt.get_id (userid, t)
	end
end
