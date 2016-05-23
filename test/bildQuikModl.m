function [CmndList] = bildQuikModl(SfunNameXten)
%BildQuikModl Build a quick-running model based on a previous one.
%   Detailed explanation goes here

clc
SorcFilePont = fopen(SfunNameXten,'r');
TargFilePont = fopen([SfunNameXten(1:end-2),'_quick.m'],'w');

CmndList = loadCmndListFromFile(SorcFilePont);
NValCmnd = numel(CmndList);
% HERE, CmndList holds all the useful commands.

% next: look for function calls, beggining with internal functions
% rename their internal variables with 'iv'n, where n is the 
% smallest number for which there is no conflict.

% Look for subfunctions definition
SubfLine = zeros(NValCmnd-1,1);
SubfNmes = cell(NValCmnd-1,1);
NSubf = 0;
for k=2:NValCmnd
    if length(CmndList{k})>9 
        cmnd = CmndList{k};
        FrstNineChar = cmnd(1:9);        
        
        if strcmp(FrstNineChar,'function ') || strcmp(FrstNineChar,'function[')
            % function declaration found.
            
            NSubf = NSubf+1;
            SubfLine(NSubf) = k;
        
            % Get function name
            [BginIndx,EndIndx] = regexp(cmnd,'=[ ]*\w+[ ]*\(');
%             Name = cmnd(BginIndx:EndIndx);
%             Name = rmovSpac(Name(2:end-1));
            SubfNmes{NSubf} = rmovSpac(cmnd(BginIndx+1:EndIndx-1));
            
            % Get number of arguments
%             SubfNArgn
            
        end
    end 
end

if NSubf>0
    SubfLine = SubfLine(1:NSubf);
    SubfNmes = SubfNmes(1:NSubf);
end

SubfLine
SubfNmes

% Get variables list
LastFuncCmndLine = SubfLine(1)-1
VarList = cell(LastFuncCmndLine,1);
VarsStru = [];

% output arguments for main function
CmndList{1}
[BginIndx,EndIndx] = regexp(CmndList{1},'.*=');
OutpStr = rmovSpac(CmndList{1}(8+BginIndx:EndIndx-1))

% check if output expression is bracketed

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO: put this code into a separate function.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Nvar = 1; % TRIGGER WARNING: is it possible to have no outputs?
if strcmp(OutpStr(1),'[')
    OutpStr = rmovSpac(OutpStr(2:end-1))
    [a,~] = regexp(OutpStr,'\W')
    if isempty(a)
        % brackets but no commas or spaces. 
        % Single output argument becomes first var
        VarsStru.(OutpStr(2:(end-1))) = 1;
    else
        %brackets, several output arguments. Here we go:
        VarsStru.(OutpStr(1:a(1)-1)) = Nvar;
        for j=2:length(a)
            if a(j)>a(j-1)+1
                Nvar = Nvar+1;
                VarsStru.(OutpStr(a(j-1)+1:a(j)-1)) = Nvar;
            end
        end
        Nvar=Nvar+1;
        VarsStru.( OutpStr( (a(j)+1):1:end ) ) = Nvar;
    end
else
    % no brackets: single output argument becomes first var
    VarsStru.(OutpStr) = 1;
end
    
VarsStru

% input arguments for main function
j = regexp(CmndList{1},'\(')
InptStr = CmndList{1}(j+1:end)



for k=2:LastFuncCmndLine
    vars = regexp(CmndList{k},'','match');
end



% Look for function calls



for k=1:NValCmnd
    fprintf(TargFilePont,'%s',CmndList{k});
end


fclose('all');

% for next step (analyzing .mdl to get the sfunction...)

% % append '.mdl' to the name of the model, if so.
% if length(ModlName)<4 || strcmp(ModlName(end-3:end),'.mdl')==0
%     ModlNameXten = [ModlName,'.mdl'];
% end


% initFileName = ['init_',ModlName];
% if ~exist(initFileName,'file') || ~exist(ModlNameXten,'file');
%     error('Model or initiation file not found.')
% end

end