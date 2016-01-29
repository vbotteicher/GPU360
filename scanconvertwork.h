#include <GLES3/gl3.h>
#include "work.h"

#define HSTRIPS		128	/* Half the number of quadrilateral strips.       	*/

class ScanConvertWork : public Work
{
public:
    ScanConvertWork(GLuint inputTex, GLuint outputTex, const char * vert, const char * frag);
    void Draw(GLuint framebuffer,GLuint vertexbuffer,GLuint uvbuffer);
    GLfloat sc_vertex_buffer_data[18*2*HSTRIPS];
    GLfloat sc_uv_buffer_data[24*2*HSTRIPS];
    GLuint sc_vertexbuffer;
    GLuint sc_uv_buffer;
    GLuint m_indices2[6];
    GLfloat m_vVertices2[12];
    GLfloat m_vLocs2[16];
};
