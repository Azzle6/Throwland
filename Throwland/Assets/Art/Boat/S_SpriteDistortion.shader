// Made with Amplify Shader Editor v1.9.6.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SpriteDistortion"
{
	Properties
	{
		[PerRendererData]_MainTex("MainTex", 2D) = "white" {}
		[Header(TimeStep)]_TimeStep("TimeStep", Float) = 10
		[Header(Distort Texture)]_DistortTex("DistortTex", 2D) = "white" {}
		_DistortStrength("DistortStrength", Float) = 0.2
		[Toggle]_PanningTex_InvertUV("PanningTex_InvertUV", Float) = 0
		_PanningTex_ManualOffset("PanningTex_ManualOffset", Float) = 0
		_Float0("DistortSubtract", Float) = 0.5
		_DistortVector("DistortVector", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
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

		uniform sampler2D _MainTex;
		uniform sampler2D _DistortTex;
		uniform float _PanningTex_ManualOffset;
		uniform float _PanningTex_InvertUV;
		uniform float _TimeStep;
		SamplerState sampler_DistortTex;
		uniform float4 _DistortTex_ST;
		uniform float _Float0;
		uniform float _DistortStrength;
		uniform float2 _DistortVector;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 appendResult43_g43 = (float4(0.0 , _PanningTex_ManualOffset , 0.0 , 0.0));
			float4 appendResult42_g43 = (float4(_PanningTex_ManualOffset , 0.0 , 0.0 , 0.0));
			float4 lerpResult41_g43 = lerp( appendResult43_g43 , appendResult42_g43 , _PanningTex_InvertUV);
			float temp_output_7_0_g41 = _TimeStep;
			float2 temp_output_1_0_g46 = _DistortTex_ST.zw;
			float2 break3_g46 = temp_output_1_0_g46;
			float4 appendResult5_g46 = (float4(break3_g46.y , break3_g46.x , 0.0 , 0.0));
			float4 lerpResult2_g46 = lerp( float4( temp_output_1_0_g46, 0.0 , 0.0 ) , appendResult5_g46 , _PanningTex_InvertUV);
			float2 temp_output_1_0_g47 = i.uv_texcoord;
			float2 break3_g47 = temp_output_1_0_g47;
			float4 appendResult5_g47 = (float4(break3_g47.y , break3_g47.x , 0.0 , 0.0));
			float4 lerpResult2_g47 = lerp( float4( temp_output_1_0_g47, 0.0 , 0.0 ) , appendResult5_g47 , _PanningTex_InvertUV);
			float2 temp_output_1_0_g45 = ( _DistortTex_ST.xy * float2( 1,1 ) );
			float2 break3_g45 = temp_output_1_0_g45;
			float4 appendResult5_g45 = (float4(break3_g45.y , break3_g45.x , 0.0 , 0.0));
			float4 lerpResult2_g45 = lerp( float4( temp_output_1_0_g45, 0.0 , 0.0 ) , appendResult5_g45 , _PanningTex_InvertUV);
			float2 panner1_g44 = ( ( floor( ( _Time.y * temp_output_7_0_g41 ) ) / temp_output_7_0_g41 ) * (lerpResult2_g46).xy + ( (lerpResult2_g47).xy * (lerpResult2_g45).xy ));
			float4 tex2DNode2_g43 = tex2D( _DistortTex, ( ( float4( float2( 0,0 ), 0.0 , 0.0 ) + lerpResult41_g43 ).xy + panner1_g44 ), ddx( i.uv_texcoord ), ddy( i.uv_texcoord ) );
			float4 temp_output_31_0_g42 = tex2DNode2_g43;
			float4 temp_cast_5 = (_Float0).xxxx;
			float temp_output_14_0_g42 = ( _DistortStrength + 0.0 );
			float temp_output_17_0_g42 = 1.0;
			float4 tex2DNode1 = tex2D( _MainTex, ( i.uv_texcoord + ( ( (( temp_output_31_0_g42 - temp_cast_5 )).rg * ( temp_output_14_0_g42 * temp_output_17_0_g42 ) ) * _DistortVector ) ) );
			o.Emission = ( i.vertexColor * float4( tex2DNode1.rgb , 0.0 ) ).rgb;
			o.Alpha = ( tex2DNode1.a * i.vertexColor.a );
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
Version=19603
Node;AmplifyShaderEditor.FunctionNode;8;-1424,96;Inherit;False;SF_SteppedTime;1;;41;d99f7a5ca99e84e49bd0eb15605d7cdc;0;2;7;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;5;-1136,0;Inherit;False;SF_DistortTexture;3;;42;96c99f2862d31594fbaa887784570dd8;0;4;22;FLOAT;0;False;16;FLOAT;0;False;17;FLOAT;1;False;11;FLOAT2;0,0;False;4;FLOAT2;25;FLOAT2;0;FLOAT;32;FLOAT2;19
Node;AmplifyShaderEditor.Vector2Node;10;-1042,221.5;Inherit;False;Property;_DistortVector;DistortVector;19;0;Create;True;0;0;0;False;0;False;0,0;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-1136,-160;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-815,134.5;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-720,-16;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VertexColorNode;2;-480,-208;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-560,48;Inherit;True;Property;_MainTex;MainTex;0;1;[PerRendererData];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-228,-62.5;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-210,171.5;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;96,16;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;SpriteDistortion;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;22;8;0
WireConnection;9;0;5;25
WireConnection;9;1;10;0
WireConnection;7;0;6;0
WireConnection;7;1;9;0
WireConnection;1;1;7;0
WireConnection;3;0;2;0
WireConnection;3;1;1;5
WireConnection;4;0;1;4
WireConnection;4;1;2;4
WireConnection;0;2;3;0
WireConnection;0;9;4;0
ASEEND*/
//CHKSM=EAAB545B4148B966862B9640F40AFD0B31645FB4