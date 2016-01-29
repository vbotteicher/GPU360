#include <GLES3/gl3.h>
#include "work.h"

class BlendImageWorkHD : public Work
{
public:
    BlendImageWorkHD(GLuint inputTex, GLuint outputTex, const char * vert,const char * frag, GLuint edgeMapTex, GLuint LFTex,GLuint uyTex);
    void Draw(GLuint framebuffer,GLuint vertexbuffer,GLuint uvbuffer);
    GLuint edgeMapTexture;
    GLuint LFTexture;
    GLuint uyTexture;
};
