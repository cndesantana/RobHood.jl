using RobHood 

portfile = "./portfolio2.txt";
portfolio = readdlm(portfile,'\n');
nS = length(portfolio);

nT,x,y,group = RobHood.readPortData(portfolio,nS);
ymat = RobHood.vecToMat(y,nT,nS);
zbar = RobHood.getzbar(x,ymat,group,nS,nT);
M,stdevs = RobHood.getVarCovMatrix(x,ymat,group,nS,nT);
mu,minvar = RobHood.getEffFrontier(zbar,M,nS);

RobHood.tsplot(x,y,group)
RobHood.efffrontplot(stdevs,zbar,mu,minvar)
