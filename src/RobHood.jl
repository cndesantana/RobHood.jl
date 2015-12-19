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

function removeLowValues!(x,y,group,epsilon)
    posLowValues = find(y.<= epsilon);
    deleteat!(y,);
    deleteat!(group,find(y.<= epsilon));
    deleteat!(x,find(y.<= epsilon));
    nS = length(unique(group)); 
    nT = round(Int,length(y)/nS)
end

function vecToMat(x,y,group,epsilon)
#    removeLowValues!(x,y,group,epsilon)
    ymat = zeros(nT,nS);
    for i = 1:nT
        for j = 1:nS
            ymat[i,j] = y[(j-1)*nT + i];    
        end 
    end
    return nS,nT,x,y,group,ymat; 
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
    minstd = sqrt(minvar);
    return mu,minvar,minstd
end

function getEffFrontPlot(stdevs,zbar,mu,minstd,group)
    s = scatterplot(x = stdevs, y = zbar, group = unique(group));
    eh = lineplot(x = minstd, y = mu);
#Make names unique in ef line
    eh.data[1].name = eh.marks[1].from.data = eh.scales[1].domain.data = eh.scales[2].domain.data = eh.scales[3].domain.data = "table2";
#Since same axis range, just push data and line mark onto scatterplot graph
    push!(s.data, eh.data[1]);
    push!(s.marks, eh.marks[1]);

    xlim!(s,min=0,max=maximum([stdevs minstd]));
    xlab!(s,title="Standard deviation (%)");
    ylab!(s,title="Expected return (%)");
    title!(s,title="Efficient frontier Individual securities");
    s.background = "white";
    return s;
end

function efffrontplot(stdevs,zbar,mu,minstd)
    myplot = getEffFrontPlot(stdevs,zbar,mu,minstd);
    myplot
end

#Write the functions here

end #module
