function [CmndList] = bildQuikModl(SfunNameXten)
%BildQuikModl Build a quick-running model based on a previous one.
%   Detailed explanation goes here

%% Preparations, command loading

clc
fclose('all');
SorcFilePont = fopen(SfunNameXten,'r');
TargFilePont = fopen([SfunNameXten(1:end-2),'_quick.m'],'w');

CmndList = loadCmndListFromFile(SorcFilePont);
NValCmnd = numel(CmndList);
% HERE, CmndList holds all the useful commands.

%% Look for replaceable functions

%For now, only the functions in the current directory
ReplFnctListStru = dir(); 

% get only the .m files
elimArry = zeros(size(ReplFnctListStru));
j=0;
for k=1:length(ReplFnctListStru)
    name = ReplFnctListStru(k).name;
    if length(name)<2 || strcmp(name(end-1:end),'.m')==0
        j=j+1;
        elimArry(j) = k;
    end
end

ReplFnctListStru(elimArry(1:j)) = [];
ReplFnctNameList = {ReplFnctListStru(:).name};
NReplFnct = length(ReplFnctNameList);

% for k=1:NReplFnct
%     SorcFilePont = fopen(SfunNameXten,'r');
% end


%% Look for function calls inside main function
% next: look for function calls, beggining with internal functions
% rename their internal variables with 'iv'n, where n is the 
% smallest number for which there is no conflict.

% Look for subfunction definitions
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
            SubfNmes{NSubf} = rmovSpac(cmnd(BginIndx+1:EndIndx-1));
            
        end
    end 
end

if NSubf>0
    SubfLine = SubfLine(1:NSubf);
    SubfNmes = SubfNmes(1:NSubf);
    SubfLine
    SubfNmes
    % Get variables list
    LastFuncCmndLine = SubfLine(1)-1
else
    LastFuncCmndLine = NValCmnd;
end


% check called functions;
% for each called function (clear from internal function calls):
%   get command list from file (or subf.)
%   substitute internal variables by unique names to avoid conflict
%   substitute the function calls by their codes themselves in the higher
%   function

%%%%%%%%%%%%%%%%%%%%%%
VarsStru = [];
Nvar = 0; 

[Nvar,VarsStru] = findNewVars(Nvar,VarsStru,CmndList{1}(9:end),'input');
% special operations with 5th argument?
[Nvar,VarsStru] = findNewVars(Nvar,VarsStru,CmndList{1}(9:end));

for k=2:LastFuncCmndLine
    [Nvar,VarsStru] = findNewVars(Nvar,VarsStru,CmndList{k});
end
%%%%%%%%%%%%%%%%%%%%%%


% HERE, all variables are mapped.

% TODO: Look for external function calls

%% Next steps


for k=1:NValCmnd
    fprintf(TargFilePont,'%s\n',CmndList{k});
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