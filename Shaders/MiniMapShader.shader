Shader "Koyashiro/MiniMapShader"
{
    Properties
    {
        _WorldTex ("Texture", 2D) = "white" {}
        _PlayerTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _WorldTex;
            float4 _WorldTex_ST;
            sampler2D _PlayerTex;
            float4 _PleyerTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _WorldTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 worldCol = tex2D(_WorldTex, i.uv);
                fixed4 playerCol = tex2D(_PlayerTex, i.uv);

                fixed4 col;
                if (playerCol.r > 0) {
                    col = fixed4(1, 0, 0, 1);
                } else {
                    col = worldCol;
                }

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
