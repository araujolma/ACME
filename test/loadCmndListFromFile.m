function [CmndList] = loadCmndListFromFile(SorcFilePont)
%LoadCmndListFromFile Summary of this function goes here
%   Detailed explanation goes here


WordByWord = textscan(SorcFilePont,'%s');
WordByWord = WordByWord{1};

if length(WordByWord{1})<8 || (strcmp(WordByWord{1}(1:8),'function')==0)
    fclose('all');
    error('Input file is not a MATLAB function.')
end

frewind(SorcFilePont);
CmndList = cell(size(WordByWord)); NValCmnd=0; 
ContLastCmnd = false; LastCmnd = []; 
NestBlckCmmt = 0;

while ~feof(SorcFilePont)
    cmnd = fgets(SorcFilePont);
    NChar = length(cmnd);
    
    if NChar>1
        
        % remove leading and trailing spaces
        cmnd = rmovSpac(cmnd)
        
        NChar = length(cmnd);
        if NChar>1
            % check if it is not a commented line
            if strcmp(cmnd(1),'%')==0 && NestBlckCmmt==0
                
                % not a commented line. Remove any mid-line comments
                isElps = false; isCmmtLine = false; 
                k=1; stringMode = false;
                while k<=NChar && ~isCmmtLine
                    if strcmp(cmnd(k),'''')
                        if (k==1)||(isempty(regexp(cmnd(k-1:k),...
                                '[\w,\),\]]''','once')))
                            if stringMode
                                stringMode=false;
                            else
                                stringMode=true;
                            end
                        end
                    elseif ~stringMode 
                        if strcmp(cmnd(k),'%')
                            isCmmtLine = true;
                            cmnd = cmnd([1:(k-1) NChar]);
                        elseif (k<=NChar-2) && strcmp(cmnd(k:k+2),'...')
                            % this may be a case of ellipsis!
                            isCmmtLine = true;
                            cmnd = cmnd([1:(k-1) NChar]);
                            isElps = true;
                        end
                    end
                    
                    k=k+1;
                end
                
                % remove ellipsis (if so)                
                if isElps
                    LastCmnd = [LastCmnd,rmovSpac(cmnd(1:end-1))]; %#ok<AGROW>
                    ContLastCmnd = true;
                else
                    NValCmnd=NValCmnd+1;
                    CmndList{NValCmnd} = [LastCmnd,cmnd];
                    
                    if ContLastCmnd
                        ContLastCmnd = false;
                        LastCmnd = [];
                    end
                end
                
            elseif length(cmnd)>1 
                if strcmp(cmnd(1:2),'%{')
                    NestBlckCmmt = NestBlckCmmt+1;
                elseif strcmp(cmnd(1:2),'%}')
                    NestBlckCmmt = NestBlckCmmt-1;
                end
            end
        end
    end
end

CmndList(NValCmnd+1:end) = [];

end

