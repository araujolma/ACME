function [RelFillVolDer] = tubeFillVolDer(InptMassFlow,TubeVol,FldDens,...
    FillVol)
%tubeFillVolDer Tube filled volume derivative
%   Detailed explanation goes here

if FillVol<1
    RelFillVolDer = InptMassFlow/TubeVol/FldDens;
else
    RelFillVolDer = 0.0;
end

end

