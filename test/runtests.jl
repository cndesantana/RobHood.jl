using RobHood 

#function main(portfilename)
    portfilename="./YahooDatabase10.csv";
    portfile = portfilename; 
    portfdat = readdlm(portfile,',');
    portfolio = portfdat[:,1]; 
    description = portfdat[:,2]; 
    
    nS = length(portfolio);
    nT,x,y,group = RobHood.readPortData(portfolio,nS);

    nS,nT,x,y,group,ymat = RobHood.vecToMat(x,y,group);
    zbar = RobHood.getzbar(x,ymat,group,nS,nT);
    M,stdevs = RobHood.getVarCovMatrix(x,ymat,group,nS,nT);
    mu,minvar,minstd = RobHood.getEffFrontier(zbar,M,nS);
    
    RobHood.tsplot(x,y,group)
    RobHood.efffrontplot(stdevs,zbar,mu,minstd,group,"Standard deviation","Expected return (%)")
    RobHood.efffrontplot(stdevs,zbar,mu,minvar,group,"Variance","Expected return (%)")
#end

#main(ARGS[1]);
#main("./YahooDatabase10.csv");
