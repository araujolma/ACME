function [RelFillVolDer] = chbFillVolDer(InptMassFlow,ChbVol,FldDens,...
    FillVol,FillFuncCode,FillFuncPars)
%chbFillVolDer Chamber filled volume derivative
%   Detailed explanation goes here

RelFillVolDer = InptMassFlow*...
    (1.0-chbFillFunc(FillVol,FillFuncCode,FillFuncPars))/(ChbVol*FldDens);

end

