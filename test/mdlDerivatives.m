function sys = mdlDerivatives(t,x,u,Pars)
    %% Load States and inputs
    TubeFillVol = x(Pars.sim.SttInfo.SttIndx.TubeFillVol);
    RingFillVol = x(Pars.sim.SttInfo.SttIndx.RingFillVol);
    
    TubeIntkPres = u(Pars.sim.InpInfo.InpIndx.TubeIntkPres);
    %% Calculate derivatives
    
    % gen
    FldDens = Pars.sys.gen.FldDens;
    AmbPres = Pars.sys.gen.AmbPres;
     
    % valve
    tValvOpen = Pars.sys.Valv.OpenTime;
    if t < tValvOpen
        ValvPsgArea = t* Pars.sys.Valv.MaxArea / tValvOpen;
    else
        ValvPsgArea = Pars.sys.Valv.MaxArea;
    end
    
    % tube
    TubeIntkMassFlow = OrifMassFlow(ValvPsgArea*Pars.sys.Valv.DchgCoef,...
        FldDens,TubeIntkPres-AmbPres);
    
    TubeVol   = Pars.sys.Tube.Vol; 
    TubeFillVolDer = tubeFillVolDer(TubeIntkMassFlow,TubeVol,FldDens,...
    TubeFillVol);
    
    % Ring
    RingIntkMassFlow= (TubeFillVol>=1.0)*TubeIntkMassFlow;
    RingVol = Pars.sys.Ring.Vol;
    FillFuncCode  ... ahaha
        = Pars.sys.Ring.FillFuncCode;
    FillFuncPars= Pars.sys.Ring.FillFuncPars;
    
    RingFillVolDer = chbFillVolDer(RingIntkMassFlow,... hahaha
        RingVol,FldDens,...
    RingFillVol,FillFuncCode,FillFuncPars);
%     Teste=[akma]'kmkm%ImportantVar = 3;
    
    
    % é string: [\s, \,, \(, \[, \*, =, ]'
    % não é:    [\w, \), \], ]'
    
    %% Load derivatives into 'sys' array
    sys = 0*x;
    sys(Pars. ... thujnkmmk
        sim.SttInfo.  ... Teste steste teste teste
        SttIndx.TubeFillVol... suga!!
        ) = TubeFillVolDer; % Tomara que funcione!
    sys(Pars.sim.SttInfo.SttIndx.RingFillVol) = RingFillVolDer;
    
end