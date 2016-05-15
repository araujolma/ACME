classdef TensileData
    properties
      Material
      SampleNumber
      Stress
      Strain
    end
    properties (Dependent)
        Modulus
    end
    
    methods
        function td = TensileData(material,samplenum,stress,strain)
            if nargin > 0
                td.Material = material;
                td.SampleNumber = samplenum;
                td.Stress = stress;
                td.Strain = strain;
            end
        end
        function obj = set.Material(obj,material)
            if (strcmpi(material,'aluminum') ||...
               strcmpi(material,'stainless steel') ||...
               strcmpi(material,'carbon steel'))
            obj.Material = material;
            else
                error('Invalid Material')
            end
        end
        function m = get.Modulus(obj)
            ind = find(obj.Strain > 0);
            m = mean(obj.Stress(ind)./obj.Strain(ind));
        end
        function obj = set.Modulus(obj,~)
            fprintf('%s%d\n','Modulus is: ',obj.Modulus)
            error('You cannot set Modulus property');
        end
        function disp(td)
            sprintf('Material: %s\nSample Number: %g\nModulus: %1.5g\n',...
                td.Material,td.SampleNumber,td.Modulus)
        end
        function plot(td,varargin)
            plot(td.Strain,td.Stress,varargin{:})
            title(['Stress/Strain plot for Sample ',...
            num2str(td.SampleNumber)])
            xlabel('Strain %')
            ylabel('Stress (psi)')
        end
    end
end