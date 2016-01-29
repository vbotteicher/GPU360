#include <GLES3/gl3.h>
#include "work.h"
#include "rgbapackwork.h"
#include "float2rgbapackwork.h"
#include "rgbaunpackwork.h"
#include "sep3x3axwork.h"
#include "sep3x3latwork.h"
#include "sep5x5axwork.h"
#include "sep5x5latwork.h"
#include "eff5x5axwork.h"
#include "eff5x5latwork.h"
#include "edgemapwork.h"
#include "blendimagework.h"
#include "blendimageHDwork.h"
#include "scanconvertwork.h"
#include "scanconvertwork2.h"
#include "downsamplework.h"
#include "gradientandedgework.h"
#include <vector>


class GPU360
{
public:
	GPU360();

	~GPU360();
	void setupTextureAndFBO();
	void setupVertexBuffers(void);
	//void addWorkItem(GLuint inputTex,GLuint outputTex, const char * vert,const char * frag, int progType);
	void addWorkItem(Work * work);
	void draw(void);
	GLuint readTextureID;
	GLuint floatTextureID;
	GLuint processTextureID[5];
	GLuint downSampleTextureID[5];
	GLuint FramebufferName[2];
	int FBflipflop;
	GLfloat g_vertex_buffer_data[18];
	GLfloat g_uv_buffer_data[18];
	GLuint vertexbuffer;
	GLuint uvbuffer;
	Work * packWork;
	std::vector<Work*> workVector;
	//Work * workArray[4];
	
	Work *unpackWork;
	unsigned int workSize;
private:
    void setupEGL(void);
    void shutdownEGL(void);
    EGLDisplay display;
    EGLConfig config;
    EGLContext context;
    EGLSurface surface;
  
};


