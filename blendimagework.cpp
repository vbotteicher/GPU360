extern "C"{

#include <EGL/egl.h>
}
#include <stdio.h>
#include <signal.h>
#include <execinfo.h>
#include <unistd.h>
#include <stdlib.h>
#include "blendimagework.h"
#include <GLES3/gl3.h>
#include "loadShader.h"

BlendImageWork::BlendImageWork(GLuint inputTex, GLuint outputTex, const char * vert,const char * frag,  GLuint edgeMapTex, GLuint LFTex, GLuint uyTex) : Work(inputTex, outputTex, vert, frag) 
{
    edgeMapTexture = edgeMapTex;
    LFTexture = LFTex;
    uyTexture = uyTex;
    
}

void BlendImageWork::Draw(GLuint framebuffer,GLuint vertexbuffer,GLuint uvbuffer)
{
    glUseProgram(Program);
    GLuint SmoothedLocation = glGetUniformLocation(Program, "smoothedTex");
    GLuint EdgeMapLocation = glGetUniformLocation(Program, "edgeMapTex");
    GLuint LFLocation = glGetUniformLocation(Program, "LFTex");
    GLuint uyLocation = glGetUniformLocation(Program, "uyTex");
    // Draw triangle...

    glUniform1f(glGetUniformLocation( Program, "wgtLF"), 0.5F);
    glUniform1f(glGetUniformLocation( Program, "wgtSmooth"), 0.5F);	


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
    glUniform1i(SmoothedLocation, 0);
    //printf("B. GPU ERROR: %i\n", glGetError() );
    glActiveTexture(GL_TEXTURE0+1);
    glBindTexture(GL_TEXTURE_2D, edgeMapTexture);    
    glUniform1i(EdgeMapLocation, 1);
    
    glActiveTexture(GL_TEXTURE0+2);
    glBindTexture(GL_TEXTURE_2D, LFTexture);    
    glUniform1i(LFLocation, 2);
    
    glActiveTexture(GL_TEXTURE0+3);
    glBindTexture(GL_TEXTURE_2D, uyTexture);    
    glUniform1i(uyLocation, 3);
    
    //if (glCheckFramebufferStatus(GL_FRAMEBUFFER) == GL_FRAMEBUFFER_COMPLETE)
        //printf("frame buffer OK\n");
    glDrawArrays(GL_TRIANGLES, 0, 6); 

    dump_image_DS("blendImage.dat");
    printf("blend Dump\n");

    }
