% compare_sc_example_simply_8.m
% Nasser, September 3, 2019
% In this code, we consider:
% bounded simply connected domain G inside polygon with 6 vertices
% (this polygon has been considered in: 
% A.R.H. Heryudono and T.A. Driscoll, Radial Basis Function Interpolation 
% on Irregular Domain through Conformal Transplantation, J Sci Comput 44
% (2010) 286--300
% 
% For comparison with Schwarz�Christoffel Toolbox, you need to download 
% the SC toolbox from http://www.math.udel.edu/~driscoll/SC/, then extract
% the toolbox into a folder sc, then add this folder to the folder contains
% this MATLAB file.
% 
clc; clear all;
%
% The vertices of the polygon
ver{1}=[1i ; -1+1i ; -1-1i ; 1.5-1i ; 1.5 ; 1];
% Choose alpha, an auxiliary point in the domain G
alpha = 0;
%%
tic
% f=plgcirmap(ver,alpha);% f is the conformal mapping from the domain G
                         % onto the circular domain D with the  
                         % normalization f(alpha)=0 and f'(alpha)>0
f=plgcirmap(ver,alpha,ver{1}(end));% f is the conformal mapping from the 
                         % domain G onto the circular domain D with the  
                         % normalization f(alpha)=0 and f(ver{1}(end))=1
toc
%%
% plotmap(f); % to plot the domain G and the circular domain D 
%%
% plotmap(f,'v','plr',20,25); % to plot polar grids in the circular domain
                              % D and their images in the domain G under  
                              % the invers map
%%                              
% plotmap(f,'v','rec',21,21); % to plot rectangular grids in the circular 
                              % domain D and their images in the domain G
                              % under the invers map
%%
% plotmap(f,'d','rec',21,21); % to plot rectangular grids in the domain 
                              % G and their images in the circular domain  
                              % D under the conformal map
%%
% plotmap(f,'d','plr',21,21); % to plot polar grids in the domain 
                              % G and their images in the circular domain  
                              % D under the conformal map
%%
addpath sc % to use the Schwarz�Christoffel Toolbox 
options = scmapopt('Tolerance',1e-14); % the accuracet for SC toolbox
p=polygon(ver{1}); 
tic
fsc = diskmap(p,options);
fsc = center(fsc,alpha);% fsc=f^-1 is the invers map from the circular 
                        % domain D onto the domain G compute by SC toolbox
                        % such that fsc(0)=alpha, fsc(1)=ver{1}(end)
toc
%%
% to plot polar grids in the circular domain D and their images in the 
% domain G under the invers map using both methods
plotmap(f,'v','plr',20,25);
figure
plot(fsc,20,25)
%%
% Checking the accuracy of the toolbox PlgCirMap:
% 
% we choose test points: wtest in the circular domain D 
ww = 0.9.*exp(i.*linspace(0,2*pi,1000));
% We compute the values of the test points wtest under the inverse map from
% D onto G using the toolbox PlgCirMap
zwwpc = evalu(f,ww,'v');
% and using SC toolbox
zwwsc = fsc(ww);
% We compute the maximum norm of the different between the computed values
error_inv_map = norm(zwwpc-zwwsc,inf)
% We compute the maximum norm of the different between the test points 
% wtest and the computed values of f(f^-(wtest)) for SC toolbox
error_sc = norm(ww-eval(inv(fsc),zwwsc),inf)
% We compute the maximum norm of the different between the test points 
% wtest and the computed values of f(f^-(wtest)) for PlgCirMap toolbox
error_pc = norm(ww-evalu(f,zwwpc,'d'),inf)
%%
% Checking the accuracy of the toolbox PlgCirMap:
% 
% we choose test points: zztest in the circular domain G 
zz  = 0.6.*exp(i.*linspace(0,2*pi,1000));
% We compute the values of the test points zztest under the conformal map 
% from G onto D using the toolbox PlgCirMap
wzzpc = evalu(f,zz,'d');
% We compute the values of the test points zztest under the conformal map 
% from G onto D using the SC toolbox 
wzzsc = eval(inv(fsc),zz);
% We compute the maximum norm of the different between the computed values
error_map = norm(wzzpc-wzzsc,inf)
% We compute the maximum norm of the different between the test points 
% zztest and the computed values of f^-1(f(zztest)) for SC toolbox
error_sc = norm(zz-fsc(wzzsc),inf)
% We compute the maximum norm of the different between the test points 
% zztest and the computed values of f^-1(f(zztest)) for PlgCirMap toolbox 
error_pc = norm(zz-evalu(f,wzzpc,'v'),inf)
%%
% Checking the accuracy of the toolbox PlgCirMap:
% 
% The prevertices computed using SC toolbox
prevertsc = get(fsc,'prevert');
% The prevertices computed using PlgCirMap toolbox
prevertpc = f.imgver{:};
% We compute the maximum norm of the different between the computed values
error_prevert = norm(prevertsc-prevertpc,inf)
%%