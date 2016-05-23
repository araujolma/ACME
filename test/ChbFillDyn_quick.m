function [ sys,x0,  str,ts, simStateCompliance] = ChbFillDyn(t,x,u,flag,Pars)
switch flag
case 0         
[sys,x0,str,ts,simStateCompliance] = mdlInitializeSizes(Pars);
case 1
sys = mdlDerivatives(t,x,u,Pars);
case {2,9}
sys = []; case 3
sys = mdlOutputs(x); 
otherwise
DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));
end
function [sys,x0,str,ts,simStateCompliance] = mdlInitializeSizes(Pars)
disp 'Starting simulation with ChbFillDyn s-function...'
sizes = simsizes;
sizes.NumContStates  = Pars.sim.SttInfo.NStt;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = Pars.sim.NOut;
sizes.NumInputs      = Pars.sim.InpInfo.NInp;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
str = [];
x0  = Pars.sim.SttInfo.InitSttArry;
ts  = [0 0];   simStateCompliance = 'DefaultSimState';
end
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
TubeIntkMassFlow = OrifMassFlow(ValvPsgArea*Pars.sys.Valv.DchgCoef,...
FldDens,TubeIntkPres-AmbPres);
TubeVol = Pars.sys.Tube.Vol;
TubeFillVolDer = tubeFillVolDer(TubeIntkMassFlow,TubeVol,FldDens,...
TubeFillVol);
RingIntkMassFlow = (TubeFillVol>=1.0)*TubeIntkMassFlow;
RingVol = Pars.sys.Ring.Vol;
FillFuncCode = Pars.sys.Ring.FillFuncCode;
FillFuncPars = Pars.sys.Ring.FillFuncPars;
RingFillVolDer = chbFillVolDer(RingIntkMassFlow,RingVol,FldDens,...
RingFillVol,FillFuncCode,FillFuncPars);
sys = 0*x;
sys(Pars.sim.SttInfo.SttIndx.TubeFillVol) = TubeFillVolDer;
sys(Pars.sim.SttInfo.SttIndx.RingFillVol) = RingFillVolDer;
end
function sys = mdlOutputs(x)
sys = x;
end
end
