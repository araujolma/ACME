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
while ~feof(SorcFilePont)
    cmnd = fgets(SorcFilePont);
    NChar = length(cmnd);
    
    if NChar>1
        
        % remove leading and trailing spaces
        cmnd = rmovSpac(cmnd);
        
        NChar = length(cmnd);
        if NChar>1
            % check if it is a commented line
            if strcmp(cmnd(1),'%')==0
                
                % not a commented line. Remove any mid-line comments
                
                kCutOff = 0; k=1; stringMode = false;
                while k<=NChar && kCutOff==0
                    if strcmp(cmnd(k),'''')
                        if stringMode
                            stringMode=false;
                        else
                            stringMode=true;
                        end
                    elseif strcmp(cmnd(k),'%') && ~stringMode
                        kCutOff = k;
                    end
                    
                    k=k+1;
                end
                if kCutOff>1
                    cmnd = cmnd([1:(kCutOff-1) NChar]);
                end
                
                % remove ellipsis
                
                if length(cmnd)>4 && strcmp(cmnd(end-3:end-1),'...')
                    LastCmnd = [LastCmnd,cmnd(1:end-4)]; %#ok<AGROW>
                    ContLastCmnd = true;
                else
                    NValCmnd=NValCmnd+1;
                    CmndList{NValCmnd} = [LastCmnd,cmnd];
                    
                    if ContLastCmnd
                        ContLastCmnd = false;
                        LastCmnd = [];
                    end
                end
                
            end
        end
    end
end

CmndList(NValCmnd+1:end) = [];

end

