extern "C"{

#include <EGL/egl.h>
}
#include <stdio.h>
#include <signal.h>
#include <execinfo.h>
#include <unistd.h>
#include <stdlib.h>
#include "float2rgbapackwork.h"
#include <GLES3/gl3.h>
#include "loadShader.h"

Float2RGBAPackWork::Float2RGBAPackWork(GLuint inputTex, GLuint outputTex, const char * vert,const char * frag) : Work(inputTex, outputTex, vert, frag) {}

void Float2RGBAPackWork::Draw(GLuint framebuffer,GLuint vertexbuffer,GLuint uvbuffer)
{

 glViewport(0,0,TEXTURE_WIDTH,TEXTURE_HEIGHT);
// 1rst attribute buffer : vertices
//  
glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
// Use our shader


glUseProgram(Program);
GLuint LuminanceTextureLocation = glGetUniformLocation(Program, "myTextureSampler");

glUniform1f(glGetUniformLocation( Program, "maxF"), PACK_MAX);
glUniform1f(glGetUniformLocation( Program, "minF"), PACK_MIN);


glBindFramebuffer(GL_FRAMEBUFFER, 0);
glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);   
glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,GL_TEXTURE_2D, outputTexture, 0);


glActiveTexture(GL_TEXTURE0);
glBindTexture(GL_TEXTURE_2D, inputTexture);
glUniform1i(LuminanceTextureLocation,0);


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
		
// Draw the triangle !
// Set our "myTextureSampler" sampler to user Texture Unit 0

//printf("2. GPU ERROR: %i\n", glGetError() );
glDrawArrays(GL_TRIANGLES, 0, 6); // Starting from vertex 0; 3 vertices total -> 1 triangle
//dump_image("Dump1.dat");
//printf("Dump1\n");
//printf("3. GPU ERROR: %i\n", glGetError() );

glDisableVertexAttribArray(0);
glDisableVertexAttribArray(1);
}
