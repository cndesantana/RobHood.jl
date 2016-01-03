# version 0.1

module RobHood 

using Vega
using Quandl

#Need to download only the new data.
#To do this, we need to store the current stock time series in *.jld files
#Then, for each new download of data of stock named ID, we should:
#-first: load any possible local file named ID.jld
#-then: to compare the time series (x) in the ID.jld file with the one we want to download (we need to calculate the time series before downloading it). 
#-So we will only download the data we still don't have locally stored. 

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
    xlab!(myplot,title="Time (days)")
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

# To activate this function we need to change the runtests.jl file in order to add an "epsilon" as a parameter
function removeLowValues!(x,y,group,epsilon)
    posLowValues = find(y.<= epsilon);
    deleteat!(y,);
    deleteat!(group,find(y.<= epsilon));
    deleteat!(x,find(y.<= epsilon));
    nS = length(unique(group)); 
    nT = round(Int,length(y)/nS)
end

"""
 Function to convert a vector containing stock data into a matrix

 Parameters: 
 (x, y, group) =  (vector of time steps, vector of stock data, group: vector stock id's)

---
 Each different time step (x) corresponds to a row in the resulting matrix

 Each different stock id (group) corresponds to a column in the matrix

 The values of the y-vector are disposed in the matrix according to their respective x, and group.

---
 This function returns the number of stocks, the number of time steps, the vectors x, y, and group, and the resulting matrix ymat.
"""
function vecToMat(x,y,group)
#    removeLowValues!(x,y,group,epsilon)
    nS = length(unique(group)); 
    nT = round(Int,length(y)/nS)
    ymat = zeros(nT,nS);
    for i = 1:nT
        for j = 1:nS
            ymat[i,j] = y[(j-1)*nT + i];    
        end 
    end
    return nS,nT,x,y,group,ymat; 
end

"""
   Function to calculate the Covariance matrix of the time series of stock data

   Parameters:

   -x: matrix of time (each column is a stock, each row is a time step)

   -y: matrix of time series of stock data (each column is a stock, each row is a time step)

   -group: the id of the stock

   -nS: number of stocks

   -nT: number of time steps

---
   This function returns:

   -M: covariance matrix 

   -stdevs: standard deviation
"""
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

"""
   Function to calculate the Efficient Frontier

   Parameters:

   -zbar: 

   -M: 

   -ns: Number of stocks  

---
   This function returns:

   -mu: expected return

   -minvar: variance

   -minstd: standard deviation
"""
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

"""
   Function to build the Vega.jl plotting object for the Efficient Frontier.
  
   Parameters:

   -stdevs: standard deviation

   -zbar: expected return 

   -minstd: standard deviation 

   -mu: expected return 

---  
   This function returns a Vega.jl plotting object
"""
function getEffFrontPlot(stdevs,zbar,mu,minstd,group,xlab_,ylab_)
    eff = layer(scatterplot(x = stdevs, y = zbar, group = unique(group)), lineplot(x = minstd, y = mu) );
#Make names unique in ef line

    xlim!(eff,min=0,max=maximum([stdevs minstd]));
    xlab!(eff,title=xlab_);
    ylab!(eff,title=ylab_);
    title!(eff,title="Efficient frontier Individual securities");
    eff.background = "white";
    return eff;
end

"""
   Function to build the plotting object for the Efficient Frontier.

   Parameters:

   -stdevs: standard deviation

   -zbar: expected return 

   -minstd: standard deviation 

   -mu: expected return 

---
   This function will call getEffFrontPlot in order to build the plotting object
"""
function efffrontplot(stdevs,zbar,mu,minstd,group,xlab_,ylab_)
    myplot = getEffFrontPlot(stdevs,zbar,mu,minstd,group,xlab_,ylab_);
    myplot
end

#Write the functions here

end #module
