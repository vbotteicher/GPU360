#include <GLES3/gl3.h>
#include "work.h"

class Float2RGBAPackWork : public Work
{
public:
    Float2RGBAPackWork(GLuint inputTex, GLuint outputTex, const char * vert,const char * frag);
   ~Float2RGBAPackWork();
    void Draw(GLuint framebuffer,GLuint vertexbuffer,GLuint uvbuffer);
};
