%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Function to calculate the B matrix given as                             %
%[B] = {NI,x 0}                                                          %
%      {0, NI,y}                                                         %
%      {N1,y N2,x}                                                       %
% where N denotes the shape function ito x & y in the xi-eta reference   %
% space.                                                                 %   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%INPUT:                                                                  % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%OUTPUT:                                                                 % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Author : Ashutosh                                                        %
%On : 29th June, 2017                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [B,j] = BCalc (xi, eta, x, y)

    [nDerXi nDerEta] = ShapeFunctionDer(xi, eta);
    x_Xi = nDerXi' * x;
    x_Eta = nDerEta' * x;
    y_Xi = nDerXi' * y;
    y_Eta = nDerEta' * y;
    j = [x_Xi x_Eta;y_Xi y_Eta];
    nDerXY = (inv(j))' * [nDerXi';nDerEta'];
    B = [nDerXY(1,1) 0 nDerXY(1,2) 0 nDerXY(1,3) 0 nDerXY(1,4) 0;... 
         0 nDerXY(2,1) 0 nDerXY(2,2) 0 nDerXY(2,3) 0 nDerXY(2,4);...
         nDerXY(2,1) nDerXY(1,1) nDerXY(2,2) nDerXY(1,2) nDerXY(2,3) nDerXY(1,3) nDerXY(2,4) nDerXY(1,4)];
end
