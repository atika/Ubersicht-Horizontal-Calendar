
lg: "FR" # EN, FR
offdayIndices:[0, 6]
position: "C|0|70"
colors:
	"offday": "#1bd8e8"
	"midline-offday": "#1c8a9c"

	"off-today": "#3cffd7"
	"midline-off-today": "#3cffd7"
	
	"midline-today": "#20fdff"
	"midline-ordinary": "rgba(255,255,255,0.2)"

	"background": 
		"background-color":"rgba(0,0,0,0.0)"

# End custom configuration -----------------------------

dayNames:
	"EN": ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
	"FR": ["Dim", "Lun", "Mar", "Me", "Je", "Ve", "Sa"]

monthNames:
	"EN": ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
	"FR": ["Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Aout", "Septembre", "Octobre", "Novembre", "Décembre"]

command:""
refreshFrequency: 10000
displayedDate: null

render: ->
	'<div class="cal-container">
	<div class="title"></div>
	<table>
	<tr class="weekday"></tr>
	<tr class="midline"></tr>
	<tr class="date"></tr>
	</table>
	</div>'

style: """
	font-family: Helvetica Neue
	font-size: 11px
	font-weight: 500
	color: #FFF

	.cal-container
		border-radius: 10px
		//background: rgba(#000, 0.3)
		padding: 10px

	.title
		color: rgba(#fff, .3)
		font-size: 14px
		font-weight: 500
		padding-bottom: 5px
		text-transform uppercase

	table
		border-collapse: collapse

	td    
		padding-left: 4px
		padding-right: 4px
		text-align: center

	.weekday td
		padding-top: 3px

	.date td
		padding-bottom: 3px

	.today, .off-today
		background: rgba(#fff, 0.2)

	.weekday .today 
	.weekday .off-today
		border-radius: 3px 3px 0 0

	.date .today,   
	.date .off-today
		border-radius: 0 0 3px 3px

	.midline   
		height: 3px

	.midline .today
		background: rgba(#0bf, .8)

	.midline .offday
		background: rgba(#f77, .5)

	.midline .off-today
		background: rgba(#fc3, .8)

	.offday, .off-today
		color: rgba(#f77, 1)
"""


update: (output, domEl) ->

	date = new Date()
	y = date.getFullYear()
	m = date.getMonth()
	today = date.getDate()
	
	# DON'T MANUPULATE DOM IF NOT NEEDED
	newDate = [today, m, y].join("/")
	if this.displayedDate != null and this.displayedDate is newDate
		return
	else 
		this.displayedDate = newDate

	firstWeekDay = new Date(y, m, 1).getDay()
	lastDate = new Date(y, m + 1, 0).getDate()
	
	weekdays = ""
	midlines = ""
	dates = ""

	i = 1
	w = firstWeekDay

	while i <= lastDate
		w %= 7
		isToday = (i is today)
		isOffday = (@offdayIndices.indexOf(w) isnt -1)
		className = "ordinary"
		if isToday and isOffday
		  className = "off-today"
		else if isToday
		  className = "today"
		else className = "offday" if isOffday
		weekdays += "<td class=\"" + className + "\">" + @dayNames[@lg][w] + "</td>"
		midlines += "<td class=\"" + className + "\"></td>"
		dates += "<td class=\"" + className + "\">" + i + "</td>"
		i++
		w++

	$(domEl).find(".title").html this.monthNames[this.lg][m]+" "+y
	$(domEl).find(".weekday").html weekdays
	$(domEl).find(".midline").html midlines
	$(domEl).find(".date").html dates

	# Styles
	$(".offday",domEl).css("color",@colors["offday"])
	$(".off-today",domEl).css("color",@colors["off-today"])
	$(".midline .offday",domEl).css("background-color",@colors["midline-offday"])
	$(".midline .today",domEl).css("background-color",@colors["midline-today"])
	$(".midline .ordinary",domEl).css("background-color",@colors["midline-ordinary"])
	$(".midline .off-today",domEl).css("background-color",@colors["midline-off-today"])
	$(".cal-container",domEl).css(@colors.background)

	# Position
	position = @position.split("|")
	console.log $(".cal-container",domEl).width()
	switch position[0]
		when "TL"
			$(domEl).css({'left':parseInt(position[1]),'top':parseInt(position[2])})
		when "TR"
			$(domEl).css({'right':parseInt(position[1]),'top':parseInt(position[2])})
		when "BR"
			$(domEl).css({'right':parseInt(position[1]),'bottom':parseInt(position[2])})
		when "C"
			posH = if position[1] is "0" then ($(window).width()/2)-(($(domEl).width()+20)/2) else parseInt(position[1])
			posV = if position[2] is "0" then $(window).height()/2-50 else parseInt(position[2])
			$(domEl).css({'left':posH,'top':posV})
		else
			$(domEl).css({'left':parseInt(position[1]),'bottom':parseInt(position[2])})
