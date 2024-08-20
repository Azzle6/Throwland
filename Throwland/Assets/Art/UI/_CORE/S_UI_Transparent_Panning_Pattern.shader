// Made with Amplify Shader Editor v1.9.3.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "UI/TransparentPanningPattern"
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
        [Toggle]_PanningTex_InvertUV("PanningTex_InvertUV", Float) = 0
        _PanningTex_ManualOffset("PanningTex_ManualOffset", Float) = 0
        _Float0("DistortSubtract", Float) = 0.5
        _Tiling("Tiling", Float) = 5
        _DistortTexture_Dissolve("DistortTexture_Dissolve", Float) = 0.15
        [Header(Alpha Sharp)]_AlphaThreshold("AlphaThreshold", Float) = 0
        _AlphaSmoothness("AlphaSmoothness", Float) = 1
        [Toggle]_AlphaSharp_OneMinus("AlphaSharp_OneMinus", Float) = 0

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

            uniform float _AlphaThreshold;
            uniform sampler2D _DistortTex;
            uniform float _PanningTex_ManualOffset;
            uniform float _PanningTex_InvertUV;
            SamplerState sampler_DistortTex;
            uniform float4 _DistortTex_ST;
            uniform float _Tiling;
            uniform float _DistortTexture_Dissolve;
            uniform float _AlphaSmoothness;
            uniform float _Float0;
            uniform float _DistortStrength;
            uniform float _AlphaSharp_OneMinus;

            
            v2f vert(appdata_t v )
            {
                v2f OUT;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);

                float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
                float4 screenPos = ComputeScreenPos(ase_clipPos);
                OUT.ase_texcoord3 = screenPos;
                

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

                float4 break19 = IN.color;
                float4 appendResult43_g56 = (float4(0.0 , _PanningTex_ManualOffset , 0.0 , 0.0));
                float4 appendResult42_g56 = (float4(_PanningTex_ManualOffset , 0.0 , 0.0 , 0.0));
                float4 lerpResult41_g56 = lerp( appendResult43_g56 , appendResult42_g56 , _PanningTex_InvertUV);
                float2 temp_output_1_0_g59 = _DistortTex_ST.zw;
                float2 break3_g59 = temp_output_1_0_g59;
                float4 appendResult5_g59 = (float4(break3_g59.y , break3_g59.x , 0.0 , 0.0));
                float4 lerpResult2_g59 = lerp( float4( temp_output_1_0_g59, 0.0 , 0.0 ) , appendResult5_g59 , _PanningTex_InvertUV);
                float4 screenPos = IN.ase_texcoord3;
                float4 ase_screenPosNorm = screenPos / screenPos.w;
                ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
                float2 appendResult33 = (float2(( _ScreenParams.x * ase_screenPosNorm.x ) , ( _ScreenParams.y * ase_screenPosNorm.y )));
                float2 temp_output_37_0 = ( ( appendResult33 / 1000.0 ) * _Tiling );
                float2 temp_output_1_0_g60 = temp_output_37_0;
                float2 break3_g60 = temp_output_1_0_g60;
                float4 appendResult5_g60 = (float4(break3_g60.y , break3_g60.x , 0.0 , 0.0));
                float4 lerpResult2_g60 = lerp( float4( temp_output_1_0_g60, 0.0 , 0.0 ) , appendResult5_g60 , _PanningTex_InvertUV);
                float2 temp_output_1_0_g58 = ( _DistortTex_ST.xy * float2( 1,1 ) );
                float2 break3_g58 = temp_output_1_0_g58;
                float4 appendResult5_g58 = (float4(break3_g58.y , break3_g58.x , 0.0 , 0.0));
                float4 lerpResult2_g58 = lerp( float4( temp_output_1_0_g58, 0.0 , 0.0 ) , appendResult5_g58 , _PanningTex_InvertUV);
                float2 panner1_g57 = ( _Time.y * (lerpResult2_g59).xy + ( (lerpResult2_g60).xy * (lerpResult2_g58).xy ));
                float2 texCoord9_g56 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
                float4 tex2DNode2_g56 = tex2D( _DistortTex, ( ( float4( float2( 0,0 ), 0.0 , 0.0 ) + lerpResult41_g56 ).xy + panner1_g57 ), ddx( texCoord9_g56 ), ddy( texCoord9_g56 ) );
                float temp_output_7_0_g66 = ( _AlphaThreshold + ( tex2DNode2_g56.r * _DistortTexture_Dissolve ) );
                float4 temp_output_31_0_g55 = tex2DNode2_g56;
                float4 temp_cast_5 = (_Float0).xxxx;
                float temp_output_14_0_g55 = ( _DistortStrength + 0.0 );
                float temp_output_17_0_g55 = 1.0;
                float2 panner35 = ( 1.0 * _Time.y * float2( -0.05,-0.2 ) + ( temp_output_37_0 + ( (( temp_output_31_0_g55 - temp_cast_5 )).rg * ( temp_output_14_0_g55 * temp_output_17_0_g55 ) ) ));
                float temp_output_1_0_g66 = tex2D( _MainTex, panner35 ).a;
                float lerpResult9_g66 = lerp( temp_output_1_0_g66 , ( 1.0 - temp_output_1_0_g66 ) , _AlphaSharp_OneMinus);
                float smoothstepResult2_g66 = smoothstep( temp_output_7_0_g66 , ( temp_output_7_0_g66 + _AlphaSmoothness ) , lerpResult9_g66);
                float4 appendResult18 = (float4(break19.r , break19.g , break19.b , ( smoothstepResult2_g66 * IN.color.a )));
                

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
Node;AmplifyShaderEditor.ScreenPosInputsNode;28;-2639.071,-484.8027;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenParams;29;-2555.071,-687.8027;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-2242.327,-450.2636;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-2221.327,-632.2636;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;33;-2009.07,-507.8026;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-1946.327,-390.2636;Inherit;False;Constant;_Float1;Float 1;8;0;Create;True;0;0;0;False;0;False;1000;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-1844.626,-305.4432;Inherit;False;Property;_Tiling;Tiling;16;0;Create;True;0;0;0;False;0;False;5;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;41;-1817.327,-488.2636;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-1659.626,-418.4432;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;26;-2268.777,155.6282;Inherit;False;SF_DistortTexture;0;;55;96c99f2862d31594fbaa887784570dd8;0;4;22;FLOAT;0;False;16;FLOAT;0;False;17;FLOAT;1;False;11;FLOAT2;0,0;False;4;FLOAT2;25;FLOAT2;0;FLOAT;32;FLOAT2;19
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-1537.981,61.17263;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-1927.6,444.5499;Inherit;False;Property;_DistortTexture_Dissolve;DistortTexture_Dissolve;17;0;Create;True;0;0;0;False;0;False;0.15;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;2;-1226.206,-130.9209;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;35;-1319.019,41.10634;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.05,-0.2;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-1478.411,333.9156;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;36;-1015.838,1.445497;Inherit;True;Property;_TextureSample0;Texture Sample 0;12;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;16;-750.0693,384.3298;Inherit;False;SF_AlphaSharp;18;;66;1a46ba76a207bfe4e97ac05d03cb8401;0;2;1;FLOAT;0;False;6;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;5;-442.4001,-18.49999;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;19;197.7375,4.709229;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-14.26245,421.7092;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;18;390.7375,97.70923;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;544,30;Float;False;True;-1;2;ASEMaterialInspector;0;3;UI/TransparentPanningPattern;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;True;True;3;1;False;;10;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;True;True;True;True;True;0;True;_ColorMask;False;False;False;False;False;False;False;True;True;0;True;_Stencil;255;True;_StencilReadMask;255;True;_StencilWriteMask;0;True;_StencilComp;0;True;_StencilOp;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;0;True;unity_GUIZTestMode;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;39;0;29;2
WireConnection;39;1;28;2
WireConnection;40;0;29;1
WireConnection;40;1;28;1
WireConnection;33;0;40;0
WireConnection;33;1;39;0
WireConnection;41;0;33;0
WireConnection;41;1;42;0
WireConnection;37;0;41;0
WireConnection;37;1;38;0
WireConnection;26;11;37;0
WireConnection;23;0;37;0
WireConnection;23;1;26;25
WireConnection;35;0;23;0
WireConnection;25;0;26;32
WireConnection;25;1;34;0
WireConnection;36;0;2;0
WireConnection;36;1;35;0
WireConnection;16;1;36;4
WireConnection;16;6;25;0
WireConnection;19;0;5;0
WireConnection;20;0;16;0
WireConnection;20;1;5;4
WireConnection;18;0;19;0
WireConnection;18;1;19;1
WireConnection;18;2;19;2
WireConnection;18;3;20;0
WireConnection;1;0;18;0
ASEEND*/
//CHKSM=5F54FF89B8B0F8E1DF5DBE5FE0A9544130C94821