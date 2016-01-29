CXX_FLAGS_MORE=-DEGL_API_FB -DLINUX 
all: main
clean:
	rm -f main
	rm -f main.o
	rm -f textfile.o
	rm -f loadShader.o
	rm -f gpu360.o
	rm -f work.o
	rm -f rgbapackwork.o
	rm -f float2rgbapackwork.o
	rm -f rgbaunpackwork.o
	rm -f sep3x3axwork.o
	rm -f sep3x3latwork.o
	rm -f sep5x5axwork.o
	rm -f sep5x5latwork.o
	rm -f eff5x5axwork.o
	rm -f eff5x5latwork.o
	rm -f edgemapwork.o
	rm -f blendimagework.o
	rm -f blendimageHDwork.o
	rm -f scanconvertwork.o
	rm -f scanconvertwork2.o
	rm -f downsamplework.o
	rm -f gradientandedgework.o
main: main.o textfile.o loadShader.o gpu360.o work.o rgbapackwork.o float2rgbapackwork.o rgbaunpackwork.o sep3x3axwork.o sep3x3latwork.o sep5x5axwork.o sep5x5latwork.o eff5x5axwork.o eff5x5latwork.o edgemapwork.o blendimagework.o blendimageHDwork.o scanconvertwork.o scanconvertwork2.o downsamplework.o gradientandedgework.o
	$(CXX) main.o textfile.o loadShader.o gpu360.o rgbapackwork.o float2rgbapackwork.o rgbaunpackwork.o sep3x3axwork.o sep3x3latwork.o sep5x5axwork.o sep5x5latwork.o eff5x5axwork.o eff5x5latwork.o work.o edgemapwork.o blendimagework.o blendimageHDwork.o scanconvertwork.o scanconvertwork2.o downsamplework.o gradientandedgework.o -lEGL -lGLESv2 -o main -I./ 
main.o: gpu360.o main.cpp main.h 
	$(CXX) $(CXX_FLAGS_MORE) -Wall -g -std=c++11 -rdynamic main.cpp -c -o main.o -I./
textfile.o:		
	$(CXX)  $(CXX_FLAGS_MORE) -c textfile.cpp -o textfile.o
loadShader.o:		
	$(CXX)  $(CXX_FLAGS_MORE) -c loadShader.cpp -o loadShader.o
gpu360.o: gpu360.cpp gpu360.h 
	$(CXX)  $(CXX_FLAGS_MORE) -c gpu360.cpp -o gpu360.o
work.o: work.cpp work.h
	$(CXX)  $(CXX_FLAGS_MORE) -c work.cpp -o work.o
rgbapackwork.o: work.o rgbapackwork.cpp rgbapackwork.h
	$(CXX)  $(CXX_FLAGS_MORE) -c rgbapackwork.cpp -o rgbapackwork.o
float2rgbapackwork.o: work.o float2rgbapackwork.cpp float2rgbapackwork.h
	$(CXX)  $(CXX_FLAGS_MORE) -c float2rgbapackwork.cpp -o float2rgbapackwork.o
rgbaunpackwork.o: work.o rgbaunpackwork.cpp rgbaunpackwork.h
	$(CXX)  $(CXX_FLAGS_MORE) -c rgbaunpackwork.cpp -o rgbaunpackwork.o
sep3x3axwork.o: work.o sep3x3axwork.cpp sep3x3axwork.h
	$(CXX)  $(CXX_FLAGS_MORE) -c sep3x3axwork.cpp -o sep3x3axwork.o
sep3x3latwork.o: work.o sep3x3latwork.cpp sep3x3latwork.h
	$(CXX)  $(CXX_FLAGS_MORE) -c sep3x3latwork.cpp -o sep3x3latwork.o
sep5x5axwork.o: work.o sep5x5axwork.cpp sep5x5axwork.h
	$(CXX)  $(CXX_FLAGS_MORE) -c sep5x5axwork.cpp -o sep5x5axwork.o
sep5x5latwork.o: work.o sep5x5latwork.cpp sep5x5latwork.h
	$(CXX)  $(CXX_FLAGS_MORE) -c sep5x5latwork.cpp -o sep5x5latwork.o
eff5x5axwork.o: work.o eff5x5axwork.cpp eff5x5axwork.h
	$(CXX)  $(CXX_FLAGS_MORE) -c eff5x5axwork.cpp -o eff5x5axwork.o
eff5x5latwork.o: work.o eff5x5latwork.cpp eff5x5latwork.h
	$(CXX)  $(CXX_FLAGS_MORE) -c eff5x5latwork.cpp -o eff5x5latwork.o
edgemapwork.o: work.o edgemapwork.cpp edgemapwork.h
	$(CXX)  $(CXX_FLAGS_MORE) -c edgemapwork.cpp -o edgemapwork.o
blendimagework.o: work.o blendimagework.cpp blendimagework.h
	$(CXX)  $(CXX_FLAGS_MORE) -c blendimagework.cpp -o blendimagework.o
blendimageHDwork.o: work.o blendimageHDwork.cpp blendimageHDwork.h
	$(CXX)  $(CXX_FLAGS_MORE) -c blendimageHDwork.cpp -o blendimageHDwork.o
scanconvertwork.o: work.o scanconvertwork.cpp scanconvertwork.h
	$(CXX)  $(CXX_FLAGS_MORE) -c scanconvertwork.cpp -o scanconvertwork.o
scanconvertwork2.o: work.o scanconvertwork2.cpp scanconvertwork2.h
	$(CXX)  $(CXX_FLAGS_MORE) -c scanconvertwork2.cpp -o scanconvertwork2.o
downsamplework.o: work.o downsamplework.cpp downsamplework.h
	$(CXX)  $(CXX_FLAGS_MORE) -c downsamplework.cpp -o downsamplework.o
gradientandedgework.o: work.o gradientandedgework.cpp gradientandedgework.h
	$(CXX)  $(CXX_FLAGS_MORE) -c gradientandedgework.cpp -o gradientandedgework.o
