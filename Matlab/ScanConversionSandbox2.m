clear all

load('LiverImage_pre_sc.mat')
%%
figure(1);
subplot(1,2,1)
imagesc(u); colormap gray;
title('Original Coordinate System')
set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', []);
set(gca, 'YTickLabelMode', 'manual', 'YTickLabel', []);
subplot(1,2,2)
imagesc(VonSC(u,512,512)); colormap gray;
title('Cartesian Coordinate System')
set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', []);
set(gca, 'YTickLabelMode', 'manual', 'YTickLabel', []);

%%
kernels = zeros(512,128,31,9);
for Y = 10 : 10 :size(u,1)
    Y
    for X = 1 :2: size(u,2)
        X = 31
        Y = 110
        tmp = zeros(512,128);
        tmp(Y,X) = 1;
        [tmpsc] = VonSC(tmp,512,512);
        tmpsc(tmpsc~=max(max(tmpsc))) = 0;
        tmpsc(tmpsc>0) = 1;
        [tmppsf] = GFilter(tmpsc,size(u,1)/100,size(u,2)/100);
        [ISCpsf] = VonISC(tmppsf);
        ISCpsf = ISCpsf.*sum(sum(tmppsf))/sum(sum(ISCpsf));
       if (((Y>15) && (X>4))&&((Y<=512-15) && (X<=128-4)))
           kernels(Y,X,:,:) = ISCpsf(Y-15:Y+15,X-4:X+4);
       else
        for i = 1:31
            for j = 1:9
                if (((Y-16+i>0) && (X-5+j>0))&&((Y-16+i<=512) && (X-5+j<=128)))
                    
        kernels(Y,X,i,j) = ISCpsf(Y-16+i,X-5+j);
                   
                else
                    kernels(Y,X,i,j) = 0;
                end
            end
        end
       end
    end
end


%%
save('kernels.mat','kernels');


%%
clear kernels
load('kernels.mat');
%%
for Y = 10 : 10 :size(u,1)
    Y
    for X = 1 :2: size(u,2)
        kernels(Y-1,X,:,:) = kernels(Y,X,:,:);
        kernels(Y-2,X,:,:) = kernels(Y,X,:,:);
        kernels(Y-3,X,:,:) = kernels(Y,X,:,:);
        kernels(Y-4,X,:,:) = kernels(Y,X,:,:);
        kernels(Y-5,X,:,:) = kernels(Y,X,:,:);
        kernels(Y-6,X,:,:) = kernels(Y,X,:,:);
        kernels(Y-7,X,:,:) = kernels(Y,X,:,:);
        kernels(Y-8,X,:,:) = kernels(Y,X,:,:);
        kernels(Y-9,X,:,:) = kernels(Y,X,:,:);
        
        kernels(Y,X+1,:,:) = kernels(Y,X,:,:);
        kernels(Y-1,X+1,:,:) = kernels(Y,X,:,:);
        kernels(Y-2,X+1,:,:) = kernels(Y,X,:,:);
        kernels(Y-3,X+1,:,:) = kernels(Y,X,:,:);
        kernels(Y-4,X+1,:,:) = kernels(Y,X,:,:);
        kernels(Y-5,X+1,:,:) = kernels(Y,X,:,:);
        kernels(Y-6,X+1,:,:) = kernels(Y,X,:,:);
        kernels(Y-7,X+1,:,:) = kernels(Y,X,:,:);
        kernels(Y-8,X+1,:,:) = kernels(Y,X,:,:);
        kernels(Y-9,X+1,:,:) = kernels(Y,X,:,:);
        
        kernels(Y+1,X+1,:,:) = kernels(Y,X,:,:);
        kernels(Y+2,X+1,:,:) = kernels(Y,X,:,:);
        kernels(Y+1,X,:,:) = kernels(Y,X,:,:);
        kernels(Y+2,X,:,:) = kernels(Y,X,:,:);
    end
    
end



kernels = kernels(1:512,1:128,:,:);

%%
padData = [zeros(size(u,1),4),u,zeros(size(u,1),4)];
padData = [zeros(15,size(padData,2));padData;zeros(15,size(padData,2))];

for row = 1:512
    for col = 1:128
        
        FiltData(row,col) = sum(sum(padData(row:row+30,col:col+8).*squeeze(kernels(row,col,:,:))));
        
        
    end
end
%%
[FiltSC] = VonSC(FiltData,512,512);
figure(1);
subplot(2,2,4)
set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', []);
set(gca, 'YTickLabelMode', 'manual', 'YTickLabel', []);
imagesc(FiltSC); colormap gray;
title('Spatially Varying Filter SC')
subplot(2,2,3)
set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', []);
set(gca, 'YTickLabelMode', 'manual', 'YTickLabel', []);
imagesc(FiltData); colormap gray;
title('Spatially Varying Filter')


subplot(2,2,1)
imagesc(VonSC(u,512,512)); colormap gray;
title('Scan Converted Data')
subplot(2,2,2)
set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', []);
set(gca, 'YTickLabelMode', 'manual', 'YTickLabel', []);
BlurOG = GFilter(VonSC(u,512,512),size(u,1)/100,size(u,2)/100);
imagesc(BlurOG); colormap gray;
title('Filtering After SC')
set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', []);
set(gca, 'YTickLabelMode', 'manual', 'YTickLabel', []);

%%
figure(3);
subplot(1,3,1);
imagesc(abs(BlurOG-FiltSC),[0 2000]);
BlurThenSC =  VonSC(GFilter(u,size(u,1)/100,size(u,2)/100),512,512);
title('Spatially Varying Kernel')
set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', []);
set(gca, 'YTickLabelMode', 'manual', 'YTickLabel', []);
subplot(1,3,2);
imagesc(abs(BlurOG-BlurThenSC),[0 2000])
title('Filtering Before SC')
set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', []);
set(gca, 'YTickLabelMode', 'manual', 'YTickLabel', []);
subplot(1,3,3);
imagesc(abs(BlurOG-VonSC(VonISC(BlurOG),512,512)),[0 2000])
title('Inverse SC then SC again')
set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', []);
set(gca, 'YTickLabelMode', 'manual', 'YTickLabel', []);
%%

figure(3);
subplot(1,3,1);
imagesc(tmppsf);colormap gray
title('Cartesian Coordinate PSF')
set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', []);
set(gca, 'YTickLabelMode', 'manual', 'YTickLabel', []);
subplot(1,3,2);
imagesc(ISCpsf);colormap gray
title('Original Coordinate PSF')
set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', []);
set(gca, 'YTickLabelMode', 'manual', 'YTickLabel', []);
subplot(1,3,3);
imagesc(squeeze(kernels(Y,X,:,:)));colormap gray
title('Stored Kernel')
set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', []);
set(gca, 'YTickLabelMode', 'manual', 'YTickLabel', []);
%%  MSE 

RMS1 = sum(sum(sqrt(((BlurOG-FiltSC).^2)/(size(u,1)*size(u,2)))))

RMS2 = sum(sum(sqrt(((BlurOG-BlurThenSC).^2)/(size(u,1)*size(u,2)))))

RMS1/RMS2
% RMS1/RMS2 = 0.6171 

RMS3 = sum(sum(sqrt(((BlurOG-VonSC(VonISC(BlurOG),512,512)).^2)/(size(u,1)*size(u,2)))))


