#include <GLES3/gl3.h>
#include "work.h"

class DownSampleWork : public Work
{
public:
    DownSampleWork(GLuint inputTex, GLuint outputTex, const char * vert, const char * frag);
    void Draw(GLuint framebuffer,GLuint vertexbuffer,GLuint uvbuffer);
   
};
