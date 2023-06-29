#include <bnb/glsl.frag>


//#define BNB_USE_SHADOW

#define GLFX_TBN
#define GLFX_MRAO
//#define GLFX_USE_BG

BNB_IN(0) vec2 var_uv;
#ifdef GLFX_TBN
BNB_IN(1) vec3 var_t;
BNB_IN(2) vec3 var_b;
#endif
BNB_IN(3) vec3 var_n;
BNB_IN(4) vec3 var_v;


#ifdef GLFX_USE_BG
BNB_IN(5) vec2 var_bg_uv;

BNB_DECLARE_SAMPLER_2D(6, 7, glfx_BACKGROUND);
#else

BNB_DECLARE_SAMPLER_2D(0, 1, tex_diffuse);
#endif
#ifdef GLFX_TBN

BNB_DECLARE_SAMPLER_2D(2, 3, tex_normal);
#endif
#ifdef GLFX_MRAO

BNB_DECLARE_SAMPLER_2D(4, 5, tex_MRAO);
#else
#endif

#ifdef BNB_USE_SHADOW

BNB_IN(6) vec3 var_shadow_coord;
float glfx_shadow_factor()
{

	vec2 offsets[4];
	offsets[0] = vec2( -0.94201624, -0.39906216 );
	offsets[1] = vec2( 0.94558609, -0.76890725 );
	offsets[2] = vec2( -0.094184101, -0.92938870 );
	offsets[3] = vec2( 0.34495938, 0.29387760 );
	float s = 0.;
	for( int i = 0; i != 4 /*assume that offsets.length() was called.*/; ++i )
		s += texture( glfx_SHADOW, var_shadow_coord + vec3(offsets[i]/110.,0.1) );
	s *= 0.125;
	return s;
}
#endif

// gamma to linear
vec3 g2l( vec3 g )
{
	return g*(g*(g*0.305306011+0.682171111)+0.012522878);
}

// linear to gamma
vec3 l2g( vec3 l )
{
	vec3 s = sqrt(l);
	vec3 q = sqrt(s);
	return 0.662002687*s + 0.68412206*q - 0.323583601*sqrt(q) - 0.022541147*l;
}

vec3 fresnel_schlick( float prod, vec3 F0 )
{
	return F0 + ( 1. - F0 )*pow( 1. - prod, 5. );
}

float distribution_GGX( float cN_H, float roughness )
{
	float a = roughness*roughness;
	float a2 = a*a;
	float d = cN_H*cN_H*( a2 - 1. ) + 1.;
	return a2/(3.14159265*d*d);
}

float geometry_schlick_GGX( float NV, float roughness )
{
	float r = roughness + 1.;
	float k = r*r/8.;
	return NV/( NV*( 1. - k ) + k );
}

float geometry_smith( float cN_L, float ggx2, float roughness )
{
	return geometry_schlick_GGX( cN_L, roughness )*ggx2;
}

float diffuse_factor( float n_l, float w )
{
	float w1 = 1. + w;
	return pow( max( 0., n_l + w )/w1, w1 );
}

// direction in xyz, lwrap in w

void main()
{
	vec3 radiance[2];
	radiance[1] = vec3(1.,1.,1.)*0.9*2.;
	radiance[0] = vec3(1.,1.,1.)*2.;
	vec4 lights[2];
	lights[1] = vec4(normalize(vec3(97.6166,-48.185,183.151)),1.);
	lights[0] = vec4(0.,0.6,0.8,1.);
#ifdef GLFX_USE_BG
	vec4 base_opacity = vec4( BNB_TEXTURE_2D(BNB_SAMPLER_2D(glfx_BACKGROUND), var_bg_uv ).xyz, 1. );
#else
	vec4 base_opacity = BNB_TEXTURE_2D(BNB_SAMPLER_2D(tex_diffuse),var_uv);
#endif

	//if( base_opacity.w < 0.5 ) discard;

	vec3 base = g2l(base_opacity.xyz)/**texture(tex_ao,var_uv).x*/;
	float opacity = base_opacity.w;
#ifdef GLFX_MRAO
	vec2 metallic_roughness = BNB_TEXTURE_2D(BNB_SAMPLER_2D(tex_MRAO),var_uv).xy;
	float metallic = metallic_roughness.x;
	float roughness = metallic_roughness.y;
#else
	float metallic = BNB_TEXTURE_2D(BNB_SAMPLER_2D(tex_metallic),var_uv).x;
	float roughness = BNB_TEXTURE_2D(BNB_SAMPLER_2D(tex_roughness),var_uv).x;
#endif

	vec3 color = 0.03*base;	// ambient
#ifdef GLFX_TBN
	vec3 N = normalize( mat3(var_t,var_b,var_n)*(BNB_TEXTURE_2D(BNB_SAMPLER_2D(tex_normal),var_uv).xyz*2.-1.) );
#else
	vec3 N = normalize( var_n );
#endif
	vec3 V = normalize( -var_v );
	float cN_V = max( 0., dot( N, V ) );
	float ggx2 = geometry_schlick_GGX( cN_V, roughness );
	vec3 F0 = mix( vec3(0.04), base, metallic );

	for( int i = 0; i != 2 /*assume that lights.length() was called.*/; ++i )
	{
		vec3 L = lights[i].xyz;
		float lwrap = lights[i].w;
		vec3 H = normalize( V + L );
		float N_L = dot( N, L );
		float cN_L = max( 0., N_L );
		float cN_H = max( 0., dot( N, H ) );
		float cH_V = max( 0., dot( H, V ) );

		float NDF = distribution_GGX( cN_H, roughness );
		float G = geometry_smith( cN_L, ggx2, roughness );
		vec3 F = fresnel_schlick( cH_V, F0 );

		vec3 specular = NDF*G*F/( 4.*cN_V*cN_L + 0.001 );

		vec3 kD = ( 1. - F )*( 1. - metallic );

		color += ( kD*base/3.14159265 + specular )*radiance[i]*diffuse_factor( N_L, lwrap )/*cN_L*/;
	}

#ifdef BNB_USE_SHADOW

	color = mix( color, vec3(0.), glfx_shadow_factor() );
#endif

	bnb_FragColor = vec4(l2g(color),opacity);
}

