module(..., package.seeall)

require("posix")

-- We use the parent exception handler in a last-case situation
local parent_exception_handler

mvc = {}
mvc.on_load = function (self, parent)
	-- Make sure we have some kind of sane defaults for libdir
	self.conf.libdir = self.conf.libdir or ( posix.dirname(self.conf.appdir) .. "/lib/" )
	self.conf.script = ""
	self.conf.default_prefix = "/acf-util/"	
	self.conf.default_controller = "welcome"	

	parent_exception_handler = parent.exception_handler
	
	-- this sets the package path for us and our children
	package.path=  self.conf.libdir .. "?.lua;" .. package.path

	self.session = {}
	local x=require("session")
end

mvc.pre_exec = function ()
end

mvc.post_exec = function ()
end


view_resolver = function(self)
	return function (viewtable)
		print(session.serialize("result", viewtable))
	end
end

--[[ The parent exception handler is just fine
exception_handler = function (self, message )
	print(session.serialize("exception", message))
end
--]]

redirect = function (self, str, result)
	return result
end

redirect_to_referrer = function(self, result)
	return result
end

-- syslog something
logevent = function ( ... )
	os.execute ( "logger \"" .. ... .. "\"" )
end
