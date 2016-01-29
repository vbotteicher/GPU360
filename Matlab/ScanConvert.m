clear all


fp = fopen('envIn.bin');
input = fread(fp, 128*512,'uint8');
input = reshape( input, [128 512] );
fclose(fp);

%  figure(16);
% fp = fopen('gradient.bin');
% input = fread(fp, 128*512,'uint8');
% fclose(fp);

% Setup Scan Conversion
[out] = VonSC(input,512,128);
%%
figure;
subplot(1,2,1);
imagesc(input);
hold on;
subplot(1,2,2);
imagesc(out);
hold off
colormap gray


%%

pivot=4.0981e-3;
B=56.0941;
dead=310;
fs=25e6;%sampling frequency
MAXDEPTH=512;
 
scsamp=2.4640e-04;
NX=256; %output dim's
NZ=256;
ZI = dead/fs*1540/2+(0:NZ-1)*scsamp*512/NZ;
XI= ((NX-1)/2.:-1:-(NX-1)/2)*scsamp*512/NZ;
Z = (0:MAXDEPTH-1)*scsamp+dead/fs/2*1540;
ZI = ZI + pivot;
Z = Z+pivot;

th = -B/2:B/127:B/2;

for y = 1 : NZ
   for x = 1 : NX
    theta(x,y) = atan(XI(x)/ZI(y))*180/pi;
    r(x,y) = sqrt(XI(x)^2+ZI(y)^2);
    
    
   end
end

out = interp2(repmat(th,[512 1]),repmat(Z,[128 1])',u,theta',r');
%%
clear XX ZZ
for angleInd = 1:128
    for depthInd = 1: MAXDEPTH
        ZZ(angleInd,depthInd) = Z(depthInd)*cos(th(angleInd)*pi/180);
        XX(angleInd,depthInd) = Z(depthInd)*sin(th(angleInd)*pi/180);
    end
end
imagesc(ZZ')
%%
back = interp2(repmat(XI,[NZ 1]),repmat(ZI,[NX 1])',out,XX',ZZ');


%%
[out] = VonSC(u,512,512);
[back] = VonISC(out)
figure(1);
imagesc(out); colormap gray;
figure(2);
imagesc(back); colormap gray;
figure(3);
imagesc(u); colormap gray;





