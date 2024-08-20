// Made with Amplify Shader Editor v1.9.3.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "UI/JitteryIcon"
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
        [Header(TimeStep)]_TimeStep("TimeStep", Float) = 10
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

            uniform sampler2D _DistortTex;
            uniform float _PanningTex_ManualOffset;
            uniform float _PanningTex_InvertUV;
            uniform float _TimeStep;
            SamplerState sampler_DistortTex;
            uniform float4 _DistortTex_ST;
            uniform float _Float0;
            uniform float _DistortStrength;

            
            v2f vert(appdata_t v )
            {
                v2f OUT;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);

                float4 appendResult43_g65 = (float4(0.0 , _PanningTex_ManualOffset , 0.0 , 0.0));
                float4 appendResult42_g65 = (float4(_PanningTex_ManualOffset , 0.0 , 0.0 , 0.0));
                float4 lerpResult41_g65 = lerp( appendResult43_g65 , appendResult42_g65 , _PanningTex_InvertUV);
                float temp_output_7_0_g70 = _TimeStep;
                float2 temp_output_1_0_g68 = _DistortTex_ST.zw;
                float2 break3_g68 = temp_output_1_0_g68;
                float4 appendResult5_g68 = (float4(break3_g68.y , break3_g68.x , 0.0 , 0.0));
                float4 lerpResult2_g68 = lerp( float4( temp_output_1_0_g68, 0.0 , 0.0 ) , appendResult5_g68 , _PanningTex_InvertUV);
                float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
                float4 screenPos = ComputeScreenPos(ase_clipPos);
                float4 ase_screenPosNorm = screenPos / screenPos.w;
                ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
                float2 temp_output_1_0_g69 = ase_screenPosNorm.xy;
                float2 break3_g69 = temp_output_1_0_g69;
                float4 appendResult5_g69 = (float4(break3_g69.y , break3_g69.x , 0.0 , 0.0));
                float4 lerpResult2_g69 = lerp( float4( temp_output_1_0_g69, 0.0 , 0.0 ) , appendResult5_g69 , _PanningTex_InvertUV);
                float2 temp_output_1_0_g67 = ( _DistortTex_ST.xy * float2( 1,1 ) );
                float2 break3_g67 = temp_output_1_0_g67;
                float4 appendResult5_g67 = (float4(break3_g67.y , break3_g67.x , 0.0 , 0.0));
                float4 lerpResult2_g67 = lerp( float4( temp_output_1_0_g67, 0.0 , 0.0 ) , appendResult5_g67 , _PanningTex_InvertUV);
                float2 panner1_g66 = ( ( floor( ( _Time.y * temp_output_7_0_g70 ) ) / temp_output_7_0_g70 ) * (lerpResult2_g68).xy + ( (lerpResult2_g69).xy * (lerpResult2_g67).xy ));
                float4 tex2DNode2_g65 = tex2Dlod( _DistortTex, float4( ( ( float4( float2( 0,0 ), 0.0 , 0.0 ) + lerpResult41_g65 ).xy + panner1_g66 ), 0, 0.0) );
                float4 temp_output_31_0_g64 = tex2DNode2_g65;
                float4 temp_cast_6 = (_Float0).xxxx;
                float temp_output_14_0_g64 = ( _DistortStrength + 0.0 );
                float temp_output_17_0_g64 = 1.0;
                float2 break8_g63 = ( (( temp_output_31_0_g64 - temp_cast_6 )).rg * ( temp_output_14_0_g64 * temp_output_17_0_g64 ) );
                float2 appendResult2_g63 = (float2(break8_g63.x , break8_g63.y));
                

                v.vertex.xyz += float3( appendResult2_g63 ,  0.0 );

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
                

                half4 color = ( tex2D( _MainTex, uv_MainTex ) * IN.color );

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
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;38;367.0185,-315.1438;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;46;685.9299,-55.05011;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;39;665.0188,-314.1439;Inherit;True;Property;_TextureSample0;Texture Sample 0;14;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;982.351,-288.3076;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;48;1046.809,0.5133667;Inherit;False;SF_UI_Jitter;0;;63;4505783496b384d4d81848122530f5f3;0;0;1;FLOAT2;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1238.6,-146.9;Float;False;True;-1;2;ASEMaterialInspector;0;3;UI/JitteryIcon;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;False;True;3;1;False;;10;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;True;True;True;True;True;0;True;_ColorMask;False;False;False;False;False;False;False;True;True;0;True;_Stencil;255;True;_StencilReadMask;255;True;_StencilWriteMask;0;True;_StencilComp;0;True;_StencilOp;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;0;True;unity_GUIZTestMode;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;39;0;38;0
WireConnection;47;0;39;0
WireConnection;47;1;46;0
WireConnection;0;0;47;0
WireConnection;0;1;48;0
ASEEND*/
//CHKSM=71A9E0505CB1D06AC1005BAD2206D9EE027128A8