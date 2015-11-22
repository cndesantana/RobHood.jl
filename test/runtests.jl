using RobHood 
using Vega
using Quandl

function main()
    println("Testing RobHood.jl");
    googledat = quandl("GOOG/NASDAQ_QQQ",rows=4218,format="DataFrame")
    
    x=collect(1:size(googledat[1,],1))
    y=collect(googledat[5,])
    
    googleplot=lineplot(x=x,y=y)

    xlab!(googleplot,title="Time")
    ylab!(googleplot,title="Closed")
    title!(googleplot,title="Alphabet Stocks")
end

main()
