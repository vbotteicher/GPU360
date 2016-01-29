extern "C"{

#include <EGL/egl.h>
}
#include <stdio.h>
#include <signal.h>
#include <execinfo.h>
#include <unistd.h>
#include <stdlib.h>
#include "scanconvertwork.h"
#include <GLES3/gl3.h>
#include "loadShader.h"
#include <math.h>

ScanConvertWork::ScanConvertWork(GLuint inputTex, GLuint outputTex, const char * vert,const char * frag) : Work(inputTex, outputTex, vert, frag) {}

void ScanConvertWork::Draw(GLuint framebuffer,GLuint vertexbuffer,GLuint uvbuffer)
{   
    glViewport(0,0,TEXTURE_WIDTH,TEXTURE_HEIGHT);
    glUseProgram(Program);
    GLuint BlurTextureLocation = glGetUniformLocation(Program, "myTextureSampler");
// Draw triangle...

    

    glUniform1f(glGetUniformLocation( Program, "maxF"), PACK_MAX);
    glUniform1f(glGetUniformLocation( Program, "minF"), PACK_MIN);
   
    #define HSECTOR				28.0470F
    #define STRIPTHETA 	(2*M_PI*HSECTOR/HSTRIPS/360.0F) /* Angle per sector strip.          	*/
    float Rb, Rs, vOfs, n_, w_, thetaR, thetaL;
    Rs = 0.1;
    Rb = 2.0;
    vOfs = -1.0;
    #define DTW		(1.0/(2.0*HSTRIPS))   /* width of each strip in texture co-ordinates.   */ 
    #define NPTF		1.0F   	/* non power of 2 factor */
      
   
    int i;
    for(i=0;i<(2*HSTRIPS);i++){
    //for(i=1;i<2;i++){
        thetaL=(-HSTRIPS+i)*STRIPTHETA;
        thetaR=thetaL+STRIPTHETA;
        
        w_=2*Rb*sinf(STRIPTHETA*0.5F); /* length of chord on bottom of each strip (w_ for wide). */
        n_=2*Rs*sinf(STRIPTHETA*0.5F); /* length of chord on top of each strip (n_ for narrow).  */
    //w_=1.0; /* length of chord on bottom of each strip (w_ for wide). */
 
        sc_vertex_buffer_data[18*i] = Rs*sinf(thetaL);//*n_;  TL
        //printf("top left x %f\n", Rs*sinf(thetaL));
        sc_vertex_buffer_data[18*i+1] = vOfs+Rs*cosf(thetaL);
        sc_vertex_buffer_data[18*i+2] = 0.0f;
   
        sc_vertex_buffer_data[18*i+3] = Rs*sinf(thetaR);//*n_; TR
        sc_vertex_buffer_data[18*i+4] = vOfs+Rs*cosf(thetaR);
        sc_vertex_buffer_data[18*i+5] = 0.0f;
   
        sc_vertex_buffer_data[18*i+6] = Rb*sinf(thetaL);    // BL
        sc_vertex_buffer_data[18*i+7] = vOfs+Rb*cosf(thetaL);
        //printf("bottom left y %f\n", vOfs+Rb*cosf(thetaL));
        sc_vertex_buffer_data[18*i+8] = 0.0f;
   
        sc_vertex_buffer_data[18*i+9] = Rb*sinf(thetaL);    // BL
        sc_vertex_buffer_data[18*i+10] = vOfs+Rb*cosf(thetaL);
        sc_vertex_buffer_data[18*i+11] =  0.0f;
   
        sc_vertex_buffer_data[18*i+12] = Rs*sinf(thetaR); //*n_; TR
        sc_vertex_buffer_data[18*i+13] = vOfs+Rs*cosf(thetaR);
        sc_vertex_buffer_data[18*i+14] =  0.0f;
   
        sc_vertex_buffer_data[18*i+15] = Rb*sinf(thetaR);   // BR
        sc_vertex_buffer_data[18*i+16] = vOfs+Rb*cosf(thetaR);
        sc_vertex_buffer_data[18*i+17] =  0.0f;
        
        
        
        sc_uv_buffer_data[24*i]= i*DTW;//*n_; // TL.s	
	    sc_uv_buffer_data[24*i+1]= 0.0f;    // TL.t
		sc_uv_buffer_data[24*i+2]= 0.0f;
		sc_uv_buffer_data[24*i+3]= 1.0;//*n_;  // TL.q - scale projective component by w_ for wide part of strip 
		
		sc_uv_buffer_data[24*i+4]=(i+1)*DTW;//*n_;  // TR.s	
		sc_uv_buffer_data[24*i+5]=0.0f;     // TR.t
		sc_uv_buffer_data[24*i+6]=0.0f;
		sc_uv_buffer_data[24*i+7]= 1.0;//*n_;  // TR.q - scale projective component by n_ for narrow part of strip 
		sc_uv_buffer_data[24*i+8]=i*DTW;     // BL.s	
		sc_uv_buffer_data[24*i+9]=1.0f;     // BL.t
		sc_uv_buffer_data[24*i+10]=0.0f;
		sc_uv_buffer_data[24*i+11]=1.0f;    // BL.q - scale projective component by w_ for wide part of strip 
		
		sc_uv_buffer_data[24*i+12]=i*DTW; // BL.s	
		sc_uv_buffer_data[24*i+13]=1.0f; // BL.t
		sc_uv_buffer_data[24*i+14]=0.0f;
		sc_uv_buffer_data[24*i+15]=1.0f; // BL.q -0 scale projective component by n_ for narrow part of strip 

        sc_uv_buffer_data[24*i+16]=(i+1)*DTW;//*n_; // TR.s	
		sc_uv_buffer_data[24*i+17]=0.0f; // TR.t
		sc_uv_buffer_data[24*i+18]=0.0f;
		sc_uv_buffer_data[24*i+19]=1.0;//*n_; // TR.q -0 scale projective component by n_ for narrow part of strip 
		sc_uv_buffer_data[24*i+20]=(i+1)*DTW; // BR.s	
		sc_uv_buffer_data[24*i+21]=1.0f; // BR.t
		sc_uv_buffer_data[24*i+22]=0.0f;
		sc_uv_buffer_data[24*i+23]=1.0f; // BR.q -0 scale projective component by n_ for narrow part of strip 
}
   
 
    glGenBuffers(1, &sc_vertexbuffer);

        glBindBuffer(GL_ARRAY_BUFFER, sc_vertexbuffer);
   glBufferData(GL_ARRAY_BUFFER, sizeof(sc_vertex_buffer_data), sc_vertex_buffer_data, GL_STATIC_DRAW);

		glGenBuffers(1, &sc_uv_buffer);

        glBindBuffer(GL_ARRAY_BUFFER, sc_uv_buffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(sc_uv_buffer_data), sc_uv_buffer_data, GL_STATIC_DRAW);
   
glEnableVertexAttribArray(0);
glBindBuffer(GL_ARRAY_BUFFER, sc_vertexbuffer);     
glVertexAttribPointer(
    0,                  // attribute 0. No particular reason for 0, but must match the layout in the shader.
    3,                  // size
    GL_FLOAT,           // type
    GL_FALSE, 
    0,                  // stride
    (void*)0            // array buffer offset
 );
 
glEnableVertexAttribArray(1);
glBindBuffer(GL_ARRAY_BUFFER, sc_uv_buffer);
glVertexAttribPointer(
			1,                                // attribute. No particular reason for 1, but must match the layou
			4,                                // size : U+V => 2
			GL_FLOAT,                         // type
			GL_FALSE,                         // normalized?
			0,                                // stride
			(void*)0                          // array buffer offset
);

//glBindFramebuffer(GL_FRAMEBUFFER, 0);
//glBindTexture(GL_TEXTURE_2D,0);
glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);   
glClear(GL_COLOR_BUFFER_BIT);
glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,GL_TEXTURE_2D, outputTexture, 0);
//printf("A. GPU ERROR: %i\n", glGetError() );
glActiveTexture(GL_TEXTURE0);
glBindTexture(GL_TEXTURE_2D, inputTexture);

glUniform1i(BlurTextureLocation, 0);


glDrawArrays(GL_TRIANGLES, 0, 6*2*HSTRIPS); 
//printf("SCDump\n");
//dump_image("SCDump.dat");
//printf("SCDump\n");
//glBindFramebuffer(GL_FRAMEBUFFER, 0);
//glBindTexture(GL_TEXTURE_2D,0);
}
