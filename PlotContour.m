%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Function to plot the configuration of the system under consideration    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%INPUT:                                                                  %
%1. node : nodal locations (as in xlsx file) - can be displaced or not   %
%2. element : element connectivity (as in xlsx file)                     %
%3. color : color to plot the lines (nodes in red)                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Author : Ashutosh                                                        %
%On : 29th June, 2017                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = PlotContour(node, dGlobal)

x = node(:,1);
y = node(:,2);
ux = dGlobal(:,1);
uy = dGlobal(:,2);

figure;
scatter3(x,y,ux);
figure;
scatter3(x,y,uy);

end