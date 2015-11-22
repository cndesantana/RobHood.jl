	using Vega
	Date(2015,11,21)
	start = Date(2015,11,21)
	days=100
	x = map(d -> start + Dates.Day(d), 1:days)
	y = 15 + randn(days) * 4
	myplot = lineplot(x=x,y=y)
