using RobHood 
using Vega
using Quandl

function readPortData(portfolio,nstocks)
    x = [];
    y = [];
    group = [];
    for(i in 1:nstocks)
       stockid = ASCIIString(portfolio[i])
       dat = quandl(stockid,rows=2000,format="DataFrame");
       println("Stock: $stockid");
       ndat = length(dat[1,])
       x = [x;collect(1:ndat)];
       y = [y;collect(dat[5,])];
       group = [group;[stockid for j in 1:ndat]];
    end
    return x,y,group
end

function getPlot(x,y,group)
    myplot=lineplot(x = x, y = y, group = group)
    xlab!(myplot,title="Time (last X days)")
    ylab!(myplot,title="Closed")
    title!(myplot,title="Stocks")
    myplot.background = "white"
    return myplot
end

function testplot(portfoliofile)
    portfolio = readdlm(portfoliofile,'\n');
    nstocks = length(portfolio);
    x,y,group = readPortData(portfolio,nstocks);
    myplot = getPlot(x,y,group);
    myplot
end

println("The portfolio file is: ",ARGS[1]);
testplot(ARGS[1])
