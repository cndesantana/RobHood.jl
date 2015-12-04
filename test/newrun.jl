Pkg.checkout("Vega")

using RobHood 
using Vega
using Quandl

function testplot(portfoliofile)
    println("Testing RobHood.jl");
    portfolio = readdlm(portfoliofile,'\n');
    nstocks = length(portfolio);
    x1 = [];
    y1 = [];
    group = [];
    for(i in 1:nstocks)
       dat = quandl(portfolio[i],rows=2000,format="DataFrame");
       ndat = size(dat[1,])
       x=[x;collect(1:size(dat[1,],1))];
       y=[y;collect(dat[5,])];
       group = [group;[[i for j in 1:dat]]];
    end

    googleplot=lineplot(x = x, y = y, group = group)
   
    xlab!(googleplot,title="Time")
    ylab!(googleplot,title="Closed")
    title!(googleplot,title="Stocks")
    googleplot.background = "white"
    googleplot;
end

testplot(ARGS[1])
