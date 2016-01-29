extern "C"{
#include <stdlib.h>
#include <unistd.h>
#include <EGL/egl.h>
//#include <GL/gl.h>

#define GL_GLEXT_PROTOTYPES 1

#include <GLES3/gl3.h>
#include <GLES2/gl2ext.h>
#include <stdio.h>
#include <signal.h>
#include <execinfo.h>
#include <stdlib.h>
#include <string.h>
#include <main.h>
#include <errno.h>
#include <fcntl.h>

/* system time include*/
#include <sys/time.h>
}
#include <math.h>
#include "gpu360.h"
#include <ctime>
#include <chrono>
#include <iostream>
#include <fstream>
#include "loadShader.h"


int dump_image(const char *name)//, float *dest, unsigned int nbytes)
{
    FILE * fp;
    fp = fopen(name,"wb");
    GLuint p[128*512];
    glReadBuffer(GL_COLOR_ATTACHMENT0);
    glReadPixels( 0, 0, 128, 512, GL_RGBA, GL_UNSIGNED_BYTE, p);
    printf("Read Pixels ERROR: %i\n", glGetError() );
    fwrite(&p, 4*128*512, 1, fp);
    fclose(fp); 
    return 0;
}

extern char * textFileRead(const char *);


int read_file(const char *name, char *dest, unsigned int nbytes)
{   
    int fd;
    unsigned int r, pos, chunk;
	
    fd=open(name, O_RDONLY);
    if(fd<0){
	return -1;
    }
    for(pos=0;pos<nbytes;){
	chunk=nbytes-pos;
	chunk=(chunk>4096)?4096:chunk;
	r=read(fd, (void *)&dest[pos], chunk);
	if(r<0){
		printf("Read error :%s:\n", strerror(errno));
		close(fd);
		return -1;
	}else if(r==0){
		return 0;
	}else{
	    //printf("%i \n",pos);
		pos=pos+r;
	}
    }
    close(fd);
    return 0;
}

int main(int argc, char ** argv)
{
    GPU360 *gpu;
    gpu=new GPU360();     
    gpu->setupTextureAndFBO();
    unsigned char scan0[128*512];


    printf("Bind. GPU ERROR: %i\n", glGetError() );

    gpu->setupVertexBuffers();
    printf("setupvertex. GPU ERROR: %i\n", glGetError() );

   
    //gpu->addWorkItem(new RGBAPackWork(gpu->readTextureID,gpu->processTextureID[0],   "lumToRGBA.vertexshader","lumToRGBA.fragmentshader", 0)); // the last argument is    the program type, a temporary placeholder until I figure out how I want to manage the different types of programs
    float blurKernel3x3[3] = {0.1664F, 0.6672F, 0.1664F};
    //float blurKernel3x3[3] = {0.33F, 0.33F, 0.33F};
    
    gpu->addWorkItem(new Float2RGBAPackWork(gpu->processTextureID[0],
                                          gpu->processTextureID[1],
                                         "IntToRGBA.vertexshader",
                                         "IntToRGBA.fragmentshader"));
                                            
    gpu->addWorkItem(new DownSampleWork(gpu->processTextureID[1],
                                      gpu->downSampleTextureID[0], 
                                      "downSample.vertexshader", 
                                      "downSample.fragmentshader"));
    
    gpu->addWorkItem(new Sep3x3AxWork(gpu->downSampleTextureID[0],
                                     gpu->downSampleTextureID[1], 
                                      "sepConv3x3.vertexshader", 
                                      "sepConv3x3.fragmentshader", 
                                      blurKernel3x3));
    
    
    gpu->addWorkItem(new Sep3x3LatWork(gpu->downSampleTextureID[1],
                                       gpu->downSampleTextureID[0], // blur in tex 0
                                       "sepConv3x3.vertexshader",
                                       "sepConv3x3.fragmentshader", 
                                        blurKernel3x3)); 
    
    float gradKernel3x3[3] = {-1.0,0.0,1.0};
    
    //gpu->addWorkItem(new Sep3x3AxWork(gpu->downSampleTextureID[0],
    //                                gpu->downSampleTextureID[3],  
    //                              "sepConv3x3.vertexshader",
    //                            "sepConv3x3.fragmentshader", 
    //                          gradKernel3x3)); 
    
    //gpu->addWorkItem(new Sep3x3LatWork(gpu->downSampleTextureID[0],
    //                                 gpu->downSampleTextureID[2],
    //                               "sepConv3x3.vertexshader",
    //                             "sepConv3x3.fragmentshader", 
    //                           gradKernel3x3));
    
    //gpu->addWorkItem(new EdgeMapWork(gpu->downSampleTextureID[2],
    //                                 gpu->downSampleTextureID[1],
    //                               "edgeMap.vertexshader",
    //                             "edgeMap.fragmentshader", 
    //                           gpu->downSampleTextureID[3]));
                                       
    gpu->addWorkItem(new GradientAndEdgeWork(gpu->downSampleTextureID[0],
                                       gpu->downSampleTextureID[1],
                                      "gradientAndEdge.vertexshader",
                                       "gradientAndEdge.fragmentshader", 
                                       gpu->downSampleTextureID[2],
                                       gpu->downSampleTextureID[3],// uy in tex 3
                                       gradKernel3x3));
                                       
                                       
                                 
                                       
    float edgeKernel5x5[5] = {0.1525F, 0.2218F, 0.2514F, 0.2218F, 0.1525F};
    //float edgeKernel5x5[5] = {0.0F, 0.0F, 1.0F, 0.0F, 0.0F};
    
    gpu->addWorkItem(new Sep5x5AxWork(gpu->downSampleTextureID[1],
                                       gpu->downSampleTextureID[2],
                                       "sepConv5x5.vertexshader",
                                       "sepConv5x5.fragmentshader", 
                                       edgeKernel5x5));
                                       
    gpu->addWorkItem(new Sep5x5LatWork(gpu->downSampleTextureID[2],
                                       gpu->downSampleTextureID[1],  // edgeMap in tex1
                                       "sepConv5x5.vertexshader",
                                       "sepConv5x5.fragmentshader", 
                                       edgeKernel5x5));
                                       
    float LFKernel5x5[5] = {0.1201F, 0.2239F, 0.2921F, 0.2239F, 0.1201F};
    //float LFKernel5x5[5] = {0.2F, 0.2F, 0.2F, 0.2F, 0.2F};
    
    
    gpu->addWorkItem(new Sep5x5LatWork(gpu->downSampleTextureID[0], // grab light blur
                                       gpu->downSampleTextureID[2],
                                       "sepConv5x5.vertexshader",
                                       "sepConv5x5.fragmentshader", 
                                       LFKernel5x5));
                                       
    gpu->addWorkItem(new Sep5x5AxWork(gpu->downSampleTextureID[2],
                                       gpu->downSampleTextureID[4],  //LF in tex4
                                       "sepConv5x5.vertexshader",
                                       "sepConv5x5.fragmentshader", 
                                       LFKernel5x5));
    
  
                                       
    gpu->addWorkItem(new BlendImageWork(gpu->downSampleTextureID[0],// grab light blur
                                        gpu->downSampleTextureID[2],
                                        "blendImage.vertexshader",
                                       "blendImage.fragmentshader", 
                                        gpu->downSampleTextureID[1], // grab edge
                                        gpu->downSampleTextureID[4], // grab LF
                                        gpu->downSampleTextureID[3])); // grab uy
                                        
    //gpu->addWorkItem(new BlendImageWorkHD(gpu->processTextureID[1],// grab light blur
    //                                     gpu->processTextureID[2],
    //                                     "blendImage.vertexshader",
    //                                     "blendImageHD.fragmentshader", 
    //                                     gpu->downSampleTextureID[1], // grab edge
    //                                     gpu->downSampleTextureID[4], // grab LF
    //                                     gpu->downSampleTextureID[3])); // grab uy
                                       

    gpu->addWorkItem(new RGBAUnpackWork(gpu->downSampleTextureID[2],
                                        gpu->downSampleTextureID[4],
                                        "renderFloatRGBA.vertexshader",
                                        "renderFloatRGBA.fragmentshader")); 
                                        
    //gpu->addWorkItem(new ScanConvertWork(gpu->processTextureID[1],
    //                                  gpu->processTextureID[3],
    //                                "scanConvert.vertexshader",
    //                              "scanConvert.fragmentshader")); 
         
    gpu->addWorkItem(new ScanConvertWork2(gpu->downSampleTextureID[4],
                                         gpu->processTextureID[3],
                                         "scanConvert2.vertexshader",
                                         "scanConvert2.fragmentshader")); 

    
    read_file("envIn.bin", (char *) scan0, 128*512);
    
    //read_file("gradient.bin", (char *) scan0, 128*512);
    
    //float scanF[128*512];
    int scan32[128*512];
    
   
    
  
     //glTexDirectVIVMap (GL_TEXTURE_2D,
       //             128,
         //           512,
           //         GL_RGBA,
             //       &pTexel);
                    
    //char *Logical = (char*) malloc (sizeof(char)*size);
    //Gluint physical = ~0U;
    //glTexDirectVIVMap(GL_TEXUTURE_2D, 
      //                512, 
        //              128, 
          //            GL_RGBA,
            //          (void**)&Logical, 
              //        &28hysical);
                      

             
    glBindTexture(GL_TEXTURE_2D, gpu->processTextureID[0]);
    GLvoid *pTexel;
    
    glTexDirectVIV (GL_TEXTURE_2D,
                    128,
                    512,
                    GL_RGBA,
                    &pTexel);  
                    
                    
    auto begin = std::chrono::system_clock::now();
    auto end = std::chrono::system_clock::now();
    std::chrono::duration<double> duration;
    std::string line;
    std::ofstream workLog;
    
    
    time_t t1;
	time_t t2;

	time(&t1);
	
	int iterations = 1;
	for (int i=0;i<iterations;i++)
	{
    //glBindTexture(GL_TEXTURE_2D, gpu->readTextureID);
    //glTexImage2D(GL_TEXTURE_2D, 0,GL_LUMINANCE, 128, 512, 0, GL_LUMINANCE,  GL_UNSIGNED_BYTE, scan0);
    
    ////////////////////////////////////////////////////////////////////
    //glActiveTexture(GL_TEXTURE0);
    //glBindTexture(GL_TEXTURE_2D, gpu->floatTextureID);
    //glTexImage2D(GL_TEXTURE_2D, 0,GL_R32F, 128, 512, 0, GL_RED, GL_FLOAT,  scanF);
    
    //glActiveTexture(GL_TEXTURE0+1);
    
    //glTexImage2D(GL_TEXTURE_2D, 0,GL_RGBA, 128, 512, 0, GL_RGBA, GL_UNSIGNED_BYTE,  scanRGBA);
    begin = std::chrono::system_clock::now();
    for (int index = 0; index < 128*512; index++){
             //scanF[index] =  scan0[index]*0.00392157f; // make sure between 0 and 1
             scan32[index] =  (int) scan0[index];
    }       
    //printf("GPU ERROR: %i\n", glGetError());
   
    memmove(pTexel,scan32,512*128*4);
    //printf("GPU ERROR: %i\n", glGetError());
    glTexDirectInvalidateVIV(GL_TEXTURE_2D);
    //printf("GPU ERROR: %i\n", glGetError());
    gpu->draw();
    workLog.open ("WorkSnap.txt");
    end = std::chrono::system_clock::now();
    duration = end-begin;
    workLog << std::to_string((float)1000*duration.count())<<"\n";
    workLog.close();
    //printf("GPU ERROR: %i\n", glGetError());
    }
   
    
    time(&t2);

    double seconds = difftime(t2,t1);
    //end = std::chrono::system_clock::now();
    //std::chrono::duration<double> duration = end-begin;
    //printf("%f ms per iteration\n", 1000*duration.count()/iterations);    
    printf("time per iteration = %f milliseconds\n", 1000.0f*seconds/(float)iterations);
    //dump_image("Dump4.dat");
    
    
  
    // delete work objects here (exiting imaging mode)
    //printf("Draw. GPU ERROR: %i\n", glGetError() );

	/*time_t t1;
	time_t t2;

	time(&t1);
	
	int iterations = 1;
	for (int i=0;i<iterations;i++)
	{
    }
    time(&t2);

    double seconds = difftime(t2,t1);

    printf("time per iteration = %f milliseconds\n", 1000.0f*seconds/(float)iterations);
*/
    //eglSwapBuffers(display, surface);
    delete(gpu);
    return EXIT_SUCCESS;
}


