<% local form = ... %>
<% require("viewfunctions") %>

<h1><%= html.html_escape(form.label) %></h1>
<%
	form.value.password.type = "password"
	form.value.redir.type = "hidden"
	local order = { "userid", "password" }
	displayform(form, order)
%>
