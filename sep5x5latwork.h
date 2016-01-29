#include <GLES3/gl3.h>
#include "work.h"

class Sep5x5LatWork : public Work
{
public:
    Sep5x5LatWork(GLuint inputTex, GLuint outputTex, const char * vert,const char * frag, float * kernel5x5);
    void Draw(GLuint framebuffer,GLuint vertexbuffer,GLuint uvbuffer);
    float * kernel;
    
};
