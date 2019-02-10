%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%2D FE solver for a problem. Acts on the file mesh.xlsx containing the    %
%node and element tables in a pre-specified format and writes all the     %
%results to the file out.xlsx (stress,strain,displacement).               &
%Element used : 2D plane quadrilateral with linear interpolation.         %
%Material model : Linear, Elastic, Isotropic (Homogeneous), Plane Stress  %
%(for the time being)                                                     %
%Other limitation : Displacement fixed (BC) value = 0                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ASSUMPTIONS :                                                            %
%1. No body forces.                                                       %
%2. Only nodal loads applied.(tractions divided between surrounding nodes)%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Author : Ashutosh                                                        %
%On : 29th June, 2017                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
clear;

inPath = 'mesh.xlsx';
outPath = 'out.xlsx';


nodeData = xlsread (inPath,'node');
%Node location
node = nodeData (:,2:3);

%Element connectivity
element = xlsread (inPath,'element');
element = element (:,2:5);

%Nodal forces
force = [];
for  i=1:length(nodeData(:,1))
    
    force = [force;nodeData(i,4);nodeData(i,5)];
    
end

%Boundary condition (1=restrained, 0=free)
bcFree = [];
bcFixed = [];
for  i=1:length(nodeData(:,1))
    
    if nodeData(i,6) == 0
        bcFree = [bcFree 2*i-1]; 
    else 
        bcFixed = [bcFixed 2*i-1]; 
    end
    
    if nodeData(i,7) == 0
        bcFree = [bcFree 2*i]; 
    else 
        bcFixed = [bcFixed 2*i]; 
    end
    
end

%Material data
materialData = xlsread('Input.xlsx','material');
E = materialData(1);
poisson = materialData(2);

%Program constants
NGPX = 2;           %# of gauss quadrature points in x
NGPY = 2;           %# of gauss quadrature points in y
DOFPERNODE = 2;     %2 DOF per node

%Constitutive matrix for plane strain case
D = (E/(1 - poisson^2))*[1,poisson,0;poisson,1,0;0,0,(1 - poisson)/2];


%Numbering scheme for node "i" : x --> 2*i-1, y---> 2*i
%Assembled global stiffness matrix
kGlobal = zeros(DOFPERNODE * length(node(:,1)));

for(i=1:length(element(:,1)))
    
    kElement = zeros(DOFPERNODE * 4);
    
    %Extracting the x and y coordinates of the nodes
    temp = element(i,:);
    bl = temp(1);
    br = temp(2);
    tr = temp(3);
    tl = temp(4);
    x = [node(bl,1);node(br,1);node(tr,1);node(tl,1)];
    y = [node(bl,2);node(br,2);node(tr,2);node(tl,2)];
    globalNode = [2*bl-1 2*bl 2*br-1 2*br 2*tr-1 2*tr 2*tl-1 2*tl];
    
    %Gauss points and weights
    [qpx,qwx] = GaussQuadrature(NGPX);
    [qpy,qwy] = GaussQuadrature(NGPY);
    
    %Traversing through the Gauss points
    for(k=1:length(qpx))
        
       for(j = 1:length(qpy))
           
           xi = qpx(k);
           eta = qpy(j);
           [B,jacobian] = BCalc(xi, eta, x, y);
           kElement = kElement + (qwx(k) * qwy(j) * B' * D * B * det(jacobian));
           
       end
        
    end
    
    %Adding to the global stiffness matrix
    kGlobal(globalNode,globalNode) = kGlobal(globalNode,globalNode) + kElement; 
    
end

%Finding the unknown nodal field values
dGlobal = zeros(DOFPERNODE * length(node(:,1)),1);
kGlobalUU = kGlobal(bcFree,bcFree);
fGlobalU = force (bcFree);
dGlobal(bcFree) = inv(kGlobalUU) * fGlobalU;

%Printing the nodal displacement values in the output file
temp=[];
for i=1:length(node(:,1))
    
    temp=[temp;i,dGlobal(2*i-1),dGlobal(2*i)];
    
end
xlswrite(outPath,temp,'NodalDisplacement');

%Converting to x and y displacement format
dGlobal = temp(:,2:3);

%Plot the undeformed configuration
PlotSystem(node,element,'r','b');

%Plotting the displacements as a contour plot
PlotContour(node,dGlobal);

%Plotting the original vs deformed configuration
figure;
origConfig = PlotSystem(node, element, 'k', 'g');
legend('Original');
hold on;
displacedNode = node + dGlobal;
newConfig = PlotSystem(displacedNode, element, 'r', 'b');
legend([origConfig newConfig],'Original','Deformed');