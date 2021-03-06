function [str] = rmovSpac(str)
%RmovSpac Remove leading and trailing spaces from string
%   Detailed explanation goes here

if ~isempty(str)
    if regexp(str,[' {',int2str(length(str)),'}'])==1
        str = '';
    else
        if strcmp(str(1),' ') 
            NChar = length(str); j=1;
            while j<=NChar && strcmp(str(j),' ') 
                j=j+1;
            end
            str = str(j:end);
        end

        if strcmp(str(end),' ')
            NChar = length(str); j=NChar;
            while j>0 && strcmp(str(j),' ') 
                j=j-1;
            end
            str = str(1:j);
        end
    end
end

