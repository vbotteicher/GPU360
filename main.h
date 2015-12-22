#include <EGL/egl.h>
//#include <GL/gl.h>
#include <GLES3/gl3.h>
	
#define PACK_MAX			255.0F
#define	PACK_MIN			-256.0F
	
int w;
int h;
unsigned char dummyData[4*128*128];
	
GLushort m_indices2[6];
GLfloat m_vVertices2[12];
GLfloat m_vLocs2[4*4];
	
GLint m_attPosition; 
GLint m_texCoordLoc;
	
	
