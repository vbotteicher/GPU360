extern "C"{

#include <EGL/egl.h>
}
#include <stdio.h>
#include <signal.h>
#include <execinfo.h>
#include <unistd.h>
#include <stdlib.h>
#include "sep3x3axwork.h"
#include <GLES3/gl3.h>
#include "loadShader.h"

Sep3x3AxWork::Sep3x3AxWork(GLuint inputTex, GLuint outputTex, const char * vert,const char * frag, float * kernel3x3) : Work(inputTex, outputTex, vert, frag) {kernel = kernel3x3;}

void Sep3x3AxWork::Draw(GLuint framebuffer,GLuint vertexbuffer,GLuint uvbuffer)
{
  
    glUseProgram(Program);
    GLuint BlurTextureLocation = glGetUniformLocation(Program, "myTextureSampler");
// Draw triangle...


glUniform1f(glGetUniformLocation( Program, "texelWidth"), 1.0/((float)TEXTURE_WIDTH/2.0)); 
glUniform1f(glGetUniformLocation( Program, "texelHeight"), 1.0/((float)TEXTURE_HEIGHT/2.0)); 
glUniform1f(glGetUniformLocation( Program, "convAxial"), 1.0); 
glUniform1f(glGetUniformLocation( Program, "convLateral"), 0.0); 

glUniform1f(glGetUniformLocation( Program, "convKernel_0"), kernel[0]); 
glUniform1f(glGetUniformLocation( Program, "convKernel_1"), kernel[1]); 
glUniform1f(glGetUniformLocation( Program, "convKernel_2"), kernel[2]);
glUniform1f(glGetUniformLocation( Program, "convKernel_3"), 0.2);
glUniform1f(glGetUniformLocation( Program, "convKernel_4"), 0.2);


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
glBindTexture(GL_TEXTURE_2D, inputTexture);

glUniform1i(BlurTextureLocation, 0);


glDrawArrays(GL_TRIANGLES, 0, 6); 
//dump_image_DS("3x3ax.dat");
//printf("3x3ax\n");
//glBindFramebuffer(GL_FRAMEBUFFER, 0);
//glBindTexture(GL_TEXTURE_2D,0);
}
