function sys = mdlDerivatives(t,x,u,Pars)
TubeFillVol = x(Pars.sim.SttInfo.SttIndx.TubeFillVol);
RingFillVol = x(Pars.sim.SttInfo.SttIndx.RingFillVol);
TubeIntkPres = u(Pars.sim.InpInfo.InpIndx.TubeIntkPres);
FldDens = Pars.sys.gen.FldDens;
AmbPres = Pars.sys.gen.AmbPres;
tValvOpen = Pars.sys.Valv.OpenTime;
if t < tValvOpen
ValvPsgArea = t* Pars.sys.Valv.MaxArea / tValvOpen;
else
ValvPsgArea = Pars.sys.Valv.MaxArea;
end
TubeIntkMassFlow = OrifMassFlow(ValvPsgArea*Pars.sys.Valv.DchgCoef,FldDens,TubeIntkPres-AmbPres);
TubeVol   = Pars.sys.Tube.Vol; 
TubeFillVolDer = tubeFillVolDer(TubeIntkMassFlow,TubeVol,FldDens,TubeFillVol);
RingIntkMassFlow= (TubeFillVol>=1.0)*TubeIntkMassFlow;
RingVol = Pars.sys.Ring.Vol;
FillFuncCode= Pars.sys.Ring.FillFuncCode;
FillFuncPars= Pars.sys.Ring.FillFuncPars;
RingFillVolDer = chbFillVolDer(RingIntkMassFlow,RingVol,FldDens,RingFillVol,FillFuncCode,FillFuncPars);
sys = 0*x;
sys(Pars.sim.SttInfo.SttIndx.TubeFillVol) = TubeFillVolDer; 
sys(Pars.sim.SttInfo.SttIndx.RingFillVol) = RingFillVolDer;
end