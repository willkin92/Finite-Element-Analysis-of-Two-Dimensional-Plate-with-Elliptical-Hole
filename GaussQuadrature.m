function [qp, qw] = GaussQuadrature(ngp)
% function [qp, qw] = quad_data(ngp)
% Gives data for Gauss-Legendre quadrature.
%
% INPUT:
% ngp : number of quadrature points to be used
%
% OUTPUTS:
% qp : quadrature points
% qw : quadrature weights
%
% Written by: Gaurav (gauravs@iitgn.ac.in)
% Date: 2014/01/10
switch(ngp)
case 1
qp = 0;
qw = 2;
case 2
qp = [-0.577350269189626; ...
0.577350269189626];
qw = [1; ...
1];
case 3
qp = [-0.744596669241483; ...
0.744596669241483; ...
0];
qw = [0.555555555555556; ...
0.555555555555556; ...
0.888888888888889];
case 4
qp = [-0.861136311694953; ...
0.861136311694953; ...
-0.339981043584856; ...
0.339981043584856];
qw = [0.347854845137454; ...
0.347854845137454; ...
0.652145154862546; ...
0.652145154862546];
otherwise
error(['no support for ', num2str(ngp), ' quadrature points']);
end