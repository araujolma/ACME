function [CmndList] = loadCmndListFromFile(SorcFilePont)
%LoadCmndListFromFile Summary of this function goes here
%   Detailed explanation goes here


WordByWord = textscan(SorcFilePont,'%s');
WordByWord = WordByWord{1};

% TODO: REMOVE (MODIFY) THIS TO ALLOW COMMENTS BEFORE FUNCTION HEADER
if length(WordByWord{1})<8 || (strcmp(WordByWord{1}(1:8),'function')==0)
    fclose('all');
    error('Input file is not a MATLAB function.')
end

% the flow:
% keep processing strings with fgets. Remove all comments. 
% once a COMMAND is finished, add it to list (with ending \n).

frewind(SorcFilePont);
CmndList = cell(size(WordByWord)); NValCmnd=0; 
Cont.BlckCmmt = 0; Cont.isElps = false;
while ~feof(SorcFilePont)
    str = fgets(SorcFilePont); str(end) = [];
    
    % here, a command from 'str' is moved to 'cmnd'. 
    % 'str' may be empty or not, corresponding to the case where 
    % there are many commands in 'str'.
    
    if ~Cont.isElps
        Cont.Pare = 0; Cont.Brak = 0; Cont.Curl = 0;
        cmnd = [];
    end
    
    while ~isempty(str)
        [cmnd,str,Cont] = getCmnd(cmnd,str,Cont);
        if ~Cont.isElps && ~isempty(cmnd)
            NValCmnd=NValCmnd+1;
            CmndList{NValCmnd} = cmnd;
            cmnd = [];
        end
    end
end

CmndList(NValCmnd+1:end) = [];
end

function [cmnd,str,Cont] = getCmnd(cmnd,str,Cont)
    
% remove leading and trailing spaces
str = rmovSpac(str);
if isempty(str)
    return;
end
    
% check for block comment indicators
if strcmp(str(1),'%')==0 && Cont.BlckCmmt==0
        
    % line reading mode
    k=1; isStrgMode = false;
    while k<=length(str)
        if strcmp(str(k),'''')
            if (k==1)||(isempty(regexp(str(k-1:k),...
                    '[\w,\),\]]''','once')))
                % found single quote. Switch string mode
                isStrgMode = ~isStrgMode;
            end
        elseif ~isStrgMode 

            switch str(k)
                case '%'
                    % comment mode
                    cmnd = [cmnd,rmovSpac(str(1:(k-1)))]; %#ok<*AGROW>
                    str = [];
                    Cont.isElps = false;
                    return;
                case '.'
                    % this may be a case of ellipsis!
                    if (k<=length(str)-2) && strcmp(str(k+1:k+2),'..')
                        % it is indeed a case of ellipsis.
                        % leave the while loop
                        Cont.isElps = true;
                        cmnd = [cmnd,rmovSpac(str(1:(k-1)))];
                        str = [];
                        return;
                    end
                case '('
                    Cont.Pare = Cont.Pare+1;
                case '['
                    Cont.Brak = Cont.Brak+1;
                case '{'
                    Cont.Curl = Cont.Curl+1;
                case ')'
                    Cont.Pare = Cont.Pare-1;
                case ']'
                    Cont.Brak = Cont.Brak-1;
                case '}'
                    Cont.Curl = Cont.Curl-1;
                case {',',';'}
                    if Cont.Pare==0 && Cont.Brak==0 && Cont.Curl==0
                        % end of command! put it in store 
                        cmnd = [cmnd,rmovSpac(str(1:k))];
                        % rest of the string should still be processed
                        if k<length(str)
                            str = rmovSpac(str(k+1:end));
                        else
                            str = [];
                        end
                        Cont.isElps = false;
                        return;
                    end
            end
            
            % Should not be necessary, since the input code should be
            % running, but...
            if Cont.Pare<0 || Cont.Brak<0 || Cont.Curl<0
                error(['Invalid MATLAB syntax. Command: ',...
                    str])
            end
        end
        k=k+1;
    end
    
    % end of command! put it in store 
    cmnd = [cmnd,rmovSpac(str)];
    str = [];
    Cont.isElps = false;
    return;
else
    if length(str)>1
        if strcmp(str,'%{')
            Cont.BlckCmmt = Cont.BlckCmmt+1;
        elseif strcmp(str,'%}')
            Cont.BlckCmmt = Cont.BlckCmmt-1;
        end
    end
    str = [];
    Cont.isElps = false;
end

end

