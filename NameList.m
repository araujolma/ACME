classdef NameList < handle
    %NameList Class for handling Name-value pair lists.
    %   Detailed explanation goes here
    
    properties (SetAccess = protected)
        NEntr;
        EntrIndx;
        EntrName;
    end
    
    methods 
        function List = NameList(varargin)
            if nargin==0
                List.NEntr = 0;
                List.EntrIndx = [];
                List.EntrName = {};
            else
                if ~iscellstr(varargin)
                    error 'Input, if nonempty, must consist only of strings.'
                end

                N = length(varargin);

                List.NEntr = N;
                List.EntrName = cell(1,N);
                for k=1:N
                    List.EntrIndx.(varargin{k}) = k;
                    List.EntrName{k} = varargin{k};
                end
            end
        end
        
        function addEntr(List,varargin)
            if nargin>0
                
                if ~iscellstr(varargin)
                    error 'Input, if nonempty, must consist only of strings.'
                end

                N = List.NEntr;
                newN = N+length(varargin);
                newEntrIndx = List.EntrIndx;
                newEntrName = List.EntrName;
                
                for k=1:(newN-N)
                    newEntrIndx.(varargin{k}) = k+N;
                    newEntrName{k+N} = varargin{k};
                end
                              
                List.NEntr = newN;
                List.EntrIndx = newEntrIndx;
                List.EntrName = newEntrName;
            end
        end

    end
    
end

