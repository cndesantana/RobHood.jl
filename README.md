# RobHood.jl

## Open platform to study market data

To install, run in your julia terminal: 

        Pkg.clone("https://github.com/cndesantana/RobHood.jl")

Once the package is installed, you can call it by running the following command in your julia terminal: 

        using RobHood

We are just starting the development of RobHood.jl. For now the only functionality is to plot the time series of stocks listed in a portfolio file. 

As one example, you can run our test script from your julia terminal:


        using RobHood

        portfile = "./portfolio2.txt";
        portfdat = readdlm(portfile,',');
        portfolio = portfdat[:,1];
        nS = length(portfolio);
        nT,x,y,group = RobHood.readPortData(portfolio,nS);

        RobHood.tsplot(x,y,group)

"portfolio2.txt" is a ascii file stored in our test folder. It contains two codes of stocks that follow the standard of Quandl. The function tsplot will plot the time series of those stocks for the last 2000 days.

Another example:

        using RobHood

To read the portfolio file with the list of stocks we will study

        portfilename="./YahooDatabase10.csv";
        portfile = portfilename;
        portfdat = readdlm(portfile,',');
        portfolio = portfdat[:,1];
        description = portfdat[:,2];
   
To import from internet the stock time series for each stock id in the portfolio file

        nS = length(portfolio);
        nT,x,y,group = RobHood.readPortData(portfolio,nS);

To calculate the Eff. Frontier

        nS,nT,x,y,group,ymat = RobHood.vecToMat(x,y,group);
        zbar = RobHood.getzbar(x,ymat,group,nS,nT);
        M,stdevs = RobHood.getVarCovMatrix(x,ymat,group,nS,nT);
        mu,minvar,minstd = RobHood.getEffFrontier(zbar,M,nS);
   
To plot the Eff. Frontier results (plotting only the results for the variance in X-axis)

        RobHood.tsplot(x,y,group)
        RobHood.efffrontplot(stdevs,zbar,mu,minvar,group)

"YahooDatabase10.csv" is a ascii file stored in our test folder. It contains 30 codes of stocks that follow the standard of Quandl.
