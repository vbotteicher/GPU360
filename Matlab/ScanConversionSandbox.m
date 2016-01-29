
Tile = [ 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
  0,0,0,0,0,0,0,0,1,1,1,1,1,1,1;
  0,0,0,0,0,0,0,0,1,1,1,1,1,1,1;
  0,0,0,0,0,0,0,0,1,1,1,1,1,1,1;
  0,0,0,0,0,0,0,0,1,1,1,1,1,1,1;
  0,0,0,0,0,0,0,0,1,1,1,1,1,1,1;
  0,0,0,0,0,0,0,0,1,1,1,1,1,1,1;
  0,0,0,0,0,0,0,0,1,1,1,1,1,1,1];
 Tile = [zeros(99,40);zeros(1,39),1];
%TestImage = repmat(Tile,[34,12]);
%TestImage = [TestImage;zeros(2,size(TestImage,2))];
%TestImage = [TestImage,zeros(size(TestImage,1),8)];
TestImage = repmat(Tile,[5,3]);
TestImage = [TestImage;zeros(12,size(TestImage,2))];
TestImage = [TestImage,zeros(size(TestImage,1),8)];
TestImage = circshift(TestImage,[0 -20]);
%%

figure(1);
subplot(1,2,1)
imagesc(GFilter(TestImage,size(sc,1)/100,size(sc,2)/100)); colormap gray;
title('PSFs Pre SC')
set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', []);
set(gca, 'YTickLabelMode', 'manual', 'YTickLabel', []);
subplot(1,2,2)
imagesc(VonSC(GFilter(TestImage,size(sc,1)/100,size(sc,2)/100),512,512)); colormap gray;
title('PSFs Post SC')
set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', []);
set(gca, 'YTickLabelMode', 'manual', 'YTickLabel', []);
%%
back = VonISC(TestImage);
[sc,r,theta] = VonSC(back,512,512);
blursc = GFilter(sc,size(sc,1)/100,size(sc,2)/100);
blurback = GFilter(back,size(sc,1)/100,size(sc,2)/100);
blurbacksc = VonSC(blurback,512,512);
%%

figure(1);
subplot(1,3,1)
imagesc(TestImage); colormap gray;
subplot(1,3,2)
imagesc(back); colormap gray;
subplot(1,3,3)
imagesc(sc); colormap gray
figure(2);
subplot(1,3,1)
imagesc(blursc); colormap gray
subplot(1,3,2)
imagesc(blurback); colormap gray
subplot(1,3,3)
imagesc(blurbacksc); colormap gray
%%
R = interp2(repmat(1:512,[512,1]),repmat([1:512]',[1,512]),r',repmat(2:4:512,[512,1]),repmat([1:512]',[1,128]),'linear',0);
Theta = interp2(repmat(1:512,[512,1]),repmat([1:512]',[1,512]),theta',repmat(2:4:512,[512,1]),repmat([1:512]',[1,128]),'linear',0);
figure(3);
subplot(1,2,1)
imagesc(abs(theta)')
subplot(1,2,2)
imagesc(abs(Theta))
%imagesc(abs(theta)')

%%

sigma1 = size(sc,1)/100;
sigma2 = size(sc,2)/100;
alpha1 = 0.5*sigma1;
alpha2 = 0.5*sigma2;
beta1 = 0.01*sigma1;
beta2 = 0.01*sigma2;
delta1 = 0.001*sigma1;
delta2 = 0.001*sigma2;

[SpatVarBack] = SpatVarGFilter(back,alpha1*ones(size(back))+beta1*R + ...
    delta1*abs(Theta),alpha2*ones(size(back))+beta2*R + delta2*abs(Theta),20);
[SpatVarBackSC] = VonSC(SpatVarBack,512,512);
counter = counter +1;
error(counter) = sum(sum(abs(blursc-SpatVarBackSC)));
%%
figure(4);
subplot(1,3,1)
imagesc(blursc); colormap gray
subplot(1,3,2)
imagesc(SpatVarBackSC); colormap gray
subplot(1,3,3)
imagesc(abs(blursc-SpatVarBackSC)); colormap gray

