
clear all
close all
fp = fopen('envIn.bin');
input = fread(fp, 128*512,'uint8');
fclose(fp);

envGCF_Log = reshape( input, [128 512] );

u = double(envGCF_Log);

%Program 1: Load u into Texture0; [512 128] ... ProgluminanceToRGBA
u; 

%Program 2: Conv3x3 Blur ...separableConv3x3\
blurAx = sepConv3x3(u,[0.1664, 0.6672, 0.1664],1);

blur = sepConv3x3(blurAx,[0.1664, 0.6672, 0.1664],0);

uxds = sepConv3x3(blur,[-1, 0, 1],1);

uyds = sepConv3x3(blur,[-1, 0, 1],0);

%Program 2: Conv3x3 Compute x,y gradients of downsampled, blurred image
%...separableConv3x3
% uxds = gradient( LFds, 'x'); %Texture3 [256 64], kernel = [-1 0 1]
% uyds = gradient( LFds, 'y'); %Texture4 [256 64], kernel = [-1 0 1]
%[uxds,uyds] = gradient(blur); %Texture3 [256 64], kernel = [-1 0 1]


%
%Program 4: Compute tmp -- VON MUST WRITE

Jxy = uxds.*uyds;
Jxx = uxds.*uxds;
Jyy = uyds.*uyds;
edge = sqrt((Jxx - Jyy).^2 + 4*Jxy.^2); %Texture5 [256 64]
edge = edge./8;


%%
%Program 5: Conv5x5 blur tmp ...separableConv5x5
%tmp = imgaussian(edge, 2); %Texture5 [256 64] ... kernel = [0.1525    0.2218    0.2514    0.2218    0.1525]

edgeBlurAx = sepConv5x5(edge,[0.1525, 0.2218, 0.2514, 0.2218, 0.1525],0);
edgeBlurLat = sepConv5x5(edgeBlurAx,[0.1525, 0.2218, 0.2514, 0.2218, 0.1525],1);

figure(1);
subplot(1,3,1);
imagesc(edge');
colormap gray
subplot(1,3,2);
imagesc(edgeBlurAx');
colormap gray
subplot(1,3,3);
imagesc(edgeBlurLat');
colormap gray
%%
%Program 5: Conv5x5 blur tmp ... separableConv5x5
%LFds = imgaussian(LFds, 1.5); %Texture2, kernel = [0.1201 0.2239 0.2921 0.2339 0.1201]

LFAx = sepConv5x5(blur,[0.1201, 0.2239, 0.2921, 0.2239, 0.1201],0);
LF = sepConv5x5(LFAx,[0.1201, 0.2239, 0.2921, 0.2239, 0.1201],1);

figure(1);
subplot(1,3,1);
imagesc(blur');
colormap gray
subplot(1,3,2);
imagesc(LFAx');
colormap gray
subplot(1,3,3);
imagesc(LF');
colormap gray
%%
%Program 7: load JSds, LF, tmp, uxds into program. Computed edgewgt inside
%program and output is Combined. ... reference progBlendImages

MaxF = 256;
MinF = -255;

lfwgt = 0.5;
smoothwgt = 0.5;
edgeMap = edgeBlurLat/1000;
Combined1 = ( (smoothwgt).*blur + lfwgt.*(1-edgeMap).*LF)./( smoothwgt + lfwgt.*(1-edgeMap)) + 1*uyds.*edgeMap;% + 0.015*LF.*randn( size(JS ) );
%Combined1(Combined1>MaxF) = MaxF;
%Combined1(Combined1<MinF)=MinF;

figure(1);
imagesc(Combined1')
colormap gray

%%

% Setup Scan Conversion
pivot=4.0981e-3;
B=56.0941;
dead=310;
fs=25e6;
MAXDEPTH=512;
 
scsamp=2.4640e-04;
NX=128;
NZ=512;
ZI = dead/fs*1540/2+(0:NZ-1)*scsamp*512/NZ;
XI= ((NX-1)/2.:-1:-(NX-1)/2)*scsamp*512/NZ*1.0;
Z = (0:MAXDEPTH-1)*scsamp+dead/fs/2*1540;

SC = fast_sc128(Z,ZI,XI, Combined1 ,pivot,B);
figure;
imagesc(SC);
colormap gray






%%
%[X,Y] = meshgrid( linspace(1,size(JSds,2), 128) , linspace(1,size(JSds,1), 512) );
%JS = interp2( JSds, X, Y, 'linear');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
%LF = interp2( LFds, X, Y, 'linear');
%edgewgt = interp2( exp( - 1000000./tmp ), X, Y, 'linear');
%E = interp2( uyds, X, Y, 'linear'); 

lfwgt = 0.5;

Combined1 = ( (1-lfwgt).*JS + lfwgt.*(1-edgewgt).*LF)./( (1-lfwgt) + lfwgt.*(1-edgewgt)) %+ 1*E.*edgewgt;% + 0.015*LF.*randn( size(JS ) );
Combined1(Combined1>32767) = 32767;
Combined1(Combined1<0)=0;

Combined2 = ( (1-lfwgt).*JS + lfwgt.*(1-edgewgt).*LF)./( (1-lfwgt) + lfwgt.*(1-edgewgt))+ 1*E.*edgewgt;% + 0.015*LF.*randn( size(JS ) );
Combined2(Combined2>32767) = 32767;
Combined2(Combined2<0)=0;

Combined3 = ( (1-lfwgt).*JS + lfwgt.*(1-edgewgt).*LF)./( (1-lfwgt) + lfwgt.*(1-edgewgt))+ 1.5*E.*edgewgt;% + 0.015*LF.*randn( size(JS ) );
Combined3(Combined3>32767) = 32767;
Combined3(Combined3<0)=0;



%Program 6: scan convert Combined .... progScanConvert
JSblend1 = fast_sc128(Z,ZI,XI, Combined1 ,pivot,B);
JSblend2 = fast_sc128(Z,ZI,XI, Combined2 ,pivot,B);
JSblend3 = fast_sc128(Z,ZI,XI, Combined3 ,pivot,B);
Original = fast_sc128(Z,ZI,XI, u ,pivot,B);
figure(1); imagesc(Original);colormap gray;axis image;axis off; title('Original');
figure(2);
subplot(1,3,1); imagesc(JSblend1);colormap gray;axis image;axis off; title('Without Edge Info');
subplot(1,3,2); imagesc(JSblend2);colormap gray;axis image;axis off; title('0.75');
subplot(1,3,3); imagesc(JSblend3);colormap gray;axis image;axis off; title('0.5');
% figure(3);subplot(1,3,1);imagesc(Jxy);colormap gray;axis image;axis off; title('Jxy');
% subplot(1,3,2);imagesc(uxds);colormap gray;axis image;axis off; title('ux');
% subplot(1,3,3);imagesc(uyds);colormap gray;axis image;axis off; title('uy');
figure(7);imagesc(tmp);colormap gray;axis off; title('tmp');
figure(8);imagesc(edgewgt.*E);colormap gray;axis off; title('edgewgt');

%%
x = 1/128:1/128:1
y = 1/512:1/512:1

img = zeros(512,128);

for row = 1:512
    for col = 1:128
        x_i = (x(col));
        y_i = y(row);
        img(row,col) = max(sqrt(x_i*x_i+y_i*y_i)*256,0);
    end
end

imagesc(img);