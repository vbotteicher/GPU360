#include <GLES3/gl3.h>
#include "work.h"

class RGBAPackWork : public Work
{
public:
    RGBAPackWork(GLuint inputTex, GLuint outputTex, const char * vert,const char * frag);
   ~RGBAPackWork();
    void Draw(GLuint framebuffer,GLuint vertexbuffer,GLuint uvbuffer);
};
