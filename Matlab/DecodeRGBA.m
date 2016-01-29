function [v] = DecodeRGBA(Img,MaxF,MinF)

v = zeros(size(Img,2),size(Img,3));
for col = 1:size(Img,2)
    for row = 1:size(Img,3)
        v(col,row) = (MaxF-MinF)*decode(Img(1,col,row),Img(2,col,row),Img(3,col,row),Img(4,col,row)+1/255) + MinF;
    end
end
        