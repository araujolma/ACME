 function [sys,x0,str,ts,simStateCompliance] = ChbFillDyn(t,x,u,flag,Pars)
%ChbFillDyn Chamber filling dynamics.
%   Detailed explanation goes here.

switch flag

  %%%%%%%%%%%%%%%%%%
  % Initialization %
  %%%%%%%%%%%%%%%%%%
  case 0         
    [sys,x0,str,ts,simStateCompliance] = mdlInitializeSizes(Pars);

  %%%%%%%%%%%%%%%
  % Derivatives %
  %%%%%%%%%%%%%%%
  case 1
    sys = mdlDerivatives(t,x,u,Pars);

  %%%%%%%%%%%%%%%%%%%%%%%%
  % Update and Terminate %
  %%%%%%%%%%%%%%%%%%%%%%%%
  case {2,9}
    sys = []; % do nothing

  %%%%%%%%%%
  % Output %
  %%%%%%%%%%
  case 3
    sys = mdlOutputs(x); 

  otherwise
    DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));
end

% end limintm

%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
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
ts  = [0 0];   % sample time: [period, offset]

% speicfy that the simState for this s-function is same as the default
simStateCompliance = 'DefaultSimState';
end
% end mdlInitializeSizes

%
%=============================================================================
% mdlDerivatives
% Compute derivatives for continuous states.
%=============================================================================
%
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
    
    TubeVol = Pars.sys.Tube.Vol;
    
    TubeFillVolDer = tubeFillVolDer(TubeIntkMassFlow,TubeVol,FldDens,...
    TubeFillVol);

    % Ring
    RingIntkMassFlow = (TubeFillVol>=1.0)*TubeIntkMassFlow;
    RingVol = Pars.sys.Ring.Vol;
    FillFuncCode = Pars.sys.Ring.FillFuncCode;
    FillFuncPars = Pars.sys.Ring.FillFuncPars;
    
    RingFillVolDer = chbFillVolDer(RingIntkMassFlow,RingVol,FldDens,...
    RingFillVol,FillFuncCode,FillFuncPars);
    
    %% Load derivatives into 'sys' array
    sys = 0*x;
    sys(Pars.sim.SttInfo.SttIndx.TubeFillVol) = TubeFillVolDer;
    sys(Pars.sim.SttInfo.SttIndx.RingFillVol) = RingFillVolDer;
    
end

% end mdlDerivatives

%
%=============================================================================
% mdlOutputs
% Return the output vector for the S-function
%=============================================================================
%
function sys = mdlOutputs(x)
    sys = x;
end

% end mdlOutputs

end
