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


function [ln] = PlotSystem (node, element, pointColor, lineColor)

%Plot the nodes in a 2D plane
scatter(node(:,1),node(:,2),30,pointColor,'filled');
hold on;

%Plot the element lines
for(i=1:length(element(:,1)))
     
    temp = element(i,:);
    bl = temp(1);
    br = temp(2);
    tr = temp(3);
    tl = temp(4);
    x = [node(bl,1) node(br,1) node(tr,1) node(tl,1) node(bl,1)];
    y = [node(bl,2) node(br,2) node(tr,2) node(tl,2) node(bl,2)];
    ln = line(x,y,'color',lineColor);
     
end

end