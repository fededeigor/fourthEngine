workspace "Render_Engine"
	architecture "x64"

	configurations
	{
		"Debug",
		"Release",
		"Dist"
	}

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

defineLightViewSpace = "ILLUMINATION_VIEW_SPACE"

defineLightViewSpace = ""	
defineLightViewSpace = "CAMERA_CENTER_WS"   

defineParticlesLightning = "PARTICLES_LIGHTNING_SPHERES"
defineParticlesLightning = "PARTICLES_LIGHTNING_BILLBOARDS"

project "fourth_Engine"
	location "fourth_Engine"
	kind "StaticLib"
	language "C++"
	cppdialect "C++17"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	debugdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir("bin-int/" .. outputdir .. "/%{prj.name}")


	warnings "High"
	pchheader "pch.h"
	pchsource "fourth_Engine/pch.cpp"




	files
	{
		"%{prj.name}/fourthE.h",
		"%{prj.name}/pch.h",
		"%{prj.name}/pch.cpp",
		"%{prj.name}/src/**.c",
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.c",
		"%{prj.name}/src/**.hpp",
		"%{prj.name}/src/**.cpp",
		"%{prj.name}/include/**.c",
		"%{prj.name}/include/**.h",
		"%{prj.name}/include/**.c",
		"%{prj.name}/include/**.hpp",
		"%{prj.name}/include/**.cpp",
		"%{prj.name}/vendor/SimpleMath/**.h",
		"%{prj.name}/vendor/SimpleMath/**.cpp",
		"%{prj.name}/vendor/SimpleMath/**.inl",
		"%{prj.name}/vendor/DirectXTex/DDSTextureLoader/**.h",
		"%{prj.name}/vendor/DirectXTex/DDSTextureLoader/**.cpp",


		"%{prj.name}/Shaders/**_PS.hlsl",
		"%{prj.name}/Shaders/**_VS.hlsl",
		"%{prj.name}/Shaders/**_HS.hlsl",
		"%{prj.name}/Shaders/**_GS.hlsl",
		"%{prj.name}/Shaders/**_DS.hlsl",
		"%{prj.name}/Shaders/**_CS.hlsl",
		"%{prj.name}/Shaders/**.hlsli"


	}

	
	includedirs
	{
		"%{prj.name}/vendor",
		"%{prj.name}/vendor/SimpleMath",
		"%{prj.name}/vendor/spdlog",
		"%{prj.name}/vendor/assimp/include",
		"%{prj.name}/vendor/DirectXTex/Include",
		"%{prj.name}/vendor/assimp",
		"%{prj.name}/src",
		"%{prj.name}"
	}

	shadermodel("5.0")

	    shaderdefines(defineLightViewSpace)
		shaderdefines(defineParticlesLightning)
		shaderassembler("AssemblyCode")
		local shader_dir = "../".."bin/" .. outputdir .. "/fourth_Engine/Shaders/"

		 -- HLSL files that don't end with 'Extensions' will be ignored as they will be
         -- used as includes

		 --Compiled shaders go to each config target path
		filter("files:**.hlsl")
		   flags("ExcludeFromBuild")
		   shaderobjectfileoutput(shader_dir.."%{file.basename}"..".cso")
		   shaderassembleroutput(shader_dir.."%{file.basename}"..".asm")

		filter("files:**_PS.hlsl")
		   removeflags("ExcludeFromBuild")
		   shadertype("Pixel")

	    filter("files:**_GS.hlsl")
	    removeflags("ExcludeFromBuild")
	    shadertype("Geometry")

		filter("files:**_HS.hlsl")
		   removeflags("ExcludeFromBuild")
		   shadertype("Hull")

		filter("files:**_DS.hlsl")
		   removeflags("ExcludeFromBuild")
		   shadertype("Domain")

		filter("files:**_VS.hlsl")
		   removeflags("ExcludeFromBuild")
		   shadertype("Vertex")

		filter("files:**_CS.hlsl")
		   removeflags("ExcludeFromBuild")
		   shadertype("Compute")

			shaderoptions({"/WX"})

	filter "system:windows"

		systemversion "latest"
		staticruntime "on"
		flags {"MultiProcessorCompile"}

		defines
		{
			"ENGINE_PLATFORM_WINDOWS",
			"DEFAULT_CONSTRUCTOR",
			defineLightViewSpace,
			defineParticlesLightning
		}

		filter "configurations:Debug"
			defines "ENGINE_DEBUG"
			symbols "on"
			links
			{
				"%{wks.location}/%{prj.name}/vendor/assimp/lib/lib_Debug/assimp-vc143-mtd",
				"%{wks.location}/%{prj.name}/vendor/assimp/lib/lib_Debug/zlibstaticd",
				"%{wks.location}/%{prj.name}/vendor/DirectXTex/lib/bin_Debug/DirectXTex"


			}

		filter "configurations:Release"
			defines "ENGINE_RELEASE"
			optimize "on"
			symbols "on"
			links
			{
				"%{wks.location}/%{prj.name}/vendor/assimp/lib/lib_Release/assimp-vc143-mt",
				"%{wks.location}/%{prj.name}/vendor/assimp/lib/lib_Release/zlibstatic",
				"%{wks.location}/%{prj.name}/vendor/DirectXTex/lib/bin_Release/DirectXTex"

			}

		filter "configurations:Dist"
			defines "ENGINE_DIST"
			defines "NDEBUG"
			optimize "on"
			links
			{
				"%{wks.location}/%{prj.name}/vendor/assimp/lib/lib_Release/assimp-vc143-mt",
				"%{wks.location}/%{prj.name}/vendor/assimp/lib/lib_Release/zlibstatic",
				"%{wks.location}/%{prj.name}/vendor/DirectXTex/lib/bin_Release/DirectXTex"

			}





project "Client"

	location "Client"
	kind "WindowedApp"
	language "C++"
	cppdialect "C++17"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir("bin-int/" .. outputdir .. "/%{prj.name}")
	debugdir ("bin/" .. outputdir .. "/%{prj.name}")


	warnings "High"

	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp",
		"%{prj.name}/include/**.h",
		"%{prj.name}/include/**.cpp"

	}

	includedirs
	{
		"%{prj.name}",

		"fourth_Engine/vendor",
		"fourth_Engine/vendor/DirectXTex/DDSTextureLoader",
		"fourth_Engine/vendor/DirectXTex/Include",
		"fourth_Engine/vendor/assimp/include",
	    "fourth_Engine/vendor/SimpleMath",
		"fourth_Engine/vendor/spdlog",
		"fourth_Engine"
	}

	links
	{
		"fourth_Engine"
	}

		filter "system:windows"

		systemversion "latest"
		staticruntime "on"
		flags {"MultiProcessorCompile"}



		filter "configurations:Debug"
			defines "ENGINE_DEBUG"
			symbols "on"
			links
			{
				"%{wks.location}/%{prj.name}/vendor/ImGUI/lib/bin_Debug/ImGui"
			}

		filter "configurations:Release"
			defines "ENGINE_RELEASE"
			optimize "on"
			symbols "on"
			links
			{
				"%{wks.location}/%{prj.name}/vendor/ImGUI/lib/bin_Release/ImGui"
			}
			

		filter "configurations:Dist"
			defines "ENGINE_DIST"
			optimize "on"
			links
			{
				"%{wks.location}/%{prj.name}/vendor/ImGUI/lib/bin_Release/ImGui"
			}
		

project "IBLGenerator"

	location "IBLGenerator"
	kind "ConsoleApp"
	language "C++"
	cppdialect "C++17"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir("bin-int/" .. outputdir .. "/%{prj.name}")
	debugdir ("bin/" .. outputdir .. "/%{prj.name}")


	warnings "High"

	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp"
	}

	includedirs
	{
		"fourth_Engine",
		"fourth_Engine/vendor"
	}

	links
	{
		"fourth_Engine"
	}

	filter "system:windows"

	systemversion "latest";
	staticruntime "on"
	flags {"MultiProcessorCompile"}

	filter "configurations:Debug"
	symbols "on"

	filter "configurations:Release"
	optimize "on"

