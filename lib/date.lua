--date and time functions 


module(..., package.seeall)

require("posix")
--global for date formating see below for more information
--Mon Nov 26 19:56:10 UTC 2007 looks like most systems use this
--print(os.date(date.format))
format = "%a %b %d %X %Z %Y"

months ={ {"January","Jan"},  
          {"February", "Feb"}, 
          {"March","Mar"}, 
          {"April", "Apr"},
	  {"May","May"},
	  {"June","Jun"},
	  {"July","Jul"},
	  {"August","Aug"},
	  {"September","Sep"},
	  {"October","Oct"},
	  {"November","Nov"},
	  {"December","Dec"}
	   }

revmonths = {["January"] = 1, ["Jan"] = 1, 
	     ["February"] = 2, ["Feb"] = 2,
	     ["March"] = 3, ["Mar"] = 3, 
	     ["April"] = 4, ["Apr"] = 4, 
	     ["May"] = 5,
	     ["June"] = 6, ["Jun"] = 6,
	     ["July"] = 7, ["Jul"] = 7,
	     ["August"] = 8, ["Aug"] = 8,
	     ["September"] = 9, ["Sep"] = 9,
	     ["October"] = 10, ["Oct"] = 10,
	     ["November"] = 11, ["Nov"] = 11,
	     ["December"] = 12, ["Dec"] = 12 
	     }

dow = { {"Sunday","Sun"}, 
	{"Monday","Mon"},
	{"Tuesday","Tue"},
	{"Wednesday","Wed"},
	{"Thursday","Thu"},
	{"Friday","Fri"},
	{"Saturday","Sat"}
	}
	
revdow = { ["Sunday"] = 1, ["Sun"] = 2,
	   ["Monday"] = 2, ["Mon"] = 2,
	   ["Tuesday"] = 3, ["Tue"] = 3,
	   ["Wednesday"] = 4, ["Wed"] = 4,
	   ["Thursday"] = 5, ["Thu"] = 5,
	   ["Friday"] = 6, ["Fri"] = 6,
	   ["Saturday"] = 7, ["Sat"] =7
	   }


--os.time() will give seconds since 1970-epoch
--os.date() will give formated time strings
--os.time{year=2007,month=1,day=1,hour=2,min=1,sec=1}
--os.date(date.format,os.time())

--give me a table
--t = { {year=2007,month=1,day=2,hour=2}, {year=2006,month=1,day=5} }
--will return a table sorted by oldest <-> newest 
--to grab the largest and smallest a,b=g[1],g[table.maxn(g)]
function date_to_seconds (t)
	g = {}
	count = table.maxn(t)
	for i = 1,count do
	g[#g+1] = os.time(t[i])
	end
	table.sort(g)
	return g
end

-- the reverse of date_to_seconds. expecting a table of seconds
--format can be changed. This seems to be standard, dow,mon,dom,time,zone,year
-- seems like %z- +0000 time zone format and %Z- 3 letter timezone undocumented or new

function seconds_to_date (t)
	g = {}
	count = table.maxn(t)
	for i = 1,count do
	g[#g+1] = os.date(format,t[i])	
	end
	
	return g	
end

--give dates in seconds and gives the difference in years,months,days,...
--gives a table back with hour,min,month,sec,day,year to display something like
--you have 10 years, 14 hours, 2 months and 10 days to renew you certificate
function date_diff (d1, d2)
	g = {}
	temp = {}
	sum = d1 - d2
	if sum < 0 then 
	sum = d2 - d1
	end
	temp = os.date("*t",sum)
	for a,b in pairs(temp) do 
	if a == "year" then
	hold = b - 1970	
	g[a] = hold
	elseif a == "hour" then
	g[a] = b
	elseif a == "min" then
	g[a] = b
	elseif a == "month" then
	g[a] = b
	elseif a == "sec" then
	g[a] = b
	elseif a == "day" then
	g[a] = b
	end
	end		
	return g
end

--give a search number and return the month name

function num_month_name (search)
	return months[search][1]
end

--give a search number and return the month abr

function num_month_name_abr (search)
	return months[search][2]
end

function name_month_num (search)
	return revmonths[search]
end

function abr_month_num (search)
	return revmonths[search]
end

function num_dow_name (search)
	return dow[search][1]
end

function num_dow_name_abr (search)
	return dow[search][2]
end

function name_dow_num (search)
	return revdow[search]
end

function abr_dow_num (search)
	return revdow[search]
end

