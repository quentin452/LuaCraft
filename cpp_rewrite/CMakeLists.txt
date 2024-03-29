cmake_minimum_required(VERSION 3.28)
project(cpp_rewrite)

# Set common directories
set(LIB_DIR "${CMAKE_SOURCE_DIR}/libs")
set(SRC_DIR "${CMAKE_SOURCE_DIR}/src")

# Find source files
file(GLOB_RECURSE SOURCES "${SRC_DIR}/*.cpp" "${SRC_DIR}/*.h")

set(SOURCES_FILES ${SOURCES})

set(build_directory "C:/Users/iamacatfr/Desktop/github-intellidea/LuaCraft/cpp_rewrite/build/")

# External libraries
set(FREETYPE_INCLUDE_DIR "${LIB_DIR}/freetype-2.8.1/include")
set(OPENGL_LIBRARY "${LIB_DIR}/opengl/OpenGL32.lib")
set(FREETYPE_LIBRARY "${LIB_DIR}/freetype-2.8.1/freetypelib/freetype.lib")
set(GLFW_INCLUDE_DIR "${LIB_DIR}/glfw-3.4/include")
set(GLFW_LIBRARY "${LIB_DIR}/glfw-3.4.bin.WIN64/lib-vc2022/glfw3.lib")
set(VULKAN_INCLUDE_DIRS "${LIB_DIR}/Vulkan-Headers-main/include/vulkan" "${LIB_DIR}/Vulkan-Headers-main/include/vk_video")
set(NOISE_INCLUDE_DIR "${LIB_DIR}/noise")
set(VULKAN_LIBRARY "${LIB_DIR}/vulkanlib/vulkan-1.lib")
set(GLAD_INCLUDE_DIR "${LIB_DIR}/glad/include/glad")
set(STB_INCLUDE_DIR "${LIB_DIR}/stb")
set(GLEW_INCLUDE_DIR "${LIB_DIR}/glew-2.1.0/include/GL")
set(GLTEXT_INCLUDE_DIR "${LIB_DIR}/gltext")
set(GLEW_LIBRARY "${LIB_DIR}/glew-2.1.0/lib/Release/x64/glew32.lib")

# Common compilation options
set(common_compile_options
   -std=c++14 
   -Wall 
   -fms-compatibility-version=19.10 
   -Wmicrosoft 
   -Wno-invalid-token-paste 
   -Wno-unknown-pragmas 
   -Wno-unused-value 
   -fsyntax-only 
   "\\\"-D_MT\\\"" 
   "\\\"-D_DLL\\\"" 
   "\\\"-DWIN32\\\"" 
   "\\\"-D_WINDOWS\\\"" 
   "\\\"-DCMAKE_INTDIR=/\\\"Debug/\\\"\\\"" 
   "\\\"-D_DEBUG_FUNCTIONAL_MACHINERY\\\""   
   -isystem "\\\"C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.39.33519/include\\\""
   -isystem "\\\"C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.39.33519/atlmfc/include\\\""
   -isystem "\\\"C:/Program Files (x86)/Windows Kits/10/Include/10.0.22621.0/ucrt\\\""
   -isystem "\\\"C:/Program Files (x86)/Windows Kits/10/Include/10.0.22621.0/um\\\""
   -isystem "\\\"C:/Program Files (x86)/Windows Kits/10/Include/10.0.22621.0/shared\\\""
   -isystem "\\\"C:/Program Files (x86)/Windows Kits/10/Include/10.0.22621.0/winrt\\\""
   -isystem "\\\"C:/Program Files (x86)/Windows Kits/10/Include/10.0.22621.0/cppwinrt\\\""
   -I\\\"${LIB_DIR}/freetype-2.8.1/include\\\"
   -I\\\"${LIB_DIR}/glfw-3.4/include\\\"
   -I\\\"${LIB_DIR}/Vulkan-Headers-main/include/vulkan\\\"
   -I\\\"${LIB_DIR}/Vulkan-Headers-main/include/vk_video\\\"
   -I\\\"${LIB_DIR}/glad/include/glad\\\"
   -I\\\"${LIB_DIR}/noise\\\"
   -I\\\"${LIB_DIR}/stb\\\"
   -I\\\"${LIB_DIR}/glew-2.1.0/include/GL\\\"
   -I\\\"${LIB_DIR}/gltext\\\"\"
   ignore\"
)

# Add executable
add_executable(${PROJECT_NAME} ${SOURCES})

# Target include directories
target_include_directories(${PROJECT_NAME} PUBLIC ${GLFW_INCLUDE_DIR} ${FREETYPE_INCLUDE_DIR} ${VULKAN_INCLUDE_DIRS} ${GLAD_INCLUDE_DIR} ${NOISE_INCLUDE_DIR} ${STB_INCLUDE_DIR} ${GLEW_INCLUDE_DIR} ${GLTEXT_INCLUDE_DIR})

# Link libraries
target_link_libraries(${PROJECT_NAME} ${FREETYPE_LIBRARY} ${GLFW_LIBRARY} ${OPENGL_LIBRARY} ${VULKAN_LIBRARY} ${GLEW_LIBRARY})

# Copy glew32.dll after build
add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    "${LIB_DIR}/glew-2.1.0/lib/Release/x64/glew32.dll"
    $<TARGET_FILE_DIR:${PROJECT_NAME}>
)

# Convert the list to a string with spaces between the options
string(REPLACE ";" " " common_compile_options_string "${common_compile_options}")

# Générer les entrées pour chaque fichier source
set(compile_commands "")
foreach(SOURCE_FILE ${SOURCES})
    # Créer une chaîne JSON pour chaque fichier source
    string(APPEND compile_commands
        "    {\n"
        "        \"directory\": \"${build_directory}\",\n"
        "        \"command\": \"\\\"C:/Program Files/LLVM/bin/clang++.exe\\\" -x c++ \\\"${SOURCE_FILE}\\\""
    )

    # Ajouter les options de compilation communes
    foreach(OPTION ${common_compile_options})
    if(NOT OPTION STREQUAL "ignore\"")
      string(APPEND compile_commands " ${OPTION}") 
    endif()
  endforeach()

    # Ajouter le reste de la commande et les métadonnées JSON
    string(APPEND compile_commands
        ",\n"
        "        \"file\": \"${SOURCE_FILE}\"\n"
        "    },\n"
    )
endforeach()

# Éliminer la virgule finale
string(REGEX REPLACE ",\n$" "" compile_commands "${compile_commands}")

# Ajouter les crochets pour former une liste JSON
set(compile_commands "[\n${compile_commands}\n]")

# Écrire les entrées dans un fichier JSON
file(WRITE ${build_directory}/compile_commands.json "${compile_commands}")

# Ajoutez la cible personnalisée pour générer compile_commands.json
add_custom_target(generate_compile_commands
    DEPENDS ${build_directory}/compile_commands.json
    COMMENT "Generating compile_commands.json"
)

# Déclarez une dépendance pour s'assurer que cela se produit avant la compilation
add_dependencies(${PROJECT_NAME} generate_compile_commands)