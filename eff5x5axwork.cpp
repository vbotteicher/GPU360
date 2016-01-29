extern "C"{

#include <EGL/egl.h>
}
#include <stdio.h>
#include <signal.h>
#include <execinfo.h>
#include <unistd.h>
#include <stdlib.h>
#include "eff5x5axwork.h"
#include <GLES3/gl3.h>
#include "loadShader.h"

Eff5x5AxWork::Eff5x5AxWork(GLuint inputTex, GLuint outputTex, const char * vert,const char * frag, float * kernel5x5) : Work(inputTex, outputTex, vert, frag) {kernel = kernel5x5;}

void Eff5x5AxWork::Draw(GLuint framebuffer,GLuint vertexbuffer,GLuint uvbuffer)
{
    glUseProgram(Program);
    GLuint BlurTextureLocation = glGetUniformLocation(Program, "myTextureSampler");

    //float fetchIndex[3];
	fetchIndex[0] = (-2.0*kernel[0] -1*kernel[1])/(kernel[0]+kernel[1]); 
	fetchIndex[1] = 0;
	fetchIndex[2] = (2.0*kernel[4] +1*kernel[3])/(kernel[4]+kernel[3]);
	
	//float sm_kernel[3];
	sm_kernel[0] = kernel[0]+kernel[1];
	sm_kernel[1] = kernel[2];
	sm_kernel[2] = kernel[3]+kernel[4]; 
	

    glUniform1f(glGetUniformLocation( Program, "texelWidth"), fetchIndex[2]*1.0/(float)TEXTURE_WIDTH); 
    //     .. this will only work for symmetric filters
    glUniform1f(glGetUniformLocation( Program, "texelHeight"), fetchIndex[2]*1.0/(float)TEXTURE_HEIGHT);  
    //     .. this will only work for symmetric filters
    glUniform1f(glGetUniformLocation( Program, "convAxial"), 1.0); 
    glUniform1f(glGetUniformLocation( Program, "convLateral"), 0.0); 

    glUniform1f(glGetUniformLocation( Program, "convKernel_0"), sm_kernel[0]); 
    glUniform1f(glGetUniformLocation( Program, "convKernel_1"), sm_kernel[1]); 
    glUniform1f(glGetUniformLocation( Program, "convKernel_2"), sm_kernel[2]);



    glUniform1f(glGetUniformLocation( Program, "maxF"), PACK_MAX);
    glUniform1f(glGetUniformLocation( Program, "minF"), PACK_MIN);

    glEnableVertexAttribArray(0);
    glBindBuffer(GL_ARRAY_BUFFER, vertexbuffer);
    glVertexAttribPointer(
        0,                  // attribute 0. No particular reason for 0, but must match the layout in the shader.
        3,                  // size
        GL_FLOAT,           // type
        GL_FALSE, 
        0,                  // stride
        (void*)0            // array buffer offset
     );
 
    glEnableVertexAttribArray(1);
    glBindBuffer(GL_ARRAY_BUFFER, uvbuffer);
    glVertexAttribPointer(
    	1,                                // attribute. No particular reason for 1, but must match the layou
		2,                                // size : U+V => 2
   		GL_FLOAT,                         // type
		GL_FALSE,                         // normalized?
		0,                                // stride
		(void*)0                          // array buffer offset
    );


//glBindFramebuffer(GL_FRAMEBUFFER, 0);
//glBindTexture(GL_TEXTURE_2D,0);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);   

    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,GL_TEXTURE_2D, outputTexture, 0);
//printf("A. GPU ERROR: %i\n", glGetError() );
    glActiveTexture(GL_TEXTURE0);
//printf("B. GPU ERROR: %i\n", glGetError() );
    glBindTexture(GL_TEXTURE_2D, inputTexture);
//printf("C. GPU ERROR: %i\n", glGetError() );
    glUniform1i(BlurTextureLocation, 0);

//if (glCheckFramebufferStatus(GL_FRAMEBUFFER) == GL_FRAMEBUFFER_COMPLETE)
  //      printf("frame buffer OK\n");
        
    glDrawArrays(GL_TRIANGLES, 0, 6); 

dump_image("eff5x5ax.dat");
//printf("5x5Dump\n");

}
