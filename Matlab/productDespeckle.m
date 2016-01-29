%clear all;close all
%% Setup all the objects that do the processing
close all;clear all;
addpath('preprod');
addpath('prod');
addpath('prod/test/structs/');
addpath('preprod/test/matlab/');
addpath(genpath('functions'));
fp=fopen(['./preprod/test/matlab/Syn_focus/SF_8Cycles_25MHz/syn_focus_coefs_opt.dat'],'r');
raw_coefs=fread(fp, 'int16');
fclose(fp);
coefs=raw_coefs(1:2:end)+1j*raw_coefs(2:2:end);

fp=fopen(['./preprod/test/matlab/Syn_focus/SF_8Cycles_25MHz/hpad.dat'],'r');
hPad=fread(fp, 512, 'int16');
fclose(fp);

sfHarmonicObj    = SFStruct(coefs, hPad, 0);
sfFundamentalObj = SFStruct(coefs, hPad, 0);

gcfObj           = GCFStruct(0.65,...
                                  12,...
                                  './preprod/test/matlab/Reverb_profile.dat');
envObj = ENVStruct(0);

gcObj=GCStruct(1, 25, 1, 1);
blfObj=BLFStruct(0.2, 0.75); 

fp=fopen(['./preprod/test/matlab/signal_and_noise_profile.dat'],'r');
in=fread(fp, [512,3],'int32');
focalGain=in(:,3)/32767;

%% Load the RF Data
fp = fopen('kidneyv7_unpacked.dat');
in=fread(fp,'int16');
fclose(fp);

imgComplex=reshape(in(1:2:end)+1j*in(2:2:end),[512,128,2,40]);
frameNum = 8;
inIQHarmonic = imgComplex(:,:,1,frameNum);
inIQFundamental = imgComplex(:,:,2,frameNum);

% Setup Scan Conversion
pivot=4.0981e-3;
B=56.0941;
dead=310;
fs=25e6;
MAXDEPTH=512;
 
scsamp=2.4640e-04;
NX=320;
NZ=480;
ZI = dead/fs*1540/2+(0:NZ-1)*scsamp*512/NZ;
XI= ((NX-1)/2.:-1:-(NX-1)/2)*scsamp*512/NZ*1.0;
Z = (0:MAXDEPTH-1)*scsamp+dead/fs/2*1540;

%% Do the processing
gcfCoefs = gcfObj.runMatlab(inIQHarmonic).gcfOut;

sfHarmonic  = sfHarmonicObj.runMatlab(inIQHarmonic);
sfHarmonic  = sfHarmonic.*(focalGain*ones(1,128));
sfFundamental  = sfFundamentalObj.runMatlab(inIQFundamental);
sfFundamental  =sfFundamental/4;

envHarmonic = envObj.runMatlab(sfHarmonic);
envFundamental = envObj.runMatlab(sfFundamental);

gcResult = gcObj.runMatlab(envHarmonic, envFundamental);
envGC = envHarmonic.*(gcResult.correctCurve*ones(1,128));
envFundamental = envFundamental.*(gcResult.correctCurve*ones(1,128)); %AJD

envGCF  = envGC.*gcfCoefs;         


load logTable;

%% Full Despeckling
% Constants which determine the amplitude of the diffusion smoothing in 
% Weickert equation
%   Options.C :     Default 1e-10
%   Options.m :     Default 1
%   Options.alpha : Default 0.001
% Constants which are needed with CED, EED and HDCS eigenmode
%   Options.lambda_e : Default 0.02, planar structure contrast
%   Options.lambda_c : Default 0.02, tube like structure contrast
%   Options.lambda_h : Default 0.5 , treshold between structure and noise

envGCF( envGCF > 32676 ) = 32767;
envGCF = double(envGCF);
for i=1:512
    for j=1:128
        envGCF_Log(i,j) = logTable(round(envGCF(i,j)+0.5),5);
    end
end

envGCF_Log = double(envGCF_Log);
o = double(127*envGCF_Log./max(envGCF_Log(:)));

fp=fopen('~/rm_sf/prod/gpu/envIn.bin', 'w');  %This writes a .bin file that can be read by gpu-app
fwrite(fp, o', 'uint8');
fclose(fp);

u = double(envGCF_Log); %u is the input image to the algorithm

% Gaussian smooth the image, for better gradients
sigma = 0.6;
usigma=imgaussian(double(u),sigma,5);

Options = struct('T',       0.15, ...
                 'sigma',   2, ...
                 'rho',     1, ...
                 'Scheme',  'S', ...
                 'eigenmode', 3, ...
                 'alpha',   0.1, ...
                 'lambda_h',0.02 , ...
                 'lambda_e',0.025, ... 
                 'C',       7.5E-8, ...
                 'm',       1, ...
                 'dt',      0.3 );
             
JS = 32767*CoherenceFilter(usigma/32767, Options );

usigma=imgaussian(double(JS),4);
ux=derivatives(usigma,'x'); uy=derivatives(usigma,'y');

LF = imgaussian(double(u),4);

JSo = fast_sc128(Z,ZI,XI,JS,pivot,B);

load lambdac1.mat
load mu2.mat
load mu1.mat
mu1 = mu1/max(mu1(:));
mu2 = mu2/max(mu2(:));
mu3 = mu1 + mu2;
lambdac1=imgaussian(double(lambdac1),1);
mu3 = imgaussian(double(mu3),1);

lfwgt = 0.6;

LFC = (JS + lfwgt*(1-mu3).*LF)./(1 + lfwgt*(1-mu3));
HFC =  0.025*LF.*randn( size(JS ) ) + 10*ux.*mu3;

Combined = LFC + HFC;

JS = fast_sc128(Z,ZI,XI,Combined,pivot,B);

close all
J = double(imread('CVImage.jpg'));

%figure(1);imagesc(img_scLog,[0 32767]/1.3);colormap gray;axis image; title ('Current Dspk');axis off
figure(2);imagesc(JS,[0 32767]/1.3);colormap gray;axis image; title('Fully Sampled Dspk');axis off
figure(3);imagesc(JS,[0 32767]/1.3);colormap gray;axis image;title('Downsampled Dspk');axis off
figure(4);imagesc(J(70:end,284:end-5,1),[0 255]);colormap gray;axis image;title('Context Vision');axis off

imwrite(JS/(32767/1.3), 'img08.png', 'PNG');


%% DOWNSAMPLED IMAGE PROCESSING

envGCF( envGCF > 32676 ) = 32767;
envGCF = double(envGCF);
for i=1:512
    for j=1:128
        envGCF_Log(i,j) = logTable(round(envGCF(i,j)+0.5),5);
    end
end

envGCF_Log = double(envGCF_Log);
o = double(255*envGCF_Log./max(envGCF_Log(:)));

fp=fopen('~/rm_sf/prod/gpu/envIn.bin', 'w');
fwrite(fp, o', 'uint8');
fclose(fp);

u = double(envGCF_Log);

%Program 1: Load u into Texture0; [512 128] ... ProgluminanceToRGBA
u; 

%Program 2: Conv3x3 Blur ...separableConv3x3
uds = imgaussian( double(u), 0.5,2); %kernel = [0.1065 0.787 0.1065]

%Program 3: Downsample from 512x128 to 256x64 --  VON MUST WRITE
JSds = uds(1:2:end, 1:2:end) ; %Texture1 [256 64]

%Program 2: Conv3x3 Blur downsampled image .. separableConv3x3
LFds =imgaussian(double(JSds),0.5,2); %Texture2 [256 64], kernel = [0.1065 0.787 0.1065]

%Program 2: Conv3x3 Compute x,y gradients of downsampled, blurred image
%...separableConv3x3
uxds = gradient( LFds, 'x'); %Texture3 [256 64], kernel = [-1 0 1]
uyds = gradient( LFds, 'y'); %Texture4 [256 64], kernel = [-1 0 1]

%Program 4: Compute tmp -- VON MUST WRITE
Jxy = uxds.*uyds;
Jxx = uxds.*uxds;
Jyy = uyds.*uyds;
tmp = sqrt((Jxx - Jyy).^2 + 4*Jxy.^2); %Texture5 [256 64]

%Program 5: Conv5x5 blur tmp ...separableConv5x5
tmp = imgaussian(tmp, 2); %Texture5 [256 64] ... kernel = [0.1525    0.2218    0.2514    0.2218    0.1525]

%Program 5: Conv5x5 blur tmp ... separableConv5x5
LFds = imgaussian(LFds, 1.5); %Texture2, kernel = [0.1201 0.2239 0.2921 0.2339 0.1201]

%Program 7: load JSds, LF, tmp, uxds into program. Computed edgewgt inside
%program and output is Combined. ... reference progBlendImages
[X,Y] = meshgrid( linspace(1,size(JSds,2), 128) , linspace(1,size(JSds,1), 512) );
JS = interp2( JSds, X, Y, 'linear');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
LF = interp2( LFds, X, Y, 'linear');
edgewgt = interp2( exp( - 150./tmp ), X, Y, 'linear');
E = interp2( uxds, X, Y, 'linear'); 

lfwgt = 0.75;
Combined = ( (1-lfwgt).*JS + lfwgt.*(1-edgewgt).*LF)./( (1-lfwgt) + lfwgt.*(1-edgewgt)) + 100*E.*edgewgt;% + 0.015*LF.*randn( size(JS ) );
Combined(Combined>32767) = 32767;
Combined(Combined<0)=0;

%Program 6: scan convert Combined .... progScanConvert
JSblend = fast_sc128(Z,ZI,XI, Combined ,pivot,B);

figure(3);imagesc(JSblend,[0 32767]/1.3);colormap gray;axis image;axis off; title('Downsampled Dspk');
