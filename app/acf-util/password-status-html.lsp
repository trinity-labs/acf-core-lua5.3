<? local form, viewlibrary, pageinfo, session = ... ?>
<? require("viewfunctions") ?>
<?
--[[ DEBUG INFORMATION
io.write("<H1>DEBUGGING</H1><span style='color:red'><H2>DEBUG INFO: CFE</H2>")
io.write(html.cfe_unpack(form))
io.write("</span>")
--]]
?>

<? displaycommandresults({"deleteuser"}, session) ?>

<H1>User Accounts</H1>
<H2>Create new account</H2>
<form action="newuser" method="POST">
<dl><dt></dt><dd><input class="submit" type="submit" value="New User"></dd></dl>
</form>
<H2>Existing account</H2>
<DL>
<? for name,user in pairs(form.value) do ?>
	<DT><IMG SRC='/skins/static/tango/16x16/apps/system-users.png' HEIGHT='16' WIDTH='16'> <?= name ?></DT>
	<DD><TABLE>
		<TR>
			<TD STYLE='border:none;'><B><?= user.value.userid.label ?></B></TD>
			<TD STYLE='border:none;' WIDTH='90%'><?= user.value.userid.value ?></TD>
		</TR><TR>
			<TD STYLE='border:none;'><B><?= user.value.username.label ?></B></TD>
			<TD STYLE='border:none;'><?= user.value.username.value ?></TD>
		</TR><TR>
			<TD STYLE='border:none;'><B><?= user.value.roles.label ?></B></TD>
			<TD STYLE='border:none;'><?= table.concat(user.value.roles.value, " / ") ?></TD>
		</TR><TR>
			<TD STYLE='border:none;'><B><?= user.value.dnsfiles.label ?></B></TD>
			<TD STYLE='border:none;'><?= table.concat(user.value.dnsfiles.value, "<br>") ?></TD>
		</TR><TR>
			<TD STYLE='border:none;'><B>Option</B></TD>
			<TD STYLE='border:none;'>
			[<A HREF='edituser?userid=<?= name ?>'>Edit this account</A>]
			[<A HREF='deleteuser?userid=<?= name ?>'>Delete this account</A>]
			[<A HREF='<?= pageinfo.script ?>/acf-util/roles/viewuserroles?userid=<?= name ?>'>View roles for this account</A>]
			</TD>
		</TR>
	</TABLE></DD>
<? end ?>
</DL>
