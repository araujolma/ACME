function [Nvar,VarsStru] = findNewVars(Nvar,VarsStru,cmnd,varargin)
%FindNewVars Finds new variables in command line.
%   Detailed explanation goes here

% disp 'In find new vars!'

if nargin==3
    % not function input. Look for assignments ('=').
    [~,EndIndx] = regexp(cmnd,'.*=');
    str = rmovSpac(cmnd(1:EndIndx-1));
elseif ischar(varargin{1}) && strcmp(varargin{1},'input')
    [BginIndx,~] = regexp(cmnd,'(');
    str = rmovSpac(cmnd(BginIndx:end-1));
end
   
if strcmp(str(1),'[') || strcmp(str(1),'(')
   % brackets!
   str = rmovSpac(str(2:end-1));
   a = regexp(str,'\W');
   if isempty(a)
       % brackets but no commas or spaces. 
       % Single output argument becomes var
       [Nvar,VarsStru] = addVarIfNew(Nvar,VarsStru,str);
   elseif length(a)==1
       %brackets, two output arguments.
       [Nvar,VarsStru] = addVarIfNew(Nvar,VarsStru,str(1:(a(1)-1)));
       [Nvar,VarsStru] = addVarIfNew(Nvar,VarsStru,str(a(1)+1:end));
   else
       %brackets, several output arguments. Here we go:

       % get the first one:
       [Nvar,VarsStru] = addVarIfNew(Nvar,VarsStru,str(1:(a(1)-1)));

       % get the middle ones
       for j=2:length(a)
           if a(j)>a(j-1)+1
               [Nvar,VarsStru] = addVarIfNew(Nvar,VarsStru,str(a(j-1)+1:a(j)-1));
           end
       end

       % get the last one (if so)
       [Nvar,VarsStru] = addVarIfNew(Nvar,VarsStru,str( (a(j)+1):1:end ));
   end
else
   % no brackets: single output argument becomes first var
   [Nvar,VarsStru] = addVarIfNew(Nvar,VarsStru,str);
end
   
end

function [Nvar,VarsStru] = addVarIfNew(Nvar,VarsStru,VarCand)
    if ~isfield(VarsStru,VarCand)
        Nvar = Nvar+1;
        VarsStru.(VarCand)=Nvar;
    end
end