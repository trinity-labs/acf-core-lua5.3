-- Roles/Group functions
module (..., package.seeall)

require("modelfunctions")
require("authenticator")
require("roles")

local get_all_permissions = function(self)
	-- need to get a list of all the controllers
	controllers = roles.get_controllers(self)
	local table_perm = {}
	local array_perm = {}
	for a,b in pairs(controllers) do
		if nil == table_perm[b.sname] then
			table_perm[b.sname] = {}
		end
		local temp = roles.get_controllers_func(self,b)
		for x,y in ipairs(temp) do
			table_perm[b.sname][y] = {}
			array_perm[#array_perm + 1] = b.sname .. ":" .. y
		end
		temp = roles.get_controllers_view(self,b)
		for x,y in ipairs(temp) do
			if not table_perm[b.sname][y] then
				table_perm[b.sname][y] = {}
				array_perm[#array_perm + 1] = b.sname .. ":" .. y
			end
		end
	end

	return table_perm, array_perm
end

-- Return roles/permissions for specified user
get_user_roles = function(self, userid)
	rls = cfe({ type="list", value=authenticator.get_userinfo_roles(self, userid).value, label="Roles" })
	permissions = cfe({ type="table", value=roles.get_roles_perm(self.conf.appdir, rls.value), label="Permissions" })
	return cfe({ type="group", value={roles=rls, permissions=permissions} })
end

-- Return permissions for specified role
get_role_perms = function(self, role)
	return cfe({ type="table", value=roles.get_role_perm(self.conf.appdir, role), label="Permissions" })
end
	
-- Return list of all permissions
get_perms_list = function()
	return cfe({ type="table", value=get_all_permissions(self), label="All Permissions" })
end

view_roles = function()
	local defined_roles, default_roles = roles.list_roles()
	local defined_roles_cfe=cfe({ type="list", value=defined_roles, label="Locally-defined roles" })
	local default_roles_cfe=cfe({ type="list", value=default_roles, label="System-defined roles" })

	return cfe({ type="group", value={defined_roles=defined_roles_cfe, default_roles=default_roles_cfe} })
end

getpermissions = function(self, role)
	local my_perms = {}

	if role then
		tmp, my_perms = roles.get_role_perm(self.conf.appdir, role)
		my_perms = my_perms or {}
	else
		role = ""
	end

	local tmp, all_perms = get_all_permissions(self)
	table.sort(all_perms)
	
	local permissions_cfe = cfe({ type="multi", value=my_perms, option=all_perms, label="Role permissions" })
	local role_cfe = cfe({ value=role, label="Role" })

	return cfe({ type="table", value={role=role_cfe, permissions=permissions_cfe} })
end

setpermissions = function(self, permissions, newrole)
	-- Validate entries and create error strings
	local result = true
	if newrole then
		-- make sure not overwriting role
		local defined_roles, default_roles = roles.list_roles()
		local reverseroles = {}
		for i,role in ipairs(defined_roles) do reverseroles[role] = i end
		for i,role in ipairs(default_roles) do reverseroles[role] = i end
		if reverseroles[permissions.value.role.value] then
			result = false
			permissions.value.role.errtxt = "Role already exists"
			permissions.errtxt = "Failed to create role"
		end
	end
	-- Try to set the value
	if result==true then
		result, permissions.value.role.errtxt = roles.set_role_perm(permissions.value.role.value, nil, permissions.value.permissions.value)
		if not result then
			permissions.errtxt = "Failed to save role"
		end
	end

	return permissions
end

delete_role = function(role)
	local result, cmdresult = roles.delete_role(role)
	return cfe({ value=cmdresult })
end
