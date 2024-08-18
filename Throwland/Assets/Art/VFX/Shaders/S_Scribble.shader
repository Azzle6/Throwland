// Made with Amplify Shader Editor v1.9.3.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "S_Scribble"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		[Header(AlphaLerp)]_AlphaLerp_TexInfluence("AlphaLerp_TexInfluence", Range( 0 , 1)) = 0.2
		[Header(Panning Texture)]_PanningTex("PanningTex", 2D) = "white" {}
		[Toggle]_PanningTex_InvertUV("PanningTex_InvertUV", Float) = 0
		_PanningTex_ManualOffset("PanningTex_ManualOffset", Float) = 0
		[Header(Alpha Sharp)]_AlphaThreshold("AlphaThreshold", Float) = 0
		_AlphaSmoothness("AlphaSmoothness", Float) = 1
		[Toggle]_AlphaSharp_OneMinus("AlphaSharp_OneMinus", Float) = 0
		[Header(TimeStep)]_TimeStep("TimeStep", Float) = 10
		[Header(Distort Texture)]_DistortTex("DistortTex", 2D) = "white" {}
		_DistortStrength("DistortStrength", Float) = 0.2
		_Float0("DistortSubtract", Float) = 0.5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
		};

		uniform float _AlphaThreshold;
		uniform float _AlphaSmoothness;
		uniform sampler2D _MainTex;
		uniform sampler2D _DistortTex;
		uniform float _PanningTex_ManualOffset;
		uniform float _PanningTex_InvertUV;
		uniform float _TimeStep;
		SamplerState sampler_DistortTex;
		uniform float4 _DistortTex_ST;
		uniform float _Float0;
		uniform float _DistortStrength;
		uniform sampler2D _PanningTex;
		SamplerState sampler_PanningTex;
		uniform float4 _PanningTex_ST;
		uniform float _AlphaLerp_TexInfluence;
		uniform float _AlphaSharp_OneMinus;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Emission = i.vertexColor.rgb;
			float temp_output_7_0_g48 = ( _AlphaThreshold + 0.0 );
			float4 appendResult43_g36 = (float4(0.0 , _PanningTex_ManualOffset , 0.0 , 0.0));
			float4 appendResult42_g36 = (float4(_PanningTex_ManualOffset , 0.0 , 0.0 , 0.0));
			float4 lerpResult41_g36 = lerp( appendResult43_g36 , appendResult42_g36 , _PanningTex_InvertUV);
			float temp_output_7_0_g1 = _TimeStep;
			float temp_output_4_0 = ( floor( ( _Time.y * temp_output_7_0_g1 ) ) / temp_output_7_0_g1 );
			float2 temp_output_1_0_g39 = _DistortTex_ST.zw;
			float2 break3_g39 = temp_output_1_0_g39;
			float4 appendResult5_g39 = (float4(break3_g39.y , break3_g39.x , 0.0 , 0.0));
			float4 lerpResult2_g39 = lerp( float4( temp_output_1_0_g39, 0.0 , 0.0 ) , appendResult5_g39 , _PanningTex_InvertUV);
			float2 temp_output_1_0_g40 = i.uv_texcoord;
			float2 break3_g40 = temp_output_1_0_g40;
			float4 appendResult5_g40 = (float4(break3_g40.y , break3_g40.x , 0.0 , 0.0));
			float4 lerpResult2_g40 = lerp( float4( temp_output_1_0_g40, 0.0 , 0.0 ) , appendResult5_g40 , _PanningTex_InvertUV);
			float2 temp_output_1_0_g38 = ( _DistortTex_ST.xy * float2( 1,1 ) );
			float2 break3_g38 = temp_output_1_0_g38;
			float4 appendResult5_g38 = (float4(break3_g38.y , break3_g38.x , 0.0 , 0.0));
			float4 lerpResult2_g38 = lerp( float4( temp_output_1_0_g38, 0.0 , 0.0 ) , appendResult5_g38 , _PanningTex_InvertUV);
			float2 panner1_g37 = ( temp_output_4_0 * (lerpResult2_g39).xy + ( (lerpResult2_g40).xy * (lerpResult2_g38).xy ));
			float4 tex2DNode2_g36 = tex2D( _DistortTex, ( ( float4( float2( 0,0 ), 0.0 , 0.0 ) + lerpResult41_g36 ).xy + panner1_g37 ), ddx( i.uv_texcoord ), ddy( i.uv_texcoord ) );
			float4 temp_output_31_0_g2 = tex2DNode2_g36;
			float4 temp_cast_6 = (_Float0).xxxx;
			float temp_output_14_0_g2 = ( _DistortStrength + 0.0 );
			float temp_output_17_0_g2 = 1.0;
			float4 appendResult43_g42 = (float4(0.0 , _PanningTex_ManualOffset , 0.0 , 0.0));
			float4 appendResult42_g42 = (float4(_PanningTex_ManualOffset , 0.0 , 0.0 , 0.0));
			float4 lerpResult41_g42 = lerp( appendResult43_g42 , appendResult42_g42 , _PanningTex_InvertUV);
			float2 temp_output_1_0_g45 = _PanningTex_ST.zw;
			float2 break3_g45 = temp_output_1_0_g45;
			float4 appendResult5_g45 = (float4(break3_g45.y , break3_g45.x , 0.0 , 0.0));
			float4 lerpResult2_g45 = lerp( float4( temp_output_1_0_g45, 0.0 , 0.0 ) , appendResult5_g45 , _PanningTex_InvertUV);
			float2 temp_output_1_0_g46 = i.uv_texcoord;
			float2 break3_g46 = temp_output_1_0_g46;
			float4 appendResult5_g46 = (float4(break3_g46.y , break3_g46.x , 0.0 , 0.0));
			float4 lerpResult2_g46 = lerp( float4( temp_output_1_0_g46, 0.0 , 0.0 ) , appendResult5_g46 , _PanningTex_InvertUV);
			float2 temp_output_1_0_g44 = ( _PanningTex_ST.xy * float2( 1,1 ) );
			float2 break3_g44 = temp_output_1_0_g44;
			float4 appendResult5_g44 = (float4(break3_g44.y , break3_g44.x , 0.0 , 0.0));
			float4 lerpResult2_g44 = lerp( float4( temp_output_1_0_g44, 0.0 , 0.0 ) , appendResult5_g44 , _PanningTex_InvertUV);
			float2 panner1_g43 = ( temp_output_4_0 * (lerpResult2_g45).xy + ( (lerpResult2_g46).xy * (lerpResult2_g44).xy ));
			float4 tex2DNode2_g42 = tex2D( _PanningTex, ( ( float4( float2( 0,0 ), 0.0 , 0.0 ) + lerpResult41_g42 ).xy + panner1_g43 ), ddx( i.uv_texcoord ), ddy( i.uv_texcoord ) );
			float lerpResult1_g47 = lerp( tex2D( _MainTex, ( i.uv_texcoord + ( (( temp_output_31_0_g2 - temp_cast_6 )).rg * ( temp_output_14_0_g2 * temp_output_17_0_g2 ) ) ) ).a , tex2DNode2_g42.r , _AlphaLerp_TexInfluence);
			float temp_output_1_0_g48 = lerpResult1_g47;
			float lerpResult9_g48 = lerp( temp_output_1_0_g48 , ( 1.0 - temp_output_1_0_g48 ) , _AlphaSharp_OneMinus);
			float smoothstepResult2_g48 = smoothstep( temp_output_7_0_g48 , ( temp_output_7_0_g48 + _AlphaSmoothness ) , lerpResult9_g48);
			o.Alpha = smoothstepResult2_g48;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				half4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.vertexColor = IN.color;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19302
Node;AmplifyShaderEditor.FunctionNode;4;-1401.614,609.7886;Inherit;False;SF_SteppedTime;17;;1;d99f7a5ca99e84e49bd0eb15605d7cdc;0;2;7;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-1164.967,166.1383;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;5;-1201.967,322.1383;Inherit;False;SF_DistortTexture;19;;2;96c99f2862d31594fbaa887784570dd8;0;4;22;FLOAT;0;False;16;FLOAT;0;False;17;FLOAT;1;False;11;FLOAT2;0,0;False;4;FLOAT2;25;FLOAT2;0;FLOAT;32;FLOAT2;19
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-828.967,247.1383;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;1;-585,273.5;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;0;False;0;False;-1;a96f4e5454b120947a4640dc2ead15c9;a96f4e5454b120947a4640dc2ead15c9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;9;-469.3982,510.1065;Inherit;False;SF_PanningTexture;3;;42;b045855c7f4c7344eb8723194efc0969;0;7;46;FLOAT;0;False;3;SAMPLER2D;;False;5;FLOAT2;0,0;False;8;FLOAT2;0,0;False;6;FLOAT2;0,0;False;14;FLOAT2;1,1;False;7;FLOAT2;0,0;False;5;COLOR;0;FLOAT;48;FLOAT;49;FLOAT;50;FLOAT;51
Node;AmplifyShaderEditor.FunctionNode;8;-163.3982,342.1065;Inherit;False;SF_AlphaLerp;1;;47;c2553cd63225274418f59d0e7f8b8bf3;0;2;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;2;-573,-195.5;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;10;24.60181,389.1065;Inherit;False;SF_AlphaSharp;13;;48;1a46ba76a207bfe4e97ac05d03cb8401;0;2;1;FLOAT;0;False;6;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;445,13;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;S_Scribble;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;22;4;0
WireConnection;7;0;6;0
WireConnection;7;1;5;25
WireConnection;1;1;7;0
WireConnection;9;46;4;0
WireConnection;8;2;1;4
WireConnection;8;3;9;48
WireConnection;10;1;8;0
WireConnection;0;2;2;0
WireConnection;0;9;10;0
ASEEND*/
//CHKSM=999209DFD24A1640D9AA6CD2458662EDE8057661