﻿// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shaders Book/Chapter 6/Diffuse Vertex-Level"
{
	Properties
	{//为了得到并控制材料的漫反射颜色
		_Diffuse("Diffuse",Color) = (1,1,1,1)
		//_MainTex ("Texture", 2D) = "white" {}
	}
		SubShader
	{
		
		Pass
		{
		Tags{"LightMode" = "ForwardBase"}

		//CGPROGARAM 用于包围CG代码片 即代码头
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
		// make fog work
		//内置文件 用于获取unity的内置变量 
		#include"Lighting.cginc"
	

		fixed4 _Diffuse;
		
		struct a2v
		{	
			float4 vertex:POSITION;
			float3 normal:NORMAL;
		};
		struct v2f {
			float4 pos:sv_POSITION;
			float3 color :COLOR;
		};

			//定点着色器 
			v2f vert (a2v v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				fixed3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
				fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
				fixed3 diffuse = _LightColor0.rgb*_Diffuse.rgb*saturate(dot(worldNormal, worldLight));
				o.color = ambient + diffuse;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				return fixed4(i.color,1.0);
			}
			ENDCG
		}
	}
		FallBack "Diffuse"
}
