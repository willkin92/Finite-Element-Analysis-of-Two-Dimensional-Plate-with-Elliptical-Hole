%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%File to ceate the mesh for the Wall Plane Stress analysis.               %
%Loading : Lateral Point Static In-plane Load at top left corner.         %
%BC : All bottom nodes fixed.                                             %  
%Creates mesh.xlsx, containing the mesh data for the FE solver.           % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MESH.XLSX format :                                                       %  
%Sheet1 : Node                                                            %  
%Node | X | Y | XForce | YForce | XBC | YBC                               %  
%                                                                         %
%Sheet 2 : Element                                                        %
%Element | BL | BR | TR | TL                                              %
%                                                                         %
%Sheet 3 : material                                                       %
%Young's Modulus                                                          %
%---------------                                                          %
%Poisson's Ratio                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Author : Ashutosh                                                        %
%On : 24th July, 2017                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

inPath = 'Wall2D.xlsx';
outPath = 'mesh.xlsx';

mesh=xlsread(inPath,'Mesh');
bl = mesh(1,:);
tr = mesh(2,:);
partsX= mesh(3,1);
partsY= mesh(3,2);

mat=xlsread(inPath,'Material');
E=mat(1);
poissons=mat(2);

force=xlsread(inPath,'Force');

%Writing the nodal coordinates
node = [];    %Contains the entire nodal info
width = tr(1) - bl(1);
height = tr(2) - bl(2);
for j=0:partsY
    
    for i=0:partsX
        
        num = (j * (partsX + 1)) + (i+1);
        node(num,1) = num;
        node (num,2) = i * width / (partsX);
        node (num,3) = j * height / (partsY);
        if(i == 0 && j == partsY)
            node(num,4)=force;
        else
            node(num,4)=0;
        end
        node(num,5)=0;
        if(j == 0)
            node(num,6)=1;
            node(num,7)=1;
        else
            node(num,6)=0;
            node(num,7)=0;
        end
        
    end
    
end

xlswrite(outPath,node,'node');

%Writing the element connectivity
element = [];
for j=1:partsY
    
    for i=1:partsX
        
        num = (j - 1)*partsX + i;
        element(num,1) = num;
        element(num,2) = (j-1)*(partsX+1) + i;
        element(num,3) = element(num,2) + 1;
        element(num,5) = j*(partsX+1)+ i;
        element(num,4) = element(num,5) + 1;
        
    end
    
end
xlswrite(outPath,element,'element');

%Writing the material properties
xlswrite(outPath,[E;poissons],'material');