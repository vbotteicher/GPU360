#include <GLES3/gl3.h>
#include "work.h"

class Sep3x3AxWork : public Work
{
public:
    Sep3x3AxWork(GLuint inputTex, GLuint outputTex, const char * vert, const char * frag, float * kernel3x3);
   
    void Draw(GLuint framebuffer,GLuint vertexbuffer,GLuint uvbuffer);
    
    float * kernel;
};
