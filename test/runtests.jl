Pkg.checkout("Vega")

using RobHood 
using Vega
using Quandl

function testplot()
    println("Testing RobHood.jl");
    googledat = quandl("GOOG/NASDAQ_GOOG",rows=2000,format="DataFrame");
    amazondat = quandl("YAHOO/AMZN",rows=2000,format="DataFrame");
    
    x1=collect(1:size(googledat[1,],1));
    y1=collect(googledat[5,]);

    x2=collect(1:size(amazondat[1,],1));
    y2=collect(amazondat[5,]);

    x = [1:length(x1); 1:length(x2)];
    y = [y1; y2];
    group = [[1 for i in 1:length(x1)]; [2 for i in 1:length(x2)]];
    
    googleplot=lineplot(x = x, y = y, group = group)
   
    xlab!(googleplot,title="Time")
    ylab!(googleplot,title="Closed")
    title!(googleplot,title="Alphabet(1) and Amazon(2) (2007-2015)")
    googleplot.background = "white"
    googleplot;
end

testplot()
