function [back] = VonISC(out)

pivot=4.0981e-3;
B=56.0941;
dead=310;
fs=25e6;%sampling frequency
MAXDEPTH=512;

scsamp=2.4640e-04;
NX=size(out,2); %output dim's
NZ=size(out,1);
ZI = dead/fs*1540/2+(0:NZ-1)*scsamp*512/NZ;
XI= ((NX-1)/2.:-1:-(NX-1)/2)*scsamp*512/NZ;
Z = (0:MAXDEPTH-1)*scsamp+dead/fs/2*1540;
ZI = ZI + pivot;
Z = Z+pivot;

th = -B/2:B/127:B/2;


for angleInd = 1:128
    for depthInd = 1: MAXDEPTH
        ZZ(angleInd,depthInd) = Z(depthInd)*cos(th(angleInd)*pi/180);
        XX(angleInd,depthInd) = Z(depthInd)*sin(th(angleInd)*pi/180);
    end
end

back = fliplr(interp2(repmat(XI,[NZ 1]),repmat(ZI,[NX 1])',out,XX',ZZ','linear',0.00001));

end