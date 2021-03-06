clear all;%close all;

% !sshpass -p "" scp root@192.168.2.101:/usr/bin/ux.dat ux.dat

%!sshpass -p "" scp root@192.168.2.101:/usr/bin/Dxx.dat Dxx.dat
%!sshpass -p "" scp root@192.168.2.101:/usr/bin/Dyy.dat Dyy.dat
%!sshpass -p "" scp root@192.168.2.101:/usr/bin/Dxy.dat Dxy.dat
% !sshpass -p "" scp root@192.168.2.101:/usr/bin/DyyDxxDxy.dat DyyDxxDxy.dat
%!sshpass -p "" scp root@192.168.2.101:/usr/bin/3x3smoothedFull.dat 3x3smoothedFull.dat
!sshpass -p "" scp root@192.168.2.101:/usr/bin/downsampled.dat downsampled.dat
!sshpass -p "" scp root@192.168.2.101:/usr/bin/DSgradient.dat DSgradient.dat
!sshpass -p "" scp root@192.168.2.101:/usr/bin/EdgeMap.dat EdgeMap.dat
!sshpass -p "" scp root@192.168.2.101:/usr/bin/SmoothEdge.dat SmoothEdge.dat
!sshpass -p "" scp root@192.168.2.101:/usr/bin/CompressedEdgeMap.dat CompressedEdgeMap.dat
!sshpass -p "" scp root@192.168.2.101:/usr/bin/buffer.dat buffer.dat
!sshpass -p "" scp root@192.168.2.101:/usr/bin/blended.dat blended.dat
% !sshpass -p "" scp root@192.168.2.101:/usr/bin/output.dat output.dat
!sshpass -p "" scp root@192.168.2.101:/usr/bin/input.dat input.dat
!sshpass -p "" scp root@192.168.2.101:/usr/bin/upsampled.dat upsampled.dat

% % 
% fp = fopen('input.dat');
% input = fread(fp, 512*128,'int16');
% fclose(fp);
% input = reshape( input, [128 512] );
% figure(16);imagesc( input', [0 255]); colormap gray
% 
% fp = fopen('3x3smoothedFull.dat');
% Smooth = fread(fp, 512*128,'int16');
% fclose(fp);
% Smooth = reshape( Smooth, [128 512] );
% figure(17);imagesc( Smooth', [0 255]); colormap gray
% 
fp = fopen('downsampled.dat');
DS = fread(fp, 256*64,'int16');
fclose(fp);
DS = reshape(DS, [64 256] );
figure(18);imagesc( DS'); colormap gray
% 
% fp = fopen('DSgradient.dat');
% DSgrad = fread(fp, 256*64,'int16');
% fclose(fp);
% DSgrad = reshape(DSgrad, [64 256] );
% figure(19);imagesc( DSgrad'); colormap gray

fp = fopen('EdgeMap.dat');
Edge = fread(fp, 256*64,'int16');
fclose(fp);
Edge = reshape( Edge, [64 256] );
figure(20);imagesc( Edge' ); colormap gray

fp = fopen('SmoothEdge.dat');
SmoothEdge = fread(fp, 256*64,'int16');
fclose(fp);
SmoothEdge = reshape( SmoothEdge, [64 256] );
figure(21);imagesc( SmoothEdge' ); colormap gray


fp = fopen('CompressedEdgeMap.dat');
CompEdge = fread(fp, 256*64,'int16');
fclose(fp);
CompEdge = reshape( CompEdge, [64 256] );
figure(22);imagesc( CompEdge' ); colormap gray

% fp = fopen('buffer.dat');
% Buffer = fread(fp, 512*128*3,'int16');
% fclose(fp);
% Buffer = reshape( Buffer, [128*3 512] );
% figure(23);imagesc( Buffer' ); colormap gray
% 
% fp = fopen('blended.dat');
% blended = fread(fp, 512*128,'int16');
% fclose(fp);
% blended = reshape( blended, [128 512] );
% figure(24);imagesc( blended' ); colormap gray
% 
% fp = fopen('upsampled.dat');
% JS = fread(fp, 512*128,'int16');
% fclose(fp);
% JS = reshape( JS, [128 512] );
% figure(24);imagesc( JS' ); colormap gray
%%


!sshpass -p "" scp root@192.168.1.153:Dump1.dat Dump1.dat
!sshpass -p "" scp root@192.168.1.153:Dump2.dat Dump2.dat
!sshpass -p "" scp root@192.168.1.153:Dump3.dat Dump3.dat
!sshpass -p "" scp root@192.168.1.153:Dump4.dat Dump4.dat

!sshpass -p "" scp root@192.168.1.153:edgeDump.dat edgeDump.dat
!sshpass -p "" scp root@192.168.1.153:downSample.dat downSample.dat

figure(16);
fp = fopen('envIn.bin');
input = fread(fp, 128*512,'uint8');
fclose(fp);

%  figure(16);
% fp = fopen('gradient.bin');
% input = fread(fp, 128*512,'uint8');
% fclose(fp);

input = reshape( input, [128 512] );
img = input;
subplot(1,2,1)
imagesc( img'); colormap gray
title('input');


fp = fopen('Dump1.dat');
Packed = fread(fp, 4*128*512,'uint8');
fclose(fp);
Packed = reshape( Packed, [4 128 512] );
subplot(2,3,2)
imagesc( squeeze(Packed(1,:,:))'); colormap gray
title('packed A');

subplot(2,3,3)
imagesc( squeeze(Packed(2,:,:))'); colormap gray
title('packed G');

subplot(2,3,4)

imagesc( squeeze(Packed(3,:,:))'); colormap gray
title('packed B');

subplot(2,3,5)
imagesc( squeeze(Packed(4,:,:))'); colormap gray
title('packed A');
%%
!sshpass -p "" scp root@192.168.1.153:Dump1.dat Dump1.dat
!sshpass -p "" scp root@192.168.1.153:DownSample.dat DownSample.dat

MaxF = 256;
MinF = -256;

texture_height =512;
texture_width =256;

figure(15);

fp = fopen('Dump1.dat');
Pack = fread(fp, 4*texture_width*texture_height,'uint8');
fclose(fp);
Pack = reshape( Pack, [4 texture_width texture_height] );
Pack = 256*DecodeRGBA(Pack/256,MaxF,MinF);
subplot(1,2,1)
imagesc( Pack'); colormap gray
title('Packed');

fp = fopen('DownSample.dat');
Lat = fread(fp, 4*(texture_width/2)*(texture_height/2),'uint8');
fclose(fp);
Packed = reshape( Lat, [4 texture_width/2 texture_height/2] );
subplot(2,3,2)
imagesc( squeeze(Packed(1,:,:))'); colormap gray
title('packed A');

subplot(2,3,3)
imagesc( squeeze(Packed(2,:,:))'); colormap gray
title('packed G');

subplot(2,3,4)

imagesc( squeeze(Packed(3,:,:))'); colormap gray
title('packed B');

subplot(2,3,5)
imagesc( squeeze(Packed(4,:,:))'); colormap gray
title('packed A');



%%

!sshpass -p "" scp root@192.168.1.153:DownSample.dat DownSample.dat
!sshpass -p "" scp root@192.168.1.153:3x3ax.dat 3x3ax.dat
!sshpass -p "" scp root@192.168.1.153:3x3lat.dat 3x3lat.dat

MaxF = 256;
MinF = -256;
figure(15);

texture_height =512;
texture_width =256;

fp = fopen('DownSample.dat');
DownSample = fread(fp, 4*(texture_width/2)*(texture_height/2),'uint8');
fclose(fp);
DownSample = reshape( DownSample, [4 (texture_width/2) (texture_height/2)] );
DownSample = 256*DecodeRGBA(DownSample/256,MaxF,MinF);
subplot(1,3,1)
imagesc( DownSample'); colormap gray
title('Decoded DownSample');

fp = fopen('3x3ax.dat');
Ax = fread(fp, 4*(texture_width/2)*(texture_height/2),'uint8');
fclose(fp);
Ax = reshape( Ax, [4 (texture_width/2) (texture_height/2)] );
Ax = 256*DecodeRGBA(Ax/256,MaxF,MinF);
subplot(1,3,2)
imagesc( Ax'); colormap gray
title('Decoded Axial derivative');

fp = fopen('3x3lat.dat');
Lat = fread(fp, 4*(texture_width/2)*(texture_height/2),'uint8');
fclose(fp);
Lat = reshape( Lat, [4 (texture_width/2) (texture_height/2)] );
Lat = 256*DecodeRGBA(Lat/256,MaxF,MinF);
subplot(1,3,3)
imagesc( Lat'); colormap gray
title('Decoded Lateral derivative');


%%

!sshpass -p "" scp root@192.168.1.153:edgeDump.dat edgeDump.dat
!sshpass -p "" scp root@192.168.1.153:5x5ax.dat 5x5ax.dat
!sshpass -p "" scp root@192.168.1.153:5x5lat.dat 5x5lat.dat

MaxF = 256;
MinF = -255;

figure(16);
fp = fopen('edgeDump.dat');
edge = fread(fp, 4*128*512,'uint8');
fclose(fp);
edge = reshape( edge, [4 128 512] );
edge = 256*DecodeRGBA(edge/256,MaxF,MinF);
subplot(1,3,1)
imagesc( edge'); colormap gray
title('Decoded Edge Map');

fp = fopen('5x5ax.dat');
edgeBlurAx = fread(fp, 4*128*512,'uint8');
fclose(fp);
edgeBlurAx = reshape( edgeBlurAx, [4 128 512] );
edgeBlurAx = 256*DecodeRGBA(edgeBlurAx/256,MaxF,MinF);
subplot(1,3,2)
imagesc( edgeBlurAx'); colormap gray
title('Decoded Edge map axial blur');

fp = fopen('5x5lat.dat');
edgeBlurLat = fread(fp, 4*128*512,'uint8');
fclose(fp);
edgeBlurLat = reshape( edgeBlurLat, [4 128 512] );
edgeBlurLat = 256*DecodeRGBA(edgeBlurLat/256,MaxF,MinF);
subplot(1,3,3)
imagesc( edgeBlurLat'); colormap gray
title('Decoded Edge map lateral blur');

%%


figure(16);
!sshpass -p "" scp root@192.168.1.153:5x5ax.dat 5x5ax.dat
!sshpass -p "" scp root@192.168.1.153:5x5lat.dat 5x5lat.dat
!sshpass -p "" scp root@192.168.1.153:eff5x5ax.dat eff5x5ax.dat
!sshpass -p "" scp root@192.168.1.153:eff5x5lat.dat eff5x5lat.dat

MaxF = 256;
MinF = -256;

texture_height =512;
texture_width =256;

fp = fopen('5x5ax.dat');
BlurAx = fread(fp, 4*texture_width*texture_height,'uint8');
fclose(fp);
BlurAx = reshape( BlurAx, [4 texture_width texture_height] );
BlurAx = 256*DecodeRGBA(BlurAx/256,MaxF,MinF);
subplot(2,3,1)
imagesc( BlurAx'); colormap gray
title(' axial blur');

fp = fopen('5x5lat.dat');
BlurLat = fread(fp, 4*texture_width*texture_height,'uint8');
fclose(fp);
BlurLat = reshape( BlurLat, [4 texture_width texture_height] );
BlurLat = 256*DecodeRGBA(BlurLat/256,MaxF,MinF);
subplot(2,3,4)
imagesc( BlurLat'); colormap gray
title('lateral blur');

fp = fopen('eff5x5ax.dat');
effBlurAx = fread(fp, 4*texture_width*texture_height,'uint8');
fclose(fp);
effBlurAx = reshape( effBlurAx, [4 texture_width texture_height] );
effBlurAx = 256*DecodeRGBA(effBlurAx/256,MaxF,MinF);
subplot(2,3,2)
imagesc( effBlurAx'); colormap gray
title('efficient axial blur');

fp = fopen('eff5x5lat.dat');
effBlurLat = fread(fp, 4*texture_width*texture_height,'uint8');
fclose(fp);
effBlurLat = reshape( effBlurLat, [4 texture_width texture_height] );
effBlurLat = 256*DecodeRGBA(effBlurLat/256,MaxF,MinF);
subplot(2,3,5)
imagesc( effBlurLat'); colormap gray
title('efficient lateral blur');

subplot(2,3,3)
imagesc( effBlurAx'-BlurAx'); colormap gray
title('axial blur difference');

subplot(2,3,6)
imagesc( effBlurLat'-BlurLat'); colormap gray
title('lateral blur difference');
%%
!sshpass -p "" scp root@192.168.1.153:blendImage.dat blendImage.dat
MaxF = 256;
MinF = -256;

texture_height =512/2;
texture_width =256/2;
figure(15);

fp = fopen('blendImage.dat');
Blend = fread(fp, 4*texture_width*texture_height,'uint8');
fclose(fp);
Blend = reshape( Blend, [4 texture_width texture_height] );
Blend = 256*DecodeRGBA(Blend/256,MaxF,MinF);

imagesc( Blend'); colormap gray
title('Blend');

%%
!sshpass -p "" scp root@192.168.1.153:blendImageHD.dat blendImageHD.dat

MaxF = 256;
MinF = -256;

texture_height =512;
texture_width =256;
figure(15);

fp = fopen('blendImageHD.dat');
Blend = fread(fp, 4*texture_width*texture_height,'uint8');
fclose(fp);
Blend = reshape( Blend, [4 texture_width texture_height] );
Blend = 256*DecodeRGBA(Blend/256,MaxF,MinF);

imagesc( Blend'); colormap gray
title('Blend');



%%

!sshpass -p "" scp root@192.168.1.153:Dump2.dat Dump2.dat

figure(16);
texture_height =512/2;
texture_width =256/2;

fp = fopen('Dump2.dat');
combined = fread(fp, 4*texture_width*texture_height,'uint8');
fclose(fp);
combined = reshape( combined, [4 texture_width texture_height] );
combined = 256*DecodeRGBA(combined/256,MaxF,MinF);
imagesc( combined'); colormap gray
title('Decoded Combined');


%%
clear all


!sshpass -p "" scp root@192.168.1.153:Dump1.dat Dump1.dat
!sshpass -p "" scp root@192.168.1.153:Dump4.dat Dump4.dat
MaxF = 256;
MinF = -256;

texture_height =512/2;
texture_width =256/2;



figure(17);



fp = fopen('Dump4.dat');
colorAtt = fread(fp, 4*texture_width*texture_height,'uint8');
fclose(fp);
colorAtt = reshape( colorAtt, [4 texture_width texture_height] );
imagesc( squeeze(colorAtt(4,:,:))'); colormap gray
title('unpacked');

%%
!sshpass -p "" scp root@192.168.1.153:SCDump.dat SCDump.dat
!sshpass -p "" scp root@192.168.1.153:SCDump2.dat SCDump2.dat
texture_height =512;
texture_width =256;

fp = fopen('SCDump.dat');
SC = fread(fp, 4*texture_width*texture_height,'uint8');
fclose(fp);
SC = reshape( SC, [4 texture_width texture_height] );

fp = fopen('SCDump2.dat');
SC2 = fread(fp, 4*texture_width*texture_height,'uint8');
fclose(fp);
SC2 = reshape( SC2, [4 texture_width texture_height] );

figure(19);
subplot(1,2,1)
imagesc( squeeze(SC(1,:,:))'); colormap gray
title('SC');
subplot(1,2,2)
imagesc( squeeze(SC2(3,:,:))'); colormap gray
title('SC2 (fragment shader)');


%%

figure(4);
plot(squeeze(SC(4,64,:)))
hold on 
plot(squeeze(SC(3,64,:)),'r')
%%
%[a,b,c,d] = encode(0.5)
v = single(254);
% [r,g,b,a] = encode(v/255);
[r,g,b,a] = encode(1/(511*127.5))

decode(r,g,b,a)
%%

for ind = 1:128
    
    VarPack(ind,1) = decode(Packed(1,ind,1),Packed(2,ind,1),Packed(3,ind,1),Packed(4,ind,1));
    VarPack(ind,2) = decode(Packed(1,ind,2),Packed(2,ind,2),Packed(3,ind,2),Packed(4,ind,2));
    VarAx(ind,1) = decode(Ax(1,ind,1),Ax(2,ind,1),Ax(3,ind,1),Ax(4,ind,1));
    VarAx(ind,2) = decode(Ax(1,ind,2),Ax(2,ind,2),Ax(3,ind,2),Ax(4,ind,2));
    VarLat(ind,1) = decode(Lat(1,ind,1),Lat(2,ind,1),Lat(3,ind,1),Lat(4,ind,1));
    VarLat(ind,2) = decode(Lat(1,ind,2),Lat(2,ind,2),Lat(3,ind,2),Lat(4,ind,2));
    VarOut(ind,1) = squeeze(Out(1,ind,1));
    VarOut(ind,2) = squeeze(Out(1,ind,2));
    
%     [r,g,b,a] = encode(single(ind)/256);
%     Mat(ind,1) = decode(r*256,g*256,b*256,a*256);
%     [r,g,b,a] = encode(single(ind+128)/256);
%     Mat(ind,2) = decode(r*256,g*256,b*256,a*256);
end

figure(3);
plot(1:256,[1:256],1:256,VarPack(:),1:256,VarAx(:),1:256,VarLat(:),1:256,VarOut(:))
%plot(1:256,[1:256]/(255*255),1:256,VarPack(:)*255/256)
%%
value = 1/256;
%%%%%%% we give value to the shader   %%%%%%%%%
[r,g,b,a] = encode(value);
%%%%%%% we leave the shader, everything is scaled up to uint8 %%%%%%%%%
r = r*256; g = g*256; b = b*256; a = a*256;
%%%%%%% we enter the conv shader, scale back down to [0,1] %%%%%%%
r = r/255; g = g/255; b = b/255; a = a/255;
mid_conv_float = decode(r,g,b,a)
% ... do stuff ...
%%%%% pack it again
[r,g,b,a] = encode(mid_conv_float);
%%%%%   leave conv shader
r = r*256 
g = g*256 
b = b*256 
a = a*256
%%
fid = fopen('gradient.bin','wb');
fwrite(fid,[1:128*512],'uint8');
fclose(fid);

%%

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


%%
lfwgt = 0.75;
JS = Smooth;
edgewgt = Buffer(1:128,:)'./255;
LF = Buffer(129:256,:)';
E = Buffer(257:384,:)';
lfwgt = 0.75;
Combined1 = ( (1-lfwgt).*JS'+ (lfwgt.*(1-edgewgt).*LF)./( (1-lfwgt) + lfwgt.*(1-edgewgt)));%+ 1*E.*edgewgt;
Combined2 = ( (1-lfwgt).*JS'+ (lfwgt.*(1-edgewgt).*LF)./( (1-lfwgt) + lfwgt.*(1-edgewgt))+ 1*E.*edgewgt);
lfwgt = 0.75;
Combined3 = ( (1-lfwgt).*JS'+ (lfwgt.*(1-edgewgt).*LF)./( (1-lfwgt) + lfwgt.*(1-edgewgt))+ 3*E.*edgewgt);
figure(25); 
subplot(1,3,1);imagesc(fast_sc128(Z,ZI,XI, Combined1 ,pivot,B),[0 127]); colormap gray; axis image; title('Without Edge Info');
subplot(1,3,2);imagesc(fast_sc128(Z,ZI,XI, Combined2 ,pivot,B),[0 127]); colormap gray; axis image; title('0.75');
subplot(1,3,3);imagesc(fast_sc128(Z,ZI,XI, Combined3 ,pivot,B),[0 127]); colormap gray; axis image; title('0.5');

%%
lfwgt = 0.75;
Combined1 = ( (1-lfwgt).*JS'+ (lfwgt.*(1-edgewgt).*LF)./( (1-lfwgt) + lfwgt.*(1-edgewgt))+ 3*E.*edgewgt);
lfwgt = 0.6;
Combined2 = ( (1-lfwgt).*JS'+ (lfwgt.*(1-edgewgt).*LF)./( (1-lfwgt) + lfwgt.*(1-edgewgt))+ 3*E.*edgewgt);
lfwgt = 0.5;
Combined3 = ( (1-lfwgt).*JS'+ (lfwgt.*(1-edgewgt).*LF)./( (1-lfwgt) + lfwgt.*(1-edgewgt))+ 3*E.*edgewgt);
figure(27); 
subplot(1,3,1);imagesc(fast_sc128(Z,ZI,XI, Combined1 ,pivot,B)); colormap gray; axis image; title('Without Edge Info');
subplot(1,3,2);imagesc(fast_sc128(Z,ZI,XI, Combined2 ,pivot,B)); colormap gray; axis image; title('0.75');
subplot(1,3,3);imagesc(fast_sc128(Z,ZI,XI, Combined3 ,pivot,B)); colormap gray; axis image; title('0.5');


%%
fname ={'A1.dat', 'A2.dat', 'A3.dat', 'A4.dat', '', 'A6.dat', 'A7.dat', 'A8.dat', 'A9.dat'};

for i=[1:4,6:9]
    fp = fopen(fname{i});
    J = fread(fp, 512*128,'int16');
    fclose(fp);
    J = reshape( J, [128 512] );
    figure(87);subplot(3,3,i);imagesc(J');colormap gray;
    m(i) = max(J(:));
end
