#include <GLES3/gl3.h>

#ifndef WORK_H
#define WORK_H
#define PACK_MAX			256.0F // Be Careful! Could change rounding behavior
#define	PACK_MIN			-256.0F

#define TEXTURE_HEIGHT 512
#define TEXTURE_WIDTH 256

class Work 
{
public:
   
public:
    //ConvWorker();
    Work(GLuint inputTex, GLuint outputTex, const char * vert,const char * frag);
    ~Work();
    virtual void Draw(GLuint framebuffer,GLuint vertexbuffer,GLuint uvbuffer);
    int dump_image(const char *name);
    int dump_image_DS(const char *name);
    GLuint inputTexture;
    GLuint outputTexture;
    GLuint Program;
    
};
#endif
