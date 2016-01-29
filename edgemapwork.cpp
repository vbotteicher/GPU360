extern "C"{

#include <EGL/egl.h>
}
#include <stdio.h>
#include <signal.h>
#include <execinfo.h>
#include <unistd.h>
#include <stdlib.h>
#include "edgemapwork.h"
#include <GLES3/gl3.h>
#include "loadShader.h"

EdgeMapWork::EdgeMapWork(GLuint inputTex, GLuint outputTex, const char * vert,const char * frag, GLuint inputTex2) : Work(inputTex, outputTex, vert, frag) {inputTexture2 = inputTex2;}

void EdgeMapWork::Draw(GLuint framebuffer,GLuint vertexbuffer,GLuint uvbuffer)
{
glUseProgram(Program);
GLuint uxTextureLocation = glGetUniformLocation(Program, "uxTextureSampler");
GLuint uyTextureLocation = glGetUniformLocation(Program, "uyTextureSampler");
// Draw triangle...
glUniform1f(glGetUniformLocation( Program, "texelWidth"), 1.0/(float)TEXTURE_WIDTH); 
glUniform1f(glGetUniformLocation( Program, "texelHeight"), 1.0/(float)TEXTURE_HEIGHT); 


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
glUniform1i(uxTextureLocation, 0);
//printf("B. GPU ERROR: %i\n", glGetError() );
glActiveTexture(GL_TEXTURE0+1);
glBindTexture(GL_TEXTURE_2D, inputTexture2);
glUniform1i(uyTextureLocation, 1);
//printf("C. GPU ERROR: %i\n", glGetError() );


glDrawArrays(GL_TRIANGLES, 0, 6); 

//dump_image("edgeDump.dat");
//printf("edgeDump\n");

}
