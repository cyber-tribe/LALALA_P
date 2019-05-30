Shader "Dimenco/2DPlusDepth_Depth"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_DepthMod("Depth Modifier", float) = 1
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

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _DepthMod;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{

				int coord_y = i.uv.y * 540; //Gives us the current row.
				int coord_x = i.uv.x * 1920; //Note: We do not use this, but it is more clear to see it.

				float mod_value = fmod(coord_y,2.0); //find whether this is an odd or even line.
				fixed4 col;

				if (mod_value == 1)
				{
				//Odd line: use the value from the texture  
					col = _DepthMod * tex2D(_MainTex, i.uv);
				}
				else
				{
				//Even line: create a black pixel.
					col = float4(0, 0, 0, 0);
				}
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
				
			}
			ENDCG
		}
	}
}
