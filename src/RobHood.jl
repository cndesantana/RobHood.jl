# version 0.1

module RobHood 

using Vega
using Quandl
using Plots

function readPortData(portfolio,nS)
    x = [];
    y = [];
    group = [];
    for(i in 1:nS)
       stockid = ASCIIString(portfolio[i])
#       stockid = portfolio[i]
#       println("type: ",typeof(stockid));
       dat = quandl(stockid,rows=365,format="DataFrame");
       println("Stock: $stockid");
       ndat = length(dat[1,])
       x = [x;collect(1:ndat)];
       y = [y;collect(dat[5,])];
       group = [group;[stockid for j in 1:ndat]];
    end
    nT = round(Int,length(y)/nS)

    return nT,x,y,group
end

function getTSPlot(x,y,group)
    myplot=lineplot(x = x, y = y, group = group)
    xlab!(myplot,title="Time (last X days)")
    ylab!(myplot,title="Closed")
    title!(myplot,title="Stocks")
    myplot.background = "white"
    return myplot
end

function tsplot(x,y,group)
    myplot = getTSPlot(x,y,group);
    myplot
end


###### From now on, there is the implementation of the Efficient Frontier algorithm

function getzbar(x,y,group,nS,nT)
    zbar=zeros(nS);
    for r = 1:nS
        zbar[r] = (y[nT,r] - y[1,r])/3;
    end
    return zbar;
end

function vecToMat(y,nT,nS)
    ymat = zeros(nT,nS);
    for i = 1:nT
        for j = 1:nS
            ymat[i,j] = y[(j-1)*nT + i];    
        end 
    end
    return ymat; 
end

function getVarCovMatrix(x,y,group,nS,nT)
    CM=zeros(nS,nS);
    for c = 1:(nS-1)
       for c1 = (c+1):nS
           CM[c,c1] = cov(y[:,c],y[:,c1]);
       end
    end
    
    for c2 =1:nS
       CM[c2,c2] = var(y[:,c2]);
    end
    M = CM+CM';
    stdevs=sqrt(diag(M));
    return M,stdevs
end


function getEffFrontier(zbar,M,nS)
    unity = ones(length(zbar));
    A = unity' * inv(M) * unity;
    B = unity' * inv(M) * zbar;
    C = zbar' * inv(M) * zbar;
    D = (A .* C) - (B.^2);
    mu = linspace(1,75,nS);
    
    minvar = ((A .* (mu.^2)) - ((2 .* B .* mu) .+ C)) ./ D;
#    minstd = sqrt(minvar);
#    return minvar,minstd
    return mu,minvar
end

function getEffFrontPlot(stdevs,zbar,mu,minvar)
    myplot=lineplot(x = minvar, y = mu)
    myplot=dotplot(x = stdevs, y = zbar)
    xlab!(myplot,title="Standard deviation (%)")
    ylab!(myplot,title="Expected return (%)")
    title!(myplot,title="Efficient frontier Individual securities")
    myplot.background = "white"
    return myplot;
end

function efffrontplot(stdevs,zbar,mu,minvar)
    myplot = getEffFrontPlot(stdevs,zbar,mu,minvar);
    myplot
end

#Write the functions here

end #module
