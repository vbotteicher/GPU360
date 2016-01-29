%function [Dxx,Dxy,Dyy]=ConstructDiffusionTensor2D(mu1,mu2,v1x,v1y,v2x,v2y,gradA,Options)
function [Dxx,Dxy,Dyy]=ConstructDiffusionTensor2D(Lambda1,Lambda2,I2x,I2y,I1x,I1y,gradA,Options)
% Construct the edge preserving diffusion tensor D = [a,b;b,c] such as
% introduced by Weickert.
%
% http://www.mia.uni-saarland.de/weickert/Papers/book.pdf, pp 127-128
% 
% Function is written by D.Kroon University of Twente (September 2009)

%di=(mu1-mu2); di((di<1e-15)&(di>-1e-15))=1e-15;
% Implicit if mu1 == mu2 then lambda1=alpha
%lambda1 = Options.alpha + (1 - Options.alpha)*exp(-Options.C./(di).^(2*Options.m)); 
%lambda2 = Options.alpha;

% Scaling of diffusion tensors
if((Options.eigenmode==0)||(Options.eigenmode==1)) % Weickert line shaped 
    di=(mu1-mu2); di((di<1e-15)&(di>-1e-15))=1e-15;
    lambda1 = Options.alpha + (1 - Options.alpha)*exp(-Options.C./di.^(2*Options.m)); 
    lambda2 = Options.alpha; 
elseif(Options.eigenmode==2) % EED
    gradA=mean(gradA,3);
    lambda2 = 1 - exp(-3.31488./(gradA./Options.lambda_e^2).^4);
    lambda2(gradA<1e-15)=1;
    lambda1 = 1;
elseif(Options.eigenmode==3) % CED
%   di=(mu1-mu2); di((di<1e-15)&(di>-1e-15))=1e-15;
%    lambda1 = Options.alpha + (1 - Options.alpha)*exp(-Options.C./di.^(2*Options.m)); 
%    lambda2 = Options.alpha; 
    di = Lambda1 - Lambda2; di((di<1e-15)&(di>-1e-15))=1e-15;
    beta1 = Options.alpha + (1 - Options.alpha)*exp(-Options.C./di.^(2*Options.m)); 
    beta2 = Options.alpha; 
elseif(Options.eigenmode==4) % Hybrid Diffusion with Continous Switch
    gradA=mean(gradA,3);
    lambdae2 = 1 - exp(-3.31488./(gradA./Options.lambda_e^2).^4);
    lambdae2(gradA<1e-15)=1;
    lambdae1 = 1;

    di=(mu1-mu2); di((di<1e-15)&(di>-1e-15))=1e-15;
    lambdac1 = Options.alpha + (1 - Options.alpha)*exp(-Options.C./di.^(2*Options.m)); 
    lambdac2 = Options.alpha; 

    xi= (mu1-mu2);
    di=2.0*Options.lambda_h^4;
    epsilon = exp(mu1.*(Options.lambda_h^2.*(xi-abs(xi)))./di);

    lambda1 = (1-epsilon) .* lambdac1 + epsilon .* lambdae1;
    lambda2 = (1-epsilon) .* lambdac2 + epsilon .* lambdae2;
    
    figure(101);imagesc(lambdac1);colormap gray;axis image
    save('lambdac1.mat', 'lambdac1');
    save('mu2.mat', 'mu2');
    save('mu1.mat', 'mu1');
    figure(102);imagesc(lambdae2);colormap gray;axis image
    figure(103);imagesc(epsilon);colormap gray;axis image
    
end

%Dxx = lambda1.*v1x.^2   + lambda2.*v2x.^2;
%Dxy = lambda1.*v1x.*v1y + lambda2.*v2x.*v2y;
%Dyy = lambda1.*v1y.^2   + lambda2.*v2y.^2;

Dxx = beta1.*I2x.^2   + beta2.*I1x.^2;
Dxy = beta1.*I2x.*I2y + beta2.*I1x.*I1y;
Dyy = beta1.*I2y.^2   + beta2.*I1y.^2;

figure(101);imagesc(Dxx);colormap gray;axis image
figure(102);imagesc(Dxy);colormap gray;axis image
figure(103);imagesc(Dyy);colormap gray;axis image
a = 5;



