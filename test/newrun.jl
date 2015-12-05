using RobHood 
using Vega
using Quandl

function testplot(portfoliofile)
    portfolio = readdlm(portfoliofile,'\n');
    nstocks = length(portfolio);
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

    googleplot=lineplot(x = x, y = y, group = group)
   
    xlab!(googleplot,title="Time (last X days)")
    ylab!(googleplot,title="Closed")
    title!(googleplot,title="Stocks")
    googleplot.background = "white"
    googleplot
end

println("The portfolio file is: ",ARGS[1]);
testplot(ARGS[1])
