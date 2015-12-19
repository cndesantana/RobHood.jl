using RobHood 

function main(portfilename)
    portfile = portfilename; 
    portfdat = readdlm(portfile,',');
    portfolio = portfdat[:,1]; 
    description = portfdat[:,2]; 
    
    nS = length(portfolio);
    nT,x,y,group = RobHood.readPortData(portfolio,nS);
    ymat = RobHood.vecToMat(y,nT,nS);
    zbar = RobHood.getzbar(x,ymat,group,nS,nT);
    M,stdevs = RobHood.getVarCovMatrix(x,ymat,group,nS,nT);
    mu,minvar,minstd = RobHood.getEffFrontier(zbar,M,nS);
    
    RobHood.tsplot(x,y,group)
    RobHood.efffrontplot(stdevs,zbar,mu,minstd)
end

main(ARGS[1]);
