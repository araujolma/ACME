function [ RelMassFlow ] = chbFillFunc(FillVol,FillFuncCode,FillFuncPars)
%chbFillFunc Chamber filling function.
%   Detailed explanation goes here

switch FillFuncCode
    case 1       
        V0 = FillFuncPars.NoMassFlowTrsh;
        RelMassFlow = (FillVol>V0).*(FillVol-V0)/(1.0-V0);
        
    case 2
        RelMassFlow = FillFuncPars.a1*FillVol.^3 + ...
            FillFuncPars.a2*FillVol.^2 + ...
            FillFuncPars.a3*FillVol;
        
    case 3
        RelMassFlow = sqrt(abs(1-(1-FillVol).^2));
        
    otherwise
        error('Unknown filling function code.');
end

end

