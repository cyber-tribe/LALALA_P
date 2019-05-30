Shader "Dimenco/2DPlusDepth_Color"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
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
			int row = i.uv.y * 540; //For the black lines
			int column = i.uv.x * 1920; //For the header

			float mod_value = fmod(row,2.0);
			fixed4 col;

			if (mod_value == 1)
			{
			// sample the texture in every odd row
			col = tex2D(_MainTex, i.uv);

			//Header:
			//Blue_channel(2*(7-row)+16*column, 0)^7 = H(column)^row
			float pos_row = 16 * row;
			float pos_col = 2 * (7 - column);

			int width = 960;
			int height = 540;

			if (row == height-1 && column <= 494)
			{ 
			//Only first row

			//Header 1:
			//F1,01, 40,80, 00,00, C4,2D, D3,AF: H[0],..., H[9]
			//1111 0001, 0000 0001 (F1,01) - H[0], H[1]
			//0100 0000, 1000 0000 (40,80) - H[2], H[3]
			//0000 0000, 0000 0000 (00,00) - H[4], H[5]
			//1100 0100, 0010 1101 (C4,2D) - H[6], H[7]
			//1101 0011, 1010 1111 (D3,AF) - H[8], H[9]  

			float headerA_0[8] = { 1,1,1,1, 0,0,0,1 }; //H[0]
			float headerA_1[8] = { 0,0,0,0, 0,0,0,1 }; //H[1]
			float headerA_2[8] = { 0,1,0,0, 0,0,0,0 }; //H[2]
			float headerA_3[8] = { 1,0,0,0, 0,0,0,0 }; //H[3]
			float headerA_4[8] = { 0,0,0,0, 0,0,0,0 }; //H[4]
			float headerA_5[8] = { 0,0,0,0, 0,0,0,0 }; //H[5]
			float headerA_6[8] = { 1,1,0,0, 0,1,0,0 }; //H[6]
			float headerA_7[8] = { 0,0,1,0, 1,1,0,1 }; //H[7]
			float headerA_8[8] = { 1,1,0,1, 0,0,1,1 }; //H[8]
			float headerA_9[8] = { 1,0,1,0, 1,1,1,1 }; //H[9]

			//Header 2:
			//F2,14, 00,00, 00,00, 00,00, 00,00, 00,00, 00,00, 00,00, 00,00, 36,95, 82,21: H[10],..., H[31]
			//1111 0010, 0001 0100 (F2,14) - H[10], H[11]
			//0000 0000, 0000 0000 (00,00) - H[12], H[13]
			//0000 0000, 0000 0000 (00,00) - H[14], H[15]
			//0000 0000, 0000 0000 (00,00) - H[16], H[17]
			//0000 0000, 0000 0000 (00,00) - H[18], H[19]
			//0000 0000, 0000 0000 (00,00) - H[20], H[21]
			//0000 0000, 0000 0000 (00,00) - H[22], H[23]
			//0000 0000, 0000 0000 (00,00) - H[24], H[25]
			//0000 0000, 0000 0000 (00,00) - H[26], H[27]
			//0011 0101, 1001 0101 (36,95) - H[28], H[29]
			//1000 0010, 0010 0001 (82,21) - H[30], H[31]

			float headerB_10[8] = { 1,1,1,1, 0,0,1,0 }; //H[10]
			float headerB_11[8] =  { 0,0,0,1, 0,1,0,0 }; //H[11]
			float headerB_12[8] = { 0,0,0,0, 0,0,0,0 }; //H[12]
			float headerB_13_27[8] = { 0,0,0,0, 0,0,0,0 }; //H[13]-H[27]
			float headerB_28[8] = { 0,0,1,1, 0,1,0,1 }; //H[28]
			float headerB_29[8] = { 1,0,0,1, 0,1,0,1 }; //H[29]
			float headerB_30[8] = { 1,0,0,0, 0,0,1,0 }; //H[30]
			float headerB_31[8] = { 0,0,1,0, 0,0,0,1 }; //H[31]

			/******** Other 3D inputs ********/

			//Declipse – ‘Removed redundant data’ format. Change H[12], H[28] - H[31]  
			//float headerB_12[8] =   { 1,0,0,1, 1,0,1,0 }; //H[12]
			//float headerB_28[8] =   { 0,1,1,0, 1,0,1,1 }; //H[28]
			//float headerB_29[8] =   { 1,1,1,1, 0,1,1,0 }; //H[29]
			//float headerB_30[8] =   { 1,1,0,0, 0,1,1,0 }; //H[30]
			//float headerB_31[8] =   { 1,0,0,0, 1,0,0,1 }; //H[31]

			//Declipse – ‘Full background data’ format. Change H[12], H[28] - H[31] 
			//float headerB_12[8] =   { 1,1,1,0, 1,1,1,1 }; //H[12]
			//float headerB_28[8] =   { 0,0,1,0, 1,1,1,1 }; //H[28]
			//float headerB_29[8] =   { 1,1,1,1, 0,0,0,0 }; //H[29]
			//float headerB_30[8] =   { 1,1,0,0, 0,1,0,0 }; //H[30]
			//float headerB_31[8] =   { 0,1,0,1, 1,1,1,1 }; //H[31]


			//Only even columns of first row
			if (fmod(column, 2.0) == 0)
			{
				int header = floor(column / 16);
				int headerPixel = fmod(column / 2, 8.0);

				if (header == 0) //Header A
				{
				col.b = headerA_0[headerPixel];
				} 
				else if (header == 1)
				{
				col.b = headerA_1[headerPixel];
				}
				else if (header == 2)
				{
				col.b = headerA_2[headerPixel];
				}
				else if (header == 3)
				{
				col.b = headerA_3[headerPixel];
				}
				else if (header == 4)
				{
				col.b = headerA_4[headerPixel];
				}
				else if (header == 5)
				{
				col.b = headerA_5[headerPixel];
				}
				else if (header == 6)
				{
				col.b = headerA_6[headerPixel];
				}
				else if (header == 7)
				{
				col.b = headerA_7[headerPixel];
				}
				else if (header == 8)
				{
				col.b = headerA_8[headerPixel];
				}
				else if (header == 9)
				{
				col.b = headerA_9[headerPixel];
				}
				else if (header == 10) //Header B
				{
				col.b = headerB_10[headerPixel];
				}
				else if (header == 11)
				{
				col.b = headerB_11[headerPixel];
				}
				else if (header == 12)
				{
				col.b = headerB_12[headerPixel];
				}
				else if (header >= 13 && header <= 27)
				{
				col.b = headerB_13_27[headerPixel];
				}
				else if (header == 28)
				{
				col.b = headerB_28[headerPixel];
				}
				else if (header == 29)
				{
				col.b = headerB_29[headerPixel];
				}
				else if (header == 30)
				{
				col.b = headerB_30[headerPixel];
				}
				else if (header == 31)
				{
				col.b = headerB_31[headerPixel];
				}

			}
			}
			}
			else
			{
			// black lines for every even line
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
