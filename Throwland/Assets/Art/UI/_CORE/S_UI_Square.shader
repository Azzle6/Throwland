// Made with Amplify Shader Editor v1.9.1.8
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "S_UI_Square"
{
    Properties
    {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1,1,1,1)

        _StencilComp ("Stencil Comparison", Float) = 8
        _Stencil ("Stencil ID", Float) = 0
        _StencilOp ("Stencil Operation", Float) = 0
        _StencilWriteMask ("Stencil Write Mask", Float) = 255
        _StencilReadMask ("Stencil Read Mask", Float) = 255

        _ColorMask ("Color Mask", Float) = 15

        [Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0

        [Header(Distort Texture)]_DistortTex("DistortTex", 2D) = "white" {}
        _DistortStrength("DistortStrength", Float) = 0.2
        _Float0("DistortSubtract", Float) = 0.5
        [Header(TimeStep)]_TimeStep("TimeStep", Float) = 10
        [Header(AlphaLerp)]_AlphaLerp_TexInfluence("AlphaLerp_TexInfluence", Range( 0 , 1)) = 0.2
        [Header(Panning Texture)]_PanningTex("PanningTex", 2D) = "white" {}
        [Toggle]_PanningTex_InvertUV("PanningTex_InvertUV", Float) = 0
        _PanningTex_ManualOffset("PanningTex_ManualOffset", Float) = 0
        [Header(Alpha Sharp)]_AlphaThreshold("AlphaThreshold", Float) = 0
        _AlphaSmoothness("AlphaSmoothness", Float) = 1
        [Toggle]_AlphaSharp_OneMinus("AlphaSharp_OneMinus", Float) = 0
        [HideInInspector] _texcoord( "", 2D ) = "white" {}

    }

    SubShader
    {
		LOD 0

        Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True" }

        Stencil
        {
        	Ref [_Stencil]
        	ReadMask [_StencilReadMask]
        	WriteMask [_StencilWriteMask]
        	Comp [_StencilComp]
        	Pass [_StencilOp]
        }


        Cull Off
        Lighting Off
        ZWrite Off
        ZTest [unity_GUIZTestMode]
        Blend One OneMinusSrcAlpha
        ColorMask [_ColorMask]

        
        Pass
        {
            Name "Default"
        CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0

            #include "UnityCG.cginc"
            #include "UnityUI.cginc"

            #pragma multi_compile_local _ UNITY_UI_CLIP_RECT
            #pragma multi_compile_local _ UNITY_UI_ALPHACLIP

            #include "UnityShaderVariables.cginc"
            #define ASE_NEEDS_FRAG_COLOR


            struct appdata_t
            {
                float4 vertex   : POSITION;
                float4 color    : COLOR;
                float2 texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                
            };

            struct v2f
            {
                float4 vertex   : SV_POSITION;
                fixed4 color    : COLOR;
                float2 texcoord  : TEXCOORD0;
                float4 worldPosition : TEXCOORD1;
                float4  mask : TEXCOORD2;
                UNITY_VERTEX_OUTPUT_STEREO
                float4 ase_texcoord3 : TEXCOORD3;
            };

            sampler2D _MainTex;
            fixed4 _Color;
            fixed4 _TextureSampleAdd;
            float4 _ClipRect;
            float4 _MainTex_ST;
            float _UIMaskSoftnessX;
            float _UIMaskSoftnessY;

            uniform sampler2D _DistortTex;
            uniform float _PanningTex_ManualOffset;
            uniform float _PanningTex_InvertUV;
            uniform float _TimeStep;
            SamplerState sampler_DistortTex;
            uniform float4 _DistortTex_ST;
            uniform float _Float0;
            uniform float _DistortStrength;
            uniform float _AlphaThreshold;
            uniform float _AlphaSmoothness;
            uniform sampler2D _PanningTex;
            SamplerState sampler_PanningTex;
            uniform float4 _PanningTex_ST;
            uniform float _AlphaLerp_TexInfluence;
            uniform float _AlphaSharp_OneMinus;

            
            v2f vert(appdata_t v )
            {
                v2f OUT;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);

                float4 appendResult43_g58 = (float4(0.0 , _PanningTex_ManualOffset , 0.0 , 0.0));
                float4 appendResult42_g58 = (float4(_PanningTex_ManualOffset , 0.0 , 0.0 , 0.0));
                float4 lerpResult41_g58 = lerp( appendResult43_g58 , appendResult42_g58 , _PanningTex_InvertUV);
                float temp_output_7_0_g37 = _TimeStep;
                float temp_output_7_0 = ( floor( ( _Time.y * temp_output_7_0_g37 ) ) / temp_output_7_0_g37 );
                float2 temp_output_1_0_g61 = _DistortTex_ST.zw;
                float2 break3_g61 = temp_output_1_0_g61;
                float4 appendResult5_g61 = (float4(break3_g61.y , break3_g61.x , 0.0 , 0.0));
                float4 lerpResult2_g61 = lerp( float4( temp_output_1_0_g61, 0.0 , 0.0 ) , appendResult5_g61 , _PanningTex_InvertUV);
                float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
                float4 screenPos = ComputeScreenPos(ase_clipPos);
                float4 ase_screenPosNorm = screenPos / screenPos.w;
                ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
                float2 temp_output_1_0_g62 = ase_screenPosNorm.xy;
                float2 break3_g62 = temp_output_1_0_g62;
                float4 appendResult5_g62 = (float4(break3_g62.y , break3_g62.x , 0.0 , 0.0));
                float4 lerpResult2_g62 = lerp( float4( temp_output_1_0_g62, 0.0 , 0.0 ) , appendResult5_g62 , _PanningTex_InvertUV);
                float2 temp_output_1_0_g60 = ( _DistortTex_ST.xy * float2( 1,1 ) );
                float2 break3_g60 = temp_output_1_0_g60;
                float4 appendResult5_g60 = (float4(break3_g60.y , break3_g60.x , 0.0 , 0.0));
                float4 lerpResult2_g60 = lerp( float4( temp_output_1_0_g60, 0.0 , 0.0 ) , appendResult5_g60 , _PanningTex_InvertUV);
                float2 panner1_g59 = ( temp_output_7_0 * (lerpResult2_g61).xy + ( (lerpResult2_g62).xy * (lerpResult2_g60).xy ));
                float4 tex2DNode2_g58 = tex2Dlod( _DistortTex, float4( ( ( float4( float2( 0,0 ), 0.0 , 0.0 ) + lerpResult41_g58 ).xy + panner1_g59 ), 0, 0.0) );
                float4 temp_output_1_0_g57 = tex2DNode2_g58;
                float4 temp_cast_6 = (_Float0).xxxx;
                float temp_output_14_0_g57 = ( _DistortStrength + 0.0 );
                float temp_output_17_0_g57 = 1.0;
                float2 break42 = ( (( temp_output_1_0_g57 - temp_cast_6 )).rg * ( temp_output_14_0_g57 * temp_output_17_0_g57 ) );
                float3 appendResult26 = (float3(break42.x , break42.y , 0.0));
                
                OUT.ase_texcoord3 = screenPos;
                

                v.vertex.xyz += appendResult26;

                float4 vPosition = UnityObjectToClipPos(v.vertex);
                OUT.worldPosition = v.vertex;
                OUT.vertex = vPosition;

                float2 pixelSize = vPosition.w;
                pixelSize /= float2(1, 1) * abs(mul((float2x2)UNITY_MATRIX_P, _ScreenParams.xy));

                float4 clampedRect = clamp(_ClipRect, -2e10, 2e10);
                float2 maskUV = (v.vertex.xy - clampedRect.xy) / (clampedRect.zw - clampedRect.xy);
                OUT.texcoord = v.texcoord;
                OUT.mask = float4(v.vertex.xy * 2 - clampedRect.xy - clampedRect.zw, 0.25 / (0.25 * half2(_UIMaskSoftnessX, _UIMaskSoftnessY) + abs(pixelSize.xy)));

                OUT.color = v.color * _Color;
                return OUT;
            }

            fixed4 frag(v2f IN ) : SV_Target
            {
                //Round up the alpha color coming from the interpolator (to 1.0/256.0 steps)
                //The incoming alpha could have numerical instability, which makes it very sensible to
                //HDR color transparency blend, when it blends with the world's texture.
                const half alphaPrecision = half(0xff);
                const half invAlphaPrecision = half(1.0/alphaPrecision);
                IN.color.a = round(IN.color.a * alphaPrecision)*invAlphaPrecision;

                float temp_output_7_0_g36 = ( _AlphaThreshold + 0.0 );
                float2 uv_MainTex = IN.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                float4 appendResult43_g3 = (float4(0.0 , _PanningTex_ManualOffset , 0.0 , 0.0));
                float4 appendResult42_g3 = (float4(_PanningTex_ManualOffset , 0.0 , 0.0 , 0.0));
                float4 lerpResult41_g3 = lerp( appendResult43_g3 , appendResult42_g3 , _PanningTex_InvertUV);
                float temp_output_7_0_g37 = _TimeStep;
                float temp_output_7_0 = ( floor( ( _Time.y * temp_output_7_0_g37 ) ) / temp_output_7_0_g37 );
                float2 temp_output_1_0_g34 = _PanningTex_ST.zw;
                float2 break3_g34 = temp_output_1_0_g34;
                float4 appendResult5_g34 = (float4(break3_g34.y , break3_g34.x , 0.0 , 0.0));
                float4 lerpResult2_g34 = lerp( float4( temp_output_1_0_g34, 0.0 , 0.0 ) , appendResult5_g34 , _PanningTex_InvertUV);
                float4 screenPos = IN.ase_texcoord3;
                float4 ase_screenPosNorm = screenPos / screenPos.w;
                ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
                float2 temp_output_1_0_g35 = ase_screenPosNorm.xy;
                float2 break3_g35 = temp_output_1_0_g35;
                float4 appendResult5_g35 = (float4(break3_g35.y , break3_g35.x , 0.0 , 0.0));
                float4 lerpResult2_g35 = lerp( float4( temp_output_1_0_g35, 0.0 , 0.0 ) , appendResult5_g35 , _PanningTex_InvertUV);
                float2 temp_output_1_0_g33 = ( _PanningTex_ST.xy * float2( 1,1 ) );
                float2 break3_g33 = temp_output_1_0_g33;
                float4 appendResult5_g33 = (float4(break3_g33.y , break3_g33.x , 0.0 , 0.0));
                float4 lerpResult2_g33 = lerp( float4( temp_output_1_0_g33, 0.0 , 0.0 ) , appendResult5_g33 , _PanningTex_InvertUV);
                float2 panner1_g32 = ( temp_output_7_0 * (lerpResult2_g34).xy + ( (lerpResult2_g35).xy * (lerpResult2_g33).xy ));
                float2 texCoord9_g3 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
                float4 tex2DNode2_g3 = tex2D( _PanningTex, ( ( float4( float2( 0,0 ), 0.0 , 0.0 ) + lerpResult41_g3 ).xy + panner1_g32 ), ddx( texCoord9_g3 ), ddy( texCoord9_g3 ) );
                float lerpResult1_g50 = lerp( tex2D( _MainTex, uv_MainTex ).r , tex2DNode2_g3.r , _AlphaLerp_TexInfluence);
                float temp_output_1_0_g36 = lerpResult1_g50;
                float lerpResult9_g36 = lerp( temp_output_1_0_g36 , ( 1.0 - temp_output_1_0_g36 ) , _AlphaSharp_OneMinus);
                float smoothstepResult2_g36 = smoothstep( temp_output_7_0_g36 , ( temp_output_7_0_g36 + _AlphaSmoothness ) , lerpResult9_g36);
                float4 appendResult3 = (float4(IN.color.r , IN.color.g , IN.color.b , ( smoothstepResult2_g36 * IN.color.a )));
                

                half4 color = appendResult3;

                #ifdef UNITY_UI_CLIP_RECT
                half2 m = saturate((_ClipRect.zw - _ClipRect.xy - abs(IN.mask.xy)) * IN.mask.zw);
                color.a *= m.x * m.y;
                #endif

                #ifdef UNITY_UI_ALPHACLIP
                clip (color.a - 0.001);
                #endif

                color.rgb *= color.a;

                return color;
            }
        ENDCG
        }
    }
    CustomEditor "ASEMaterialInspector"
	
	Fallback Off
}
/*ASEBEGIN
Version=19108
Node;AmplifyShaderEditor.FunctionNode;1;-590,173.5;Inherit;False;SF_EdgeFade;0;;1;2c737c027c7911941847cd940f44e2cc;0;1;8;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;5;-702,314.5;Inherit;False;SF_PanningTexture;28;;3;b045855c7f4c7344eb8723194efc0969;0;7;46;FLOAT;0;False;3;SAMPLER2D;;False;5;FLOAT2;0,0;False;8;FLOAT2;0,0;False;6;FLOAT2;0,0;False;14;FLOAT2;1,1;False;7;FLOAT2;0,0;False;2;COLOR;0;FLOAT;22
Node;AmplifyShaderEditor.FunctionNode;6;-142,181.5;Inherit;False;SF_AlphaSharp;40;;36;1a46ba76a207bfe4e97ac05d03cb8401;0;2;1;FLOAT;0;False;6;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;3;231,-161.5;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1091.6,-150.9;Float;False;True;-1;2;ASEMaterialInspector;0;3;S_UI_Square;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;False;True;3;1;False;;10;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;True;True;True;True;True;0;True;_ColorMask;False;False;False;False;False;False;False;True;True;0;True;_Stencil;255;True;_StencilReadMask;255;True;_StencilWriteMask;0;True;_StencilComp;0;True;_StencilOp;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;0;True;unity_GUIZTestMode;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;0;;0;0;Standard;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.FunctionNode;7;-1207.054,615.9371;Inherit;False;SF_SteppedTime;23;;37;d99f7a5ca99e84e49bd0eb15605d7cdc;0;2;7;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;26;618.4666,680.3208;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;30;-1310.138,856.2176;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;32;-1610.471,664.0962;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;29;-1345.538,664.9175;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-1136.138,889.2177;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;28;-1528.029,813.9046;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenPosInputsNode;33;-1354.506,117.5494;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenParams;34;-1365.023,324.6932;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;4;-368,199.5;Inherit;False;SF_AlphaLerp;25;;50;c2553cd63225274418f59d0e7f8b8bf3;0;2;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;36;-395.144,58.96082;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1071.503,-178.1566;Inherit;False;Property;_Radius;Radius;27;0;Create;True;0;0;0;False;0;False;0.5;0.48;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;8;-853.5035,-224.1566;Inherit;False;float2 d = abs(pos)-radius@$return length(max(d,0)) + 	min(max(d.x,d.y),0)@$;1;Create;2;True;pos;FLOAT2;0,0;In;;Inherit;False;True;radius;FLOAT2;0,0;In;;Inherit;False;SDF_Box;True;False;0;;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-1334.927,-490.0224;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;14;-1071.927,-483.0225;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;-0.5,-0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;38;-1092.175,-24.18243;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;39;-856.1746,-41.18243;Inherit;True;Property;_TextureSample0;Texture Sample 0;14;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;42;348.5315,707.9834;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.FunctionNode;43;-33.6167,721.239;Inherit;False;SF_DistortTexture;5;;57;96c99f2862d31594fbaa887784570dd8;0;4;22;FLOAT;0;False;16;FLOAT;0;False;17;FLOAT;1;False;11;FLOAT2;0,0;False;3;FLOAT2;25;FLOAT2;0;FLOAT2;19
Node;AmplifyShaderEditor.VertexColorNode;2;-127,-184.5;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;44;-105.1398,315.8086;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;198.4119,226.0078;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
WireConnection;5;46;7;0
WireConnection;5;5;33;0
WireConnection;6;1;4;0
WireConnection;3;0;2;1
WireConnection;3;1;2;2
WireConnection;3;2;2;3
WireConnection;3;3;45;0
WireConnection;0;0;3;0
WireConnection;0;1;26;0
WireConnection;26;0;42;0
WireConnection;26;1;42;1
WireConnection;30;0;28;1
WireConnection;30;1;28;2
WireConnection;29;0;32;0
WireConnection;29;1;31;0
WireConnection;31;0;30;0
WireConnection;4;2;39;1
WireConnection;4;3;5;0
WireConnection;36;0;8;0
WireConnection;8;0;14;0
WireConnection;8;1;10;0
WireConnection;14;0;11;0
WireConnection;39;0;38;0
WireConnection;42;0;43;25
WireConnection;43;22;7;0
WireConnection;43;11;28;0
WireConnection;45;0;6;0
WireConnection;45;1;44;4
ASEEND*/
//CHKSM=39F32269719B84C7A9A8214EB0BAD61C2368B5A3