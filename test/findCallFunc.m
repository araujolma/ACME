function [isReplFuncCall,CallFuncStru] = findCallFunc(CmndList,...
    ReplFuncStru,VarsStru)
%FindCallFunc Find function calls in command list.
%   Only calls to functions with parentheses are to be identified?

isReplFuncCall = false;
CallFuncStru = [];
NCmnd = length(CmndList);

for k=1:length(ReplFuncStru)
    ReplFuncNameStru.(ReplFuncStru(k).name) = k;
end

for k=2:NCmnd
    k
    CmndList{k}
%     [BginIndx,EndIndx] = regexp(CmndList{k},'\w+(\W|$)')
%     for i=1:length(BginIndx)
%         str = CmndList{k}(BginIndx(i):EndIndx(i))
%     end
%     pause

    [BginIndx,EndIndx] = regexp(CmndList{k},'\w+\(')
    if ~isempty(BginIndx)
        % there are occurences of '('.
        for i=1:length(BginIndx)
            FuncCand = CmndList{k}(BginIndx(i):EndIndx(i)-1)
            if isfield(ReplFuncNameStru,FuncCand)
                indx = ReplFuncNameStru.(FuncCand);
                ReplFuncStru(indx).isCall = true;
                call = ReplFuncStru(indx).lineCall;
                ReplFuncStru(indx).lineCall = [call k];
            end
        end
        
    end
    
    %check string mode!
    %check terminating string, if ')', '(', or ';' ok, 
    %if '.', is struct...
    %check for structs...
end

end

