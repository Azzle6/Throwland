// Made with Amplify Shader Editor v1.9.3.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "S_BaseVFX"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		[Toggle]_InvertUV("InvertUV", Float) = 0
		[HDR][Header(Bicolor)][HideIf(_NOBICOLOR_ON)]_ColorA("ColorA", Color) = (0,0,0,1)
		[HDR][HideIf(_NOBICOLOR_ON)]_ColorB("ColorB", Color) = (1,1,1,1)
		[HideIf(_NOBICOLOR_ON)]_BicolorThreshold("BicolorThreshold", Float) = 0
		[HideIf(_NOBICOLOR_ON)]_BicolorSmoothness("BicolorSmoothness", Float) = 1
		[Toggle]_Bicolor_OneMinus("Bicolor_OneMinus", Float) = 0
		_Alpha("Alpha", Float) = 1
		[Toggle(_USETEXTUREALPHA_ON)] _UseTextureAlpha("UseTextureAlpha", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#pragma target 3.0
		#pragma shader_feature_local _USETEXTUREALPHA_ON
		#pragma surface surf Unlit alpha:fade keepalpha noshadow 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float4 _ColorA;
		uniform float4 _ColorB;
		uniform float _BicolorThreshold;
		uniform float _BicolorSmoothness;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _InvertUV;
		uniform float _Bicolor_OneMinus;
		uniform float _Alpha;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 uvs_MainTex = i.uv_texcoord;
			uvs_MainTex.xy = i.uv_texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 temp_output_1_0_g21 = uvs_MainTex.xy;
			float2 break3_g21 = temp_output_1_0_g21;
			float4 appendResult5_g21 = (float4(break3_g21.y , break3_g21.x , 0.0 , 0.0));
			float4 lerpResult2_g21 = lerp( float4( temp_output_1_0_g21, 0.0 , 0.0 ) , appendResult5_g21 , _InvertUV);
			float4 tex2DNode31 = tex2D( _MainTex, (lerpResult2_g21).xy );
			float smoothstepResult5_g23 = smoothstep( _BicolorThreshold , ( _BicolorThreshold + _BicolorSmoothness ) , tex2DNode31.r);
			float lerpResult12_g23 = lerp( smoothstepResult5_g23 , ( 1.0 - smoothstepResult5_g23 ) , _Bicolor_OneMinus);
			float4 lerpResult4_g23 = lerp( _ColorA , _ColorB , lerpResult12_g23);
			o.Emission = ( lerpResult4_g23 * i.vertexColor * ( i.uv_texcoord.z + 1.0 ) ).rgb;
			#ifdef _USETEXTUREALPHA_ON
				float staticSwitch39 = tex2DNode31.a;
			#else
				float staticSwitch39 = tex2DNode31.r;
			#endif
			o.Alpha = saturate( ( staticSwitch39 * i.vertexColor.a * _Alpha ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19302
Node;AmplifyShaderEditor.TexturePropertyNode;23;-1155.809,-119.6712;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;0;False;0;False;None;fc81fcb40c3554c4e9277cd2e5cefc92;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;56;-848.8284,41.51416;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;57;-563.8284,96.51416;Inherit;False;SF_InvertUV;1;;21;878c174c84d46054d9de6233be531ef5;0;2;1;FLOAT2;0,0;False;6;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;31;-313.9302,8.478149;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;41;141.9767,-273.577;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;39;115.9766,164.6231;Inherit;False;Property;_UseTextureAlpha;UseTextureAlpha;13;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;302.0447,471.7708;Inherit;False;Property;_Alpha;Alpha;12;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;59;309.1226,-59.17044;Inherit;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;507.2771,211.3417;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;44;175.9767,-66.57703;Inherit;False;SF_Bicolor;6;;23;8f1c0adb31a562646a4d2a8fec362420;0;3;9;COLOR;0,0,0,0;False;10;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0;FLOAT;14
Node;AmplifyShaderEditor.SimpleAddOpNode;60;560.8029,2.252319;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;53;49.27698,464.2932;Inherit;False;SF_DepthFade;3;;24;adc458ead34511148bae829420de626c;0;1;6;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;52;722.7985,215.9535;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;711.9767,-122.577;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;58;956.1695,84.06198;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;S_BaseVFX;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;56;2;23;0
WireConnection;57;1;56;0
WireConnection;31;0;23;0
WireConnection;31;1;57;0
WireConnection;39;1;31;1
WireConnection;39;0;31;4
WireConnection;42;0;39;0
WireConnection;42;1;41;4
WireConnection;42;2;51;0
WireConnection;44;1;31;1
WireConnection;60;0;59;3
WireConnection;52;0;42;0
WireConnection;40;0;44;0
WireConnection;40;1;41;0
WireConnection;40;2;60;0
WireConnection;58;2;40;0
WireConnection;58;9;52;0
ASEEND*/
//CHKSM=E599A2EF840BD6E776D104A1805BDD4A25A6FB40