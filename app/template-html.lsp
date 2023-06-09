<% local viewtable, viewlibrary, pageinfo, session = ...
   html=require("acf.html")
   posix=require("posix")
%>
Status: 200 OK
Content-Type: text/html
<%
if (session.id) then
	io.write( html.cookie.set("sessionid", session.id) )
else
	io.write (html.cookie.unset("sessionid"))
end
%>

<%
local hostname = ""
if pageinfo.skinned ~= "false" and viewlibrary and viewlibrary.dispatch_component then
	local result = viewlibrary.dispatch_component("alpine-baselayout/hostname/read", nil, true)
	if result and result.value then
		hostname = result.value
	end
end
%>


<!DOCTYPE html>
<!--[if IE 6]> <html class="ie6"> <![endif]-->
<!--[if IE 7]> <html class="ie7"> <![endif]-->
<!--[if IE 8]> <html class="ie8"> <![endif]-->
<!--[if gt IE 8]><!--> <html> <!--<![endif]-->
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

<% if pageinfo.skinned ~= "false" then %>
		<title><%= html.html_escape(hostname .. " - " .. pageinfo.controller .. "->" .. pageinfo.action) %></title>

		<link rel="stylesheet" type="text/css" href="<%= html.html_escape(pageinfo.wwwprefix..pageinfo.staticdir) %>/reset.css">
		<link rel="stylesheet" type="text/css" href="<%= html.html_escape(pageinfo.wwwprefix..pageinfo.skin.."/"..posix.basename(pageinfo.skin)..".css") %>">
		<!--[if IE]>
		<link rel="stylesheet" type="text/css" href="<%= html.html_escape(pageinfo.wwwprefix..pageinfo.skin.."/"..posix.basename(pageinfo.skin).."-ie.css") %>">
		<![endif]-->

		<script type="text/javascript">
			if (typeof jQuery == 'undefined') {
				document.write('<script type="text/javascript" src="<%= html.html_escape(pageinfo.wwwprefix) %>/js/jquery-latest.js"><\/script>');
			}
		</script>
		<script type="text/javascript" src="<%= html.html_escape(pageinfo.wwwprefix..pageinfo.skin.."/"..posix.basename(pageinfo.skin)..".js") %>"></script>
		<script type="text/javascript">
			$(function(){
				$(":input:not(input[type=button],input[type=submit],button):enabled:not([readonly]):visible:first").focus();
			});
		</script>
<% end -- pageinfo.skinned %>

	</head>
	<body>

<% if pageinfo.skinned ~= "false" then %>
		<div id="page">
			<div id="header">
				<h1>AlpineLinux</h1>
				<p class="hostname"><%= html.html_escape(hostname or "unknown hostname") %></p>
				<p class="links">
				<%
					local ctlr = pageinfo.script .. "/acf-util/logon/"

					if session.userinfo and session.userinfo.userid then
						print("<a href=\""..html.html_escape(ctlr).."logoff\">Log off as '" .. html.html_escape(session.userinfo.userid) .. "'</a> |")
					else
						print("<a href=\""..html.html_escape(ctlr).."logon\">Log on</a> |" )
					end
				%>
					<a href="<%= html.html_escape(pageinfo.wwwprefix) %>/">home</a> |
					<a href="http://www.alpinelinux.org">about</a>
				</p>
			</div>	<!-- header -->

			<div id="main">
				<div id="nav">
				<%
					local class
					local tabs
					if (#session.menu.cats > 0) then
						print("<ul>")
						for x,cat in ipairs(session.menu.cats) do
							print("<li>"..html.html_escape(cat.name))
							print("<ul>")
							for y,group in ipairs(cat.groups) do
								class=""
								if not tabs and group.controllers[pageinfo.prefix .. pageinfo.controller] then
									class="class='selected'"
									tabs = group.tabs
								end
								print("<li "..class.."><a "..class.." href=\""..html.html_escape(pageinfo.script)..html.html_escape(group.tabs[1].prefix)..html.html_escape(group.tabs[1].controller).."/"..html.html_escape(group.tabs[1].action).."\">"..html.html_escape(group.name).."</a></li>")
							end
							print("</ul>")
							print("</li>")
						end
						print("</ul>")
					end
				%>
				</div>	<!-- nav -->

				<div id="subnav">
				<%
					local class=""
					if (tabs and #tabs > 0) then
						print("<ul>")
						for x,tab in pairs(tabs or {})  do
							if tab.prefix == pageinfo.prefix and tab.controller == pageinfo.controller and tab.action == pageinfo.action then
								class="class='selected'"
							else
								class=""
							end
							print("<li "..class.."><a "..class.." href=\""..html.html_escape(pageinfo.script)..html.html_escape(tab.prefix)..html.html_escape(tab.controller).."/"..html.html_escape(tab.action).."\">"..html.html_escape(tab.name).."</a></li>")
						end
						print("</ul>")
					end
				%>
				</div> <!-- subnav -->

				<div id="content">
<% end --pageinfo.skinned %>

					<% pageinfo.viewfunc(viewtable, viewlibrary, pageinfo, session) %>

<% if pageinfo.skinned ~= "false" then %>
				</div>	<!-- content -->

			</div> <!-- main -->

			<div id="footer">
				<p>Page generated in <%= html.html_escape(os.clock()) %> seconds on <%= html.html_escape(os.date()) %>.</p>
			</div> <!-- footer -->

		</div> <!-- page -->
<% end --pageinfo.skinned %>

	</body>
</html>
