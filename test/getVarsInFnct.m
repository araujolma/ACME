function [NVar,VarsStru,isReplFuncCall,CallFuncStru] = getVarsInFnct(...
    CmndList,ReplFuncStru)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% This approach to internal variables and IO variables is admittedly bad
% and lazy (the idea was not to change findNewVars). 
% It does work, however...

disp 'Beggining getVarsInFnct...'
VarsStru = [];
NVar = 0; 

[NVar,VarsStru] = findNewVars(NVar,VarsStru,CmndList{1}(9:end),'input');
% special operations with 5th argument? (external parameters for sfunction) 
[NVar,VarsStru] = findNewVars(NVar,VarsStru,CmndList{1}(9:end));

IOVarsStru = VarsStru

for k=2:numel(CmndList)
    [NVar,VarsStru] = findNewVars(NVar,VarsStru,CmndList{k});
end

IntVarsStru = VarsStru;
fnames = fieldnames(IOVarsStru);
for i=1:length(fnames)
    IntVarsStru = rmfield(IntVarsStru,fnames{i});
end

IntVarsStru

isReplFuncCall = false;
% CallFuncStru = 0;
% Find function calls
[NCallFunc,CallFuncStru] = findCallFunc(CmndList,ReplFuncStru,VarsStru)
disp 'Leaving getVarsInFnct...'
end

