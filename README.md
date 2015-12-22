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
        nS = length(portfolio);
        nT,x,y,group = RobHood.readPortData(portfolio,nS);

        RobHood.tsplot(x,y,group)

"portfolio2.txt" is a ascii file stored in our test folder. It contains two codes of stocks that follow the standard of Quandl. The function tsplot will plot the time series of those stocks for the last 2000 days.

 
