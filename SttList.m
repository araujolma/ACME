classdef SttList < NameList
    %SttList Class for handling state lists.
    %   Detailed explanation goes here
    
    properties (SetAccess = protected)
        InitStt
    end
    
    methods
        function List = SttList(varargin)

            if mod(nargin,2) ~= 0
                error 'Wrong (odd) number of arguments.'
            end

            newInitStt = [varargin{2:2:nargin}]';
            names = varargin(1:2:(nargin-1));

            if ~(iscellstr(names) || ischar(names))
                error 'New state names should be strings.'
            end

            List = List@NameList(names{:});
            List.InitStt = [List.InitStt; newInitStt];
            

%             if nargin==0
%                 List.NEntr = 0;
%                 List.EntrIndx = [];
%                 List.EntrName = {};
%             else
%                 if ~iscellstr(varargin)
%                     error 'Input, if nonempty, must consist only of strings.'
%                 end
% 
%                 N = length(varargin);
% 
%                 List.NEntr = N;
%                 List.EntrName = cell(1,N);
%                 for k=1:N
%                     List.EntrIndx.(varargin{k}) = k;
%                     List.EntrName{k} = varargin{k};
%                 end
%                 List.InitStt = zeros(N,1);
%             end
        end
        function addEntr(List,varargin)
            if nargin>0   
                N = nargin-1;
                if mod(N,2) ~= 0
                    error 'Wrong (odd) number of arguments.'
                end
                
                newInitStt = zeros(N/2,1);
                
                newInitStt(:) = varargin{2:2:N};
                names = varargin{1:2:(N-1)};
                
                if ~(iscellstr(names) || ischar(names))
                    error 'New state names should be strings.'
                end
                
                addEntr@NameList(List,names);               
                List.InitStt = [List.InitStt; newInitStt];
            end         
        end
    end
    
end

