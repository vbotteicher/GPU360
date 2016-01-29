function [ImgOut] = sepConv5x5(ImgIn,kernel,axOrLat)

PadImg = zeros(size(ImgIn,1)+4,size(ImgIn,2)+4);
%keyboard()
PadImg(3:end-2,3:end-2) = ImgIn;
PadImg(2,:) = PadImg(3,:);
PadImg(1,:) = PadImg(2,:);
PadImg(end-1,:) = PadImg(end-2,:);
PadImg(end,:) = PadImg(end-1,:);
PadImg(:,2) = PadImg(:,3);
PadImg(:,1) = PadImg(:,2);
PadImg(:,end-1) = PadImg(:,end-2);
PadImg(:,end) = PadImg(:,end-1);
ImgOut = zeros(size(ImgIn));
if axOrLat == 1
for i =  3:size(PadImg,1)-2
    for j =  3:size(PadImg,2)-2
        ImgOut(i-2,j-2) = kernel(1)*PadImg(i-2,j) + kernel(2)*PadImg(i-1,j)...
            + kernel(3)*PadImg(i,j) + kernel(4)*PadImg(i+1,j) + kernel(5)*PadImg(i+2,j);   
    end
end
else
for i =  3:size(PadImg,1)-2
    for j =  3:size(PadImg,2)-2
         ImgOut(i-2,j-2) = kernel(1)*PadImg(i,j-2) + kernel(2)*PadImg(i,j-1)...
            + kernel(3)*PadImg(i,j) + kernel(4)*PadImg(i,j+1) + kernel(5)*PadImg(i,j+2);  
    end
end
end