--
-- premake4 file to build TerrainRL
-- Copyright (c) 2009-2017 Glen Berseth
-- See license.txt for complete license.
--

local action = _ACTION or ""
local todir = "./" .. action
-- local todir = "./"

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

local linuxLibraryLoc = "./external/"

solution "TerrainRL"
	configurations { 
		"Debug",
		"Release"
	}
	
	platforms {
		"x32", 
		"x64"
	}
	location (todir)

	-- extra warnings, no exceptions or rtti
	flags { 
		-- "ExtraWarnings",
--		"FloatFast",
--		"NoExceptions",
--		"NoRTTI",
		"Symbols"
	}
	-- defines { "ENABLE_GUI", "ENABLE_GLFW" }

	-- debug configs
	configuration { "Debug*"}
		defines { "DEBUG" }
		flags {
			"Symbols",
			Optimize = Off
		}
		targetdir ( "./x64/Debug" )
 
 	-- release configs
	configuration {"Release*"}
		defines { "NDEBUG" }
		flags { "Optimize" }
		targetdir ( "./x64/Release" )

end
	
	configuration { "linux", "Debug*", "gmake"}
        buildoptions { "-ggdb -fPIC" }
		linkoptions { 
			-- "-stdlib=libc++" ,
			"-Wl,-rpath," .. path.getabsolute("lib")
		}
		targetdir ( "./x64/Debug" )

	configuration { "linux", "Release*", "gmake"}
        buildoptions { "-ggdb -fPIC" }
		linkoptions { 
			-- "-stdlib=libc++" ,
			"-Wl,-rpath," .. path.getabsolute("lib")
		}

		links {
	        "OpenGL.framework",
        }

	end


project "TerrainRL"
	language "C++"
	kind "ConsoleApp"

	files { 
		-- Source files for this project
		-- "render/*.cpp",
		-- "util/*.cpp",
		-- "sim/*.cpp",
		-- "anim/*.cpp",
		-- "learning/*.cpp",
		-- "scenarios/*.cpp",
		"external/LodePNG/*.cpp",
		"Main.cpp"
	}
	excludes {
		"learning/DMACETrainer - Copy.cpp",
		"scenarios/ScenarioExpImitate - Copy.cpp",
		"**- Copy**.cpp",
	}	
	includedirs { 
		"./",
		"anim",
		"learning",
		"sim",
		"render",
		"scenarios",
		"util"
	}
	links {
		"terrainrlScenarios",
		"terrainrlLearning",
		"terrainrlAnim",
		"terrainrlSim",
		"terrainrlUtil",
		"terrainrlRender",
	}

	

	defines {
		"_CRT_SECURE_NO_WARNINGS",
		"_SCL_SECURE_NO_WARNINGS",
		"CPU_ONLY",
		"GOOGLE_GLOG_DLL_DECL=",
		"ENABLE_TRAINING",
	}

	buildoptions("-std=c++0x -ggdb" )	

	-- linux library cflags and libs
	configuration { "linux", "gmake" }
		buildoptions { 
			"`pkg-config --cflags gl`",
			"`pkg-config --cflags glu`" 
		}
		linkoptions { 
			"-Wl,-rpath," .. path.getabsolute("lib") ,
			"`pkg-config --libs gl`",
			"`pkg-config --libs glu`" 
		}
		libdirs { 
			-- "lib",
			linuxLibraryLoc .. "Bullet/bin",
			linuxLibraryLoc .. "jsoncpp/build/debug/src/lib_json",
			linuxLibraryLoc .. "caffe/build/lib",
		}
		
		includedirs { 
			linuxLibraryLoc .. "Bullet/src",
			linuxLibraryLoc,
			linuxLibraryLoc .. "jsoncpp/include",
			linuxLibraryLoc .. "caffe/include/",
			linuxLibraryLoc .. "caffe/build/src/",
			"C:/Program Files (x86)/boost/boost_1_58_0/",
			linuxLibraryLoc .. "3rdparty/include/hdf5",
			linuxLibraryLoc .. "3rdparty/include/",
			linuxLibraryLoc .. "3rdparty/include/openblas",
			linuxLibraryLoc .. "3rdparty/include/lmdb",
			"/usr/local/cuda/include/",
			linuxLibraryLoc .. "OpenCV/include",
			linuxLibraryLoc .. "caffe/src/",
			"/usr/include/hdf5/serial/",
		}
		defines {
			"_LINUX_",
		}
			-- debug configs
		configuration { "linux", "Debug*", "gmake"}
			links {
				"X11",
				"dl",
				"pthread",
				-- Just a few dependancies....
				"BulletDynamics_gmake_x64_debug",
				"BulletCollision_gmake_x64_debug",
				"LinearMath_gmake_x64_debug",
				"jsoncpp",
				"boost_system",
				"caffe",
				"glog",
				--"hdf5",
				--"hdf5_hl",
				"hdf5_serial_hl",
				"hdf5_serial",
				"glut",
				"GLEW",
				"GLU",
			}
	 
	 	-- release configs
		configuration { "linux", "Release*", "gmake"}
			defines { "NDEBUG" }
			links {
				"X11",
				"dl",
				"pthread",
				-- Just a few dependancies....
				"BulletDynamics_gmake_x64_release",
				"BulletCollision_gmake_x64_release",
				"LinearMath_gmake_x64_release",
				"jsoncpp",
				"boost_system",
				"caffe",
				"glog",
				--"hdf5",
				--"hdf5_hl",
				"hdf5_serial_hl",
				"hdf5_serial",
				"glut",
				"GLEW",
				"GLU",
			}


project "terrainrlUtil"
	language "C++"
	kind "SharedLib"

	files { 
		-- Source files for this project
		--"util/*.h",
		"util/*.cpp",
	}
	excludes {
		"learning/DMACETrainer - Copy.cpp",
		"scenarios/ScenarioExpImitate - Copy.cpp",
		"**- Copy**.cpp",
	}	
	includedirs { 
		"./",
		"util"
	}

	

	defines {
		"_CRT_SECURE_NO_WARNINGS",
		"_SCL_SECURE_NO_WARNINGS",
		"CPU_ONLY",
		"GOOGLE_GLOG_DLL_DECL=",
		"ENABLE_TRAINING",
	}

	buildoptions("-std=c++0x -ggdb" )	

	-- linux library cflags and libs
	configuration { "linux", "gmake" }
		targetdir ( "./lib" )
		buildoptions { 
			"`pkg-config --cflags gl`",
			"`pkg-config --cflags glu`" 
		}
		linkoptions { 
			"-Wl,-rpath," .. path.getabsolute("lib") ,
			"`pkg-config --libs gl`",
			"`pkg-config --libs glu`" 
		}
		libdirs { 
			-- "lib",
			linuxLibraryLoc .. "Bullet/bin",
			linuxLibraryLoc .. "jsoncpp/build/debug/src/lib_json",
			linuxLibraryLoc .. "caffe/build/lib",
		}
		
		includedirs { 
			linuxLibraryLoc .. "Bullet/src",
			linuxLibraryLoc,
			linuxLibraryLoc .. "jsoncpp/include",
			linuxLibraryLoc .. "caffe/include/",
			linuxLibraryLoc .. "caffe/build/src/",
			"C:/Program Files (x86)/boost/boost_1_58_0/",
			linuxLibraryLoc .. "3rdparty/include/hdf5",
			linuxLibraryLoc .. "3rdparty/include/",
			linuxLibraryLoc .. "3rdparty/include/openblas",
			linuxLibraryLoc .. "3rdparty/include/lmdb",
			"/usr/local/cuda/include/",
			linuxLibraryLoc .. "OpenCV/include",
			linuxLibraryLoc .. "caffe/src/",
			"/usr/include/hdf5/serial/",
		}
		defines {
			"_LINUX_",
		}
			-- debug configs
		configuration { "linux", "Debug*", "gmake"}
			links {
				"X11",
				"dl",
				"pthread",
				-- Just a few dependancies....
				"BulletDynamics_gmake_x64_debug",
				"BulletCollision_gmake_x64_debug",
				"LinearMath_gmake_x64_debug",
				"jsoncpp",
				"boost_system",
				"caffe",
				"glog",
				--"hdf5",
				--"hdf5_hl",
				"hdf5_serial_hl",
				"hdf5_serial",
				"glut",
				"GLEW",
			}
	 
	 	-- release configs
		configuration { "linux", "Release*", "gmake"}
			defines { "NDEBUG" }
			links {
				"X11",
				"dl",
				"pthread",
				-- Just a few dependancies....
				"BulletDynamics_gmake_x64_release",
				"BulletCollision_gmake_x64_release",
				"LinearMath_gmake_x64_release",
				"jsoncpp",
				"boost_system",
				"caffe",
				"glog",
				--"hdf5",
				--"hdf5_hl",
				"hdf5_serial_hl",
				"hdf5_serial",
				"glut",
				"GLEW",
			}



project "terrainrlLearning"
	language "C++"
	kind "SharedLib"

	files { 
		-- Source files for this project
		--"util/*.h",
		"learning/*.cpp",
	}
	excludes {
		"learning/DMACETrainer - Copy.cpp",
		"scenarios/ScenarioExpImitate - Copy.cpp",
		"**- Copy**.cpp",
	}	
	includedirs { 
		"./",
		"learning",
		"util",
	}
	links {
		"terrainrlUtil",
		"terrainrlAnim",
	}

	

	defines {
		"_CRT_SECURE_NO_WARNINGS",
		"_SCL_SECURE_NO_WARNINGS",
		"CPU_ONLY",
		"GOOGLE_GLOG_DLL_DECL=",
		"ENABLE_TRAINING",
	}

	buildoptions("-std=c++0x -ggdb" )	

	-- linux library cflags and libs
	configuration { "linux", "gmake" }

		targetdir ( "./lib" )

		buildoptions { 
			"`pkg-config --cflags gl`",
			"`pkg-config --cflags glu`" 
		}
		linkoptions { 
			"-Wl,-rpath," .. path.getabsolute("lib") ,
			"`pkg-config --libs gl`",
			"`pkg-config --libs glu`" 
		}
		libdirs { 
			-- "lib",
			linuxLibraryLoc .. "Bullet/bin",
			linuxLibraryLoc .. "jsoncpp/build/debug/src/lib_json",
			linuxLibraryLoc .. "caffe/build/lib",
		}
		
		includedirs { 
			linuxLibraryLoc .. "Bullet/src",
			linuxLibraryLoc,
			linuxLibraryLoc .. "jsoncpp/include",
			linuxLibraryLoc .. "caffe/include/",
			linuxLibraryLoc .. "caffe/build/src/",
			"C:/Program Files (x86)/boost/boost_1_58_0/",
			linuxLibraryLoc .. "3rdparty/include/hdf5",
			linuxLibraryLoc .. "3rdparty/include/",
			linuxLibraryLoc .. "3rdparty/include/openblas",
			linuxLibraryLoc .. "3rdparty/include/lmdb",
			"/usr/local/cuda/include/",
			linuxLibraryLoc .. "OpenCV/include",
			linuxLibraryLoc .. "caffe/src/",
			"/usr/include/hdf5/serial/",
		}
		defines {
			"_LINUX_",
		}
			-- debug configs
		configuration { "linux", "Debug*", "gmake"}
			links {
				"X11",
				"dl",
				"pthread",
				-- Just a few dependancies....
				"BulletDynamics_gmake_x64_debug",
				"BulletCollision_gmake_x64_debug",
				"LinearMath_gmake_x64_debug",
				"jsoncpp",
				"boost_system",
				"caffe",
				"glog",
				--"hdf5",
				--"hdf5_hl",
				"hdf5_serial_hl",
				"hdf5_serial",
				"glut",
				"GLEW",
			}
	 
	 	-- release configs
		configuration { "linux", "Release*", "gmake"}
			defines { "NDEBUG" }
			links {
				"X11",
				"dl",
				"pthread",
				-- Just a few dependancies....
				"BulletDynamics_gmake_x64_release",
				"BulletCollision_gmake_x64_release",
				"LinearMath_gmake_x64_release",
				"jsoncpp",
				"boost_system",
				"caffe",
				"glog",
				--"hdf5",
				--"hdf5_hl",
				"hdf5_serial_hl",
				"hdf5_serial",
				"glut",
				"GLEW",
			}



project "terrainrlAnim"
	language "C++"
	kind "SharedLib"

	files { 
		-- Source files for this project
		--"util/*.h",
		"anim/*.cpp",
	}
	excludes {
		"learning/DMACETrainer - Copy.cpp",
		"scenarios/ScenarioExpImitate - Copy.cpp",
		"**- Copy**.cpp",
	}	
	includedirs { 
		"./",
		"anim"
	}
	links {
		"terrainrlUtil",
		-- "terrainrlSim",
	}

	

	defines {
		"_CRT_SECURE_NO_WARNINGS",
		"_SCL_SECURE_NO_WARNINGS",
		"CPU_ONLY",
		"GOOGLE_GLOG_DLL_DECL=",
		"ENABLE_TRAINING",
	}

	buildoptions("-std=c++0x -ggdb" )	

	-- linux library cflags and libs
	configuration { "linux", "gmake" }

		targetdir ( "./lib" )
		buildoptions { 
			"`pkg-config --cflags gl`",
			"`pkg-config --cflags glu`" 
		}
		linkoptions { 
			"-Wl,-rpath," .. path.getabsolute("lib") ,
			"`pkg-config --libs gl`",
			"`pkg-config --libs glu`" 
		}
		libdirs { 
			-- "lib",
			linuxLibraryLoc .. "Bullet/bin",
			linuxLibraryLoc .. "jsoncpp/build/debug/src/lib_json",
			linuxLibraryLoc .. "caffe/build/lib",
		}
		
		includedirs { 
			linuxLibraryLoc .. "Bullet/src",
			linuxLibraryLoc,
			linuxLibraryLoc .. "jsoncpp/include",
			linuxLibraryLoc .. "caffe/include/",
			linuxLibraryLoc .. "caffe/build/src/",
			"C:/Program Files (x86)/boost/boost_1_58_0/",
			linuxLibraryLoc .. "3rdparty/include/hdf5",
			linuxLibraryLoc .. "3rdparty/include/",
			linuxLibraryLoc .. "3rdparty/include/openblas",
			linuxLibraryLoc .. "3rdparty/include/lmdb",
			"/usr/local/cuda/include/",
			linuxLibraryLoc .. "OpenCV/include",
			linuxLibraryLoc .. "caffe/src/",
			"/usr/include/hdf5/serial/",
		}
		defines {
			"_LINUX_",
		}
			-- debug configs
		configuration { "linux", "Debug*", "gmake"}
			links {
				"X11",
				"dl",
				"pthread",
				-- Just a few dependancies....
				"BulletDynamics_gmake_x64_debug",
				"BulletCollision_gmake_x64_debug",
				"LinearMath_gmake_x64_debug",
				"jsoncpp",
				"boost_system",
				"caffe",
				"glog",
				--"hdf5",
				--"hdf5_hl",
				"hdf5_serial_hl",
				"hdf5_serial",
				"glut",
				"GLEW",
			}
	 
	 	-- release configs
		configuration { "linux", "Release*", "gmake"}
			defines { "NDEBUG" }
			links {
				"X11",
				"dl",
				"pthread",
				-- Just a few dependancies....
				"BulletDynamics_gmake_x64_release",
				"BulletCollision_gmake_x64_release",
				"LinearMath_gmake_x64_release",
				"jsoncpp",
				"boost_system",
				"caffe",
				"glog",
				--"hdf5",
				--"hdf5_hl",
				"hdf5_serial_hl",
				"hdf5_serial",
				"glut",
				"GLEW",
			}




project "terrainrlSim"
	language "C++"
	kind "SharedLib"

	files { 
		-- Source files for this project
		--"util/*.h",
		"sim/*.cpp",
	}
	excludes {
		"learning/DMACETrainer - Copy.cpp",
		"scenarios/ScenarioExpImitate - Copy.cpp",
		"**- Copy**.cpp",
	}	
	includedirs { 
		"./",
		"sim",
		-- "util"
	}
	links {
		"terrainrlUtil",
		"terrainrlAnim",
		"terrainrlLearning",
		-- "terrainrlRender",
	}

	

	defines {
		"_CRT_SECURE_NO_WARNINGS",
		"_SCL_SECURE_NO_WARNINGS",
		"CPU_ONLY",
		"GOOGLE_GLOG_DLL_DECL=",
		"ENABLE_TRAINING",
	}

	buildoptions("-std=c++0x -ggdb" )	

	-- linux library cflags and libs
	configuration { "linux", "gmake" }

		targetdir ( "./lib" )
		buildoptions { 
			"`pkg-config --cflags gl`",
			"`pkg-config --cflags glu`" 
		}
		linkoptions { 
			"-Wl,-rpath," .. path.getabsolute("lib") ,
			"`pkg-config --libs gl`",
			"`pkg-config --libs glu`" 
		}
		libdirs { 
			-- "lib",
			linuxLibraryLoc .. "Bullet/bin",
			linuxLibraryLoc .. "jsoncpp/build/debug/src/lib_json",
			linuxLibraryLoc .. "caffe/build/lib",
		}
		
		includedirs { 
			linuxLibraryLoc .. "Bullet/src",
			linuxLibraryLoc,
			linuxLibraryLoc .. "jsoncpp/include",
			linuxLibraryLoc .. "caffe/include/",
			linuxLibraryLoc .. "caffe/build/src/",
			"C:/Program Files (x86)/boost/boost_1_58_0/",
			linuxLibraryLoc .. "3rdparty/include/hdf5",
			linuxLibraryLoc .. "3rdparty/include/",
			linuxLibraryLoc .. "3rdparty/include/openblas",
			linuxLibraryLoc .. "3rdparty/include/lmdb",
			"/usr/local/cuda/include/",
			linuxLibraryLoc .. "OpenCV/include",
			linuxLibraryLoc .. "caffe/src/",
			"/usr/include/hdf5/serial/",
		}
		defines {
			"_LINUX_",
		}
			-- debug configs
		configuration { "linux", "Debug*", "gmake"}
			links {
				"X11",
				"dl",
				"pthread",
				-- Just a few dependancies....
				"BulletDynamics_gmake_x64_debug",
				"BulletCollision_gmake_x64_debug",
				"LinearMath_gmake_x64_debug",
				"jsoncpp",
				"boost_system",
				"caffe",
				"glog",
				--"hdf5",
				--"hdf5_hl",
				"hdf5_serial_hl",
				"hdf5_serial",
				"glut",
				"GLEW",
			}
	 
	 	-- release configs
		configuration { "linux", "Release*", "gmake"}
			defines { "NDEBUG" }
			links {
				"X11",
				"dl",
				"pthread",
				-- Just a few dependancies....
				"BulletDynamics_gmake_x64_release",
				"BulletCollision_gmake_x64_release",
				"LinearMath_gmake_x64_release",
				"jsoncpp",
				"boost_system",
				"caffe",
				"glog",
				--"hdf5",
				--"hdf5_hl",
				"hdf5_serial_hl",
				"hdf5_serial",
				"glut",
				"GLEW",
			}




project "terrainrlRender"
	language "C++"
	kind "SharedLib"

	files { 
		-- Source files for this project
		--"util/*.h",
		"render/*.cpp",
		"render/*.h",
		"../library/LodePNG/*.cpp",
		"../library/LodePNG/*.h",
		"external/LodePNG/*.cpp",
	}
	excludes {
		"learning/DMACETrainer - Copy.cpp",
		"scenarios/ScenarioExpImitate - Copy.cpp",
		"**- Copy**.cpp",
	}	
	includedirs { 
		"./",
	}
	links {
		"terrainrlUtil",
		"terrainrlAnim"
	}

	

	defines {
		"_CRT_SECURE_NO_WARNINGS",
		"_SCL_SECURE_NO_WARNINGS",
		"CPU_ONLY",
		"GOOGLE_GLOG_DLL_DECL=",
		"ENABLE_TRAINING",
	}

	buildoptions("-std=c++0x -ggdb" )	

	-- linux library cflags and libs
	configuration { "linux", "gmake" }

		targetdir ( "./lib" )

		buildoptions { 
			"`pkg-config --cflags gl`",
			"`pkg-config --cflags glu`" 
		}
		linkoptions { 
			"-Wl,-rpath," .. path.getabsolute("lib") ,
			"`pkg-config --libs gl`",
			"`pkg-config --libs glu`" 
		}
		libdirs { 
			-- "lib",
			linuxLibraryLoc .. "Bullet/bin",
			linuxLibraryLoc .. "jsoncpp/build/debug/src/lib_json",
			linuxLibraryLoc .. "caffe/build/lib",
		}
		
		includedirs { 
			linuxLibraryLoc .. "Bullet/src",
			linuxLibraryLoc,
			linuxLibraryLoc .. "jsoncpp/include",
			linuxLibraryLoc .. "caffe/include/",
			linuxLibraryLoc .. "caffe/build/src/",
			"C:/Program Files (x86)/boost/boost_1_58_0/",
			linuxLibraryLoc .. "3rdparty/include/hdf5",
			linuxLibraryLoc .. "3rdparty/include/",
			linuxLibraryLoc .. "3rdparty/include/openblas",
			linuxLibraryLoc .. "3rdparty/include/lmdb",
			"/usr/local/cuda/include/",
			linuxLibraryLoc .. "OpenCV/include",
			linuxLibraryLoc .. "caffe/src/",
			"/usr/include/hdf5/serial/",
		}
		defines {
			"_LINUX_",
		}
			-- debug configs
		configuration { "linux", "Debug*", "gmake"}
			links {
				"X11",
				"dl",
				"pthread",
				-- Just a few dependancies....
				"BulletDynamics_gmake_x64_debug",
				"BulletCollision_gmake_x64_debug",
				"LinearMath_gmake_x64_debug",
				"jsoncpp",
				"boost_system",
				"caffe",
				"glog",
				--"hdf5",
				--"hdf5_hl",
				"hdf5_serial_hl",
				"hdf5_serial",
				"glut",
				"GLEW",
				"GLU",
			}
	 
	 	-- release configs
		configuration { "linux", "Release*", "gmake"}
			defines { "NDEBUG" }
			links {
				"X11",
				"dl",
				"pthread",
				-- Just a few dependancies....
				"BulletDynamics_gmake_x64_release",
				"BulletCollision_gmake_x64_release",
				"LinearMath_gmake_x64_release",
				"jsoncpp",
				"boost_system",
				"caffe",
				"glog",
				--"hdf5",
				--"hdf5_hl",
				"hdf5_serial_hl",
				"hdf5_serial",
				"glut",
				"GLEW",
				"GLU",
			}



project "terrainrlScenarios"
	language "C++"
	kind "SharedLib"

	files { 
		-- Source files for this project
		--"util/*.h",
		"scenarios/*.cpp",
	}
	excludes {
		"learning/DMACETrainer - Copy.cpp",
		"scenarios/ScenarioExpImitate - Copy.cpp",
		"**- Copy**.cpp",
	}	
	includedirs { 
		"./",
		"scenarios"
	}
	links {
		"terrainrlLearning",
		"terrainrlAnim",
		"terrainrlSim",
		"terrainrlUtil",
		"terrainrlRender",
	}

	

	defines {
		"_CRT_SECURE_NO_WARNINGS",
		"_SCL_SECURE_NO_WARNINGS",
		"CPU_ONLY",
		"GOOGLE_GLOG_DLL_DECL=",
		"ENABLE_TRAINING",
	}

	buildoptions("-std=c++0x -ggdb" )	

	-- linux library cflags and libs
	configuration { "linux", "gmake" }
		targetdir ( "./lib" )
		buildoptions { 
			"`pkg-config --cflags gl`",
			"`pkg-config --cflags glu`" 
		}
		linkoptions { 
			"-Wl,-rpath," .. path.getabsolute("lib") ,
			"`pkg-config --libs gl`",
			"`pkg-config --libs glu`" 
		}
		libdirs { 
			-- "lib",
			linuxLibraryLoc .. "Bullet/bin",
			linuxLibraryLoc .. "jsoncpp/build/debug/src/lib_json",
			linuxLibraryLoc .. "caffe/build/lib",
		}
		
		includedirs { 
			linuxLibraryLoc .. "Bullet/src",
			linuxLibraryLoc,
			linuxLibraryLoc .. "jsoncpp/include",
			linuxLibraryLoc .. "caffe/include/",
			linuxLibraryLoc .. "caffe/build/src/",
			"C:/Program Files (x86)/boost/boost_1_58_0/",
			linuxLibraryLoc .. "3rdparty/include/hdf5",
			linuxLibraryLoc .. "3rdparty/include/",
			linuxLibraryLoc .. "3rdparty/include/openblas",
			linuxLibraryLoc .. "3rdparty/include/lmdb",
			"/usr/local/cuda/include/",
			linuxLibraryLoc .. "OpenCV/include",
			linuxLibraryLoc .. "caffe/src/",
			"/usr/include/hdf5/serial/",
		}
		defines {
			"_LINUX_",
		}
			-- debug configs
		configuration { "linux", "Debug*", "gmake"}
			links {
				"X11",
				"dl",
				"pthread",
				-- Just a few dependancies....
				"BulletDynamics_gmake_x64_debug",
				"BulletCollision_gmake_x64_debug",
				"LinearMath_gmake_x64_debug",
				"jsoncpp",
				"boost_system",
				"caffe",
				"glog",
				--"hdf5",
				--"hdf5_hl",
				"hdf5_serial_hl",
				"hdf5_serial",
				"glut",
				"GLEW",
			}
	 
	 	-- release configs
		configuration { "linux", "Release*", "gmake"}
			defines { "NDEBUG" }
			links {
				"X11",
				"dl",
				"pthread",
				-- Just a few dependancies....
				"BulletDynamics_gmake_x64_release",
				"BulletCollision_gmake_x64_release",
				"LinearMath_gmake_x64_release",
				"jsoncpp",
				"boost_system",
				"caffe",
				"glog",
				--"hdf5",
				--"hdf5_hl",
				"hdf5_serial_hl",
				"hdf5_serial",
				"glut",
				"GLEW",
			}


		
end


project "TerrainRL_Optimizer"
	language "C++"
	kind "ConsoleApp"

	files { 
		-- Source files for this project
		-- "../learning/*.cpp",
		-- "../scenarios/*.cpp",
		-- "../sim/*.cpp",
		-- "../util/*.cpp",
		-- "../anim/*.cpp",
		"optimizer/opt/*.cpp",
		"optimizer/opt/*.c",
		"optimizer/opt/*.h",
		"optimizer/scenarios/*.cpp",
		"optimizer/Main.cpp",
		

	}
	excludes {
		"scenarios/Draw*.h",
		"scenarios/Draw*.cpp",
		"sim/CharTracer.cpp",
		"learning/DMACETrainer - Copy.cpp",
		"scenarios/ScenarioExpImitate - Copy.cpp",
		"**- Copy**.cpp",
		"learning/CaclaTrainer - Copy (2).cpp",
		"learning/CaclaTrainer - Copy.cpp",
		"optimizer/opt/QL.c",
		"optimizer/opt/QuadProg.cpp",
	}

	includedirs { 
		"optimizer",
		"./",
		"optimizer/opt",
		"anim",
		"learning",
		"sim",
		"render",
		"scenarios",
		"util"
	}
	links {
		"terrainrlScenarios",
		"terrainrlLearning",
		"terrainrlAnim",
		"terrainrlSim",
		"terrainrlUtil",
		"terrainrlRender",
	}
	

	defines {
		"_CRT_SECURE_NO_WARNINGS",
		"_SCL_SECURE_NO_WARNINGS",
		"CPU_ONLY",
		"GOOGLE_GLOG_DLL_DECL=",
		"ENABLE_TRAINING",
	}

	buildoptions("-std=c++0x -ggdb -g" )	

	-- linux library cflags and libs
	configuration { "linux", "gmake" }
		linkoptions { 
			"-Wl,-rpath," .. path.getabsolute("lib") ,
		}
		libdirs { 
			-- "lib",
			linuxLibraryLoc .. "Bullet/bin",
			linuxLibraryLoc .. "jsoncpp/build/debug/src/lib_json",
			linuxLibraryLoc .. "caffe/build/lib",
		}
		
		includedirs { 
			linuxLibraryLoc .. "Bullet/src",
			linuxLibraryLoc,
			linuxLibraryLoc .. "jsoncpp/include",
			linuxLibraryLoc .. "caffe/include/",
			linuxLibraryLoc .. "caffe/build/src/",
			"C:/Program Files (x86)/boost/boost_1_58_0/",
			linuxLibraryLoc .. "3rdparty/include/hdf5",
			linuxLibraryLoc .. "3rdparty/include/",
			linuxLibraryLoc .. "3rdparty/include/openblas",
			linuxLibraryLoc .. "3rdparty/include/lmdb",
			"/usr/local/cuda/include/",
			linuxLibraryLoc .. "OpenCV/include",
			linuxLibraryLoc .. "caffe/src/",
			linuxLibraryLoc .. "CMA-ESpp/cma-es",
			"/usr/include/hdf5/serial/",
		}
		defines {
			"_LINUX_",
		}

		configuration { "linux", "Debug*", "gmake"}
			links {
				"X11",
				"dl",
				"pthread",
				-- Just a few dependancies....
				"BulletDynamics_gmake_x64_debug",
				"BulletCollision_gmake_x64_debug",
				"LinearMath_gmake_x64_debug",
				"jsoncpp",
				"boost_system",
				"caffe",
				"glog",
				--"hdf5",
				--"hdf5_hl",
				"hdf5_serial_hl",
				"hdf5_serial",
				-- "f2c",
			}
	 
	 	-- release configs
		configuration { "linux", "Release*", "gmake"}
			links {
				"X11",
				"dl",
				"pthread",
				-- Just a few dependancies....
				"BulletDynamics_gmake_x64_release",
				"BulletCollision_gmake_x64_release",
				"LinearMath_gmake_x64_release",
				"jsoncpp",
				"boost_system",
				"caffe",
				"glog",
				--"hdf5",
				--"hdf5_hl",
				"hdf5_serial_hl",
				"hdf5_serial",
   				-- "f2c",
			}



dofile( "./simAdapter/premake4-dev.lua")

