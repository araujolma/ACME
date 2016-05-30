function [Nvar,VarsStru] = findNewVars(Nvar,VarsStru,cmnd,varargin)
%FindNewVars Finds new variables in command line.
%   [Nvar,VarsStru] = findNewVars(Nvar,VarsStru,cmnd)
%   finds new vars in string 'cmnd', assuming it is a single command line.
%   Example: if cmnd = 'x = sqrt(pi)/y;', 'x' is saved as a new variable.

if nargin==3
    % not function input. Look for assignments: '='.
    BginIndx = regexp(cmnd,'[^=<>~]=[^=]');
    if isempty(BginIndx)
        return;
    else
%         cmnd
%         BginIndx
        str = rmovSpac(cmnd(1:BginIndx));
    end
elseif ischar(varargin{1}) && strcmp(varargin{1},'input')
    % it is a function input. Look for parenthesis: '('.
    BginIndx = regexp(cmnd,'(');
    if isempty(BginIndx)
        return;
    else
        str = rmovSpac(cmnd(BginIndx:end-1)); %end-1 removes the ')'.
    end
else 
    error('Unidentified fourth argument.')
end
   
if strcmp(str(1),'[') || strcmp(str(1),'(')
   % brackets!
   str = rmovSpac(str(2:end-1)); %end-1 removes the ')' or ']'.
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
    
    bginIndx = regexp(VarCand,'\(');
    if ~isempty(bginIndx)
        bginIndx = bginIndx(1);
        [~,endIndx] = regexp(VarCand,'\)');
        endIndx = endIndx(end);
%         if length(bginIndx)>1
%             error(['Too many parentheses in input string: ',VarCand])
%         else
        VarCand(bginIndx:endIndx) = [];
        VarCand = rmovSpac(VarCand);
    end
    
    if ~isfield(VarsStru,VarCand)
        Nvar = Nvar+1;
        VarsStru.(VarCand)=Nvar;
    end
end