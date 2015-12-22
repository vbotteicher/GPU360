CXX_FLAGS_MORE=-DEGL_API_FB -DLINUX 
all: main
clean:
	rm -f main
	rm -f main.o
	rm -f textfile.o
	rm -f loadShader.o
	rm -f gpu360.o
	rm -f work.o
main: main.o textfile.o loadShader.o gpu360.o work.o
	$(CXX) main.o textfile.o loadShader.o gpu360.o work.o -lEGL -lGLESv2 -o main -I./
main.o: gpu360.o main.cpp main.h 
	$(CXX) $(CXX_FLAGS_MORE) -Wall -g -rdynamic main.cpp -c -o main.o -I./
textfile.o:		
	$(CXX)  $(CXX_FLAGS_MORE) -c textfile.cpp -o textfile.o
loadShader.o:		
	$(CXX)  $(CXX_FLAGS_MORE) -c loadShader.cpp -o loadShader.o
gpu360.o: gpu360.cpp gpu360.h 
	$(CXX)  $(CXX_FLAGS_MORE) -c gpu360.cpp -o gpu360.o
work.o: work.cpp work.h
	$(CXX)  $(CXX_FLAGS_MORE) -c work.cpp -o work.o
