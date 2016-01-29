#include <GLES3/gl3.h>
#include "work.h"

class Eff5x5AxWork : public Work
{
public:
    Eff5x5AxWork(GLuint inputTex, GLuint outputTex, const char * vert, const char * frag, float * kernel5x5);
    void Draw(GLuint framebuffer,GLuint vertexbuffer,GLuint uvbuffer);
    float * kernel;
    float fetchIndex[3];
	float sm_kernel[3];
};
