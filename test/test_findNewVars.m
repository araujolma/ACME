clc
NVar = 0;
VarsStru = [];

teste = 'x = haha(2:5);'
[NVar,VarsStru] = findNewVars(NVar,VarsStru,teste)

teste = '[ y,  z ,w] = magic(2);'
[NVar,VarsStru] = findNewVars(NVar,VarsStru,teste)

teste = 'sys(3:6) = haha(2:5);'
[NVar,VarsStru] = findNewVars(NVar,VarsStru,teste)

teste = 'r ( z ~=1 ) = haha(2:5);'
[NVar,VarsStru] = findNewVars(NVar,VarsStru,teste)

teste = 't ( z ==1 ) = haha(2:5);'
[NVar,VarsStru] = findNewVars(NVar,VarsStru,teste)

teste = '[A,B,C] = Sugou(1454:10000,''teste=teste'');'
[NVar,VarsStru] = findNewVars(NVar,VarsStru,teste)

teste = 'plot( t,A (z== 1) );'
[NVar,VarsStru] = findNewVars(NVar,VarsStru,teste)

teste = 'x(9:end-2) = Sugou(1454:10000);'
[NVar,VarsStru] = findNewVars(NVar,VarsStru,teste)