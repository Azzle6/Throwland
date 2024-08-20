// Made with Amplify Shader Editor v1.9.3.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "UI/PanningPattern"
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

        [Header(Panning Texture)]_PanningTex("PanningTex", 2D) = "white" {}
        [Toggle]_PanningTex_InvertUV("PanningTex_InvertUV", Float) = 0
        _PanningTex_ManualOffset("PanningTex_ManualOffset", Float) = 0
        [Header(Distort Texture)]_DistortTex("DistortTex", 2D) = "white" {}
        _DistortStrength("DistortStrength", Float) = 0.2
        _Float0("DistortSubtract", Float) = 0.5
        [Header(Alpha Sharp)]_AlphaThreshold("AlphaThreshold", Float) = 0
        _AlphaSmoothness("AlphaSmoothness", Float) = 1
        [Toggle]_AlphaSharp_OneMinus("AlphaSharp_OneMinus", Float) = 0
        _Strength("Strength", Float) = 0.15
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
                
            };

            sampler2D _MainTex;
            fixed4 _Color;
            fixed4 _TextureSampleAdd;
            float4 _ClipRect;
            float4 _MainTex_ST;
            float _UIMaskSoftnessX;
            float _UIMaskSoftnessY;

            uniform float _AlphaThreshold;
            uniform sampler2D _DistortTex;
            uniform float _PanningTex_ManualOffset;
            uniform float _PanningTex_InvertUV;
            SamplerState sampler_DistortTex;
            uniform float4 _DistortTex_ST;
            uniform float _AlphaSmoothness;
            uniform sampler2D _PanningTex;
            SamplerState sampler_PanningTex;
            uniform float4 _PanningTex_ST;
            uniform float _Float0;
            uniform float _DistortStrength;
            uniform float _AlphaSharp_OneMinus;
            uniform float _Strength;

            
            v2f vert(appdata_t v )
            {
                v2f OUT;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);

                

                v.vertex.xyz +=  float3( 0, 0, 0 ) ;

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

                float2 uv_MainTex = IN.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                float4 tex2DNode3 = tex2D( _MainTex, uv_MainTex );
                float4 appendResult43_g44 = (float4(0.0 , _PanningTex_ManualOffset , 0.0 , 0.0));
                float4 appendResult42_g44 = (float4(_PanningTex_ManualOffset , 0.0 , 0.0 , 0.0));
                float4 lerpResult41_g44 = lerp( appendResult43_g44 , appendResult42_g44 , _PanningTex_InvertUV);
                float2 temp_output_1_0_g47 = _DistortTex_ST.zw;
                float2 break3_g47 = temp_output_1_0_g47;
                float4 appendResult5_g47 = (float4(break3_g47.y , break3_g47.x , 0.0 , 0.0));
                float4 lerpResult2_g47 = lerp( float4( temp_output_1_0_g47, 0.0 , 0.0 ) , appendResult5_g47 , _PanningTex_InvertUV);
                float2 texCoord13_g43 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
                float2 temp_output_1_0_g48 = texCoord13_g43;
                float2 break3_g48 = temp_output_1_0_g48;
                float4 appendResult5_g48 = (float4(break3_g48.y , break3_g48.x , 0.0 , 0.0));
                float4 lerpResult2_g48 = lerp( float4( temp_output_1_0_g48, 0.0 , 0.0 ) , appendResult5_g48 , _PanningTex_InvertUV);
                float2 temp_output_1_0_g46 = ( _DistortTex_ST.xy * float2( 1,1 ) );
                float2 break3_g46 = temp_output_1_0_g46;
                float4 appendResult5_g46 = (float4(break3_g46.y , break3_g46.x , 0.0 , 0.0));
                float4 lerpResult2_g46 = lerp( float4( temp_output_1_0_g46, 0.0 , 0.0 ) , appendResult5_g46 , _PanningTex_InvertUV);
                float2 panner1_g45 = ( _Time.y * (lerpResult2_g47).xy + ( (lerpResult2_g48).xy * (lerpResult2_g46).xy ));
                float2 texCoord9_g44 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
                float4 tex2DNode2_g44 = tex2D( _DistortTex, ( ( float4( float2( 0,0 ), 0.0 , 0.0 ) + lerpResult41_g44 ).xy + panner1_g45 ), ddx( texCoord9_g44 ), ddy( texCoord9_g44 ) );
                float temp_output_7_0_g36 = ( _AlphaThreshold + ( tex2DNode2_g44.r * 0.4 ) );
                float4 appendResult43_g1 = (float4(0.0 , _PanningTex_ManualOffset , 0.0 , 0.0));
                float4 appendResult42_g1 = (float4(_PanningTex_ManualOffset , 0.0 , 0.0 , 0.0));
                float4 lerpResult41_g1 = lerp( appendResult43_g1 , appendResult42_g1 , _PanningTex_InvertUV);
                float2 temp_output_1_0_g34 = _PanningTex_ST.zw;
                float2 break3_g34 = temp_output_1_0_g34;
                float4 appendResult5_g34 = (float4(break3_g34.y , break3_g34.x , 0.0 , 0.0));
                float4 lerpResult2_g34 = lerp( float4( temp_output_1_0_g34, 0.0 , 0.0 ) , appendResult5_g34 , _PanningTex_InvertUV);
                float2 texCoord22 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
                float4 temp_output_31_0_g43 = tex2DNode2_g44;
                float4 temp_cast_8 = (_Float0).xxxx;
                float temp_output_14_0_g43 = ( _DistortStrength + 0.0 );
                float temp_output_17_0_g43 = 1.0;
                float2 temp_output_1_0_g35 = ( texCoord22 + ( (( temp_output_31_0_g43 - temp_cast_8 )).rg * ( temp_output_14_0_g43 * temp_output_17_0_g43 ) ) );
                float2 break3_g35 = temp_output_1_0_g35;
                float4 appendResult5_g35 = (float4(break3_g35.y , break3_g35.x , 0.0 , 0.0));
                float4 lerpResult2_g35 = lerp( float4( temp_output_1_0_g35, 0.0 , 0.0 ) , appendResult5_g35 , _PanningTex_InvertUV);
                float2 temp_output_1_0_g33 = ( _PanningTex_ST.xy * float2( 1,1 ) );
                float2 break3_g33 = temp_output_1_0_g33;
                float4 appendResult5_g33 = (float4(break3_g33.y , break3_g33.x , 0.0 , 0.0));
                float4 lerpResult2_g33 = lerp( float4( temp_output_1_0_g33, 0.0 , 0.0 ) , appendResult5_g33 , _PanningTex_InvertUV);
                float2 panner1_g32 = ( _Time.y * (lerpResult2_g34).xy + ( (lerpResult2_g35).xy * (lerpResult2_g33).xy ));
                float2 texCoord9_g1 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
                float4 tex2DNode2_g1 = tex2D( _PanningTex, ( ( float4( float2( 0,0 ), 0.0 , 0.0 ) + lerpResult41_g1 ).xy + panner1_g32 ), ddx( texCoord9_g1 ), ddy( texCoord9_g1 ) );
                float temp_output_1_0_g36 = tex2DNode2_g1.r;
                float lerpResult9_g36 = lerp( temp_output_1_0_g36 , ( 1.0 - temp_output_1_0_g36 ) , _AlphaSharp_OneMinus);
                float smoothstepResult2_g36 = smoothstep( temp_output_7_0_g36 , ( temp_output_7_0_g36 + _AlphaSmoothness ) , lerpResult9_g36);
                float4 temp_output_13_0 = ( tex2DNode3 + ( smoothstepResult2_g36 * _Strength ) );
                float4 break19 = ( temp_output_13_0 * IN.color );
                float4 appendResult18 = (float4(break19.r , break19.g , break19.b , ( tex2DNode3.a * IN.color.a )));
                

                half4 color = appendResult18;

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
Version=19302
Node;AmplifyShaderEditor.TextureCoordinatesNode;22;-1465.305,-86.19754;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;24;-1556.846,74.7522;Inherit;False;SF_DistortTexture;10;;43;96c99f2862d31594fbaa887784570dd8;0;4;22;FLOAT;0;False;16;FLOAT;0;False;17;FLOAT;1;False;11;FLOAT2;0,0;False;4;FLOAT2;25;FLOAT2;0;FLOAT;32;FLOAT2;19
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-1240.982,-58.03136;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;12;-992.9946,-22.61831;Inherit;False;SF_PanningTexture;0;;1;b045855c7f4c7344eb8723194efc0969;0;7;46;FLOAT;0;False;3;SAMPLER2D;;False;5;FLOAT2;0,0;False;8;FLOAT2;0,0;False;6;FLOAT2;0,0;False;14;FLOAT2;1,1;False;7;FLOAT2;0,0;False;4;COLOR;0;FLOAT;48;FLOAT;49;FLOAT;50
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-1157.357,179.2354;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.4;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-571.0333,204.7378;Inherit;False;Property;_Strength;Strength;30;0;Create;True;0;0;0;False;0;False;0.15;0.06;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;16;-714.8694,19.52979;Inherit;False;SF_AlphaSharp;26;;36;1a46ba76a207bfe4e97ac05d03cb8401;0;2;1;FLOAT;0;False;6;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;2;-1095,-295.5;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-414.7266,57.29446;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-892,-369.5;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-223.7266,-15.70554;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;5;-348,325.5;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;80,157.5;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;19;197.7375,4.709229;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-14.26245,421.7092;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;17;-69.26245,-21.29077;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;18;390.7375,97.70923;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;544,30;Float;False;True;-1;2;ASEMaterialInspector;0;3;UI/PanningPattern;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;False;True;3;1;False;;10;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;True;True;True;True;True;0;True;_ColorMask;False;False;False;False;False;False;False;True;True;0;True;_Stencil;255;True;_StencilReadMask;255;True;_StencilWriteMask;0;True;_StencilComp;0;True;_StencilOp;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;0;True;unity_GUIZTestMode;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;23;0;22;0
WireConnection;23;1;24;25
WireConnection;12;5;23;0
WireConnection;25;0;24;32
WireConnection;16;1;12;48
WireConnection;16;6;25;0
WireConnection;14;0;16;0
WireConnection;14;1;15;0
WireConnection;3;0;2;0
WireConnection;13;0;3;0
WireConnection;13;1;14;0
WireConnection;4;0;13;0
WireConnection;4;1;5;0
WireConnection;19;0;4;0
WireConnection;20;0;3;4
WireConnection;20;1;5;4
WireConnection;17;0;13;0
WireConnection;18;0;19;0
WireConnection;18;1;19;1
WireConnection;18;2;19;2
WireConnection;18;3;20;0
WireConnection;1;0;18;0
ASEEND*/
//CHKSM=CCB3C7375B4D9CAB9A33CF829F93076F67322FA8