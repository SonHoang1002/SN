#include <bnb/glsl.frag>



BNB_DECLARE_SAMPLER_2D(0, 1, glfx_BACKGROUND);
BNB_IN(0) vec2 var_bg_uv;


void main()
{
	bnb_FragColor = vec4( BNB_TEXTURE_2D(BNB_SAMPLER_2D(glfx_BACKGROUND), var_bg_uv ).xyz, 1. );
}
